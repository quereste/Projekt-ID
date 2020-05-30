import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableModel;
import java.awt.*;
import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import javax.swing.event.*;
import java.sql.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.event.TableModelEvent;
import javax.swing.event.TableModelListener;
import java.text.SimpleDateFormat;  
import java.text.DateFormat;  
import java.text.ParseException;

@SuppressWarnings("serial")
public class Hello extends JFrame {
    public Hello(String name) {
        super(name);
        try {
            Class.forName("org.postgresql.Driver");
            connection= DriverManager.getConnection
                    // ("jdbc:postgresql://db.tcs.uj.edu.pl/z11...", "z11...", "haslo");
                            ("jdbc:postgresql://db.tcs.uj.edu.pl/z1165952", "z1165952", "xHJaKo9E9ddu");
            statement = connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
        }
        catch(SQLException | ClassNotFoundException err){System.out.println("ERROR");}
    }

    private JButton buttonOne;
    private JButton buttonTwo;
    private JButton buttonTrzy;
    private JLabel lab;
    static private JTextArea textArea;
    static private JTextField text;
    static private JTextField text1;
    static Connection connection;
    static Statement statement;
    static ResultSet resultSet;
    static ResultSet result;
    DefaultTableModel tableModel;
    JScrollPane scroll;
    JTable jTable;
    JComboBox<String> tabele;
	String str;

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
		
		tableModel.addTableModelListener(new TableModelListener() {
            public void tableChanged(TableModelEvent e) {
				System.out.println(tableModel.getValueAt(e.getFirstRow(),e.getColumn()));
				try{
					//e.getRow i podobne numeruja od zera, ale pozostali numeruja od 1
					resultSet.absolute(e.getFirstRow()+1);
					ResultSetMetaData meta= resultSet.getMetaData();
					int typ=meta.getColumnType(e.getColumn()+1);
					//integer||numeric
					if(typ==4){
						int zamiana=Integer.parseInt((String) tableModel.getValueAt(e.getFirstRow(),e.getColumn()));
						resultSet.updateInt(e.getColumn()+1,zamiana);
						resultSet.updateRow();					
					}
					//numeric, czyli moga wystapic po kropce cyfry
					else{if(typ==2){
						float zamiana=Float.parseFloat((String) tableModel.getValueAt(e.getFirstRow(),e.getColumn()));
						resultSet.updateFloat(e.getColumn()+1,zamiana);
						resultSet.updateRow();
						}
					//varchar||char
					else{if(typ==12||typ==1){
					//	String zamiana=(String) tableModel.getValueAt(e.getFirstRow(),e.getColumn());
						resultSet.updateString(e.getColumn()+1,(String) tableModel.getValueAt(e.getFirstRow(),e.getColumn()));
						resultSet.updateRow();
						}
					else{if(typ==92){
							//String zamiana=(String) tableModel.getValueAt(e.getFirstRow(),e.getColumn());
							DateFormat formatter = new SimpleDateFormat("HH:mm:ss");
							java.sql.Time zamiana= new java.sql.Time(formatter.parse((String) tableModel.getValueAt(e.getFirstRow(),e.getColumn())).getTime());
							resultSet.updateTime(e.getColumn()+1,zamiana);
							resultSet.updateRow();
							}		
						}
					}	
					}
				}catch(SQLException ex){ex.printStackTrace();}
				catch(NumberFormatException exc){exc.printStackTrace();}
				catch(ParseException exce){exce.printStackTrace();}
		   }
        });
		
        scroll.setViewportView(jTable);
    }

    private void createAndShowGUI() {
      //  setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    //    setDefaultCloseOperation(0);
        //rozmiar pierwszego okna
        setSize(600, 600);
        setResizable(true);
        setLayout(new FlowLayout());
        //wyswietla okno na srodku
        setLocationRelativeTo(null);

        buttonOne = new JButton("Wypisz");
        buttonOne.addActionListener(e -> {System.out.println(text.getText());});
        buttonTwo = new JButton("Wy�wietl tabel�");
        //wykonuje zapytanie, a nastepnie je wyswietla
        buttonTwo.addActionListener(e -> {
                    str="";
                    str=text.getText();
                    //jezeli nic nie jest wpisane wtedy pobieramy nazwe z okienka wyboru
                    if(str.equals("")){str=(String) tabele.getSelectedItem();}
                    try {
                        resultSet=statement.executeQuery("select * from "+str+" order by 1");
                        wypisz();
                     //   resultSet = statement.executeQuery("select m.nazwa, model,silnik,nowy,kolor,w.nazwa,n.nazwa,rok_produkcji as \"rok\",cena,t.nazwa,skrzynia_biegow from samochody left outer join modele using(id_model) left outer join marki m using(id_marka) left outer join wyposazenie w using(id_wyposazenie) left outer join rodzaj_napedu n using(id_naped) left outer join typ t using(id_typ);");
                    } catch (SQLException ex) {
                        JOptionPane.showMessageDialog(null, "ERROR: Nie istnieje tabela o podanej nazwie: "+str,"",JOptionPane.ERROR_MESSAGE);
                    //    ex.printStackTrace();
                    }
                }
        );

        //zamyka polaczenie z baza i konczy program
        buttonTrzy=new JButton("Zako�cz");
        buttonTrzy.addActionListener(e -> {
            try {
                connection.close();
                statement.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            System.exit(0);
        });

        lab = new JLabel("Wpisz albo wybierz nazw� tabeli kt�r� chcesz zobaczy�: ");
        JLabel lab2=new JLabel("Na skr�ty: ");
        JButton button4 = new JButton("Dost�pne samochody");
        //wykonuje zapytanie, a nastepnie je wyswietla
        button4.addActionListener(e -> {
                try {
                    resultSet = statement.executeQuery("select m.nazwa, model,silnik,nowy,kolor,w.nazwa,n.nazwa,rok_produkcji as \"rok\",cena,t.nazwa,skrzynia_biegow from samochody left outer join modele using(id_model) left outer join marki m using(id_marka) left outer join wyposazenie w using(id_wyposazenie) left outer join rodzaj_napedu n using(id_naped) left outer join typ t using(id_typ);");
                    wypisz();
                } catch (SQLException ex){ 
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

		JLabel lab3= new JLabel("Wpisz polecenie: ");

		text1=new JTextField();
        //ustawia wymiar tego pola
        text1.setPreferredSize(new Dimension(this.getWidth()-50,30));
      //  text.setBounds(140, 70, 200,30);
        text1.setVisible(true);
		
		
		//usuwanie wyswietla blad bo wykonuje sie ale nie zwraca wynikow
		JButton button5 = new JButton("Wykonaj");
        //wykonuje zapytanie, a nastepnie wyswietla wynik
        button5.addActionListener(e -> {
				str=text1.getText();
                try {
                    resultSet = statement.executeQuery(str);
                    wypisz();
                } catch (SQLException ex){
					JOptionPane.showMessageDialog(null, "ERROR: B��dne polecenie: "+str,"",JOptionPane.ERROR_MESSAGE);
					ex.printStackTrace();
                }
            }
        );
		
        jTable=new JTable(new DefaultTableModel());
		
        scroll=new JScrollPane(jTable,JScrollPane.VERTICAL_SCROLLBAR_ALWAYS, JScrollPane.HORIZONTAL_SCROLLBAR_ALWAYS);
        scroll.setSize(new Dimension(this.getWidth()-20,this.getHeight()-300));
        scroll.setPreferredSize(new Dimension(this.getWidth()-20, this.getHeight()-300));
        scroll.setVisible(true);

        String[] tabeleTab = {"doradcy","klienci_salonu", "kierownicy","salon","historia_transakcji","samochody", "modele",
                "marki","wyposazenie","modele_kraje","kraje","modele_wyposazenie","modele_naped","rodzaj_napedu","modele_typ","typ"};
        tabele = new JComboBox<>(tabeleTab);

		tabele.addActionListener (new ActionListener () {
			public void actionPerformed(ActionEvent e) {
                    //jezeli nic nie jest wpisane wtedy pobieramy nazwe z okienka wyboru
                    str=(String) tabele.getSelectedItem();
                    try {
                        resultSet=statement.executeQuery("select * from "+str+" order by 1");
                        wypisz();
                     //   resultSet = statement.executeQuery("select m.nazwa, model,silnik,nowy,kolor,w.nazwa,n.nazwa,rok_produkcji as \"rok\",cena,t.nazwa,skrzynia_biegow from samochody left outer join modele using(id_model) left outer join marki m using(id_marka) left outer join wyposazenie w using(id_wyposazenie) left outer join rodzaj_napedu n using(id_naped) left outer join typ t using(id_typ);");
                    } catch (SQLException ex) {
                    //    JOptionPane.showMessageDialog(null, "ERROR: Nie istnieje tabela o podanej nazwie: "+str,"",JOptionPane.ERROR_MESSAGE);
                        ex.printStackTrace();
                    }
			}
		});

    //    add(buttonOne);
     //   add(buttonTwo);
        add(buttonTrzy);
		//wybieranie i wypisywanie tabel
        add(lab);
        add(text);
        add(tabele);
        add(buttonTwo);
        add(scroll);
		//dowolne zapytanie
		add(lab3);
		add(text1);
		add(button5);
		//ciekawe zapytania
        add(lab2);
        add(button4);
        setVisible(true);

        //jak okno zmienia rozmiar to takze tebela zmienia rozmiar
        addComponentListener(new ComponentAdapter() {
            public void componentResized(ComponentEvent componentEvent) {
                scroll.setSize(new Dimension(getWidth()-20, getHeight()-300));
                scroll.setPreferredSize(new Dimension(getWidth()-20, getHeight()-300));
                //odswieza widok (zmiania szeroksc tabeli)
                revalidate();
            }
        });

        addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent we) {
                try {
                    connection.close();
                    statement.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
                System.exit(0);
            }
        });
    }
}

