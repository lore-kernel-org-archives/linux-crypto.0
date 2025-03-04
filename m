Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BAFF204090
	for <linux-crypto@vger.kernel.org>; Tue,  4 Mar 2025 13:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741094398; cv=none; b=QhOzqnyH8jzuAX2OOzQFUezXXmo3CcBcf95JR3HZXy2aXArAUNY+Rk+9g/j0QALwh5USEqRyhMbUmbMqcdAtyr3tqbm+fjHQfK2I6rtumh0wjIyD8cjZk/cORMNIe3NiOWhFblugzQEMh8rZdkdtwEz62E33gkNfnVWNAWb7u2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741094398; c=relaxed/simple;
	bh=ZGeOaFCjghGKhSbj+J2WgJx/KZ8phyOqoRDsnlPA9GI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AI7loWCDwIqcJ4jSwkmQqDtaBP4L0lL9D7WBp4TxQjDbpd6GnalwWtrk2uAUXQyK4QCFBJZCRIpR4mWwZkJk0H6o4SBq5FSBBgkwwfd8GzOa6NXcuw4QniP0wO2FjIJECE1Di5KqEiD9RGn+0mQQy1+IYwPj6B1oLqJE0pl7Cq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=PrT4UVf3; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="PrT4UVf3"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-22337bc9ac3so105125295ad.1
        for <linux-crypto@vger.kernel.org>; Tue, 04 Mar 2025 05:19:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1741094397; x=1741699197; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rsYEnEDGDEiInTO3ukZFQ+GokK6aXOyrP3pTeF30GtI=;
        b=PrT4UVf3W1cNFguXLXWv5IVrh91sDzeyZxq0AsJCOPM1OSP/cHmhgVgX9GspQgrlzB
         k9qWuZ55TFMQz2K7EX7bgVJIIyK7oO7lc/12cp/ZPUrd+gXVeKK54CUQy6HwkFds94bk
         nI35Tus/dd3BeJ0TsxOD9fyuogZUbrZ86BvBs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741094397; x=1741699197;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rsYEnEDGDEiInTO3ukZFQ+GokK6aXOyrP3pTeF30GtI=;
        b=EGGVXbcITsPfC5aXHnivt041hdW6NLPU1/UMvrPbxyDg69ErQEpgiOo+tQHzuJcvPJ
         feTXGc2p6dgv7QDRtGErgxFuY5skuYgiCnF7oXMuB7PMlygiqvSx37SA7zLWTF0Zn9aN
         ddWTGRvaoyRmMYykuwNRC3j4UGv0NEoS/nY6jq1PdAJK1EdKIVqIg5bBhkHtYYIMyYbA
         Y0lLVqGhOQaawWA1l7P6kXy+zqlC+SU9PLwTzysuUwtbbbJY0ER4FlB1egtwo/XrYQPU
         Ds7kA1gDzAY6cqVSwI1UFJ6qPqi/7T8BZwhDVlaDAslmk1mjwXGQLpIL49Wb7/ZJtysN
         mdeA==
X-Forwarded-Encrypted: i=1; AJvYcCXOSEjbLajF8WWQc0zd+kxdtqtRF/A+RHQ4WclZSbk23cnESTY/vJWZX73gwI1adjXP7HOgsgMqgcabWio=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjWraaf7kudyUs+fd00anAfU+SAChmSO8sAKuCvmdPS8lpGMQ6
	KLkfvo9W2udCJ0TkvG/vT6FvGYE57ctxhepYagPq1IKlzQdUF1UG7t4a7A75DA==
X-Gm-Gg: ASbGncuBoYo9yT7bIIXq7fAN+++CmxhqC0GwUkfIdYOasc1Q6vAkIk8iiXx0YxvVNLG
	jePKdanKy8FgNR0FwQa6u5o7go1IZNkkcWXSZlKFXilCXvOitPzq3wwZYkjjLVC9sm+Ss1eR13k
	BZB6ZGB6PVdD6TOOSrfckZGYUTkPYUPNOU/nJsf0W5Yct6OqSjLWyIk/YeCxj/+0nUIWqnB9dEA
	DpkfMYSu7e69jA/+0avZ6EuFB36epmMml5VXgCtfMk+3rUB4ni3nCRP8kB7p6oXKmNwYvK9snTm
	LT2b08owERZ4Q4htGGqH4Lp1fJheNI7qimdQzRDoXMoszz4=
X-Google-Smtp-Source: AGHT+IEy5sLNS43nRq/vyH8BFlfow9g+v3waSagmkGS1xuRNy2LAI7XEalnQgGvFm9vagu9SGl7pfQ==
X-Received: by 2002:a05:6a00:b96:b0:736:4644:86e6 with SMTP id d2e1a72fcca58-7364644887dmr15703591b3a.12.1741094396590;
        Tue, 04 Mar 2025 05:19:56 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:767f:c723:438:d0b1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73519c31931sm8458429b3a.20.2025.03.04.05.19.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 05:19:56 -0800 (PST)
Date: Tue, 4 Mar 2025 22:19:51 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Eric Biggers <ebiggers@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [RFC PATCH 7/7] mm: zswap: Use acomp virtual address interface
Message-ID: <dawjvaf3nbfd6hnaclhcih6sfjzeuusu6kwhklv3bpptwwjzsd@t4ln7cwu74lh>
References: <Z8DcmK4eECXp3aws@google.com>
 <Z8FwFJ4iMLuvo3Jj@gondor.apana.org.au>
 <Z8GH7VssQGR1ujHV@gondor.apana.org.au>
 <Z8Hcur3T82_FiONj@google.com>
 <Z8KrAk9Y52RDox2U@gondor.apana.org.au>
 <Z8KxVC1RBeh8DTKI@gondor.apana.org.au>
 <Z8YOVyGugHwAsvmO@google.com>
 <Z8ZzqOw9veZ2HGkk@gondor.apana.org.au>
 <Z8aByQ5kJZf47wzW@google.com>
 <Z8aZPcgzuaNR6N8L@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8aZPcgzuaNR6N8L@gondor.apana.org.au>

On (25/03/04 14:10), Herbert Xu wrote:
> +static void zs_map_object_sg(struct zs_pool *pool, unsigned long handle,
> +			     enum zs_mapmode mm, struct scatterlist sg[2])
> +{
[..]
> +	sg_init_table(sg, 2);
> +	sg_set_page(sg, zpdesc_page(zpdescs[0]),
> +		    PAGE_SIZE - off - handle_size, off + handle_size);
> +	sg_set_page(&sg[1], zpdesc_page(zpdescs[1]),
> +		    class->size - (PAGE_SIZE - off - handle_size), 0);
> +}
> +
> +static void zs_unmap_object_sg(struct zs_pool *pool, unsigned long handle)
> +{
> +	struct zspage *zspage;
> +	struct zpdesc *zpdesc;
> +	unsigned int obj_idx;
> +	unsigned long obj;
> +
> +	obj = handle_to_obj(handle);
> +	obj_to_location(obj, &zpdesc, &obj_idx);
> +	zspage = get_zspage(zpdesc);
> +	migrate_read_unlock(zspage);
> +}

One thing to notice is that these functions don't actually map/unmap.

And the handling is spread out over different parts of the stack,
sg list is set in zsmalloc, but the actual zsmalloc map local page is
done in crypto, and then zswap does memcpy() to write to object and so
on.  The "new" zsmalloc map API, which we plan on landing soon, handles
most of the things within zsmalloc.  Would it be possible to do something
similar with the sg API?

> @@ -928,9 +929,9 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
>  	struct scatterlist input, output;
>  	int comp_ret = 0, alloc_ret = 0;
>  	unsigned int dlen = PAGE_SIZE;
> +	struct scatterlist sg[2];
>  	unsigned long handle;
>  	struct zpool *zpool;
> -	char *buf;
>  	gfp_t gfp;
>  	u8 *dst;
>  
> @@ -972,9 +973,9 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
>  	if (alloc_ret)
>  		goto unlock;
>  
> -	buf = zpool_map_handle(zpool, handle, ZPOOL_MM_WO);
> -	memcpy(buf, dst, dlen);
> -	zpool_unmap_handle(zpool, handle);
> +	zpool_map_sg(zpool, handle, ZPOOL_MM_WO, sg);
> +	memcpy_to_sglist(sg, 0, dst, dlen);
> +	zpool_unmap_sg(zpool, handle);

You can give zsmalloc a handle and a compressed buffer (u8) and
zsmalloc should be able to figure it out.  WO direction map()
seems, a bit, like an extra step.
