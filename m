From: Mathias Krause <minipli@googlemail.com>
Subject: [PATCH] crypto: aesni - fix "by8" variant for 128 bit keys
Date: Tue, 30 Dec 2014 22:50:54 +0100
Message-ID: <1419976254-30208-1-git-send-email-minipli@googlemail.com>
Cc: linux-crypto@vger.kernel.org,
	Mathias Krause <minipli@googlemail.com>,
	Romain Francoise <romain@orebokech.com>,
	Chandramouli Narayanan <mouli@linux.intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	James Yonan <james@openvpn.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42374 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbaL3VvQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 30 Dec 2014 16:51:16 -0500
Received: by mail-wg0-f44.google.com with SMTP id b13so21257504wgh.3
        for <linux-crypto@vger.kernel.org>; Tue, 30 Dec 2014 13:51:14 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The "by8" counter mode optimization is broken for 128 bit keys with
input data longer than 128 bytes. It uses the wrong key material for
en- and decryption.

The key registers xkey0, xkey4, xkey8 and xkey12 need to be preserved
in case we're handling more than 128 bytes of input data -- they won't
get reloaded after the initial load. They must therefore be (a) loaded
on the first iteration and (b) be preserved for the latter ones. The
implementation for 128 bit keys does not comply with (a) nor (b).

Fix this by bringing the implementation back to its original source
and correctly load the key registers and preserve their values by
*not* re-using the registers for other purposes.

Kudos to James for reporting the issue and providing a test case
showing the discrepancies.

Reported-by: James Yonan <james@openvpn.net>
Cc: Chandramouli Narayanan <mouli@linux.intel.com>
Cc: <stable@vger.kernel.org> # v3.18
Signed-off-by: Mathias Krause <minipli@googlemail.com>
---

James, this should fix the issue for you, too -- it did for me, using
your test case. Feel free to add your 'Tested-by' if it does.

This patch should go on top of crypto-2.6.git#master as it's a fix
that needs to go to stable as well.

 arch/x86/crypto/aes_ctrby8_avx-x86_64.S |   46 +++++++++++++++++++++++--------
 1 file changed, 35 insertions(+), 11 deletions(-)

diff --git a/arch/x86/crypto/aes_ctrby8_avx-x86_64.S b/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
index 2df2a0298f5a..a916c4a61165 100644
--- a/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
+++ b/arch/x86/crypto/aes_ctrby8_avx-x86_64.S
@@ -208,7 +208,7 @@ ddq_add_8:
 
 	.if (klen == KEY_128)
 		.if (load_keys)
-			vmovdqa	3*16(p_keys), xkeyA
+			vmovdqa	3*16(p_keys), xkey4
 		.endif
 	.else
 		vmovdqa	3*16(p_keys), xkeyA
@@ -224,7 +224,7 @@ ddq_add_8:
 	add	$(16*by), p_in
 
 	.if (klen == KEY_128)
-		vmovdqa	4*16(p_keys), xkey4
+		vmovdqa	4*16(p_keys), xkeyB
 	.else
 		.if (load_keys)
 			vmovdqa	4*16(p_keys), xkey4
@@ -234,7 +234,12 @@ ddq_add_8:
 	.set i, 0
 	.rept by
 		club XDATA, i
-		vaesenc	xkeyA, var_xdata, var_xdata		/* key 3 */
+		/* key 3 */
+		.if (klen == KEY_128)
+			vaesenc	xkey4, var_xdata, var_xdata
+		.else
+			vaesenc	xkeyA, var_xdata, var_xdata
+		.endif
 		.set i, (i +1)
 	.endr
 
@@ -243,13 +248,18 @@ ddq_add_8:
 	.set i, 0
 	.rept by
 		club XDATA, i
-		vaesenc	xkey4, var_xdata, var_xdata		/* key 4 */
+		/* key 4 */
+		.if (klen == KEY_128)
+			vaesenc	xkeyB, var_xdata, var_xdata
+		.else
+			vaesenc	xkey4, var_xdata, var_xdata
+		.endif
 		.set i, (i +1)
 	.endr
 
 	.if (klen == KEY_128)
 		.if (load_keys)
-			vmovdqa	6*16(p_keys), xkeyB
+			vmovdqa	6*16(p_keys), xkey8
 		.endif
 	.else
 		vmovdqa	6*16(p_keys), xkeyB
@@ -267,12 +277,17 @@ ddq_add_8:
 	.set i, 0
 	.rept by
 		club XDATA, i
-		vaesenc	xkeyB, var_xdata, var_xdata		/* key 6 */
+		/* key 6 */
+		.if (klen == KEY_128)
+			vaesenc	xkey8, var_xdata, var_xdata
+		.else
+			vaesenc	xkeyB, var_xdata, var_xdata
+		.endif
 		.set i, (i +1)
 	.endr
 
 	.if (klen == KEY_128)
-		vmovdqa	8*16(p_keys), xkey8
+		vmovdqa	8*16(p_keys), xkeyB
 	.else
 		.if (load_keys)
 			vmovdqa	8*16(p_keys), xkey8
@@ -288,7 +303,7 @@ ddq_add_8:
 
 	.if (klen == KEY_128)
 		.if (load_keys)
-			vmovdqa	9*16(p_keys), xkeyA
+			vmovdqa	9*16(p_keys), xkey12
 		.endif
 	.else
 		vmovdqa	9*16(p_keys), xkeyA
@@ -297,7 +312,12 @@ ddq_add_8:
 	.set i, 0
 	.rept by
 		club XDATA, i
-		vaesenc	xkey8, var_xdata, var_xdata		/* key 8 */
+		/* key 8 */
+		.if (klen == KEY_128)
+			vaesenc	xkeyB, var_xdata, var_xdata
+		.else
+			vaesenc	xkey8, var_xdata, var_xdata
+		.endif
 		.set i, (i +1)
 	.endr
 
@@ -306,7 +326,12 @@ ddq_add_8:
 	.set i, 0
 	.rept by
 		club XDATA, i
-		vaesenc	xkeyA, var_xdata, var_xdata		/* key 9 */
+		/* key 9 */
+		.if (klen == KEY_128)
+			vaesenc	xkey12, var_xdata, var_xdata
+		.else
+			vaesenc	xkeyA, var_xdata, var_xdata
+		.endif
 		.set i, (i +1)
 	.endr
 
@@ -412,7 +437,6 @@ ddq_add_8:
 /* main body of aes ctr load */
 
 .macro do_aes_ctrmain key_len
-
 	cmp	$16, num_bytes
 	jb	.Ldo_return2\key_len
 
-- 
1.7.10.4
