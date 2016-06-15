From: Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>
Subject: RE: [PATCH 2/2] Crypto: Add SHA-3 Test's in tcrypt
Date: Wed, 15 Jun 2016 15:20:49 +0530
Message-ID: <016ee0e718b11041cde5c4fe3d251940@mail.gmail.com>
References: <1465983719-8313-1-git-send-email-raveendra.padasalagi@broadcom.com>
 <1465983719-8313-3-git-send-email-raveendra.padasalagi@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jon Mason <jonmason@broadcom.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Anup Patel <anup.patel@broadcom.com>,
	Ray Jui <rjui@broadcom.com>,
	Scott Branden <sbranden@broadcom.com>,
	Pramod Kumar <pramod.kumar@broadcom.com>,
	bcm-kernel-feedback-list@broadcom.com
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jeff Garzik <jeff@garzik.org>, Jeff Garzik <jgarzik@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yw0-f171.google.com ([209.85.161.171]:34334 "EHLO
	mail-yw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbcFOJuw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jun 2016 05:50:52 -0400
Received: by mail-yw0-f171.google.com with SMTP id c72so15188294ywb.1
        for <linux-crypto@vger.kernel.org>; Wed, 15 Jun 2016 02:50:51 -0700 (PDT)
In-Reply-To: <1465983719-8313-3-git-send-email-raveendra.padasalagi@broadcom.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Forgot to add Jeff Garzik in the email list.

++  Jeff Garzik.

Regards,
Raveendra
> -----Original Message-----
> From: Raveendra Padasalagi [mailto:raveendra.padasalagi@broadcom.com]
> Sent: 15 June 2016 15:12
> To: Herbert Xu; David S. Miller; linux-crypto@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Cc: Jon Mason; Florian Fainelli; Anup Patel; Ray Jui; Scott Branden;
Pramod
> Kumar; bcm-kernel-feedback-list@broadcom.com; Raveendra Padasalagi
> Subject: [PATCH 2/2] Crypto: Add SHA-3 Test's in tcrypt
>
> Added support for SHA-3 algorithm test's in tcrypt module and related
test
> vectors.
>
> Signed-off-by: Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>
> ---
>  crypto/tcrypt.c  |  53 ++++++++++++++++++++++-  crypto/testmgr.c |  40
> ++++++++++++++++++  crypto/testmgr.h | 125
> +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 217 insertions(+), 1 deletion(-)
>
> diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c index 579dce0..4675459
100644
> --- a/crypto/tcrypt.c
> +++ b/crypto/tcrypt.c
> @@ -72,7 +72,8 @@ static char *check[] = {
>  	"cast6", "arc4", "michael_mic", "deflate", "crc32c", "tea",
"xtea",
>  	"khazad", "wp512", "wp384", "wp256", "tnepres", "xeta",  "fcrypt",
>  	"camellia", "seed", "salsa20", "rmd128", "rmd160", "rmd256",
> "rmd320",
> -	"lzo", "cts", "zlib", NULL
> +	"lzo", "cts", "zlib", "sha3-224", "sha3-256", "sha3-384",
"sha3-512",
> +	NULL
>  };
>
>  struct tcrypt_result {
> @@ -1284,6 +1285,22 @@ static int do_test(const char *alg, u32 type, u32
> mask, int m)
>  		ret += tcrypt_test("crct10dif");
>  		break;
>
> +	case 48:
> +		ret += tcrypt_test("sha3-224");
> +		break;
> +
> +	case 49:
> +		ret += tcrypt_test("sha3-256");
> +		break;
> +
> +	case 50:
> +		ret += tcrypt_test("sha3-384");
> +		break;
> +
> +	case 51:
> +		ret += tcrypt_test("sha3-512");
> +		break;
> +
>  	case 100:
>  		ret += tcrypt_test("hmac(md5)");
>  		break;
> @@ -1691,6 +1708,22 @@ static int do_test(const char *alg, u32 type, u32
> mask, int m)
>  		test_hash_speed("poly1305", sec, poly1305_speed_template);
>  		if (mode > 300 && mode < 400) break;
>
> +	case 322:
> +		test_hash_speed("sha3-224", sec,
> generic_hash_speed_template);
> +		if (mode > 300 && mode < 400) break;
> +
> +	case 323:
> +		test_hash_speed("sha3-256", sec,
> generic_hash_speed_template);
> +		if (mode > 300 && mode < 400) break;
> +
> +	case 324:
> +		test_hash_speed("sha3-384", sec,
> generic_hash_speed_template);
> +		if (mode > 300 && mode < 400) break;
> +
> +	case 325:
> +		test_hash_speed("sha3-512", sec,
> generic_hash_speed_template);
> +		if (mode > 300 && mode < 400) break;
> +
>  	case 399:
>  		break;
>
> @@ -1770,6 +1803,24 @@ static int do_test(const char *alg, u32 type, u32
> mask, int m)
>  		test_ahash_speed("rmd320", sec,
> generic_hash_speed_template);
>  		if (mode > 400 && mode < 500) break;
>
> +	case 418:
> +		test_ahash_speed("sha3-224", sec,
> generic_hash_speed_template);
> +		if (mode > 400 && mode < 500) break;
> +
> +	case 419:
> +		test_ahash_speed("sha3-256", sec,
> generic_hash_speed_template);
> +		if (mode > 400 && mode < 500) break;
> +
> +	case 420:
> +		test_ahash_speed("sha3-384", sec,
> generic_hash_speed_template);
> +		if (mode > 400 && mode < 500) break;
> +
> +
> +	case 421:
> +		test_ahash_speed("sha3-512", sec,
> generic_hash_speed_template);
> +		if (mode > 400 && mode < 500) break;
> +
> +
>  	case 499:
>  		break;
>
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c index c727fb0..b773a56
100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -3659,6 +3659,46 @@ static const struct alg_test_desc
alg_test_descs[] = {
>  			}
>  		}
>  	}, {
> +		.alg = "sha3-224",
> +		.test = alg_test_hash,
> +		.fips_allowed = 1,
> +		.suite = {
> +			.hash = {
> +				.vecs = sha3_224_tv_template,
> +				.count = SHA3_224_TEST_VECTORS
> +			}
> +		}
> +	}, {
> +		.alg = "sha3-256",
> +		.test = alg_test_hash,
> +		.fips_allowed = 1,
> +		.suite = {
> +			.hash = {
> +				.vecs = sha3_256_tv_template,
> +				.count = SHA3_256_TEST_VECTORS
> +			}
> +		}
> +	}, {
> +		.alg = "sha3-384",
> +		.test = alg_test_hash,
> +		.fips_allowed = 1,
> +		.suite = {
> +			.hash = {
> +				.vecs = sha3_384_tv_template,
> +				.count = SHA3_384_TEST_VECTORS
> +			}
> +		}
> +	}, {
> +		.alg = "sha3-512",
> +		.test = alg_test_hash,
> +		.fips_allowed = 1,
> +		.suite = {
> +			.hash = {
> +				.vecs = sha3_512_tv_template,
> +				.count = SHA3_512_TEST_VECTORS
> +			}
> +		}
> +	}, {
>  		.alg = "sha384",
>  		.test = alg_test_hash,
>  		.fips_allowed = 1,
> diff --git a/crypto/testmgr.h b/crypto/testmgr.h index 487ec88..b70e3c9
> 100644
> --- a/crypto/testmgr.h
> +++ b/crypto/testmgr.h
> @@ -376,6 +376,131 @@ static struct hash_testvec md4_tv_template [] = {
>  	},
>  };
>
> +#define SHA3_224_TEST_VECTORS	3
> +static struct hash_testvec sha3_224_tv_template[] = {
> +	{
> +		.plaintext = "",
> +		.digest	= "\x6b\x4e\x03\x42\x36\x67\xdb\xb7"
> +				"\x3b\x6e\x15\x45\x4f\x0e\xb1\xab"
> +				"\xd4\x59\x7f\x9a\x1b\x07\x8e\x3f"
> +				"\x5b\x5a\x6b\xc7",
> +	}, {
> +		.plaintext = "a",
> +		.psize	= 1,
> +		.digest	= "\x9e\x86\xff\x69\x55\x7c\xa9\x5f"
> +				"\x40\x5f\x08\x12\x69\x68\x5b\x38"
> +				"\xe3\xa8\x19\xb3\x09\xee\x94\x2f"
> +				"\x48\x2b\x6a\x8b",
> +	}, {
> +		.plaintext = "abcdbcdecdefdefgefghfghighijhijkijkl"
> +				"jklmklmnlmnomnopnopq",
> +		.psize	= 56,
> +		.digest	= "\x8a\x24\x10\x8b\x15\x4a\xda\x21"
> +				"\xc9\xfd\x55\x74\x49\x44\x79\xba"
> +				"\x5c\x7e\x7a\xb7\x6e\xf2\x64\xea"
> +				"\xd0\xfc\xce\x33",
> +	},
> +};
> +
> +#define SHA3_256_TEST_VECTORS	3
> +static struct hash_testvec sha3_256_tv_template[] = {
> +	{
> +		.plaintext = "",
> +		.digest	= "\xa7\xff\xc6\xf8\xbf\x1e\xd7\x66"
> +				"\x51\xc1\x47\x56\xa0\x61\xd6\x62"
> +				"\xf5\x80\xff\x4d\xe4\x3b\x49\xfa"
> +				"\x82\xd8\x0a\x4b\x80\xf8\x43\x4a",
> +	}, {
> +		.plaintext = "a",
> +		.psize	= 1,
> +		.digest	= "\x80\x08\x4b\xf2\xfb\xa0\x24\x75"
> +				"\x72\x6f\xeb\x2c\xab\x2d\x82\x15"
> +				"\xea\xb1\x4b\xc6\xbd\xd8\xbf\xb2"
> +				"\xc8\x15\x12\x57\x03\x2e\xcd\x8b",
> +	}, {
> +		.plaintext = "abcdbcdecdefdefgefghfghighijhijkijkl"
> +			     "jklmklmnlmnomnopnopq",
> +		.psize	= 56,
> +		.digest	= "\x41\xc0\xdb\xa2\xa9\xd6\x24\x08"
> +				"\x49\x10\x03\x76\xa8\x23\x5e\x2c"
> +				"\x82\xe1\xb9\x99\x8a\x99\x9e\x21"
> +				"\xdb\x32\xdd\x97\x49\x6d\x33\x76",
> +	},
> +};
> +
> +
> +#define SHA3_384_TEST_VECTORS	3
> +static struct hash_testvec sha3_384_tv_template[] = {
> +	{
> +		.plaintext = "",
> +		.digest	= "\x0c\x63\xa7\x5b\x84\x5e\x4f\x7d"
> +				"\x01\x10\x7d\x85\x2e\x4c\x24\x85"
> +				"\xc5\x1a\x50\xaa\xaa\x94\xfc\x61"
> +				"\x99\x5e\x71\xbb\xee\x98\x3a\x2a"
> +				"\xc3\x71\x38\x31\x26\x4a\xdb\x47"
> +				"\xfb\x6b\xd1\xe0\x58\xd5\xf0\x04",
> +	}, {
> +		.plaintext = "a",
> +		.psize	= 1,
> +		.digest	= "\x18\x15\xf7\x74\xf3\x20\x49\x1b"
> +				"\x48\x56\x9e\xfe\xc7\x94\xd2\x49"
> +				"\xee\xb5\x9a\xae\x46\xd2\x2b\xf7"
> +				"\x7d\xaf\xe2\x5c\x5e\xdc\x28\xd7"
> +				"\xea\x44\xf9\x3e\xe1\x23\x4a\xa8"
> +				"\x8f\x61\xc9\x19\x12\xa4\xcc\xd9",
> +	}, {
> +		.plaintext = "abcdbcdecdefdefgefghfghighijhijkijkl"
> +			     "jklmklmnlmnomnopnopq",
> +		.psize	= 56,
> +		.digest	= "\x99\x1c\x66\x57\x55\xeb\x3a\x4b"
> +				"\x6b\xbd\xfb\x75\xc7\x8a\x49\x2e"
> +				"\x8c\x56\xa2\x2c\x5c\x4d\x7e\x42"
> +				"\x9b\xfd\xbc\x32\xb9\xd4\xad\x5a"
> +				"\xa0\x4a\x1f\x07\x6e\x62\xfe\xa1"
> +				"\x9e\xef\x51\xac\xd0\x65\x7c\x22",
> +	},
> +};
> +
> +
> +#define SHA3_512_TEST_VECTORS	3
> +static struct hash_testvec sha3_512_tv_template[] = {
> +	{
> +		.plaintext = "",
> +		.digest	= "\xa6\x9f\x73\xcc\xa2\x3a\x9a\xc5"
> +				"\xc8\xb5\x67\xdc\x18\x5a\x75\x6e"
> +				"\x97\xc9\x82\x16\x4f\xe2\x58\x59"
> +				"\xe0\xd1\xdc\xc1\x47\x5c\x80\xa6"
> +				"\x15\xb2\x12\x3a\xf1\xf5\xf9\x4c"
> +				"\x11\xe3\xe9\x40\x2c\x3a\xc5\x58"
> +				"\xf5\x00\x19\x9d\x95\xb6\xd3\xe3"
> +				"\x01\x75\x85\x86\x28\x1d\xcd\x26",
> +	}, {
> +		.plaintext = "a",
> +		.psize	= 1,
> +		.digest	= "\x69\x7f\x2d\x85\x61\x72\xcb\x83"
> +				"\x09\xd6\xb8\xb9\x7d\xac\x4d\xe3"
> +				"\x44\xb5\x49\xd4\xde\xe6\x1e\xdf"
> +				"\xb4\x96\x2d\x86\x98\xb7\xfa\x80"
> +				"\x3f\x4f\x93\xff\x24\x39\x35\x86"
> +				"\xe2\x8b\x5b\x95\x7a\xc3\xd1\xd3"
> +				"\x69\x42\x0c\xe5\x33\x32\x71\x2f"
> +				"\x99\x7b\xd3\x36\xd0\x9a\xb0\x2a",
> +	}, {
> +		.plaintext = "abcdbcdecdefdefgefghfghighijhijkijkl"
> +			     "jklmklmnlmnomnopnopq",
> +		.psize	= 56,
> +		.digest	= "\x04\xa3\x71\xe8\x4e\xcf\xb5\xb8"
> +				"\xb7\x7c\xb4\x86\x10\xfc\xa8\x18"
> +				"\x2d\xd4\x57\xce\x6f\x32\x6a\x0f"
> +				"\xd3\xd7\xec\x2f\x1e\x91\x63\x6d"
> +				"\xee\x69\x1f\xbe\x0c\x98\x53\x02"
> +				"\xba\x1b\x0d\x8d\xc7\x8c\x08\x63"
> +				"\x46\xb5\x33\xb4\x9c\x03\x0d\x99"
> +				"\xa2\x7d\xaf\x11\x39\xd6\xe7\x5e",
> +	},
> +};
> +
> +
>  /*
>   * MD5 test vectors from RFC1321
>   */
> --
> 1.9.1
