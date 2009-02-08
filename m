From: "George Spelvin" <linux@horizon.com>
Subject: [PATCH 10/10] crypto/des_generic: Add a few comments.
Date: Sun, 08 Feb 2009 06:54:45 -0500
Message-ID: <20090208115445.6305.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux@horizon.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from science.horizon.com ([192.35.100.1]:17696 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752450AbZBHMB0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 8 Feb 2009 07:01:26 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

---
 crypto/des_generic.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/crypto/des_generic.c b/crypto/des_generic.c
index a4f3165..ff95f7b 100644
--- a/crypto/des_generic.c
+++ b/crypto/des_generic.c
@@ -67,6 +67,12 @@ static const u8 pc1[256] = {
 	0xae, 0xea, 0xee, 0xee, 0xbe, 0xfa, 0xfe, 0xfe
 };
 
+/*
+ * This table rotates the most significant 7 bits one place right.
+ * rs[i] = (i >> 1 & 0x7e) + (i << 6 & 0x80)
+ * Note that the odd elements of this array are actually
+ * "don't care"; the index used always has the low bit clear.
+ */
 static const u8 rs[256] = {
 	0x00, 0x00, 0x80, 0x80, 0x02, 0x02, 0x82, 0x82,
 	0x04, 0x04, 0x84, 0x84, 0x06, 0x06, 0x86, 0x86,
@@ -102,6 +108,11 @@ static const u8 rs[256] = {
 	0x7c, 0x7c, 0xfc, 0xfc, 0x7e, 0x7e, 0xfe, 0xfe
 };
 
+/*
+ * The pc2 table consists of 2 sections.  Each section is
+ * 4 columns of 128 entries each.  See the PC2() macro
+ * for details.
+ */
 static const u32 pc2[1024] = {
 	0x00000000, 0x00000000, 0x00000000, 0x00000000,
 	0x00040000, 0x00000000, 0x04000000, 0x00100000,
@@ -590,7 +601,7 @@ static const u32 S8[64] = {
  */
 unsigned long des_ekey(u32 pe[DES_EXPKEY_WORDS], const u8 k[DES_KEY_SIZE])
 {
-	/* K&R: long is at least 32 bits */
+	/* Long is the size of pointer, so good for indexing */
 	unsigned long a, b, c, d, w;
 	const u32 *pt = pc2;
 
-- 
1.6.0.6

