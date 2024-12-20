PGDMP  :    6                |         
   transporte    16.3    16.3 :    K           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            L           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            M           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            N           1262    24576 
   transporte    DATABASE     }   CREATE DATABASE transporte WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_World.1252';
    DROP DATABASE transporte;
                postgres    false                        3079    24669    dblink 	   EXTENSION     :   CREATE EXTENSION IF NOT EXISTS dblink WITH SCHEMA public;
    DROP EXTENSION dblink;
                   false            O           0    0    EXTENSION dblink    COMMENT     _   COMMENT ON EXTENSION dblink IS 'connect to other PostgreSQL databases from within a database';
                        false    2            �            1255    24663    impl()    FUNCTION     �  CREATE FUNCTION public.impl() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE 
	rec record;
contador integer := 0;
 BEGIN
   FOR rec in  select * from pasajero loop
	  
-- RAISE NOTICE 'Nombre de pasajero %', rec.nombre;
   contador := contador +1;
end loop;

--RAISE NOTICE 'Conteo registros %', contador;

INSERT INTO cont_pasajeros(total, tiempo )
	values (contador, now());
return old;
END
$$;
    DROP FUNCTION public.impl();
       public          postgres    false            �            1259    24587    estacion    TABLE     �   CREATE TABLE public.estacion (
    id integer NOT NULL,
    nombre character varying(1200),
    direccion character varying(1200)
);
    DROP TABLE public.estacion;
       public         heap    postgres    false            P           0    0    TABLE estacion    ACL     I   GRANT SELECT,INSERT,UPDATE ON TABLE public.estacion TO usuario_consulta;
          public          postgres    false    219            �            1259    24586    Estcion_id_seq    SEQUENCE     �   CREATE SEQUENCE public."Estcion_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public."Estcion_id_seq";
       public          postgres    false    219            Q           0    0    Estcion_id_seq    SEQUENCE OWNED BY     D   ALTER SEQUENCE public."Estcion_id_seq" OWNED BY public.estacion.id;
          public          postgres    false    218            �            1259    24594    TREN    TABLE     x   CREATE TABLE public."TREN" (
    "ID" integer NOT NULL,
    "MODELO" character varying(100),
    "CAPACIDAD" integer
);
    DROP TABLE public."TREN";
       public         heap    postgres    false            R           0    0    TABLE "TREN"    ACL     G   GRANT SELECT,INSERT,UPDATE ON TABLE public."TREN" TO usuario_consulta;
          public          postgres    false    221            �            1259    24593    TREN_ID_seq    SEQUENCE     �   CREATE SEQUENCE public."TREN_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public."TREN_ID_seq";
       public          postgres    false    221            S           0    0    TREN_ID_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public."TREN_ID_seq" OWNED BY public."TREN"."ID";
          public          postgres    false    220            �            1259    24601    Trayecto    TABLE     �   CREATE TABLE public."Trayecto" (
    "ID " integer NOT NULL,
    id_estacion integer,
    "Id_tren" integer,
    "Nombre" character varying(100)
);
    DROP TABLE public."Trayecto";
       public         heap    postgres    false            T           0    0    TABLE "Trayecto"    ACL     K   GRANT SELECT,INSERT,UPDATE ON TABLE public."Trayecto" TO usuario_consulta;
          public          postgres    false    223            �            1259    24600    Trayecto_ID _seq    SEQUENCE     �   CREATE SEQUENCE public."Trayecto_ID _seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public."Trayecto_ID _seq";
       public          postgres    false    223            U           0    0    Trayecto_ID _seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public."Trayecto_ID _seq" OWNED BY public."Trayecto"."ID ";
          public          postgres    false    222            �            1259    24608    VIAJE    TABLE     �   CREATE TABLE public."VIAJE" (
    "ID" integer NOT NULL,
    "ID_PASAJERO" integer,
    "ID_TRAYECTO" integer,
    "Inicio" time without time zone[],
    fin time without time zone,
    fecha date
);
    DROP TABLE public."VIAJE";
       public         heap    postgres    false            V           0    0    TABLE "VIAJE"    ACL     H   GRANT SELECT,INSERT,UPDATE ON TABLE public."VIAJE" TO usuario_consulta;
          public          postgres    false    225            �            1259    24607    VIAJE_ID_seq    SEQUENCE     �   CREATE SEQUENCE public."VIAJE_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public."VIAJE_ID_seq";
       public          postgres    false    225            W           0    0    VIAJE_ID_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public."VIAJE_ID_seq" OWNED BY public."VIAJE"."ID";
          public          postgres    false    224            �            1259    24655    cont_pasajeros    TABLE     s   CREATE TABLE public.cont_pasajeros (
    total integer,
    tiempo time with time zone,
    id integer NOT NULL
);
 "   DROP TABLE public.cont_pasajeros;
       public         heap    postgres    false            �            1259    24654    cont_pasajeros_id_seq    SEQUENCE     �   CREATE SEQUENCE public.cont_pasajeros_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.cont_pasajeros_id_seq;
       public          postgres    false    227            X           0    0    cont_pasajeros_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.cont_pasajeros_id_seq OWNED BY public.cont_pasajeros.id;
          public          postgres    false    226            �            1259    24578    pasajero    TABLE     �   CREATE TABLE public.pasajero (
    id integer NOT NULL,
    nombre character varying(100),
    direccion_recidencia character varying,
    fecha_nacimiento date
);
    DROP TABLE public.pasajero;
       public         heap    postgres    false            Y           0    0    TABLE pasajero    ACL     I   GRANT SELECT,INSERT,UPDATE ON TABLE public.pasajero TO usuario_consulta;
          public          postgres    false    217            �            1259    24577    pasajero_ID_seq    SEQUENCE     �   CREATE SEQUENCE public."pasajero_ID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public."pasajero_ID_seq";
       public          postgres    false    217            Z           0    0    pasajero_ID_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public."pasajero_ID_seq" OWNED BY public.pasajero.id;
          public          postgres    false    216            �           2604    24597    TREN ID    DEFAULT     h   ALTER TABLE ONLY public."TREN" ALTER COLUMN "ID" SET DEFAULT nextval('public."TREN_ID_seq"'::regclass);
 :   ALTER TABLE public."TREN" ALTER COLUMN "ID" DROP DEFAULT;
       public          postgres    false    220    221    221            �           2604    24604    Trayecto ID     DEFAULT     r   ALTER TABLE ONLY public."Trayecto" ALTER COLUMN "ID " SET DEFAULT nextval('public."Trayecto_ID _seq"'::regclass);
 ?   ALTER TABLE public."Trayecto" ALTER COLUMN "ID " DROP DEFAULT;
       public          postgres    false    222    223    223            �           2604    24611    VIAJE ID    DEFAULT     j   ALTER TABLE ONLY public."VIAJE" ALTER COLUMN "ID" SET DEFAULT nextval('public."VIAJE_ID_seq"'::regclass);
 ;   ALTER TABLE public."VIAJE" ALTER COLUMN "ID" DROP DEFAULT;
       public          postgres    false    225    224    225            �           2604    24658    cont_pasajeros id    DEFAULT     v   ALTER TABLE ONLY public.cont_pasajeros ALTER COLUMN id SET DEFAULT nextval('public.cont_pasajeros_id_seq'::regclass);
 @   ALTER TABLE public.cont_pasajeros ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    227    226    227            �           2604    24590    estacion id    DEFAULT     k   ALTER TABLE ONLY public.estacion ALTER COLUMN id SET DEFAULT nextval('public."Estcion_id_seq"'::regclass);
 :   ALTER TABLE public.estacion ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    219    218    219            �           2604    24581    pasajero id    DEFAULT     l   ALTER TABLE ONLY public.pasajero ALTER COLUMN id SET DEFAULT nextval('public."pasajero_ID_seq"'::regclass);
 :   ALTER TABLE public.pasajero ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    216    217    217            B          0    24594    TREN 
   TABLE DATA           =   COPY public."TREN" ("ID", "MODELO", "CAPACIDAD") FROM stdin;
    public          postgres    false    221   !>       D          0    24601    Trayecto 
   TABLE DATA           M   COPY public."Trayecto" ("ID ", id_estacion, "Id_tren", "Nombre") FROM stdin;
    public          postgres    false    223   M>       F          0    24608    VIAJE 
   TABLE DATA           [   COPY public."VIAJE" ("ID", "ID_PASAJERO", "ID_TRAYECTO", "Inicio", fin, fecha) FROM stdin;
    public          postgres    false    225   j>       H          0    24655    cont_pasajeros 
   TABLE DATA           ;   COPY public.cont_pasajeros (total, tiempo, id) FROM stdin;
    public          postgres    false    227   �>       @          0    24587    estacion 
   TABLE DATA           9   COPY public.estacion (id, nombre, direccion) FROM stdin;
    public          postgres    false    219   �>       >          0    24578    pasajero 
   TABLE DATA           V   COPY public.pasajero (id, nombre, direccion_recidencia, fecha_nacimiento) FROM stdin;
    public          postgres    false    217   (B       [           0    0    Estcion_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public."Estcion_id_seq"', 51, true);
          public          postgres    false    218            \           0    0    TREN_ID_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public."TREN_ID_seq"', 2, true);
          public          postgres    false    220            ]           0    0    Trayecto_ID _seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public."Trayecto_ID _seq"', 1, false);
          public          postgres    false    222            ^           0    0    VIAJE_ID_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public."VIAJE_ID_seq"', 1, false);
          public          postgres    false    224            _           0    0    cont_pasajeros_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.cont_pasajeros_id_seq', 9, true);
          public          postgres    false    226            `           0    0    pasajero_ID_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public."pasajero_ID_seq"', 1005, true);
          public          postgres    false    216            �           2606    24592    estacion estacion_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.estacion
    ADD CONSTRAINT estacion_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.estacion DROP CONSTRAINT estacion_pkey;
       public            postgres    false    219            �           2606    24585    pasajero pasajero_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.pasajero
    ADD CONSTRAINT pasajero_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.pasajero DROP CONSTRAINT pasajero_pkey;
       public            postgres    false    217            �           2606    24606    Trayecto trayecto_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public."Trayecto"
    ADD CONSTRAINT trayecto_pkey PRIMARY KEY ("ID ");
 B   ALTER TABLE ONLY public."Trayecto" DROP CONSTRAINT trayecto_pkey;
       public            postgres    false    223            �           2606    24599    TREN tren_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public."TREN"
    ADD CONSTRAINT tren_pkey PRIMARY KEY ("ID");
 :   ALTER TABLE ONLY public."TREN" DROP CONSTRAINT tren_pkey;
       public            postgres    false    221            �           2606    24615    VIAJE viaje_pkeyt 
   CONSTRAINT     S   ALTER TABLE ONLY public."VIAJE"
    ADD CONSTRAINT viaje_pkeyt PRIMARY KEY ("ID");
 =   ALTER TABLE ONLY public."VIAJE" DROP CONSTRAINT viaje_pkeyt;
       public            postgres    false    225            �           2620    24664    pasajero mitrigger    TRIGGER     f   CREATE TRIGGER mitrigger AFTER INSERT ON public.pasajero FOR EACH ROW EXECUTE FUNCTION public.impl();
 +   DROP TRIGGER mitrigger ON public.pasajero;
       public          postgres    false    217    229            �           2606    24626    VIAJE VIAJE_ID_PASAJERO_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VIAJE"
    ADD CONSTRAINT "VIAJE_ID_PASAJERO_fkey" FOREIGN KEY ("ID_PASAJERO") REFERENCES public.pasajero(id) NOT VALID;
 J   ALTER TABLE ONLY public."VIAJE" DROP CONSTRAINT "VIAJE_ID_PASAJERO_fkey";
       public          postgres    false    225    4768    217            �           2606    24631    VIAJE VIAJE_ID_TRAYECTO_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VIAJE"
    ADD CONSTRAINT "VIAJE_ID_TRAYECTO_fkey" FOREIGN KEY ("ID_TRAYECTO") REFERENCES public."Trayecto"("ID ") NOT VALID;
 J   ALTER TABLE ONLY public."VIAJE" DROP CONSTRAINT "VIAJE_ID_TRAYECTO_fkey";
       public          postgres    false    4774    225    223            �           2606    24616 !   Trayecto trayecto_idEstacion_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."Trayecto"
    ADD CONSTRAINT "trayecto_idEstacion_fkey" FOREIGN KEY (id_estacion) REFERENCES public.estacion(id) NOT VALID;
 O   ALTER TABLE ONLY public."Trayecto" DROP CONSTRAINT "trayecto_idEstacion_fkey";
       public          postgres    false    4770    223    219            �           2606    24621    Trayecto trayecto_id_tren_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."Trayecto"
    ADD CONSTRAINT trayecto_id_tren_fkey FOREIGN KEY ("Id_tren") REFERENCES public."TREN"("ID") NOT VALID;
 J   ALTER TABLE ONLY public."Trayecto" DROP CONSTRAINT trayecto_id_tren_fkey;
       public          postgres    false    223    221    4772            B      x�3��M-JNMI-�445������ 9��      D      x������ � �      F      x������ � �      H   B   x����0�wإ�Ơ&����H���pDt�1T�� G\��t��W���`�.WY���mw��      @   ?  x�}U�r7<���b�}))�-�-*�K.�%̅�(�
�A��!_��PN��R��Vaf����Y��5�#�ڸ	���Z^N��Y�z˗;l;��a;$��o�{Bd
n��g�Gߛ豷��R�����i�C�K'/e0�h������8$,~����ʢ`9|^���|�P����:���P	!�]��7�*�D��P9��\%���o1�{{��B�	��3}g�Hu�2ń�/�H��s'�Ȳ,�P0-����"gB�%UZ�n~P���r��CS�M�]gƷ�y^eL�pg����g�
[��il�>�ɸ�u�q�ʷe��&Q�g��0�T�>��E��"$��ήl����7O{�`u6��窘0Q�r�����?����dr��[���D~c�� _��B1)`aHg>O��vs2YŤ�[ta�Ј��
��{�3���lG�В.�4/~m��.}����43!����5��q�Y!�%��,D3�<c2�K*����":
2%ܷ|(K8Gg��1��Ɋl	;�#�T�15�+� 7�BIAː����Ą`J�����5ܝX$+��)ש~��Y<DXUK�$gF
]TL�p�X��*�*�����A�侑�>��[�
Hx��_ޑ]���E)*�'�u�����H���~�,�0O�����h��+��!��N�D��d�� j��7	_m�^d�3M�����)^�:����uz={�䄶q�h�"�Hb��K���;�����"~%[܏M��%̟��y��*���Wo5�M��6���X&�F�~K��Of�l4�p�����1�̣$�      >      x�]�Iw�H-��~�w��;$��|+M�lI�ZR����6I2EfD�1HE��wo� �7]}a��nD�Γ���u��I��o����tz�2����'�*��_��Y����I�pT;����t�u�}��g��Ymm��K���试_g�Y�<��1�h�j���_g���,OnUwH.԰W�0�y�|~V�I{ݘA%j��̎�+\�C��J5�3}�M�ͮ���}�����+?t+7nu�[y���|��=��o��kݙ�N���?hV��gX�Z�x�}sw�ҳ�<�K���սnծ�Ǧ؜�y�t�����1)��_SܸH.:���M�U?�2f�?ϒ�-V����z��]p!)�'�f�?�kV+�;� �Y$�v���t�ƾ�ο.fg�2��������z���,�α�*�n�Q%��_S~M�y�\�{�$v�䅌;��Lg�����`Tr�\k�����t��2vH^5��n�/c�Y�&�ֿ��ݩ��/��g�"y��L�Q�ѭ��4KnǮ��^��:�Wqi����K��n�������a{�E�nG�G�����g)vG�V81/�䳴Jn��68G<v\k/���9��N^�5*�W���(�}O�K�e_I�<��&����l1����#NE�5�O��P�޴*�aڵZ�pM�[,���]��c�ں��5(�d[lE;��&�� i�z��/�X5�s�Cа��n�j�Oڂ�.���X���^�������^[��oZ�A�3y7�L�)()���zy��P�E��a? iwf�w��lF�mai�\aGZ��q'���\�v��ื�z:ܜ&��v}�z$Y��o�g�"������z:��<�2��v��}c�u�
ء,OlGC�j����bE�ϊ�	��ם�m�|
��ɋ��y�C��Eu�U�y���q6�A�]s�`VCC������/���,�A����mWc���+� �'q�����_�3�i�5-��F�)M)��g�"�n7Oi����]�q�X�=� ?���l�V���xq��q�-D֬߹��Û,Z�!$�Og�y���ۤ;�{���ho�RYoE�-���n��QL(
gy��c��=ĥB��q�q=A߭�c��[�sl�0@���|m���fp�ϊv�f��9m,�X�a56y6��v'R��,�a!���n��R��R�9���G��,;kw���V:��i��{H������%����n6Q�f4 �Z.,�n�붪��lܟ�r{�ܩ%��S�����3�);�;��)�/^v�g�Sz�r��q���j��bo�_�o(i��!���Tb�)��%̸i�k����2��Ͱ�K���ۙv䷥��+s�U���-�[���0����,�{���f���߸.���'\A�aBU�zx2>�
~���}a-ܫ�"�e��v�7�Y��&1��na�(j��N��j�ò�����V�ɍi�}�-,Xrot?��<�`�T�6��y���}�AQ�{���3݇W�t��/�����:��Z�I 6���MRMO|V��p���T�?Lp
W+'|m������y�U�o���<��bS�p��k�2��� 0�Zs������79������Fu��&z��'W/������(��a�,9ﷴ��p�f]0E��(�5>�m�T�b�⳺�2�-v	_��C�Pe.{�Vj��ϱ�RsQW�ж@؆�H6*�Q]��;px��a9:�,�x>�%?-�si?�D�.͉���s�p����2�|�
r�-l?u��EQ#��-Ę�}��Yu��ن�?���au�=�i�	�5`)�.����x��v�pV$�8�5VHie��d���g%�
6�R�}D�)a4pf\Q�M�x�� �,nje��e& �
�:ȭ�)gձZ�pBŞ�~z@�����y��i���h@qe���[��S�cT��7�PD"��vf�:��f@W��C��x~w�þ7�q�=J@來�:�(A���e�҇c����U���A��?�:��Y���0ڀ�!����?�=dgO8Q �o��d�/�����` �'�.~�n@����_,���;K9��G;a*���V������*�<��|\����D��ȿ5<��z즉ț�P�M�O`���ݵ�6.��ضz��Қh�{��&qq���^'�`��iw�&������Nw��@@���׳�yS!�q�>"��[��g�?�>K����񤻕y�q����@��r����]�����h�XcH�<����9��-O��/+�����a�h�w�����"��X�Z#`;N��L��D��S��|<�L��O��kw�Gy�w��>�&�{	w�E:w�Gl-�tt��>Y������VЗi���oǞe��b���.����Bbe�tZ� ���:X=R��{�3�7V�@�K\9v�ҭ��΅���!ʅ��u1��sz������F�������"�wY��;�
[�\oZ��2���ѝ\E���_�� E|��}T�/p��P ~�\̓���rh� =���0���j?GD
��4��*�s���%��u\5���$U �n�����޶���t�!@2s@�������O�_�39n����d����>l7l's�;S&J
�(�Nq����������ơ�u�
Y���?���NF<D���/��k�İi�:��'�+A�ܱi���%b�F��/�Z1�GWK� - �����m� ���co��D��\�;Q#v��y63Ō����HhvIx���<) ��X�%����n��] ����Q���%#�%����X�G�^x��+&��xK�P�\*#bs_�Grx��N��w1a�`GӱS3�
���Y�w�¢�m����:���>c���5�c���ߚ!�_��@@���ǹ��НA!�δM�ŀ�#�g�ٝ�|�B�G�4�d������B�owg[ʖ ��5���X�hJp��6�ۮ;�5%̕��@��`ob��xy����T3&������d,��SN���d�$����*·��YML��|�%m��#.�%��G	���R!n�����R!b���������˪3�����rG��_L�ގC�<9l��7�{z�oo��8w(\J6b�W+�_�����׺a:�Q~�"&��o�����{�[2���z�\1߁f���r,
42��>"���=4ti��J]�~�s��K�[����p}�����$4&^j�|M&�F {���E�s�=!N) �^���� ��:�Pr*��9���	_�B��0�L&���h�υrb7t+te�L�\�d!�{}�%1��� �"×�'�.���ʴb��6���qI
TO��f����k)�-�l�c�7~9>3�� ����]���ٸ�l$ �wI�3����.Cr+)s���qÒ�����4��P��-0�"�(��j��k2�|���qK�3�%���;P{��ͦS���� ��2�gE�$��@�/Z ��B��<� �ce�c�h8\r\��)S��L�k��E�r/"f��f>eB�r1�������c�n�DT���1ý`� ��m[���Ǚ9-���?�+3���.���S2�j�i������D�,�wկ�A,d� �������N�c�z ���Ïi�BdcAC��O�vr���3M�Z�lMgB&�r��T�w��_��/Y� ��dhiO��#m��]w��`�f:yl��%j�;�Z�P3��z�=a��[�Fe�? k��ˇax;v}�~���@�����>|`1�����ڈ<B`�~�bv�:��73|�#"&���=OKuc�TmH�fb� �]�z�^ۘ*ԓf	q���� �b	�S`z��-�  �T-����k�{x�~��)?��D��T�/��a���Ʒ��������9�i���씘��������Q��E����0�
j����MB�51�/��+������|���v x:t�B�yj[K�ʼ��v!)M��    ?(Y�e�誰�Mbv�� �����NNYTIפ������6EŸ�/��(�3.�)fw���`����U�i.��^	��qړ�/��`����L/����g�"���%Np
��)P= k"�,qoB�QHy�Iy��җ��'C�fD},$�Պ�]�7���u_jdr�CHv��1hv���EB�pT����}���a{���O�1��R�_J��5�!fb���G����۝�v5�,���S��O���v�7gJ1���XG�E�,��������v��\� �"��ޟ��Zd8��km�����N��4en��+b^�ڻQ1����ߏ�XA�����eE��옕t_���dL�V�ߪ�) �����n�]���b:u	q��7&8�n|P��;M�߭Y���CI�:��Zұ�%�h��ˠ�ݚE�F��N�I5W�.��Ct�|9��(`���!�y8B��	��NZվn�Kn�Iy�j��@��YZV?����XSҵt����H�p R �~�P��}�����givЮt�bg~ ?6��Q|�k�,nӀ��4>
�1��}q�@?�*.�lLB"���W��0X��s������ά� 9\��
�? :�$�c>�o�� ���#?[�f^3*�N�̭��C�ڍKs����;W��p=u� Z�X�=�I�x2B�^��Y��r|��f��+���P����#r.��S�!�i����1'rw�D`da���g�%�9�
���x��)� �OрH?���· ���� �g2G���ؽ��P���R�¿��D���l����J\0*�ʢ+�B'auw;h���ZGzҋ99F��~)3	��ݝ�w�� ��촆5I�9��\��Ȏ�O8$G �{#J3��c��� E, �n*��`�`��(O�Y5LS@� 7b Y���@�F�3gK�g<[ɛ3^'q�e�#"<F�ꖗJzg�F�D)�Kt� �gj� ^��c�e�o��)��n��ҧS�p�-�`���Ն�Dր��a�][ 8��=lcC
�@`�wHǨ����Z ��jI�!\]Y�h*;�2D%A����Τ��t�����E��r9y)@�^��ІZ��9��0��@cۂ^��b@�o��D?b�M���6ǖ����*�R�X*$�jl����f:	,��2毿���3� ��d�NrHv������������㔑�Y8��O��#��	�K2�9�v�eƠE&/Ⱥ��b�����R� )G���f��}\?71 Q���5��d�S�f�ta�Tx�s1}��vd���p���45�%}��0!N,2��`9XXif	� �Ǟ�������j\�i��� ���t�����0�UH/9��sj�+�vwBנd"8'�V��c� B &΀���B���+[ �֩O��Z�c�� R[���'�Ȝ��%-ш �O L�\ ���o���|�]�Bz� ����y#�R}Н8]p��qq�W�wt��BJ�D����$�b}�2W��K�{���#��&1��#z�%�U���?A:��#��á�hx<V�����\#2Pk�\����4�����e��	�����.U7L��G����$��̇Q��yir ��w���п!Lr��=�� ��d����l�\$\��Ia��_�C�|�Y�� 1�]7va�3�����o�3�%���?�2��:�IY�!�uN� ο��g�G��
uu���6 ��T��â$w%��ukN��Ȉ�Y�a�{��2$������_��������y�u��>��@{�L��N��]p��T��vՉ�z2����Y1�#��l6�#�ڧ�=���^V���qz6��I�(��A�+Մt��_Wܓ�/��Y}Ɲ���_���Φ�I9|E� ��]<�i��ho	ZnU۩�����8�Õ���}�Ek�U��[�W\�x�|0=y�ݫ�a:a*!����$����/������QV&�&b�J���v�]|�a��� ��k�n'? �T�4�D��B� �'c'I�P��Eh}��~�
WI^ �3���fcl��cβ��ێ��^*�+2/��L���ր�vr6$|�DƘi�KV�w��S^]�dfͬB&Yd/
$�'k+��Ȁ�;DW�n�b�e@�<���W�V9���?Y17����vVE:��g���>�f+)iu��S� 	�ܦ=��,�fsR�]���NҮ�t{��^������x��X��'{d���,)(�����K������"�j@y����.�SQ(�E��@���ӹ��u�7�v�HYr���#�H��d��p-<�3��rC+��o�q��f����=\7�ߩ��Hcр�7B&|r��Hd���f��[����P!qp$��	�^� ��ly%���0N����9KAJ��w�҄��|v�òBr=����2�r���5�9x�8�b�mYZ������ s\��i�}݅$�T0�s8����X�Xt��)o�Ə��3�|�5x�Y��5� kf��d��kkN��0���Hj#����Gs���Y�ѐ�)�:p� ipۘұֻ�y������j�]r��'u�x����*P�]�c��=<A����N{�YL�B��"��W-2 �k1���	�h!G	��:�[����j� t��m'L[-į>
)�@�d=�P�J�]���/ ��j��34�e�<���,�p��f��9�D����5�r)?�r��X�n"�I�&J���6���u�@P/��V��D�$��ց^'^1�I"i�y�A&Br�9fD�����6N�r� �~#V�(,T�ܳt]��וQ�f�-�U=�N��?(�/�9O}��\\�!N��i�'w~-xɛ-�j�L9��ali�'E���?o����AO��M�<����`{39R��`�Vi���[�:��|F!F	�}ә����D�Cᓮ�.���"�j֕Z6!2�W|'���q9�U0���"����0N��_���z�R�+��0�%�L��̲/�r��p�n�}�ё�$*��6��@.F��X�֧��I���.Ʈ]�3�,���Z��K�A����D�%���J^V�?�m��%7^� ?���Jap�*	������h%i��	zf?B,.�4����%M��wF��!.��c��U�E8.�������j���l�8�C(�� ��*�j".>˪TX�G�{�� ��8��FV$�8e1�� ��e��@o'u�[E�֒��P��{�IX�g���p�_ΗK5KRI�b��~�5�m�	�U�]�㴌��a�|X�oBc���jp9׉����ᾈ��:��p�jiqb��]O�{'���
n?i��v*0P�˟ ��*�Ѕb�I����;6��8@��8���>�" r�jB���"�M�	Wߩ@�5�W��=��Z2)��l)lwM�z	D��u��c��I�F>�yQ Nx�IG��g]��A-��DB�D�,�F�.���$���́�'>'�œ��	[������Uj\��Y��X��t��x�{��R�@
�ݣ��*�Zj����S�|@%��0��Ԟ&�E>��B��}h�uo�s��j��O��$`�����,<��@J���?�Q��qGlw��Rrȁ�I-�ݰǱ.m�994R��!���Q~ζ������������9�SG��0�9�.�W��_z����'�>�$�ϫ@��C2�qF>�%	L�yu��6���U6�!�Ecv�_�yb�A/Ձi�]�L�9e]0�٠P�� 3�޳;�e|Ӹ���	�hq����W����ɫ@<I�w��ʶ5x��Z�r��G��nT~'?��;R��8��~���SVU�V_M��հ=I&P��Ii�U���X,�|� �j%���N��#�/�Iw��jH�Xs���?$xtmZ����g����y���:{|~C���K�c����,.n�3}ZVx�ܵ&sK��E��Aݯß���q���*P�_5�e-���c�G&���    ��L�n������?��"�dٽg�{*A8�a\ �H60L�n�b�7$��]�4��X�{4�i�`����K���Ծ���3�w��0������M�N�'��;<8k4+�}�[�g�7�y2����BK��̆bt&�G.<	��Û�4������Sn:�O>A:s���f�)qk8�O��-Q���DGy�0X`ѕ��6G�㋁`)h��P�ʋJ�S�9 :랮9ۿ�8����U�i��^7�W����ō���Mt~C�Y@�|z�}�&*��	&!�e���(&��P0�����pi�D��_G��!�'�^�#pl����_c�Hr"9�:>��Oo�s6�5�
�:���BTS�2 ������a1�:+8���^)`�>P��-+��K����mb��"���U5�u�1�l��!Q����~�d��o�z�'�����1:@�������!$w���l�z�,�!��&d���N��ٝ��M,H&g*�Sz�g�����
�Jρ֯�B�`3R���B��K��a��!jW�#�I�KN@J096Ꜥxr�����d�\w*N��yE�Ը��]�|9��:��L>Q�� ���{{��Q$		$´*�z�nY�1����W�X�5�p�:0ѝ��?XC�HP�!S����/B�����s��J8ޮ��o�D���s�zI(���ғ�����V0O�߃f�B�~�c9@����i�MA-��ӾS>"��^��+��T�bG^K~a�#���=/�w�X"j�;��_V���~�LEg@k��5�}"w18�j6�qI���'� 5P�ñ�U�B1���쬘I�3�ǎ��w��T ��iwn�cpI���ׇ-��,��T��	
����n�D������j��/�r����q��3r�]ӆ��nJ�aC
 �K�+	�b�XP+�� zY6�h��M=	��U�2��5`�<� (���Ic��x��]m�^��C���Y2��5����x �P�.eB�1�ʭ�2��\�O�M,�8��Y:1�hՆ �t�gl_�r}'��p��ġ�yy����R*�Y�2��5�T Ǯ>�;���b�/h�f�o��[����6�[9�.�ui�O���0�]�=��`���pm�����f����E:�|w��m=	,-%�j����_!�)�Ņ�k��֒�?�q�' ���5�!����Љ;�=�$/�c�{"��"-"����m��d����f�1X�qE��ƊAr��)�YԮQA�jD����}�xL\0�+�I�'���Ώ��7Fj�ߺ�����
 �ﭜ�O�W�Q��z? ��16!<+h�
 ��������(,�Xǎt3�{�?��[( �!x@J����>�Ş,�a@7;)�3�e5�帕P�]�Q3 �7���V�[f�����%�%��{�ᩬJ �;Nn8?�-ji\�P�r37��0�� �1��A��8�E0��r�X�9%q�3�b�nF?~%�g��� �!�U�] ��)/U℄��	M���-�av���td��"�I�ʏ��l$| �g�>���s���Z9�����=��y���ƿ �C�g1���Ey&��9[�?�LQ��r��V���$�} �K���C�h���TE�f����p�f�#���7��*�]*��W �?+��9�����^G��C/�/}Ѹ �?'�Z[v�9�k�DQ�분^aZQ��,�s#U�G�K�
�� ��7�a7����O�"dI��T?���U�(86��Ȝ�M�\8g��VX�#���&� �Ͱ}��e�~�$��#@.l�8��r�3�A`��*/C|.%���w�1E[�9�4�����T��������ڳ���n,M8gءz���Ε�����(��)���G�b:��tJN]+Y�!�hx�8��� -F*16����$e{����O�\�fn.�0DǮodzK����4DOc��J�� t���<�:1�p
�� h������t�I?�𝊊�{z��2!rP;������M�z!�@����X�;N-e��h�
R��s�	����tfm��Q��V�6���{�O4�ywr{"�>�%H+�rgz��Nu����k@1������Ǟ3�d�]�̅V_Ԅ��$�^F�ń��e������f���S��"��_�2)�w��� \�['7�*�d� ���h5�@1CU�m`jf/=��ZM�3���7�`�I��V�C���c۩?T�b	���l�[�{2B�$�EP���H5�em^�8yB��a{��O	��O�L���w_��p���^�<:�9���&MB�TBJ����rFJ�)B]rP?�Xq������OS��W+�/]�����Ӷ��
��e����+�EHiH�q}�N`F��?<��o�Q�����$4f���vq�A*���D��Gڛ���MN���5����X�Q$%@��ڙ}T��OZ(67D�����dd�� ��5ɟ���9�2�t�� ۄ�1�Z��-�V����\�ђt�Q��Nr|!S\�C�9�Sy0򗡢��F�ڰ1�/*Q�d��]D��e*] $��O?͢�t֒���(��J�K��`��0�p˩�h�+��S?��6���ֱ�#�-�B:&�o�C2#`��D�𦝔�~����x��vp~��j�9%`�+�ί��],�8�X.5����lDt�ƥ-
6Ea�a�A�c�;7F�\~M^V�(ɮ �h>�l�#iFM�-R�,ǿb�n<#��ӹ.�i
���2��V�v�7��!�\gk!��7������.eא�2�Afu����e�Ic�� B9m�*��Zp
[��>���
)`jG��L��b�8N�tP�T��$�\�?q��=0#����dң��J�K����Tn%��y�q|�;ی���I��$:o���K�#�b�/��I`o�V���a�f�	\;/_��WV`R����i�H���H�h�R�+�@��;F���f����%v4����]@��'�2'���g�J ����%�!>�_����4��0(�x~�w�6Jꗧ�\n���e�"y�~;[T���ٹ�`^%GQ��e�T��C8��K�9�a���E6v�1��0��J7 ���`w��鷌��t�aJ��T٨�k�w�z��rk�o-���9M���\�3G���s��ěr�q˒�+1:ߨ*�-M�qɖU�3=x�&�����3bu�
�m���%����g�EW~KY�SJ����8�#R�˲�A��OÆ���%�:�*I��8���a����p�@$p�$Y>�����55��ɜ9J�A�j�NL�K9w�Y�tu�(8p?͝#>��B"s�6���G�z�!��1��C�Mr#%��2E�B�b���v�ʐۿ ��ՠzT�D�b�㗓ٔ>Ոak*gf�đq�'����/�Ύ�7��@ũcU�@�z�jQ=��<v21b� �;%�z���ʯ[�>;OX������f�hq۵��jq����w�z��3"٭�]���������g[��Wj�*��H��օK(,�q��u���m5Ŷ��d��C�4�p�sW���)��S�u1*�c;4qR�T)�Y(L(ߩu]�W�?aF���;'��3�-����r(��F��Vq�$��J��$s?��"iƕ��O��JM�"�����d��d5� I�s��z��)SV �0uFK�#�"'��0Tv�D����|~ɛU��~�ҋj��:Np�V�N��f�����h���ޝ��5L�X�j��E��`(�H\��#t�VyI��]s�EW����b<6�=k8?W���DW@�ر�}^o�*���4�����Ϗ��PE
9|ٹ"�ľ���X����Ͷ��r�+�PN���8K�|������K?����8u�� �2Ƹ�$�F�L�D�������ZIH]P��I� �����P>:scwur�����~�J9���7Dd������t\�asB��J~C�����R�0�����r(��>�؅,�܍�c������"��"�����kN \	  �*2?�f'���E���W,��ZȠ��QA`2��n��s�N�px~6�g��əp����I�' ��g�?��'��[�.�"�6zG鬯�օj�0�܏Tf*�<7�.lC�ǅ���-��|	iN0�	ۑ�`��B?��W+�/�$��q��ޮ"k]*�/f�>�Ŕ�.8����.�a!B�2�	0�'(	�r���i����	4�-���T �W{�02��'s�%���7��0���U��HN�4���e�@��=�	WK���)y�
H�^F�_�3���<8�J��K��3��;;`t 6K����&�V���b ��i˘��f�|�y0,��0*��pUΙ)R2:tț����~���q:d� �����C��	*o�hq7���g,n�9!`:`�v6V3%sP����� �>�0uA�P�̸���힜�	�@��n
��Jd|_�da� :�3���
J�~3����U��)��Y�t���L�J�$��������R<�a&���e��~P�+M�q�4_>�����jjv�1�~2�qWEf��o(��I��E%�reN�G:;�4�����t���>��897%��<lF��!�2�1�LkY��*Ņ ���6Q����#������hn��c�JU��;n
�ɴZ�[�~���ѿ����EB��s�Q��U��?ڑ� �>?C�e�ơϓ﫭ZZn�$n/*��mTr�c���V���I*G&n�1�.�� ���ob�%
+`�50[��_qrL��"���Fr3*)�1Q�9I�	#9�P��ȅ2�1�0�"GD�$��uhV��TE�(���2�`;>��uv2+�Sx���Y�)�P��>���N�ќ�.������W�+�3��%IG��!	���d�s�cVK� ��ʵ�_�73u�Q� �e��*�(T��V�vc�㻿q�L�#
a6 'NҘ��v=����8��Bv'!Q�I�y��j�����-@~�bL�>I�s��Lf8y��2�>�3�����?͊���e�Ø�F�b�Xr֪֛iޭdx뙛f�7�p;�!�%]����<
���<MĊ'��Ϳ����ĥ�^��?�>�<�2��\��¨�Qgl���&�+r�^υ�Ǫ�}M�S0�5�����9xW��w�;7B��. @��,I�VPc���I�� ��+F���A�ٻ5���pGU�O��0�?�rg��}y��愤ԭ&�]��9R��K5 :�:�V�:�n� ��х���)w�S�2=�DDJ�Xk�at>5�>ض�1��R9�]|�#��B�4�IηN3��D0�ᗘ|Ȃ�Jْk{!�p"DTH.0=t�?��C�(��]
��O��M;���e-8�pp�a�}Y�R�8GX�w��� ��]~ȉ5\���+� ��j���K5�QVF��5x��q������/5�[VoNӡ%cQ/��yɸ^���i
�Us�����Z}�1,&}yb����N�Z�D�(�rBvpz	���h��v�`,~J�Y�2��8��]�K�>*�����Cg�۪�ᙍQ2���k�3�����h�ɒ=1�R���n���WN��dL�~פ�(ǋ��^)k����1�H�=�u���gB2
��Ʈ��0G� �=txp��F�q�  ��i	��;���ߚ���i������Φ��y\��	��}��pi��a�a�e�9�,�w5��q����/��k�
�2�Ck���5��̼L�h��g��u.$����M(�Im��:Jc��t�๔�S��@CH��oXԹ�V������䲻��s2��]�v���WI�o��TNM��V2�PHg͔ͥ��0H
�x¬�}��f�iаNO���C�H�'i�w�ipyN`ul��2��S$7w�f��]���1v�Oꃒ�Ⴎ�F�Э��iJ��J�Z�B�Q�����(�{���n�7��`T��s�C���=Z]�<Hfo����	۬lg���eo�~�a͹0���Y��`�\��.2����76����;k�2Sg����6L�]x�M��-�7x�ԛg�� �����'@���Q���(t4ץ:Dz�a0q*���V�������<a�yu�?��d���]����f�����-n>����ɣ='�>��k9�]i�<�jA2��<�[b:���Pđ9Fu��*;4��Ms��
�3�Ƶ����>��gf�ʌL��\LcϝE Ʒ8]0�?XV�恚M��m < �{�a�+k�QK�e��LNp��wÊ�?f��AE�RV�����r��˗�����&�Vw�$���ך4�����MBg �r�>=����¾IKj'?gvT��踮�xӸ��g�\��+ɲI��I�?��s�v��b����ٌp�t�܎�Cj��D���HY�����cD�e~+���<������������
     