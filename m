From: Fabio Estevam <festevam@gmail.com>
Subject: [PATCH v3] crypto: caam: Drop leading zero from input buffer
Date: Sun, 15 Apr 2018 11:12:38 -0300
Message-ID: <1523801558-21647-1-git-send-email-festevam@gmail.com>
Cc: horia.geanta@nxp.com, aymen.sghaier@nxp.com,
        mtownsend1973@gmail.com, breno.lima@nxp.com,
        bryan.odonoghue@linaro.org, linux-crypto@vger.kernel.org,
        Fabio Estevam <fabio.estevam@nxp.com>, stable@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Fabio Estevam <fabio.estevam@nxp.com>

imx6ul and imx7 report the following error:

caam_jr 2142000.jr1: 40000789: DECO: desc idx 7:
Protocol Size Error - A protocol has seen an error in size. When
running RSA, pdb size N < (size of F) when no formatting is used; or
pdb size N < (F + 11) when formatting is used.

------------[ cut here ]------------
WARNING: CPU: 0 PID: 1 at crypto/asymmetric_keys/public_key.c:148
public_key_verify_signature+0x27c/0x2b0

This error happens because the signature contains 257 bytes, including
a leading zero as the first element.

Fix the problem by stripping off the leading zero from input data
before feeding it to the CAAM accelerator.

Fixes: 8c419778ab57e497b5 ("crypto: caam - add support for RSA algorithm")
Cc: <stable@vger.kernel.org>
Reported-by: Martin Townsend <mtownsend1973@gmail.com>
Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
---
Changes since v2:
- Check if the lenght is zero after calling caam_rsa_drop_leading_zeros()

 drivers/crypto/caam/caampkc.c | 45 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 37 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index 7a897209..47467ff 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -166,6 +166,14 @@ static void rsa_priv_f3_done(struct device *dev, u32 *desc, u32 err,
 	akcipher_request_complete(req, err);
 }
 
+static void caam_rsa_drop_leading_zeros(const u8 **ptr, size_t *nbytes)
+{
+	while (!**ptr && *nbytes) {
+		(*ptr)++;
+		(*nbytes)--;
+	}
+}
+
 static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,
 					 size_t desclen)
 {
@@ -178,7 +186,36 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,
 	int sgc;
 	int sec4_sg_index, sec4_sg_len = 0, sec4_sg_bytes;
 	int src_nents, dst_nents;
+	const u8 *temp;
+	void *buffer;
+	size_t len;
+
+	buffer = kzalloc(req->src_len, GFP_ATOMIC);
+	if (!buffer)
+		return ERR_PTR(-ENOMEM);
+
+	sg_copy_to_buffer(req->src, sg_nents(req->src),
+			  buffer, req->src_len);
+	temp = (u8 *)buffer;
+	len = req->src_len;
 
+	/*
+	 * Check if the buffer contains leading zeros and if
+	 * it does, drop the leading zeros
+	 */
+	if (temp[0] == 0) {
+		caam_rsa_drop_leading_zeros(&temp, &len);
+		if (!len) {
+			kfree(buffer);
+			return ERR_PTR(-ENOMEM);
+		}
+
+		req->src_len = len;
+		sg_copy_from_buffer(req->src, sg_nents(req->src),
+				    (void *)temp, req->src_len);
+	}
+
+	kfree(buffer);
 	src_nents = sg_nents_for_len(req->src, req->src_len);
 	dst_nents = sg_nents_for_len(req->dst, req->dst_len);
 
@@ -683,14 +720,6 @@ static void caam_rsa_free_key(struct caam_rsa_key *key)
 	memset(key, 0, sizeof(*key));
 }
 
-static void caam_rsa_drop_leading_zeros(const u8 **ptr, size_t *nbytes)
-{
-	while (!**ptr && *nbytes) {
-		(*ptr)++;
-		(*nbytes)--;
-	}
-}
-
 /**
  * caam_read_rsa_crt - Used for reading dP, dQ, qInv CRT members.
  * dP, dQ and qInv could decode to less than corresponding p, q length, as the
-- 
2.7.4
