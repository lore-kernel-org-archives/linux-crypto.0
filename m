From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v2] dm: switch dm-verity to async hash crypto API
Date: Fri, 17 Feb 2017 14:00:18 +0100
Message-ID: <74bc1a00-6fb4-4b2f-b57b-a7fea0969eeb@gmail.com>
References: <1486389482-26992-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org, gilad.benyossef@arm.com,
        ofir.drang@arm.com, Eric Biggers <ebiggers3@gmail.com>,
        =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?=
        <omosnacek+linux-crypto@gmail.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>, dm-devel@redhat.com,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36381 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933787AbdBQNAV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Feb 2017 08:00:21 -0500
Received: by mail-wm0-f66.google.com with SMTP id r18so2459708wmd.3
        for <linux-crypto@vger.kernel.org>; Fri, 17 Feb 2017 05:00:21 -0800 (PST)
In-Reply-To: <1486389482-26992-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 02/06/2017 02:58 PM, Gilad Ben-Yossef wrote:
> Use of the synchronous digest API limits dm-verity to using pure
> CPU based algorithm providers and rules out the use of off CPU
> algorithm providers which are normally asynchronous by nature,
> potentially freeing CPU cycles.
> 
> This can reduce performance per Watt in situations such as during
> boot time when a lot of concurrent file accesses are made to the
> protected volume.
> 
> Move DM_VERITY to the asynchronous hash API.

Did you test that async hash completion path?

I just tried to force async crypto by replacing "sha256"
in mapping table with "cryptd(sha256-generic)" and it kills
kernel immediately.
https://mbroz.fedorapeople.org/tmp/verity-fail.png

(I hope this trick should cause to use cryptd and use async processing.
In previous version the parameter is properly rejected, because unsupported
by shash api.)


Some more comments below.
...

> -static int verity_hash_update(struct dm_verity *v, struct shash_desc *desc,
> -			      const u8 *data, size_t len)
> +static int verity_hash_update(struct dm_verity *v, struct ahash_request *req,
> +				const u8 *data, size_t len,
> +				struct verity_result *res)
>  {
> -	int r = crypto_shash_update(desc, data, len);
> +	struct scatterlist sg;
>  
> -	if (unlikely(r < 0))
> -		DMERR("crypto_shash_update failed: %d", r);
> +	sg_init_table(&sg, 1);
> +	sg_set_buf(&sg, data, len);

why not use sg_init_one?

> +	ahash_request_set_crypt(req, &sg, NULL, len);
> +
> +	return verity_complete_op(res, crypto_ahash_update(req));
> +}

...

> -int verity_hash(struct dm_verity *v, struct shash_desc *desc,
> +int verity_hash(struct dm_verity *v, struct ahash_request *req,
>  		const u8 *data, size_t len, u8 *digest)
>  {
>  	int r;
> +	struct verity_result res;
>  
> -	r = verity_hash_init(v, desc);
> +	r = verity_hash_init(v, req, &res);
>  	if (unlikely(r < 0))
> -		return r;
> +		goto out;

why it is changed to goto? it doesn't simplify anything in this function

>  
> -	r = verity_hash_update(v, desc, data, len);
> +	r = verity_hash_update(v, req, data, len, &res);
>  	if (unlikely(r < 0))
> -		return r;
> +		goto out;
> +
> +	r = verity_hash_final(v, req, digest, &res);
>  
> -	return verity_hash_final(v, desc, digest);
> +out:
> +	return r;
>  }


Milan
