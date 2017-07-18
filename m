From: Gary R Hook <gary.hook@amd.com>
Subject: Re: [PATCH] crypto: ccp - Fix XTS-AES support on a version 5 CCP
Date: Tue, 18 Jul 2017 12:39:34 -0500
Message-ID: <b188dac1-7617-b31f-190f-5616a19b7f16@amd.com>
References: <150032210775.102848.1585950131204303137.stgit@sosxen.amd.com>
 <8290106.IDex3JMMbd@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
To: =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2nam02on0063.outbound.protection.outlook.com ([104.47.38.63]:19632
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751379AbdGRRkW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jul 2017 13:40:22 -0400
In-Reply-To: <8290106.IDex3JMMbd@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 07/18/2017 01:28 AM, Stephan Müller wrote:
> Am Montag, 17. Juli 2017, 22:08:27 CEST schrieb Gary R Hook:
>
> Hi Gary,
>
>> Version 5 CCPs have differing requirements for XTS-AES: key components
>> are stored in a 512-bit vector. The context must be little-endian
>> justified. AES-256 is supported now, so propagate the cipher size to
>> the command descriptor.
>>
>> Signed-off-by: Gary R Hook <gary.hook@amd.com>
>> ---
>>  drivers/crypto/ccp/ccp-crypto-aes-xts.c |   79

...<snip>...

>> @@ -97,14 +77,20 @@ static int ccp_aes_xts_setkey(struct crypto_ablkcipher
>> *tfm, const u8 *key, unsigned int key_len)
>>  {
>>        struct ccp_ctx *ctx = crypto_tfm_ctx(crypto_ablkcipher_tfm(tfm));
>> +     unsigned int ccpversion = ccp_version();
>>
>>        /* Only support 128-bit AES key with a 128-bit Tweak key,
>>         * otherwise use the fallback
>>         */
>> +
>
> Can you please add xts_check_key here?

Certainly!
