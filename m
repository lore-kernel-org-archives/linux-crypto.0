Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766731487DD;
	Fri, 13 Sep 2024 19:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726255406; cv=none; b=XiWLj7N+LNw3KwgfyjGket7g6g7qzf1epCwrqFvimJxcWcC2HHF2d44bEPOC3VQ19wFoq9ebtnS2h2IukWkAlFkHV3m3f3Go2kyivk/0jJJPnsiJXmDyzKQe0Hp6h7wdcS0ShwxFrJ6zRb6X0UqrzYDScDMUmgC868G7fGULQA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726255406; c=relaxed/simple;
	bh=g+we6zXlRF0K6r7vmZ6GDKa/NiVEm5StyEJsa3ai1Q0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uYg9a+889aUkGZ3I/GX7sJqn1yLGhlyspmt8HjoapXRLfUGwFVXwmQDJxlThyvRiLw6Q9Fcae+Ra+MaLd+5OifQNVXXYn4MFAShUXui9o79GNQ+aNnEUnqXaaSKSfn+OVRg8Bu398D3qieTMzsRQWnv7Ip/ny7I4LMfcZQuv5+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=iqVaYpSF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="iqVaYpSF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8FF2C4CEC0;
	Fri, 13 Sep 2024 19:23:24 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="iqVaYpSF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1726255403;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gRexsgTMh+myIiZRscYFbD1nR7aA5ysUH5XGp1Tlp7Y=;
	b=iqVaYpSFmuqJS/EdM5oDqxY2LQzVTZFAYQulKseyvnZmHLVK/DE49vWb0PUK1vNuOI/a51
	d6ZKtvRqOhSwajEr79L3BzwYkbTqqzx9h2HX+OcRVWHVcDbYGwYRM1VMRLtk7CUyZv2Xka
	Nm9OEG0/yDyTZQCq/C3JhJMnu09M5Jo=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 745eb482 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Fri, 13 Sep 2024 19:23:22 +0000 (UTC)
Date: Fri, 13 Sep 2024 21:23:20 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Stefan Liebler <stli@linux.ibm.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH 7/7] s390/vdso: Wire up getrandom() vdso implementation
Message-ID: <ZuSRKLFdYI1gCHh9@zx2c4.com>
References: <20240913130544.2398678-1-hca@linux.ibm.com>
 <20240913130544.2398678-8-hca@linux.ibm.com>
 <ZuRWmJTWqmD92D8d@zx2c4.com>
 <ZuRYoVIrg28kBKqb@zx2c4.com>
 <20240913173206.30385-C-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240913173206.30385-C-hca@linux.ibm.com>

On Fri, Sep 13, 2024 at 07:32:06PM +0200, Heiko Carstens wrote:
> On Fri, Sep 13, 2024 at 05:22:09PM +0200, Jason A. Donenfeld wrote:
> > On Fri, Sep 13, 2024 at 05:13:28PM +0200, Jason A. Donenfeld wrote:
> > > On Fri, Sep 13, 2024 at 03:05:43PM +0200, Heiko Carstens wrote:
> > > > The vdso testcases vdso_test_getrandom and vdso_test_chacha pass.
> > > 
> > > I'm trying to cross compile this but I'm getting:
> > > 
> > >   CC       vdso_test_chacha
> > > /home/zx2c4/Projects/random-linux/tools/testing/selftests/../../../tools/arch/s390/vdso/vgetrandom-chacha.S: Assembler messages:
> > > /home/zx2c4/Projects/random-linux/tools/testing/selftests/../../../tools/arch/s390/vdso/vgetrandom-chacha.S:147: Error: Unrecognized opcode: `alsih'
> > > 
> > > Any idea what's up?
> > 
> > Looks like I needed `-march=arch9`. I can potentially rebuild my
> > toolchains to do this by default, though, if that's a normal thing to
> > have and this is just my toolchain being crappy. Or, if it's not a
> > normal thing to have, do we need to add it to the selftests Makefile?
> 
> That needs to be fixed differently, since the kernel build would also
> fail when building for z10. Could you squash the below fix into this
> patch, please?

Done.

> So for the kernel itself including the vdso code, everything is
> correct now. But similar checks are missing within vdso_test_chacha.c.
> I'll provide something for that, so that the test case will be skipped
> if the required instructions are missing, but not today.

Okay. I would assume no rush there, because it's unlikely there are
those machines part of kselftest fleets anyway?

Jason
