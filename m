Return-Path: <SRS0=g5s/=PY=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.80]:34072 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389696AbfAPLLt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Jan 2019 06:11:49 -0500
From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@kernel.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, keyrings@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Chen Yu <yu.c.chen@intel.com>,
        Oliver Neukum <oneukum@suse.com>,
        Ryan Chen <yu.chen.surf@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Giovanni Gherdovich <ggherdovich@suse.cz>,
        Randy Dunlap <rdunlap@infradead.org>,
        Jann Horn <jannh@google.com>,
        Andy Lutomirski <luto@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH v2 5/6] crypto: hkdf - add known answer tests
Date: Wed, 16 Jan 2019 12:09:11 +0100
Message-ID: <2443102.TZCsN2CrQ3@positron.chronox.de>
In-Reply-To: <2082192.jPI8ve1O8G@positron.chronox.de>
References: <20190103143227.9138-1-jlee@suse.com> <9733066.Vrs4h5eWcW@positron.chronox.de> <2082192.jPI8ve1O8G@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add known answer tests to the testmgr for the HKDF (RFC5869) cipher.

The known answer tests are derived from RFC 5869 appendix A.

Note, the HKDF is considered to be a FIPS 140-2 allowed (not approved)
cipher as of now. Yet, an allowed cipher is usable under FIPS 140-2
rules.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/testmgr.c | 26 ++++++++++++++
 crypto/testmgr.h | 91 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 117 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 309819af55d8..0b06721a70df 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -3189,6 +3189,32 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.suite = {
 			.hash = __VECS(ghash_tv_template)
 		}
+	}, {
+		.alg = "hkdf(hmac(sha1))",
+		.test = alg_test_kdf,
+		.fips_allowed = 1,
+		.suite = {
+			.kdf = __VECS(hkdf_hmac_sha1_tv_template)
+		}
+	}, {
+		.alg = "hkdf(hmac(sha224))",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
+		.alg = "hkdf(hmac(sha256))",
+		.test = alg_test_kdf,
+		.fips_allowed = 1,
+		.suite = {
+			.kdf = __VECS(hkdf_hmac_sha256_tv_template)
+		}
+	}, {
+		.alg = "hkdf(hmac(sha384))",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
+		.alg = "hkdf(hmac(sha512))",
+		.test = alg_test_null,
+		.fips_allowed = 1,
 	}, {
 		.alg = "hmac(md5)",
 		.test = alg_test_hash,
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 65fe3d4ef082..7ffff184fba2 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -27999,6 +27999,97 @@ static const struct kdf_testvec kdf_dpi_hmac_sha256_tv_template[] = {
 	}
 };
 
+/* Test vectors from RFC 5869 appendix A */
+static const struct kdf_testvec hkdf_hmac_sha256_tv_template[] = {
+	{
+		.K1 =
+#ifdef __LITTLE_ENDIAN
+			"\x0d\x00\x00\x00"		/* salt length */
+#else
+			"\x00\x00\x00\x0d"		/* salt length */
+#endif
+			"\x00\x01\x02\x03\x04\x05\x06\x07"
+			"\x08\x09\x0a\x0b\x0c"		/* salt */
+			"\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
+			"\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
+			"\x0b\x0b\x0b\x0b\x0b\x0b",	/* IKM */
+		.K1len = 39,
+		.context =
+			"\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7"
+			"\xf8\xf9",
+		.contextlen = 10,
+		.expected =
+			"\x3c\xb2\x5f\x25\xfa\xac\xd5\x7a"
+			"\x90\x43\x4f\x64\xd0\x36\x2f\x2a"
+			"\x2d\x2d\x0a\x90\xcf\x1a\x5a\x4c"
+			"\x5d\xb0\x2d\x56\xec\xc4\xc5\xbf"
+			"\x34\x00\x72\x08\xd5\xb8\x87\x18"
+			"\x58\x65",
+		.expectedlen = 42
+	}, {
+		.K1 =	"\x00\x00\x00\x00"		/* salt length */
+			"\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
+			"\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
+			"\x0b\x0b\x0b\x0b\x0b\x0b",	/* IKM */
+		.K1len = 26,
+		.context = NULL,
+		.contextlen = 0,
+		.expected =
+			"\x8d\xa4\xe7\x75\xa5\x63\xc1\x8f"
+			"\x71\x5f\x80\x2a\x06\x3c\x5a\x31"
+			"\xb8\xa1\x1f\x5c\x5e\xe1\x87\x9e"
+			"\xc3\x45\x4e\x5f\x3c\x73\x8d\x2d"
+			"\x9d\x20\x13\x95\xfa\xa4\xb6\x1a"
+			"\x96\xc8",
+		.expectedlen = 42
+	}
+};
+
+/* Test vectors from RFC 5869 appendix A */
+static const struct kdf_testvec hkdf_hmac_sha1_tv_template[] = {
+	{
+		.K1 =
+#ifdef __LITTLE_ENDIAN
+			"\x0d\x00\x00\x00"		/* salt length */
+#else
+			"\x00\x00\x00\x0d"		/* salt length */
+#endif
+			"\x00\x01\x02\x03\x04\x05\x06\x07"
+			"\x08\x09\x0a\x0b\x0c"		/* salt */
+			"\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
+			"\x0b\x0b\x0b",			/* IKM */
+		.K1len = 28,
+		.context =
+			"\xf0\xf1\xf2\xf3\xf4\xf5\xf6\xf7"
+			"\xf8\xf9",
+		.contextlen = 10,
+		.expected =
+			"\x08\x5a\x01\xea\x1b\x10\xf3\x69"
+			"\x33\x06\x8b\x56\xef\xa5\xad\x81"
+			"\xa4\xf1\x4b\x82\x2f\x5b\x09\x15"
+			"\x68\xa9\xcd\xd4\xf1\x55\xfd\xa2"
+			"\xc2\x2e\x42\x24\x78\xd3\x05\xf3"
+			"\xf8\x96",
+		.expectedlen = 42
+	}, {
+		.K1 =	"\x00\x00\x00\x00"		/* salt length */
+			"\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
+			"\x0b\x0b\x0b\x0b\x0b\x0b\x0b\x0b"
+			"\x0b\x0b\x0b\x0b\x0b\x0b",	/* IKM */
+		.K1len = 26,
+		.context = NULL,
+		.contextlen = 0,
+		.expected =
+			"\x0a\xc1\xaf\x70\x02\xb3\xd7\x61"
+			"\xd1\xe5\x52\x98\xda\x9d\x05\x06"
+			"\xb9\xae\x52\x05\x72\x20\xa3\x06"
+			"\xe0\x7b\x6b\x87\xe8\xdf\x21\xd0"
+			"\xea\x00\x03\x3d\xe0\x39\x84\xd3"
+			"\x49\x18",
+		.expectedlen = 42
+	}
+};
+
 /* Cast5 test vectors from RFC 2144 */
 static const struct cipher_testvec cast5_tv_template[] = {
 	{
-- 
2.20.1
