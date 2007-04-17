From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Subject: [PATCH] crypto: convert "crypto" subdirectory to UTF-8
Date: Tue, 17 Apr 2007 13:25:49 -0400 (EDT)
Message-ID: <alpine.DEB.0.83.0704171322280.914@sigma.j-a-k-j.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1875672472-344198655-1176830752=:914"
Cc: trivial@kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, linux-crypto@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1161178AbXDQRcV@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1875672472-344198655-1176830752=:914
Content-Type: TEXT/PLAIN; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT

From: John Anthony Kazos Jr. <jakj@j-a-k-j.com>

Convert the subdirectory "crypto" to UTF-8. The files changed are 
<crypto/fcrypt.c> and <crypto/api.c>.

Signed-off-by: John Anthony Kazos Jr. <jakj@j-a-k-j.com>

---

I can't get my mail client to send in ISO-8859-1 instead of UTF-8, so the 
actual patch is attached in octet-stream format. The below patch is just 
for reference and will almost certainly NOT work.

Also, since the patch includes both encodings, whichever encoding you 
select while viewing it will display one correct and one garbled line. 
However, the bytecodes -are- correct.

diff -uprN linux-2.6.21-rc7.orig/crypto/api.c linux-2.6.21-rc7.mod/crypto/api.c
--- linux-2.6.21-rc7.orig/crypto/api.c	2007-04-17 11:41:50.000000000 -0400
+++ linux-2.6.21-rc7.mod/crypto/api.c	2007-04-17 13:21:52.000000000 -0400
@@ -6,7 +6,7 @@
  * Copyright (c) 2005 Herbert Xu <herbert@gondor.apana.org.au>
  *
  * Portions derived from Cryptoapi, by Alexander Kjeldaas <astor@fast.no>
- * and Nettle, by Niels Möller.
+ * and Nettle, by Niels MÃ¶ller.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
diff -uprN linux-2.6.21-rc7.orig/crypto/fcrypt.c linux-2.6.21-rc7.mod/crypto/fcrypt.c
--- linux-2.6.21-rc7.orig/crypto/fcrypt.c	2007-04-17 11:41:50.000000000 -0400
+++ linux-2.6.21-rc7.mod/crypto/fcrypt.c	2007-04-17 13:21:52.000000000 -0400
@@ -10,7 +10,7 @@
  *
  * Based on code:
  *
- * Copyright (c) 1995 - 2000 Kungliga Tekniska Högskolan
+ * Copyright (c) 1995 - 2000 Kungliga Tekniska HÃ¶gskolan
  * (Royal Institute of Technology, Stockholm, Sweden).
  * All rights reserved.
  *
--1875672472-344198655-1176830752=:914
Content-Type: APPLICATION/octet-stream; name=patch-crypto.bin
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.0.83.0704171325490.914@sigma.j-a-k-j.com>
Content-Description: 
Content-Disposition: attachment; filename=patch-crypto.bin

ZGlmZiAtdXByTiBsaW51eC0yLjYuMjEtcmM3Lm9yaWcvY3J5cHRvL2FwaS5j
IGxpbnV4LTIuNi4yMS1yYzcubW9kL2NyeXB0by9hcGkuYwotLS0gbGludXgt
Mi42LjIxLXJjNy5vcmlnL2NyeXB0by9hcGkuYwkyMDA3LTA0LTE3IDExOjQx
OjUwLjAwMDAwMDAwMCAtMDQwMAorKysgbGludXgtMi42LjIxLXJjNy5tb2Qv
Y3J5cHRvL2FwaS5jCTIwMDctMDQtMTcgMTM6MjE6NTIuMDAwMDAwMDAwIC0w
NDAwCkBAIC02LDcgKzYsNyBAQAogICogQ29weXJpZ2h0IChjKSAyMDA1IEhl
cmJlcnQgWHUgPGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdT4KICAqCiAg
KiBQb3J0aW9ucyBkZXJpdmVkIGZyb20gQ3J5cHRvYXBpLCBieSBBbGV4YW5k
ZXIgS2plbGRhYXMgPGFzdG9yQGZhc3Qubm8+Ci0gKiBhbmQgTmV0dGxlLCBi
eSBOaWVscyBN9mxsZXIuCisgKiBhbmQgTmV0dGxlLCBieSBOaWVscyBNw7Zs
bGVyLgogICoKICAqIFRoaXMgcHJvZ3JhbSBpcyBmcmVlIHNvZnR3YXJlOyB5
b3UgY2FuIHJlZGlzdHJpYnV0ZSBpdCBhbmQvb3IgbW9kaWZ5IGl0CiAgKiB1
bmRlciB0aGUgdGVybXMgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNl
bnNlIGFzIHB1Ymxpc2hlZCBieSB0aGUgRnJlZQpkaWZmIC11cHJOIGxpbnV4
LTIuNi4yMS1yYzcub3JpZy9jcnlwdG8vZmNyeXB0LmMgbGludXgtMi42LjIx
LXJjNy5tb2QvY3J5cHRvL2ZjcnlwdC5jCi0tLSBsaW51eC0yLjYuMjEtcmM3
Lm9yaWcvY3J5cHRvL2ZjcnlwdC5jCTIwMDctMDQtMTcgMTE6NDE6NTAuMDAw
MDAwMDAwIC0wNDAwCisrKyBsaW51eC0yLjYuMjEtcmM3Lm1vZC9jcnlwdG8v
ZmNyeXB0LmMJMjAwNy0wNC0xNyAxMzoyMTo1Mi4wMDAwMDAwMDAgLTA0MDAK
QEAgLTEwLDcgKzEwLDcgQEAKICAqCiAgKiBCYXNlZCBvbiBjb2RlOgogICoK
LSAqIENvcHlyaWdodCAoYykgMTk5NSAtIDIwMDAgS3VuZ2xpZ2EgVGVrbmlz
a2EgSPZnc2tvbGFuCisgKiBDb3B5cmlnaHQgKGMpIDE5OTUgLSAyMDAwIEt1
bmdsaWdhIFRla25pc2thIEjDtmdza29sYW4KICAqIChSb3lhbCBJbnN0aXR1
dGUgb2YgVGVjaG5vbG9neSwgU3RvY2tob2xtLCBTd2VkZW4pLgogICogQWxs
IHJpZ2h0cyByZXNlcnZlZC4KICAqCg==

--1875672472-344198655-1176830752=:914--
