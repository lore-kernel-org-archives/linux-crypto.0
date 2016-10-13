From: Harsh Jain <harsh@chelsio.com>
Subject: [PATCH 1/6] chcr:Fix memory corruption done
Date: Thu, 13 Oct 2016 16:39:34 +0530
Message-ID: <f255ca225c78bc5c6b0113441b131ebd574634c2.1476263960.git.harsh@chelsio.com>
References: <cover.1476263960.git.harsh@chelsio.com>
Cc: jlulla@chelsio.com, atul.gupta@chelsio.com, yeshaswi@chelsio.com,
        hariprasad@chelsio.com, Harsh Jain <harsh@chelsio.com>,
        Jitendra Lulla <JLULLA@chelsio.com>
To: dan.carpenter@oracle.com, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:30521 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753419AbcJMNCu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Oct 2016 09:02:50 -0400
In-Reply-To: <cover.1476263960.git.harsh@chelsio.com>
In-Reply-To: <cover.1476263960.git.harsh@chelsio.com>
References: <cover.1476263960.git.harsh@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix memory corruption done by  *((u32 *)dec_key + k) operation.

Signed-off-by: Jitendra Lulla <JLULLA@chelsio.com>
---
 drivers/crypto/chelsio/chcr_algo.c | 52 ++++++++++++++++++++++++++++++++++
 drivers/crypto/chelsio/chcr_algo.h | 58 +-------------------------------------
 2 files changed, 53 insertions(+), 57 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index e4ddb92..944c11f 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -178,6 +178,58 @@ static inline unsigned int calc_tx_flits_ofld(const struct sk_buff *skb)
 	return flits + sgl_len(cnt);
 }
 
+static void get_aes_decrypt_key(unsigned char *dec_key,
+				const unsigned char *key,
+				unsigned int keylength)
+{
+	u32 temp;
+	u32 w_ring[MAX_NK];
+	int i, j, k;
+	u8  nr, nk;
+
+	switch (keylength) {
+	case AES_KEYLENGTH_128BIT:
+		nk = KEYLENGTH_4BYTES;
+		nr = NUMBER_OF_ROUNDS_10;
+		break;
+	case AES_KEYLENGTH_192BIT:
+		nk = KEYLENGTH_6BYTES;
+		nr = NUMBER_OF_ROUNDS_12;
+		break;
+	case AES_KEYLENGTH_256BIT:
+		nk = KEYLENGTH_8BYTES;
+		nr = NUMBER_OF_ROUNDS_14;
+		break;
+	default:
+		return;
+	}
+	for (i = 0; i < nk; i++)
+		w_ring[i] = be32_to_cpu(*(u32 *)&key[4 * i]);
+
+	i = 0;
+	temp = w_ring[nk - 1];
+	while (i + nk < (nr + 1) * 4) {
+		if (!(i % nk)) {
+			/* RotWord(temp) */
+			temp = (temp << 8) | (temp >> 24);
+			temp = aes_ks_subword(temp);
+			temp ^= round_constant[i / nk];
+		} else if (nk == 8 && (i % 4 == 0)) {
+			temp = aes_ks_subword(temp);
+		}
+		w_ring[i % nk] ^= temp;
+		temp = w_ring[i % nk];
+		i++;
+	}
+	i--;
+	for (k = 0, j = i % nk; k < nk; k++) {
+		*((u32 *)dec_key + k) = htonl(w_ring[j]);
+		j--;
+		if (j < 0)
+			j += nk;
+	}
+}
+
 static struct shash_desc *chcr_alloc_shash(unsigned int ds)
 {
 	struct crypto_shash *base_hash = NULL;
diff --git a/drivers/crypto/chelsio/chcr_algo.h b/drivers/crypto/chelsio/chcr_algo.h
index ec64fbc..f34bc91 100644
--- a/drivers/crypto/chelsio/chcr_algo.h
+++ b/drivers/crypto/chelsio/chcr_algo.h
@@ -394,7 +394,7 @@ static const u8 aes_sbox[256] = {
 	187, 22
 };
 
-static u32 aes_ks_subword(const u32 w)
+static inline u32 aes_ks_subword(const u32 w)
 {
 	u8 bytes[4];
 
@@ -412,60 +412,4 @@ static u32 round_constant[11] = {
 	0x1B000000, 0x36000000, 0x6C000000
 };
 
-/* dec_key - OUTPUT - Reverse round key
- * key - INPUT - key
- * keylength - INPUT - length of the key in number of bits
- */
-static inline void get_aes_decrypt_key(unsigned char *dec_key,
-				       const unsigned char *key,
-				       unsigned int keylength)
-{
-	u32 temp;
-	u32 w_ring[MAX_NK];
-	int i, j, k = 0;
-	u8  nr, nk;
-
-	switch (keylength) {
-	case AES_KEYLENGTH_128BIT:
-		nk = KEYLENGTH_4BYTES;
-		nr = NUMBER_OF_ROUNDS_10;
-		break;
-
-	case AES_KEYLENGTH_192BIT:
-		nk = KEYLENGTH_6BYTES;
-		nr = NUMBER_OF_ROUNDS_12;
-		break;
-	case AES_KEYLENGTH_256BIT:
-		nk = KEYLENGTH_8BYTES;
-		nr = NUMBER_OF_ROUNDS_14;
-		break;
-	default:
-		return;
-	}
-	for (i = 0; i < nk; i++ )
-		w_ring[i] = be32_to_cpu(*(u32 *)&key[4 * i]);
-
-	i = 0;
-	temp = w_ring[nk - 1];
-	while(i + nk < (nr + 1) * 4) {
-		if(!(i % nk)) {
-			/* RotWord(temp) */
-			temp = (temp << 8) | (temp >> 24);
-			temp = aes_ks_subword(temp);
-			temp ^= round_constant[i / nk];
-		}
-		else if (nk == 8 && (i % 4 == 0))
-			temp = aes_ks_subword(temp);
-		w_ring[i % nk] ^= temp;
-		temp = w_ring[i % nk];
-		i++;
-	}
-	for (k = 0, j = i % nk; k < nk; k++) {
-		*((u32 *)dec_key + k) = htonl(w_ring[j]);
-		j--;
-		if(j < 0)
-			j += nk;
-	}
-}
-
 #endif /* __CHCR_ALGO_H__ */
-- 
1.8.2.3
