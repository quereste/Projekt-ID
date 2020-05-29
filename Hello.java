import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableModel;
import java.awt.*;
import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;
import java.sql.*;

@SuppressWarnings("serial")
public class Hello extends JFrame {
    public Hello(String name) {
        super(name);
        try {
            Class.forName("org.postgresql.Driver");
            connection= DriverManager.getConnection
                    // ("jdbc:postgresql://db.tcs.uj.edu.pl/z11...", "z11...", "haslo");
                            ("jdbc:postgresql://db.tcs.uj.edu.pl/z1165952", "z1165952", "xHJaKo9E9ddu");
            statement = connection.createStatement();
        }
        catch(SQLException | ClassNotFoundException err){System.out.println("ERROR");}
    }

    private JButton buttonOne;
    private JButton buttonTwo;
    private JButton buttonTrzy;
    private JLabel lab;
    static private JTextArea textArea;
    static private JTextField text;
    static Connection connection;
    static Statement statement;
    static ResultSet resultSet;
    static ResultSet result;
    DefaultTableModel tableModel;
    JScrollPane scroll;
    JTable jTable;
    JComboBox<String> tabele;

    /**
     * @param args
     */
    public static void main(String[] args){
        javax.swing.SwingUtilities.invokeLater(new Hello("GUI Baza danych")::createAndShowGUI);
    }

    //zamienia result set na tabele
    DefaultTableModel createResultTable(ResultSet row) throws SQLException {
        ResultSetMetaData meta= row.getMetaData();
        tableModel= new DefaultTableModel();
        String cols[]=new String[meta.getColumnCount()];
        for(int i=0;i< cols.length;++i) { cols[i]= meta.getColumnLabel(i+1); }
        tableModel.setColumnIdentifiers(cols);
        while(row.next()) {
            Object data[]= new Object[cols.length];
            for(int i=0;i< data.length;++i) { data[i]=row.getObject(i+1);}
            tableModel.addRow(data);
        }
        return tableModel;
    }

    //wyswietla tabele
    void wypisz() throws SQLException {
        tableModel=createResultTable(resultSet);
        jTable=new JTable(tableModel);
        scroll.setViewportView(jTable);
    }

    private void createAndShowGUI() {
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        //rozmiar pierwszego okna
        setSize(600, 600);
        setResizable(true);
        setLayout(new FlowLayout());
        //wyswietla okno na srodku
        setLocationRelativeTo(null);

        buttonOne = new JButton("Wypisz");
        buttonOne.addActionListener(e -> {System.out.println(text.getText());});
        buttonTwo = new JButton("Wyœwietl tabelê");
        //wykonuje zapytanie, a nastepnie je wyswietla
        buttonTwo.addActionListener(e -> {
                    String str;
                    str=text.getText();
                    str=(String) tabele.getSelectedItem();
                    try {
                        resultSet=statement.executeQuery("select * from "+str);
                        wypisz();
                     //   resultSet = statement.executeQuery("select m.nazwa, model,silnik,nowy,kolor,w.nazwa,n.nazwa,rok_produkcji as \"rok\",cena,t.nazwa,skrzynia_biegow from samochody left outer join modele using(id_model) left outer join marki m using(id_marka) left outer join wyposazenie w using(id_wyposazenie) left outer join rodzaj_napedu n using(id_naped) left outer join typ t using(id_typ);");
                    } catch (SQLException ex) {
                        JOptionPane.showMessageDialog(null, "ERROR: Nie istnieje tabela o podanej nazwie: "+str,"",JOptionPane.ERROR_MESSAGE);
                    //    ex.printStackTrace();
                    }
                }
        );

        //zamyka polaczenie z baza i konczy program
        buttonTrzy=new JButton("Zakoñcz");
        buttonTrzy.addActionListener(e -> {
            try {
                connection.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            System.exit(0);
        });

        lab = new JLabel("Wpisz albo wybierz nazwê tabeli któr¹ chcesz zobaczyæ: ");
        JLabel lab2=new JLabel("Na skróty: ");
        JButton button4 = new JButton("Dostêpne samochody");
        //wykonuje zapytanie, a nastepnie je wyswietla
        button4.addActionListener(e -> {
                    try {
                        resultSet = statement.executeQuery("select m.nazwa, model,silnik,nowy,kolor,w.nazwa,n.nazwa,rok_produkcji as \"rok\",cena,t.nazwa,skrzynia_biegow from samochody left outer join modele using(id_model) left outer join marki m using(id_marka) left outer join wyposazenie w using(id_wyposazenie) left outer join rodzaj_napedu n using(id_naped) left outer join typ t using(id_typ);");
                        wypisz();
                    } catch (SQLException ex) {
                        ex.printStackTrace();
                    }
                }
        );

        textArea = new JTextArea(30,40);
        textArea.setEditable(false);
        textArea.setSize(600,200);

        //interaktywne pole sluzace do wpisania nazwy tabeli ktora chccemy wypisac
        text=new JTextField();
        //ustawia wymiar tego pola
        text.setPreferredSize(new Dimension(300,30));
      //  text.setBounds(140, 70, 200,30);
        text.setVisible(true);

        jTable=new JTable(new DefaultTableModel());
        scroll=new JScrollPane(jTable,JScrollPane.VERTICAL_SCROLLBAR_ALWAYS, JScrollPane.HORIZONTAL_SCROLLBAR_ALWAYS);
        scroll.setSize(new Dimension(this.getWidth()-20,10));
        scroll.setPreferredSize(new Dimension(this.getWidth()-20, scroll.getPreferredSize().height));
        scroll.setVisible(true);

        String[] tabeleTab = {"doradcy","klienci_salonu", "kierownicy","salon","historia_transakcji","samochody", "modele",
                "marki","wyposazenie","modele_kraje","kraje","modele_wyposazenie","modele_naped","rodzaj_napedu","modele_typ","typ"};
        tabele = new JComboBox<>(tabeleTab);

    //    add(buttonOne);
     //   add(buttonTwo);
        add(buttonTrzy);

        add(lab);
        add(text);
        add(tabele);
        add(buttonTwo);
        add(scroll);
        add(lab2);
        add(button4);
        setVisible(true);

        //jak okno zmienia rozmiar to takze tebela zmienia rozmiar
        addComponentListener(new ComponentAdapter() {
            public void componentResized(ComponentEvent componentEvent) {
                scroll.setSize(new Dimension(getWidth()-20, 10));
                scroll.setPreferredSize(new Dimension(getWidth()-20, scroll.getPreferredSize().height));
                //odswieza widok (zmiania szeroksc tabeli)
                revalidate();
            }
        });
    }
}

