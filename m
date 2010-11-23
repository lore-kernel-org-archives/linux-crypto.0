From: Miloslav Trmac <mitr@redhat.com>
Subject: RFC: AF_ALG auditing
Date: Tue, 23 Nov 2010 07:47:11 -0500 (EST)
Message-ID: <344091777.216361290516431362.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
References: <847856953.215811290516008957.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_12815_1468147495.1290516431359"
Cc: linux-audit <linux-audit@redhat.com>,
	linux-crypto <linux-crypto@vger.kernel.org>
To: Steve Grubb <sgrubb@redhat.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:54125 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743Ab0KWMrP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Nov 2010 07:47:15 -0500
In-Reply-To: <847856953.215811290516008957.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

------=_Part_12815_1468147495.1290516431359
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hello,
attached is an user-space patch that adds support for auditing uses of the AF_ALG protocol family developed by Herbert Xu to provide user-space access to kernel crypto accelerators.  Kernel patches will follow.

One new record is defined: AUDIT_CRYPTO_USERSPACE_OP.  An audited event is always caused by a syscall, and all other syscall-related data (process identity, syscall result) is audited in the usual records.

To disable auditing crypto by default and to allow the users to selectively enable them using filters, a new filter field AUDIT_CRYPTO_OP is defined; auditing of all crypto operations can thus be enabled using (auditctl -a exit,always -F crypto_op!=0).

In addition to the user-space patch, attached are also a few example audit entries.
    Mirek
------=_Part_12815_1468147495.1290516431359
Content-Type: text/x-patch; name=audit-2.0.5-AF_ALG.patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=audit-2.0.5-AF_ALG.patch

diff -urN audit/lib/crypto_ops_table.h audit-2.0.5/lib/crypto_ops_table.h
--- audit/lib/crypto_ops_table.h=091970-01-01 01:00:00.000000000 +0100
+++ audit-2.0.5/lib/crypto_ops_table.h=092010-11-23 12:46:30.228156952 +010=
0
@@ -0,0 +1,28 @@
+/* crypto_ops_table.h --
+ * Copyright 2010 Red Hat Inc., Durham, North Carolina.
+ * All Rights Reserved.
+ *
+ * This library is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Lesser General Public
+ * License as published by the Free Software Foundation; either
+ * version 2.1 of the License, or (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public
+ * License along with this library; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  U=
SA
+ *
+ * Authors:
+ *      Miloslav Trma=C4=8D <mitr@redhat.com>
+ */
+
+_S(AUDIT_CRYPTO_OP_TFM_NEW,        "tfm_new")
+_S(AUDIT_CRYPTO_OP_TFM_KEY_IMPORT, "tfm_key_import")
+_S(AUDIT_CRYPTO_OP_TFM_DEL,        "tfm_del")
+_S(AUDIT_CRYPTO_OP_CTX_NEW,        "ctx_new")
+_S(AUDIT_CRYPTO_OP_CTX_OP,         "ctx_op")
+_S(AUDIT_CRYPTO_OP_CTX_DEL,        "ctx_del")
diff -urN audit/lib/errormsg.h audit-2.0.5/lib/errormsg.h
--- audit/lib/errormsg.h=092010-09-22 17:02:27.000000000 +0200
+++ audit-2.0.5/lib/errormsg.h=092010-11-23 12:42:32.914851919 +0100
@@ -54,5 +54,6 @@
     { -19,    0,    "Key field needs a watch or syscall given prior to it"=
 },
     { -20,    2,    "-F missing value after operation for" },
     { -21,    2,    "-F value should be number for" },
-    { -22,    2,    "-F missing field name before operator for" }
+    { -22,    2,    "-F missing field name before operator for" },
+    { -23,    2,    "-F unknown crypto_op - " }
 };
diff -urN audit/lib/fieldtab.h audit-2.0.5/lib/fieldtab.h
--- audit/lib/fieldtab.h=092010-09-22 17:02:27.000000000 +0200
+++ audit-2.0.5/lib/fieldtab.h=092010-11-23 12:49:30.583184463 +0100
@@ -55,6 +55,7 @@
 _S(AUDIT_PERM,         "perm"         )
 _S(AUDIT_DIR,          "dir"          )
 _S(AUDIT_FILETYPE,     "filetype"     )
+_S(AUDIT_CRYPTO_OP,    "crypto_op"    )
=20
 _S(AUDIT_ARG0,         "a0"           )
 _S(AUDIT_ARG1,         "a1"           )
diff -urN audit/lib/libaudit.c audit-2.0.5/lib/libaudit.c
--- audit/lib/libaudit.c=092010-09-22 17:02:27.000000000 +0200
+++ audit-2.0.5/lib/libaudit.c=092010-11-23 12:42:32.917851911 +0100
@@ -38,6 +38,8 @@
 #include <fcntl.h>=09/* O_NOFOLLOW needs gnu defined */
 #include <limits.h>=09/* for PATH_MAX */
=20
+#include "gen_tables.h"
+#include "crypto_ops.h"
 #include "libaudit.h"
 #include "private.h"
 #include "errormsg.h"
@@ -1109,6 +1111,21 @@
 =09=09=09else=20
 =09=09=09=09return -21;
 =09=09=09break;
+=09=09case AUDIT_CRYPTO_OP:
+=09=09=09if (flags !=3D AUDIT_FILTER_EXIT)
+=09=09=09=09return -7;
+=09=09=09if (isdigit((unsigned char)*v))
+=09=09=09=09rule->values[rule->field_count] =3D
+=09=09=09=09=09strtoul(v, NULL, 0);
+=09=09=09else {
+=09=09=09=09int op;
+
+=09=09=09=09if (crypto_op_s2i(v, &op) !=3D 0)
+=09=09=09=09=09rule->values[rule->field_count] =3D op;
+=09=09=09=09else
+=09=09=09=09=09return -23;
+=09=09=09}
+=09=09=09break;
 =09=09case AUDIT_DEVMAJOR...AUDIT_INODE:
 =09=09case AUDIT_SUCCESS:
 =09=09=09if (flags !=3D AUDIT_FILTER_EXIT)
diff -urN audit/lib/libaudit.h audit-2.0.5/lib/libaudit.h
--- audit/lib/libaudit.h=092010-09-22 17:02:27.000000000 +0200
+++ audit-2.0.5/lib/libaudit.h=092010-11-23 12:45:29.291347010 +0100
@@ -119,6 +119,7 @@
 #endif
=20
 #define AUDIT_FIRST_KERN_CRYPTO_MSG=091600
+#define AUDIT_CRYPTO_USERSPACE_OP=091600 /* User-space crypto operation */
 #define AUDIT_LAST_KERN_CRYPTO_MSG=091699
=20
 #define AUDIT_FIRST_KERN_ANOM_MSG=091700
@@ -211,6 +212,14 @@
 #define AUDIT_LAST_USER_MSG2   2999
 #endif
=20
+#define AUDIT_CRYPTO_OP=09109
+
+#define AUDIT_CRYPTO_OP_TFM_NEW=09=091
+#define AUDIT_CRYPTO_OP_TFM_KEY_IMPORT=092
+#define AUDIT_CRYPTO_OP_TFM_DEL=09=093
+#define AUDIT_CRYPTO_OP_CTX_NEW=09=094
+#define AUDIT_CRYPTO_OP_CTX_OP=09=095
+#define AUDIT_CRYPTO_OP_CTX_DEL=09=096
=20
 /* This is related to the filterkey patch */
 #define AUDIT_KEY_SEPARATOR 0x01
diff -urN audit/lib/Makefile.am audit-2.0.5/lib/Makefile.am
--- audit/lib/Makefile.am=092010-09-22 17:02:27.000000000 +0200
+++ audit-2.0.5/lib/Makefile.am=092010-11-23 12:42:32.921851901 +0100
@@ -37,7 +37,7 @@
 libaudit_la_LDFLAGS =3D -Wl,-z,relro -version-info $(VERSION_INFO)
 nodist_libaudit_la_SOURCES =3D $(BUILT_SOURCES)
=20
-BUILT_SOURCES =3D actiontabs.h errtabs.h fieldtabs.h flagtabs.h \
+BUILT_SOURCES =3D actiontabs.h crypto_ops.h errtabs.h fieldtabs.h flagtabs=
.h \
 =09ftypetabs.h i386_tables.h ia64_tables.h machinetabs.h \
 =09msg_typetabs.h optabs.h ppc_tables.h s390_tables.h \
 =09s390x_tables.h x86_64_tables.h
@@ -47,8 +47,8 @@
 if USE_ARMEB
 BUILT_SOURCES +=3D armeb_tables.h
 endif
-noinst_PROGRAMS =3D gen_actiontabs_h gen_errtabs_h gen_fieldtabs_h \
-=09gen_flagtabs_h gen_ftypetabs_h gen_i386_tables_h \
+noinst_PROGRAMS =3D gen_actiontabs_h gen_crypto_ops_h gen_errtabs_h \
+=09gen_fieldtabs_h gen_flagtabs_h gen_ftypetabs_h gen_i386_tables_h \
 =09gen_ia64_tables_h gen_machinetabs_h gen_msg_typetabs_h \
 =09gen_optabs_h gen_ppc_tables_h gen_s390_tables_h \
 =09gen_s390x_tables_h gen_x86_64_tables_h
@@ -77,6 +77,11 @@
 =09./gen_armeb_tables_h --lowercase --i2s --s2i armeb_syscall > $@
 endif
=20
+gen_crypto_ops_h_SOURCES =3D gen_tables.c gen_tables.h crypto_ops_table.h
+gen_crypto_ops_h_CFLAGS =3D $(AM_CFLAGS) '-DTABLE_H=3D"crypto_ops_table.h"=
'
+crypto_ops.h: gen_crypto_ops_h Makefile
+=09./gen_crypto_ops_h --lowercase --s2i crypto_op > $@
+
 gen_errtabs_h_SOURCES =3D gen_tables.c gen_tables.h errtab.h
 gen_errtabs_h_CFLAGS =3D $(AM_CFLAGS) '-DTABLE_H=3D"errtab.h"'
 errtabs.h: gen_errtabs_h Makefile
diff -urN audit/lib/msg_typetab.h audit-2.0.5/lib/msg_typetab.h
--- audit/lib/msg_typetab.h=092010-09-22 17:02:27.000000000 +0200
+++ audit-2.0.5/lib/msg_typetab.h=092010-11-23 12:44:00.963608651 +0100
@@ -122,6 +122,7 @@
 _S(AUDIT_MAC_IPSEC_EVENT,            "MAC_IPSEC_EVENT"               )
 _S(AUDIT_MAC_UNLBL_STCADD,           "MAC_UNLBL_STCADD"              )
 _S(AUDIT_MAC_UNLBL_STCDEL,           "MAC_UNLBL_STCDEL"              )
+_S(AUDIT_CRYPTO_USERSPACE_OP,        "CRYPTO_USERSPACE_OP"           )
 _S(AUDIT_ANOM_PROMISCUOUS,           "ANOM_PROMISCUOUS"              )
 _S(AUDIT_ANOM_ABEND,                 "ANOM_ABEND"                    )
 _S(AUDIT_INTEGRITY_DATA,             "INTEGRITY_DATA"                )
diff -urN audit/src/aureport-output.c audit-2.0.5/src/aureport-output.c
--- audit/src/aureport-output.c=092010-09-22 17:02:21.000000000 +0200
+++ audit-2.0.5/src/aureport-output.c=092010-11-23 12:42:32.910851932 +0100
@@ -600,7 +600,7 @@
 =09=09=09// auid type success event
 =09=09=09printf("%s %s %s %lu\n",
 =09=09=09=09aulookup_uid(l->s.loginuid, name, sizeof(name)),
-=09=09=09=09audit_msg_type_to_name(l->head->type),
+=09=09=09=09audit_msg_type_to_name(l->cur->type),
 =09=09=09=09aulookup_success(l->s.success),
 =09=09=09=09l->e.serial);
 =09=09=09break;
diff -urN audit/src/aureport-scan.c audit-2.0.5/src/aureport-scan.c
--- audit/src/aureport-scan.c=092010-09-22 17:02:21.000000000 +0200
+++ audit-2.0.5/src/aureport-scan.c=092010-11-23 12:42:32.912851925 +0100
@@ -420,8 +420,12 @@
 =09=09case RPT_CRYPTO:
 =09=09=09if (list_find_msg_range(l, AUDIT_FIRST_KERN_CRYPTO_MSG,
 =09=09=09=09=09=09AUDIT_LAST_KERN_CRYPTO_MSG)) {
-=09=09=09=09ilist_add_if_uniq(&sd.crypto_list,=20
-=09=09=09=09=09=09=09l->head->type, 0);
+=09=09=09=09do
+=09=09=09=09=09ilist_add_if_uniq(&sd.crypto_list,
+=09=09=09=09=09=09=09  l->cur->type, 0);
+=09=09=09=09while (list_find_next_msg_range(l,
+=09=09=09=09=09=09AUDIT_FIRST_KERN_CRYPTO_MSG,
+=09=09=09=09=09=09AUDIT_LAST_KERN_CRYPTO_MSG));
 =09=09=09} else {
 =09=09=09=09if (list_find_msg_range(l,=20
 =09=09=09=09=09AUDIT_FIRST_CRYPTO_MSG,
@@ -663,7 +667,11 @@
 =09=09=09=09if (list_find_msg_range(l,=20
 =09=09=09=09=09=09AUDIT_FIRST_KERN_CRYPTO_MSG,
 =09=09=09=09=09=09AUDIT_LAST_KERN_CRYPTO_MSG)) {
-=09=09=09=09=09print_per_event_item(l);
+=09=09=09=09=09do
+=09=09=09=09=09=09print_per_event_item(l);
+=09=09=09=09=09while (list_find_next_msg_range(l,
+=09=09=09=09=09=09AUDIT_FIRST_KERN_CRYPTO_MSG,
+=09=09=09=09=09=09AUDIT_LAST_KERN_CRYPTO_MSG));
 =09=09=09=09=09rc =3D 1;
 =09=09=09=09} else {
 =09=09=09=09=09if (list_find_msg_range(l,=20
diff -urN audit/src/ausearch-llist.c audit-2.0.5/src/ausearch-llist.c
--- audit/src/ausearch-llist.c=092010-09-22 17:02:21.000000000 +0200
+++ audit-2.0.5/src/ausearch-llist.c=092010-11-23 12:42:32.911851928 +0100
@@ -245,3 +245,22 @@
 =09return NULL;
 }
=20
+
+lnode *list_find_next_msg_range(llist *l, int low, int high)
+{
+        register lnode *window;
+
+=09if (high <=3D low)
+=09=09return NULL;
+
+       =09window =3D l->cur->next;
+=09while (window) {
+=09=09if (window->type >=3D low && window->type <=3D high) {
+=09=09=09l->cur =3D window;
+=09=09=09return window;
+=09=09} else
+=09=09=09window =3D window->next;
+=09}
+=09return NULL;
+}
+
diff -urN audit/src/ausearch-llist.h audit-2.0.5/src/ausearch-llist.h
--- audit/src/ausearch-llist.h=092010-09-22 17:02:21.000000000 +0200
+++ audit-2.0.5/src/ausearch-llist.h=092010-11-23 12:42:32.913851922 +0100
@@ -107,5 +107,8 @@
 /* Given two message types, find the first matching node */
 lnode *list_find_msg_range(llist *l, int low, int high);
=20
+/* Given two message types, find the next matching node */
+lnode *list_find_next_msg_range(llist *l, int low, int high);
+
 #endif
=20

------=_Part_12815_1468147495.1290516431359
Content-Type: application/octet-stream; name=audit-examples
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=audit-examples

# Records other than CRYPTO_USERSPACE_OP, e.g. SYSCALL, omitted

# HMAC (unkeyed digests are the same, but tfm_key_import is not generated):
type=CRYPTO_USERSPACE_OP msg=audit(1290514606.290:1615): crypto_op=tfm_new tfm=0
type=CRYPTO_USERSPACE_OP msg=audit(1290514606.327:1616): crypto_op=tfm_key_import tfm=0 algorithm="hmac(sha1)"
type=CRYPTO_USERSPACE_OP msg=audit(1290514606.327:1617): crypto_op=ctx_new tfm=0 ctx=1 algorithm="hmac(sha1)"
type=CRYPTO_USERSPACE_OP msg=audit(1290514606.327:1618): crypto_op=ctx_op tfm=0 ctx=1 algorithm="hmac(sha1)" operation="hash-input"
type=CRYPTO_USERSPACE_OP msg=audit(1290514606.327:1619): crypto_op=ctx_op tfm=0 ctx=1 algorithm="hmac(sha1)" operation="hash-input"
type=CRYPTO_USERSPACE_OP msg=audit(1290514606.327:1620): crypto_op=ctx_op tfm=0 ctx=1 algorithm="hmac(sha1)" operation="hash-output"
type=CRYPTO_USERSPACE_OP msg=audit(1290514606.328:1621): crypto_op=ctx_del tfm=0 ctx=1 algorithm="hmac(sha1)"
type=CRYPTO_USERSPACE_OP msg=audit(1290514606.348:1652): crypto_op=tfm_del tfm=0

# Encryption
type=CRYPTO_USERSPACE_OP msg=audit(1290514598.353:817): crypto_op=tfm_new tfm=0
type=CRYPTO_USERSPACE_OP msg=audit(1290514598.408:818): crypto_op=tfm_key_import tfm=0 algorithm="cbc(aes)"
type=CRYPTO_USERSPACE_OP msg=audit(1290514598.409:819): crypto_op=ctx_new tfm=0 ctx=1 algorithm="cbc(aes)"
# Here user-space used a 0-byte sendmsg to specify an IV without specifying
# operation type, which defaults to "decrypt"
type=CRYPTO_USERSPACE_OP msg=audit(1290514598.409:820): crypto_op=ctx_op tfm=0 ctx=1 algorithm="cbc(aes)" operation="decrypt-input"
type=CRYPTO_USERSPACE_OP msg=audit(1290514598.409:821): crypto_op=ctx_op tfm=0 ctx=1 algorithm="cbc(aes)" operation="encrypt-input"
type=CRYPTO_USERSPACE_OP msg=audit(1290514598.409:822): crypto_op=ctx_op tfm=0 ctx=1 algorithm="cbc(aes)" operation="encrypt-output"
type=CRYPTO_USERSPACE_OP msg=audit(1290514598.409:823): crypto_op=ctx_del tfm=0 ctx=1 algorithm="cbc(aes)"
type=CRYPTO_USERSPACE_OP msg=audit(1290514598.409:824): crypto_op=tfm_key_import tfm=0 algorithm="cbc(aes)"
type=CRYPTO_USERSPACE_OP msg=audit(1290514598.410:825): crypto_op=ctx_new tfm=0 ctx=1 algorithm="cbc(aes)"
type=CRYPTO_USERSPACE_OP msg=audit(1290514598.410:826): crypto_op=ctx_op tfm=0 ctx=1 algorithm="cbc(aes)" operation="decrypt-input"
type=CRYPTO_USERSPACE_OP msg=audit(1290514598.410:827): crypto_op=ctx_op tfm=0 ctx=1 algorithm="cbc(aes)" operation="decrypt-input"
type=CRYPTO_USERSPACE_OP msg=audit(1290514598.410:828): crypto_op=ctx_op tfm=0 ctx=1 algorithm="cbc(aes)" operation="decrypt-output"
type=CRYPTO_USERSPACE_OP msg=audit(1290514598.410:829): crypto_op=ctx_del tfm=0 ctx=1 algorithm="cbc(aes)"
type=CRYPTO_USERSPACE_OP msg=audit(1290514598.410:830): crypto_op=tfm_key_import tfm=0 algorithm="cbc(aes)"
type=CRYPTO_USERSPACE_OP msg=audit(1290514598.412:831): crypto_op=ctx_new tfm=0 ctx=1 algorithm="cbc(aes)"
type=CRYPTO_USERSPACE_OP msg=audit(1290514598.412:832): crypto_op=ctx_op tfm=0 ctx=1 algorithm="cbc(aes)" operation="decrypt-input"
type=CRYPTO_USERSPACE_OP msg=audit(1290514598.412:833): crypto_op=ctx_op tfm=0 ctx=1 algorithm="cbc(aes)" operation="encrypt-input"
type=CRYPTO_USERSPACE_OP msg=audit(1290514598.413:834): crypto_op=ctx_op tfm=0 ctx=1 algorithm="cbc(aes)" operation="encrypt-output"
type=CRYPTO_USERSPACE_OP msg=audit(1290514598.413:835): crypto_op=ctx_del tfm=0 ctx=1 algorithm="cbc(aes)"
type=CRYPTO_USERSPACE_OP msg=audit(1290514598.413:836): crypto_op=tfm_key_import tfm=0 algorithm="cbc(aes)"
type=CRYPTO_USERSPACE_OP msg=audit(1290514598.413:837): crypto_op=ctx_new tfm=0 ctx=1 algorithm="cbc(aes)"
type=CRYPTO_USERSPACE_OP msg=audit(1290514598.414:838): crypto_op=ctx_op tfm=0 ctx=1 algorithm="cbc(aes)" operation="decrypt-input"
type=CRYPTO_USERSPACE_OP msg=audit(1290514598.414:839): crypto_op=ctx_op tfm=0 ctx=1 algorithm="cbc(aes)" operation="decrypt-input"
type=CRYPTO_USERSPACE_OP msg=audit(1290514598.415:840): crypto_op=ctx_op tfm=0 ctx=1 algorithm="cbc(aes)" operation="decrypt-output"
type=CRYPTO_USERSPACE_OP msg=audit(1290514598.415:841): crypto_op=ctx_del tfm=0 ctx=1 algorithm="cbc(aes)"
type=CRYPTO_USERSPACE_OP msg=audit(1290514598.415:842): crypto_op=tfm_del tfm=0

------=_Part_12815_1468147495.1290516431359--
