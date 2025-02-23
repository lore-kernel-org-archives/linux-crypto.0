Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74BA9CA4E
	for <linux-crypto@vger.kernel.org>; Sun, 23 Feb 2025 02:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740276583; cv=none; b=HSi7t/o2gxz6CRButjUqxUPWqGyJ3wEmc+bUCQhxRfmTqa/KSyyALdjqxtZHPwyojKqztSW6CrVYGJACpGrK1tijQjcBsbXU5lxpxaPZkaJ1UqC/oCA+qkufrwRUX2mDzcD+FRH1Krld9UWKmLqb2zRNvG8ZE5+vjApo2kqnh0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740276583; c=relaxed/simple;
	bh=NuIBx3upqL9KNIxLQxy3GzF6zwII0EOXk8q7zJM9u9E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ivtnj7Ffbhvr+6Ld970urtaPR0iatRD9AqK45wOCj1NiQLLJ/TdNsetxIoT/ANGtz1U/DL/LZ4meIfw0LnoZvR3M1KrlO+pTC1gM4CAZ2h1Oweuz1RCLc+4/fRlz7qJoJ2fCBNJPudarwR87Crs53A/wnNP9vAqsCTuuRRVTsPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=E6lbOk/q; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="E6lbOk/q"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-220dc3831e3so68332855ad.0
        for <linux-crypto@vger.kernel.org>; Sat, 22 Feb 2025 18:09:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1740276582; x=1740881382; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iKUNTxI3ScxWIEmge1ue/3A/mxxEuL0ykQJBIUwpXck=;
        b=E6lbOk/qq33aBS3c39xZxUvVwJ/65j04nZa7Zia66YFKx+cUS8Sxf17rzzzaIzrxpf
         NWktcdxEu3h9Iry3gvyQhn9aQ5WPB8xrw6cU14cfDYZ5lQtOxesYJJB1nmjB5QSNA/Lj
         DGzdpM7M1gKr8m+j0YVZjOrcFUjlrUwscGdFg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740276582; x=1740881382;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iKUNTxI3ScxWIEmge1ue/3A/mxxEuL0ykQJBIUwpXck=;
        b=EeArpSH5VfMBJm/+PUdc4KDF0QZ7R6zKptusbliBFfb0GiDisixW5MHjgY/3eg1ZUG
         qeCaJsdKBxPfbJ07f2BXLA3/+UAjz0QHpEPnW3Gu479CSUZM1kxawZLGskdoLnhjf6GY
         V0NLrP8Di8Ur+u++HKSGYiwvVbRP3Wpj5NRE3UsjL+Kb6ea37ErI+7wVDSLrhrvjXqnv
         +2VU+Eltn99aOuItyXWBSLUH6xYyh85Uh2Dk5ZRfDekbjf0wprQ/SmovjKpTcXU+oVXx
         4ezpfGXbjR3QjJOGr4/BYiRNksASLw3Ve69pdzE37526DP6pI0zFX0eS3znfFMIFlrve
         rh3Q==
X-Forwarded-Encrypted: i=1; AJvYcCWXjrnLAYV4WIryxRUOenzX8A3n7piULPEiSoJUyctr1KmP7KMcbxDwo5punu12zoOv2uNxSxw8fqGZFC0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+68HVrpbT6/Ez/8ivoO5gU/1PAKgqFsZ5nR/fLIvkzhC+KLph
	mX5rEGX2rwAE8u5rMGt26/dsegVpvaCDS+X+l3ivh7LvmPIrnPnlSB7euEdLsw==
X-Gm-Gg: ASbGnctssPgGY0x670W+6k/ikBdjeQr24ZvjeHH1BBNrkKgr455pTFmCcTVVSZa2K1C
	cyOCKHDEBJc8zbU6d7ZphX4kgQE1dLT6WFA2oU3wk7zDttse2iAdsbuoqls5pgZkvSLbKZp7ano
	HCqbxufe9LCOPl2D9OeCOc4f03wbZAVMgeY5etdIIhFdcGgsupdRUbmyBKcV8L0f79X5rrGnpKA
	O/sb5gQWswp6mk9uADKMGCNg1pnOr0RUitQmx68EmwlJZLMQ9zLYqJ0Op3bObEnNixnh2w0aU8b
	aswiNLvY+1BHIp5D6ktHrxk354Nh
X-Google-Smtp-Source: AGHT+IGyOWS8SdxcnCpNXmpsnOdPgyaUof7mfUQNC5miFn8aT5EBDEvVNb2Ow5PqSGIOE2oJnFkx1w==
X-Received: by 2002:a05:6a00:991:b0:732:6276:b46c with SMTP id d2e1a72fcca58-73425a1fab8mr14109564b3a.0.1740276581776;
        Sat, 22 Feb 2025 18:09:41 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:badf:54f:bbc8:4593])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-732575e055dsm16497804b3a.68.2025.02.22.18.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Feb 2025 18:09:41 -0800 (PST)
Date: Sun, 23 Feb 2025 11:09:32 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Barry Song <21cnbao@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Minchan Kim <minchan@kernel.org>, "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "nphamcs@gmail.com" <nphamcs@gmail.com>, 
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, "usamaarif642@gmail.com" <usamaarif642@gmail.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>, 
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>, 
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com" <surenb@google.com>, 
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>, "Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, 
	"Gopal, Vinodh" <vinodh.gopal@intel.com>
Subject: Re: [PATCH v5 02/12] crypto: acomp - Define new interfaces for
 compress/decompress batching.
Message-ID: <u7t7gibspxu3lujdl4hambr72qd6o5u33udbojihngznlyistk@gmyyhwjuiwxc>
References: <SJ0PR11MB5678034533E3FAD7B16E2758C9112@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <CAJD7tkbRHkb7Znzto6=RRDQA9zXZSva43GukhBEfjrgm1qOxHw@mail.gmail.com>
 <Z3yMNI_DbkKBKJxO@gondor.apana.org.au>
 <CAJD7tkaTuNWF42+CoCLruPZks3F7H9mS=6S74cmXnyWz-2tuPw@mail.gmail.com>
 <Z7F1B_blIbByYBzz@gondor.apana.org.au>
 <Z7dnPh4tPxLO1UEo@google.com>
 <CAGsJ_4yVFG-C=nJWp8xda3eLZENc4dpU-d4VyFswOitiXe+G_Q@mail.gmail.com>
 <dhj6msbvbyoz7iwrjnjkvoljvkh2pgxrwzqf67gdinverixvr5@e3ld7oeketgw>
 <lu3j2kr3m2b53ze2covbywh6a7vvrscbkoplwnq4ov24g2cfso@572bdcsobd4a>
 <Z7poTnlv-1DStRZQ@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z7poTnlv-1DStRZQ@gondor.apana.org.au>

On (25/02/23 08:14), Herbert Xu wrote:
> On Sat, Feb 22, 2025 at 11:27:49PM +0900, Sergey Senozhatsky wrote:
> >
> > So I didn't look at all of them, but at least S/W lzo1 doesn't even
> > have a notion of max-output-len.  lzo1x_1_compress() accepts a pointer
> > to out_len which tells the size of output stream (the algorithm is free
> > to produce any), so there is no dst_buf overflow as far as lzo1 is
> > concerned.  Unless I'm missing something or misunderstanding your points.
> 
> I just looked at deflate/zstd and they seem to be doing the right
> things.
> 
> But yes lzo is a gaping security hole on the compression side.

Right, for lzo/lzo-rle we need a safety page.

It also seems that there is no common way of reporting dst_but overflow.
Some algos return -ENOSPC immediately, some don't return anything at all,
and deflate does it's own thing - there are these places where they see
they are out of out space but they Z_OK it

if (s->pending != 0) {
	flush_pending(strm);
	if (strm->avail_out == 0) {
		/* Since avail_out is 0, deflate will be called again with
		 * more output space, but possibly with both pending and
		 * avail_in equal to zero. There won't be anything to do,
		 * but this is not an error situation so make sure we
		 * return OK instead of BUF_ERROR at next call of deflate:
		 */
		s->last_flush = -1;
		return Z_OK;
	}
}
