From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [RFC PATCH 4/4] crypto: testmgr - add genkey kpp test
Date: Wed, 17 May 2017 13:38:36 +0300
Message-ID: <1495017516-10048-5-git-send-email-tudor.ambarus@microchip.com>
References: <1495017516-10048-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <smueller@chronox.de>,
        <marcel@holtmann.org>, <Nicolas.Ferre@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:34402 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752974AbdEQKjE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 May 2017 06:39:04 -0400
In-Reply-To: <1495017516-10048-1-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The test considers a party that already has a private-public
key pair and a party that provides a NULL key. The kernel will
generate the private-public key pair for the latter, computes
the shared secret on both ends and verifies it it's the same.

The explicit private-public key pairs were copied from
the previous test vectors.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 crypto/testmgr.c |  77 +++++++++++++++++++++++----
 crypto/testmgr.h | 155 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 221 insertions(+), 11 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 6f5f3ed..48438ef 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1997,6 +1997,9 @@ static int do_test_kpp(struct crypto_kpp *tfm, const struct kpp_testvec *vec,
 	struct kpp_request *req;
 	void *input_buf = NULL;
 	void *output_buf = NULL;
+	void *a_public = NULL;
+	void *a_ss = NULL;
+	void *shared_secret = NULL;
 	struct tcrypt_result result;
 	unsigned int out_len_max;
 	int err = -ENOMEM;
@@ -2026,20 +2029,32 @@ static int do_test_kpp(struct crypto_kpp *tfm, const struct kpp_testvec *vec,
 	kpp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
 				 tcrypt_complete, &result);
 
-	/* Compute public key */
+	/* Compute party A's public key */
 	err = wait_async_op(&result, crypto_kpp_generate_public_key(req));
 	if (err) {
-		pr_err("alg: %s: generate public key test failed. err %d\n",
+		pr_err("alg: %s: Party A: generate public key test failed. err %d\n",
 		       alg, err);
 		goto free_output;
 	}
-	/* Verify calculated public key */
-	if (memcmp(vec->expected_a_public, sg_virt(req->dst),
-		   vec->expected_a_public_size)) {
-		pr_err("alg: %s: generate public key test failed. Invalid output\n",
-		       alg);
-		err = -EINVAL;
-		goto free_output;
+
+	if (vec->genkey) {
+		/* Save party A's public key */
+		a_public = kzalloc(out_len_max, GFP_KERNEL);
+		if (!a_public) {
+			err = -ENOMEM;
+			goto free_output;
+		}
+		memcpy(a_public, sg_virt(req->dst),
+		       vec->expected_a_public_size);
+	} else {
+		/* Verify calculated public key */
+		if (memcmp(vec->expected_a_public, sg_virt(req->dst),
+			   vec->expected_a_public_size)) {
+			pr_err("alg: %s: Party A: generate public key test failed. Invalid output\n",
+			       alg);
+			err = -EINVAL;
+			goto free_output;
+		}
 	}
 
 	/* Calculate shared secret key by using counter part (b) public key. */
@@ -2058,15 +2073,53 @@ static int do_test_kpp(struct crypto_kpp *tfm, const struct kpp_testvec *vec,
 				 tcrypt_complete, &result);
 	err = wait_async_op(&result, crypto_kpp_compute_shared_secret(req));
 	if (err) {
-		pr_err("alg: %s: compute shard secret test failed. err %d\n",
+		pr_err("alg: %s: Party A: compute shared secret test failed. err %d\n",
 		       alg, err);
 		goto free_all;
 	}
+
+	if (vec->genkey) {
+		/* Save the shared secret obtained by party A */
+		a_ss = kzalloc(vec->expected_ss_size, GFP_KERNEL);
+		if (!a_ss) {
+			err = -ENOMEM;
+			goto free_all;
+		}
+		memcpy(a_ss, sg_virt(req->dst), vec->expected_ss_size);
+
+		/*
+		 * Calculate party B's shared secret by using party A's
+		 * public key.
+		 */
+		err = crypto_kpp_set_secret(tfm, vec->b_secret,
+					    vec->b_secret_size);
+		if (err < 0)
+			goto free_all;
+
+		sg_init_one(&src, a_public, vec->expected_a_public_size);
+		sg_init_one(&dst, output_buf, out_len_max);
+		kpp_request_set_input(req, &src, vec->expected_a_public_size);
+		kpp_request_set_output(req, &dst, out_len_max);
+		kpp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+					 tcrypt_complete, &result);
+		err = wait_async_op(&result,
+				    crypto_kpp_compute_shared_secret(req));
+		if (err) {
+			pr_err("alg: %s: Party B: compute shared secret failed. err %d\n",
+			       alg, err);
+			goto free_all;
+		}
+
+		shared_secret = a_ss;
+	} else {
+		shared_secret = (void *)vec->expected_ss;
+	}
+
 	/*
 	 * verify shared secret from which the user will derive
 	 * secret key by executing whatever hash it has chosen
 	 */
-	if (memcmp(vec->expected_ss, sg_virt(req->dst),
+	if (memcmp(shared_secret, sg_virt(req->dst),
 		   vec->expected_ss_size)) {
 		pr_err("alg: %s: compute shared secret test failed. Invalid output\n",
 		       alg);
@@ -2074,8 +2127,10 @@ static int do_test_kpp(struct crypto_kpp *tfm, const struct kpp_testvec *vec,
 	}
 
 free_all:
+	kfree(a_ss);
 	kfree(input_buf);
 free_output:
+	kfree(a_public);
 	kfree(output_buf);
 free_req:
 	kpp_request_free(req);
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 4293573..a6c6b24 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -137,13 +137,16 @@ struct akcipher_testvec {
 
 struct kpp_testvec {
 	const unsigned char *secret;
+	const unsigned char *b_secret;
 	const unsigned char *b_public;
 	const unsigned char *expected_a_public;
 	const unsigned char *expected_ss;
 	unsigned short secret_size;
+	unsigned short b_secret_size;
 	unsigned short b_public_size;
 	unsigned short expected_a_public_size;
 	unsigned short expected_ss_size;
+	bool genkey;
 };
 
 static const char zeroed_string[48];
@@ -752,6 +755,114 @@ static const struct kpp_testvec dh_tv_template[] = {
 	.b_public_size = 256,
 	.expected_a_public_size = 256,
 	.expected_ss_size = 256,
+	},
+	{
+	.secret =
+#ifdef __LITTLE_ENDIAN
+	"\x01\x00" /* type */
+	"\x11\x01" /* len */
+	"\x00\x00\x00\x00" /* key_size */
+	"\x00\x01\x00\x00" /* p_size */
+	"\x01\x00\x00\x00" /* g_size */
+#else
+	"\x00\x01" /* type */
+	"\x01\x11" /* len */
+	"\x00\x00\x00\x00" /* key_size */
+	"\x00\x00\x01\x00" /* p_size */
+	"\x00\x00\x00\x01" /* g_size */
+#endif
+	/* p */
+	"\xb9\x36\x3a\xf1\x82\x1f\x60\xd3\x22\x47\xb8\xbc\x2d\x22\x6b\x81"
+	"\x7f\xe8\x20\x06\x09\x23\x73\x49\x9a\x59\x8b\x35\x25\xf8\x31\xbc"
+	"\x7d\xa8\x1c\x9d\x56\x0d\x1a\xf7\x4b\x4f\x96\xa4\x35\x77\x6a\x89"
+	"\xab\x42\x00\x49\x21\x71\xed\x28\x16\x1d\x87\x5a\x10\xa7\x9c\x64"
+	"\x94\xd4\x87\x3d\x28\xef\x44\xfe\x4b\xe2\xb4\x15\x8c\x82\xa6\xf3"
+	"\x50\x5f\xa8\xe8\xa2\x60\xe7\x00\x86\x78\x05\xd4\x78\x19\xa1\x98"
+	"\x62\x4e\x4a\x00\x78\x56\x96\xe6\xcf\xd7\x10\x1b\x74\x5d\xd0\x26"
+	"\x61\xdb\x6b\x32\x09\x51\xd8\xa5\xfd\x54\x16\x71\x01\xb3\x39\xe6"
+	"\x4e\x69\xb1\xd7\x06\x8f\xd6\x1e\xdc\x72\x25\x26\x74\xc8\x41\x06"
+	"\x5c\xd1\x26\x5c\xb0\x2f\xf9\x59\x13\xc1\x2a\x0f\x78\xea\x7b\xf7"
+	"\xbd\x59\xa0\x90\x1d\xfc\x33\x5b\x4c\xbf\x05\x9c\x3a\x3f\x69\xa2"
+	"\x45\x61\x4e\x10\x6a\xb3\x17\xc5\x68\x30\xfb\x07\x5f\x34\xc6\xfb"
+	"\x73\x07\x3c\x70\xf6\xae\xe7\x72\x84\xc3\x18\x81\x8f\xe8\x11\x1f"
+	"\x3d\x83\x83\x01\x2a\x14\x73\xbf\x32\x32\x2e\xc9\x4d\xdb\x2a\xca"
+	"\xee\x71\xf9\xda\xad\xe8\x82\x0b\x4d\x0c\x1f\xb6\x1d\xef\x00\x67"
+	"\x74\x3d\x95\xe0\xb7\xc4\x30\x8a\x24\x87\x12\x47\x27\x70\x0d\x73"
+	/* g */
+	"\x02",
+	.b_secret =
+#ifdef __LITTLE_ENDIAN
+	"\x01\x00" /* type */
+	"\x11\x02" /* len */
+	"\x00\x01\x00\x00" /* key_size */
+	"\x00\x01\x00\x00" /* p_size */
+	"\x01\x00\x00\x00" /* g_size */
+#else
+	"\x00\x01" /* type */
+	"\x02\x11" /* len */
+	"\x00\x00\x01\x00" /* key_size */
+	"\x00\x00\x01\x00" /* p_size */
+	"\x00\x00\x00\x01" /* g_size */
+#endif
+	/* xa */
+	"\x4d\x75\xa8\x6e\xba\x23\x3a\x0c\x63\x56\xc8\xc9\x5a\xa7\xd6\x0e"
+	"\xed\xae\x40\x78\x87\x47\x5f\xe0\xa7\x7b\xba\x84\x88\x67\x4e\xe5"
+	"\x3c\xcc\x5c\x6a\xe7\x4a\x20\xec\xbe\xcb\xf5\x52\x62\x9f\x37\x80"
+	"\x0c\x72\x7b\x83\x66\xa4\xf6\x7f\x95\x97\x1c\x6a\x5c\x7e\xf1\x67"
+	"\x37\xb3\x93\x39\x3d\x0b\x55\x35\xd9\xe5\x22\x04\x9f\xf8\xc1\x04"
+	"\xce\x13\xa5\xac\xe1\x75\x05\xd1\x2b\x53\xa2\x84\xef\xb1\x18\xf4"
+	"\x66\xdd\xea\xe6\x24\x69\x5a\x49\xe0\x7a\xd8\xdf\x1b\xb7\xf1\x6d"
+	"\x9b\x50\x2c\xc8\x1c\x1c\xa3\xb4\x37\xfb\x66\x3f\x67\x71\x73\xa9"
+	"\xff\x5f\xd9\xa2\x25\x6e\x25\x1b\x26\x54\xbf\x0c\xc6\xdb\xea\x0a"
+	"\x52\x6c\x16\x7c\x27\x68\x15\x71\x58\x73\x9d\xe6\xc2\x80\xaa\x97"
+	"\x31\x66\xfb\xa6\xfb\xfd\xd0\x9c\x1d\xbe\x81\x48\xf5\x9a\x32\xf1"
+	"\x69\x62\x18\x78\xae\x72\x36\xe6\x94\x27\xd1\xff\x18\x4f\x28\x6a"
+	"\x16\xbd\x6a\x60\xee\xe5\xf9\x6d\x16\xe4\xb8\xa6\x41\x9b\x23\x7e"
+	"\xf7\x9d\xd1\x1d\x03\x15\x66\x3a\xcf\xb6\x2c\x13\x96\x2c\x52\x21"
+	"\xe4\x2d\x48\x7a\x8a\x5d\xb2\x88\xed\x98\x61\x79\x8b\x6a\x1e\x5f"
+	"\xd0\x8a\x2d\x99\x5a\x2b\x0f\xbc\xef\x53\x8f\x32\xc1\xa2\x99\x26"
+	/* p */
+	"\xb9\x36\x3a\xf1\x82\x1f\x60\xd3\x22\x47\xb8\xbc\x2d\x22\x6b\x81"
+	"\x7f\xe8\x20\x06\x09\x23\x73\x49\x9a\x59\x8b\x35\x25\xf8\x31\xbc"
+	"\x7d\xa8\x1c\x9d\x56\x0d\x1a\xf7\x4b\x4f\x96\xa4\x35\x77\x6a\x89"
+	"\xab\x42\x00\x49\x21\x71\xed\x28\x16\x1d\x87\x5a\x10\xa7\x9c\x64"
+	"\x94\xd4\x87\x3d\x28\xef\x44\xfe\x4b\xe2\xb4\x15\x8c\x82\xa6\xf3"
+	"\x50\x5f\xa8\xe8\xa2\x60\xe7\x00\x86\x78\x05\xd4\x78\x19\xa1\x98"
+	"\x62\x4e\x4a\x00\x78\x56\x96\xe6\xcf\xd7\x10\x1b\x74\x5d\xd0\x26"
+	"\x61\xdb\x6b\x32\x09\x51\xd8\xa5\xfd\x54\x16\x71\x01\xb3\x39\xe6"
+	"\x4e\x69\xb1\xd7\x06\x8f\xd6\x1e\xdc\x72\x25\x26\x74\xc8\x41\x06"
+	"\x5c\xd1\x26\x5c\xb0\x2f\xf9\x59\x13\xc1\x2a\x0f\x78\xea\x7b\xf7"
+	"\xbd\x59\xa0\x90\x1d\xfc\x33\x5b\x4c\xbf\x05\x9c\x3a\x3f\x69\xa2"
+	"\x45\x61\x4e\x10\x6a\xb3\x17\xc5\x68\x30\xfb\x07\x5f\x34\xc6\xfb"
+	"\x73\x07\x3c\x70\xf6\xae\xe7\x72\x84\xc3\x18\x81\x8f\xe8\x11\x1f"
+	"\x3d\x83\x83\x01\x2a\x14\x73\xbf\x32\x32\x2e\xc9\x4d\xdb\x2a\xca"
+	"\xee\x71\xf9\xda\xad\xe8\x82\x0b\x4d\x0c\x1f\xb6\x1d\xef\x00\x67"
+	"\x74\x3d\x95\xe0\xb7\xc4\x30\x8a\x24\x87\x12\x47\x27\x70\x0d\x73"
+	/* g */
+	"\x02",
+	.b_public =
+	"\x90\x89\xe4\x82\xd6\x0a\xcf\x1a\xae\xce\x1b\x66\xa7\x19\x71\x18"
+	"\x8f\x95\x4b\x5b\x80\x45\x4a\x5a\x43\x99\x4d\x37\xcf\xa3\xa7\x28"
+	"\x9c\xc7\x73\xf1\xb2\x17\xf6\x99\xe3\x6b\x56\xcb\x3e\x35\x60\x7d"
+	"\x65\xc7\x84\x6b\x3e\x60\xee\xcd\xd2\x70\xe7\xc9\x32\x1c\xf0\xb4"
+	"\xf9\x52\xd9\x88\x75\xfd\x40\x2c\xa7\xbe\x19\x1c\x0a\xae\x93\xe1"
+	"\x71\xc7\xcd\x4f\x33\x5c\x10\x7d\x39\x56\xfc\x73\x84\xb2\x67\xc3"
+	"\x77\x26\x20\x97\x2b\xf8\x13\x43\x93\x9c\x9a\xa4\x08\xc7\x34\x83"
+	"\xe6\x98\x61\xe7\x16\x30\x2c\xb1\xdb\x2a\xb2\xcc\xc3\x02\xa5\x3c"
+	"\x71\x50\x14\x83\xc7\xbb\xa4\xbe\x98\x1b\xfe\xcb\x43\xe9\x97\x62"
+	"\xd6\xf0\x8c\xcb\x1c\xba\x1e\xa8\xa6\xa6\x50\xfc\x85\x7d\x47\xbf"
+	"\xf4\x3e\x23\xd3\x5f\xb2\x71\x3e\x40\x94\xaa\x87\x83\x2c\x6c\x8e"
+	"\x60\xfd\xdd\xf7\xf4\x76\x03\xd3\x1d\xec\x18\x51\xa3\xf2\x44\x1a"
+	"\x3f\xb4\x7c\x18\x0d\x68\x65\x92\x54\x0d\x2d\x81\x16\xf1\x84\x66"
+	"\x89\x92\xd0\x1a\x5e\x1f\x42\x46\x5b\xe5\x83\x86\x80\xd9\xcd\x3a"
+	"\x5a\x2f\xb9\x59\x9b\xe4\x43\x84\x64\xf3\x09\x1a\x0a\xa2\x64\x0f"
+	"\x77\x4e\x8d\x8b\xe6\x88\xd1\xfc\xaf\x8f\xdf\x1d\xbc\x31\xb3\xbd",
+	.secret_size = 273,
+	.b_secret_size = 529,
+	.b_public_size = 256,
+	.expected_a_public_size = 256,
+	.expected_ss_size = 256,
+	.genkey = true,
 	}
 };
 
@@ -840,6 +951,50 @@ static const struct kpp_testvec ecdh_tv_template[] = {
 	.b_public_size = 64,
 	.expected_a_public_size = 64,
 	.expected_ss_size = 32
+	}, {
+	.secret =
+#ifdef __LITTLE_ENDIAN
+	"\x02\x00" /* type */
+	"\x08\x00" /* len */
+	"\x02\x00" /* curve_id */
+	"\x00\x00", /* key_size */
+#else
+	"\x00\x02" /* type */
+	"\x00\x08" /* len */
+	"\x00\x02" /* curve_id */
+	"\x00\x00", /* key_size */
+#endif
+	.b_secret =
+#ifdef __LITTLE_ENDIAN
+	"\x02\x00" /* type */
+	"\x28\x00" /* len */
+	"\x02\x00" /* curve_id */
+	"\x20\x00" /* key_size */
+#else
+	"\x00\x02" /* type */
+	"\x00\x28" /* len */
+	"\x00\x02" /* curve_id */
+	"\x00\x20" /* key_size */
+#endif
+	"\x24\xd1\x21\xeb\xe5\xcf\x2d\x83"
+	"\xf6\x62\x1b\x6e\x43\x84\x3a\xa3"
+	"\x8b\xe0\x86\xc3\x20\x19\xda\x92"
+	"\x50\x53\x03\xe1\xc0\xea\xb8\x82",
+	.b_public =
+	"\x1a\x7f\xeb\x52\x00\xbd\x3c\x31"
+	"\x7d\xb6\x70\xc1\x86\xa6\xc7\xc4"
+	"\x3b\xc5\x5f\x6c\x6f\x58\x3c\xf5"
+	"\xb6\x63\x82\x77\x33\x24\xa1\x5f"
+	"\x6a\xca\x43\x6f\xf7\x7e\xff\x02"
+	"\x37\x08\xcc\x40\x5e\x7a\xfd\x6a"
+	"\x6a\x02\x6e\x41\x87\x68\x38\x77"
+	"\xfa\xa9\x44\x43\x2d\xef\x09\xdf",
+	.secret_size = 8,
+	.b_secret_size = 40,
+	.b_public_size = 64,
+	.expected_a_public_size = 64,
+	.expected_ss_size = 32,
+	.genkey = true,
 	}
 };
 
-- 
2.7.4
