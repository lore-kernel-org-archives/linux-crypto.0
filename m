From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH] [CRYPTO] Extend sha256_generic.c to support SHA-224
	and SHA-224-HMAC
Date: Tue, 6 Nov 2007 20:02:42 +0100
Message-ID: <20071106190242.GC15572@Chamillionaire.breakpoint.cc>
References: <20071106182800.GA32299@compsoc.nuigalway.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: Jonathan Lynch <jonathan.lynch@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:37753 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752973AbXKFTCq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 6 Nov 2007 14:02:46 -0500
Content-Disposition: inline
In-Reply-To: <20071106182800.GA32299@compsoc.nuigalway.ie>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Jonathan Lynch | 2007-11-06 18:28:00 [+0000]:

>SHA-224 should be chosen as a hash algorithm when 112 bits of security
>strength is required.

Who uses such an algorithm (in terms of application)?

>diff -uprN -X linux-2.6.24-rc1-vanilla/Documentation/dontdiff linux-2.6.24-rc1-vanilla/crypto/tcrypt.c linux-2.6.24-rc1/crypto/tcrypt.c
>--- linux-2.6.24-rc1-vanilla/crypto/tcrypt.c	2007-11-05 17:12:50.468842000 +0000
>+++ linux-2.6.24-rc1/crypto/tcrypt.c	2007-11-06 10:20:30.985270000 +0000
>@@ -1097,10 +1102,14 @@ static void do_test(void)
> 		break;
> 
> 	case 6:
>-		test_hash("sha256", sha256_tv_template, SHA256_TEST_VECTORS);
>+		test_hash("sha224", sha224_tv_template, SHA224_TEST_VECTORS);
> 		break;
> 
> 	case 7:
>+		test_hash("sha256", sha256_tv_template, SHA256_TEST_VECTORS);
>+		break;
>+
>+	case 8:
> 		test_cipher("ecb(blowfish)", ENCRYPT, bf_enc_tv_template,
> 			    BF_ENC_TEST_VECTORS);
> 		test_cipher("ecb(blowfish)", DECRYPT, bf_dec_tv_template,
>@@ -1111,7 +1120,7 @@ static void do_test(void)
> 			    BF_CBC_DEC_TEST_VECTORS);
> 		break;
> 
>-	case 8:
>+	case 9:
> 		test_cipher("ecb(twofish)", ENCRYPT, tf_enc_tv_template,
> 			    TF_ENC_TEST_VECTORS);
> 		test_cipher("ecb(twofish)", DECRYPT, tf_dec_tv_template,

Extend does not mean you change the user interface of the module. Please
pick your own number. This breaks atleast two of mine scripts.

>diff -uprN -X linux-2.6.24-rc1-vanilla/Documentation/dontdiff linux-2.6.24-rc1-vanilla/crypto/tcrypt.h linux-2.6.24-rc1/crypto/tcrypt.h
>--- linux-2.6.24-rc1-vanilla/crypto/tcrypt.h	2007-11-05 17:12:50.492842000 +0000
>+++ linux-2.6.24-rc1/crypto/tcrypt.h	2007-11-05 18:18:31.610720000 +0000
>@@ -173,6 +173,33 @@ static struct hash_testvec sha1_tv_templ
> 	}
> };
> 
>+
>+/*
>+ * SHA224 test vectors from from FIPS PUB 180-2
>+ */
>+#define SHA224_TEST_VECTORS     2
>+
>+static struct hash_testvec sha224_tv_template[] = {
>+	{
>+		.plaintext = "abc",
>+		.psize  = 3,
>+		.digest = { 0x23, 0x09, 0x7D, 0x22, 0x34, 0x05, 0xD8, 0x22,
>+			0x86, 0x42, 0xA4, 0x77, 0xBD, 0xA2, 0x55, 0xB3,
>+			0x2A, 0xAD, 0xBC, 0xE4, 0xBD, 0xA0, 0xB3, 0xF7,
>+			0xE3, 0x6C, 0x9D, 0xA7},
>+	}, {
>+		.plaintext =
>+		"abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq",
>+		.psize  = 56,
>+		.digest = { 0x75, 0x38, 0x8B, 0x16, 0x51, 0x27, 0x76, 0xCC,
>+			0x5D, 0xBA, 0x5D, 0xA1, 0xFD, 0x89, 0x01, 0x50,
>+			0xB0, 0xC6, 0x45, 0x5C, 0xB4, 0xF5, 0x8B, 0x19,
>+			0x52, 0x52, 0x25, 0x25 },
>+		.np     = 2,
>+		.tap    = { 28, 28 }
>+	}
>+};
>+
> /*
>  * SHA256 test vectors from from NIST
>  */
>@@ -753,6 +780,7 @@ static struct hash_testvec hmac_md5_tv_t
> 	},
> };
> 
>+
> /*
>  * HMAC-SHA1 test vectors from RFC2202
>  */
>@@ -817,6 +845,121 @@ static struct hash_testvec hmac_sha1_tv_
> 	},
> };
> 
>+
>+/*
>+ * SHA224 HMAC test vectors from RFC4231
>+ */
>+#define HMAC_SHA224_TEST_VECTORS    4
>+
>+static struct hash_testvec hmac_sha224_tv_template[] = {

Please don't introduce any empty lines. You could save hunk #2 btw :)

Sebastian
