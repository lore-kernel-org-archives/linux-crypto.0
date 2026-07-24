Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52FC72F9D98;
	Fri, 24 Jul 2026 08:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784882555; cv=none; b=URGvpY0ZM6+DmzibzUVKm/6kHkhH0Un4hXNCgkWfx/OKBaBgGTFrPDuGorQ2Uwrva6x9XUlgAX7+RWQqeaIOqP2UCcwxR1tLy9pxG/3jGTl/F3FgXWjbiIzLqc5R2d5MFOwizFx7IVnr6RH1IYhWsA3xzV1+yIiYi4aPJbks66A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784882555; c=relaxed/simple;
	bh=IKNEgb2hfeXsKoHFNVyxvHaUclfCVU00yG0PgUyW/No=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kNxn6g5gNM1WT26bmK4YQVHJoIVsinC3NmAOYAy8GQGUxz5UFf3cIepjMg6kqzd8FSgROAtfBHtX6DFxi81oSfD2FrdnKithQLV8GlNRXi/PzpHS52b5N5Skx10Yp5CVKOdMTl85sOrpIom7UDSoffKxx8X+bX2Z5qXsxr17ri8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CSJqlN/l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CSJqlN/l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50BB11F000E9;
	Fri, 24 Jul 2026 08:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784882553;
	bh=1Viv4laXGsPAQoliMSE2ofB8brslnCyeCGRVHQ1c5ZY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CSJqlN/lL9qh7fxX1PunNsNfpsBiwIkQyd4cr9nuIYrbqRVMM5LHUgQfB+Cav03lk
	 gfkcv5S7ZSyagwUGEWO8rLVXEvzXjHTW+X4e72LMZouVd58S34GrShgcjeEHnYrcEx
	 6sGElKzXdIE5NY/FwrDQF9WzNbTENPh7xOA6AXH4=
Date: Fri, 24 Jul 2026 10:41:09 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Bartosz Golaszewski <brgl@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Demi Marie Obenour <demiobenour@gmail.com>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH] crypto: qce - Remove driver
Message-ID: <2026072412-decrease-sandbag-70a1@gregkh>
References: <20260724050645.223799-1-ebiggers@kernel.org>
 <2026072410-drained-acts-3502@gregkh>
 <CAMRc=MdJTFokXLEbJMQW3V4FAMQid50Vx3fDB+CaNGUrzX-Pwg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMRc=MdJTFokXLEbJMQW3V4FAMQid50Vx3fDB+CaNGUrzX-Pwg@mail.gmail.com>

On Fri, Jul 24, 2026 at 12:36:24AM -0700, Bartosz Golaszewski wrote:
> I'm against removing this driver but I have a kernel driver policy question
> before I start arguing the case: If I say that I do use this driver and that
> I volunteer to maintain it and had already started sending out fixes, can
> Eric still force its removal? Because in this case I can name a whole lot of
> drivers that I deem useless that we still keep around.

But you aren't using it if it is marked as BROKEN.  If that's not the
case, and it is not broken, well why is it marked that way?

> The alg priority of this driver has been decreased below that of ARM CE and
> since CRYPTO_ALG_KERN_DRIVER_ONLY it can no longer be used accidentally by
> user-space either.

If it can't be used, then again, who is using it?  We can't have ONLY
out of tree users for code that is in the kernel.  We HAVE to have
in-kernel users for it to stick around.

> Even if in practice the driver is used for testing purposes - does this warrant
> its removal?

testing purposes of what exactly if there is no in-kernel code that
calls this thing?

thanks,

greg k-h
