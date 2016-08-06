From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v3] DH support: add KDF handling support
Date: Sat, 06 Aug 2016 08:37:34 +0200
Message-ID: <3715151.LOyK4NLlGi@positron.chronox.de>
References: <2239809.KsND40bFeW@positron.chronox.de> <2313703.12yUpncF2W@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Mat Martineau <mathew.j.martineau@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34178 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbcHFUM6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 6 Aug 2016 16:12:58 -0400
In-Reply-To: <2313703.12yUpncF2W@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add the interface logic to support DH with KDF handling support.

The dh_compute code now allows the following options:

- no KDF support / output of raw DH shared secret:
  dh_compute <private> <prime> <base>

- KDF support without "other information" string:
  dh_compute_kdf <private> <prime> <base> <output length> <KDF type>

- KDF support with "other information string:
  dh_compute_kdf_oi <private> <prime> <base> <output length> <KDF type>
    where the OI string is provided on STDIN.

The test to verify the code is based on a test vector used for the CAVS
testing of SP800-56A.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 Makefile                                 |   1 +
 keyctl.c                                 | 133 ++++++++++++++++++++++++
 keyutils.c                               |  14 +++
 keyutils.h                               |  11 ++
 man/keyctl_dh_compute.3                  |  58 +++++++++++
 tests/keyctl/dh_compute/valid/runtest.sh | 168 +++++++++++++++++++++++++++++++
 tests/toolbox.inc.sh                     |  44 ++++++++
 version.lds                              |   2 +
 8 files changed, 431 insertions(+)

diff --git a/Makefile b/Makefile
index 824bbbf..90fc33f 100644
--- a/Makefile
+++ b/Makefile
@@ -195,6 +195,7 @@ endif
 	$(LNS) keyctl_read.3 $(DESTDIR)$(MAN3)/keyctl_read_alloc.3
 	$(LNS) recursive_key_scan.3 $(DESTDIR)$(MAN3)/recursive_session_key_scan.3
 	$(LNS) keyctl_dh_compute.3 $(DESTDIR)$(MAN3)/keyctl_dh_compute_alloc.3
+	$(LNS) keyctl_dh_compute.3 $(DESTDIR)$(MAN3)/keyctl_dh_compute_kdf.3
 	$(INSTALL) -D -m 0644 keyutils.h $(DESTDIR)$(INCLUDEDIR)/keyutils.h
 
 ###############################################################################
diff --git a/keyctl.c b/keyctl.c
index edb03de..fcf2f02 100644
--- a/keyctl.c
+++ b/keyctl.c
@@ -20,6 +20,7 @@
 #include <errno.h>
 #include <asm/unistd.h>
 #include "keyutils.h"
+#include <limits.h>
 
 struct command {
 	void (*action)(int argc, char *argv[]) __attribute__((noreturn));
@@ -67,6 +68,8 @@ static nr void act_keyctl_purge(int argc, char *argv[]);
 static nr void act_keyctl_invalidate(int argc, char *argv[]);
 static nr void act_keyctl_get_persistent(int argc, char *argv[]);
 static nr void act_keyctl_dh_compute(int argc, char *argv[]);
+static nr void act_keyctl_dh_compute_kdf(int argc, char *argv[]);
+static nr void act_keyctl_dh_compute_kdf_oi(int argc, char *argv[]);
 
 const struct command commands[] = {
 	{ act_keyctl___version,	"--version",	"" },
@@ -76,6 +79,8 @@ const struct command commands[] = {
 	{ act_keyctl_clear,	"clear",	"<keyring>" },
 	{ act_keyctl_describe,	"describe",	"<keyring>" },
 	{ act_keyctl_dh_compute, "dh_compute",	"<private> <prime> <base>" },
+	{ act_keyctl_dh_compute_kdf, "dh_compute_kdf", "<private> <prime> <base> <len> <kdf>" },
+	{ act_keyctl_dh_compute_kdf_oi, "dh_compute_kdf_oi", "<private> <prime> <base> <len> <kdf>" },
 	{ act_keyctl_instantiate, "instantiate","<key> <data> <keyring>" },
 	{ act_keyctl_invalidate,"invalidate",	"<key>" },
 	{ act_keyctl_get_persistent, "get_persistent", "<keyring> [<uid>]" },
@@ -1663,6 +1668,7 @@ static void act_keyctl_dh_compute(int argc, char *argv[])
 		}
 
 		printf("%02hhx", *p);
+		*p = 0x00;	/* zeroize buffer */
 		p++;
 
 		col++;
@@ -1674,6 +1680,133 @@ static void act_keyctl_dh_compute(int argc, char *argv[])
 	} while (--ret > 0);
 
 	printf("\n");
+
+	free(buffer);
+
+	exit(0);
+}
+
+static void act_keyctl_dh_compute_kdf(int argc, char *argv[])
+{
+	key_serial_t private, prime, base;
+	char *buffer;
+	char *p;
+	int ret, sep, col;
+	unsigned long buflen = 0;
+
+	if (argc != 6)
+		format();
+
+	private = get_key_id(argv[1]);
+	prime = get_key_id(argv[2]);
+	base = get_key_id(argv[3]);
+
+	buflen = strtoul(argv[4], NULL, 10);
+	if (buflen == ULONG_MAX)
+		error("dh_compute: cannot convert generated length value");
+
+	buffer = malloc(buflen);
+	if (!buffer)
+		error("dh_compute: cannot allocate memory");
+
+	ret = keyctl_dh_compute_kdf(private, prime, base, argv[5], NULL,  0,
+				    buffer, buflen);
+	if (ret < 0)
+		error("keyctl_dh_compute_alloc");
+
+	/* hexdump the contents */
+	printf("%u bytes of data in result:\n", ret);
+
+	sep = 0;
+	col = 0;
+	p = buffer;
+
+	do {
+		if (sep) {
+			putchar(sep);
+			sep = 0;
+		}
+
+		printf("%02hhx", *p);
+		*p = 0x00;	/* zeroize buffer */
+		p++;
+
+		col++;
+		if (col % 32 == 0)
+			sep = '\n';
+		else if (col % 4 == 0)
+			sep = ' ';
+
+	} while (--ret > 0);
+
+	printf("\n");
+
+	free(buffer);
+
+	exit(0);
+}
+
+static void act_keyctl_dh_compute_kdf_oi(int argc, char *argv[])
+{
+	key_serial_t private, prime, base;
+	char *buffer;
+	char *p;
+	int ret, sep, col;
+	unsigned long buflen = 0;
+	size_t oilen;
+	void *oi;
+
+	if (argc != 6)
+		format();
+
+	private = get_key_id(argv[1]);
+	prime = get_key_id(argv[2]);
+	base = get_key_id(argv[3]);
+
+	buflen = strtoul(argv[4], NULL, 10);
+	if (buflen == ULONG_MAX)
+		error("dh_compute: cannot convert generated length value");
+
+	buffer = malloc(buflen);
+	if (!buffer)
+		error("dh_compute: cannot allocate memory");
+
+	oi = grab_stdin(&oilen);
+
+	ret = keyctl_dh_compute_kdf(private, prime, base, argv[5], oi,  oilen,
+				    buffer, buflen);
+	if (ret < 0)
+		error("keyctl_dh_compute_alloc");
+
+	/* hexdump the contents */
+	printf("%u bytes of data in result:\n", ret);
+
+	sep = 0;
+	col = 0;
+	p = buffer;
+
+	do {
+		if (sep) {
+			putchar(sep);
+			sep = 0;
+		}
+
+		printf("%02hhx", *p);
+		*p = 0x00;	/* zeroize buffer */
+		p++;
+
+		col++;
+		if (col % 32 == 0)
+			sep = '\n';
+		else if (col % 4 == 0)
+			sep = ' ';
+
+	} while (--ret > 0);
+
+	printf("\n");
+
+	free(buffer);
+
 	exit(0);
 }
 
diff --git a/keyutils.c b/keyutils.c
index 2a69304..2c3c4e6 100644
--- a/keyutils.c
+++ b/keyutils.c
@@ -244,6 +244,20 @@ long keyctl_dh_compute(key_serial_t private, key_serial_t prime,
 	return keyctl(KEYCTL_DH_COMPUTE, &params, buffer, buflen, 0);
 }
 
+long keyctl_dh_compute_kdf(key_serial_t private, key_serial_t prime,
+			   key_serial_t base, char *kdfname, char *otherinfo,
+			   size_t otherinfolen, char *buffer, size_t buflen)
+{
+	struct keyctl_dh_params params = { .private = private,
+					   .prime = prime,
+					   .base = base };
+	struct keyctl_kdf_params kdfparams = { .kdfname = kdfname,
+					       .otherinfo = otherinfo,
+					       .otherinfolen = otherinfolen };
+
+	return keyctl(KEYCTL_DH_COMPUTE, &params, buffer, buflen, &kdfparams);
+}
+
 /*****************************************************************************/
 /*
  * fetch key description into an allocated buffer
diff --git a/keyutils.h b/keyutils.h
index b321aa8..65df9fd 100644
--- a/keyutils.h
+++ b/keyutils.h
@@ -108,6 +108,13 @@ struct keyctl_dh_params {
 	key_serial_t base;
 };
 
+struct keyctl_kdf_params {
+	char *kdfname;
+	char *otherinfo;
+	uint32_t otherinfolen;
+	uint32_t __spare[8];
+};
+
 /*
  * syscall wrappers
  */
@@ -163,6 +170,10 @@ extern long keyctl_invalidate(key_serial_t id);
 extern long keyctl_get_persistent(uid_t uid, key_serial_t id);
 extern long keyctl_dh_compute(key_serial_t private, key_serial_t prime,
 			      key_serial_t base, char *buffer, size_t buflen);
+extern long keyctl_dh_compute_kdf(key_serial_t private, key_serial_t prime,
+				  key_serial_t base, char *kdfname,
+				  char *otherinfo, size_t otherinfolen,
+				  char *buffer, size_t buflen);
 
 /*
  * utilities
diff --git a/man/keyctl_dh_compute.3 b/man/keyctl_dh_compute.3
index b06d39e..92d358f 100644
--- a/man/keyctl_dh_compute.3
+++ b/man/keyctl_dh_compute.3
@@ -11,6 +11,8 @@
 .\"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
 .SH NAME
 keyctl_dh_compute \- Compute a Diffie-Hellman shared secret or public key
+.br
+keyctl_dh_compute_kdf \- Derive key from a Diffie-Hellman shared secret
 .\"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
 .SH SYNOPSIS
 .nf
@@ -21,6 +23,10 @@ keyctl_dh_compute \- Compute a Diffie-Hellman shared secret or public key
 .sp
 .BI "long keyctl_dh_compute_alloc(key_serial_t " private,
 .BI "key_serial_t " prime ", key_serial_t " base ", void **" _buffer ");"
+.sp
+.BI "long keyctl_dh_compute_kdf(key_serial_t " private ", key_serial_t " prime ,
+.BI "key_serial_t " base ", char *" kdfname ", char *" otherinfo ",
+.BI "size_t " otherinfolen ", char *" buffer ", size_t " buflen ");"
 .\"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
 .SH DESCRIPTION
 .BR keyctl_dh_compute ()
@@ -64,6 +70,49 @@ places the data in it.  If successful, a pointer to the buffer is placed in
 .IR *_buffer .
 The caller must free the buffer.
 .P
+.BR keyctl_dh_compute_kdf ()
+derives a key from a Diffie-Hellman shared secret according to the protocol
+specified in SP800-56A. The Diffie-Hellman computation is based on the same
+primitives as discussed
+for
+.BR keyctl_dy_compute ().
+.P
+To implement the protocol of SP800-56A
+.I base
+is a key containing the remote public key to compute the Diffie-Hellman
+shared secret. That shared secret is post-processed with a key derivation
+function.
+.P
+The
+.I kdfname
+specifies the Linux kernel crypto API name for a key derivation function
+using a non-keyed hash, such as kdf_ctr(sha256). Using the counter KDF function
+specified with kdf_ctr() makes the key derivation compliant to SP800-56A.
+The
+.I kdfname
+must be a NULL terminated string.
+.P
+Following the specification of SP800-56A section 5.8.1.2 the
+.I otherinfo
+parameter may be provided. The format of the OtherInfo field is defined
+by the caller. The caller may also specify NULL as a valid argument when
+no OtherInfo data shall be processed. The length of the
+.I otherinfo
+parameter is specified with
+.I otherinfolen
+and is restricted to a maximum length by the kernel.
+.P
+The KDF returns the requested number of bytes specified with the
+.I genlen
+or the
+.I buflen
+parameter depending on the invoked function.
+.P
+.I buffer
+and
+.I buflen
+specify the buffer into which the computed result will be placed.
+.P
 .\"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
 .SH RETURN VALUE
 On success
@@ -91,6 +140,15 @@ The buffer pointer is invalid or buflen is too small.
 .TP
 .B EOPNOTSUPP
 One of the keys was not a valid user key.
+.TP
+.B EMSGSIZE
+When using
+.BR keyctl_dh_compute_kdf (),
+the size of either
+.I otherinfolen
+or
+.I buflen
+is too big.
 .\"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
 .SH LINKING
 This is a library function that can be found in
diff --git a/tests/keyctl/dh_compute/valid/runtest.sh b/tests/keyctl/dh_compute/valid/runtest.sh
index f2aace6..d8e338b 100644
--- a/tests/keyctl/dh_compute/valid/runtest.sh
+++ b/tests/keyctl/dh_compute/valid/runtest.sh
@@ -84,5 +84,173 @@ expect_multiline payload "$public"
 
 echo "++++ FINISHED TEST: $result" >>$OUTPUTFILE
 
+
+################################################################
+# Testing DH compute with KDF according to SP800-56A
+#
+# test vectors from http://csrc.nist.gov/groups/STM/cavp/documents/keymgmt/KASTestVectorsFFC2014.zip
+################################################################
+
+# SHA-256
+
+# XephemCAVS
+private="\x81\xb2\xc6\x5f\x5c\xba\xc0\x0b\x13\x53\xac\x38\xbd\x77\xa2\x5a"
+private+="\x86\x50\xed\x48\x5e\x41\x3e\xac\x1d\x6c\x48\x85"
+
+# P
+prime="\xa3\xcc\x62\x23\xe5\x0c\x6e\x3f\x7b\xb0\x58\x1d\xcb\x9e\x9f\xf0"
+prime+="\x2c\x58\x07\x68\x32\x8a\x15\x20\x7b\x1c\x32\x31\x7f\xb7\x84\x96"
+prime+="\x81\x5e\x3c\xf7\xf9\xd0\x9c\xcb\x9f\xa8\x40\xff\x47\x98\x51\x1a"
+prime+="\x17\xb5\x59\x28\x72\x1e\x5d\xfb\xcc\xc5\x41\x47\xe0\xf0\x5f\x85"
+prime+="\xb3\xac\x41\x0b\x6a\xe3\xf5\x9b\x79\x6f\x3f\xea\xc7\xfc\x52\x49"
+prime+="\x21\x7e\xb2\xa0\x45\x88\x29\x3a\x5a\xde\x22\x78\x79\xf4\x6c\xeb"
+prime+="\x56\x45\x7b\x5c\x43\x12\x93\xe5\xe1\x04\xd1\xb9\x64\xbd\x2c\xdf"
+prime+="\xde\xff\xa0\x40\x49\xa9\x1e\x67\xee\x8c\x86\xe9\x44\xf0\x4f\x94"
+prime+="\x4a\x30\xe3\x61\xf8\xd1\x5d\x17\xe5\x01\x0c\xab\xb4\xef\x40\xc0"
+prime+="\xeb\xa5\xf4\xa2\x52\xd4\xfd\x6c\xf9\xda\xe6\x0e\x86\xe4\xb3\x00"
+prime+="\x9b\x1d\xfc\x92\x66\x70\x35\x72\x61\x58\x7a\xd0\x5c\x00\xa6\xc6"
+prime+="\xf0\x10\x6c\xec\x8f\xc5\x91\x31\x51\x50\x84\xa8\x70\x59\x41\x65"
+prime+="\xb4\x93\x90\xdb\x2d\x00\xe7\x53\x8f\x23\x0d\x53\x2f\x4a\x4e\xca"
+prime+="\x83\x09\xd7\x07\xc0\xb3\x83\x5c\xee\x04\xf3\xca\x55\x8a\x22\xc6"
+prime+="\xb5\x20\xfe\x25\xde\x6f\xfa\x90\xef\xda\x49\x27\xd0\x18\x59\x4c"
+prime+="\x0c\x0b\x77\x06\x73\x93\xb7\xf1\xe0\xfc\x7c\xf2\x16\xaf\xf3\x9f"
+
+# YephemIUT
+xa="\x9a\x70\x82\x2d\x3f\x06\x12\x3d\x0e\x51\x8e\xe1\x16\x51\xe5\xf6"
+xa+="\xb1\x19\xdc\x3b\x97\xd5\xb1\xc0\xa2\xa6\xf6\xde\x94\x25\x64\xba"
+xa+="\x10\x06\x1e\xec\xde\xb7\x36\x9c\xa5\x37\x49\x9e\x04\xb0\x36\xe9"
+xa+="\x7f\x44\x5a\x95\x6f\x63\x69\xae\x6e\x63\xfd\x27\xea\xe3\xe3\x47"
+xa+="\x85\x54\x47\xd3\xba\xc1\xc6\x0c\x10\xe7\x35\x07\x72\xc6\xc0\xc6"
+xa+="\xfb\xf9\xca\x3e\x38\xf0\xe8\x65\x88\x25\xd3\xb2\x0f\x1f\x02\x8f"
+xa+="\x35\xe3\x4d\x12\x35\x10\x3d\xf2\x33\x9b\x5b\x09\x9d\x3f\xe3\xe5"
+xa+="\x34\x6a\x69\x16\x42\xba\xc5\xb0\xbb\x03\xcd\x5d\x04\xd7\x56\x26"
+xa+="\x21\x49\x3f\xf1\xc4\x27\x3b\x6a\x45\xc5\xec\xb0\xb5\xe9\x08\xa0"
+xa+="\xf9\xf5\x62\x28\x2e\x85\x3e\xfc\x9a\x7e\xa1\x12\xe9\x47\x4f\xf6"
+xa+="\x94\x18\xf7\xc4\x7a\xe9\x66\xd4\x52\x4c\xa1\x70\x1b\x60\xa4\xbe"
+xa+="\x15\xc7\x5e\x27\xb4\x05\x80\x64\x68\x15\x6e\x02\xcb\xc5\x8f\xf4"
+xa+="\x66\x3c\x96\xac\x0c\x87\x36\x81\x35\xfa\x9b\x0b\xb6\x33\x7a\xe2"
+xa+="\x58\x52\x1d\x7d\x60\xc2\xa9\x1b\x4e\xd7\x72\xad\x65\x03\x40\x49"
+xa+="\x97\xf6\x79\x9d\xf6\x63\xa8\x99\x9c\xfd\x74\x7f\xa0\x67\xb9\x05"
+xa+="\x8a\xb3\x3b\xc1\x45\x94\x36\x6f\x28\xf5\xa2\xd9\x00\xb6\x46\x7a"
+
+# Z
+read -d '' shared <<"EOF"
+0fdbd9a2 ebf50cba 489b4e4d 7cd6924a 42ee6324 a26988b2 22bc38e6 9cc445f1
+eb47c1a4 62eca39f 39bcd7b8 19dede51 30bc38da ec99c16f 40a4e5c1 9c97b796
+8b41823d a0650e37 13c73e6f 5f2a9dff 2e67dbf5 40ee66f4 e694c28f ba1d604b
+71b57b8a eeb67a35 ba425a38 490b6fb9 f713db22 6f893b7a 8962f426 ba3046fb
+cff8538c 16f583e8 ae947672 0ba55ff9 75b440d0 c4565cc7 5837d23a fea61a39
+e0b7f6c4 e24c2154 7eb19fce f8dbed10 b06a9cce 971c0f0f ba7c1d5c b5035eaa
+4fddd3ba fe757339 e3321e3e 4ebfe9e7 9c6c0401 4df63cf9 28d0a2c0 5b2d5521
+030c35f1 c84c97fe 64cad509 8012a003 d52d24c4 1a1f9348 b7575251 3facb02f
+EOF
+
+# OI
+otherinfo="\xa1\xb2\xc3\xd4\xe5\x43\x41\x56\x53\x69\x64\x0d\x64\xc1\xb2"
+otherinfo+="\x33\x61\xb2\x61\xde\x78\x68\x8e\xa8\x65\xfc\xff\x11\x3c\x84"
+
+# DKM
+read -d '' derived <<"EOF"
+8284e313 02c8a26b 393ec52d 9f9e0882
+EOF
+
+pcreate_key "-e $prime" user dh:prime @s
+expect_keyid primeid
+
+pcreate_key "-e $xa" user dh:xa @s
+expect_keyid xaid
+
+pcreate_key "-e $private" user dh:private @s
+expect_keyid privateid
+
+marker "COMPUTE DH SHARED SECRET"
+dh_compute $privateid $primeid $xaid
+expect_multiline payload "$shared"
+
+marker "COMPUTE DERIVED KEY FROM DH SHARED SECRET (SHA-256)"
+echo -e -n $otherinfo | dh_compute_kdf_oi $privateid $primeid $xaid 16 "kdf_ctr(sha256)"
+expect_multiline payload "$derived"
+
+
+# SHA-224
+
+# XephemCAVS
+private="\x86\x1b\xa2\x59\xab\xa6\xaa\x57\x7d\xe2\x2f\x50\x8e\xcb\xbc\x26"
+private+="\xc5\xac\xfc\xcb\x9e\xa2\x3b\x43\x4d\x6d\x2b\x79"
+
+# P
+prime="\xa5\xb1\x76\x4e\x13\xc8\x16\x99\xab\xa3\x8f\x0d\xc0\xd1\x5e\x15"
+prime+="\xf5\x0f\xcd\x5c\xf7\xc2\x23\x72\xca\xfc\x5e\xd7\x62\x94\x1b\xd9"
+prime+="\xe0\xfb\x9a\xab\xee\x74\x66\xd2\xc8\x29\xaa\xb0\x31\xdb\x7b\x1b"
+prime+="\x5a\x64\xe6\x8e\xd5\x3b\xaf\xb2\x83\xba\x0f\x01\x8b\xeb\x3e\xdc"
+prime+="\x95\x7f\xe4\x53\xbe\x0d\xaa\xb6\x1b\x32\x28\x76\x3e\x80\x75\x8c"
+prime+="\x6d\x8c\x28\x3c\xf6\x30\xed\xd9\xd7\x0a\x8a\xf3\x30\xdd\x0a\xf6"
+prime+="\xa8\xd5\x94\xc2\x3c\xdd\x24\xc8\xad\x3f\xcf\xea\x41\x75\x77\x72"
+prime+="\xce\xed\x92\x1e\x63\x86\x2f\x24\x6e\x6f\x49\xd8\x74\x7e\x44\xae"
+prime+="\xf0\x1e\x30\x9b\x6d\xcc\x80\xd4\x50\x38\x3b\xb1\xf9\x4d\xd5\x90"
+prime+="\x84\xf8\xe9\x6f\x85\x6e\xc7\xc8\x33\x5e\xdb\x05\x5f\x8e\xc6\xc4"
+prime+="\x81\x52\x0b\x3f\x28\xe8\x0b\x62\x09\xb8\xae\x61\xcc\x86\x0e\x24"
+prime+="\xc8\x22\xb6\x6c\x4f\x97\x80\x49\x93\xbc\xd0\xa9\x72\xb3\x53\x54"
+prime+="\x01\x33\x0e\xbe\x4b\x2e\x92\x3f\x18\x9b\x63\x35\x62\xe4\x68\xeb"
+prime+="\x99\xa4\xbc\x88\xcc\xbf\xf8\xdf\x0f\xd5\xaf\xcf\xe6\xae\x19\x18"
+prime+="\x42\x14\xab\x3f\xef\xb7\xf0\x66\x8b\x8b\x26\x83\xbe\xbd\x56\x51"
+prime+="\xa4\xc6\x38\x43\xb9\xb1\x4b\xc7\x38\xd5\x20\xb1\xb7\x21\x2c\x69"
+
+# YephemIUT
+xa="\x17\xd7\x1a\xf4\x35\x3c\x22\x12\x2a\xeb\x2a\x06\x19\xcc\x2c\xf7"
+xa+="\x35\x53\xf2\x8e\x9f\xb1\x91\xfd\xb2\x86\xb1\x15\xb9\xfd\xa8\x66"
+xa+="\x2d\xe5\x17\x3b\x1a\xff\x70\x48\x8d\x9b\xc8\x48\xe5\x37\xd7\xe5"
+xa+="\x02\x16\x49\xd3\x7d\xc7\x8c\x94\x36\x9d\xb9\x0c\x27\x84\xc9\x4d"
+xa+="\x97\x0a\xc9\xb5\xe3\x5e\xfd\x22\xd4\x18\xd3\x1b\x68\xd9\x55\x0b"
+xa+="\xaa\x77\x16\xe9\x8e\xa6\x78\x3b\xb3\xa8\x45\x05\x9f\xba\xa4\xa6"
+xa+="\x72\x0a\x6a\x23\xc5\x6b\xa5\x2b\x4d\x9b\x72\x6e\x00\x68\xe9\xeb"
+xa+="\x4d\x17\x5b\xff\x43\x69\xf3\xd2\xa4\xaf\x66\xee\xcd\x62\xef\x7b"
+xa+="\x23\xc3\x37\xd4\x70\x95\x2b\x17\x67\xc8\xbf\x78\x2f\x0b\x58\xb4"
+xa+="\xfc\x82\x45\xf8\x40\x78\x71\x70\xf4\xb0\xa5\x1b\x5e\xb4\x60\x75"
+xa+="\x8a\xdd\xc9\xf4\x4a\x73\xa3\xf6\x07\x60\x3b\xd3\x50\x73\xd1\xa6"
+xa+="\x9a\x20\x3a\x04\x94\xa8\xc2\x02\x1b\xa0\xda\x1f\x04\x95\xf5\x60"
+xa+="\xc0\xba\x81\x79\x4e\xee\xeb\x82\x5d\x1b\xd3\x43\x16\xa5\x2a\xe1"
+xa+="\xc9\x00\x10\x0c\x0d\x6f\xa0\x25\x46\xed\x7a\x9c\x38\xa6\xa3\x43"
+xa+="\xd6\x86\x59\xee\xb5\x9c\xf3\x81\x04\xa9\x6b\xb2\x5a\x6d\xbb\xf0"
+xa+="\xcb\xc0\xed\xe7\x3a\x7b\xba\x67\x51\x81\xe0\xcd\x2e\x7b\x9f\x89"
+
+# Z
+read -d '' shared <<"EOF"
+057c22b8 c5872fef 08ebe852 fafab4b7 c2c2ffbb 376d71bd a941b16e 32614adf
+ebb82aeb d50f29d3 cec63d10 77f50e21 cf381b87 a818c614 52c5cce2 af85f40c
+06615b97 fe8c3a80 68990ac5 83957b52 8dd6d52d a3b51e84 aec355fd 4a3fe5ce
+faa3b17c 9e71cb4d 28ecab6d 21297280 e52397b7 ccb1b62d 8d5d3ce4 1d26b2a3
+bdbf880b b39e8b02 8a745ff2 9f0984da efe97084 5d850884 525403ca d2a52956
+f55b9a89 b2d801f1 710333c0 479c5955 b54c8163 83c65ad9 c78b8c67 cc1b211b
+208b9fab b9c99a68 18293e6a 8da069e6 75eb4317 668a7d4b 6f235533 f3ff4ed0
+4f8ad579 f9ad14e7 f68ae183 41d603d9 d6297123 00716c98 bbbf16eb 2a2cc92f
+EOF
+
+# OI
+otherinfo="\xa1\xb2\xc3\xd4\xe5\x43\x41\x56\x53\x69\x64\xaa\x27\xe2\x49"
+otherinfo+="\xbf\x0a\x12\x76\x46\x8d\x80\x82\x59\xf3\xb8\xe2\x68\x78\x51"
+
+# DKM
+read -d '' derived <<"EOF"
+88bf39c0 08eec33a dc3b4430 054ba262
+EOF
+
+pcreate_key "-e $prime" user dh:prime @s
+expect_keyid primeid
+
+pcreate_key "-e $xa" user dh:xa @s
+expect_keyid xaid
+
+pcreate_key "-e $private" user dh:private @s
+expect_keyid privateid
+
+marker "COMPUTE DH SHARED SECRET"
+dh_compute $privateid $primeid $xaid
+expect_multiline payload "$shared"
+
+marker "COMPUTE DERIVED KEY FROM DH SHARED SECRET (SHA-224)"
+echo -e -n $otherinfo | dh_compute_kdf_oi $privateid $primeid $xaid 16 "kdf_ctr(sha224)"
+expect_multiline payload "$derived"
+
 # --- then report the results in the database ---
 toolbox_report_result $TEST $result
diff --git a/tests/toolbox.inc.sh b/tests/toolbox.inc.sh
index 7f19a02..27b253f 100644
--- a/tests/toolbox.inc.sh
+++ b/tests/toolbox.inc.sh
@@ -1106,6 +1106,50 @@ function dh_compute ()
 
 ###############################################################################
 #
+# Do a DH computation post-processed by a KDF
+#
+###############################################################################
+function dh_compute_kdf ()
+{
+    my_exitval=0
+    if [ "x$1" = "x--fail" ]
+    then
+	my_exitval=1
+	shift
+    fi
+
+    echo keyctl dh_compute_kdf $@ >>$OUTPUTFILE
+    keyctl dh_compute_kdf $@ >>$OUTPUTFILE 2>&1
+    if [ $? != $my_exitval ]
+    then
+	failed
+    fi
+}
+
+###############################################################################
+#
+# Do a DH computation post-processed by a KDF with other information
+#
+###############################################################################
+function dh_compute_kdf_oi ()
+{
+    my_exitval=0
+    if [ "x$1" = "x--fail" ]
+    then
+	my_exitval=1
+	shift
+    fi
+
+    echo keyctl dh_compute_kdf_oi $@ >>$OUTPUTFILE
+    keyctl dh_compute_kdf_oi $@ >>$OUTPUTFILE 2>&1
+    if [ $? != $my_exitval ]
+    then
+	failed
+    fi
+}
+
+###############################################################################
+#
 # Make sure we sleep at least N seconds
 #
 ###############################################################################
diff --git a/version.lds b/version.lds
index 2bfed13..b8eebfb 100644
--- a/version.lds
+++ b/version.lds
@@ -66,5 +66,7 @@ KEYUTILS_1.6 {
 	/* management functions */
 	keyctl_dh_compute;
 	keyctl_dh_compute_alloc;
+	keyctl_dh_compute_kdf;
+	keyctl_dh_compute_kdf_alloc;
 
 } KEYUTILS_1.5;
-- 
2.7.4
