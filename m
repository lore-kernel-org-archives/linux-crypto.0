Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1F226ADD;
	Sun, 11 May 2025 20:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746996781; cv=none; b=M83WrFJXsof3rRR87vyqzCC+afOCD6Xxsaka+7cV/QNDbWqSVBfsHNE9saKvbfk+a3qsc9Hw52TvBH7yRsvhnGtgyjPXrfepoy6rR/v20tCycQGvV0mtbcR6ZnA6lJfBoLdIuPpBpxVkEsuOZXLzYnsOCWjiq/prcHX0A1QmhWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746996781; c=relaxed/simple;
	bh=cLWQEuDyXM0HnmZL7YBjStG5UjDwsWt/iMGWtO01te4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J2jCx+n7//2yEd9FMEpJA4kcXEqGKM+1b+z3PlkS31wjyjvi5wjWfSiZynLyl4rFsTqmO0kAJCThwtDJOLpEmmYHcjEpfjmLD1e8jCP+4FNrbszLL7AkUWe5r2LLgQfhqJup+9FA5TLHfFLY9sFOlpMwFUl4bwh7Y98RY78hD8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jCBaflPX; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jCBaflPX"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-6f0c30a1cb6so30073816d6.2;
        Sun, 11 May 2025 13:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746996779; x=1747601579; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RipRjxnYfW+Jx5Ls2Hz0Hp4uDesu7VcMLC+uJZD+Nr8=;
        b=jCBaflPXVptkGJUjoxPCWlNXC7drIMz1cP148elQYKZ51cAZJHWDcUmHA59pzsRpKQ
         k1wYv3HQfGLbTkchOD1GU7CZpVsYmTwVHP3RfztOFKzKnkvUQZ2axOnIRcv8CdwKhwjG
         jFRFSVBBcxqMKMnVA9KWJRp69+z6I9YGApulolTOS/TTQkcfeOHdiZrgmaRvWSNRunTp
         cCBBVWRfZwm4Y1v+8gpoTJcwveyuC0llRD10fF+xBcey+dXrp/OOdEr9HZjB1+XLP5x6
         RT/yj2WVF3SkxtKQgsP7d2aca3A7SgrUV6eGAzSNeM5NwYX2PSZKMECNW6fQqM/UOoWb
         lS0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746996779; x=1747601579;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RipRjxnYfW+Jx5Ls2Hz0Hp4uDesu7VcMLC+uJZD+Nr8=;
        b=SPJMwiHnzJpW0VQgqf83wD1cq4b4t9RTKXI1ASnu8t65sukp+MtG42r8OkXwJ+Bny1
         O/yF6N+oWt0g9MaU746yb/TceliftjpBipZSLl2RbfnqhwL03fxiB5Q2H7wTZxHL7Ss3
         9zrNpJh3y0v0DKEuSa7SuTzcHI06PaOewStb9uAR3Y+bb/QvnxM16ttR3ZT0WegMwpZU
         GxQtrEry7iAh+9IE/gDzFLR3b08qL1UCOKzHbp9gnFjYGEyiicHulU3+QZQ5Q0k5CMfl
         IEUzpx8RJ4qD3TMRcWoA47vXsrmB5MkZV8K3yepILnLBG5kwxMVGUYIPoioUtvEJcFmE
         CqDQ==
X-Forwarded-Encrypted: i=1; AJvYcCVd63SF1CTMyNODXHDK8Gc/o8zj5CWDlGu+21Van+SAq0aiCn7wQJsBp7KrVmIA+vkb/iSiOERNHOqauFI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQfBNi3d/c0pqXg6dUE8Pdr8yXUlp0hl6mj+wV6/v4Q7t+v38J
	Ns3pnUPK7dPoAAgoqEoBAM07Kf+B6CUxRJ1liqQheV7ClsHZIQEqJy2/N1LAIYGJZtDTNLrihsr
	RiUDLfZSury70/BamVa+5DAp9YFA=
X-Gm-Gg: ASbGncttD/ZaWqOno9jZw+JOvdFl/wAFV4bkOlQbh7UlND0baPhWu2NYpuB2UDDJlwO
	Qv3knFA4Om6BMV/hZ9ozUo9WqXhuVpoHFkmydHA8AM2H/UBBcqIv6780WZAMDBRbT1JyGY4EfSu
	xPbljM6YcLI/uGagpBMnmR9umP2/FcDuVvZBOQMdP3+AI=
X-Google-Smtp-Source: AGHT+IEXUJcO+2pqe/WSnvcgKLVVGhD6I+qO3yu2CxFedTENN6cNl+uwgNw1LCNbXpeMTAIsot8KcI6sNYkIsKEGQdE=
X-Received: by 2002:ad4:5f8c:0:b0:6f5:e80:ac69 with SMTP id
 6a1803df08f44-6f6e480ac1fmr155723586d6.29.1746996779178; Sun, 11 May 2025
 13:52:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250430205305.22844-1-kanchana.p.sridhar@intel.com>
In-Reply-To: <20250430205305.22844-1-kanchana.p.sridhar@intel.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Sun, 11 May 2025 16:52:47 -0400
X-Gm-Features: AX0GCFujuwJ08KLC2fnWBSBrn2i3URgm4MKtTV03zVybIUnaxHXnwtnCFSklin4
Message-ID: <CAKEwX=PSOCKNtX0LXHytMwU67eJ=9-d17T62UMBDMpAeoFb76A@mail.gmail.com>
Subject: Re: [PATCH v9 00/19] zswap compression batching
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	yosry.ahmed@linux.dev, chengming.zhou@linux.dev, usamaarif642@gmail.com, 
	ryan.roberts@arm.com, 21cnbao@gmail.com, ying.huang@linux.alibaba.com, 
	akpm@linux-foundation.org, linux-crypto@vger.kernel.org, 
	herbert@gondor.apana.org.au, davem@davemloft.net, clabbe@baylibre.com, 
	ardb@kernel.org, ebiggers@google.com, surenb@google.com, 
	kristen.c.accardi@intel.com, wajdi.k.feghali@intel.com, 
	vinodh.gopal@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 30, 2025 at 4:53=E2=80=AFPM Kanchana P Sridhar
<kanchana.p.sridhar@intel.com> wrote:
>
> Changes since v8:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> 1) Rebased to mm-unstable as of 4-21-2025, commit 2c01d9f3c611.
> 2) Backported commits for reverting request chaining, since these are
>    in cryptodev-2.6 but not yet in mm-unstable: without these backports,
>    deflate-iaa is non-functional in mm-unstable:
>    commit 64929fe8c0a4 ("crypto: acomp - Remove request chaining")
>    commit 5976fe19e240 ("Revert "crypto: testmgr - Add multibuffer acomp
>                          testing"")
>    Backported this hotfix as well:
>    commit 002ba346e3d7 ("crypto: scomp - Fix off-by-one bug when
>    calculating last page").
> 3) crypto_acomp_[de]compress() restored to non-request chained
>    implementations since request chaining has been removed from acomp in
>    commit 64929fe8c0a4 ("crypto: acomp - Remove request chaining").

I'm a bit confused. Which patches on top of mm-unstable do I need from
the crypto tree as pre-requisite for this patch series? And in which
order?
