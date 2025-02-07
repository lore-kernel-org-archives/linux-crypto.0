Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F1B23C8C4;
	Fri,  7 Feb 2025 22:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738968570; cv=none; b=ESWkkURAtroe+JZPbef8ytY9Ijo1K27gHMoArBeB40Ry0QvnD0YFcOt8We529PYyFlCt0DQi0eS/85IRFvNafYCMbsVP0wAqnYexIPE3AF5rfwKrkUrkhWtZZ5x/ds3u/CdqQWSxQftKNpil+MGINcxLTi3vvm+p+ifvo1G3pvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738968570; c=relaxed/simple;
	bh=owl9CVvvtG4wUxs40IqT3ipinai74SzRIByVFrvUN8g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s3bdr/j6yMijnYvadk4xrNgPs+RxoNR+q2Mzjnal+T3O4gzisIBhWTP2FRyx4jy2gGoABgEczwnZYH0Yf4XiYTwJBudIquAUysdxzxu54f7By6BN7xc8T92wMmosmv48fzxSzreKm7d5AZwSS+ZIaAkmjS61+Ydn0uan0WoRsN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iRDMQFhU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iRDMQFhU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26CA0C4CEE2;
	Fri,  7 Feb 2025 22:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738968570;
	bh=owl9CVvvtG4wUxs40IqT3ipinai74SzRIByVFrvUN8g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iRDMQFhUqf3Y9j2K4MSyxcguvtSusGJAQ0eqU2s1r9eA6CBTQTwYXcVaOhk45dNQ5
	 qWxuw8KgkfsOKNLX7rvIBVzdP2vo3Q/aCbQnLWhdR4f71+bTVKPiE2yJKGVthsHyFW
	 HN7ahdBcfJQGxZPgR9djShZW9SFcvdeRCX33Qd1BTdH3+iZoSmnBAd7Ocy51xwgzTS
	 MM9Hye8RLeJ0Xu0SwLKszOraecX04CRmygN2O75FQyPrThd97yCU3wZWhe3KCjo7C9
	 sqnadSr9tfcFsVmeU69d8smXtHsyfI+W1SSBnjUmUvfnprjXlsK/IZwSo77PrqHKEG
	 pkiy6NoGku1QQ==
Date: Fri, 7 Feb 2025 22:49:28 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH 3/5] lib/crc32: standardize on crc32c() name for
 Castagnoli CRC32
Message-ID: <20250207224928.GB2819332@google.com>
References: <20250205005403.136082-1-ebiggers@kernel.org>
 <20250205005403.136082-4-ebiggers@kernel.org>
 <20250207224233.GA1261167@ax162>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250207224233.GA1261167@ax162>

On Fri, Feb 07, 2025 at 03:42:33PM -0700, Nathan Chancellor wrote:
> Hi Eric,
> 
> On Tue, Feb 04, 2025 at 04:54:01PM -0800, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > For historical reasons, the Castagnoli CRC32 is available under 3 names:
> > crc32c(), crc32c_le(), __crc32c_le().  Most callers use crc32c().  The
> > more verbose versions are not really warranted; there is no "_be"
> > version that the "_le" version needs to be differentiated from, and the
> > leading underscores are pointless.
> > 
> > Therefore, let's standardize on just crc32c().  Remove the other two
> > names, and update callers accordingly.
> > 
> > Specifically, the new crc32c() comes from what was previously
> > __crc32c_le(), so compared to the old crc32c() it now takes a size_t
> > length rather than unsigned int, and it's now in linux/crc32.h instead
> > of just linux/crc32c.h (which includes linux/crc32.h).
> > 
> > Later patches will also rename __crc32c_le_combine(), crc32c_le_base(),
> > and crc32c_le_arch().
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> ...
> > diff --git a/include/linux/crc32.h b/include/linux/crc32.h
> > index 61a7ec29d6338..bc39b023eac0f 100644
> > --- a/include/linux/crc32.h
> > +++ b/include/linux/crc32.h
> > @@ -27,12 +27,11 @@ static inline u32 crc32_be(u32 crc, const void *p, size_t len)
> >  	if (IS_ENABLED(CONFIG_CRC32_ARCH))
> >  		return crc32_be_arch(crc, p, len);
> >  	return crc32_be_base(crc, p, len);
> >  }
> >  
> > -/* TODO: leading underscores should be dropped once callers have been updated */
> > -static inline u32 __crc32c_le(u32 crc, const void *p, size_t len)
> > +static inline u32 crc32c(u32 crc, const void *p, size_t len)
> >  {
> >  	if (IS_ENABLED(CONFIG_CRC32_ARCH))
> >  		return crc32c_le_arch(crc, p, len);
> >  	return crc32c_le_base(crc, p, len);
> >  }
> 
> I think this rename is responsible for a build failure I see with an
> ARCH=mips configuration on current -next:
> 
>   $ make -skj"$(nproc)" ARCH=mips CROSS_COMPILE=mips-linux- mrproper 32r6_defconfig arch/mips/lib/crc32-mips.o
>   arch/mips/lib/crc32-mips.c:25:9: error: 'crc32c' redeclared as different kind of symbol
>      25 |         crc32c,
>         |         ^~~~~~
>   In file included from arch/mips/lib/crc32-mips.c:12:
>   include/linux/crc32.h:32:19: note: previous definition of 'crc32c' with type 'u32(u32,  const void *, size_t)' {aka 'unsigned int(unsigned int,  const void *, unsigned int)'}
>      32 | static inline u32 crc32c(u32 crc, const void *p, size_t len)
>         |                   ^~~~~~
> 

Thanks for pointing this out!  I temporarily dropped the series from crc-next
and will send out a revised version soon.  The enum value in crc32-mips.c will
need to be renamed.

- Eric
