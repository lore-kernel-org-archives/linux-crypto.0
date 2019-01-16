Return-Path: <SRS0=g5s/=PY=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.52]:16829 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730526AbfAPLMF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Jan 2019 06:12:05 -0500
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
Subject: [PATCH v2 6/6] crypto: tcrypt - add KDF test invocation
Date: Wed, 16 Jan 2019 12:09:33 +0100
Message-ID: <8600018.3ZaGsXI4pz@positron.chronox.de>
In-Reply-To: <2082192.jPI8ve1O8G@positron.chronox.de>
References: <20190103143227.9138-1-jlee@suse.com> <9733066.Vrs4h5eWcW@positron.chronox.de> <2082192.jPI8ve1O8G@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Enable testing of the SP800-108 and RFC5869 KDFs.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/tcrypt.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index e7fb87e114a5..5606e59e80ec 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -2054,6 +2054,14 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 		ret += tcrypt_test("cbc(sm4)");
 		ret += tcrypt_test("ctr(sm4)");
 		break;
+	case 192:
+		ret += tcrypt_test("kdf_ctr(hmac(sha256))");
+		ret += tcrypt_test("kdf_dpi(hmac(sha256))");
+		ret += tcrypt_test("kdf_fb(hmac(sha256))");
+		break;
+	case 193:
+		ret += tcrypt_test("hkdf(hmac(sha256))");
+		break;
 	case 200:
 		test_cipher_speed("ecb(aes)", ENCRYPT, sec, NULL, 0,
 				speed_template_16_24_32);
-- 
2.20.1
