Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37E4249F5
	for <linux-crypto@vger.kernel.org>; Fri, 31 May 2024 05:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717132727; cv=none; b=hpWlzJNnaN6pmegzWd+E077s/zomv/s1Q1FjVeB1tujXji73CxrJOhKXR+CbvCRkEz3IoEXBFCScuaP6AkQY2rrlJoird2ou484zC1vtlsz4Bet1ckmPfsmi8y7T6QFHWHeQPtncG5oKeBzut2vYU0lBqFyoZoNqnhJinuKgXtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717132727; c=relaxed/simple;
	bh=fLbuEfEwJiI7zQEHBbqh3S+Np+0kRkcKHddVrqO3Vj8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dzB91H+F4vijS58kS4f/r2RJ8ae/2lMdJr98h+RjBBGuknn46Cejuw1eoOkk/VEa3sGLErB9W95kGZhtbl1hmdPtyVM9GEmmWoH3+cftTe1DcrWwoJGUVQbLrL7B7Ag2wZFx6ghccgPftr+Byh8mGHa0grGx/rGeywpEJdHxxUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=gl0JNg18; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="gl0JNg18"
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-24fda23b9f2so983777fac.0
        for <linux-crypto@vger.kernel.org>; Thu, 30 May 2024 22:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1717132725; x=1717737525; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8A1zL3+cbvinMx9qLVNAkh8DveoBEmthdLg5ORax1cw=;
        b=gl0JNg18npJpMvPkQnI5kS5XdLEToKR8r8OPuWt0BFR+GdTUt0T2XOXXK9z64JI8jT
         QYVYBjmjNFbF13xlGBg2/5jqyTB41WDf+juIPmYQY4X7pdU4HmSZiWxFo6WGIXkEnpnC
         dwcBWfg73KNwq0oh392Nni8uYKQrG6rPUrkg8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717132725; x=1717737525;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8A1zL3+cbvinMx9qLVNAkh8DveoBEmthdLg5ORax1cw=;
        b=rOopm8VIOWTA1jojetm6VVB8hN14H88F1E59gE5jjOV00ftBgGxGsIB1EP0hTvwqoj
         5l2zFbqmusYiffrbzDJROLJGghUzm0CAfHw0Z10p1OfH/KYJEEYqt6dChyKY0qn9NfpN
         cb7CTF37jsqNQLZk/iwv3q8FLL0MhEizbBoTUCPJKmGGY/Pm70nZo5j06/G/aPa5a3eE
         B9kGYFr+rG2ajhMCMxOEeYxarytUyI34EeMvqq76pj26gnoii1WY2tB2RLJAADHs8tDo
         c1xJIFgdF0hoymkHJ7LQdKm6BrcJ+57l3Os1Lult6TQtci+AHY9pEgDEwRiPs343R3DZ
         Uh4Q==
X-Gm-Message-State: AOJu0YzwAcYq2FD1CVUlIiaTBAXB4Ta6OsqkIaXyE0NLb1VsUNuf7I6o
	RoqsJTFNPBoI124C1yCmq7mpENtem82pgXYeQBCuiQo7LpTl2L+YFizKjNb/1w==
X-Google-Smtp-Source: AGHT+IE1Ndu6SzRlycJQRWgYGDCw879I1Sq45sCBoTGvVr7V2XFhCXXTk4kcW6AUmFlERxaCRcddHQ==
X-Received: by 2002:a05:6870:fba1:b0:24f:e478:6e6c with SMTP id 586e51a60fabf-2508b7f155bmr1138606fac.17.1717132724635;
        Thu, 30 May 2024 22:18:44 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:b7f3:e557:e6df:620b])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70248bf7eeesm380170b3a.137.2024.05.30.22.18.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 May 2024 22:18:44 -0700 (PDT)
Date: Fri, 31 May 2024 14:18:41 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH 0/3] crypto: acomp - Add interface to set parameters
Message-ID: <20240531051841.GD8400@google.com>
References: <cover.1716202860.git.herbert@gondor.apana.org.au>
 <ZllbHYL8FYlrCRC_@gondor.apana.org.au>
 <20240531051232.GC8400@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240531051232.GC8400@google.com>

On (24/05/31 14:12), Sergey Senozhatsky wrote:
> On (24/05/31 13:07), Herbert Xu wrote:
> > On Mon, May 20, 2024 at 07:04:43PM +0800, Herbert Xu wrote:
> > > This patch series adds an interface to set compression algorithm
> > > parameters.  The third patch is only an example.  Each algorithm
> > > could come up with its own distinct set of parameters and format
> > > if necessary.
> > > 
> > > Herbert Xu (3):
> > >   crypto: scomp - Add setparam interface
> > >   crypto: acomp - Add setparam interface
> > >   crypto: acomp - Add comp_params helpers
> > > 
> > >  crypto/acompress.c                  |  70 +++++++++++++++++--
> > >  crypto/compress.h                   |   9 ++-
> > >  crypto/scompress.c                  | 103 +++++++++++++++++++++++++++-
> > >  include/crypto/acompress.h          |  41 ++++++++++-
> > >  include/crypto/internal/acompress.h |   3 +
> > >  include/crypto/internal/scompress.h |  37 ++++++++++
> > >  6 files changed, 252 insertions(+), 11 deletions(-)
> > > 
> > > -- 
> > > 2.39.2
> > 
> > So does this satsify your needs Sergey? I'm not going to apply this
> > if you won't be using it.
> 
> Oh, I didn't see this series (not subscribed to linux-crypto).
> Let me take a look.

Ah, wonderful. The series landed in the SPAM folder:

	"Why is this message in spam? It is similar to messages that were
	identified as spam in the past."

Whatever that means. Recovered, thanks for pinging me on this.
