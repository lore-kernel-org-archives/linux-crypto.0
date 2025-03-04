Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162BC1DFD8B
	for <linux-crypto@vger.kernel.org>; Tue,  4 Mar 2025 08:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741077192; cv=none; b=pok7/K2TjsJ8Ayrmr1rGFcV7lo2fXN16ZLd5HG8enzq6zAdke7oGfjSN6CUPMeEyIhMDLreOTLCQkeVnvrmCeR756zsA6HQDFAUkMr94GvaynbIkPVO3WKERmU5gKwdLiM2sRqY/ayAj75JiYvjUmtvToIb9cFO4ofiuJG3cTVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741077192; c=relaxed/simple;
	bh=iztx82rpCbPGhMO0iIK0+JOf0vPtmUxI8XStpdlmN78=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S8T4YIxZ1amcO7tj4h2jtSc+/oEiGdOftBxDvR5RVwPbmBW72jR+laAUEr6MjF8KjTayw8dAD1jVpoJCo4txt2t9+NoCzKKQ3xkTRALTyyUZMCbxRGxsa6EreG/zX/jvAX9wnTUro22KlmU8vqXKbgenzqVNqPHa3l4RdFcH1VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=Ism93AXx; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Ism93AXx"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-22398e09e39so41166505ad.3
        for <linux-crypto@vger.kernel.org>; Tue, 04 Mar 2025 00:33:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1741077190; x=1741681990; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ls034JdceRJdgsKt1ncLTwTspu53450K3do6C83lCj4=;
        b=Ism93AXx545zKuqH5Fi7AcfbMOtDvI0UC9QW/Fxh4paxZQqMCM9gQrNCnfGFF+zPDC
         rF8xsrnk0yyZrNyBsqtSnuQm3KELTwM/YYsXQAggdJcOhvK3/it0Uv2OTjlLfPRsnvar
         VNvcd89+e7Da2z9QMr+QiReoSQMm6uCFrxMb4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741077190; x=1741681990;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ls034JdceRJdgsKt1ncLTwTspu53450K3do6C83lCj4=;
        b=tDX/boz515/ZNsB3iqd6iMZODoSoAHF2zO+jQw5b1ydypOBrlkmTRKRv4zgCZRSH6E
         IPiuHsBKu65YEyUhWV6zkNPvsf8cWGz4fQWEwC51ztfb5aUZ+2QkURcAPOMbqibg0ZVn
         hKRk69Eh7Jk8i3CS+bhZzQme1wbxawdT4MJMADlN2frFBhwVE1nx2EUfL+bcsMKJuQgv
         Q8HS+OJwlZ+6s9L84gbBywjCYnMUOt0WirbDxbTy92gTmbXZDnNoEFrxBm9+NVi7dvJL
         WxQpBwv9n0KjdbavpBEqoiPbalGK9dEn3S8MqSYlgx2ebd/4GAkj+fj84oyTxP5ToPEk
         67jw==
X-Forwarded-Encrypted: i=1; AJvYcCX8faz2sM/k5yUg1y2uuiGfofE6ktIRg1SocqrSKvClVzHlaE164ie/E11bUhcAFZC95HRO4Ogo3OWZxmM=@vger.kernel.org
X-Gm-Message-State: AOJu0YymzH57bnQ9JCdE/xacmXAnLzh2PkLDNpin19foUReVJ0jJIcmA
	u8hT9eNO5FQ3UcyJiOSV4lWQQDmXgVkb8GiDWixwch90tzwb7dlVhghJq9O6pw==
X-Gm-Gg: ASbGncuO198HihdhH+Mxkbz2UvgeJWD7gB/YnmDo/ZJZS4GnoqSmbelvlJT13Tf4JMc
	EswIpbidgJK7eb9MrOzzWaAtBaVJy0VLQHwL48tCtug443DfWR5IfwtgEC+wKL3EbfobBKoYu2O
	3YBF4jUkbCRiiv86xxHDsH2j6A6oesoBQj+1DS7QTh2qzl8f5+kH7BMEZIzX+EeWLaxAXBynURt
	AIivbfsDxz8fLocH7YO4WheUjDqrwDZbwXcDk53HWN3Xf7UjSGIheCMsXXeSdD2j0SrnIbUHRjA
	SlO/iYchfeLFiasu20K88dMFbMeASFxESoaGvyeSFiLnauY=
X-Google-Smtp-Source: AGHT+IFke/Kn/7by7ePS0YnlPomd4R0PuL9lngQDVZGe83c7qDsBLLX/kBoKi8H29vOpupTfsVcQpQ==
X-Received: by 2002:a17:902:c948:b0:21f:1549:a563 with SMTP id d9443c01a7336-22368fa53eemr279657475ad.2.1741077190313;
        Tue, 04 Mar 2025 00:33:10 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:767f:c723:438:d0b1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22350524b69sm89675455ad.228.2025.03.04.00.33.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 00:33:09 -0800 (PST)
Date: Tue, 4 Mar 2025 17:33:05 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Eric Biggers <ebiggers@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [RFC PATCH 7/7] mm: zswap: Use acomp virtual address interface
Message-ID: <vghra5lyaxc7zgzgqrewa5yxanziuh4d444w45ukt6dye3hhfg@ukgknqwyru35>
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
[..]
> +static void zs_map_object_sg(struct zs_pool *pool, unsigned long handle,
> +			     enum zs_mapmode mm, struct scatterlist sg[2])
> +{
> +	int handle_size = ZS_HANDLE_SIZE;
> +	struct zspage *zspage;
> +	struct zpdesc *zpdesc;
> +	unsigned long obj, off;
> +	unsigned int obj_idx;
> +
> +	struct size_class *class;
> +	struct zpdesc *zpdescs[2];
> +
> +	/* It guarantees it can get zspage from handle safely */
> +	read_lock(&pool->migrate_lock);
> +	obj = handle_to_obj(handle);
> +	obj_to_location(obj, &zpdesc, &obj_idx);
> +	zspage = get_zspage(zpdesc);
> +
> +	/*
> +	 * migration cannot move any zpages in this zspage. Here, class->lock
> +	 * is too heavy since callers would take some time until they calls
> +	 * zs_unmap_object API so delegate the locking from class to zspage
> +	 * which is smaller granularity.
> +	 */
> +	migrate_read_lock(zspage);
> +	read_unlock(&pool->migrate_lock);
> +
> +	class = zspage_class(pool, zspage);
> +	off = offset_in_page(class->size * obj_idx);
> +
> +	if (unlikely(ZsHugePage(zspage)))
> +		handle_size = 0;
> +
> +	if (off + class->size <= PAGE_SIZE) {
> +		/* this object is contained entirely within a page */
> +		sg_init_table(sg, 1);
> +		sg_set_page(sg, zpdesc_page(zpdesc), class->size - handle_size,
> +			    off + handle_size);
> +		return;
> +	}
> +
> +	/* this object spans two pages */
> +	zpdescs[0] = zpdesc;
> +	zpdescs[1] = get_next_zpdesc(zpdesc);
> +	BUG_ON(!zpdescs[1]);
> +
> +	sg_init_table(sg, 2);
> +	sg_set_page(sg, zpdesc_page(zpdescs[0]),
> +		    PAGE_SIZE - off - handle_size, off + handle_size);
> +	sg_set_page(&sg[1], zpdesc_page(zpdescs[1]),
> +		    class->size - (PAGE_SIZE - off - handle_size), 0);
> +}

[..]

>  static void zswap_decompress(struct zswap_entry *entry, struct folio *folio)
>  {
>  	struct zpool *zpool = entry->pool->zpool;
> -	struct scatterlist input, output;
>  	struct crypto_acomp_ctx *acomp_ctx;
> -	u8 *src;
> +	struct scatterlist input[2];
> +	struct scatterlist output;
>  
>  	acomp_ctx = acomp_ctx_get_cpu_lock(entry->pool);
> -	src = zpool_map_handle(zpool, entry->handle, ZPOOL_MM_RO);
> -	/*
> -	 * If zpool_map_handle is atomic, we cannot reliably utilize its mapped buffer
> -	 * to do crypto_acomp_decompress() which might sleep. In such cases, we must
> -	 * resort to copying the buffer to a temporary one.
> -	 * Meanwhile, zpool_map_handle() might return a non-linearly mapped buffer,
> -	 * such as a kmap address of high memory or even ever a vmap address.
> -	 * However, sg_init_one is only equipped to handle linearly mapped low memory.
> -	 * In such cases, we also must copy the buffer to a temporary and lowmem one.
> -	 */
> -	if ((acomp_ctx->is_sleepable && !zpool_can_sleep_mapped(zpool)) ||
> -	    !virt_addr_valid(src)) {
> -		memcpy(acomp_ctx->buffer, src, entry->length);
> -		src = acomp_ctx->buffer;
> -		zpool_unmap_handle(zpool, entry->handle);
> -	}
> -
> -	sg_init_one(&input, src, entry->length);
> +	zpool_map_sg(zpool, entry->handle, ZPOOL_MM_RO, input);
>  	sg_init_table(&output, 1);
>  	sg_set_folio(&output, folio, PAGE_SIZE, 0);
> -	acomp_request_set_params(acomp_ctx->req, &input, &output, entry->length, PAGE_SIZE);
> +	acomp_request_set_params(acomp_ctx->req, input, &output, entry->length, PAGE_SIZE);
>  	BUG_ON(crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait));
>  	BUG_ON(acomp_ctx->req->dlen != PAGE_SIZE);

And at some point you do memcpy() from SG list to a local buffer?

zsmalloc map() has a shortcut - for objects that fit one physical
page (that includes huge incompressible PAGE_SIZE-ed objects)
zsmalloc kmap the physical page in question and returns a pointer
to that mapping.
