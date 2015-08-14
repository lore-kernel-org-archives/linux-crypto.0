From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/3] Move certificate handling to its own directory
Date: Fri, 14 Aug 2015 16:57:00 +0100
Message-ID: <20150814155700.23941.29650.stgit@warthog.procyon.org.uk>
References: <20150814155650.23941.76513.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
	dwmw2@infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: keyrings@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150814155650.23941.76513.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Move certificate handling out of the kernel/ directory and into a certs=
/
directory to get all the weird stuff in one place and move the generate=
d
signing keys into this directory.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: David Woodhouse <David.Woodhouse@intel.com>
---

 Documentation/module-signing.txt |   18 ++--
 MAINTAINERS                      |    9 ++
 Makefile                         |    4 -
 certs/Kconfig                    |   42 ++++++++++
 certs/Makefile                   |  147 ++++++++++++++++++++++++++++++=
++++++
 certs/system_certificates.S      |   23 ++++++
 certs/system_keyring.c           |  157 ++++++++++++++++++++++++++++++=
++++++++
 crypto/Kconfig                   |    1=20
 init/Kconfig                     |   39 ---------
 kernel/Makefile                  |  143 ------------------------------=
-----
 kernel/system_certificates.S     |   23 ------
 kernel/system_keyring.c          |  157 ------------------------------=
--------
 12 files changed, 390 insertions(+), 373 deletions(-)
 create mode 100644 certs/Kconfig
 create mode 100644 certs/Makefile
 create mode 100644 certs/system_certificates.S
 create mode 100644 certs/system_keyring.c
 delete mode 100644 kernel/system_certificates.S
 delete mode 100644 kernel/system_keyring.c

diff --git a/Documentation/module-signing.txt b/Documentation/module-si=
gning.txt
index 02a9baf1c72f..a78bf1ffa68c 100644
--- a/Documentation/module-signing.txt
+++ b/Documentation/module-signing.txt
@@ -92,13 +92,13 @@ This has a number of options available:
  (4) "File name or PKCS#11 URI of module signing key" (CONFIG_MODULE_S=
IG_KEY)
=20
      Setting this option to something other than its default of
-     "signing_key.pem" will disable the autogeneration of signing keys=
 and
-     allow the kernel modules to be signed with a key of your choosing=
=2E
-     The string provided should identify a file containing both a priv=
ate
-     key and its corresponding X.509 certificate in PEM form, or =E2=80=
=94 on
-     systems where the OpenSSL ENGINE_pkcs11 is functional =E2=80=94 a=
 PKCS#11 URI
-     as defined by RFC7512. In the latter case, the PKCS#11 URI should
-     reference both a certificate and a private key.
+     "certs/signing_key.pem" will disable the autogeneration of signin=
g keys
+     and allow the kernel modules to be signed with a key of your choo=
sing.
+     The string provided should identify a file containing both a priv=
ate key
+     and its corresponding X.509 certificate in PEM form, or =E2=80=94=
 on systems where
+     the OpenSSL ENGINE_pkcs11 is functional =E2=80=94 a PKCS#11 URI a=
s defined by
+     RFC7512. In the latter case, the PKCS#11 URI should reference bot=
h a
+     certificate and a private key.
=20
      If the PEM file containing the private key is encrypted, or if th=
e
      PKCS#11 token requries a PIN, this can be provided at build time =
by
@@ -130,12 +130,12 @@ Under normal conditions, when CONFIG_MODULE_SIG_K=
EY is unchanged from its
 default, the kernel build will automatically generate a new keypair us=
ing
 openssl if one does not exist in the file:
=20
-	signing_key.pem
+	certs/signing_key.pem
=20
 during the building of vmlinux (the public part of the key needs to be=
 built
 into vmlinux) using parameters in the:
=20
-	x509.genkey
+	certs/x509.genkey
=20
 file (which is also generated if it does not already exist).
=20
diff --git a/MAINTAINERS b/MAINTAINERS
index bde2e3f5a10b..294dc59ed5e1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2589,6 +2589,15 @@ S:	Supported
 F:	Documentation/filesystems/ceph.txt
 F:	fs/ceph/
=20
+CERTIFICATE HANDLING:
+M:	David Howells <dhowells@redhat.com>
+M:	David Woodhouse <dwmw2@infradead.org>
+L:	keyrings@linux-nfs.org
+S:	Maintained
+F:	Documentation/module-signing.txt
+F:	certs/
+F:	scripts/extract-cert.c
+
 CERTIFIED WIRELESS USB (WUSB) SUBSYSTEM:
 L:	linux-usb@vger.kernel.org
 S:	Orphan
diff --git a/Makefile b/Makefile
index 6ab99d8cc23c..2341942feb85 100644
--- a/Makefile
+++ b/Makefile
@@ -871,7 +871,7 @@ INITRD_COMPRESS-$(CONFIG_RD_LZ4)   :=3D lz4
=20
 ifdef CONFIG_MODULE_SIG_ALL
 MODSECKEY =3D $(CONFIG_MODULE_SIG_KEY)
-MODPUBKEY =3D ./signing_key.x509
+MODPUBKEY =3D certs/signing_key.x509
 export MODPUBKEY
 mod_sign_cmd =3D scripts/sign-file $(CONFIG_MODULE_SIG_HASH) $(MODSECK=
EY) $(MODPUBKEY)
 else
@@ -881,7 +881,7 @@ export mod_sign_cmd
=20
=20
 ifeq ($(KBUILD_EXTMOD),)
-core-y		+=3D kernel/ mm/ fs/ ipc/ security/ crypto/ block/
+core-y		+=3D kernel/ certs/ mm/ fs/ ipc/ security/ crypto/ block/
=20
 vmlinux-dirs	:=3D $(patsubst %/,%,$(filter %/, $(init-y) $(init-m) \
 		     $(core-y) $(core-m) $(drivers-y) $(drivers-m) \
diff --git a/certs/Kconfig b/certs/Kconfig
new file mode 100644
index 000000000000..b030b9c7ed34
--- /dev/null
+++ b/certs/Kconfig
@@ -0,0 +1,42 @@
+menu "Certificates for signature checking"
+
+config MODULE_SIG_KEY
+	string "File name or PKCS#11 URI of module signing key"
+	default "certs/signing_key.pem"
+	depends on MODULE_SIG
+	help
+         Provide the file name of a private key/certificate in PEM for=
mat,
+         or a PKCS#11 URI according to RFC7512. The file should contai=
n, or
+         the URI should identify, both the certificate and its corresp=
onding
+         private key.
+
+         If this option is unchanged from its default "certs/signing_k=
ey.pem",
+         then the kernel will automatically generate the private key a=
nd
+         certificate as described in Documentation/module-signing.txt
+
+config SYSTEM_TRUSTED_KEYRING
+	bool "Provide system-wide ring of trusted keys"
+	depends on KEYS
+	help
+	  Provide a system keyring to which trusted keys can be added.  Keys =
in
+	  the keyring are considered to be trusted.  Keys may be added at wil=
l
+	  by the kernel from compiled-in data and from hardware key stores, b=
ut
+	  userspace may only add extra keys if those keys can be verified by
+	  keys already in the keyring.
+
+	  Keys in this keyring are used by module signature checking.
+
+config SYSTEM_TRUSTED_KEYS
+	string "Additional X.509 keys for default system keyring"
+	depends on SYSTEM_TRUSTED_KEYRING
+	help
+	  If set, this option should be the filename of a PEM-formatted file
+	  containing trusted X.509 certificates to be included in the default
+	  system keyring. Any certificate used for module signing is implicit=
ly
+	  also trusted.
+
+	  NOTE: If you previously provided keys for the system keyring in the
+	  form of DER-encoded *.x509 files in the top-level build directory,
+	  those are no longer used. You will need to set this option instead.
+
+endmenu
diff --git a/certs/Makefile b/certs/Makefile
new file mode 100644
index 000000000000..5d33486d3b20
--- /dev/null
+++ b/certs/Makefile
@@ -0,0 +1,147 @@
+#
+# Makefile for the linux kernel signature checking certificates.
+#
+
+obj-$(CONFIG_SYSTEM_TRUSTED_KEYRING) +=3D system_keyring.o system_cert=
ificates.o
+
+######################################################################=
#########
+#
+# When a Kconfig string contains a filename, it is suitable for
+# passing to shell commands. It is surrounded by double-quotes, and
+# any double-quotes or backslashes within it are escaped by
+# backslashes.
+#
+# This is no use for dependencies or $(wildcard). We need to strip the
+# surrounding quotes and the escaping from quotes and backslashes, and
+# we *do* need to escape any spaces in the string. So, for example:
+#
+# Usage: $(eval $(call config_filename,FOO))
+#
+# Defines FOO_FILENAME based on the contents of the CONFIG_FOO option,
+# transformed as described above to be suitable for use within the
+# makefile.
+#
+# Also, if the filename is a relative filename and exists in the sourc=
e
+# tree but not the build tree, define FOO_SRCPREFIX as $(srctree)/ to
+# be prefixed to *both* command invocation and dependencies.
+#
+# Note: We also print the filenames in the quiet_cmd_foo text, and
+# perhaps ought to have a version specially escaped for that purpose.
+# But it's only cosmetic, and $(patsubst "%",%,$(CONFIG_FOO)) is good
+# enough.  It'll strip the quotes in the common case where there's no
+# space and it's a simple filename, and it'll retain the quotes when
+# there's a space. There are some esoteric cases in which it'll print
+# the wrong thing, but we don't really care. The actual dependencies
+# and commands *do* get it right, with various combinations of single
+# and double quotes, backslashes and spaces in the filenames.
+#
+######################################################################=
#########
+#
+quote :=3D $(firstword " ")
+space :=3D
+space +=3D
+space_escape :=3D %%%SPACE%%%
+#
+define config_filename
+ifneq ($$(CONFIG_$(1)),"")
+$(1)_FILENAME :=3D $$(subst \\,\,$$(subst \$$(quote),$$(quote),$$(subs=
t $$(space_escape),\$$(space),$$(patsubst "%",%,$$(subst $$(space),$$(s=
pace_escape),$$(CONFIG_$(1)))))))
+ifneq ($$(patsubst /%,%,$$(firstword $$($(1)_FILENAME))),$$(firstword =
$$($(1)_FILENAME)))
+else
+ifeq ($$(wildcard $$($(1)_FILENAME)),)
+ifneq ($$(wildcard $$(srctree)/$$($(1)_FILENAME)),)
+$(1)_SRCPREFIX :=3D $(srctree)/
+endif
+endif
+endif
+endif
+endef
+#
+######################################################################=
#########
+
+ifeq ($(CONFIG_SYSTEM_TRUSTED_KEYRING),y)
+
+$(eval $(call config_filename,SYSTEM_TRUSTED_KEYS))
+
+# GCC doesn't include .incbin files in -MD generated dependencies (PR#=
66871)
+$(obj)/system_certificates.o: $(obj)/x509_certificate_list
+
+# Cope with signing_key.x509 existing in $(srctree) not $(objtree)
+AFLAGS_system_certificates.o :=3D -I$(srctree)
+
+quiet_cmd_extract_certs  =3D EXTRACT_CERTS   $(patsubst "%",%,$(2))
+      cmd_extract_certs  =3D scripts/extract-cert $(2) $@ || ( rm $@; =
exit 1)
+
+targets +=3D x509_certificate_list
+$(obj)/x509_certificate_list: scripts/extract-cert $(SYSTEM_TRUSTED_KE=
YS_SRCPREFIX)$(SYSTEM_TRUSTED_KEYS_FILENAME) FORCE
+	$(call if_changed,extract_certs,$(SYSTEM_TRUSTED_KEYS_SRCPREFIX)$(CON=
=46IG_SYSTEM_TRUSTED_KEYS))
+endif
+
+clean-files :=3D x509_certificate_list .x509.list
+
+ifeq ($(CONFIG_MODULE_SIG),y)
+######################################################################=
#########
+#
+# If module signing is requested, say by allyesconfig, but a key has n=
ot been
+# supplied, then one will need to be generated to make sure the build =
does not
+# fail and that the kernel may be used afterwards.
+#
+######################################################################=
#########
+ifndef CONFIG_MODULE_SIG_HASH
+$(error Could not determine digest type to use from kernel config)
+endif
+
+# We do it this way rather than having a boolean option for enabling a=
n
+# external private key, because 'make randconfig' might enable such a
+# boolean option and we unfortunately can't make it depend on !RANDCON=
=46IG.
+ifeq ($(CONFIG_MODULE_SIG_KEY),"certs/signing_key.pem")
+$(obj)/signing_key.pem: $(obj)/x509.genkey
+	@echo "###"
+	@echo "### Now generating an X.509 key pair to be used for signing mo=
dules."
+	@echo "###"
+	@echo "### If this takes a long time, you might wish to run rngd in t=
he"
+	@echo "### background to keep the supply of entropy topped up.  It"
+	@echo "### needs to be run as root, and uses a hardware random"
+	@echo "### number generator if one is available."
+	@echo "###"
+	openssl req -new -nodes -utf8 -$(CONFIG_MODULE_SIG_HASH) -days 36500 =
\
+		-batch -x509 -config $(obj)/x509.genkey \
+		-outform PEM -out $(obj)/signing_key.pem \
+		-keyout $(obj)/signing_key.pem 2>&1
+	@echo "###"
+	@echo "### Key pair generated."
+	@echo "###"
+
+$(obj)/x509.genkey:
+	@echo Generating X.509 key generation config
+	@echo  >$@ "[ req ]"
+	@echo >>$@ "default_bits =3D 4096"
+	@echo >>$@ "distinguished_name =3D req_distinguished_name"
+	@echo >>$@ "prompt =3D no"
+	@echo >>$@ "string_mask =3D utf8only"
+	@echo >>$@ "x509_extensions =3D myexts"
+	@echo >>$@
+	@echo >>$@ "[ req_distinguished_name ]"
+	@echo >>$@ "#O =3D Unspecified company"
+	@echo >>$@ "CN =3D Build time autogenerated kernel key"
+	@echo >>$@ "#emailAddress =3D unspecified.user@unspecified.company"
+	@echo >>$@
+	@echo >>$@ "[ myexts ]"
+	@echo >>$@ "basicConstraints=3Dcritical,CA:FALSE"
+	@echo >>$@ "keyUsage=3DdigitalSignature"
+	@echo >>$@ "subjectKeyIdentifier=3Dhash"
+	@echo >>$@ "authorityKeyIdentifier=3Dkeyid"
+endif
+
+$(eval $(call config_filename,MODULE_SIG_KEY))
+
+# If CONFIG_MODULE_SIG_KEY isn't a PKCS#11 URI, depend on it
+ifeq ($(patsubst pkcs11:%,%,$(firstword $(MODULE_SIG_KEY_FILENAME))),$=
(firstword $(MODULE_SIG_KEY_FILENAME)))
+X509_DEP :=3D $(MODULE_SIG_KEY_SRCPREFIX)$(MODULE_SIG_KEY_FILENAME)
+endif
+
+# GCC PR#66871 again.
+$(obj)/system_certificates.o: $(obj)/signing_key.x509
+
+$(obj)/signing_key.x509: scripts/extract-cert include/config/module/si=
g/key.h $(X509_DEP)
+	$(call cmd,extract_certs,$(MODULE_SIG_KEY_SRCPREFIX)$(CONFIG_MODULE_S=
IG_KEY))
+endif
diff --git a/certs/system_certificates.S b/certs/system_certificates.S
new file mode 100644
index 000000000000..9216e8c81764
--- /dev/null
+++ b/certs/system_certificates.S
@@ -0,0 +1,23 @@
+#include <linux/export.h>
+#include <linux/init.h>
+
+	__INITRODATA
+
+	.align 8
+	.globl VMLINUX_SYMBOL(system_certificate_list)
+VMLINUX_SYMBOL(system_certificate_list):
+__cert_list_start:
+#ifdef CONFIG_MODULE_SIG
+	.incbin "certs/signing_key.x509"
+#endif
+	.incbin "certs/x509_certificate_list"
+__cert_list_end:
+
+	.align 8
+	.globl VMLINUX_SYMBOL(system_certificate_list_size)
+VMLINUX_SYMBOL(system_certificate_list_size):
+#ifdef CONFIG_64BIT
+	.quad __cert_list_end - __cert_list_start
+#else
+	.long __cert_list_end - __cert_list_start
+#endif
diff --git a/certs/system_keyring.c b/certs/system_keyring.c
new file mode 100644
index 000000000000..2570598b784d
--- /dev/null
+++ b/certs/system_keyring.c
@@ -0,0 +1,157 @@
+/* System trusted keyring for trusted public keys
+ *
+ * Copyright (C) 2012 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/export.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/cred.h>
+#include <linux/err.h>
+#include <keys/asymmetric-type.h>
+#include <keys/system_keyring.h>
+#include <crypto/pkcs7.h>
+
+struct key *system_trusted_keyring;
+EXPORT_SYMBOL_GPL(system_trusted_keyring);
+
+extern __initconst const u8 system_certificate_list[];
+extern __initconst const unsigned long system_certificate_list_size;
+
+/*
+ * Load the compiled-in keys
+ */
+static __init int system_trusted_keyring_init(void)
+{
+	pr_notice("Initialise system trusted keyring\n");
+
+	system_trusted_keyring =3D
+		keyring_alloc(".system_keyring",
+			      KUIDT_INIT(0), KGIDT_INIT(0), current_cred(),
+			      ((KEY_POS_ALL & ~KEY_POS_SETATTR) |
+			      KEY_USR_VIEW | KEY_USR_READ | KEY_USR_SEARCH),
+			      KEY_ALLOC_NOT_IN_QUOTA, NULL);
+	if (IS_ERR(system_trusted_keyring))
+		panic("Can't allocate system trusted keyring\n");
+
+	set_bit(KEY_FLAG_TRUSTED_ONLY, &system_trusted_keyring->flags);
+	return 0;
+}
+
+/*
+ * Must be initialised before we try and load the keys into the keyrin=
g.
+ */
+device_initcall(system_trusted_keyring_init);
+
+/*
+ * Load the compiled-in list of X.509 certificates.
+ */
+static __init int load_system_certificate_list(void)
+{
+	key_ref_t key;
+	const u8 *p, *end;
+	size_t plen;
+
+	pr_notice("Loading compiled-in X.509 certificates\n");
+
+	p =3D system_certificate_list;
+	end =3D p + system_certificate_list_size;
+	while (p < end) {
+		/* Each cert begins with an ASN.1 SEQUENCE tag and must be more
+		 * than 256 bytes in size.
+		 */
+		if (end - p < 4)
+			goto dodgy_cert;
+		if (p[0] !=3D 0x30 &&
+		    p[1] !=3D 0x82)
+			goto dodgy_cert;
+		plen =3D (p[2] << 8) | p[3];
+		plen +=3D 4;
+		if (plen > end - p)
+			goto dodgy_cert;
+
+		key =3D key_create_or_update(make_key_ref(system_trusted_keyring, 1)=
,
+					   "asymmetric",
+					   NULL,
+					   p,
+					   plen,
+					   ((KEY_POS_ALL & ~KEY_POS_SETATTR) |
+					   KEY_USR_VIEW | KEY_USR_READ),
+					   KEY_ALLOC_NOT_IN_QUOTA |
+					   KEY_ALLOC_TRUSTED);
+		if (IS_ERR(key)) {
+			pr_err("Problem loading in-kernel X.509 certificate (%ld)\n",
+			       PTR_ERR(key));
+		} else {
+			set_bit(KEY_FLAG_BUILTIN, &key_ref_to_ptr(key)->flags);
+			pr_notice("Loaded X.509 cert '%s'\n",
+				  key_ref_to_ptr(key)->description);
+			key_ref_put(key);
+		}
+		p +=3D plen;
+	}
+
+	return 0;
+
+dodgy_cert:
+	pr_err("Problem parsing in-kernel X.509 certificate list\n");
+	return 0;
+}
+late_initcall(load_system_certificate_list);
+
+#ifdef CONFIG_SYSTEM_DATA_VERIFICATION
+
+/**
+ * Verify a PKCS#7-based signature on system data.
+ * @data: The data to be verified.
+ * @len: Size of @data.
+ * @raw_pkcs7: The PKCS#7 message that is the signature.
+ * @pkcs7_len: The size of @raw_pkcs7.
+ * @usage: The use to which the key is being put.
+ */
+int system_verify_data(const void *data, unsigned long len,
+		       const void *raw_pkcs7, size_t pkcs7_len,
+		       enum key_being_used_for usage)
+{
+	struct pkcs7_message *pkcs7;
+	bool trusted;
+	int ret;
+
+	pkcs7 =3D pkcs7_parse_message(raw_pkcs7, pkcs7_len);
+	if (IS_ERR(pkcs7))
+		return PTR_ERR(pkcs7);
+
+	/* The data should be detached - so we need to supply it. */
+	if (pkcs7_supply_detached_data(pkcs7, data, len) < 0) {
+		pr_err("PKCS#7 signature with non-detached data\n");
+		ret =3D -EBADMSG;
+		goto error;
+	}
+
+	ret =3D pkcs7_verify(pkcs7, usage);
+	if (ret < 0)
+		goto error;
+
+	ret =3D pkcs7_validate_trust(pkcs7, system_trusted_keyring, &trusted)=
;
+	if (ret < 0)
+		goto error;
+
+	if (!trusted) {
+		pr_err("PKCS#7 signature not signed with a trusted key\n");
+		ret =3D -ENOKEY;
+	}
+
+error:
+	pkcs7_free_message(pkcs7);
+	pr_devel("<=3D=3D%s() =3D %d\n", __func__, ret);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(system_verify_data);
+
+#endif /* CONFIG_SYSTEM_DATA_VERIFICATION */
diff --git a/crypto/Kconfig b/crypto/Kconfig
index b4cfc5754033..51b01de7c0ae 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1601,5 +1601,6 @@ config CRYPTO_HASH_INFO
=20
 source "drivers/crypto/Kconfig"
 source crypto/asymmetric_keys/Kconfig
+source certs/Kconfig
=20
 endif	# if CRYPTO
diff --git a/init/Kconfig b/init/Kconfig
index 5d1a703663ad..5526dfaac628 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1740,31 +1740,6 @@ config MMAP_ALLOW_UNINITIALIZED
=20
 	  See Documentation/nommu-mmap.txt for more information.
=20
-config SYSTEM_TRUSTED_KEYRING
-	bool "Provide system-wide ring of trusted keys"
-	depends on KEYS
-	help
-	  Provide a system keyring to which trusted keys can be added.  Keys =
in
-	  the keyring are considered to be trusted.  Keys may be added at wil=
l
-	  by the kernel from compiled-in data and from hardware key stores, b=
ut
-	  userspace may only add extra keys if those keys can be verified by
-	  keys already in the keyring.
-
-	  Keys in this keyring are used by module signature checking.
-
-config SYSTEM_TRUSTED_KEYS
-	string "Additional X.509 keys for default system keyring"
-	depends on SYSTEM_TRUSTED_KEYRING
-	help
-	  If set, this option should be the filename of a PEM-formatted file
-	  containing trusted X.509 certificates to be included in the default
-	  system keyring. Any certificate used for module signing is implicit=
ly
-	  also trusted.
-
-	  NOTE: If you previously provided keys for the system keyring in the
-	  form of DER-encoded *.x509 files in the top-level build directory,
-	  those are no longer used. You will need to set this option instead.
-
 config SYSTEM_DATA_VERIFICATION
 	def_bool n
 	select SYSTEM_TRUSTED_KEYRING
@@ -1965,20 +1940,6 @@ config MODULE_SIG_HASH
 	default "sha384" if MODULE_SIG_SHA384
 	default "sha512" if MODULE_SIG_SHA512
=20
-config MODULE_SIG_KEY
-	string "File name or PKCS#11 URI of module signing key"
-	default "signing_key.pem"
-	depends on MODULE_SIG
-	help
-         Provide the file name of a private key/certificate in PEM for=
mat,
-         or a PKCS#11 URI according to RFC7512. The file should contai=
n, or
-         the URI should identify, both the certificate and its corresp=
onding
-         private key.
-
-         If this option is unchanged from its default "signing_key.pem=
",
-         then the kernel will automatically generate the private key a=
nd
-         certificate as described in Documentation/module-signing.txt
-
 config MODULE_COMPRESS
 	bool "Compress modules on installation"
 	depends on MODULES
diff --git a/kernel/Makefile b/kernel/Makefile
index 65ef3846fbe8..1aa153a1be21 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -45,7 +45,6 @@ ifneq ($(CONFIG_SMP),y)
 obj-y +=3D up.o
 endif
 obj-$(CONFIG_UID16) +=3D uid16.o
-obj-$(CONFIG_SYSTEM_TRUSTED_KEYRING) +=3D system_keyring.o system_cert=
ificates.o
 obj-$(CONFIG_MODULES) +=3D module.o
 obj-$(CONFIG_MODULE_SIG) +=3D module_signing.o
 obj-$(CONFIG_KALLSYMS) +=3D kallsyms.o
@@ -111,145 +110,3 @@ $(obj)/config_data.gz: $(KCONFIG_CONFIG) FORCE
 targets +=3D config_data.h
 $(obj)/config_data.h: $(obj)/config_data.gz FORCE
 	$(call filechk,ikconfiggz)
-
-######################################################################=
#########
-#
-# When a Kconfig string contains a filename, it is suitable for
-# passing to shell commands. It is surrounded by double-quotes, and
-# any double-quotes or backslashes within it are escaped by
-# backslashes.
-#
-# This is no use for dependencies or $(wildcard). We need to strip the
-# surrounding quotes and the escaping from quotes and backslashes, and
-# we *do* need to escape any spaces in the string. So, for example:
-#
-# Usage: $(eval $(call config_filename,FOO))
-#
-# Defines FOO_FILENAME based on the contents of the CONFIG_FOO option,
-# transformed as described above to be suitable for use within the
-# makefile.
-#
-# Also, if the filename is a relative filename and exists in the sourc=
e
-# tree but not the build tree, define FOO_SRCPREFIX as $(srctree)/ to
-# be prefixed to *both* command invocation and dependencies.
-#
-# Note: We also print the filenames in the quiet_cmd_foo text, and
-# perhaps ought to have a version specially escaped for that purpose.
-# But it's only cosmetic, and $(patsubst "%",%,$(CONFIG_FOO)) is good
-# enough.  It'll strip the quotes in the common case where there's no
-# space and it's a simple filename, and it'll retain the quotes when
-# there's a space. There are some esoteric cases in which it'll print
-# the wrong thing, but we don't really care. The actual dependencies
-# and commands *do* get it right, with various combinations of single
-# and double quotes, backslashes and spaces in the filenames.
-#
-######################################################################=
#########
-#
-quote :=3D $(firstword " ")
-space :=3D
-space +=3D
-space_escape :=3D %%%SPACE%%%
-#
-define config_filename
-ifneq ($$(CONFIG_$(1)),"")
-$(1)_FILENAME :=3D $$(subst \\,\,$$(subst \$$(quote),$$(quote),$$(subs=
t $$(space_escape),\$$(space),$$(patsubst "%",%,$$(subst $$(space),$$(s=
pace_escape),$$(CONFIG_$(1)))))))
-ifneq ($$(patsubst /%,%,$$(firstword $$($(1)_FILENAME))),$$(firstword =
$$($(1)_FILENAME)))
-else
-ifeq ($$(wildcard $$($(1)_FILENAME)),)
-ifneq ($$(wildcard $$(srctree)/$$($(1)_FILENAME)),)
-$(1)_SRCPREFIX :=3D $(srctree)/
-endif
-endif
-endif
-endif
-endef
-#
-######################################################################=
#########
-
-ifeq ($(CONFIG_SYSTEM_TRUSTED_KEYRING),y)
-
-$(eval $(call config_filename,SYSTEM_TRUSTED_KEYS))
-
-# GCC doesn't include .incbin files in -MD generated dependencies (PR#=
66871)
-$(obj)/system_certificates.o: $(obj)/x509_certificate_list
-
-# Cope with signing_key.x509 existing in $(srctree) not $(objtree)
-AFLAGS_system_certificates.o :=3D -I$(srctree)
-
-quiet_cmd_extract_certs  =3D EXTRACT_CERTS   $(patsubst "%",%,$(2))
-      cmd_extract_certs  =3D scripts/extract-cert $(2) $@ || ( rm $@; =
exit 1)
-
-targets +=3D x509_certificate_list
-$(obj)/x509_certificate_list: scripts/extract-cert $(SYSTEM_TRUSTED_KE=
YS_SRCPREFIX)$(SYSTEM_TRUSTED_KEYS_FILENAME) FORCE
-	$(call if_changed,extract_certs,$(SYSTEM_TRUSTED_KEYS_SRCPREFIX)$(CON=
=46IG_SYSTEM_TRUSTED_KEYS))
-endif
-
-clean-files :=3D x509_certificate_list .x509.list
-
-ifeq ($(CONFIG_MODULE_SIG),y)
-######################################################################=
#########
-#
-# If module signing is requested, say by allyesconfig, but a key has n=
ot been
-# supplied, then one will need to be generated to make sure the build =
does not
-# fail and that the kernel may be used afterwards.
-#
-######################################################################=
#########
-ifndef CONFIG_MODULE_SIG_HASH
-$(error Could not determine digest type to use from kernel config)
-endif
-
-# We do it this way rather than having a boolean option for enabling a=
n
-# external private key, because 'make randconfig' might enable such a
-# boolean option and we unfortunately can't make it depend on !RANDCON=
=46IG.
-ifeq ($(CONFIG_MODULE_SIG_KEY),"signing_key.pem")
-signing_key.pem: x509.genkey
-	@echo "###"
-	@echo "### Now generating an X.509 key pair to be used for signing mo=
dules."
-	@echo "###"
-	@echo "### If this takes a long time, you might wish to run rngd in t=
he"
-	@echo "### background to keep the supply of entropy topped up.  It"
-	@echo "### needs to be run as root, and uses a hardware random"
-	@echo "### number generator if one is available."
-	@echo "###"
-	openssl req -new -nodes -utf8 -$(CONFIG_MODULE_SIG_HASH) -days 36500 =
\
-		-batch -x509 -config x509.genkey \
-		-outform PEM -out signing_key.pem \
-		-keyout signing_key.pem 2>&1
-	@echo "###"
-	@echo "### Key pair generated."
-	@echo "###"
-
-x509.genkey:
-	@echo Generating X.509 key generation config
-	@echo  >x509.genkey "[ req ]"
-	@echo >>x509.genkey "default_bits =3D 4096"
-	@echo >>x509.genkey "distinguished_name =3D req_distinguished_name"
-	@echo >>x509.genkey "prompt =3D no"
-	@echo >>x509.genkey "string_mask =3D utf8only"
-	@echo >>x509.genkey "x509_extensions =3D myexts"
-	@echo >>x509.genkey
-	@echo >>x509.genkey "[ req_distinguished_name ]"
-	@echo >>x509.genkey "#O =3D Unspecified company"
-	@echo >>x509.genkey "CN =3D Build time autogenerated kernel key"
-	@echo >>x509.genkey "#emailAddress =3D unspecified.user@unspecified.c=
ompany"
-	@echo >>x509.genkey
-	@echo >>x509.genkey "[ myexts ]"
-	@echo >>x509.genkey "basicConstraints=3Dcritical,CA:FALSE"
-	@echo >>x509.genkey "keyUsage=3DdigitalSignature"
-	@echo >>x509.genkey "subjectKeyIdentifier=3Dhash"
-	@echo >>x509.genkey "authorityKeyIdentifier=3Dkeyid"
-endif
-
-$(eval $(call config_filename,MODULE_SIG_KEY))
-
-# If CONFIG_MODULE_SIG_KEY isn't a PKCS#11 URI, depend on it
-ifeq ($(patsubst pkcs11:%,%,$(firstword $(MODULE_SIG_KEY_FILENAME))),$=
(firstword $(MODULE_SIG_KEY_FILENAME)))
-X509_DEP :=3D $(MODULE_SIG_KEY_SRCPREFIX)$(MODULE_SIG_KEY_FILENAME)
-endif
-
-# GCC PR#66871 again.
-$(obj)/system_certificates.o: signing_key.x509
-
-signing_key.x509: scripts/extract-cert include/config/module/sig/key.h=
 $(X509_DEP)
-	$(call cmd,extract_certs,$(MODULE_SIG_KEY_SRCPREFIX)$(CONFIG_MODULE_S=
IG_KEY))
-endif
diff --git a/kernel/system_certificates.S b/kernel/system_certificates.=
S
deleted file mode 100644
index 6ba2f75e7ba5..000000000000
--- a/kernel/system_certificates.S
+++ /dev/null
@@ -1,23 +0,0 @@
-#include <linux/export.h>
-#include <linux/init.h>
-
-	__INITRODATA
-
-	.align 8
-	.globl VMLINUX_SYMBOL(system_certificate_list)
-VMLINUX_SYMBOL(system_certificate_list):
-__cert_list_start:
-#ifdef CONFIG_MODULE_SIG
-	.incbin "signing_key.x509"
-#endif
-	.incbin "kernel/x509_certificate_list"
-__cert_list_end:
-
-	.align 8
-	.globl VMLINUX_SYMBOL(system_certificate_list_size)
-VMLINUX_SYMBOL(system_certificate_list_size):
-#ifdef CONFIG_64BIT
-	.quad __cert_list_end - __cert_list_start
-#else
-	.long __cert_list_end - __cert_list_start
-#endif
diff --git a/kernel/system_keyring.c b/kernel/system_keyring.c
deleted file mode 100644
index 2570598b784d..000000000000
--- a/kernel/system_keyring.c
+++ /dev/null
@@ -1,157 +0,0 @@
-/* System trusted keyring for trusted public keys
- *
- * Copyright (C) 2012 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public Licence
- * as published by the Free Software Foundation; either version
- * 2 of the Licence, or (at your option) any later version.
- */
-
-#include <linux/export.h>
-#include <linux/kernel.h>
-#include <linux/sched.h>
-#include <linux/cred.h>
-#include <linux/err.h>
-#include <keys/asymmetric-type.h>
-#include <keys/system_keyring.h>
-#include <crypto/pkcs7.h>
-
-struct key *system_trusted_keyring;
-EXPORT_SYMBOL_GPL(system_trusted_keyring);
-
-extern __initconst const u8 system_certificate_list[];
-extern __initconst const unsigned long system_certificate_list_size;
-
-/*
- * Load the compiled-in keys
- */
-static __init int system_trusted_keyring_init(void)
-{
-	pr_notice("Initialise system trusted keyring\n");
-
-	system_trusted_keyring =3D
-		keyring_alloc(".system_keyring",
-			      KUIDT_INIT(0), KGIDT_INIT(0), current_cred(),
-			      ((KEY_POS_ALL & ~KEY_POS_SETATTR) |
-			      KEY_USR_VIEW | KEY_USR_READ | KEY_USR_SEARCH),
-			      KEY_ALLOC_NOT_IN_QUOTA, NULL);
-	if (IS_ERR(system_trusted_keyring))
-		panic("Can't allocate system trusted keyring\n");
-
-	set_bit(KEY_FLAG_TRUSTED_ONLY, &system_trusted_keyring->flags);
-	return 0;
-}
-
-/*
- * Must be initialised before we try and load the keys into the keyrin=
g.
- */
-device_initcall(system_trusted_keyring_init);
-
-/*
- * Load the compiled-in list of X.509 certificates.
- */
-static __init int load_system_certificate_list(void)
-{
-	key_ref_t key;
-	const u8 *p, *end;
-	size_t plen;
-
-	pr_notice("Loading compiled-in X.509 certificates\n");
-
-	p =3D system_certificate_list;
-	end =3D p + system_certificate_list_size;
-	while (p < end) {
-		/* Each cert begins with an ASN.1 SEQUENCE tag and must be more
-		 * than 256 bytes in size.
-		 */
-		if (end - p < 4)
-			goto dodgy_cert;
-		if (p[0] !=3D 0x30 &&
-		    p[1] !=3D 0x82)
-			goto dodgy_cert;
-		plen =3D (p[2] << 8) | p[3];
-		plen +=3D 4;
-		if (plen > end - p)
-			goto dodgy_cert;
-
-		key =3D key_create_or_update(make_key_ref(system_trusted_keyring, 1)=
,
-					   "asymmetric",
-					   NULL,
-					   p,
-					   plen,
-					   ((KEY_POS_ALL & ~KEY_POS_SETATTR) |
-					   KEY_USR_VIEW | KEY_USR_READ),
-					   KEY_ALLOC_NOT_IN_QUOTA |
-					   KEY_ALLOC_TRUSTED);
-		if (IS_ERR(key)) {
-			pr_err("Problem loading in-kernel X.509 certificate (%ld)\n",
-			       PTR_ERR(key));
-		} else {
-			set_bit(KEY_FLAG_BUILTIN, &key_ref_to_ptr(key)->flags);
-			pr_notice("Loaded X.509 cert '%s'\n",
-				  key_ref_to_ptr(key)->description);
-			key_ref_put(key);
-		}
-		p +=3D plen;
-	}
-
-	return 0;
-
-dodgy_cert:
-	pr_err("Problem parsing in-kernel X.509 certificate list\n");
-	return 0;
-}
-late_initcall(load_system_certificate_list);
-
-#ifdef CONFIG_SYSTEM_DATA_VERIFICATION
-
-/**
- * Verify a PKCS#7-based signature on system data.
- * @data: The data to be verified.
- * @len: Size of @data.
- * @raw_pkcs7: The PKCS#7 message that is the signature.
- * @pkcs7_len: The size of @raw_pkcs7.
- * @usage: The use to which the key is being put.
- */
-int system_verify_data(const void *data, unsigned long len,
-		       const void *raw_pkcs7, size_t pkcs7_len,
-		       enum key_being_used_for usage)
-{
-	struct pkcs7_message *pkcs7;
-	bool trusted;
-	int ret;
-
-	pkcs7 =3D pkcs7_parse_message(raw_pkcs7, pkcs7_len);
-	if (IS_ERR(pkcs7))
-		return PTR_ERR(pkcs7);
-
-	/* The data should be detached - so we need to supply it. */
-	if (pkcs7_supply_detached_data(pkcs7, data, len) < 0) {
-		pr_err("PKCS#7 signature with non-detached data\n");
-		ret =3D -EBADMSG;
-		goto error;
-	}
-
-	ret =3D pkcs7_verify(pkcs7, usage);
-	if (ret < 0)
-		goto error;
-
-	ret =3D pkcs7_validate_trust(pkcs7, system_trusted_keyring, &trusted)=
;
-	if (ret < 0)
-		goto error;
-
-	if (!trusted) {
-		pr_err("PKCS#7 signature not signed with a trusted key\n");
-		ret =3D -ENOKEY;
-	}
-
-error:
-	pkcs7_free_message(pkcs7);
-	pr_devel("<=3D=3D%s() =3D %d\n", __func__, ret);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(system_verify_data);
-
-#endif /* CONFIG_SYSTEM_DATA_VERIFICATION */
