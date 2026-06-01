Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0063CAA51
	for <linux-crypto@vger.kernel.org>; Mon,  1 Jun 2026 14:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780325847; cv=none; b=h82cOd+uUlQugEueiqH1iIUw2pUEKyBHmOkjK2YwPVxAJ9gEG3wYnbwULmUJPcsqxDZxb8d+7z41EpOkGqSwA5wc1YuCdGNDcsbPZo+vS6BK9KC0J2LM1XCCpFhnPeSe6XqnRjoklQEOLBcHiJha9p0MY2rp5pXrWx/6vvJncEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780325847; c=relaxed/simple;
	bh=3U/hoCMfqrN8WYMe6LpM/eJcEaNfw0c3jaGz+fXlIRQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jw2RaGvNDdQnk58pxC0dvwCcveQWe2pJstNruMrWwv+7sw0bdtfVFeWQ8JTxm13nSR2yUxSzjkBKRzz4o4ixBBV9HAByQO6/RE9EwZDNBadXG1x1rIoYbbtCT1aKfZsYzEFdo+hhU2LwQLObcflRWmcAh3eR71a61aRIhh4wYt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DMC2b/cn; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DMC2b/cn"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-45ef5146b56so1791412f8f.0
        for <linux-crypto@vger.kernel.org>; Mon, 01 Jun 2026 07:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780325845; x=1780930645; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gfecz+ZWs/BTOXCnvzAkst5tZtXH0lgY7BHeUFyc1xs=;
        b=DMC2b/cn/Zo4sw5g1sBqwqrnNX/OHyqX+T+opTkM+11oeJ3ilxNqPAGBhXNU2soY0G
         0Eh7lgxJqh9kjl9g/CNGzKFvkC3ddInd0ipayjmx2nKO9PepaZ4VZ5GSHIIMaw3ygNT3
         n4q+3MQ4PTUV+0aH9SHU3DC3tv+zMGEV4F/h5o7AIB9e6qugKyyJMYQGfAjh7+JqulS8
         3U3w4xcR1ILOvU8Gxn1Tu9nIUWcGhwrSyZj/RzZKk/47YXWQvLVdTJ/4GHV+PZuq1ZFW
         2EQ30FAvRgWdw05jQxdSl75RZB/snqvQTBhFGqenN5rcs9DuaGkE2vBh0krrpbz/XPeX
         2Omg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780325845; x=1780930645;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gfecz+ZWs/BTOXCnvzAkst5tZtXH0lgY7BHeUFyc1xs=;
        b=Flm1ALPd95JakcVy0k5ggimqCgF/knxn62CsxWnEUN8cBAwmiISHlKYuM3zrPRHk6P
         +jNAERZF5oT1G424F1KvN+aVGstO3ii2m6nvWxn9qV5Lj7RS6vGgCVi603QEKZz/M+kr
         0i4kgqdTeXiEdlYMfoFRGkjbDaRVDzW6j+dJ4GVZ72qmlcX8b0GBuQwBD5tdfYDk/VOe
         UbzpJnD3wMbeV8WwIgCiqbYLDjrX5wsOTs1CM1UK5L6F3QRzJyvcK4o224KhF1LO3+Xf
         DTpchTL+hnuHL52DkfwRuNISJJuT7ZyWxwGcgZCyeD8onN7RfsUPvQ9jMwoYgTfRlo+L
         JsgA==
X-Forwarded-Encrypted: i=1; AFNElJ8/JcnQzSylED01zSpFL6R579QuRVhe1XGaMG4bfMMtxYYBX4RZIb3EgEczyHbqkVf/x4oFVZctX8KbtFI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyamHbRo7wo5TJ9jcOos6lDp31547TcUu4IJr3rfbsVwZqalq1V
	c8Oni7N/bDnj7o1fN0xBNB4xxf5a+ZBgV+F9Ukt6BF8LVMWZ7k7t0r4C
X-Gm-Gg: Acq92OGGKstMGAKF12L9eKbH/BM9E2u2Ut8OnJ31Uvd+TuZz6+T51snO5G5TdxJV5RB
	1PQk8vWWtZxxsi0E95K/41xt5k4qGnJswhwPDNjDk4xnco14L1auFTOuflswOQAJkoZLQ/h/Jzr
	KK9NJ4ETgooPQCCFDWRyAHuemkanyfr16i9cc3Cp0YUXHuZA2ixa5wkHgFJ9r8qhsIV/q4odtKR
	4nI4fvsVT+mDjG7i8oVwtXjzixrjBp1UVoxbnOSbmmeUiyl0s1JYlQD3jg6g9gFAV48WM2ZIfbk
	pTZ6QvkP7Rz1Ywih9t1LYcK8V/Y+/cuLWSCCS/175CH4NCYms9clxcfrg3U3si59khRx4X3vNWG
	iswVP+gLyHAejw/86947Tmeq/lKMEjy1LXzIM1RlomikCJMynqVQwM5BBplfZiIVDEEvRFPzxVw
	DhYkH4NAoRCmPED5qndOurtDDED8GtzJd6dg==
X-Received: by 2002:a5d:59c6:0:b0:45e:e936:5e30 with SMTP id ffacd0b85a97d-45ef6e696cbmr18803207f8f.6.1780325844434;
        Mon, 01 Jun 2026 07:57:24 -0700 (PDT)
Received: from Red ([2a01:cb1d:897:7800:4a02:2aff:fe07:1efc])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-45ef34a03f8sm27548200f8f.7.2026.06.01.07.57.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 07:57:23 -0700 (PDT)
Date: Mon, 1 Jun 2026 16:57:21 +0200
From: Corentin Labbe <clabbe.montjoie@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Tianchu Chen <tianchu.chen@linux.dev>, herbert@gondor.apana.org.au,
	davem@davemloft.net, wens@kernel.org, jernej.skrabec@gmail.com,
	samuel@sholland.org, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: sun4i-ss - clamp PRNG seed length to prevent
 heap overflow
Message-ID: <ah2d0RyZcVp614_k@Red>
References: <af749a8447bd7f0e9dd26ca6c87e9c6afecb09d9@linux.dev>
 <4d4407c05835a50413fa1e974e3aa3f4abfe2d5b@linux.dev>
 <20260529161057.GA2706@sol>
 <ahnIbpBLyn5z_siT@Red>
 <20260529173341.GA566433@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260529173341.GA566433@google.com>

Le Fri, May 29, 2026 at 05:33:41PM +0000, Eric Biggers a écrit :
> On Fri, May 29, 2026 at 07:10:06PM +0200, Corentin Labbe wrote:
> > Le Fri, May 29, 2026 at 09:10:57AM -0700, Eric Biggers a écrit :
> > > On Fri, May 29, 2026 at 08:08:01AM +0000, Tianchu Chen wrote:
> > > > From: Tianchu Chen <flynnnchen@tencent.com>
> > > > 
> > > > sun4i_ss_prng_seed() copies the user-supplied seed into ss->seed
> > > > using the user-provided length with no bounds check. The crypto core
> > > > does not enforce slen <= seedsize before calling into the driver, so a
> > > > userspace caller via AF_ALG setsockopt(ALG_SET_KEY) can pass up to
> > > > sysctl_optmem_max bytes, overflowing the fixed-size buffer and
> > > > corrupting adjacent heap memory.
> > > > 
> > > > Clamp the copy length to the buffer size, matching the approach used by
> > > > loongson-rng for oversized seeds.
> > > > 
> > > > Discovered by Atuin - Automated Vulnerability Discovery Engine.
> > > > 
> > > > Fixes: 6298e948215f ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Tianchu Chen <flynnnchen@tencent.com>
> > > > ---
> > > > v2: Silently clamp oversized seeds with min_t instead of returning
> > > >     -EINVAL (Herbert Xu).
> > > 
> > > sun4i-ss-prng.c is useless, is still broken, and should just be deleted.
> > 
> > Hello
> > 
> > useless ? clearly no, it helped a lot on devices where it is.
> 
> The only way this code is reachable is via "rng" algorithm type in
> AF_ALG, which is almost never used.  Everyone just uses the regular
> Linux RNG (/dev/random etc) instead, as they should.
> 
> In fact, anyone were to accidentally use this it would be a security
> vulnerability, seeing as sun4i_ss_prng_generate() doesn't actually fill
> in all the bytes that were requested.  It also doesn't wait for the FIFO
> to be ready when reading data from it.
> 
> Is it possible that there's a misunderstanding here and you think this
> provides entropy to the regular Linux RNG?  It doesn't.  hwrng does
> that, crypto_rng does not.
> 

I believe to have used rngd for that. ( or something like that)

Anyway, I understand why want to remove it.
