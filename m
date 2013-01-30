From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Subject: [PATCH 1/2] digsig: remove unnecessary memory allocation and copying
Date: Wed, 30 Jan 2013 11:30:05 +0200
Message-ID: <1ed8eac5fb76f096b794a5f7326eb60a3013ce3d.1359538137.git.dmitry.kasatkin@intel.com>
References: <cover.1359538137.git.dmitry.kasatkin@intel.com>
Cc: jmorris@namei.org
To: linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <cover.1359538137.git.dmitry.kasatkin@intel.com>
In-Reply-To: <cover.1359538137.git.dmitry.kasatkin@intel.com>
References: <cover.1359538137.git.dmitry.kasatkin@intel.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

In existing use case, copying of the decoded data is unnecessary in
pkcs_1_v1_5_decode_emsa. It is just enough to get pointer to the message.
Removing copying and extra buffer allocation.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
---
 lib/digsig.c |   41 ++++++++++++++---------------------------
 1 file changed, 14 insertions(+), 27 deletions(-)

diff --git a/lib/digsig.c b/lib/digsig.c
index dc2be7e..2f31e6a 100644
--- a/lib/digsig.c
+++ b/lib/digsig.c
@@ -30,11 +30,10 @@
 
 static struct crypto_shash *shash;
 
-static int pkcs_1_v1_5_decode_emsa(const unsigned char *msg,
-			unsigned long  msglen,
-			unsigned long  modulus_bitlen,
-			unsigned char *out,
-			unsigned long *outlen)
+static const char *pkcs_1_v1_5_decode_emsa(const unsigned char *msg,
+						unsigned long  msglen,
+						unsigned long  modulus_bitlen,
+						unsigned long *outlen)
 {
 	unsigned long modulus_len, ps_len, i;
 
@@ -42,11 +41,11 @@ static int pkcs_1_v1_5_decode_emsa(const unsigned char *msg,
 
 	/* test message size */
 	if ((msglen > modulus_len) || (modulus_len < 11))
-		return -EINVAL;
+		return NULL;
 
 	/* separate encoded message */
-	if ((msg[0] != 0x00) || (msg[1] != (unsigned char)1))
-		return -EINVAL;
+	if (msg[0] != 0x00 || msg[1] != 0x01)
+		return NULL;
 
 	for (i = 2; i < modulus_len - 1; i++)
 		if (msg[i] != 0xFF)
@@ -56,19 +55,13 @@ static int pkcs_1_v1_5_decode_emsa(const unsigned char *msg,
 	if (msg[i] != 0)
 		/* There was no octet with hexadecimal value 0x00
 		to separate ps from m. */
-		return -EINVAL;
+		return NULL;
 
 	ps_len = i - 2;
 
-	if (*outlen < (msglen - (2 + ps_len + 1))) {
-		*outlen = msglen - (2 + ps_len + 1);
-		return -EOVERFLOW;
-	}
-
 	*outlen = (msglen - (2 + ps_len + 1));
-	memcpy(out, &msg[2 + ps_len + 1], *outlen);
 
-	return 0;
+	return msg + 2 + ps_len + 1;
 }
 
 /*
@@ -83,7 +76,8 @@ static int digsig_verify_rsa(struct key *key,
 	unsigned long mlen, mblen;
 	unsigned nret, l;
 	int head, i;
-	unsigned char *out1 = NULL, *out2 = NULL;
+	unsigned char *out1 = NULL;
+	const char *m;
 	MPI in = NULL, res = NULL, pkey[2];
 	uint8_t *p, *datap, *endp;
 	struct user_key_payload *ukp;
@@ -120,7 +114,7 @@ static int digsig_verify_rsa(struct key *key,
 	}
 
 	mblen = mpi_get_nbits(pkey[0]);
-	mlen = (mblen + 7)/8;
+	mlen = DIV_ROUND_UP(mblen, 8);
 
 	if (mlen == 0)
 		goto err;
@@ -129,10 +123,6 @@ static int digsig_verify_rsa(struct key *key,
 	if (!out1)
 		goto err;
 
-	out2 = kzalloc(mlen, GFP_KERNEL);
-	if (!out2)
-		goto err;
-
 	nret = siglen;
 	in = mpi_read_from_buffer(sig, &nret);
 	if (!in)
@@ -164,18 +154,15 @@ static int digsig_verify_rsa(struct key *key,
 
 	kfree(p);
 
-	err = pkcs_1_v1_5_decode_emsa(out1, len, mblen, out2, &len);
-	if (err)
-		goto err;
+	m = pkcs_1_v1_5_decode_emsa(out1, len, mblen, &len);
 
-	if (len != hlen || memcmp(out2, h, hlen))
+	if (!m || len != hlen || memcmp(m, h, hlen))
 		err = -EINVAL;
 
 err:
 	mpi_free(in);
 	mpi_free(res);
 	kfree(out1);
-	kfree(out2);
 	while (--i >= 0)
 		mpi_free(pkey[i]);
 err1:
-- 
1.7.10.4

