Return-Path: <SRS0=BCrf=T5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 636F7C28CC0
	for <linux-crypto@archiver.kernel.org>; Wed, 29 May 2019 20:36:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3873B24171
	for <linux-crypto@archiver.kernel.org>; Wed, 29 May 2019 20:36:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbfE2UgG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 29 May 2019 16:36:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:49674 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726155AbfE2UgF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 May 2019 16:36:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 53D75AE08;
        Wed, 29 May 2019 20:36:04 +0000 (UTC)
Subject: Re: [PATCH v3] crypto: xxhash - Implement xxhash support
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, terrelln@fb.com, jthumshirn@suse.de
References: <20190529154826.12147-1-nborisov@suse.com>
 <20190529195512.GA141639@gmail.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 mQINBFiKBz4BEADNHZmqwhuN6EAzXj9SpPpH/nSSP8YgfwoOqwrP+JR4pIqRK0AWWeWCSwmZ
 T7g+RbfPFlmQp+EwFWOtABXlKC54zgSf+uulGwx5JAUFVUIRBmnHOYi/lUiE0yhpnb1KCA7f
 u/W+DkwGerXqhhe9TvQoGwgCKNfzFPZoM+gZrm+kWv03QLUCr210n4cwaCPJ0Nr9Z3c582xc
 bCUVbsjt7BN0CFa2BByulrx5xD9sDAYIqfLCcZetAqsTRGxM7LD0kh5WlKzOeAXj5r8DOrU2
 GdZS33uKZI/kZJZVytSmZpswDsKhnGzRN1BANGP8sC+WD4eRXajOmNh2HL4P+meO1TlM3GLl
 EQd2shHFY0qjEo7wxKZI1RyZZ5AgJnSmehrPCyuIyVY210CbMaIKHUIsTqRgY5GaNME24w7h
 TyyVCy2qAM8fLJ4Vw5bycM/u5xfWm7gyTb9V1TkZ3o1MTrEsrcqFiRrBY94Rs0oQkZvunqia
 c+NprYSaOG1Cta14o94eMH271Kka/reEwSZkC7T+o9hZ4zi2CcLcY0DXj0qdId7vUKSJjEep
 c++s8ncFekh1MPhkOgNj8pk17OAESanmDwksmzh1j12lgA5lTFPrJeRNu6/isC2zyZhTwMWs
 k3LkcTa8ZXxh0RfWAqgx/ogKPk4ZxOXQEZetkEyTFghbRH2BIwARAQABtCNOaWtvbGF5IEJv
 cmlzb3YgPG5ib3Jpc292QHN1c2UuY29tPokCOAQTAQIAIgUCWIo48QIbAwYLCQgHAwIGFQgC
 CQoLBBYCAwECHgECF4AACgkQcb6CRuU/KFc0eg/9GLD3wTQz9iZHMFbjiqTCitD7B6dTLV1C
 ddZVlC8Hm/TophPts1bWZORAmYIihHHI1EIF19+bfIr46pvfTu0yFrJDLOADMDH+Ufzsfy2v
 HSqqWV/nOSWGXzh8bgg/ncLwrIdEwBQBN9SDS6aqsglagvwFD91UCg/TshLlRxD5BOnuzfzI
 Leyx2c6YmH7Oa1R4MX9Jo79SaKwdHt2yRN3SochVtxCyafDlZsE/efp21pMiaK1HoCOZTBp5
 VzrIP85GATh18pN7YR9CuPxxN0V6IzT7IlhS4Jgj0NXh6vi1DlmKspr+FOevu4RVXqqcNTSS
 E2rycB2v6cttH21UUdu/0FtMBKh+rv8+yD49FxMYnTi1jwVzr208vDdRU2v7Ij/TxYt/v4O8
 V+jNRKy5Fevca/1xroQBICXsNoFLr10X5IjmhAhqIH8Atpz/89ItS3+HWuE4BHB6RRLM0gy8
 T7rN6ja+KegOGikp/VTwBlszhvfLhyoyjXI44Tf3oLSFM+8+qG3B7MNBHOt60CQlMkq0fGXd
 mm4xENl/SSeHsiomdveeq7cNGpHi6i6ntZK33XJLwvyf00PD7tip/GUj0Dic/ZUsoPSTF/mG
 EpuQiUZs8X2xjK/AS/l3wa4Kz2tlcOKSKpIpna7V1+CMNkNzaCOlbv7QwprAerKYywPCoOSC
 7P25Ag0EWIoHPgEQAMiUqvRBZNvPvki34O/dcTodvLSyOmK/MMBDrzN8Cnk302XfnGlW/YAQ
 csMWISKKSpStc6tmD+2Y0z9WjyRqFr3EGfH1RXSv9Z1vmfPzU42jsdZn667UxrRcVQXUgoKg
 QYx055Q2FdUeaZSaivoIBD9WtJq/66UPXRRr4H/+Y5FaUZx+gWNGmBT6a0S/GQnHb9g3nonD
 jmDKGw+YO4P6aEMxyy3k9PstaoiyBXnzQASzdOi39BgWQuZfIQjN0aW+Dm8kOAfT5i/yk59h
 VV6v3NLHBjHVw9kHli3jwvsizIX9X2W8tb1SefaVxqvqO1132AO8V9CbE1DcVT8fzICvGi42
 FoV/k0QOGwq+LmLf0t04Q0csEl+h69ZcqeBSQcIMm/Ir+NorfCr6HjrB6lW7giBkQl6hhomn
 l1mtDP6MTdbyYzEiBFcwQD4terc7S/8ELRRybWQHQp7sxQM/Lnuhs77MgY/e6c5AVWnMKd/z
 MKm4ru7A8+8gdHeydrRQSWDaVbfy3Hup0Ia76J9FaolnjB8YLUOJPdhI2vbvNCQ2ipxw3Y3c
 KhVIpGYqwdvFIiz0Fej7wnJICIrpJs/+XLQHyqcmERn3s/iWwBpeogrx2Lf8AGezqnv9woq7
 OSoWlwXDJiUdaqPEB/HmGfqoRRN20jx+OOvuaBMPAPb+aKJyle8zABEBAAGJAh8EGAECAAkF
 AliKBz4CGwwACgkQcb6CRuU/KFdacg/+M3V3Ti9JYZEiIyVhqs+yHb6NMI1R0kkAmzsGQ1jU
 zSQUz9AVMR6T7v2fIETTT/f5Oout0+Hi9cY8uLpk8CWno9V9eR/B7Ifs2pAA8lh2nW43FFwp
 IDiSuDbH6oTLmiGCB206IvSuaQCp1fed8U6yuqGFcnf0ZpJm/sILG2ECdFK9RYnMIaeqlNQm
 iZicBY2lmlYFBEaMXHoy+K7nbOuizPWdUKoKHq+tmZ3iA+qL5s6Qlm4trH28/fPpFuOmgP8P
 K+7LpYLNSl1oQUr+WlqilPAuLcCo5Vdl7M7VFLMq4xxY/dY99aZx0ZJQYFx0w/6UkbDdFLzN
 upT7NIN68lZRucImffiWyN7CjH23X3Tni8bS9ubo7OON68NbPz1YIaYaHmnVQCjDyDXkQoKC
 R82Vf9mf5slj0Vlpf+/Wpsv/TH8X32ajva37oEQTkWNMsDxyw3aPSps6MaMafcN7k60y2Wk/
 TCiLsRHFfMHFY6/lq/c0ZdOsGjgpIK0G0z6et9YU6MaPuKwNY4kBdjPNBwHreucrQVUdqRRm
 RcxmGC6ohvpqVGfhT48ZPZKZEWM+tZky0mO7bhZYxMXyVjBn4EoNTsXy1et9Y1dU3HVJ8fod
 5UqrNrzIQFbdeM0/JqSLrtlTcXKJ7cYFa9ZM2AP7UIN9n1UWxq+OPY9YMOewVfYtL8M=
Message-ID: <842f6363-8ca5-2eca-a618-90385935c820@suse.com>
Date:   Wed, 29 May 2019 23:36:02 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190529195512.GA141639@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 29.05.19 г. 22:55 ч., Eric Biggers wrote:
> Hi Nikolay, some more comments from another read through.  Sorry for not
> noticing these in v2.
> 
> On Wed, May 29, 2019 at 06:48:26PM +0300, Nikolay Borisov wrote:
>> +static int xxhash64_update(struct shash_desc *desc, const u8 *data,
>> +			 unsigned int length)
>> +{
>> +	struct xxhash64_desc_ctx *tctx = shash_desc_ctx(desc);
> 
> This variable should be named 'dctx' (for desc_ctx), not 'tctx' (for tfm_ctx).>
>> +
>> +	xxh64_update(&tctx->xxhstate, data, length);
>> +
>> +	return 0;
>> +}
> 
> xxh64_update() has a return value (0 or -errno) which is not being checked,
> which at first glance seems to be a bug.
> 
> However, it only returns an error in this case:
> 
>         if (input == NULL)
>                 return -EINVAL;
> 
> But data=NULL, length=0 are valid parameters to xxhash64_update(), so if you did
> check the return value, xxhash64_update() would break.  So it's fine as-is.
> 
> However, if anyone changed xxh64_update() to an error in any other case,
> xxhash64_update() would break since it ignores the error.
> 
> I suggest avoiding this complexity around error codes by changing xxh64_update()
> to return void.  It can be a separate patch.
> 
>> +
>> +static int xxhash64_final(struct shash_desc *desc, u8 *out)
>> +{
>> +	struct xxhash64_desc_ctx *ctx = shash_desc_ctx(desc);
>> +
> 
> For consistency it should be 'dctx' here too.
> 
>> +	put_unaligned_le64(xxh64_digest(&ctx->xxhstate), out);
>> +
>> +	return 0;
>> +}
>> +
> 
>> +static int xxhash64_finup(struct shash_desc *desc, const u8 *data,
>> +			unsigned int len, u8 *out)
>> +{
>> +	xxhash64_update(desc, data, len);
>> +	xxhash64_final(desc, out);
>> +
>> +	return 0;
>> +}
>> +
>> +static int xxhash64_digest(struct shash_desc *desc, const u8 *data,
>> +			 unsigned int length, u8 *out)
>> +{
>> +	xxhash64_init(desc);
>> +	return xxhash64_finup(desc, data, length, out);
>> +}
>> +
> 
> The purpose of the ->finup() and ->digest() methods is to allow the algorithm to
> work more efficiently than it could if ->init(), ->update(), and ->final() were
> called separately.  So, implementing them on top of xxhash64_init(),
> xxhash64_update(), and xxhash64_final() is mostly pointless.
> 
> lib/xxhash.c already provides a function xxh64() which does a digest in one
> step, so that should be used to implement xxhash64_digest():
> 
> static int xxhash64_digest(struct shash_desc *desc, const u8 *data,
> 			 unsigned int length, u8 *out)
> {
> 	struct xxhash64_tfm_ctx *tctx = crypto_shash_ctx(desc->tfm);
> 
> 	put_unaligned_le64(xxh64(data, length, tctx->seed), out);
> 
> 	return 0;
> }
> 
> I suggest just deleting xxhash64_finup().
> 
>> +static struct shash_alg alg = {
>> +	.digestsize	= XXHASH64_DIGEST_SIZE,
>> +	.setkey		= xxhash64_setkey,
>> +	.init		= xxhash64_init,
>> +	.update		= xxhash64_update,
>> +	.final		= xxhash64_final,
>> +	.finup		= xxhash64_finup,
>> +	.digest		= xxhash64_digest,
>> +	.descsize	= sizeof(struct xxhash64_desc_ctx),
>> +	.base		= {
>> +		.cra_name	 = "xxhash64",
>> +		.cra_driver_name = "xxhash64-generic",
>> +		.cra_priority	 = 100,
>> +		.cra_flags	 = CRYPTO_ALG_OPTIONAL_KEY,
>> +		.cra_blocksize	 = XXHASH64_BLOCK_SIZE,
>> +		.cra_ctxsize	 = sizeof(struct xxhash64_tfm_ctx),
>> +		.cra_module	 = THIS_MODULE,
>> +	}
>> +};
> 
> Note that because .export() and .import() aren't set, if someone calls
> crypto_shash_export() and crypto_shash_import() on an xxhash64 descriptor, the
> crypto API will export and import the state by memcpy().
> 
> That's perfectly fine, but it also means that the xxh64_copy_state() function
> won't be called.  Since it exists, one might assume that all state copies go
> through that function.  But it's actually pointless as it just does a memcpy, so
> I suggest removing it.  (As a separate patch, which you don't necessarily have
> to do now.  BTW, another thing that should be cleaned up is the random
> unnecessary local variable in xxh32_reset() and xxh64_reset()...)

Good suggestion, however they stretch beyond what I'm currently
comfortable doing. I will do a v4 which deals with the minor
inconsistencies in the crypto  module (variable naming, removing finup,
implementing digest via xxh64), however I will definitely won't be doing
any changes in lib/xxhash.c now. I don't think any of the things you
mentioned in that regard are a blockers towards merging crypto layer
support for xxhash.

> 
> Thanks,
> 
> - Eric
> 
