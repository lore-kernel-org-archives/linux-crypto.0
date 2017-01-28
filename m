From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 1/4] crypto: testmgr - add test cases for cbcmac(aes)
Date: Sat, 28 Jan 2017 23:33:30 +0000
Message-ID: <1485646413-17491-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1485646413-17491-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:34076 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752120AbdA1Xeq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 28 Jan 2017 18:34:46 -0500
Received: by mail-wm0-f47.google.com with SMTP id r126so333047wmr.1
        for <linux-crypto@vger.kernel.org>; Sat, 28 Jan 2017 15:34:00 -0800 (PST)
In-Reply-To: <1485646413-17491-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In preparation of splitting off the CBC-MAC transform in the CCM
driver into a separate algorithm, define some test cases for the
AES incarnation of cbcmac.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/testmgr.c |  7 +++
 crypto/testmgr.h | 58 ++++++++++++++++++++
 2 files changed, 65 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 98eb09782db8..f9c378af3907 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2514,6 +2514,13 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "cbcmac(aes)",
+		.fips_allowed = 1,
+		.test = alg_test_hash,
+		.suite = {
+			.hash = __VECS(aes_cbcmac_tv_template)
+		}
+	}, {
 		.alg = "ccm(aes)",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 64595f067d72..ed6b09978611 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -3413,6 +3413,64 @@ static struct hash_testvec aes_cmac128_tv_template[] = {
 	}
 };
 
+static struct hash_testvec aes_cbcmac_tv_template[] = {
+	{
+		.key		= "\x2b\x7e\x15\x16\x28\xae\xd2\xa6"
+				  "\xab\xf7\x15\x88\x09\xcf\x4f\x3c",
+		.plaintext	= "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
+				  "\xe9\x3d\x7e\x11\x73\x93\x17\x2a",
+		.digest		= "\x3a\xd7\x7b\xb4\x0d\x7a\x36\x60"
+				  "\xa8\x9e\xca\xf3\x24\x66\xef\x97",
+		.psize		= 16,
+		.ksize		= 16,
+	}, {
+		.key		= "\x2b\x7e\x15\x16\x28\xae\xd2\xa6"
+				  "\xab\xf7\x15\x88\x09\xcf\x4f\x3c",
+		.plaintext	= "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
+				  "\xe9\x3d\x7e\x11\x73\x93\x17\x2a"
+				  "\xae\x2d\x8a\x57\x1e\x03\xac\x9c"
+				  "\x9e\xb7\x6f\xac\x45\xaf\x8e\x51"
+				  "\x30",
+		.digest		= "\x9d\x0d\xd0\x63\xfb\xcb\x24\x43"
+				  "\xf8\xf2\x76\x03\xac\x39\xb0\x9d",
+		.psize		= 33,
+		.ksize		= 16,
+	}, {
+		.key		= "\x2b\x7e\x15\x16\x28\xae\xd2\xa6"
+				  "\xab\xf7\x15\x88\x09\xcf\x4f\x3c",
+		.plaintext	= "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
+				  "\xe9\x3d\x7e\x11\x73\x93\x17\x2a"
+				  "\xae\x2d\x8a\x57\x1e\x03\xac\x9c"
+				  "\x9e\xb7\x6f\xac\x45\xaf\x8e\x51"
+				  "\x30\xc8\x1c\x46\xa3\x5c\xe4\x11"
+				  "\xe5\xfb\xc1\x19\x1a\x0a\x52\xef"
+				  "\xf6\x9f\x24\x45\xdf\x4f\x9b\x17"
+				  "\xad\x2b\x41\x7b\xe6\x6c\x37",
+		.digest		= "\xc0\x71\x73\xb8\xa0\x2c\x11\x7c"
+				  "\xaf\xdc\xb2\xf8\x89\x32\xa3\x3a",
+		.psize		= 63,
+		.ksize		= 16,
+	}, {
+		.key		= "\x60\x3d\xeb\x10\x15\xca\x71\xbe"
+				  "\x2b\x73\xae\xf0\x85\x7d\x77\x81"
+				  "\x1f\x35\x2c\x07\x3b\x61\x08\xd7"
+				  "\x2d\x98\x10\xa3\x09\x14\xdf\xf4",
+		.plaintext	= "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
+				  "\xe9\x3d\x7e\x11\x73\x93\x17\x2a"
+				  "\xae\x2d\x8a\x57\x1e\x03\xac\x9c"
+				  "\x9e\xb7\x6f\xac\x45\xaf\x8e\x51"
+				  "\x30\xc8\x1c\x46\xa3\x5c\xe4\x11"
+				  "\xe5\xfb\xc1\x19\x1a\x0a\x52\xef"
+				  "\xf6\x9f\x24\x45\xdf\x4f\x9b\x17"
+				  "\xad\x2b\x41\x7b\xe6\x6c\x37\x10"
+				  "\x1c",
+		.digest		= "\x6a\x4e\xdb\x21\x47\x51\xdf\x4f"
+				  "\xa8\x4d\x4c\x10\x3b\x72\x7d\xd6",
+		.psize		= 65,
+		.ksize		= 32,
+	}
+};
+
 static struct hash_testvec des3_ede_cmac64_tv_template[] = {
 /*
  * From NIST Special Publication 800-38B, Three Key TDEA
-- 
2.7.4
