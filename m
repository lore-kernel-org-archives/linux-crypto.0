From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] crypto: testmgr - use calculated count for number of test vectors
Date: Thu, 12 Jan 2017 13:40:39 +0000
Message-ID: <1484228439-28373-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:34865 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750739AbdALNuE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2017 08:50:04 -0500
Received: by mail-wm0-f49.google.com with SMTP id r126so19263942wmr.0
        for <linux-crypto@vger.kernel.org>; Thu, 12 Jan 2017 05:50:03 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When working on AES in CCM mode for ARM, my code passed the internal
tcrypt test before I had even bothered to implement the AES-192 and
AES-256 code paths, which is strange because the tcrypt does contain
AES-192 and AES-256 test vectors for CCM.

As it turned out, the define AES_CCM_ENC_TEST_VECTORS was out of sync
with the actual number of test vectors, causing only the AES-128 ones
to be executed.

So get rid of the defines, and wrap the test vector references in a
macro that calculates the number of vectors automatically.

The following test vector counts were out of sync with the respective
defines:

    BF_CTR_ENC_TEST_VECTORS          2 ->  3
    BF_CTR_DEC_TEST_VECTORS          2 ->  3
    TF_CTR_ENC_TEST_VECTORS          2 ->  3
    TF_CTR_DEC_TEST_VECTORS          2 ->  3
    SERPENT_CTR_ENC_TEST_VECTORS     2 ->  3
    SERPENT_CTR_DEC_TEST_VECTORS     2 ->  3
    AES_CCM_ENC_TEST_VECTORS         8 -> 14
    AES_CCM_DEC_TEST_VECTORS         7 -> 17
    AES_CCM_4309_ENC_TEST_VECTORS    7 -> 23
    AES_CCM_4309_DEC_TEST_VECTORS   10 -> 23
    CAMELLIA_CTR_ENC_TEST_VECTORS    2 ->  3
    CAMELLIA_CTR_DEC_TEST_VECTORS    2 ->  3

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/testmgr.c | 1033 +++++++++++-------------------------------------------
 crypto/testmgr.h |  272 +-------------
 2 files changed, 204 insertions(+), 1101 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 44e888b0b041..b49d57826f4a 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2251,30 +2251,23 @@ static int alg_test_null(const struct alg_test_desc *desc,
 	return 0;
 }
 
+#define __VECS(tv)	{ .vecs = tv, .count = ARRAY_SIZE(tv) }
+
 /* Please keep this list sorted by algorithm name. */
 static const struct alg_test_desc alg_test_descs[] = {
 	{
 		.alg = "ansi_cprng",
 		.test = alg_test_cprng,
 		.suite = {
-			.cprng = {
-				.vecs = ansi_cprng_aes_tv_template,
-				.count = ANSI_CPRNG_AES_TEST_VECTORS
-			}
+			.cprng = __VECS(ansi_cprng_aes_tv_template)
 		}
 	}, {
 		.alg = "authenc(hmac(md5),ecb(cipher_null))",
 		.test = alg_test_aead,
 		.suite = {
 			.aead = {
-				.enc = {
-					.vecs = hmac_md5_ecb_cipher_null_enc_tv_template,
-					.count = HMAC_MD5_ECB_CIPHER_NULL_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = hmac_md5_ecb_cipher_null_dec_tv_template,
-					.count = HMAC_MD5_ECB_CIPHER_NULL_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(hmac_md5_ecb_cipher_null_enc_tv_template),
+				.dec = __VECS(hmac_md5_ecb_cipher_null_dec_tv_template)
 			}
 		}
 	}, {
@@ -2282,12 +2275,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_aead,
 		.suite = {
 			.aead = {
-				.enc = {
-					.vecs =
-					hmac_sha1_aes_cbc_enc_tv_temp,
-					.count =
-					HMAC_SHA1_AES_CBC_ENC_TEST_VEC
-				}
+				.enc = __VECS(hmac_sha1_aes_cbc_enc_tv_temp)
 			}
 		}
 	}, {
@@ -2295,12 +2283,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_aead,
 		.suite = {
 			.aead = {
-				.enc = {
-					.vecs =
-					hmac_sha1_des_cbc_enc_tv_temp,
-					.count =
-					HMAC_SHA1_DES_CBC_ENC_TEST_VEC
-				}
+				.enc = __VECS(hmac_sha1_des_cbc_enc_tv_temp)
 			}
 		}
 	}, {
@@ -2309,12 +2292,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.fips_allowed = 1,
 		.suite = {
 			.aead = {
-				.enc = {
-					.vecs =
-					hmac_sha1_des3_ede_cbc_enc_tv_temp,
-					.count =
-					HMAC_SHA1_DES3_EDE_CBC_ENC_TEST_VEC
-				}
+				.enc = __VECS(hmac_sha1_des3_ede_cbc_enc_tv_temp)
 			}
 		}
 	}, {
@@ -2326,18 +2304,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_aead,
 		.suite = {
 			.aead = {
-				.enc = {
-					.vecs =
-					hmac_sha1_ecb_cipher_null_enc_tv_temp,
-					.count =
-					HMAC_SHA1_ECB_CIPHER_NULL_ENC_TEST_VEC
-				},
-				.dec = {
-					.vecs =
-					hmac_sha1_ecb_cipher_null_dec_tv_temp,
-					.count =
-					HMAC_SHA1_ECB_CIPHER_NULL_DEC_TEST_VEC
-				}
+				.enc = __VECS(hmac_sha1_ecb_cipher_null_enc_tv_temp),
+				.dec = __VECS(hmac_sha1_ecb_cipher_null_dec_tv_temp)
 			}
 		}
 	}, {
@@ -2349,12 +2317,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_aead,
 		.suite = {
 			.aead = {
-				.enc = {
-					.vecs =
-					hmac_sha224_des_cbc_enc_tv_temp,
-					.count =
-					HMAC_SHA224_DES_CBC_ENC_TEST_VEC
-				}
+				.enc = __VECS(hmac_sha224_des_cbc_enc_tv_temp)
 			}
 		}
 	}, {
@@ -2363,12 +2326,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.fips_allowed = 1,
 		.suite = {
 			.aead = {
-				.enc = {
-					.vecs =
-					hmac_sha224_des3_ede_cbc_enc_tv_temp,
-					.count =
-					HMAC_SHA224_DES3_EDE_CBC_ENC_TEST_VEC
-				}
+				.enc = __VECS(hmac_sha224_des3_ede_cbc_enc_tv_temp)
 			}
 		}
 	}, {
@@ -2377,12 +2335,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.fips_allowed = 1,
 		.suite = {
 			.aead = {
-				.enc = {
-					.vecs =
-					hmac_sha256_aes_cbc_enc_tv_temp,
-					.count =
-					HMAC_SHA256_AES_CBC_ENC_TEST_VEC
-				}
+				.enc = __VECS(hmac_sha256_aes_cbc_enc_tv_temp)
 			}
 		}
 	}, {
@@ -2390,12 +2343,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_aead,
 		.suite = {
 			.aead = {
-				.enc = {
-					.vecs =
-					hmac_sha256_des_cbc_enc_tv_temp,
-					.count =
-					HMAC_SHA256_DES_CBC_ENC_TEST_VEC
-				}
+				.enc = __VECS(hmac_sha256_des_cbc_enc_tv_temp)
 			}
 		}
 	}, {
@@ -2404,12 +2352,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.fips_allowed = 1,
 		.suite = {
 			.aead = {
-				.enc = {
-					.vecs =
-					hmac_sha256_des3_ede_cbc_enc_tv_temp,
-					.count =
-					HMAC_SHA256_DES3_EDE_CBC_ENC_TEST_VEC
-				}
+				.enc = __VECS(hmac_sha256_des3_ede_cbc_enc_tv_temp)
 			}
 		}
 	}, {
@@ -2425,12 +2368,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_aead,
 		.suite = {
 			.aead = {
-				.enc = {
-					.vecs =
-					hmac_sha384_des_cbc_enc_tv_temp,
-					.count =
-					HMAC_SHA384_DES_CBC_ENC_TEST_VEC
-				}
+				.enc = __VECS(hmac_sha384_des_cbc_enc_tv_temp)
 			}
 		}
 	}, {
@@ -2439,12 +2377,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.fips_allowed = 1,
 		.suite = {
 			.aead = {
-				.enc = {
-					.vecs =
-					hmac_sha384_des3_ede_cbc_enc_tv_temp,
-					.count =
-					HMAC_SHA384_DES3_EDE_CBC_ENC_TEST_VEC
-				}
+				.enc = __VECS(hmac_sha384_des3_ede_cbc_enc_tv_temp)
 			}
 		}
 	}, {
@@ -2461,12 +2394,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_aead,
 		.suite = {
 			.aead = {
-				.enc = {
-					.vecs =
-					hmac_sha512_aes_cbc_enc_tv_temp,
-					.count =
-					HMAC_SHA512_AES_CBC_ENC_TEST_VEC
-				}
+				.enc = __VECS(hmac_sha512_aes_cbc_enc_tv_temp)
 			}
 		}
 	}, {
@@ -2474,12 +2402,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_aead,
 		.suite = {
 			.aead = {
-				.enc = {
-					.vecs =
-					hmac_sha512_des_cbc_enc_tv_temp,
-					.count =
-					HMAC_SHA512_DES_CBC_ENC_TEST_VEC
-				}
+				.enc = __VECS(hmac_sha512_des_cbc_enc_tv_temp)
 			}
 		}
 	}, {
@@ -2488,12 +2411,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.fips_allowed = 1,
 		.suite = {
 			.aead = {
-				.enc = {
-					.vecs =
-					hmac_sha512_des3_ede_cbc_enc_tv_temp,
-					.count =
-					HMAC_SHA512_DES3_EDE_CBC_ENC_TEST_VEC
-				}
+				.enc = __VECS(hmac_sha512_des3_ede_cbc_enc_tv_temp)
 			}
 		}
 	}, {
@@ -2510,14 +2428,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.fips_allowed = 1,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = aes_cbc_enc_tv_template,
-					.count = AES_CBC_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = aes_cbc_dec_tv_template,
-					.count = AES_CBC_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(aes_cbc_enc_tv_template),
+				.dec = __VECS(aes_cbc_dec_tv_template)
 			}
 		}
 	}, {
@@ -2525,14 +2437,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = anubis_cbc_enc_tv_template,
-					.count = ANUBIS_CBC_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = anubis_cbc_dec_tv_template,
-					.count = ANUBIS_CBC_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(anubis_cbc_enc_tv_template),
+				.dec = __VECS(anubis_cbc_dec_tv_template)
 			}
 		}
 	}, {
@@ -2540,14 +2446,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = bf_cbc_enc_tv_template,
-					.count = BF_CBC_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = bf_cbc_dec_tv_template,
-					.count = BF_CBC_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(bf_cbc_enc_tv_template),
+				.dec = __VECS(bf_cbc_dec_tv_template)
 			}
 		}
 	}, {
@@ -2555,14 +2455,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = camellia_cbc_enc_tv_template,
-					.count = CAMELLIA_CBC_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = camellia_cbc_dec_tv_template,
-					.count = CAMELLIA_CBC_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(camellia_cbc_enc_tv_template),
+				.dec = __VECS(camellia_cbc_dec_tv_template)
 			}
 		}
 	}, {
@@ -2570,14 +2464,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = cast5_cbc_enc_tv_template,
-					.count = CAST5_CBC_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = cast5_cbc_dec_tv_template,
-					.count = CAST5_CBC_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(cast5_cbc_enc_tv_template),
+				.dec = __VECS(cast5_cbc_dec_tv_template)
 			}
 		}
 	}, {
@@ -2585,14 +2473,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = cast6_cbc_enc_tv_template,
-					.count = CAST6_CBC_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = cast6_cbc_dec_tv_template,
-					.count = CAST6_CBC_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(cast6_cbc_enc_tv_template),
+				.dec = __VECS(cast6_cbc_dec_tv_template)
 			}
 		}
 	}, {
@@ -2600,14 +2482,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = des_cbc_enc_tv_template,
-					.count = DES_CBC_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = des_cbc_dec_tv_template,
-					.count = DES_CBC_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(des_cbc_enc_tv_template),
+				.dec = __VECS(des_cbc_dec_tv_template)
 			}
 		}
 	}, {
@@ -2616,14 +2492,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.fips_allowed = 1,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = des3_ede_cbc_enc_tv_template,
-					.count = DES3_EDE_CBC_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = des3_ede_cbc_dec_tv_template,
-					.count = DES3_EDE_CBC_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(des3_ede_cbc_enc_tv_template),
+				.dec = __VECS(des3_ede_cbc_dec_tv_template)
 			}
 		}
 	}, {
@@ -2631,14 +2501,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = serpent_cbc_enc_tv_template,
-					.count = SERPENT_CBC_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = serpent_cbc_dec_tv_template,
-					.count = SERPENT_CBC_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(serpent_cbc_enc_tv_template),
+				.dec = __VECS(serpent_cbc_dec_tv_template)
 			}
 		}
 	}, {
@@ -2646,14 +2510,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = tf_cbc_enc_tv_template,
-					.count = TF_CBC_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = tf_cbc_dec_tv_template,
-					.count = TF_CBC_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(tf_cbc_enc_tv_template),
+				.dec = __VECS(tf_cbc_dec_tv_template)
 			}
 		}
 	}, {
@@ -2662,14 +2520,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.fips_allowed = 1,
 		.suite = {
 			.aead = {
-				.enc = {
-					.vecs = aes_ccm_enc_tv_template,
-					.count = AES_CCM_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = aes_ccm_dec_tv_template,
-					.count = AES_CCM_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(aes_ccm_enc_tv_template),
+				.dec = __VECS(aes_ccm_dec_tv_template)
 			}
 		}
 	}, {
@@ -2677,14 +2529,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = chacha20_enc_tv_template,
-					.count = CHACHA20_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = chacha20_enc_tv_template,
-					.count = CHACHA20_ENC_TEST_VECTORS
-				},
+				.enc = __VECS(chacha20_enc_tv_template),
+				.dec = __VECS(chacha20_enc_tv_template),
 			}
 		}
 	}, {
@@ -2692,20 +2538,14 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.fips_allowed = 1,
 		.test = alg_test_hash,
 		.suite = {
-			.hash = {
-				.vecs = aes_cmac128_tv_template,
-				.count = CMAC_AES_TEST_VECTORS
-			}
+			.hash = __VECS(aes_cmac128_tv_template)
 		}
 	}, {
 		.alg = "cmac(des3_ede)",
 		.fips_allowed = 1,
 		.test = alg_test_hash,
 		.suite = {
-			.hash = {
-				.vecs = des3_ede_cmac64_tv_template,
-				.count = CMAC_DES3_EDE_TEST_VECTORS
-			}
+			.hash = __VECS(des3_ede_cmac64_tv_template)
 		}
 	}, {
 		.alg = "compress_null",
@@ -2714,30 +2554,21 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "crc32",
 		.test = alg_test_hash,
 		.suite = {
-			.hash = {
-				.vecs = crc32_tv_template,
-				.count = CRC32_TEST_VECTORS
-			}
+			.hash = __VECS(crc32_tv_template)
 		}
 	}, {
 		.alg = "crc32c",
 		.test = alg_test_crc32c,
 		.fips_allowed = 1,
 		.suite = {
-			.hash = {
-				.vecs = crc32c_tv_template,
-				.count = CRC32C_TEST_VECTORS
-			}
+			.hash = __VECS(crc32c_tv_template)
 		}
 	}, {
 		.alg = "crct10dif",
 		.test = alg_test_hash,
 		.fips_allowed = 1,
 		.suite = {
-			.hash = {
-				.vecs = crct10dif_tv_template,
-				.count = CRCT10DIF_TEST_VECTORS
-			}
+			.hash = __VECS(crct10dif_tv_template)
 		}
 	}, {
 		.alg = "ctr(aes)",
@@ -2745,14 +2576,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.fips_allowed = 1,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = aes_ctr_enc_tv_template,
-					.count = AES_CTR_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = aes_ctr_dec_tv_template,
-					.count = AES_CTR_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(aes_ctr_enc_tv_template),
+				.dec = __VECS(aes_ctr_dec_tv_template)
 			}
 		}
 	}, {
@@ -2760,14 +2585,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = bf_ctr_enc_tv_template,
-					.count = BF_CTR_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = bf_ctr_dec_tv_template,
-					.count = BF_CTR_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(bf_ctr_enc_tv_template),
+				.dec = __VECS(bf_ctr_dec_tv_template)
 			}
 		}
 	}, {
@@ -2775,14 +2594,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = camellia_ctr_enc_tv_template,
-					.count = CAMELLIA_CTR_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = camellia_ctr_dec_tv_template,
-					.count = CAMELLIA_CTR_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(camellia_ctr_enc_tv_template),
+				.dec = __VECS(camellia_ctr_dec_tv_template)
 			}
 		}
 	}, {
@@ -2790,14 +2603,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = cast5_ctr_enc_tv_template,
-					.count = CAST5_CTR_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = cast5_ctr_dec_tv_template,
-					.count = CAST5_CTR_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(cast5_ctr_enc_tv_template),
+				.dec = __VECS(cast5_ctr_dec_tv_template)
 			}
 		}
 	}, {
@@ -2805,14 +2612,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = cast6_ctr_enc_tv_template,
-					.count = CAST6_CTR_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = cast6_ctr_dec_tv_template,
-					.count = CAST6_CTR_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(cast6_ctr_enc_tv_template),
+				.dec = __VECS(cast6_ctr_dec_tv_template)
 			}
 		}
 	}, {
@@ -2820,14 +2621,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = des_ctr_enc_tv_template,
-					.count = DES_CTR_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = des_ctr_dec_tv_template,
-					.count = DES_CTR_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(des_ctr_enc_tv_template),
+				.dec = __VECS(des_ctr_dec_tv_template)
 			}
 		}
 	}, {
@@ -2835,14 +2630,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = des3_ede_ctr_enc_tv_template,
-					.count = DES3_EDE_CTR_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = des3_ede_ctr_dec_tv_template,
-					.count = DES3_EDE_CTR_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(des3_ede_ctr_enc_tv_template),
+				.dec = __VECS(des3_ede_ctr_dec_tv_template)
 			}
 		}
 	}, {
@@ -2850,14 +2639,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = serpent_ctr_enc_tv_template,
-					.count = SERPENT_CTR_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = serpent_ctr_dec_tv_template,
-					.count = SERPENT_CTR_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(serpent_ctr_enc_tv_template),
+				.dec = __VECS(serpent_ctr_dec_tv_template)
 			}
 		}
 	}, {
@@ -2865,14 +2648,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = tf_ctr_enc_tv_template,
-					.count = TF_CTR_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = tf_ctr_dec_tv_template,
-					.count = TF_CTR_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(tf_ctr_enc_tv_template),
+				.dec = __VECS(tf_ctr_dec_tv_template)
 			}
 		}
 	}, {
@@ -2880,14 +2657,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = cts_mode_enc_tv_template,
-					.count = CTS_MODE_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = cts_mode_dec_tv_template,
-					.count = CTS_MODE_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(cts_mode_enc_tv_template),
+				.dec = __VECS(cts_mode_dec_tv_template)
 			}
 		}
 	}, {
@@ -2896,14 +2667,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.fips_allowed = 1,
 		.suite = {
 			.comp = {
-				.comp = {
-					.vecs = deflate_comp_tv_template,
-					.count = DEFLATE_COMP_TEST_VECTORS
-				},
-				.decomp = {
-					.vecs = deflate_decomp_tv_template,
-					.count = DEFLATE_DECOMP_TEST_VECTORS
-				}
+				.comp = __VECS(deflate_comp_tv_template),
+				.decomp = __VECS(deflate_decomp_tv_template)
 			}
 		}
 	}, {
@@ -2911,10 +2676,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_kpp,
 		.fips_allowed = 1,
 		.suite = {
-			.kpp = {
-				.vecs = dh_tv_template,
-				.count = DH_TEST_VECTORS
-			}
+			.kpp = __VECS(dh_tv_template)
 		}
 	}, {
 		.alg = "digest_null",
@@ -2924,30 +2686,21 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_drbg,
 		.fips_allowed = 1,
 		.suite = {
-			.drbg = {
-				.vecs = drbg_nopr_ctr_aes128_tv_template,
-				.count = ARRAY_SIZE(drbg_nopr_ctr_aes128_tv_template)
-			}
+			.drbg = __VECS(drbg_nopr_ctr_aes128_tv_template)
 		}
 	}, {
 		.alg = "drbg_nopr_ctr_aes192",
 		.test = alg_test_drbg,
 		.fips_allowed = 1,
 		.suite = {
-			.drbg = {
-				.vecs = drbg_nopr_ctr_aes192_tv_template,
-				.count = ARRAY_SIZE(drbg_nopr_ctr_aes192_tv_template)
-			}
+			.drbg = __VECS(drbg_nopr_ctr_aes192_tv_template)
 		}
 	}, {
 		.alg = "drbg_nopr_ctr_aes256",
 		.test = alg_test_drbg,
 		.fips_allowed = 1,
 		.suite = {
-			.drbg = {
-				.vecs = drbg_nopr_ctr_aes256_tv_template,
-				.count = ARRAY_SIZE(drbg_nopr_ctr_aes256_tv_template)
-			}
+			.drbg = __VECS(drbg_nopr_ctr_aes256_tv_template)
 		}
 	}, {
 		/*
@@ -2962,11 +2715,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_drbg,
 		.fips_allowed = 1,
 		.suite = {
-			.drbg = {
-				.vecs = drbg_nopr_hmac_sha256_tv_template,
-				.count =
-				ARRAY_SIZE(drbg_nopr_hmac_sha256_tv_template)
-			}
+			.drbg = __VECS(drbg_nopr_hmac_sha256_tv_template)
 		}
 	}, {
 		/* covered by drbg_nopr_hmac_sha256 test */
@@ -2986,10 +2735,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_drbg,
 		.fips_allowed = 1,
 		.suite = {
-			.drbg = {
-				.vecs = drbg_nopr_sha256_tv_template,
-				.count = ARRAY_SIZE(drbg_nopr_sha256_tv_template)
-			}
+			.drbg = __VECS(drbg_nopr_sha256_tv_template)
 		}
 	}, {
 		/* covered by drbg_nopr_sha256 test */
@@ -3005,10 +2751,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_drbg,
 		.fips_allowed = 1,
 		.suite = {
-			.drbg = {
-				.vecs = drbg_pr_ctr_aes128_tv_template,
-				.count = ARRAY_SIZE(drbg_pr_ctr_aes128_tv_template)
-			}
+			.drbg = __VECS(drbg_pr_ctr_aes128_tv_template)
 		}
 	}, {
 		/* covered by drbg_pr_ctr_aes128 test */
@@ -3028,10 +2771,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_drbg,
 		.fips_allowed = 1,
 		.suite = {
-			.drbg = {
-				.vecs = drbg_pr_hmac_sha256_tv_template,
-				.count = ARRAY_SIZE(drbg_pr_hmac_sha256_tv_template)
-			}
+			.drbg = __VECS(drbg_pr_hmac_sha256_tv_template)
 		}
 	}, {
 		/* covered by drbg_pr_hmac_sha256 test */
@@ -3051,10 +2791,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_drbg,
 		.fips_allowed = 1,
 		.suite = {
-			.drbg = {
-				.vecs = drbg_pr_sha256_tv_template,
-				.count = ARRAY_SIZE(drbg_pr_sha256_tv_template)
-			}
+			.drbg = __VECS(drbg_pr_sha256_tv_template)
 		}
 	}, {
 		/* covered by drbg_pr_sha256 test */
@@ -3071,14 +2808,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.fips_allowed = 1,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = aes_enc_tv_template,
-					.count = AES_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = aes_dec_tv_template,
-					.count = AES_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(aes_enc_tv_template),
+				.dec = __VECS(aes_dec_tv_template)
 			}
 		}
 	}, {
@@ -3086,14 +2817,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = anubis_enc_tv_template,
-					.count = ANUBIS_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = anubis_dec_tv_template,
-					.count = ANUBIS_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(anubis_enc_tv_template),
+				.dec = __VECS(anubis_dec_tv_template)
 			}
 		}
 	}, {
@@ -3101,14 +2826,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = arc4_enc_tv_template,
-					.count = ARC4_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = arc4_dec_tv_template,
-					.count = ARC4_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(arc4_enc_tv_template),
+				.dec = __VECS(arc4_dec_tv_template)
 			}
 		}
 	}, {
@@ -3116,14 +2835,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = bf_enc_tv_template,
-					.count = BF_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = bf_dec_tv_template,
-					.count = BF_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(bf_enc_tv_template),
+				.dec = __VECS(bf_dec_tv_template)
 			}
 		}
 	}, {
@@ -3131,14 +2844,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = camellia_enc_tv_template,
-					.count = CAMELLIA_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = camellia_dec_tv_template,
-					.count = CAMELLIA_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(camellia_enc_tv_template),
+				.dec = __VECS(camellia_dec_tv_template)
 			}
 		}
 	}, {
@@ -3146,14 +2853,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = cast5_enc_tv_template,
-					.count = CAST5_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = cast5_dec_tv_template,
-					.count = CAST5_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(cast5_enc_tv_template),
+				.dec = __VECS(cast5_dec_tv_template)
 			}
 		}
 	}, {
@@ -3161,14 +2862,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = cast6_enc_tv_template,
-					.count = CAST6_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = cast6_dec_tv_template,
-					.count = CAST6_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(cast6_enc_tv_template),
+				.dec = __VECS(cast6_dec_tv_template)
 			}
 		}
 	}, {
@@ -3179,14 +2874,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = des_enc_tv_template,
-					.count = DES_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = des_dec_tv_template,
-					.count = DES_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(des_enc_tv_template),
+				.dec = __VECS(des_dec_tv_template)
 			}
 		}
 	}, {
@@ -3195,14 +2884,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.fips_allowed = 1,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = des3_ede_enc_tv_template,
-					.count = DES3_EDE_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = des3_ede_dec_tv_template,
-					.count = DES3_EDE_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(des3_ede_enc_tv_template),
+				.dec = __VECS(des3_ede_dec_tv_template)
 			}
 		}
 	}, {
@@ -3225,14 +2908,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = khazad_enc_tv_template,
-					.count = KHAZAD_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = khazad_dec_tv_template,
-					.count = KHAZAD_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(khazad_enc_tv_template),
+				.dec = __VECS(khazad_dec_tv_template)
 			}
 		}
 	}, {
@@ -3240,14 +2917,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = seed_enc_tv_template,
-					.count = SEED_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = seed_dec_tv_template,
-					.count = SEED_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(seed_enc_tv_template),
+				.dec = __VECS(seed_dec_tv_template)
 			}
 		}
 	}, {
@@ -3255,14 +2926,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = serpent_enc_tv_template,
-					.count = SERPENT_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = serpent_dec_tv_template,
-					.count = SERPENT_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(serpent_enc_tv_template),
+				.dec = __VECS(serpent_dec_tv_template)
 			}
 		}
 	}, {
@@ -3270,14 +2935,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = tea_enc_tv_template,
-					.count = TEA_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = tea_dec_tv_template,
-					.count = TEA_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(tea_enc_tv_template),
+				.dec = __VECS(tea_dec_tv_template)
 			}
 		}
 	}, {
@@ -3285,14 +2944,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = tnepres_enc_tv_template,
-					.count = TNEPRES_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = tnepres_dec_tv_template,
-					.count = TNEPRES_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(tnepres_enc_tv_template),
+				.dec = __VECS(tnepres_dec_tv_template)
 			}
 		}
 	}, {
@@ -3300,14 +2953,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = tf_enc_tv_template,
-					.count = TF_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = tf_dec_tv_template,
-					.count = TF_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(tf_enc_tv_template),
+				.dec = __VECS(tf_dec_tv_template)
 			}
 		}
 	}, {
@@ -3315,14 +2962,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = xeta_enc_tv_template,
-					.count = XETA_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = xeta_dec_tv_template,
-					.count = XETA_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(xeta_enc_tv_template),
+				.dec = __VECS(xeta_dec_tv_template)
 			}
 		}
 	}, {
@@ -3330,14 +2971,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = xtea_enc_tv_template,
-					.count = XTEA_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = xtea_dec_tv_template,
-					.count = XTEA_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(xtea_enc_tv_template),
+				.dec = __VECS(xtea_dec_tv_template)
 			}
 		}
 	}, {
@@ -3345,10 +2980,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_kpp,
 		.fips_allowed = 1,
 		.suite = {
-			.kpp = {
-				.vecs = ecdh_tv_template,
-				.count = ECDH_TEST_VECTORS
-			}
+			.kpp = __VECS(ecdh_tv_template)
 		}
 	}, {
 		.alg = "gcm(aes)",
@@ -3356,14 +2988,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.fips_allowed = 1,
 		.suite = {
 			.aead = {
-				.enc = {
-					.vecs = aes_gcm_enc_tv_template,
-					.count = AES_GCM_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = aes_gcm_dec_tv_template,
-					.count = AES_GCM_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(aes_gcm_enc_tv_template),
+				.dec = __VECS(aes_gcm_dec_tv_template)
 			}
 		}
 	}, {
@@ -3371,136 +2997,94 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_hash,
 		.fips_allowed = 1,
 		.suite = {
-			.hash = {
-				.vecs = ghash_tv_template,
-				.count = GHASH_TEST_VECTORS
-			}
+			.hash = __VECS(ghash_tv_template)
 		}
 	}, {
 		.alg = "hmac(crc32)",
 		.test = alg_test_hash,
 		.suite = {
-			.hash = {
-				.vecs = bfin_crc_tv_template,
-				.count = BFIN_CRC_TEST_VECTORS
-			}
+			.hash = __VECS(bfin_crc_tv_template)
 		}
 	}, {
 		.alg = "hmac(md5)",
 		.test = alg_test_hash,
 		.suite = {
-			.hash = {
-				.vecs = hmac_md5_tv_template,
-				.count = HMAC_MD5_TEST_VECTORS
-			}
+			.hash = __VECS(hmac_md5_tv_template)
 		}
 	}, {
 		.alg = "hmac(rmd128)",
 		.test = alg_test_hash,
 		.suite = {
-			.hash = {
-				.vecs = hmac_rmd128_tv_template,
-				.count = HMAC_RMD128_TEST_VECTORS
-			}
+			.hash = __VECS(hmac_rmd128_tv_template)
 		}
 	}, {
 		.alg = "hmac(rmd160)",
 		.test = alg_test_hash,
 		.suite = {
-			.hash = {
-				.vecs = hmac_rmd160_tv_template,
-				.count = HMAC_RMD160_TEST_VECTORS
-			}
+			.hash = __VECS(hmac_rmd160_tv_template)
 		}
 	}, {
 		.alg = "hmac(sha1)",
 		.test = alg_test_hash,
 		.fips_allowed = 1,
 		.suite = {
-			.hash = {
-				.vecs = hmac_sha1_tv_template,
-				.count = HMAC_SHA1_TEST_VECTORS
-			}
+			.hash = __VECS(hmac_sha1_tv_template)
 		}
 	}, {
 		.alg = "hmac(sha224)",
 		.test = alg_test_hash,
 		.fips_allowed = 1,
 		.suite = {
-			.hash = {
-				.vecs = hmac_sha224_tv_template,
-				.count = HMAC_SHA224_TEST_VECTORS
-			}
+			.hash = __VECS(hmac_sha224_tv_template)
 		}
 	}, {
 		.alg = "hmac(sha256)",
 		.test = alg_test_hash,
 		.fips_allowed = 1,
 		.suite = {
-			.hash = {
-				.vecs = hmac_sha256_tv_template,
-				.count = HMAC_SHA256_TEST_VECTORS
-			}
+			.hash = __VECS(hmac_sha256_tv_template)
 		}
 	}, {
 		.alg = "hmac(sha3-224)",
 		.test = alg_test_hash,
 		.fips_allowed = 1,
 		.suite = {
-			.hash = {
-				.vecs = hmac_sha3_224_tv_template,
-				.count = HMAC_SHA3_224_TEST_VECTORS
-			}
+			.hash = __VECS(hmac_sha3_224_tv_template)
 		}
 	}, {
 		.alg = "hmac(sha3-256)",
 		.test = alg_test_hash,
 		.fips_allowed = 1,
 		.suite = {
-			.hash = {
-				.vecs = hmac_sha3_256_tv_template,
-				.count = HMAC_SHA3_256_TEST_VECTORS
-			}
+			.hash = __VECS(hmac_sha3_256_tv_template)
 		}
 	}, {
 		.alg = "hmac(sha3-384)",
 		.test = alg_test_hash,
 		.fips_allowed = 1,
 		.suite = {
-			.hash = {
-				.vecs = hmac_sha3_384_tv_template,
-				.count = HMAC_SHA3_384_TEST_VECTORS
-			}
+			.hash = __VECS(hmac_sha3_384_tv_template)
 		}
 	}, {
 		.alg = "hmac(sha3-512)",
 		.test = alg_test_hash,
 		.fips_allowed = 1,
 		.suite = {
-			.hash = {
-				.vecs = hmac_sha3_512_tv_template,
-				.count = HMAC_SHA3_512_TEST_VECTORS
-			}
+			.hash = __VECS(hmac_sha3_512_tv_template)
 		}
 	}, {
 		.alg = "hmac(sha384)",
 		.test = alg_test_hash,
 		.fips_allowed = 1,
 		.suite = {
-			.hash = {
-				.vecs = hmac_sha384_tv_template,
-				.count = HMAC_SHA384_TEST_VECTORS
-			}
+			.hash = __VECS(hmac_sha384_tv_template)
 		}
 	}, {
 		.alg = "hmac(sha512)",
 		.test = alg_test_hash,
 		.fips_allowed = 1,
 		.suite = {
-			.hash = {
-				.vecs = hmac_sha512_tv_template,
-				.count = HMAC_SHA512_TEST_VECTORS
-			}
+			.hash = __VECS(hmac_sha512_tv_template)
 		}
 	}, {
 		.alg = "jitterentropy_rng",
@@ -3512,14 +3096,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.fips_allowed = 1,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = aes_kw_enc_tv_template,
-					.count = ARRAY_SIZE(aes_kw_enc_tv_template)
-				},
-				.dec = {
-					.vecs = aes_kw_dec_tv_template,
-					.count = ARRAY_SIZE(aes_kw_dec_tv_template)
-				}
+				.enc = __VECS(aes_kw_enc_tv_template),
+				.dec = __VECS(aes_kw_dec_tv_template)
 			}
 		}
 	}, {
@@ -3527,14 +3105,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = aes_lrw_enc_tv_template,
-					.count = AES_LRW_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = aes_lrw_dec_tv_template,
-					.count = AES_LRW_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(aes_lrw_enc_tv_template),
+				.dec = __VECS(aes_lrw_dec_tv_template)
 			}
 		}
 	}, {
@@ -3542,14 +3114,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = camellia_lrw_enc_tv_template,
-					.count = CAMELLIA_LRW_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = camellia_lrw_dec_tv_template,
-					.count = CAMELLIA_LRW_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(camellia_lrw_enc_tv_template),
+				.dec = __VECS(camellia_lrw_dec_tv_template)
 			}
 		}
 	}, {
@@ -3557,14 +3123,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = cast6_lrw_enc_tv_template,
-					.count = CAST6_LRW_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = cast6_lrw_dec_tv_template,
-					.count = CAST6_LRW_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(cast6_lrw_enc_tv_template),
+				.dec = __VECS(cast6_lrw_dec_tv_template)
 			}
 		}
 	}, {
@@ -3572,14 +3132,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = serpent_lrw_enc_tv_template,
-					.count = SERPENT_LRW_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = serpent_lrw_dec_tv_template,
-					.count = SERPENT_LRW_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(serpent_lrw_enc_tv_template),
+				.dec = __VECS(serpent_lrw_dec_tv_template)
 			}
 		}
 	}, {
@@ -3587,14 +3141,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = tf_lrw_enc_tv_template,
-					.count = TF_LRW_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = tf_lrw_dec_tv_template,
-					.count = TF_LRW_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(tf_lrw_enc_tv_template),
+				.dec = __VECS(tf_lrw_dec_tv_template)
 			}
 		}
 	}, {
@@ -3603,14 +3151,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.fips_allowed = 1,
 		.suite = {
 			.comp = {
-				.comp = {
-					.vecs = lz4_comp_tv_template,
-					.count = LZ4_COMP_TEST_VECTORS
-				},
-				.decomp = {
-					.vecs = lz4_decomp_tv_template,
-					.count = LZ4_DECOMP_TEST_VECTORS
-				}
+				.comp = __VECS(lz4_comp_tv_template),
+				.decomp = __VECS(lz4_decomp_tv_template)
 			}
 		}
 	}, {
@@ -3619,14 +3161,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.fips_allowed = 1,
 		.suite = {
 			.comp = {
-				.comp = {
-					.vecs = lz4hc_comp_tv_template,
-					.count = LZ4HC_COMP_TEST_VECTORS
-				},
-				.decomp = {
-					.vecs = lz4hc_decomp_tv_template,
-					.count = LZ4HC_DECOMP_TEST_VECTORS
-				}
+				.comp = __VECS(lz4hc_comp_tv_template),
+				.decomp = __VECS(lz4hc_decomp_tv_template)
 			}
 		}
 	}, {
@@ -3635,42 +3171,27 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.fips_allowed = 1,
 		.suite = {
 			.comp = {
-				.comp = {
-					.vecs = lzo_comp_tv_template,
-					.count = LZO_COMP_TEST_VECTORS
-				},
-				.decomp = {
-					.vecs = lzo_decomp_tv_template,
-					.count = LZO_DECOMP_TEST_VECTORS
-				}
+				.comp = __VECS(lzo_comp_tv_template),
+				.decomp = __VECS(lzo_decomp_tv_template)
 			}
 		}
 	}, {
 		.alg = "md4",
 		.test = alg_test_hash,
 		.suite = {
-			.hash = {
-				.vecs = md4_tv_template,
-				.count = MD4_TEST_VECTORS
-			}
+			.hash = __VECS(md4_tv_template)
 		}
 	}, {
 		.alg = "md5",
 		.test = alg_test_hash,
 		.suite = {
-			.hash = {
-				.vecs = md5_tv_template,
-				.count = MD5_TEST_VECTORS
-			}
+			.hash = __VECS(md5_tv_template)
 		}
 	}, {
 		.alg = "michael_mic",
 		.test = alg_test_hash,
 		.suite = {
-			.hash = {
-				.vecs = michael_mic_tv_template,
-				.count = MICHAEL_MIC_TEST_VECTORS
-			}
+			.hash = __VECS(michael_mic_tv_template)
 		}
 	}, {
 		.alg = "ofb(aes)",
@@ -3678,14 +3199,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.fips_allowed = 1,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = aes_ofb_enc_tv_template,
-					.count = AES_OFB_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = aes_ofb_dec_tv_template,
-					.count = AES_OFB_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(aes_ofb_enc_tv_template),
+				.dec = __VECS(aes_ofb_dec_tv_template)
 			}
 		}
 	}, {
@@ -3693,24 +3208,15 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = fcrypt_pcbc_enc_tv_template,
-					.count = FCRYPT_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = fcrypt_pcbc_dec_tv_template,
-					.count = FCRYPT_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(fcrypt_pcbc_enc_tv_template),
+				.dec = __VECS(fcrypt_pcbc_dec_tv_template)
 			}
 		}
 	}, {
 		.alg = "poly1305",
 		.test = alg_test_hash,
 		.suite = {
-			.hash = {
-				.vecs = poly1305_tv_template,
-				.count = POLY1305_TEST_VECTORS
-			}
+			.hash = __VECS(poly1305_tv_template)
 		}
 	}, {
 		.alg = "rfc3686(ctr(aes))",
@@ -3718,14 +3224,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.fips_allowed = 1,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = aes_ctr_rfc3686_enc_tv_template,
-					.count = AES_CTR_3686_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = aes_ctr_rfc3686_dec_tv_template,
-					.count = AES_CTR_3686_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(aes_ctr_rfc3686_enc_tv_template),
+				.dec = __VECS(aes_ctr_rfc3686_dec_tv_template)
 			}
 		}
 	}, {
@@ -3734,14 +3234,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.fips_allowed = 1,
 		.suite = {
 			.aead = {
-				.enc = {
-					.vecs = aes_gcm_rfc4106_enc_tv_template,
-					.count = AES_GCM_4106_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = aes_gcm_rfc4106_dec_tv_template,
-					.count = AES_GCM_4106_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(aes_gcm_rfc4106_enc_tv_template),
+				.dec = __VECS(aes_gcm_rfc4106_dec_tv_template)
 			}
 		}
 	}, {
@@ -3750,14 +3244,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.fips_allowed = 1,
 		.suite = {
 			.aead = {
-				.enc = {
-					.vecs = aes_ccm_rfc4309_enc_tv_template,
-					.count = AES_CCM_4309_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = aes_ccm_rfc4309_dec_tv_template,
-					.count = AES_CCM_4309_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(aes_ccm_rfc4309_enc_tv_template),
+				.dec = __VECS(aes_ccm_rfc4309_dec_tv_template)
 			}
 		}
 	}, {
@@ -3765,14 +3253,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_aead,
 		.suite = {
 			.aead = {
-				.enc = {
-					.vecs = aes_gcm_rfc4543_enc_tv_template,
-					.count = AES_GCM_4543_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = aes_gcm_rfc4543_dec_tv_template,
-					.count = AES_GCM_4543_DEC_TEST_VECTORS
-				},
+				.enc = __VECS(aes_gcm_rfc4543_enc_tv_template),
+				.dec = __VECS(aes_gcm_rfc4543_dec_tv_template),
 			}
 		}
 	}, {
@@ -3780,14 +3262,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_aead,
 		.suite = {
 			.aead = {
-				.enc = {
-					.vecs = rfc7539_enc_tv_template,
-					.count = RFC7539_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = rfc7539_dec_tv_template,
-					.count = RFC7539_DEC_TEST_VECTORS
-				},
+				.enc = __VECS(rfc7539_enc_tv_template),
+				.dec = __VECS(rfc7539_dec_tv_template),
 			}
 		}
 	}, {
@@ -3795,71 +3271,47 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_aead,
 		.suite = {
 			.aead = {
-				.enc = {
-					.vecs = rfc7539esp_enc_tv_template,
-					.count = RFC7539ESP_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = rfc7539esp_dec_tv_template,
-					.count = RFC7539ESP_DEC_TEST_VECTORS
-				},
+				.enc = __VECS(rfc7539esp_enc_tv_template),
+				.dec = __VECS(rfc7539esp_dec_tv_template),
 			}
 		}
 	}, {
 		.alg = "rmd128",
 		.test = alg_test_hash,
 		.suite = {
-			.hash = {
-				.vecs = rmd128_tv_template,
-				.count = RMD128_TEST_VECTORS
-			}
+			.hash = __VECS(rmd128_tv_template)
 		}
 	}, {
 		.alg = "rmd160",
 		.test = alg_test_hash,
 		.suite = {
-			.hash = {
-				.vecs = rmd160_tv_template,
-				.count = RMD160_TEST_VECTORS
-			}
+			.hash = __VECS(rmd160_tv_template)
 		}
 	}, {
 		.alg = "rmd256",
 		.test = alg_test_hash,
 		.suite = {
-			.hash = {
-				.vecs = rmd256_tv_template,
-				.count = RMD256_TEST_VECTORS
-			}
+			.hash = __VECS(rmd256_tv_template)
 		}
 	}, {
 		.alg = "rmd320",
 		.test = alg_test_hash,
 		.suite = {
-			.hash = {
-				.vecs = rmd320_tv_template,
-				.count = RMD320_TEST_VECTORS
-			}
+			.hash = __VECS(rmd320_tv_template)
 		}
 	}, {
 		.alg = "rsa",
 		.test = alg_test_akcipher,
 		.fips_allowed = 1,
 		.suite = {
-			.akcipher = {
-				.vecs = rsa_tv_template,
-				.count = RSA_TEST_VECTORS
-			}
+			.akcipher = __VECS(rsa_tv_template)
 		}
 	}, {
 		.alg = "salsa20",
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = salsa20_stream_enc_tv_template,
-					.count = SALSA20_STREAM_ENC_TEST_VECTORS
-				}
+				.enc = __VECS(salsa20_stream_enc_tv_template)
 			}
 		}
 	}, {
@@ -3867,162 +3319,111 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_hash,
 		.fips_allowed = 1,
 		.suite = {
-			.hash = {
-				.vecs = sha1_tv_template,
-				.count = SHA1_TEST_VECTORS
-			}
+			.hash = __VECS(sha1_tv_template)
 		}
 	}, {
 		.alg = "sha224",
 		.test = alg_test_hash,
 		.fips_allowed = 1,
 		.suite = {
-			.hash = {
-				.vecs = sha224_tv_template,
-				.count = SHA224_TEST_VECTORS
-			}
+			.hash = __VECS(sha224_tv_template)
 		}
 	}, {
 		.alg = "sha256",
 		.test = alg_test_hash,
 		.fips_allowed = 1,
 		.suite = {
-			.hash = {
-				.vecs = sha256_tv_template,
-				.count = SHA256_TEST_VECTORS
-			}
+			.hash = __VECS(sha256_tv_template)
 		}
 	}, {
 		.alg = "sha3-224",
 		.test = alg_test_hash,
 		.fips_allowed = 1,
 		.suite = {
-			.hash = {
-				.vecs = sha3_224_tv_template,
-				.count = SHA3_224_TEST_VECTORS
-			}
+			.hash = __VECS(sha3_224_tv_template)
 		}
 	}, {
 		.alg = "sha3-256",
 		.test = alg_test_hash,
 		.fips_allowed = 1,
 		.suite = {
-			.hash = {
-				.vecs = sha3_256_tv_template,
-				.count = SHA3_256_TEST_VECTORS
-			}
+			.hash = __VECS(sha3_256_tv_template)
 		}
 	}, {
 		.alg = "sha3-384",
 		.test = alg_test_hash,
 		.fips_allowed = 1,
 		.suite = {
-			.hash = {
-				.vecs = sha3_384_tv_template,
-				.count = SHA3_384_TEST_VECTORS
-			}
+			.hash = __VECS(sha3_384_tv_template)
 		}
 	}, {
 		.alg = "sha3-512",
 		.test = alg_test_hash,
 		.fips_allowed = 1,
 		.suite = {
-			.hash = {
-				.vecs = sha3_512_tv_template,
-				.count = SHA3_512_TEST_VECTORS
-			}
+			.hash = __VECS(sha3_512_tv_template)
 		}
 	}, {
 		.alg = "sha384",
 		.test = alg_test_hash,
 		.fips_allowed = 1,
 		.suite = {
-			.hash = {
-				.vecs = sha384_tv_template,
-				.count = SHA384_TEST_VECTORS
-			}
+			.hash = __VECS(sha384_tv_template)
 		}
 	}, {
 		.alg = "sha512",
 		.test = alg_test_hash,
 		.fips_allowed = 1,
 		.suite = {
-			.hash = {
-				.vecs = sha512_tv_template,
-				.count = SHA512_TEST_VECTORS
-			}
+			.hash = __VECS(sha512_tv_template)
 		}
 	}, {
 		.alg = "tgr128",
 		.test = alg_test_hash,
 		.suite = {
-			.hash = {
-				.vecs = tgr128_tv_template,
-				.count = TGR128_TEST_VECTORS
-			}
+			.hash = __VECS(tgr128_tv_template)
 		}
 	}, {
 		.alg = "tgr160",
 		.test = alg_test_hash,
 		.suite = {
-			.hash = {
-				.vecs = tgr160_tv_template,
-				.count = TGR160_TEST_VECTORS
-			}
+			.hash = __VECS(tgr160_tv_template)
 		}
 	}, {
 		.alg = "tgr192",
 		.test = alg_test_hash,
 		.suite = {
-			.hash = {
-				.vecs = tgr192_tv_template,
-				.count = TGR192_TEST_VECTORS
-			}
+			.hash = __VECS(tgr192_tv_template)
 		}
 	}, {
 		.alg = "vmac(aes)",
 		.test = alg_test_hash,
 		.suite = {
-			.hash = {
-				.vecs = aes_vmac128_tv_template,
-				.count = VMAC_AES_TEST_VECTORS
-			}
+			.hash = __VECS(aes_vmac128_tv_template)
 		}
 	}, {
 		.alg = "wp256",
 		.test = alg_test_hash,
 		.suite = {
-			.hash = {
-				.vecs = wp256_tv_template,
-				.count = WP256_TEST_VECTORS
-			}
+			.hash = __VECS(wp256_tv_template)
 		}
 	}, {
 		.alg = "wp384",
 		.test = alg_test_hash,
 		.suite = {
-			.hash = {
-				.vecs = wp384_tv_template,
-				.count = WP384_TEST_VECTORS
-			}
+			.hash = __VECS(wp384_tv_template)
 		}
 	}, {
 		.alg = "wp512",
 		.test = alg_test_hash,
 		.suite = {
-			.hash = {
-				.vecs = wp512_tv_template,
-				.count = WP512_TEST_VECTORS
-			}
+			.hash = __VECS(wp512_tv_template)
 		}
 	}, {
 		.alg = "xcbc(aes)",
 		.test = alg_test_hash,
 		.suite = {
-			.hash = {
-				.vecs = aes_xcbc128_tv_template,
-				.count = XCBC_AES_TEST_VECTORS
-			}
+			.hash = __VECS(aes_xcbc128_tv_template)
 		}
 	}, {
 		.alg = "xts(aes)",
@@ -4030,14 +3431,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.fips_allowed = 1,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = aes_xts_enc_tv_template,
-					.count = AES_XTS_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = aes_xts_dec_tv_template,
-					.count = AES_XTS_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(aes_xts_enc_tv_template),
+				.dec = __VECS(aes_xts_dec_tv_template)
 			}
 		}
 	}, {
@@ -4045,14 +3440,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = camellia_xts_enc_tv_template,
-					.count = CAMELLIA_XTS_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = camellia_xts_dec_tv_template,
-					.count = CAMELLIA_XTS_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(camellia_xts_enc_tv_template),
+				.dec = __VECS(camellia_xts_dec_tv_template)
 			}
 		}
 	}, {
@@ -4060,14 +3449,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = cast6_xts_enc_tv_template,
-					.count = CAST6_XTS_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = cast6_xts_dec_tv_template,
-					.count = CAST6_XTS_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(cast6_xts_enc_tv_template),
+				.dec = __VECS(cast6_xts_dec_tv_template)
 			}
 		}
 	}, {
@@ -4075,14 +3458,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = serpent_xts_enc_tv_template,
-					.count = SERPENT_XTS_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = serpent_xts_dec_tv_template,
-					.count = SERPENT_XTS_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(serpent_xts_enc_tv_template),
+				.dec = __VECS(serpent_xts_dec_tv_template)
 			}
 		}
 	}, {
@@ -4090,14 +3467,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = {
-				.enc = {
-					.vecs = tf_xts_enc_tv_template,
-					.count = TF_XTS_ENC_TEST_VECTORS
-				},
-				.dec = {
-					.vecs = tf_xts_dec_tv_template,
-					.count = TF_XTS_DEC_TEST_VECTORS
-				}
+				.enc = __VECS(tf_xts_enc_tv_template),
+				.dec = __VECS(tf_xts_dec_tv_template)
 			}
 		}
 	}
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 9b656be7f52f..64595f067d72 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -151,11 +151,6 @@ static char zeroed_string[48];
 /*
  * RSA test vectors. Borrowed from openSSL.
  */
-#ifdef CONFIG_CRYPTO_FIPS
-#define RSA_TEST_VECTORS	2
-#else
-#define RSA_TEST_VECTORS	5
-#endif
 static struct akcipher_testvec rsa_tv_template[] = {
 	{
 #ifndef CONFIG_CRYPTO_FIPS
@@ -340,6 +335,7 @@ static struct akcipher_testvec rsa_tv_template[] = {
 	.m_size = 8,
 	.c_size = 256,
 	.public_key_vec = true,
+#ifndef CONFIG_CRYPTO_FIPS
 	}, {
 	.key =
 	"\x30\x82\x09\x29" /* sequence of 2345 bytes */
@@ -538,11 +534,10 @@ static struct akcipher_testvec rsa_tv_template[] = {
 	.key_len = 2349,
 	.m_size = 8,
 	.c_size = 512,
+#endif
 	}
 };
 
-#define DH_TEST_VECTORS 2
-
 struct kpp_testvec dh_tv_template[] = {
 	{
 	.secret =
@@ -760,11 +755,6 @@ struct kpp_testvec dh_tv_template[] = {
 	}
 };
 
-#ifdef CONFIG_CRYPTO_FIPS
-#define ECDH_TEST_VECTORS 1
-#else
-#define ECDH_TEST_VECTORS 2
-#endif
 struct kpp_testvec ecdh_tv_template[] = {
 	{
 #ifndef CONFIG_CRYPTO_FIPS
@@ -856,8 +846,6 @@ struct kpp_testvec ecdh_tv_template[] = {
 /*
  * MD4 test vectors from RFC1320
  */
-#define MD4_TEST_VECTORS	7
-
 static struct hash_testvec md4_tv_template [] = {
 	{
 		.plaintext = "",
@@ -899,7 +887,6 @@ static struct hash_testvec md4_tv_template [] = {
 	},
 };
 
-#define SHA3_224_TEST_VECTORS	3
 static struct hash_testvec sha3_224_tv_template[] = {
 	{
 		.plaintext = "",
@@ -925,7 +912,6 @@ static struct hash_testvec sha3_224_tv_template[] = {
 	},
 };
 
-#define SHA3_256_TEST_VECTORS	3
 static struct hash_testvec sha3_256_tv_template[] = {
 	{
 		.plaintext = "",
@@ -952,7 +938,6 @@ static struct hash_testvec sha3_256_tv_template[] = {
 };
 
 
-#define SHA3_384_TEST_VECTORS	3
 static struct hash_testvec sha3_384_tv_template[] = {
 	{
 		.plaintext = "",
@@ -985,7 +970,6 @@ static struct hash_testvec sha3_384_tv_template[] = {
 };
 
 
-#define SHA3_512_TEST_VECTORS	3
 static struct hash_testvec sha3_512_tv_template[] = {
 	{
 		.plaintext = "",
@@ -1027,8 +1011,6 @@ static struct hash_testvec sha3_512_tv_template[] = {
 /*
  * MD5 test vectors from RFC1321
  */
-#define MD5_TEST_VECTORS	7
-
 static struct hash_testvec md5_tv_template[] = {
 	{
 		.digest	= "\xd4\x1d\x8c\xd9\x8f\x00\xb2\x04"
@@ -1073,8 +1055,6 @@ static struct hash_testvec md5_tv_template[] = {
 /*
  * RIPEMD-128 test vectors from ISO/IEC 10118-3:2004(E)
  */
-#define RMD128_TEST_VECTORS     10
-
 static struct hash_testvec rmd128_tv_template[] = {
 	{
 		.digest	= "\xcd\xf2\x62\x13\xa1\x50\xdc\x3e"
@@ -1137,8 +1117,6 @@ static struct hash_testvec rmd128_tv_template[] = {
 /*
  * RIPEMD-160 test vectors from ISO/IEC 10118-3:2004(E)
  */
-#define RMD160_TEST_VECTORS     10
-
 static struct hash_testvec rmd160_tv_template[] = {
 	{
 		.digest	= "\x9c\x11\x85\xa5\xc5\xe9\xfc\x54\x61\x28"
@@ -1201,8 +1179,6 @@ static struct hash_testvec rmd160_tv_template[] = {
 /*
  * RIPEMD-256 test vectors
  */
-#define RMD256_TEST_VECTORS     8
-
 static struct hash_testvec rmd256_tv_template[] = {
 	{
 		.digest	= "\x02\xba\x4c\x4e\x5f\x8e\xcd\x18"
@@ -1269,8 +1245,6 @@ static struct hash_testvec rmd256_tv_template[] = {
 /*
  * RIPEMD-320 test vectors
  */
-#define RMD320_TEST_VECTORS     8
-
 static struct hash_testvec rmd320_tv_template[] = {
 	{
 		.digest	= "\x22\xd6\x5d\x56\x61\x53\x6c\xdc\x75\xc1"
@@ -1334,7 +1308,6 @@ static struct hash_testvec rmd320_tv_template[] = {
 	}
 };
 
-#define CRCT10DIF_TEST_VECTORS	ARRAY_SIZE(crct10dif_tv_template)
 static struct hash_testvec crct10dif_tv_template[] = {
 	{
 		.plaintext	= "abc",
@@ -1385,8 +1358,6 @@ static struct hash_testvec crct10dif_tv_template[] = {
  * SHA1 test vectors  from from FIPS PUB 180-1
  * Long vector from CAVS 5.0
  */
-#define SHA1_TEST_VECTORS	6
-
 static struct hash_testvec sha1_tv_template[] = {
 	{
 		.plaintext = "",
@@ -1577,8 +1548,6 @@ static struct hash_testvec sha1_tv_template[] = {
 /*
  * SHA224 test vectors from from FIPS PUB 180-2
  */
-#define SHA224_TEST_VECTORS     5
-
 static struct hash_testvec sha224_tv_template[] = {
 	{
 		.plaintext = "",
@@ -1751,8 +1720,6 @@ static struct hash_testvec sha224_tv_template[] = {
 /*
  * SHA256 test vectors from from NIST
  */
-#define SHA256_TEST_VECTORS	5
-
 static struct hash_testvec sha256_tv_template[] = {
 	{
 		.plaintext = "",
@@ -1924,8 +1891,6 @@ static struct hash_testvec sha256_tv_template[] = {
 /*
  * SHA384 test vectors from from NIST and kerneli
  */
-#define SHA384_TEST_VECTORS	6
-
 static struct hash_testvec sha384_tv_template[] = {
 	{
 		.plaintext = "",
@@ -2118,8 +2083,6 @@ static struct hash_testvec sha384_tv_template[] = {
 /*
  * SHA512 test vectors from from NIST and kerneli
  */
-#define SHA512_TEST_VECTORS	6
-
 static struct hash_testvec sha512_tv_template[] = {
 	{
 		.plaintext = "",
@@ -2327,8 +2290,6 @@ static struct hash_testvec sha512_tv_template[] = {
  * by Vincent Rijmen and Paulo S. L. M. Barreto as part of the NESSIE
  * submission
  */
-#define WP512_TEST_VECTORS	8
-
 static struct hash_testvec wp512_tv_template[] = {
 	{
 		.plaintext = "",
@@ -2425,8 +2386,6 @@ static struct hash_testvec wp512_tv_template[] = {
 	},
 };
 
-#define WP384_TEST_VECTORS	8
-
 static struct hash_testvec wp384_tv_template[] = {
 	{
 		.plaintext = "",
@@ -2507,8 +2466,6 @@ static struct hash_testvec wp384_tv_template[] = {
 	},
 };
 
-#define WP256_TEST_VECTORS	8
-
 static struct hash_testvec wp256_tv_template[] = {
 	{
 		.plaintext = "",
@@ -2576,8 +2533,6 @@ static struct hash_testvec wp256_tv_template[] = {
 /*
  * TIGER test vectors from Tiger website
  */
-#define TGR192_TEST_VECTORS	6
-
 static struct hash_testvec tgr192_tv_template[] = {
 	{
 		.plaintext = "",
@@ -2621,8 +2576,6 @@ static struct hash_testvec tgr192_tv_template[] = {
 	},
 };
 
-#define TGR160_TEST_VECTORS	6
-
 static struct hash_testvec tgr160_tv_template[] = {
 	{
 		.plaintext = "",
@@ -2666,8 +2619,6 @@ static struct hash_testvec tgr160_tv_template[] = {
 	},
 };
 
-#define TGR128_TEST_VECTORS	6
-
 static struct hash_testvec tgr128_tv_template[] = {
 	{
 		.plaintext = "",
@@ -2705,8 +2656,6 @@ static struct hash_testvec tgr128_tv_template[] = {
 	},
 };
 
-#define GHASH_TEST_VECTORS 6
-
 static struct hash_testvec ghash_tv_template[] =
 {
 	{
@@ -2822,8 +2771,6 @@ static struct hash_testvec ghash_tv_template[] =
  * HMAC-MD5 test vectors from RFC2202
  * (These need to be fixed to not use strlen).
  */
-#define HMAC_MD5_TEST_VECTORS	7
-
 static struct hash_testvec hmac_md5_tv_template[] =
 {
 	{
@@ -2904,8 +2851,6 @@ static struct hash_testvec hmac_md5_tv_template[] =
 /*
  * HMAC-RIPEMD128 test vectors from RFC2286
  */
-#define HMAC_RMD128_TEST_VECTORS	7
-
 static struct hash_testvec hmac_rmd128_tv_template[] = {
 	{
 		.key	= "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b",
@@ -2985,8 +2930,6 @@ static struct hash_testvec hmac_rmd128_tv_template[] = {
 /*
  * HMAC-RIPEMD160 test vectors from RFC2286
  */
-#define HMAC_RMD160_TEST_VECTORS	7
-
 static struct hash_testvec hmac_rmd160_tv_template[] = {
 	{
 		.key	= "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b",
@@ -3066,8 +3009,6 @@ static struct hash_testvec hmac_rmd160_tv_template[] = {
 /*
  * HMAC-SHA1 test vectors from RFC2202
  */
-#define HMAC_SHA1_TEST_VECTORS	7
-
 static struct hash_testvec hmac_sha1_tv_template[] = {
 	{
 		.key	= "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b",
@@ -3149,8 +3090,6 @@ static struct hash_testvec hmac_sha1_tv_template[] = {
 /*
  * SHA224 HMAC test vectors from RFC4231
  */
-#define HMAC_SHA224_TEST_VECTORS    4
-
 static struct hash_testvec hmac_sha224_tv_template[] = {
 	{
 		.key    = "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
@@ -3264,8 +3203,6 @@ static struct hash_testvec hmac_sha224_tv_template[] = {
  * HMAC-SHA256 test vectors from
  * draft-ietf-ipsec-ciph-sha-256-01.txt
  */
-#define HMAC_SHA256_TEST_VECTORS	10
-
 static struct hash_testvec hmac_sha256_tv_template[] = {
 	{
 		.key	= "\x01\x02\x03\x04\x05\x06\x07\x08"
@@ -3401,8 +3338,6 @@ static struct hash_testvec hmac_sha256_tv_template[] = {
 	},
 };
 
-#define CMAC_AES_TEST_VECTORS 6
-
 static struct hash_testvec aes_cmac128_tv_template[] = {
 	{ /* From NIST Special Publication 800-38B, AES-128 */
 		.key		= "\x2b\x7e\x15\x16\x28\xae\xd2\xa6"
@@ -3478,8 +3413,6 @@ static struct hash_testvec aes_cmac128_tv_template[] = {
 	}
 };
 
-#define CMAC_DES3_EDE_TEST_VECTORS 4
-
 static struct hash_testvec des3_ede_cmac64_tv_template[] = {
 /*
  * From NIST Special Publication 800-38B, Three Key TDEA
@@ -3526,8 +3459,6 @@ static struct hash_testvec des3_ede_cmac64_tv_template[] = {
 	}
 };
 
-#define XCBC_AES_TEST_VECTORS 6
-
 static struct hash_testvec aes_xcbc128_tv_template[] = {
 	{
 		.key	= "\x00\x01\x02\x03\x04\x05\x06\x07"
@@ -3594,7 +3525,6 @@ static struct hash_testvec aes_xcbc128_tv_template[] = {
 	}
 };
 
-#define VMAC_AES_TEST_VECTORS	11
 static char vmac_string1[128] = {'\x01', '\x01', '\x01', '\x01',
 				'\x02', '\x03', '\x02', '\x02',
 				'\x02', '\x04', '\x01', '\x07',
@@ -3701,8 +3631,6 @@ static struct hash_testvec aes_vmac128_tv_template[] = {
  * SHA384 HMAC test vectors from RFC4231
  */
 
-#define HMAC_SHA384_TEST_VECTORS	4
-
 static struct hash_testvec hmac_sha384_tv_template[] = {
 	{
 		.key	= "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
@@ -3801,8 +3729,6 @@ static struct hash_testvec hmac_sha384_tv_template[] = {
  * SHA512 HMAC test vectors from RFC4231
  */
 
-#define HMAC_SHA512_TEST_VECTORS	4
-
 static struct hash_testvec hmac_sha512_tv_template[] = {
 	{
 		.key	= "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
@@ -3908,8 +3834,6 @@ static struct hash_testvec hmac_sha512_tv_template[] = {
 	},
 };
 
-#define HMAC_SHA3_224_TEST_VECTORS	4
-
 static struct hash_testvec hmac_sha3_224_tv_template[] = {
 	{
 		.key	= "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
@@ -3999,8 +3923,6 @@ static struct hash_testvec hmac_sha3_224_tv_template[] = {
 	},
 };
 
-#define HMAC_SHA3_256_TEST_VECTORS	4
-
 static struct hash_testvec hmac_sha3_256_tv_template[] = {
 	{
 		.key	= "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
@@ -4090,8 +4012,6 @@ static struct hash_testvec hmac_sha3_256_tv_template[] = {
 	},
 };
 
-#define HMAC_SHA3_384_TEST_VECTORS	4
-
 static struct hash_testvec hmac_sha3_384_tv_template[] = {
 	{
 		.key	= "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
@@ -4189,8 +4109,6 @@ static struct hash_testvec hmac_sha3_384_tv_template[] = {
 	},
 };
 
-#define HMAC_SHA3_512_TEST_VECTORS	4
-
 static struct hash_testvec hmac_sha3_512_tv_template[] = {
 	{
 		.key	= "\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
@@ -4300,8 +4218,6 @@ static struct hash_testvec hmac_sha3_512_tv_template[] = {
  * Poly1305 test vectors from RFC7539 A.3.
  */
 
-#define POLY1305_TEST_VECTORS	11
-
 static struct hash_testvec poly1305_tv_template[] = {
 	{ /* Test Vector #1 */
 		.plaintext	= "\x00\x00\x00\x00\x00\x00\x00\x00"
@@ -4547,19 +4463,6 @@ static struct hash_testvec poly1305_tv_template[] = {
 /*
  * DES test vectors.
  */
-#define DES_ENC_TEST_VECTORS		11
-#define DES_DEC_TEST_VECTORS		5
-#define DES_CBC_ENC_TEST_VECTORS	6
-#define DES_CBC_DEC_TEST_VECTORS	5
-#define DES_CTR_ENC_TEST_VECTORS	2
-#define DES_CTR_DEC_TEST_VECTORS	2
-#define DES3_EDE_ENC_TEST_VECTORS	4
-#define DES3_EDE_DEC_TEST_VECTORS	4
-#define DES3_EDE_CBC_ENC_TEST_VECTORS	2
-#define DES3_EDE_CBC_DEC_TEST_VECTORS	2
-#define DES3_EDE_CTR_ENC_TEST_VECTORS	2
-#define DES3_EDE_CTR_DEC_TEST_VECTORS	2
-
 static struct cipher_testvec des_enc_tv_template[] = {
 	{ /* From Applied Cryptography */
 		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef",
@@ -6620,13 +6523,6 @@ static struct cipher_testvec des3_ede_ctr_dec_tv_template[] = {
 /*
  * Blowfish test vectors.
  */
-#define BF_ENC_TEST_VECTORS	7
-#define BF_DEC_TEST_VECTORS	7
-#define BF_CBC_ENC_TEST_VECTORS	2
-#define BF_CBC_DEC_TEST_VECTORS	2
-#define BF_CTR_ENC_TEST_VECTORS	2
-#define BF_CTR_DEC_TEST_VECTORS	2
-
 static struct cipher_testvec bf_enc_tv_template[] = {
 	{ /* DES test vectors from OpenSSL */
 		.key	= "\x00\x00\x00\x00\x00\x00\x00\x00",
@@ -8152,17 +8048,6 @@ static struct cipher_testvec bf_ctr_dec_tv_template[] = {
 /*
  * Twofish test vectors.
  */
-#define TF_ENC_TEST_VECTORS		4
-#define TF_DEC_TEST_VECTORS		4
-#define TF_CBC_ENC_TEST_VECTORS		5
-#define TF_CBC_DEC_TEST_VECTORS		5
-#define TF_CTR_ENC_TEST_VECTORS		2
-#define TF_CTR_DEC_TEST_VECTORS		2
-#define TF_LRW_ENC_TEST_VECTORS		8
-#define TF_LRW_DEC_TEST_VECTORS		8
-#define TF_XTS_ENC_TEST_VECTORS		5
-#define TF_XTS_DEC_TEST_VECTORS		5
-
 static struct cipher_testvec tf_enc_tv_template[] = {
 	{
 		.key	= zeroed_string,
@@ -10881,24 +10766,6 @@ static struct cipher_testvec tf_xts_dec_tv_template[] = {
  * Serpent test vectors.  These are backwards because Serpent writes
  * octet sequences in right-to-left mode.
  */
-#define SERPENT_ENC_TEST_VECTORS	5
-#define SERPENT_DEC_TEST_VECTORS	5
-
-#define TNEPRES_ENC_TEST_VECTORS	4
-#define TNEPRES_DEC_TEST_VECTORS	4
-
-#define SERPENT_CBC_ENC_TEST_VECTORS	1
-#define SERPENT_CBC_DEC_TEST_VECTORS	1
-
-#define SERPENT_CTR_ENC_TEST_VECTORS	2
-#define SERPENT_CTR_DEC_TEST_VECTORS	2
-
-#define SERPENT_LRW_ENC_TEST_VECTORS	8
-#define SERPENT_LRW_DEC_TEST_VECTORS	8
-
-#define SERPENT_XTS_ENC_TEST_VECTORS	5
-#define SERPENT_XTS_DEC_TEST_VECTORS	5
-
 static struct cipher_testvec serpent_enc_tv_template[] = {
 	{
 		.input	= "\x00\x01\x02\x03\x04\x05\x06\x07"
@@ -13637,17 +13504,6 @@ static struct cipher_testvec serpent_xts_dec_tv_template[] = {
 };
 
 /* Cast6 test vectors from RFC 2612 */
-#define CAST6_ENC_TEST_VECTORS		4
-#define CAST6_DEC_TEST_VECTORS		4
-#define CAST6_CBC_ENC_TEST_VECTORS	1
-#define CAST6_CBC_DEC_TEST_VECTORS	1
-#define CAST6_CTR_ENC_TEST_VECTORS	2
-#define CAST6_CTR_DEC_TEST_VECTORS	2
-#define CAST6_LRW_ENC_TEST_VECTORS	1
-#define CAST6_LRW_DEC_TEST_VECTORS	1
-#define CAST6_XTS_ENC_TEST_VECTORS	1
-#define CAST6_XTS_DEC_TEST_VECTORS	1
-
 static struct cipher_testvec cast6_enc_tv_template[] = {
 	{
 		.key	= "\x23\x42\xbb\x9e\xfa\x38\x54\x2c"
@@ -15182,38 +15038,6 @@ static struct cipher_testvec cast6_xts_dec_tv_template[] = {
 /*
  * AES test vectors.
  */
-#define AES_ENC_TEST_VECTORS 4
-#define AES_DEC_TEST_VECTORS 4
-#define AES_CBC_ENC_TEST_VECTORS 5
-#define AES_CBC_DEC_TEST_VECTORS 5
-#define HMAC_MD5_ECB_CIPHER_NULL_ENC_TEST_VECTORS 2
-#define HMAC_MD5_ECB_CIPHER_NULL_DEC_TEST_VECTORS 2
-#define HMAC_SHA1_ECB_CIPHER_NULL_ENC_TEST_VEC 2
-#define HMAC_SHA1_ECB_CIPHER_NULL_DEC_TEST_VEC 2
-#define HMAC_SHA1_AES_CBC_ENC_TEST_VEC 7
-#define HMAC_SHA256_AES_CBC_ENC_TEST_VEC 7
-#define HMAC_SHA512_AES_CBC_ENC_TEST_VEC 7
-#define AES_LRW_ENC_TEST_VECTORS 8
-#define AES_LRW_DEC_TEST_VECTORS 8
-#define AES_XTS_ENC_TEST_VECTORS 5
-#define AES_XTS_DEC_TEST_VECTORS 5
-#define AES_CTR_ENC_TEST_VECTORS 5
-#define AES_CTR_DEC_TEST_VECTORS 5
-#define AES_OFB_ENC_TEST_VECTORS 1
-#define AES_OFB_DEC_TEST_VECTORS 1
-#define AES_CTR_3686_ENC_TEST_VECTORS 7
-#define AES_CTR_3686_DEC_TEST_VECTORS 6
-#define AES_GCM_ENC_TEST_VECTORS 9
-#define AES_GCM_DEC_TEST_VECTORS 8
-#define AES_GCM_4106_ENC_TEST_VECTORS 23
-#define AES_GCM_4106_DEC_TEST_VECTORS 23
-#define AES_GCM_4543_ENC_TEST_VECTORS 1
-#define AES_GCM_4543_DEC_TEST_VECTORS 2
-#define AES_CCM_ENC_TEST_VECTORS 8
-#define AES_CCM_DEC_TEST_VECTORS 7
-#define AES_CCM_4309_ENC_TEST_VECTORS 7
-#define AES_CCM_4309_DEC_TEST_VECTORS 10
-
 static struct cipher_testvec aes_enc_tv_template[] = {
 	{ /* From FIPS-197 */
 		.key	= "\x00\x01\x02\x03\x04\x05\x06\x07"
@@ -17069,8 +16893,6 @@ static struct aead_testvec hmac_sha512_aes_cbc_enc_tv_temp[] = {
 	},
 };
 
-#define HMAC_SHA1_DES_CBC_ENC_TEST_VEC	1
-
 static struct aead_testvec hmac_sha1_des_cbc_enc_tv_temp[] = {
 	{ /*Generated with cryptopp*/
 #ifdef __LITTLE_ENDIAN
@@ -17130,8 +16952,6 @@ static struct aead_testvec hmac_sha1_des_cbc_enc_tv_temp[] = {
 	},
 };
 
-#define HMAC_SHA224_DES_CBC_ENC_TEST_VEC	1
-
 static struct aead_testvec hmac_sha224_des_cbc_enc_tv_temp[] = {
 	{ /*Generated with cryptopp*/
 #ifdef __LITTLE_ENDIAN
@@ -17191,8 +17011,6 @@ static struct aead_testvec hmac_sha224_des_cbc_enc_tv_temp[] = {
 	},
 };
 
-#define HMAC_SHA256_DES_CBC_ENC_TEST_VEC	1
-
 static struct aead_testvec hmac_sha256_des_cbc_enc_tv_temp[] = {
 	{ /*Generated with cryptopp*/
 #ifdef __LITTLE_ENDIAN
@@ -17254,8 +17072,6 @@ static struct aead_testvec hmac_sha256_des_cbc_enc_tv_temp[] = {
 	},
 };
 
-#define HMAC_SHA384_DES_CBC_ENC_TEST_VEC	1
-
 static struct aead_testvec hmac_sha384_des_cbc_enc_tv_temp[] = {
 	{ /*Generated with cryptopp*/
 #ifdef __LITTLE_ENDIAN
@@ -17321,8 +17137,6 @@ static struct aead_testvec hmac_sha384_des_cbc_enc_tv_temp[] = {
 	},
 };
 
-#define HMAC_SHA512_DES_CBC_ENC_TEST_VEC	1
-
 static struct aead_testvec hmac_sha512_des_cbc_enc_tv_temp[] = {
 	{ /*Generated with cryptopp*/
 #ifdef __LITTLE_ENDIAN
@@ -17392,8 +17206,6 @@ static struct aead_testvec hmac_sha512_des_cbc_enc_tv_temp[] = {
 	},
 };
 
-#define HMAC_SHA1_DES3_EDE_CBC_ENC_TEST_VEC	1
-
 static struct aead_testvec hmac_sha1_des3_ede_cbc_enc_tv_temp[] = {
 	{ /*Generated with cryptopp*/
 #ifdef __LITTLE_ENDIAN
@@ -17455,8 +17267,6 @@ static struct aead_testvec hmac_sha1_des3_ede_cbc_enc_tv_temp[] = {
 	},
 };
 
-#define HMAC_SHA224_DES3_EDE_CBC_ENC_TEST_VEC	1
-
 static struct aead_testvec hmac_sha224_des3_ede_cbc_enc_tv_temp[] = {
 	{ /*Generated with cryptopp*/
 #ifdef __LITTLE_ENDIAN
@@ -17518,8 +17328,6 @@ static struct aead_testvec hmac_sha224_des3_ede_cbc_enc_tv_temp[] = {
 	},
 };
 
-#define HMAC_SHA256_DES3_EDE_CBC_ENC_TEST_VEC	1
-
 static struct aead_testvec hmac_sha256_des3_ede_cbc_enc_tv_temp[] = {
 	{ /*Generated with cryptopp*/
 #ifdef __LITTLE_ENDIAN
@@ -17583,8 +17391,6 @@ static struct aead_testvec hmac_sha256_des3_ede_cbc_enc_tv_temp[] = {
 	},
 };
 
-#define HMAC_SHA384_DES3_EDE_CBC_ENC_TEST_VEC	1
-
 static struct aead_testvec hmac_sha384_des3_ede_cbc_enc_tv_temp[] = {
 	{ /*Generated with cryptopp*/
 #ifdef __LITTLE_ENDIAN
@@ -17652,8 +17458,6 @@ static struct aead_testvec hmac_sha384_des3_ede_cbc_enc_tv_temp[] = {
 	},
 };
 
-#define HMAC_SHA512_DES3_EDE_CBC_ENC_TEST_VEC	1
-
 static struct aead_testvec hmac_sha512_des3_ede_cbc_enc_tv_temp[] = {
 	{ /*Generated with cryptopp*/
 #ifdef __LITTLE_ENDIAN
@@ -24434,8 +24238,6 @@ static struct aead_testvec aes_ccm_rfc4309_dec_tv_template[]	= {
 /*
  * ChaCha20-Poly1305 AEAD test vectors from RFC7539 2.8.2./A.5.
  */
-#define RFC7539_ENC_TEST_VECTORS 2
-#define RFC7539_DEC_TEST_VECTORS 2
 static struct aead_testvec rfc7539_enc_tv_template[] = {
 	{
 		.key	= "\x80\x81\x82\x83\x84\x85\x86\x87"
@@ -24703,8 +24505,6 @@ static struct aead_testvec rfc7539_dec_tv_template[] = {
 /*
  * draft-irtf-cfrg-chacha20-poly1305
  */
-#define RFC7539ESP_DEC_TEST_VECTORS 1
-#define RFC7539ESP_ENC_TEST_VECTORS 1
 static struct aead_testvec rfc7539esp_enc_tv_template[] = {
 	{
 		.key	= "\x1c\x92\x40\xa5\xeb\x55\xd3\x8a"
@@ -24927,8 +24727,6 @@ static struct cipher_testvec aes_kw_dec_tv_template[] = {
  *     http://csrc.nist.gov/groups/STM/cavp/documents/rng/RNGVS.pdf
  * Only AES-128 is supported at this time.
  */
-#define ANSI_CPRNG_AES_TEST_VECTORS	6
-
 static struct cprng_testvec ansi_cprng_aes_tv_template[] = {
 	{
 		.key	= "\xf3\xb1\x66\x6d\x13\x60\x72\x42"
@@ -25846,13 +25644,6 @@ static struct drbg_testvec drbg_nopr_ctr_aes128_tv_template[] = {
 };
 
 /* Cast5 test vectors from RFC 2144 */
-#define CAST5_ENC_TEST_VECTORS		4
-#define CAST5_DEC_TEST_VECTORS		4
-#define CAST5_CBC_ENC_TEST_VECTORS	1
-#define CAST5_CBC_DEC_TEST_VECTORS	1
-#define CAST5_CTR_ENC_TEST_VECTORS	2
-#define CAST5_CTR_DEC_TEST_VECTORS	2
-
 static struct cipher_testvec cast5_enc_tv_template[] = {
 	{
 		.key	= "\x01\x23\x45\x67\x12\x34\x56\x78"
@@ -26756,9 +26547,6 @@ static struct cipher_testvec cast5_ctr_dec_tv_template[] = {
 /*
  * ARC4 test vectors from OpenSSL
  */
-#define ARC4_ENC_TEST_VECTORS	7
-#define ARC4_DEC_TEST_VECTORS	7
-
 static struct cipher_testvec arc4_enc_tv_template[] = {
 	{
 		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef",
@@ -26894,9 +26682,6 @@ static struct cipher_testvec arc4_dec_tv_template[] = {
 /*
  * TEA test vectors
  */
-#define TEA_ENC_TEST_VECTORS	4
-#define TEA_DEC_TEST_VECTORS	4
-
 static struct cipher_testvec tea_enc_tv_template[] = {
 	{
 		.key    = zeroed_string,
@@ -26986,9 +26771,6 @@ static struct cipher_testvec tea_dec_tv_template[] = {
 /*
  * XTEA test vectors
  */
-#define XTEA_ENC_TEST_VECTORS	4
-#define XTEA_DEC_TEST_VECTORS	4
-
 static struct cipher_testvec xtea_enc_tv_template[] = {
 	{
 		.key    = zeroed_string,
@@ -27078,9 +26860,6 @@ static struct cipher_testvec xtea_dec_tv_template[] = {
 /*
  * KHAZAD test vectors.
  */
-#define KHAZAD_ENC_TEST_VECTORS 5
-#define KHAZAD_DEC_TEST_VECTORS 5
-
 static struct cipher_testvec khazad_enc_tv_template[] = {
 	{
 		.key	= "\x80\x00\x00\x00\x00\x00\x00\x00"
@@ -27177,11 +26956,6 @@ static struct cipher_testvec khazad_dec_tv_template[] = {
  * Anubis test vectors.
  */
 
-#define ANUBIS_ENC_TEST_VECTORS			5
-#define ANUBIS_DEC_TEST_VECTORS			5
-#define ANUBIS_CBC_ENC_TEST_VECTORS		2
-#define ANUBIS_CBC_DEC_TEST_VECTORS		2
-
 static struct cipher_testvec anubis_enc_tv_template[] = {
 	{
 		.key	= "\xfe\xfe\xfe\xfe\xfe\xfe\xfe\xfe"
@@ -27381,9 +27155,6 @@ static struct cipher_testvec anubis_cbc_dec_tv_template[] = {
 /*
  * XETA test vectors
  */
-#define XETA_ENC_TEST_VECTORS	4
-#define XETA_DEC_TEST_VECTORS	4
-
 static struct cipher_testvec xeta_enc_tv_template[] = {
 	{
 		.key    = zeroed_string,
@@ -27473,9 +27244,6 @@ static struct cipher_testvec xeta_dec_tv_template[] = {
 /*
  * FCrypt test vectors
  */
-#define FCRYPT_ENC_TEST_VECTORS	ARRAY_SIZE(fcrypt_pcbc_enc_tv_template)
-#define FCRYPT_DEC_TEST_VECTORS	ARRAY_SIZE(fcrypt_pcbc_dec_tv_template)
-
 static struct cipher_testvec fcrypt_pcbc_enc_tv_template[] = {
 	{ /* http://www.openafs.org/pipermail/openafs-devel/2000-December/005320.html */
 		.key	= "\x00\x00\x00\x00\x00\x00\x00\x00",
@@ -27601,17 +27369,6 @@ static struct cipher_testvec fcrypt_pcbc_dec_tv_template[] = {
 /*
  * CAMELLIA test vectors.
  */
-#define CAMELLIA_ENC_TEST_VECTORS 4
-#define CAMELLIA_DEC_TEST_VECTORS 4
-#define CAMELLIA_CBC_ENC_TEST_VECTORS 3
-#define CAMELLIA_CBC_DEC_TEST_VECTORS 3
-#define CAMELLIA_CTR_ENC_TEST_VECTORS 2
-#define CAMELLIA_CTR_DEC_TEST_VECTORS 2
-#define CAMELLIA_LRW_ENC_TEST_VECTORS 8
-#define CAMELLIA_LRW_DEC_TEST_VECTORS 8
-#define CAMELLIA_XTS_ENC_TEST_VECTORS 5
-#define CAMELLIA_XTS_DEC_TEST_VECTORS 5
-
 static struct cipher_testvec camellia_enc_tv_template[] = {
 	{
 		.key	= "\x01\x23\x45\x67\x89\xab\xcd\xef"
@@ -31331,9 +31088,6 @@ static struct cipher_testvec camellia_xts_dec_tv_template[] = {
 /*
  * SEED test vectors
  */
-#define SEED_ENC_TEST_VECTORS	4
-#define SEED_DEC_TEST_VECTORS	4
-
 static struct cipher_testvec seed_enc_tv_template[] = {
 	{
 		.key    = zeroed_string,
@@ -31418,7 +31172,6 @@ static struct cipher_testvec seed_dec_tv_template[] = {
 	}
 };
 
-#define SALSA20_STREAM_ENC_TEST_VECTORS 5
 static struct cipher_testvec salsa20_stream_enc_tv_template[] = {
 	/*
 	* Testvectors from verified.test-vectors submitted to ECRYPT.
@@ -32588,7 +32341,6 @@ static struct cipher_testvec salsa20_stream_enc_tv_template[] = {
 	},
 };
 
-#define CHACHA20_ENC_TEST_VECTORS 4
 static struct cipher_testvec chacha20_enc_tv_template[] = {
 	{ /* RFC7539 A.2. Test Vector #1 */
 		.key	= "\x00\x00\x00\x00\x00\x00\x00\x00"
@@ -33100,8 +32852,6 @@ static struct cipher_testvec chacha20_enc_tv_template[] = {
 /*
  * CTS (Cipher Text Stealing) mode tests
  */
-#define CTS_MODE_ENC_TEST_VECTORS 6
-#define CTS_MODE_DEC_TEST_VECTORS 6
 static struct cipher_testvec cts_mode_enc_tv_template[] = {
 	{ /* from rfc3962 */
 		.klen	= 16,
@@ -33322,9 +33072,6 @@ struct comp_testvec {
  * Params: winbits=-11, Z_DEFAULT_COMPRESSION, MAX_MEM_LEVEL.
  */
 
-#define DEFLATE_COMP_TEST_VECTORS 2
-#define DEFLATE_DECOMP_TEST_VECTORS 2
-
 static struct comp_testvec deflate_comp_tv_template[] = {
 	{
 		.inlen	= 70,
@@ -33400,9 +33147,6 @@ static struct comp_testvec deflate_decomp_tv_template[] = {
 /*
  * LZO test vectors (null-terminated strings).
  */
-#define LZO_COMP_TEST_VECTORS 2
-#define LZO_DECOMP_TEST_VECTORS 2
-
 static struct comp_testvec lzo_comp_tv_template[] = {
 	{
 		.inlen	= 70,
@@ -33534,8 +33278,6 @@ static struct hash_testvec michael_mic_tv_template[] = {
 /*
  * CRC32 test vectors
  */
-#define CRC32_TEST_VECTORS 14
-
 static struct hash_testvec crc32_tv_template[] = {
 	{
 		.key = "\x87\xa9\xcb\xed",
@@ -33968,8 +33710,6 @@ static struct hash_testvec crc32_tv_template[] = {
 /*
  * CRC32C test vectors
  */
-#define CRC32C_TEST_VECTORS 15
-
 static struct hash_testvec crc32c_tv_template[] = {
 	{
 		.psize = 0,
@@ -34406,8 +34146,6 @@ static struct hash_testvec crc32c_tv_template[] = {
 /*
  * Blakcifn CRC test vectors
  */
-#define BFIN_CRC_TEST_VECTORS 6
-
 static struct hash_testvec bfin_crc_tv_template[] = {
 	{
 		.psize = 0,
@@ -34493,9 +34231,6 @@ static struct hash_testvec bfin_crc_tv_template[] = {
 
 };
 
-#define LZ4_COMP_TEST_VECTORS 1
-#define LZ4_DECOMP_TEST_VECTORS 1
-
 static struct comp_testvec lz4_comp_tv_template[] = {
 	{
 		.inlen	= 70,
@@ -34526,9 +34261,6 @@ static struct comp_testvec lz4_decomp_tv_template[] = {
 	},
 };
 
-#define LZ4HC_COMP_TEST_VECTORS 1
-#define LZ4HC_DECOMP_TEST_VECTORS 1
-
 static struct comp_testvec lz4hc_comp_tv_template[] = {
 	{
 		.inlen	= 70,
-- 
2.7.4
