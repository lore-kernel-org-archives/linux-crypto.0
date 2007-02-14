From: David Howells <dhowells@redhat.com>
Subject: [PATCH 6/6] MODSIGN: Apply signature checking to modules on module
	load
Date: Wed, 14 Feb 2007 19:10:09 +0000
Message-ID: <20070214191009.6438.46785.stgit@warthog.cambridge.redhat.com>
References: <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, davej@redhat.com,
	arjan@infradead.org, linux-crypto@vger.kernel.org,
	dhowells@redhat.com
To: torvalds@osdl.org, akpm@osdl.org, herbert.xu@redhat.com
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932481AbXBNTLP@vger.kernel.org>
In-Reply-To: <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Apply signature checking to modules on module load, checking the signature
against the ring of public keys compiled into the kernel (if enabled by
CONFIG_MODULE_SIG).  Turning on signature checking will also force the module's
ELF metadata to be verified first.

These patches have been in use by RHEL and Fedora kernels for years, and so
have been thoroughly tested.  The signed modules survive both the debuginfo
separation performed by rpmbuild and the strip performed when modules are being
reduced as much as possible before being included in an initial ramdisk
composition.  Signed modules have been tested to work with LE and BE, 32- and
64-bit arch kernels, including i386, x86_64, ppc64, ia64, s390 and s390x.

There are several reasons why these patches are useful, amongst which are:

 (1) to protect against accidentally-corrupted modules causing damage;

 (2) to protect against maliciously modified modules causing damage;

 (3) to allow a sysadmin (or more likely an IT department) to enforce a policy
     that only known and approved modules shall be loaded onto machines which
     they're expected to support;

 (4) to allow other support providers to do likewise, or at least to _detect_
     the fact that unsupported modules are loaded;

 (5) to allow the detection of modules replaced by a second-order distro or a
     preloaded Linux purveyor.

Basically, these patches have two main appeals to me: (a) preventing malicious
modules from being loaded, and (b) reducing support workload by pointing out
modules on a crashing box that aren't what they're expected to be.

Now, this is not a complete solution by any means: the core kernel is not
protected, and nor are /dev/mem or /dev/kmem, but it denies (or at least
controls) one relatively simple attack vector.

This facility is optional: the builder of a kernel is by no means under any
requirement to actually enable it, let alone force the set of loadable modules
to be restricted to just those that the builder provides (there are degrees of
restriction available).


Use of the module signing facility is documentated in:

	Documentation/module-signing.txt

which I've included here for reference:

			==============================
			KERNEL MODULE SIGNING FACILITY
			==============================

The module signing facilitiy applies cryptographic signature checking to
modules on module load, checking the signature against a ring of public keys
compiled into the kernel.  GPG is used to do the cryptographic work and
determines the format of the signature and key data.  The facility uses GPG's
MPI library to handle the huge numbers involved.

This facility is enabled through CONFIG_MODULE_SIG.  Turning on signature
checking will also force the module's ELF metadata to be verified before the
signature is checked.


=====================
SUPPLYING PUBLIC KEYS
=====================

A set of public keys must be supplied at main kernel compile time.  This is
done by taking a GPG public key file, running it through the kernel's bin2c
program and writing the result over crypto/signature/key.h.  To automate this
process, something like this could be done:

	cat >genkey <<EOF
	%pubring kernel.pub
	%secring kernel.sec
	Key-Type: DSA
	Key-Length: 512
	Name-Real: A. N. Other
	Name-Comment: Kernel Module GPG key
	%commit
	EOF
	make scripts/bin2c
	gpg --homedir . --batch --gen-key genkey
	gpg --homedir . --export --keyring kernel.pub keyname |
	 scripts/bin2c ksign_def_public_key __initdata >crypto/signature/key.h

The above generates fresh keys using /dev/random.  If there's insufficient data
in /dev/random, more can be provided more by running:

	rngd -r /dev/urandom

in the background.

Note:

 (1) That "keyname" is the name of the key in the keyring.  This differentiates
     it from any other keys that may be added to the keyring.

 (2) That no GPG password is used in the above scriptlet.

 (3) It may be desirable to shred and delete the private key file after signing
     the modules.


==============
MODULE SIGNING
==============

Modules will then be signed automatically.  The kernel make command line can
include the following options:

 (*) MODSECKEY=<secret-key-ring-path>

     This indicates the whereabouts of the GPG keyring that is the source of
     the secret key to be used.  The default is "./kernel.sec".

 (*) MODPUBKEY=<public-key-ring-path>

     This indicates the whereabouts of the GPG keyring that is the source of
     the public key to be used.  The default is "./kernel.pub".

 (*) MODKEYNAME=<key-name>

     The name of the key pair to be used from the aforementioned keyrings.
     This defaults to being unset, thus leaving the choice of default key to
     gpg.

 (*) KEYFLAGS="gpg-options"

     Override the complete gpg command line, including the preceding three
     options.  The default options supplied to gpg are:

	--no-default-keyring
	--secret-keyring $(MODSECKEY)
	--keyring $(MODPUBKEY)
	--no-default-keyring
	--homedir .
	--no-options
	--no-auto-check-trustdb
	--no-permission-warning

      with:

	--default-key $(MODKEYNAME)

      being added if requested.

The resulting module.ko file will be the signed module.


========================
STRIPPING SIGNED MODULES
========================

Signed modules may be safely stripped as the signature only covers those parts
of the module the kernel actually uses and any ELF metadata required to deal
with them.  Any necessary ELF metadata that is affected by stripping is
canonicalised by the sig generator and the sig checker to hide strip effects.

This permits the debuginfo to be detached from the module and placed in another
spot so that gdb can find it when referring to that module without the need for
multiple signed versions of the module.  Such is done by rpmbuild when
producing RPMs.

It also permits the module to be stripped as far as possible for when modules
are being reduced prior to being included in an initial ramdisk composition.


======================
LOADING SIGNED MODULES
======================

Modules are loaded with insmod, exactly as for unsigned modules.  The signature
is inserted into the module object file as an ELF section called ".module_sig".
The signature checker will spot it and apply signature checking.


=========================================
NON-VALID SIGNATURES AND UNSIGNED MODULES
=========================================

If CONFIG_MODULE_SIG_FORCE is enabled or "enforcemodulesig=1" is supplied on
the kernel command line, the kernel will _only_ load validly signed modules
for which it has a public key.  Otherwise, it will also load modules that are
unsigned.  Any module for which the kernel has a key, but which proves to have
a signature mismatch will not be permitted to load (returning EKEYREJECTED).

This table indicates the behaviours of the various situations:

	MODULE STATE			PERMISSIVE MODE	ENFORCING MODE
	===============================	===============	===============
	Unsigned			Ok		EKEYREJECTED
	Signed, no public key		ENOKEY		ENOKEY
	Validly signed, public key	Ok		Ok
	Invalidly signed, public key	EKEYREJECTED	EKEYREJECTED
	Validly signed, expired key	EKEYEXPIRED	EKEYEXPIRED
	Corrupt signature		ELIBBAD		ELIBBAD
	Corrupt ELF			ELIBBAD		ELIBBAD


Signed-Off-By: David Howells <dhowells@redhat.com>
---

 .gitignore                       |    9 
 Documentation/module-signing.txt |  147 ++++++
 Makefile                         |    7 
 include/linux/module.h           |    3 
 init/Kconfig                     |   22 +
 kernel/Makefile                  |    1 
 kernel/module-verify-sig.c       |  455 +++++++++++++++++++
 kernel/module-verify.c           |    5 
 kernel/module-verify.h           |   17 +
 kernel/module.c                  |   12 -
 scripts/Makefile.modpost         |   36 +-
 scripts/mod/.gitignore           |    1 
 scripts/mod/Makefile             |    2 
 scripts/mod/mod-extract.c        |  890 ++++++++++++++++++++++++++++++++++++++
 14 files changed, 1596 insertions(+), 11 deletions(-)

diff --git a/.gitignore b/.gitignore
index 060a71d..144cd50 100644
--- a/.gitignore
+++ b/.gitignore
@@ -9,6 +9,9 @@
 *.o
 *.a
 *.s
+*.ko.unsigned
+*.ko.out
+*.ko.out.sig
 *.ko
 *.so
 *.mod.c
@@ -45,3 +48,9 @@ series
 
 # cscope files
 cscope.*
+
+#
+# GPG leavings from module signing
+#
+trustdb.gpg
+random_seed
diff --git a/Documentation/module-signing.txt b/Documentation/module-signing.txt
new file mode 100644
index 0000000..ae7c4f9
--- /dev/null
+++ b/Documentation/module-signing.txt
@@ -0,0 +1,147 @@
+			==============================
+			KERNEL MODULE SIGNING FACILITY
+			==============================
+
+The module signing facility applies cryptographic signature checking to modules
+on module load, checking the signature against a ring of public keys compiled
+into the kernel.  GPG is used to do the cryptographic work and determines the
+format of the signature and key data.  The facility uses GPG's MPI library to
+handle the huge numbers involved.
+
+This facility is enabled through CONFIG_MODULE_SIG.  Turning on signature
+checking will also force the module's ELF metadata to be verified before the
+signature is checked.
+
+
+=====================
+SUPPLYING PUBLIC KEYS
+=====================
+
+A set of public keys must be supplied at main kernel compile time.  This is
+done by taking a GPG public key file, running it through the kernel's bin2c
+program and writing the result over crypto/signature/key.h.  To automate this
+process, something like this could be done:
+
+	cat >genkey <<EOF
+	%pubring kernel.pub
+	%secring kernel.sec
+	Key-Type: DSA
+	Key-Length: 512
+	Name-Real: A. N. Other
+	Name-Comment: Kernel Module GPG key
+	%commit
+	EOF
+	make scripts/bin2c
+	gpg --homedir . --batch --gen-key genkey
+	gpg --homedir . --export --keyring kernel.pub keyname |
+	 scripts/bin2c ksign_def_public_key __initdata >crypto/signature/key.h
+
+The above generates fresh keys using /dev/random.  If there's insufficient data
+in /dev/random, more can be provided more by running:
+
+	rngd -r /dev/urandom
+
+in the background.
+
+Note:
+
+ (1) That "keyname" is the name of the key in the keyring.  This differentiates
+     it from any other keys that may be added to the keyring.
+
+ (2) That no GPG password is used in the above scriptlet.
+
+
+==============
+MODULE SIGNING
+==============
+
+Modules will then be signed automatically.  The kernel make command line can
+include the following options:
+
+ (*) MODSECKEY=<secret-key-ring-path>
+
+     This indicates the whereabouts of the GPG keyring that is the source of
+     the secret key to be used.  The default is "./kernel.sec".
+
+ (*) MODPUBKEY=<public-key-ring-path>
+
+     This indicates the whereabouts of the GPG keyring that is the source of
+     the public key to be used.  The default is "./kernel.pub".
+
+ (*) MODKEYNAME=<key-name>
+
+     The name of the key pair to be used from the aforementioned keyrings.
+     This defaults to being unset, thus leaving the choice of default key to
+     gpg.
+
+ (*) KEYFLAGS="gpg-options"
+
+     Override the complete gpg command line, including the preceding three
+     options.  The default options supplied to gpg are:
+
+	--no-default-keyring
+	--secret-keyring $(MODSECKEY)
+	--keyring $(MODPUBKEY)
+	--no-default-keyring
+	--homedir .
+	--no-options
+	--no-auto-check-trustdb
+	--no-permission-warning
+
+      with:
+
+	--default-key $(MODKEYNAME)
+
+      being added if requested.
+
+The resulting module.ko file will be the signed module.
+
+
+========================
+STRIPPING SIGNED MODULES
+========================
+
+Signed modules may be safely stripped as the signature only covers those parts
+of the module the kernel actually uses and any ELF metadata required to deal
+with them.  Any necessary ELF metadata that is affected by stripping is
+canonicalised by the sig generator and the sig checker to hide strip effects.
+
+This permits the debuginfo to be detached from the module and placed in another
+spot so that gdb can find it when referring to that module without the need for
+multiple signed versions of the module.  Such is done by rpmbuild when
+producing RPMs.
+
+It also permits the module to be stripped as far as possible for when modules
+are being reduced prior to being included in an initial ramdisk composition.
+
+
+======================
+LOADING SIGNED MODULES
+======================
+
+Modules are loaded with insmod, exactly as for unsigned modules.  The signature
+is inserted into the module object file as an ELF section called ".module_sig".
+The signature checker will spot it and apply signature checking.
+
+
+=========================================
+NON-VALID SIGNATURES AND UNSIGNED MODULES
+=========================================
+
+If CONFIG_MODULE_SIG_FORCE is enabled or "enforcemodulesig=1" is supplied on
+the kernel command line, the kernel will _only_ load validly signed modules
+for which it has a public key.  Otherwise, it will also load modules that are
+unsigned.  Any module for which the kernel has a key, but which proves to have
+a signature mismatch will not be permitted to load (returning EKEYREJECTED).
+
+This table indicates the behaviours of the various situations:
+
+	MODULE STATE			PERMISSIVE MODE	ENFORCING MODE
+	===============================	===============	===============
+	Unsigned			Ok		EKEYREJECTED
+	Signed, no public key		ENOKEY		ENOKEY
+	Validly signed, public key	Ok		Ok
+	Invalidly signed, public key	EKEYREJECTED	EKEYREJECTED
+	Validly signed, expired key	EKEYEXPIRED	EKEYEXPIRED
+	Corrupt signature		ELIBBAD		ELIBBAD
+	Corrupt ELF			ELIBBAD		ELIBBAD
diff --git a/Makefile b/Makefile
index 7e4968f..efbb768 100644
--- a/Makefile
+++ b/Makefile
@@ -1041,7 +1041,8 @@ clean: archclean $(clean-dirs)
 	@find . $(RCS_FIND_IGNORE) \
 		\( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
 		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
-		-o -name '*.symtypes' \) \
+		-o -name '*.symtypes' -o -name '*.ko.unsigned' \
+		-o -name "*.ko.out" -o -name "*.ko.out.sig" \) \
 		-type f -print | xargs rm -f
 
 # mrproper - Delete all generated files, including .config
@@ -1229,7 +1230,9 @@ clean: $(clean-dirs)
 	$(call cmd,rmdirs)
 	@find $(KBUILD_EXTMOD) $(RCS_FIND_IGNORE) \
 		\( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
-		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \) \
+		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
+		-o -name '*.ko.unsigned' -o -name "*.ko.out" \
+		-o -name "*.ko.out.sig" \) \
 		-type f -print | xargs rm -f
 
 help:
diff --git a/include/linux/module.h b/include/linux/module.h
index 419d3ef..aaae69a 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -327,6 +327,9 @@ struct module
 	unsigned num_bugs;
 #endif
 
+	/* Is this module GPG signed */
+	int gpgsig_ok;
+
 #ifdef CONFIG_MODULE_UNLOAD
 	/* Reference counts */
 	struct module_ref ref[NR_CPUS];
diff --git a/init/Kconfig b/init/Kconfig
index 0013f45..246b9cc 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -559,10 +559,30 @@ config MODULE_VERIFY_ELF
 	help
 	  Check ELF structure of modules upon load
 
+config MODULE_SIG
+	bool "Module signature verification (EXPERIMENTAL)"
+	depends on MODULES && EXPERIMENTAL
+	select CRYPTO
+	select CRYPTO_SHA1
+	select CRYPTO_SIGNATURE
+	select MODULE_VERIFY_ELF
+	help
+	  Check modules for valid signatures upon load.  For more information
+	  see:
+
+	  Documentation/module-signing.txt
+
+config MODULE_SIG_FORCE
+	bool "Required modules to be validly signed (EXPERIMENTAL)"
+	depends on MODULE_SIG
+	help
+	  Reject unsigned modules or signed modules for which we don't have a
+	  key.
+
 config MODULE_VERIFY
 	bool
 	depends on MODULES
-	default y if MODULE_VERIFY_ELF
+	default y if MODULE_VERIFY_ELF || MODULE_SIG
 
 config KMOD
 	bool "Automatic kernel module loading"
diff --git a/kernel/Makefile b/kernel/Makefile
index 5ed0824..715da89 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -32,6 +32,7 @@ obj-$(CONFIG_UID16) += uid16.o
 obj-$(CONFIG_MODULES) += module.o
 obj-$(CONFIG_MODULE_VERIFY) += module-verify.o
 obj-$(CONFIG_MODULE_VERIFY_ELF) += module-verify-elf.o
+obj-$(CONFIG_MODULE_SIG) += module-verify-sig.o
 obj-$(CONFIG_KALLSYMS) += kallsyms.o
 obj-$(CONFIG_PM) += power/
 obj-$(CONFIG_BSD_PROCESS_ACCT) += acct.o
diff --git a/kernel/module-verify-sig.c b/kernel/module-verify-sig.c
new file mode 100644
index 0000000..23e812b
--- /dev/null
+++ b/kernel/module-verify-sig.c
@@ -0,0 +1,455 @@
+/* module-verify-sig.c: module signature checker
+ *
+ * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ * - Derived from GregKH's RSA module signer
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/elf.h>
+#include <linux/crypto.h>
+#include <linux/crypto/ksign.h>
+#include "module-verify.h"
+
+#undef MODSIGN_DEBUG
+
+#ifdef MODSIGN_DEBUG
+#define _debug(FMT, ...) printk(FMT, ##__VA_ARGS__)
+#else
+#define _debug(FMT, ...) do {} while (0)
+#endif
+
+#ifdef MODSIGN_DEBUG
+#define count_and_csum(C, __p,__n)			\
+do {							\
+	int __loop;					\
+	for (__loop = 0; __loop < __n; __loop++) {	\
+		(C)->csum += __p[__loop];		\
+		(C)->xcsum += __p[__loop];		\
+	}						\
+	(C)->signed_size += __n;			\
+} while(0)
+#else
+#define count_and_csum(C, __p,__n)		\
+do {						\
+	(C)->signed_size += __n;		\
+} while(0)
+#endif
+
+#define crypto_digest_update_data(C,PTR,N)			\
+do {								\
+	size_t __n = (N);					\
+	uint8_t *__p = (uint8_t *)(PTR);			\
+	count_and_csum((C), __p, __n);				\
+	crypto_hash_update_kernel(&(C)->hash, __p, __n);	\
+} while(0)
+
+#define crypto_digest_update_val(C,VAL)				\
+do {								\
+	size_t __n = sizeof(VAL);				\
+	uint8_t *__p = (uint8_t *)&(VAL);			\
+	count_and_csum((C), __p, __n);				\
+	crypto_hash_update_kernel(&(C)->hash, __p, __n);	\
+} while(0)
+
+static int module_verify_canonicalise(struct module_verify_data *mvdata);
+
+static int extract_elf_rela(struct module_verify_data *mvdata,
+			    int secix,
+			    const Elf_Rela *relatab, size_t nrels,
+			    const char *sh_name);
+
+static int extract_elf_rel(struct module_verify_data *mvdata,
+			   int secix,
+			   const Elf_Rel *reltab, size_t nrels,
+			   const char *sh_name);
+
+#ifdef CONFIG_MODULE_SIG_FORCE
+static int signedonly = 1;
+#else
+static int signedonly;
+#endif
+
+static int __init sign_setup(char *str)
+{
+	signedonly = 1;
+	return 0;
+}
+__setup("enforcemodulesig", sign_setup);
+
+/*
+ * verify a module's signature
+ */
+int module_verify_signature(struct module_verify_data *mvdata,
+			    int *_gpgsig_ok)
+{
+	const Elf_Shdr *sechdrs = mvdata->sections;
+	const char *secstrings = mvdata->secstrings;
+	const char *sig;
+	unsigned sig_size;
+	int i, ret;
+
+	for (i = 1; i < mvdata->nsects; i++) {
+		switch (sechdrs[i].sh_type) {
+		case SHT_PROGBITS:
+			if (strcmp(mvdata->secstrings + sechdrs[i].sh_name,
+				   ".module_sig") == 0) {
+				mvdata->sig_index = i;
+			}
+			break;
+		}
+	}
+
+	if (mvdata->sig_index <= 0)
+		goto no_signature;
+
+	sig = mvdata->buffer + sechdrs[mvdata->sig_index].sh_offset;
+	sig_size = sechdrs[mvdata->sig_index].sh_size;
+
+	_debug("sig in section %d (size %d)\n",
+	       mvdata->sig_index, sig_size);
+
+	/* produce a canonicalisation map for the sections */
+	ret = module_verify_canonicalise(mvdata);
+	if (ret < 0)
+		return ret;
+
+	/* grab an SHA1 transformation context
+	 * - !!! if this tries to load the sha1.ko module, we will deadlock!!!
+	 */
+	mvdata->hash.tfm = crypto_hash_cast(crypto_alloc_tfm2("sha1", 0, 1));
+	if (!mvdata->hash.tfm) {
+		printk("Couldn't load module - SHA1 transform unavailable\n");
+		return -EPERM;
+	}
+
+	crypto_hash_init(&mvdata->hash);
+
+#ifdef MODSIGN_DEBUG
+	mvdata->xcsum = 0;
+#endif
+
+	/* load data from each relevant section into the digest */
+	for (i = 1; i < mvdata->nsects; i++) {
+		unsigned long sh_type = sechdrs[i].sh_type;
+		unsigned long sh_info = sechdrs[i].sh_info;
+		unsigned long sh_size = sechdrs[i].sh_size;
+		unsigned long sh_flags = sechdrs[i].sh_flags;
+		const char *sh_name = secstrings + sechdrs[i].sh_name;
+		const void *data = mvdata->buffer + sechdrs[i].sh_offset;
+
+		if (i == mvdata->sig_index)
+			continue;
+
+#ifdef MODSIGN_DEBUG
+		mvdata->csum = 0;
+#endif
+
+		/* it would be nice to include relocation sections, but the act
+		 * of adding a signature to the module seems changes their
+		 * contents, because the symtab gets changed when sections are
+		 * added or removed */
+		if (sh_type == SHT_REL || sh_type == SHT_RELA) {
+			if (mvdata->canonlist[sh_info]) {
+				uint32_t xsh_info = mvdata->canonmap[sh_info];
+
+				crypto_digest_update_data(mvdata, sh_name, strlen(sh_name));
+				crypto_digest_update_val(mvdata, sechdrs[i].sh_type);
+				crypto_digest_update_val(mvdata, sechdrs[i].sh_flags);
+				crypto_digest_update_val(mvdata, sechdrs[i].sh_size);
+				crypto_digest_update_val(mvdata, sechdrs[i].sh_addralign);
+				crypto_digest_update_val(mvdata, xsh_info);
+
+				if (sh_type == SHT_RELA)
+					ret = extract_elf_rela(
+						mvdata, i,
+						data,
+						sh_size / sizeof(Elf_Rela),
+						sh_name);
+				else
+					ret = extract_elf_rel(
+						mvdata, i,
+						data,
+						sh_size / sizeof(Elf_Rel),
+						sh_name);
+
+				if (ret < 0)
+					goto format_error;
+			}
+
+			continue;
+		}
+
+		/* include allocatable loadable sections */
+		if (sh_type != SHT_NOBITS && sh_flags & SHF_ALLOC)
+			goto include_section;
+
+		continue;
+
+	include_section:
+		crypto_digest_update_data(mvdata, sh_name, strlen(sh_name));
+		crypto_digest_update_val(mvdata, sechdrs[i].sh_type);
+		crypto_digest_update_val(mvdata, sechdrs[i].sh_flags);
+		crypto_digest_update_val(mvdata, sechdrs[i].sh_size);
+		crypto_digest_update_val(mvdata, sechdrs[i].sh_addralign);
+		crypto_digest_update_data(mvdata, data, sh_size);
+
+		_debug("%08zx %02x digested the %s section, size %ld\n",
+		       mvdata->signed_size, mvdata->csum, sh_name, sh_size);
+
+		mvdata->canonlist[i] = 1;
+	}
+
+	_debug("Contributed %zu bytes to the digest (csum 0x%02x)\n",
+	       mvdata->signed_size, mvdata->xcsum);
+
+	/* do the actual signature verification */
+	ret = ksign_verify_signature(sig, sig_size, mvdata->hash.tfm);
+
+	_debug("verify-sig : %d\n", ret);
+
+	switch (ret) {
+	case 0:			/* good signature */
+		*_gpgsig_ok = 1;
+		break;
+	case -EKEYREJECTED:	/* signature mismatch or number format error */
+		printk(KERN_ERR "Module signature verification failed\n");
+		break;
+	case -ENOKEY:		/* signed, but we don't have the public key */
+		printk(KERN_ERR "Module signed with unknown public key\n");
+		break;
+	default:		/* other error (probably ENOMEM) */
+		break;
+	}
+
+	return ret;
+
+format_error:
+	crypto_free_hash(mvdata->hash.tfm);
+	printk(KERN_ERR "Module format error encountered\n");
+	return -ELIBBAD;
+
+	/* deal with the case of an unsigned module */
+no_signature:
+ 	if (!signedonly)
+		return 0;
+	printk(KERN_ERR "An attempt to load unsigned module was rejected\n");
+	return -EKEYREJECTED;
+}
+
+/*
+ * canonicalise the section table index numbers
+ */
+static int module_verify_canonicalise(struct module_verify_data *mvdata)
+{
+	int canon, loop, changed, tmp;
+
+	/* produce a list of index numbers of sections that contribute
+	 * to the kernel's module image
+	 */
+	mvdata->canonlist =
+		kmalloc(sizeof(int) * mvdata->nsects * 2, GFP_KERNEL);
+	if (!mvdata->canonlist)
+		return -ENOMEM;
+
+	mvdata->canonmap = mvdata->canonlist + mvdata->nsects;
+	canon = 0;
+
+	for (loop = 1; loop < mvdata->nsects; loop++) {
+		const Elf_Shdr *section = mvdata->sections + loop;
+
+		if (loop != mvdata->sig_index) {
+			/* we only need to canonicalise allocatable sections */
+			if (section->sh_flags & SHF_ALLOC)
+				mvdata->canonlist[canon++] = loop;
+		}
+	}
+
+	/* canonicalise the index numbers of the contributing section */
+	do {
+		changed = 0;
+
+		for (loop = 0; loop < canon - 1; loop++) {
+			const char *x, *y;
+
+			x = mvdata->secstrings +
+				mvdata->sections[mvdata->canonlist[loop + 0]].sh_name;
+			y = mvdata->secstrings +
+				mvdata->sections[mvdata->canonlist[loop + 1]].sh_name;
+
+			if (strcmp(x, y) > 0) {
+				tmp = mvdata->canonlist[loop + 0];
+				mvdata->canonlist[loop + 0] =
+					mvdata->canonlist[loop + 1];
+				mvdata->canonlist[loop + 1] = tmp;
+				changed = 1;
+			}
+		}
+
+	} while(changed);
+
+	for (loop = 0; loop < canon; loop++)
+		mvdata->canonmap[mvdata->canonlist[loop]] = loop + 1;
+
+	return 0;
+}
+
+/*
+ * extract an ELF RELA table
+ * - need to canonicalise the entries in case section addition/removal has
+ *   rearranged the symbol table and the section table
+ */
+static int extract_elf_rela(struct module_verify_data *mvdata,
+			    int secix,
+			    const Elf_Rela *relatab, size_t nrels,
+			    const char *sh_name)
+{
+	struct {
+#if defined(MODULES_ARE_ELF32)
+		uint32_t	r_offset;
+		uint32_t	r_addend;
+		uint32_t	st_value;
+		uint32_t	st_size;
+		uint16_t	st_shndx;
+		uint8_t		r_type;
+		uint8_t		st_info;
+		uint8_t		st_other;
+#elif defined(MODULES_ARE_ELF64)
+		uint64_t	r_offset;
+		uint64_t	r_addend;
+		uint64_t	st_value;
+		uint64_t	st_size;
+		uint32_t	r_type;
+		uint16_t	st_shndx;
+		uint8_t		st_info;
+		uint8_t		st_other;
+#else
+#error unsupported module type
+#endif
+	} __attribute__((packed)) relocation;
+
+	const Elf_Rela *reloc;
+	const Elf_Sym *symbol;
+	size_t loop;
+
+	/* contribute the relevant bits from a join of { RELA, SYMBOL, SECTION } */
+	for (loop = 0; loop < nrels; loop++) {
+		int st_shndx;
+
+		reloc = &relatab[loop];
+
+		/* decode the relocation */
+		relocation.r_offset = reloc->r_offset;
+		relocation.r_addend = reloc->r_addend;
+		relocation.r_type = ELF_R_TYPE(reloc->r_info);
+
+		/* decode the symbol referenced by the relocation */
+		symbol = &mvdata->symbols[ELF_R_SYM(reloc->r_info)];
+		relocation.st_info = symbol->st_info;
+		relocation.st_other = symbol->st_other;
+		relocation.st_value = symbol->st_value;
+		relocation.st_size = symbol->st_size;
+		relocation.st_shndx = symbol->st_shndx;
+		st_shndx = symbol->st_shndx;
+
+		/* canonicalise the section used by the symbol */
+		if (st_shndx > SHN_UNDEF && st_shndx < mvdata->nsects)
+			relocation.st_shndx = mvdata->canonmap[st_shndx];
+
+		crypto_digest_update_val(mvdata, relocation);
+
+		/* undefined symbols must be named if referenced */
+		if (st_shndx == SHN_UNDEF) {
+			const char *name = mvdata->strings + symbol->st_name;
+			crypto_digest_update_data(mvdata,
+						  name, strlen(name) + 1);
+		}
+	}
+
+	_debug("%08zx %02x digested the %s section, nrels %zu\n",
+	       mvdata->signed_size, mvdata->csum, sh_name, nrels);
+
+	return 0;
+}
+
+/*
+ * extract an ELF REL table
+ * - need to canonicalise the entries in case section addition/removal has
+ *   rearranged the symbol table and the section table
+ */
+static int extract_elf_rel(struct module_verify_data *mvdata,
+			   int secix,
+			   const Elf_Rel *reltab, size_t nrels,
+			   const char *sh_name)
+{
+	struct {
+#if defined(MODULES_ARE_ELF32)
+		uint32_t	r_offset;
+		uint32_t	st_value;
+		uint32_t	st_size;
+		uint16_t	st_shndx;
+		uint8_t		r_type;
+		uint8_t		st_info;
+		uint8_t		st_other;
+#elif defined(MODULES_ARE_ELF64)
+		uint64_t	r_offset;
+		uint64_t	st_value;
+		uint64_t	st_size;
+		uint32_t	r_type;
+		uint16_t	st_shndx;
+		uint8_t		st_info;
+		uint8_t		st_other;
+#else
+#error unsupported module type
+#endif
+	} __attribute__((packed)) relocation;
+
+	const Elf_Rel *reloc;
+	const Elf_Sym *symbol;
+	size_t loop;
+
+	/* contribute the relevant bits from a join of { RELA, SYMBOL, SECTION } */
+	for (loop = 0; loop < nrels; loop++) {
+		int st_shndx;
+
+		reloc = &reltab[loop];
+
+		/* decode the relocation */
+		relocation.r_offset = reloc->r_offset;
+		relocation.r_type = ELF_R_TYPE(reloc->r_info);
+
+		/* decode the symbol referenced by the relocation */
+		symbol = &mvdata->symbols[ELF_R_SYM(reloc->r_info)];
+		relocation.st_info = symbol->st_info;
+		relocation.st_other = symbol->st_other;
+		relocation.st_value = symbol->st_value;
+		relocation.st_size = symbol->st_size;
+		relocation.st_shndx = symbol->st_shndx;
+		st_shndx = symbol->st_shndx;
+
+		/* canonicalise the section used by the symbol */
+		if (st_shndx > SHN_UNDEF && st_shndx < mvdata->nsects)
+			relocation.st_shndx = mvdata->canonmap[st_shndx];
+
+		crypto_digest_update_val(mvdata, relocation);
+
+		/* undefined symbols must be named if referenced */
+		if (st_shndx == SHN_UNDEF) {
+			const char *name = mvdata->strings + symbol->st_name;
+			crypto_digest_update_data(mvdata,
+						  name, strlen(name) + 1);
+		}
+	}
+
+	_debug("%08zx %02x digested the %s section, nrels %zu\n",
+	       mvdata->signed_size, mvdata->csum, sh_name, nrels);
+
+	return 0;
+}
diff --git a/kernel/module-verify.c b/kernel/module-verify.c
index 875279f..64c5813 100644
--- a/kernel/module-verify.c
+++ b/kernel/module-verify.c
@@ -16,8 +16,9 @@
 /*
  * verify a module's integrity
  * - check the ELF is viable
+ * - check the module's signature
  */
-int module_verify(const Elf_Ehdr *hdr, size_t size)
+int module_verify(const Elf_Ehdr *hdr, size_t size, int *_gpgsig_ok)
 {
 	struct module_verify_data mvdata;
 	int ret;
@@ -34,6 +35,8 @@ int module_verify(const Elf_Ehdr *hdr, size_t size)
 		goto error;
 	}
 
+	ret = module_verify_signature(&mvdata, _gpgsig_ok);
+
 error:
 	kfree(mvdata.secsizes);
 	kfree(mvdata.canonlist);
diff --git a/kernel/module-verify.h b/kernel/module-verify.h
index 63f5e08..95995b2 100644
--- a/kernel/module-verify.h
+++ b/kernel/module-verify.h
@@ -10,11 +10,12 @@
  */
 
 #include <linux/types.h>
+#include <linux/crypto.h>
 #include <asm/module.h>
 
 #ifdef CONFIG_MODULE_VERIFY
 struct module_verify_data {
-	struct crypto_tfm	*digest;	/* module signature digest */
+	struct hash_desc	hash;		/* module signature digest */
 	const void		*buffer;	/* module buffer */
 	const Elf_Ehdr		*hdr;		/* ELF header */
 	const Elf_Shdr		*sections;	/* ELF section table */
@@ -37,7 +38,7 @@ struct module_verify_data {
 /*
  * module-verify.c
  */
-extern int module_verify(const Elf_Ehdr *hdr, size_t size);
+extern int module_verify(const Elf_Ehdr *hdr, size_t size, int *_gpgsig_ok);
 
 /*
  * module-verify-elf.c
@@ -48,6 +49,16 @@ extern int module_verify_elf(struct module_verify_data *mvdata);
 #define module_verify_elf(m) (0)
 #endif
 
+/*
+ * module-verify-sig.c
+ */
+#ifdef CONFIG_MODULE_SIG
+extern int module_verify_signature(struct module_verify_data *mvdata,
+				   int *_gpgsig_ok);
+#else
+#define module_verify_signature(m, g) (0)
+#endif
+
 #else
-#define module_verify(h, s) (0)
+#define module_verify(h, s, g) (0)
 #endif
diff --git a/kernel/module.c b/kernel/module.c
index 86abdce..c3a1dca 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1581,6 +1581,7 @@ static struct module *load_module(void __user *umod,
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
 	struct exception_table_entry *extable;
 	mm_segment_t old_fs;
+	int gpgsig_ok;
 
 	DEBUGP("load_module: umod=%p, len=%lu, uargs=%p\n",
 	       umod, len, uargs);
@@ -1607,7 +1608,8 @@ static struct module *load_module(void __user *umod,
 	}
 
 	/* Verify the module's contents */
-	err = module_verify(hdr, len);
+	gpgsig_ok = 0;
+	err = module_verify(hdr, len, &gpgsig_ok);
 	if (err < 0)
 		goto free_hdr;
 
@@ -1646,6 +1648,7 @@ static struct module *load_module(void __user *umod,
 		goto free_hdr;
 	}
 	mod = (void *)sechdrs[modindex].sh_addr;
+	mod->gpgsig_ok = gpgsig_ok;
 
 	if (symindex == 0) {
 		printk(KERN_WARNING "%s: module has no symbols (stripped?)\n",
@@ -2343,8 +2346,13 @@ void print_modules(void)
 	char buf[8];
 
 	printk("Modules linked in:");
-	list_for_each_entry(mod, &modules, list)
+	list_for_each_entry(mod, &modules, list) {
 		printk(" %s%s", mod->name, taint_flags(mod->taints, buf));
+#ifdef CONFIG_MODULE_SIG
+		if (!mod->gpgsig_ok)
+			printk("(U)");
+#endif
+	}
 	printk("\n");
 }
 
diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 65e0a79..cd78aed 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -14,7 +14,8 @@
 # 3)  create one <module>.mod.c file pr. module
 # 4)  create one Module.symvers file with CRC for all exported symbols
 # 5) compile all <module>.mod.c files
-# 6) final link of the module to a <module.ko> file
+# 6) final link of the module to a <module.ko> (or <module.unsigned>) file
+# 7) signs the modules to a <module.ko> file
 
 # Step 3 is used to place certain information in the module's ELF
 # section, including information such as:
@@ -32,6 +33,8 @@
 # Step 4 is solely used to allow module versioning in external modules,
 # where the CRC of each module is retrieved from the Module.symers file.
 
+# Step 7 is dependent on CONFIG_MODULE_SIG being enabled.
+
 # KBUILD_MODPOST_WARN can be set to avoid error out in case of undefined
 # symbols in the final module linking stage
 # KBUILD_MODPOST_NOFINAL can be set to skip the final link of modules.
@@ -96,6 +99,7 @@ $(modules:.ko=.mod.o): %.mod.o: %.mod.c FORCE
 targets += $(modules:.ko=.mod.o)
 
 # Step 6), final link of the modules
+ifneq ($(CONFIG_MODULE_SIG),y)
 quiet_cmd_ld_ko_o = LD [M]  $@
       cmd_ld_ko_o = $(LD) $(LDFLAGS) $(LDFLAGS_MODULE) -o $@		\
 			  $(filter-out FORCE,$^)
@@ -104,7 +108,37 @@ $(modules): %.ko :%.o %.mod.o FORCE
 	$(call if_changed,ld_ko_o)
 
 targets += $(modules)
+else
+quiet_cmd_ld_ko_unsigned_o = LD [M]  $@
+      cmd_ld_ko_unsigned_o = $(LD) $(LDFLAGS) $(LDFLAGS_MODULE) -o $@		\
+			  $(filter-out FORCE,$^)
+
+$(modules:.ko=.ko.unsigned): %.ko.unsigned :%.o %.mod.o FORCE
+	$(call if_changed,ld_ko_unsigned_o)
+
+targets += $(modules)
 
+# Step 7), sign the modules
+MODSECKEY = ./kernel.sec
+MODPUBKEY = ./kernel.pub
+KEYFLAGS = --no-default-keyring --secret-keyring $(MODSECKEY) --keyring $(MODPUBKEY) --no-default-keyring --homedir . --no-options --no-auto-check-trustdb --no-permission-warning
+ifdef MODKEYNAME
+KEYFLAGS += --default-key $(MODKEYNAME)
+endif
+
+quiet_cmd_sign_ko_ko_unsigned = SIGN [M] $@
+      cmd_sign_ko_ko_unsigned = \
+		scripts/mod/mod-extract $< $@.out && \
+		rm -f $@.out.sig && \
+		gpg --batch --no-greeting $(KEYFLAGS) -b $@.out && \
+		$(OBJCOPY) --add-section .module_sig=$@.out.sig $< $@ && \
+		$(OBJCOPY) --set-section-flags .module_sig=alloc $@
+
+$(modules): %.ko :%.ko.unsigned FORCE
+	$(call if_changed,sign_ko_ko_unsigned)
+
+targets += $(modules)
+endif
 
 # Add FORCE to the prequisites of a target to force it to be always rebuilt.
 # ---------------------------------------------------------------------------
diff --git a/scripts/mod/.gitignore b/scripts/mod/.gitignore
index e9b7abe..223dfd6 100644
--- a/scripts/mod/.gitignore
+++ b/scripts/mod/.gitignore
@@ -1,4 +1,5 @@
 elfconfig.h
 mk_elfconfig
 modpost
+mod-extract
 
diff --git a/scripts/mod/Makefile b/scripts/mod/Makefile
index 11d69c3..bba0494 100644
--- a/scripts/mod/Makefile
+++ b/scripts/mod/Makefile
@@ -1,4 +1,4 @@
-hostprogs-y	:= modpost mk_elfconfig
+hostprogs-y	:= modpost mk_elfconfig mod-extract
 always		:= $(hostprogs-y) empty.o
 
 modpost-objs	:= modpost.o file2alias.o sumversion.o
diff --git a/scripts/mod/mod-extract.c b/scripts/mod/mod-extract.c
new file mode 100644
index 0000000..b7b5dd1
--- /dev/null
+++ b/scripts/mod/mod-extract.c
@@ -0,0 +1,890 @@
+/* mod-extract.c: module extractor for signing
+ *
+ * Copyright (C) 2004 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdint.h>
+#include <stdarg.h>
+#include <string.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <elf.h>
+#include <asm/byteorder.h>
+
+void extract_elf64(void *buffer, size_t size, Elf64_Ehdr *hdr);
+void extract_elf32(void *buffer, size_t size, Elf32_Ehdr *hdr);
+
+struct byteorder {
+	uint16_t (*get16)(const uint16_t *);
+	uint32_t (*get32)(const uint32_t *);
+	uint64_t (*get64)(const uint64_t *);
+	void (*set16)(uint16_t *, uint16_t);
+	void (*set32)(uint32_t *, uint32_t);
+	void (*set64)(uint64_t *, uint64_t);
+};
+
+uint16_t get16_le(const uint16_t *p) { return __le16_to_cpu(*p); }
+uint32_t get32_le(const uint32_t *p) { return __le32_to_cpu(*p); }
+uint64_t get64_le(const uint64_t *p) { return __le64_to_cpu(*p); }
+uint16_t get16_be(const uint16_t *p) { return __be16_to_cpu(*p); }
+uint32_t get32_be(const uint32_t *p) { return __be32_to_cpu(*p); }
+uint64_t get64_be(const uint64_t *p) { return __be64_to_cpu(*p); }
+
+void set16_le(uint16_t *p, uint16_t n) { *p = __cpu_to_le16(n); }
+void set32_le(uint32_t *p, uint32_t n) { *p = __cpu_to_le32(n); }
+void set64_le(uint64_t *p, uint64_t n) { *p = __cpu_to_le64(n); }
+void set16_be(uint16_t *p, uint16_t n) { *p = __cpu_to_be16(n); }
+void set32_be(uint32_t *p, uint32_t n) { *p = __cpu_to_be32(n); }
+void set64_be(uint64_t *p, uint64_t n) { *p = __cpu_to_be64(n); }
+
+const struct byteorder byteorder_le = {
+	get16_le, get32_le, get64_le,
+	set16_le, set32_le, set64_le
+};
+const struct byteorder byteorder_be = {
+	get16_be, get32_be, get64_be,
+	set16_be, set32_be, set64_be
+};
+const struct byteorder *order;
+
+uint16_t get16(const uint16_t *p) { return order->get16(p); }
+uint32_t get32(const uint32_t *p) { return order->get32(p); }
+uint64_t get64(const uint64_t *p) { return order->get64(p); }
+void set16(uint16_t *p, uint16_t n) { order->set16(p, n); }
+void set32(uint32_t *p, uint32_t n) { order->set32(p, n); }
+void set64(uint64_t *p, uint64_t n) { order->set64(p, n); }
+
+FILE *outfd;
+uint8_t csum, xcsum;
+
+void write_out(const void *data, size_t size)
+{
+	const uint8_t *p = data;
+	size_t loop;
+
+	for (loop = 0; loop < size; loop++) {
+		csum += p[loop];
+		xcsum += p[loop];
+	}
+
+	if (fwrite(data, 1, size, outfd) != size) {
+		perror("write");
+		exit(1);
+	}
+}
+
+#define write_out_val(VAL) write_out(&(VAL), sizeof(VAL))
+
+int is_verbose;
+
+void verbose(const char *fmt, ...) __attribute__((format(printf,1,2)));
+void verbose(const char *fmt, ...)
+{
+	va_list va;
+
+	if (is_verbose) {
+		va_start(va, fmt);
+		vprintf(fmt, va);
+		va_end(va);
+	}
+}
+
+void usage(void) __attribute__((noreturn));
+void usage(void)
+{
+	fprintf(stderr, "Usage: mod-extract [-v] <modulefile> <extractfile>\n");
+	exit(2);
+}
+
+/*
+ *
+ */
+int main(int argc, char **argv)
+{
+	struct stat st;
+	Elf32_Ehdr *hdr32;
+	Elf64_Ehdr *hdr64;
+	size_t len;
+	void *buffer;
+	int fd, be, b64;
+
+	while (argc > 1 && strcmp("-v", argv[1]) == 0) {
+		argv++;
+		argc--;
+		is_verbose++;
+	}
+
+	if (argc != 3)
+		usage();
+
+	/* map the module into memory */
+	fd = open(argv[1], O_RDONLY);
+	if (fd < 0) {
+		perror("open input");
+		exit(1);
+	}
+
+	if (fstat(fd, &st) < 0) {
+		perror("fstat");
+		exit(1);
+	}
+
+	len = st.st_size;
+
+	buffer = mmap(NULL, len, PROT_READ|PROT_WRITE, MAP_PRIVATE, fd, 0);
+	if (buffer == MAP_FAILED) {
+		perror("mmap");
+		exit(1);
+	}
+
+	if (close(fd) < 0) {
+		perror("close input");
+		exit(1);
+	}
+
+	/* check it's an ELF object */
+	hdr32 = buffer;
+	hdr64 = buffer;
+
+	if (hdr32->e_ident[EI_MAG0] != ELFMAG0 ||
+	    hdr32->e_ident[EI_MAG1] != ELFMAG1 ||
+	    hdr32->e_ident[EI_MAG2] != ELFMAG2 ||
+	    hdr32->e_ident[EI_MAG3] != ELFMAG3
+	    ) {
+		fprintf(stderr, "Module does not appear to be ELF\n");
+		exit(3);
+	}
+
+	/* determine endianness and word size */
+	b64 = (hdr32->e_ident[EI_CLASS] == ELFCLASS64);
+	be = (hdr32->e_ident[EI_DATA] == ELFDATA2MSB);
+	order = be ? &byteorder_be : &byteorder_le;
+
+	verbose("Module is %s-bit %s-endian\n",
+		b64 ? "64" : "32",
+		be ? "big" : "little");
+
+	/* open the output file */
+	outfd = fopen(argv[2], "w");
+	if (!outfd) {
+		perror("open output");
+		exit(1);
+	}
+
+	/* perform the extraction */
+	if (b64)
+ 		extract_elf64(buffer, len, hdr64);
+	else
+ 		extract_elf32(buffer, len, hdr32);
+
+	/* done */
+	if (fclose(outfd) == EOF) {
+		perror("close output");
+		exit(1);
+	}
+
+	return 0;
+}
+
+/*
+ * extract a RELA table
+ * - need to canonicalise the entries in case section addition/removal has
+ *   rearranged the symbol table and the section table
+ */
+void extract_elf64_rela(const void *buffer, int secix, int targetix,
+			const Elf64_Rela *relatab, size_t nrels,
+			const Elf64_Sym *symbols, size_t nsyms,
+			const Elf64_Shdr *sections, size_t nsects, int *canonmap,
+			const char *strings, size_t nstrings,
+			const char *sh_name)
+{
+	struct {
+		uint64_t	r_offset;
+		uint64_t	r_addend;
+		uint64_t	st_value;
+		uint64_t	st_size;
+		uint32_t	r_type;
+		uint16_t	st_shndx;
+		uint8_t		st_info;
+		uint8_t		st_other;
+
+	} __attribute__((packed)) relocation;
+
+	const Elf64_Sym *symbol;
+	size_t loop;
+
+	/* contribute the relevant bits from a join of { RELA, SYMBOL, SECTION } */
+	for (loop = 0; loop < nrels; loop++) {
+		Elf64_Section st_shndx;
+		Elf64_Xword r_info;
+
+		/* decode the relocation */
+		r_info = get64(&relatab[loop].r_info);
+		relocation.r_offset = relatab[loop].r_offset;
+		relocation.r_addend = relatab[loop].r_addend;
+		set32(&relocation.r_type, ELF64_R_TYPE(r_info));
+
+		if (ELF64_R_SYM(r_info) >= nsyms) {
+			fprintf(stderr, "Invalid symbol ID %lx in relocation %zu\n",
+				ELF64_R_SYM(r_info), loop);
+			exit(1);
+		}
+
+		/* decode the symbol referenced by the relocation */
+		symbol = &symbols[ELF64_R_SYM(r_info)];
+		relocation.st_info = symbol->st_info;
+		relocation.st_other = symbol->st_other;
+		relocation.st_value = symbol->st_value;
+		relocation.st_size = symbol->st_size;
+		relocation.st_shndx = symbol->st_shndx;
+		st_shndx = get16(&symbol->st_shndx);
+
+		/* canonicalise the section used by the symbol */
+		if (st_shndx > SHN_UNDEF && st_shndx < nsects)
+			set16(&relocation.st_shndx, canonmap[st_shndx]);
+
+		write_out_val(relocation);
+
+		/* undefined symbols must be named if referenced */
+		if (st_shndx == SHN_UNDEF) {
+			const char *name = strings + get32(&symbol->st_name);
+			write_out(name, strlen(name) + 1);
+		}
+	}
+
+	verbose("%02x %4d %s [canon]\n", csum, secix, sh_name);
+}
+
+/*
+ * extract a REL table
+ * - need to canonicalise the entries in case section addition/removal has
+ *   rearranged the symbol table and the section table
+ */
+void extract_elf64_rel(const void *buffer, int secix, int targetix,
+		       const Elf64_Rel *relatab, size_t nrels,
+		       const Elf64_Sym *symbols, size_t nsyms,
+		       const Elf64_Shdr *sections, size_t nsects, int *canonmap,
+		       const char *strings, size_t nstrings,
+		       const char *sh_name)
+{
+	struct {
+		uint64_t	r_offset;
+		uint64_t	st_value;
+		uint64_t	st_size;
+		uint32_t	r_type;
+		uint16_t	st_shndx;
+		uint8_t		st_info;
+		uint8_t		st_other;
+
+	} __attribute__((packed)) relocation;
+
+	const Elf64_Sym *symbol;
+	size_t loop;
+
+	/* contribute the relevant bits from a join of { RELA, SYMBOL, SECTION } */
+	for (loop = 0; loop < nrels; loop++) {
+		Elf64_Section st_shndx;
+		Elf64_Xword r_info;
+
+		/* decode the relocation */
+		r_info = get64(&relatab[loop].r_info);
+		relocation.r_offset = relatab[loop].r_offset;
+		set32(&relocation.r_type, ELF64_R_TYPE(r_info));
+
+		if (ELF64_R_SYM(r_info) >= nsyms) {
+			fprintf(stderr, "Invalid symbol ID %lx in relocation %zi\n",
+				ELF64_R_SYM(r_info), loop);
+			exit(1);
+		}
+
+		/* decode the symbol referenced by the relocation */
+		symbol = &symbols[ELF64_R_SYM(r_info)];
+		relocation.st_info = symbol->st_info;
+		relocation.st_other = symbol->st_other;
+		relocation.st_value = symbol->st_value;
+		relocation.st_size = symbol->st_size;
+		relocation.st_shndx = symbol->st_shndx;
+		st_shndx = get16(&symbol->st_shndx);
+
+		/* canonicalise the section used by the symbol */
+		if (st_shndx > SHN_UNDEF && st_shndx < nsects)
+			set16(&relocation.st_shndx, canonmap[st_shndx]);
+
+		write_out_val(relocation);
+
+		/* undefined symbols must be named if referenced */
+		if (st_shndx == SHN_UNDEF) {
+			const char *name = strings + get32(&symbol->st_name);
+			write_out(name, strlen(name) + 1);
+		}
+	}
+
+	verbose("%02x %4d %s [canon]\n", csum, secix, sh_name);
+}
+
+/*
+ * extract the data from a 64-bit module
+ */
+void extract_elf64(void *buffer, size_t len, Elf64_Ehdr *hdr)
+{
+	const Elf64_Sym *symbols;
+	Elf64_Shdr *sections;
+	const char *secstrings, *strings;
+	size_t nsyms, nstrings;
+	int loop, shnum, *canonlist, *canonmap, canon, changed, tmp;
+
+	sections = buffer + get64(&hdr->e_shoff);
+	secstrings = buffer + get64(&sections[get16(&hdr->e_shstrndx)].sh_offset);
+	shnum = get16(&hdr->e_shnum);
+
+	/* find the symbol table and the string table and produce a list of
+	 * index numbers of sections that contribute to the kernel's module
+	 * image
+	 */
+	canonlist = calloc(sizeof(int), shnum * 2);
+	if (!canonlist) {
+		perror("calloc");
+		exit(1);
+	}
+	canonmap = canonlist + shnum;
+	canon = 0;
+
+	symbols = NULL;
+	strings = NULL;
+	nstrings = 0;
+	nsyms = 0;
+
+	for (loop = 1; loop < shnum; loop++) {
+		const char *sh_name = secstrings + get32(&sections[loop].sh_name);
+		Elf64_Word  sh_type	= get32(&sections[loop].sh_type);
+		Elf64_Xword sh_size	= get64(&sections[loop].sh_size);
+		Elf64_Xword sh_flags	= get64(&sections[loop].sh_flags);
+		Elf64_Off   sh_offset	= get64(&sections[loop].sh_offset);
+		void *data = buffer + sh_offset;
+
+		/* quick sanity check */
+		if (sh_type != SHT_NOBITS && len < sh_offset + sh_size) {
+			fprintf(stderr, "Section goes beyond EOF\n");
+			exit(3);
+		}
+
+		/* we only need to canonicalise allocatable sections */
+		if (sh_flags & SHF_ALLOC)
+			canonlist[canon++] = loop;
+
+		/* keep track of certain special sections */
+		switch (sh_type) {
+		case SHT_SYMTAB:
+			if (strcmp(sh_name, ".symtab") == 0) {
+				symbols = data;
+				nsyms = sh_size / sizeof(Elf64_Sym);
+			}
+			break;
+
+		case SHT_STRTAB:
+			if (strcmp(sh_name, ".strtab") == 0) {
+				strings = data;
+				nstrings = sh_size;
+			}
+			break;
+
+		default:
+			break;
+		}
+	}
+
+	if (!symbols) {
+		fprintf(stderr, "Couldn't locate symbol table\n");
+		exit(3);
+	}
+
+	if (!strings) {
+		fprintf(stderr, "Couldn't locate strings table\n");
+		exit(3);
+	}
+
+	/* canonicalise the index numbers of the contributing section */
+	do {
+		changed = 0;
+
+		for (loop = 0; loop < canon - 1; loop++) {
+			const char *x = secstrings + get32(&sections[canonlist[loop + 0]].sh_name);
+			const char *y = secstrings + get32(&sections[canonlist[loop + 1]].sh_name);
+			if (strcmp(x, y) > 0) {
+				tmp = canonlist[loop + 0];
+				canonlist[loop + 0] = canonlist[loop + 1];
+				canonlist[loop + 1] = tmp;
+				changed = 1;
+			}
+		}
+
+	} while(changed);
+
+	for (loop = 0; loop < canon; loop++)
+		canonmap[canonlist[loop]] = loop + 1;
+
+	if (is_verbose > 1) {
+		printf("\nSection canonicalisation map:\n");
+		for (loop = 1; loop < shnum; loop++) {
+			const char *x = secstrings + get32(&sections[loop].sh_name);
+			printf("%4d %s\n", canonmap[loop], x);
+		}
+
+		printf("\nAllocated section list in canonical order:\n");
+		for (loop = 0; loop < canon; loop++) {
+			const char *x = secstrings + get32(&sections[canonlist[loop]].sh_name);
+			printf("%4d %s\n", canonlist[loop], x);
+		}
+	}
+
+	memset(canonlist, 0, sizeof(int) * shnum);
+
+	/* iterate through the section table looking for sections we want to
+	 * contribute to the signature */
+	verbose("\n");
+	verbose("FILE POS CS SECT NAME\n");
+	verbose("======== == ==== ==============================\n");
+
+	for (loop = 1; loop < shnum; loop++) {
+		const char *sh_name = secstrings + get32(&sections[loop].sh_name);
+		Elf64_Word  sh_type	= get32(&sections[loop].sh_type);
+		Elf64_Xword sh_size	= get64(&sections[loop].sh_size);
+		Elf64_Xword sh_flags	= get64(&sections[loop].sh_flags);
+		Elf64_Word  sh_info	= get32(&sections[loop].sh_info);
+		Elf64_Off   sh_offset	= get64(&sections[loop].sh_offset);
+		void *data = buffer + sh_offset;
+
+		csum = 0;
+
+		/* include canonicalised relocation sections */
+		if (sh_type == SHT_REL || sh_type == SHT_RELA) {
+			if (sh_info <= 0 && sh_info >= hdr->e_shnum) {
+				fprintf(stderr,
+					"Invalid ELF - REL/RELA sh_info does"
+					" not refer to a valid section\n");
+				exit(3);
+			}
+
+			if (canonlist[sh_info]) {
+				Elf32_Word xsh_info;
+
+				verbose("%08lx ", ftell(outfd));
+
+				set32(&xsh_info, canonmap[sh_info]);
+
+				/* write out selected portions of the section
+				 * header */
+				write_out(sh_name, strlen(sh_name));
+				write_out_val(sections[loop].sh_type);
+				write_out_val(sections[loop].sh_flags);
+				write_out_val(sections[loop].sh_size);
+				write_out_val(sections[loop].sh_addralign);
+				write_out_val(xsh_info);
+
+				if (sh_type == SHT_RELA)
+					extract_elf64_rela(buffer, loop, sh_info,
+							   data, sh_size / sizeof(Elf64_Rela),
+							   symbols, nsyms,
+							   sections, shnum, canonmap,
+							   strings, nstrings,
+							   sh_name);
+				else
+					extract_elf64_rel(buffer, loop, sh_info,
+							  data, sh_size / sizeof(Elf64_Rel),
+							  symbols, nsyms,
+							  sections, shnum, canonmap,
+							  strings, nstrings,
+							  sh_name);
+			}
+
+			continue;
+		}
+
+		/* include allocatable loadable sections */
+		if (sh_type != SHT_NOBITS && sh_flags & SHF_ALLOC)
+			goto include_section;
+
+		/* not this section */
+		continue;
+
+	include_section:
+		verbose("%08lx ", ftell(outfd));
+
+		/* write out selected portions of the section header */
+		write_out(sh_name, strlen(sh_name));
+		write_out_val(sections[loop].sh_type);
+		write_out_val(sections[loop].sh_flags);
+		write_out_val(sections[loop].sh_size);
+		write_out_val(sections[loop].sh_addralign);
+
+		/* write out the section data */
+		write_out(data, sh_size);
+
+		verbose("%02x %4d %s\n", csum, loop, sh_name);
+
+		/* note the section has been written */
+		canonlist[loop] = 1;
+	}
+
+	verbose("%08lx         (%lu bytes csum 0x%02x)\n",
+		ftell(outfd), ftell(outfd), xcsum);
+}
+
+/*
+ * extract a RELA table
+ * - need to canonicalise the entries in case section addition/removal has
+ *   rearranged the symbol table and the section table
+ */
+void extract_elf32_rela(const void *buffer, int secix, int targetix,
+			const Elf32_Rela *relatab, size_t nrels,
+			const Elf32_Sym *symbols, size_t nsyms,
+			const Elf32_Shdr *sections, size_t nsects, int *canonmap,
+			const char *strings, size_t nstrings,
+			const char *sh_name)
+{
+	struct {
+		uint32_t	r_offset;
+		uint32_t	r_addend;
+		uint32_t	st_value;
+		uint32_t	st_size;
+		uint16_t	st_shndx;
+		uint8_t		r_type;
+		uint8_t		st_info;
+		uint8_t		st_other;
+
+	} __attribute__((packed)) relocation;
+
+	const Elf32_Sym *symbol;
+	size_t loop;
+
+	/* contribute the relevant bits from a join of { RELA, SYMBOL, SECTION } */
+	for (loop = 0; loop < nrels; loop++) {
+		Elf32_Section st_shndx;
+		Elf32_Word r_info;
+
+		/* decode the relocation */
+		r_info = get32(&relatab[loop].r_info);
+		relocation.r_offset = relatab[loop].r_offset;
+		relocation.r_addend = relatab[loop].r_addend;
+		relocation.r_type = ELF32_R_TYPE(r_info);
+
+		if (ELF32_R_SYM(r_info) >= nsyms) {
+			fprintf(stderr, "Invalid symbol ID %x in relocation %zu\n",
+				ELF32_R_SYM(r_info), loop);
+			exit(1);
+		}
+
+		/* decode the symbol referenced by the relocation */
+		symbol = &symbols[ELF32_R_SYM(r_info)];
+		relocation.st_info = symbol->st_info;
+		relocation.st_other = symbol->st_other;
+		relocation.st_value = symbol->st_value;
+		relocation.st_size = symbol->st_size;
+		relocation.st_shndx = symbol->st_shndx;
+		st_shndx = get16(&symbol->st_shndx);
+
+		/* canonicalise the section used by the symbol */
+		if (st_shndx > SHN_UNDEF && st_shndx < nsects)
+			set16(&relocation.st_shndx, canonmap[st_shndx]);
+
+		write_out_val(relocation);
+
+		/* undefined symbols must be named if referenced */
+		if (st_shndx == SHN_UNDEF) {
+			const char *name = strings + get32(&symbol->st_name);
+			write_out(name, strlen(name) + 1);
+		}
+	}
+
+	verbose("%02x %4d %s [canon]\n", csum, secix, sh_name);
+}
+
+/*
+ * extract a REL table
+ * - need to canonicalise the entries in case section addition/removal has
+ *   rearranged the symbol table and the section table
+ */
+void extract_elf32_rel(const void *buffer, int secix, int targetix,
+		       const Elf32_Rel *relatab, size_t nrels,
+		       const Elf32_Sym *symbols, size_t nsyms,
+		       const Elf32_Shdr *sections, size_t nsects, int *canonmap,
+		       const char *strings, size_t nstrings,
+		       const char *sh_name)
+{
+	struct {
+		uint32_t	r_offset;
+		uint32_t	st_value;
+		uint32_t	st_size;
+		uint16_t	st_shndx;
+		uint8_t		r_type;
+		uint8_t		st_info;
+		uint8_t		st_other;
+
+	} __attribute__((packed)) relocation;
+
+	const Elf32_Sym *symbol;
+	size_t loop;
+
+	/* contribute the relevant bits from a join of { RELA, SYMBOL, SECTION } */
+	for (loop = 0; loop < nrels; loop++) {
+		Elf32_Section st_shndx;
+		Elf32_Word r_info;
+
+		/* decode the relocation */
+		r_info = get32(&relatab[loop].r_info);
+		relocation.r_offset = relatab[loop].r_offset;
+		relocation.r_type = ELF32_R_TYPE(r_info);
+
+		if (ELF32_R_SYM(r_info) >= nsyms) {
+			fprintf(stderr, "Invalid symbol ID %x in relocation %zu\n",
+				ELF32_R_SYM(r_info), loop);
+			exit(1);
+		}
+
+		/* decode the symbol referenced by the relocation */
+		symbol = &symbols[ELF32_R_SYM(r_info)];
+		relocation.st_info = symbol->st_info;
+		relocation.st_other = symbol->st_other;
+		relocation.st_value = symbol->st_value;
+		relocation.st_size = symbol->st_size;
+		relocation.st_shndx = symbol->st_shndx;
+		st_shndx = get16(&symbol->st_shndx);
+
+		/* canonicalise the section used by the symbol */
+		if (st_shndx > SHN_UNDEF && st_shndx < nsects)
+			set16(&relocation.st_shndx, canonmap[st_shndx]);
+
+		write_out_val(relocation);
+
+		/* undefined symbols must be named if referenced */
+		if (st_shndx == SHN_UNDEF) {
+			const char *name = strings + get32(&symbol->st_name);
+			write_out(name, strlen(name) + 1);
+		}
+	}
+
+	verbose("%02x %4d %s [canon]\n", csum, secix, sh_name);
+}
+
+/*
+ * extract the data from a 32-bit module
+ */
+void extract_elf32(void *buffer, size_t len, Elf32_Ehdr *hdr)
+{
+	const Elf32_Sym *symbols;
+	Elf32_Shdr *sections;
+	const char *secstrings, *strings;
+	size_t nsyms, nstrings;
+	int loop, shnum, *canonlist, *canonmap, canon, changed, tmp;
+
+	sections = buffer + get32(&hdr->e_shoff);
+	secstrings = buffer + get32(&sections[get16(&hdr->e_shstrndx)].sh_offset);
+	shnum = get16(&hdr->e_shnum);
+
+	/* find the symbol table and the string table and produce a list of
+	 * index numbers of sections that contribute to the kernel's module
+	 * image
+	 */
+	canonlist = calloc(sizeof(int), shnum * 2);
+	if (!canonlist) {
+		perror("calloc");
+		exit(1);
+	}
+	canonmap = canonlist + shnum;
+	canon = 0;
+
+	symbols = NULL;
+	strings = NULL;
+	nstrings = 0;
+	nsyms = 0;
+
+	for (loop = 1; loop < shnum; loop++) {
+		const char *sh_name = secstrings + get32(&sections[loop].sh_name);
+		Elf32_Word  sh_type	= get32(&sections[loop].sh_type);
+		Elf32_Xword sh_size	= get32(&sections[loop].sh_size);
+		Elf32_Xword sh_flags	= get32(&sections[loop].sh_flags);
+		Elf32_Off   sh_offset	= get32(&sections[loop].sh_offset);
+		void *data = buffer + sh_offset;
+
+		/* quick sanity check */
+		if (sh_type != SHT_NOBITS && len < sh_offset + sh_size) {
+			fprintf(stderr, "Section goes beyond EOF\n");
+			exit(3);
+		}
+
+		/* we only need to canonicalise allocatable sections */
+		if (sh_flags & SHF_ALLOC)
+			canonlist[canon++] = loop;
+
+		/* keep track of certain special sections */
+		switch (sh_type) {
+		case SHT_SYMTAB:
+			if (strcmp(sh_name, ".symtab") == 0) {
+				symbols = data;
+				nsyms = sh_size / sizeof(Elf32_Sym);
+			}
+			break;
+
+		case SHT_STRTAB:
+			if (strcmp(sh_name, ".strtab") == 0) {
+				strings = data;
+				nstrings = sh_size;
+			}
+			break;
+
+		default:
+			break;
+		}
+	}
+
+	if (!symbols) {
+		fprintf(stderr, "Couldn't locate symbol table\n");
+		exit(3);
+	}
+
+	if (!strings) {
+		fprintf(stderr, "Couldn't locate strings table\n");
+		exit(3);
+	}
+
+	/* canonicalise the index numbers of the contributing section */
+	do {
+		changed = 0;
+
+		for (loop = 0; loop < canon - 1; loop++) {
+			const char *x = secstrings + get32(&sections[canonlist[loop + 0]].sh_name);
+			const char *y = secstrings + get32(&sections[canonlist[loop + 1]].sh_name);
+			if (strcmp(x, y) > 0) {
+				tmp = canonlist[loop + 0];
+				canonlist[loop + 0] = canonlist[loop + 1];
+				canonlist[loop + 1] = tmp;
+				changed = 1;
+			}
+		}
+
+	} while(changed);
+
+	for (loop = 0; loop < canon; loop++)
+		canonmap[canonlist[loop]] = loop + 1;
+
+	if (is_verbose > 1) {
+		printf("\nSection canonicalisation map:\n");
+		for (loop = 1; loop < shnum; loop++) {
+			const char *x = secstrings + get32(&sections[loop].sh_name);
+			printf("%4d %s\n", canonmap[loop], x);
+		}
+
+		printf("\nAllocated section list in canonical order:\n");
+		for (loop = 0; loop < canon; loop++) {
+			const char *x = secstrings + get32(&sections[canonlist[loop]].sh_name);
+			printf("%4d %s\n", canonlist[loop], x);
+		}
+	}
+
+	memset(canonlist, 0, sizeof(int) * shnum);
+
+	/* iterate through the section table looking for sections we want to
+	 * contribute to the signature */
+	verbose("\n");
+	verbose("FILE POS CS SECT NAME\n");
+	verbose("======== == ==== ==============================\n");
+
+	for (loop = 1; loop < shnum; loop++) {
+		const char *sh_name = secstrings + get32(&sections[loop].sh_name);
+		Elf32_Word  sh_type	= get32(&sections[loop].sh_type);
+		Elf32_Xword sh_size	= get32(&sections[loop].sh_size);
+		Elf32_Xword sh_flags	= get32(&sections[loop].sh_flags);
+		Elf32_Word  sh_info	= get32(&sections[loop].sh_info);
+		Elf32_Off   sh_offset	= get32(&sections[loop].sh_offset);
+		void *data = buffer + sh_offset;
+
+		csum = 0;
+
+		/* quick sanity check */
+		if (sh_type != SHT_NOBITS && len < sh_offset + sh_size) {
+			fprintf(stderr, "section goes beyond EOF\n");
+			exit(3);
+		}
+
+		/* include canonicalised relocation sections */
+		if (sh_type == SHT_REL || sh_type == SHT_RELA) {
+			if (sh_info <= 0 && sh_info >= hdr->e_shnum) {
+				fprintf(stderr,
+					"Invalid ELF - REL/RELA sh_info does"
+					" not refer to a valid section\n");
+				exit(3);
+			}
+
+			if (canonlist[sh_info]) {
+				Elf32_Word xsh_info;
+
+				verbose("%08lx ", ftell(outfd));
+
+				set32(&xsh_info, canonmap[sh_info]);
+
+				/* write out selected portions of the section header */
+				write_out(sh_name, strlen(sh_name));
+				write_out_val(sections[loop].sh_type);
+				write_out_val(sections[loop].sh_flags);
+				write_out_val(sections[loop].sh_size);
+				write_out_val(sections[loop].sh_addralign);
+				write_out_val(xsh_info);
+
+				if (sh_type == SHT_RELA)
+					extract_elf32_rela(buffer, loop, sh_info,
+							   data, sh_size / sizeof(Elf32_Rela),
+							   symbols, nsyms,
+							   sections, shnum, canonmap,
+							   strings, nstrings,
+							   sh_name);
+				else
+					extract_elf32_rel(buffer, loop, sh_info,
+							  data, sh_size / sizeof(Elf32_Rel),
+							  symbols, nsyms,
+							  sections, shnum, canonmap,
+							  strings, nstrings,
+							  sh_name);
+			}
+
+			continue;
+		}
+
+		/* include allocatable loadable sections */
+		if (sh_type != SHT_NOBITS && sh_flags & SHF_ALLOC)
+			goto include_section;
+
+		/* not this section */
+		continue;
+
+	include_section:
+		verbose("%08lx ", ftell(outfd));
+
+		/* write out selected portions of the section header */
+		write_out(sh_name, strlen(sh_name));
+		write_out_val(sections[loop].sh_type);
+		write_out_val(sections[loop].sh_flags);
+		write_out_val(sections[loop].sh_size);
+		write_out_val(sections[loop].sh_addralign);
+
+		/* write out the section data */
+		write_out(data, sh_size);
+
+		verbose("%02x %4d %s\n", csum, loop, sh_name);
+
+		/* note the section has been written */
+		canonlist[loop] = 1;
+	}
+
+	verbose("%08lx         (%lu bytes csum 0x%02x)\n",
+		ftell(outfd), ftell(outfd), xcsum);
+}
