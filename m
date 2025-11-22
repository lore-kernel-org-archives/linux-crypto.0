Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B26C18027;
	Sat, 22 Nov 2025 12:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763812930; cv=none; b=CxxX3iTEHaLtGinosfxfHHdadS/3lW0EJuVAxcFCoBwRimkUzrcB1uruQmSfFTubX/UEDfmf0sLY4ZhGKxloHyi/buMXY+qBs6okbDxBwiQbvWfGFxNIsMvTeNSiRmt//BWiRu84N8Co5q0Z0JY2Z/CV8sb86O+QgzC6hn7JRIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763812930; c=relaxed/simple;
	bh=p9hpmLgRkw8Acyew2mQukW/5Wx7m7AppS6yC+/4Rllo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iBJuXu7gbpKY3kVaRv+sOKVCKeiJWXSDDBy4jNSnfpGQU5TGRPuBU+N0mX61x19lTskFeyvbu18wPV/5MwX6IqLvF1CkcFRDQLLuyVvMEBntE9xywjuqL+3nUE7NgjCPfiWsOt54yBI600kfp7lEN3m7XHA+gJJ86Vx7YNRc5V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=DOznPC63; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="DOznPC63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E083CC4CEF5;
	Sat, 22 Nov 2025 12:02:07 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="DOznPC63"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1763812925;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0JgzeJAS/5Dp1HqCBMEBqZ0eiDZPpQ6SIMUxA+kxrQM=;
	b=DOznPC63VjGGu23hTFPG/+czVPQ5XSY5E8eDM3S5Om0P+iAwlQM+sDvef+wdQQAqvGp2/m
	6McyMrL/dI6nIJz4M8KzBQEzcwNU7tkEbIafRMYgmJlUdMk03yw5jOi1JIMR9xY6bfu1CM
	kRXPYswOprsNwx1bstx5J1swqhp2JgU=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id cf0eefe5 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Sat, 22 Nov 2025 12:02:05 +0000 (UTC)
Date: Sat, 22 Nov 2025 13:02:04 +0100
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, torvalds@linux-foundation.org,
	ebiggers@kernel.org, kees@kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH libcrypto v2 2/3] compiler: introduce at_least parameter
 decoration pseudo keyword
Message-ID: <aSGmPAmCXJiv73wI@zx2c4.com>
References: <20251120011022.1558674-2-Jason@zx2c4.com>
 <aSEj0GvbFjwlDbVM@gondor.apana.org.au>
 <CAHmME9oukFd4=9J2AHOi3-4Axpw2M9-hwM6PSzRtvH_iCxaFaA@mail.gmail.com>
 <aSEpNYgrYRGOihxy@gondor.apana.org.au>
 <CAMj1kXG0adfCkuM4f92csxF0bxxBo6sNe_iJ_szKNEcEfgFwqg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMj1kXG0adfCkuM4f92csxF0bxxBo6sNe_iJ_szKNEcEfgFwqg@mail.gmail.com>

On Sat, Nov 22, 2025 at 12:53:58PM +0100, Ard Biesheuvel wrote:
> On Sat, 22 Nov 2025 at 04:08, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > On Sat, Nov 22, 2025 at 03:46:38AM +0100, Jason A. Donenfeld wrote:
> > >
> > > Saw your reply to v1 and was thinking about that. Will do. Thanks for
> > > pointing this out.
> >
> > It seems that we need to bring the brackets back, because sparse
> > won't take this either:
> >
> > int foo(int n, int a[n])
> > {
> >         return a[0]++;
> > }
> >
> > But this seems to work:
> >
> > #ifdef __CHECKER__
> > #define at_least(x)
> > #else
> > #define at_least(x) static x
> > #endif
> >
> > int foo(int n, int a[at_least(n)])
> > {
> >         return a[0]++;
> > }
> >
> 
> This is a different idiom: n is a function argument, not a compile
> time constant.
> 
> Clang and GCC both appear to permit it, but only GCC [11 or newer]
> emits a diagnostic when 'n' exceeds the size of a[]. There is also
> work ongoing to support the counted_by variable attribute for formal
> function parameters in both compilers.
> 
> So for the moment, I think we should limit this to compile time
> constants only, in which case sparse is happy too, right?

Sparse seems happy with my v3 for constants:
https://lore.kernel.org/all/20251122025510.1625066-4-Jason@zx2c4.com/

For this new idiom -- function arguments -- I think I'll look into just
fixing sparse. This seems like something useful down the line.

So I think we ought to merge v3 as-is, and then take the longer but
better road for this additional feature Herbert has brought up, by
extending sparse.

Jason
