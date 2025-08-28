Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C32634;
	Thu, 28 Aug 2025 23:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756425597; cv=none; b=RXp3RAXxJz1m0hhVShgiwBDthloJ5XNOonMtJk8p0H9OESn3IrcBy7T8/pnvHOCPspZmQuYXue5Eo0FSqMGdXJSnjgVapH/9rBHkvd1mGvu0N5liY2bq7ephD4LV/s7CqVEeuhqDzjnWyXX0Te6cTFVOMnIwi47LWmkyJn06HdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756425597; c=relaxed/simple;
	bh=ziHLgutJ6Jzb9aA7gEl3JFJBYePIq6WyCFN9tsQbgmg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YWymnQLTMW9tvLKTp1YunVzolUWTpI4ydFcyqN7aT7TebK3tItwjo/PxozEBE1YCQlI5vE8MtrG7OBG96BjNHGitkSsM1V+68zZNIlXCvyvIHiIjy7zIPaRmlN5oljIQM0yJIHi8cE//5NWb1hpjzOZZPqmi1oI/p3t+3oGiPQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IoGAcm9m; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IoGAcm9m"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4b109c59dc9so18369091cf.3;
        Thu, 28 Aug 2025 16:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756425595; x=1757030395; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yItl692DyhuDS6W/wEpu2bIzdUK1IZAYDHXcH2tTSMs=;
        b=IoGAcm9mQ1SPpJGmLNgXtNikzPY9ehOdTa9lXZ4fr2BVvdgAH2TA4evPkomlO9VjW9
         6pKAd7FXxGoEOcbgvPh+TVv9FbX9nO343rSZ4N4AMoBMySfuJYsMUwaj/mzJkFvdV6hA
         gnXgZ4qLldhGvWKyQzEsHiSWhOva7YFvsmqdJn8l1rvsp7rp4xK3SxkJo+mjDWg9zQWd
         NX/Q0L+XPkhm1R3zZHLPoX4ABQ3+JlYEWn4DPQFXXj2IBhnWX9gA44C+pO5EW6pfwDaC
         mpWRy62p4aO4kL5wDfuuUutFTojUtzqE2mrN4l0d+sg+q5QOUNP3/monkl0gyDgFXglZ
         Qpkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756425595; x=1757030395;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yItl692DyhuDS6W/wEpu2bIzdUK1IZAYDHXcH2tTSMs=;
        b=cO4t7eRmE5dp3/z6C02x0vxFAoMH/hBlkxEnClT9mcKJPiNUmZjqPAq/v4I1YJ95e9
         chnPr3vPYTV1KkrXVTrv8eJNraOb5NeBWkBgxc54XzHNOEtYmYWJs7/cOnLYouQgMCTz
         Ztz2q8CndGpaiiaZo3CyBB656GIVgLL/xYa+m0jOp304hf5p3Wx7byUs7d5Rhyb70N6p
         8efVEPkCFnlEErut5gfIvoRbxt4BjBoW5RbkKDOiTxGYR94c5eOnr2OgsbfG+oRs6FzJ
         KgwChTdMTzCRqq0oaNYu0/YxVMLTJ+pujexscMLKRAm87UgRjnmVy3m2GnTG6r0JQNkg
         3j6A==
X-Forwarded-Encrypted: i=1; AJvYcCXfrCvAuVHTtoVU2zfqBp2MSlY+66Y5s4qnfBQAO6lPaQHFu+bKJD63/hgjdPBt6pkMSbrHX8yxTIHMWDY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxoC3WUaoqjqDMci3ZrhOHSmfBLV+LbrYswPdQpha8Sq5C8b4Yz
	K1AtvdhQ5qp98zhW/OXi3Ccjk7GmHtSX25KgKJ2G5aBnneu6FV5rRqP17z7FkLxbt8RJp581e1/
	ywjUte6awotIJ/voqcZ12CPDb+PnOhw4=
X-Gm-Gg: ASbGncvjEvm5GEwR2PoolKk/G49JXyiGDEVRn0XpcukQRNTANCpwCjD6FUTbtPoY8VB
	XReThy/ByAZPFEQ4DttZOo7f+BZx9nsZ8SymFRfD/NyN2Kte8ZHx3qPuyackmXxD1Rd54sbTCa9
	Equoag5h4htVkL/RMJ+Q0C7KwnMVNRlu9rCr+n1g67sNALWwUeB971k5n5xejCPmZ3Yo1vu9I0y
	ax9Bl74CM696Y9cuw==
X-Google-Smtp-Source: AGHT+IF7fCSXabW657dVKAGS/GF509K9twPmo/AHrq8NDU0U6tCuf/HScs7K1Azgv7V+H4gdMTsEESUZ6v1fcRS+ldg=
X-Received: by 2002:a05:622a:4c9:b0:4b2:a8d9:8683 with SMTP id
 d75a77b69052e-4b2aaad2aecmr307254751cf.53.1756425594653; Thu, 28 Aug 2025
 16:59:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com> <20250801043642.8103-24-kanchana.p.sridhar@intel.com>
In-Reply-To: <20250801043642.8103-24-kanchana.p.sridhar@intel.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 29 Aug 2025 11:59:43 +1200
X-Gm-Features: Ac12FXzBq7J1whHqez1tkCmNGbSGiqJOevhIX7mUkGKttCKRWOFATlZ2WVnzLG4
Message-ID: <CAGsJ_4zFXzXKVKu9M2_R1Nqqt6FBEktT1YBGAFPRgjTxv=+1_Q@mail.gmail.com>
Subject: Re: [PATCH v11 23/24] mm: zswap: zswap_store() will process a large
 folio in batches.
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	usamaarif642@gmail.com, ryan.roberts@arm.com, ying.huang@linux.alibaba.com, 
	akpm@linux-foundation.org, senozhatsky@chromium.org, 
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org, 
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com, 
	vinicius.gomes@intel.com, wajdi.k.feghali@intel.com, vinodh.gopal@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 1, 2025 at 4:36=E2=80=AFPM Kanchana P Sridhar
<kanchana.p.sridhar@intel.com> wrote:
>
> This patch modifies zswap_store() to store a batch of pages in large
> folios at a time, instead of storing one page at a time. It does this by
> calling a new procedure zswap_store_pages() with a range of
> "pool->batch_size" indices in the folio.
>
> zswap_store_pages() implements all the computes done earlier in
> zswap_store_page() for a single-page, for multiple pages in a folio,
> namely the "batch":
>
> 1) It starts by allocating all zswap entries required to store the
>    batch. New procedures, zswap_entries_cache_alloc_batch() and
>    zswap_entries_cache_free_batch() call kmem_cache_[free]alloc_bulk()
>    to optimize the performance of this step.
>
> 2) Next, the entries fields are written, computes that need to be happen
>    anyway, without modifying the zswap xarray/LRU publishing order. This
>    improves latency by avoiding having the bring the entries into the
>    cache for writing in different code blocks within this procedure.
>
> 3) Next, it calls zswap_compress() to sequentially compress each page in
>    the batch.
>
> 4) Finally, it adds the batch's zswap entries to the xarray and LRU,
>    charges zswap memory and increments zswap stats.
>
> 5) The error handling and cleanup required for all failure scenarios
>    that can occur while storing a batch in zswap are consolidated to a
>    single "store_pages_failed" label in zswap_store_pages(). Here again,
>    we optimize performance by calling kmem_cache_free_bulk().
>
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> ---
>  mm/zswap.c | 218 ++++++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 149 insertions(+), 69 deletions(-)

This seems fine overall. However, could we pull some data from the
cover letter. For example, even with hardware batching, we are still
improving performance. Since your cover letter is very long, readers
might fail to connect this data with the patches.

Thanks
Barry
