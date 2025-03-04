Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760BF43172
	for <linux-crypto@vger.kernel.org>; Tue,  4 Mar 2025 08:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741077937; cv=none; b=pPZe+rxlLHT4+DlFlGs/VPlu3usroz6DoIMfnQNcZ8fDd2yxOAKZlE5DO+H9ctmKOLl10BYO1Igo4CD2cRNqyodge7GCXL0YN57k3KSdeSS2LOtho5j4TR0cDf0C5Dy7mUuTyvOyz2gFTyuT44F5kpZf3s9DKt1a/PHlWvaHRag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741077937; c=relaxed/simple;
	bh=pcTYX1xIzXs/knRASRdj77drr5doZKZKKNxtztbUfng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oqQocBm3dhdaNqhPK6jnJ3nKwJFiw5zVk08fS7kLmFGBQdeBkC1pv0R8hfJbVjtNzKUSvk+MtcCM5Czn8xNEf7B9RkUxIXgDHAbDNY+SNMj48BcQPt85pmPSLP4jfxUCbsWoHpMw339MUnKrPLr9dJAw73qikaMfqeG1W9jXXPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=eUnTXeWs; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="eUnTXeWs"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2232aead377so104060535ad.0
        for <linux-crypto@vger.kernel.org>; Tue, 04 Mar 2025 00:45:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1741077936; x=1741682736; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bsZGgqt47lRT1nPeMqiwA/uQRm+FSsiQtG0lpiMHFsI=;
        b=eUnTXeWsYPSpyKgmzl3iBaBD2Z/0BQi4QwIOlg1cOlNeKI+SvL85YW5ODgEaE2Pxja
         e47uW+llUMksUPXWmV11OnPtDpFH5+jvl7vjmHDZgeMIZHNOUYTP20kcCkZ6eMgnQBUZ
         QM7MyAh2pxjmXpDlwm/K5jwcNF4LDey5etkXk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741077936; x=1741682736;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bsZGgqt47lRT1nPeMqiwA/uQRm+FSsiQtG0lpiMHFsI=;
        b=pPsQb7AI9qOabENxmmDAWZI6+ETO3nL7KhfU73O5qrSrKC9QXe2tNieznTfmcCp96+
         fa3XzpIkTvqAOVz+CLzUzmjUgW5X2pm9cw/rrxiqPPnpQMzOGPkFWxt8OfDfSgeBZgSo
         8TWNi8E7qnGpXRMAZBIndMLG+M+I7nwI4mW15IvUoo+IRLcY+IAJSy1LXA5Zlw1EgKpj
         0uYRGPfnGhiT34yB9z+swEqJcBGOGjljprkseElcWFwnedP4JNopl2HiTQf08Ftxj7QK
         za3T0nqdlBqnZXQtcUS6QoWNS8iA5aGWEyQKqozmbjlZF0yJLZckfS2xb+C+JSpx+vNJ
         Y46w==
X-Forwarded-Encrypted: i=1; AJvYcCVzyOYXcOEbio9RmGQk3z2KJab/AsjsIwqjEoyI+eAyFrVqDgHxmygzPyk7KaoS7aIeNBzazVyEi57R/Hg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPCfqdZiTGrETk55uhab/h4v6yqQbwPVHGU3lDHPekDeYbzsaJ
	C1Brsay3u5DkdWIQSex2/l9RpPD9FCPZ2KrFjuGJHUwNDgTEr2Gv9nKRQzg5Ig==
X-Gm-Gg: ASbGncvF34Z0mqaIpOYuXuSu5PaqZ2ZJboB6FsVaHbAEeXtA71N2f2Qkdmlt4fzVf1F
	guRoYYlM3q3Hn2FfZoM4d8JQzmazyAMgoSl4fSrRWlTHa162H+9mNf32VW20TPnuWTxMLWoR174
	HIVqqUrvQaxVS4rlBeZoJhJangRSuPe9NsxXehEFnieHr9xo7zkpZbQuzw2SPSN1kiqLjfD6r/X
	nWS6/crQgmIKVuQaXwwpeihFe1Z/Bn92EnsgAeHwQ/L1lwqytgFj7R5/SDSAqC0Cjcq/XWPT84z
	SKHViWEdjMXNHtL3SooYEXm0LhGUEHLVGv3ybr13ajCsE4g=
X-Google-Smtp-Source: AGHT+IFSmrDqRxmBK5WpGJqlTIrLBroRuWECs7WCPotZwXaQSZaN9UGtLmSGOwmqkDW8UbVKy+BKDA==
X-Received: by 2002:a17:902:cec7:b0:223:5c33:56b4 with SMTP id d9443c01a7336-22368f91d03mr250629105ad.20.1741077935780;
        Tue, 04 Mar 2025 00:45:35 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:767f:c723:438:d0b1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-223504c5a11sm90836815ad.150.2025.03.04.00.45.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 00:45:35 -0800 (PST)
Date: Tue, 4 Mar 2025 17:45:31 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Eric Biggers <ebiggers@kernel.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [RFC PATCH 7/7] mm: zswap: Use acomp virtual address interface
Message-ID: <o4zei74phb2tl64lawbfjqzqpirwvn4lnmdmzanhtvswfm36gj@z53kttzjaftf>
References: <Z8GH7VssQGR1ujHV@gondor.apana.org.au>
 <Z8Hcur3T82_FiONj@google.com>
 <Z8KrAk9Y52RDox2U@gondor.apana.org.au>
 <Z8KxVC1RBeh8DTKI@gondor.apana.org.au>
 <Z8YOVyGugHwAsvmO@google.com>
 <Z8ZzqOw9veZ2HGkk@gondor.apana.org.au>
 <Z8aByQ5kJZf47wzW@google.com>
 <Z8aZPcgzuaNR6N8L@gondor.apana.org.au>
 <vghra5lyaxc7zgzgqrewa5yxanziuh4d444w45ukt6dye3hhfg@ukgknqwyru35>
 <Z8a83Vjmvm81LGOf@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8a83Vjmvm81LGOf@gondor.apana.org.au>

On (25/03/04 16:42), Herbert Xu wrote:
> On Tue, Mar 04, 2025 at 05:33:05PM +0900, Sergey Senozhatsky wrote:
> >
> > And at some point you do memcpy() from SG list to a local buffer?
> > 
> > zsmalloc map() has a shortcut - for objects that fit one physical
> > page (that includes huge incompressible PAGE_SIZE-ed objects)
> > zsmalloc kmap the physical page in question and returns a pointer
> > to that mapping.
> 
> If the SG list only has a single entry, there will be no copies
> whatsoever even with the existing scomp code (crypto/scompress.c):

Nice.

[..]

> This still does an unnecessary copy for highmem, but that will
> disappear after my acomp patch-set:
> 
>                 if (sg_nents(req->src) == 1 &&
>                     (!PageHighMem(sg_page(req->src)) ||
>                      req->src->offset + slen <= PAGE_SIZE))
>                         src = kmap_local_page(sg_page(req->src)) + req->src->offset;
> 		else
> 			Use scratch buffer and do a copy
> 
> I've also modified LZO decompression to handle SG lists which I will
> post soon.  That will mean that no copies will ever occur for LZO
> decompression.  The same change could be extended to other algorithms
> if someone wishes to eliminate the copy for their favourite algorithm.

That's interesting.
