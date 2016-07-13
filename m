From: Will Thomas <will.thomas@imgtec.com>
Subject: Re: [PATCH 5/6] crypto: img-hash - Add support for export and import
Date: Wed, 13 Jul 2016 15:01:38 +0100
Message-ID: <578649C2.801@imgtec.com>
References: <20160712074929.GA29737@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <james.hartley@imgtec.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:29369 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbcGMOBq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 Jul 2016 10:01:46 -0400
In-Reply-To: <20160712074929.GA29737@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

I don't see any other drivers explicitly requesting a fallback
driver by name. Anyways, should this be done using  "sha1-generic"
in the crypto_alloc_ahash call when setting up the fallback tfm?

Thanks,
Will

On 12/07/16 08:49, Herbert Xu wrote:
> Will Thomas <will.thomas@imgtec.com> wrote:
>>
>> @@ -714,9 +740,12 @@ static struct ahash_alg img_algs[] = {
>>                .update = img_hash_update,
>>                .final = img_hash_final,
>>                .finup = img_hash_finup,
>> +               .export = img_hash_export,
>> +               .import = img_hash_import,
>>                .digest = img_hash_digest,
>>                .halg = {
>>                        .digestsize = MD5_DIGEST_SIZE,
>> +                       .statesize = sizeof(struct md5_state),
> 
> This is wrong.  The fallback state size is not guaranteed to be
> the same as the generic MD5.  I suppose the easiest fix is to
> explicitly request for md5-generic/sha1-generic/etc. when you
> allocate the fallback.
> 
> Thanks,
> 
