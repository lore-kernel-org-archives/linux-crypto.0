From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v2 6/9] staging: ccree: add FIPS support
Date: Thu, 20 Apr 2017 15:39:48 +0200
Message-ID: <6020947.G2hzgUSCE3@positron.chronox.de>
References: <1492693983-8175-1-git-send-email-gilad@benyossef.com> <1492693983-8175-7-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        gilad.benyossef@arm.com, Binoy Jayan <binoy.jayan@linaro.org>,
        Ofir Drang <ofir.drang@arm.com>,
        Stuart Yoder <stuart.yoder@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1492693983-8175-7-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Donnerstag, 20. April 2017, 15:13:00 CEST schrieb Gilad Ben-Yossef:

Hi Gilad,

> +/* The function verifies that tdes keys are not weak.*/
> +static int ssi_fips_verify_3des_keys(const u8 *key, unsigned int keylen)
> +{
> +#ifdef CCREE_FIPS_SUPPORT
> +        tdes_keys_t *tdes_key = (tdes_keys_t*)key;
> +
> +	/* verify key1 != key2 and key3 != key2*/

I do not think that this check is necessary. There is no FIPS requirement or 
IG that mandates this (unlike the XTS key check).

If there would be such requirement, we would need a common service function 
for all TDES implementations

> +        if (unlikely( (memcmp((u8*)tdes_key->key1, (u8*)tdes_key->key2,
> sizeof(tdes_key->key1)) == 0) || +		      (memcmp((u8*)tdes_key->key3,
> (u8*)tdes_key->key2, sizeof(tdes_key->key3)) == 0) )) { +               
> return -ENOEXEC;
> +        }
> +#endif /* CCREE_FIPS_SUPPORT */
> +
> +        return 0;
> +}
> +
> +/* The function verifies that xts keys are not weak.*/
> +static int ssi_fips_verify_xts_keys(const u8 *key, unsigned int keylen)
> +{
> +#ifdef CCREE_FIPS_SUPPORT
> +        /* Weak key is define as key that its first half (128/256 lsb)
> equals its second half (128/256 msb) */ +        int singleKeySize = keylen
> >> 1;
> +
> +	if (unlikely(memcmp(key, &key[singleKeySize], singleKeySize) == 0)) {
> +		return -ENOEXEC;

Use xts_check_key.

> +The test vectors were taken from:
> +
> +* AES
> +NIST Special Publication 800-38A 2001 Edition
> +Recommendation for Block Cipher Modes of Operation
> +http://csrc.nist.gov/publications/nistpubs/800-38a/sp800-38a.pdf
> +Appendix F: Example Vectors for Modes of Operation of the AES
> +
> +* AES CTS
> +Advanced Encryption Standard (AES) Encryption for Kerberos 5
> +February 2005
> +https://tools.ietf.org/html/rfc3962#appendix-B
> +B.  Sample Test Vectors
> +
> +* AES XTS
> +http://csrc.nist.gov/groups/STM/cavp/#08
> +http://csrc.nist.gov/groups/STM/cavp/documents/aes/XTSTestVectors.zip
> +
> +* AES CMAC
> +http://csrc.nist.gov/groups/STM/cavp/index.html#07
> +http://csrc.nist.gov/groups/STM/cavp/documents/mac/cmactestvectors.zip
> +
> +* AES-CCM
> +http://csrc.nist.gov/groups/STM/cavp/#07
> +http://csrc.nist.gov/groups/STM/cavp/documents/mac/ccmtestvectors.zip
> +
> +* AES-GCM
> +http://csrc.nist.gov/groups/STM/cavp/documents/mac/gcmtestvectors.zip
> +
> +* Triple-DES
> +NIST Special Publication 800-67 January 2012
> +Recommendation for the Triple Data Encryption Algorithm (TDEA) Block Cipher
> +http://csrc.nist.gov/publications/nistpubs/800-67-Rev1/SP-800-67-Rev1.pdf
> +APPENDIX B: EXAMPLE OF TDEA FORWARD AND INVERSE CIPHER OPERATIONS +and
> +http://csrc.nist.gov/groups/STM/cavp/#01
> +http://csrc.nist.gov/groups/STM/cavp/documents/des/tdesmct_intermediate.zip
> +
> +* HASH
> +http://csrc.nist.gov/groups/STM/cavp/#03
> +http://csrc.nist.gov/groups/STM/cavp/documents/shs/shabytetestvectors.zip
> +
> +* HMAC
> +http://csrc.nist.gov/groups/STM/cavp/#07
> +http://csrc.nist.gov/groups/STM/cavp/documents/mac/hmactestvectors.zip
> +
> +*/

Is this test vector business really needed? Why do you think that testmgr.c is 
not sufficient? Other successful FIPS validations of the kernel crypto API 
managed without such special code.

Also, your entire API seems to implement the approach that if there is a self 
test error, you disable the cipher functions, but leave the rest in-tact. The 
standard kernel crypto API handling logic is to simply panic the kernel. Is it 
really necessary to implement a special case for your driver?


Ciao
Stephan
