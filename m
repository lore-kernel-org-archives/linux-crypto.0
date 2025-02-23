Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD3F28F4
	for <linux-crypto@vger.kernel.org>; Sun, 23 Feb 2025 03:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740280380; cv=none; b=E9JcxqesrdZPLmpuOmIo0M83wMeUDHvrsbM9c2w2m8tuNtl5TnVdabdNUY8wZ4aiQznhk3RcnFucpLhA4lDbwLvModLymqhCenO4Ls9QK2pp5ygFQfyJZuvvz55A0Ivj32jksEHKnzBx0MjAN7onrY6lfzdWCUwWtc8YifXudPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740280380; c=relaxed/simple;
	bh=qZgYp4hiy5AbktBK/6uq9C27b6p0D2oN047rwlhl410=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BEZoT5IMWKPBnvelngD09JtSffVn2bpqtZdwMnhzig5mmx6YDziLylG/jY3VUG2yp1bRf5rhTyaashOMg08l0hwl3GEVXvYCFTPQV7wIb7FmcYkJlCiLfPObkwZrtA4SkPQQv3tBQ4krq5VN5LMRGXu4NjHZBrKF0RZaUQR3ZSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=CclgYAEj; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="CclgYAEj"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2fbffe0254fso6889149a91.3
        for <linux-crypto@vger.kernel.org>; Sat, 22 Feb 2025 19:12:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1740280378; x=1740885178; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q4hSWwxP6ZiCusbLhbTnvl7H4ZNzc7v3lXbdR+X+u7U=;
        b=CclgYAEj78dxqtoUE6kb5fSQYk+1E0Y8qRa4gd4Yc37X4mwHWRlwQHyqI4pycK1MzL
         jF18x5kAKy4gwQstTnvebA+q9T8CCh/PO+lxHWncVO23P2jwD+20OarKhmYL69Ijfwg8
         GDWudYEgnhtAHRtdxz82z7dPHkT5g3aAhMh+c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740280378; x=1740885178;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q4hSWwxP6ZiCusbLhbTnvl7H4ZNzc7v3lXbdR+X+u7U=;
        b=NkmcAaG6Y/dY4sn2FIqpYll/89Z1BeNkQKlw/KDLVOBdcG+zT45DyB6FomyVgR9cty
         l0NRA3NFiH4ef4xiFESj6mK9vvDCtL4HbYfagGZhitWOXItU7d7CIjX6/teviWhzaOl1
         A9BKWp+9qTZDfe8CVCe38F7E1t3hFANnKnoPy0QfyEcQDUZc7G9SIr8C9d76uhIfCSHK
         XR+noxAc6wqheRfZmDmZXlTSmFU+18Gfz92fPdzqWhS+ueWCkMP1TPUquSCCgn5/PWff
         TRDLRgODF1m3264IqzZ7rClrZd7r/jbe/E1fO2nEER/sA9Qe9m/Ka3N9/wC+dontOW3Y
         CvUA==
X-Forwarded-Encrypted: i=1; AJvYcCUja/GfuvcIqg1YfJ2+VY4Xpd+BvH1ZuJlitAL3EX1L5LrMy1i73bO69yV1JrTVfurdYBE/YDSS0ZfrbP0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7mpm4o03+MaZ7fLyYoEnemVTaEmlXnLj3g8aT6bhteXB9+eUM
	L1p9dJ7J/24Eg/5VfVy+LF4FV7xKUcVYgpxluta2/0TqDvHgk2aCUtmFzxDU1w==
X-Gm-Gg: ASbGnctU2BgP6brsWiFMVWwDS6vum9oKRSlLar9R1eFIXP97OAiPBU2+AKPG2eZ4CWG
	GvIlEOnqdpwGpLuRRo5dFWM4noAvfaNMh3mexilLNQBECsWhF2+fHnsMKcxNX+8z6zf8ReWzJ3e
	5auBO8Rf7gm47mFOQ/XEgtcKoA//0gEFDh56B018n+nW4DLL4zOZUfoqAfN67V9jZbw88LodAKG
	0QbCmKUh35DGN6TBizt+wZS8TjzvcOplFjc9NnjSXNnTuCSKbeYMuiTZLq3r4fFHd/7yhbgXiZg
	ZXdAVKfwwe2eRfAxu6UlCaucluFX
X-Google-Smtp-Source: AGHT+IFtN36KhbjavF+Sg24ptpizXiER9hpFjSJioRr2SlZ1w260b/Y5kfU5U1Qhbzz/n+DC0vw00w==
X-Received: by 2002:a17:90a:da87:b0:2fa:1e3e:9be0 with SMTP id 98e67ed59e1d1-2fce78c9247mr13494362a91.19.1740280376731;
        Sat, 22 Feb 2025 19:12:56 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:badf:54f:bbc8:4593])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fceb0786e9sm3838542a91.33.2025.02.22.19.12.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Feb 2025 19:12:56 -0800 (PST)
Date: Sun, 23 Feb 2025 12:12:47 +0900
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
Message-ID: <cxspxz5jeiigd34cl7x3asyx4lowefjpffj3ip4mwpxdwh34e6@xzpqbmlihbcg>
References: <Z3yMNI_DbkKBKJxO@gondor.apana.org.au>
 <CAJD7tkaTuNWF42+CoCLruPZks3F7H9mS=6S74cmXnyWz-2tuPw@mail.gmail.com>
 <Z7F1B_blIbByYBzz@gondor.apana.org.au>
 <Z7dnPh4tPxLO1UEo@google.com>
 <CAGsJ_4yVFG-C=nJWp8xda3eLZENc4dpU-d4VyFswOitiXe+G_Q@mail.gmail.com>
 <dhj6msbvbyoz7iwrjnjkvoljvkh2pgxrwzqf67gdinverixvr5@e3ld7oeketgw>
 <lu3j2kr3m2b53ze2covbywh6a7vvrscbkoplwnq4ov24g2cfso@572bdcsobd4a>
 <Z7poTnlv-1DStRZQ@gondor.apana.org.au>
 <u7t7gibspxu3lujdl4hambr72qd6o5u33udbojihngznlyistk@gmyyhwjuiwxc>
 <Z7qNf4NerHrflmfV@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z7qNf4NerHrflmfV@gondor.apana.org.au>

On (25/02/23 10:52), Herbert Xu wrote:
> On Sun, Feb 23, 2025 at 11:09:32AM +0900, Sergey Senozhatsky wrote:
> >
> > Right, for lzo/lzo-rle we need a safety page.
> 
> We should fix it because it's a security hole for anyone who calls
> it through the Crypto API.

Yeah, I don't disagree.

> > It also seems that there is no common way of reporting dst_but overflow.
> > Some algos return -ENOSPC immediately, some don't return anything at all,
> > and deflate does it's own thing - there are these places where they see
> > they are out of out space but they Z_OK it
> > 
> > if (s->pending != 0) {
> > 	flush_pending(strm);
> > 	if (strm->avail_out == 0) {
> > 		/* Since avail_out is 0, deflate will be called again with
> > 		 * more output space, but possibly with both pending and
> > 		 * avail_in equal to zero. There won't be anything to do,
> > 		 * but this is not an error situation so make sure we
> > 		 * return OK instead of BUF_ERROR at next call of deflate:
> > 		 */
> > 		s->last_flush = -1;
> > 		return Z_OK;
> > 	}
> > }
> 
> Z_OK is actually an error, see crypto/deflate.c:

I saw Z_STREAM_END, but deflate states "this is not an error" and
there are more places like this.

> 	ret = zlib_deflate(stream, Z_FINISH);
> 	if (ret != Z_STREAM_END) {
> 		ret = -EINVAL;
> 		goto out;
> 	}
> 
> We could change this to ENOSPC for consistency.

So it will ENOSPC all errors, not sure how good that is.  We also
have lz4/lz4hc that return the number of bytes "(((char *)op) - dest)"
if successful and 0 otherwise.  So any error is 0. dst_buf overrun
is also 0, impossible to tell the difference, again not sure if we
can just ENOSPC.
