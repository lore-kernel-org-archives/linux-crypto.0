Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793444335;
	b=4L0K5LutkN9ZY9/qZq89MQLv4h/OLqKVvKQXglaYB+BtMmzwkuqli0w9nXMYMt+rA31P
	 ojv4i64SOG5BuNnbYW00IHwFR3BuKzQ7vuOvRuF8ns9g3jRuH1yvppUFboyWhH8FVacQl
	 UXZcSCQuGgXEUVP6XKK0MSH6aPfOvc8mvvM70rWO5lPwzzdzmhZIKvFe4BBHUksu/2NIj
	 hEGc1Cdv34s3mZQMD/cipoO6GHu63yVwHa7Uieaugi7j1hHoKO2iWE9kT3jcmVmic9z5t
	 MBnE4U5jgAxXWu5Rmz65DU5pMAZqVFMFI87Vr2Rz6rF3BStZjzOB3sK9EHSxthgaPAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793444335;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=cCGadwtToCorgflN9IipYjClmwBy5TcnQgY9awENpas=;
	b=rAx1IHMlgg4aA7U9OrLocPlrBr3aQMb7uIBAHzKeJTc0EdjWtDS/yaq+7VBWF7XEKuaK
	 gXIkpbRl1WDaPEPlBNfcpedGmu+3cwxfJLoFw2bOPoC1jBteEC4D/WD+tUje/bX6XzF/m
	 yB6bFTIRevVuIpVSzv0ZalLytUP6pyp7cBLNPjmIcOzNCmAvIzoMwnfhbbNtdBaU1Vg/4
	 z4e88BF2yxgF2hu6XSbt1O96ZswO/yTAtm/dlaXOj5NLJvOO7l00GdIdt4YFZDZ8vW74O
	 ovvlsa0q9l/OOVQcJERyGqvawe99RaKw83tawiSfBhS9McEQQmnLFR+5W6eRtggYJKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bfqJsfRk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B10606A31A;
	Sat, 31 Oct 2026 10:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bfqJsfRk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2021F000C1;
	Sat, 31 Oct 2026 10:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793444333;
	bh=cCGadwtToCorgflN9IipYjClmwBy5TcnQgY9awENpas=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bfqJsfRk5fAoPhQhuwBGpCLM+O0gvNvAKyTWknoAIRheMasf014RhAQl0jAmM2a2C
	 pauGVZE+E0DCrSRj/gxggtAXBa265IeYMTdhTO/+JBHMyLn9tzZLrzSFH9UarsO+NA
	 pOOyojO/0SXSkfWIivN54HLwhrx+pzTD+KHcJwVs=
Date: Sat, 31 Oct 2026 11:58:47 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Jeremy.Jean@oss.cyber.gouv.fr, Jason@zx2c4.com, stable@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] lib/crypto: arm64: Fix lost Poly1305
 carry when resuming NEON" failed to apply to 6.12-stable tree
Message-ID: <2026103132-crept-dormitory-2414@gregkh>
References: <2026102137-contently-unshaven-7da4@gregkh>
 <20261021154806.GA1879@quark>
 <20261021164836.GB1879@quark>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261021164836.GB1879@quark>

On Wed, Oct 21, 2026 at 09:48:36AM -0700, Eric Biggers wrote:
> On Wed, Oct 21, 2026 at 08:48:08AM -0700, Eric Biggers wrote:
> > [+Cc linux-crypto@vger.kernel.org]
> > 
> > On Wed, Oct 21, 2026 at 04:40:37PM +0200, gregkh@linuxfoundation.org wrote:
> > > 
> > > The patch below does not apply to the 6.12-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> > 
> > It's a clean cherry-pick, as git detects the rename of
> > poly1305-armv8.pl.  So there should be no need to require this to be
> > resent.  Also, missing Cc to linux-crypto.
> > 
> > Same for 6.12, 6.6, 6.1, 5.15, and 5.10.
> 
> As I've said before, the reason this keeps happening is that Greg's
> stable scripts perform a cherry-pick by first formatting the commit as a
> patch file with the default 3 lines of context, then applying it with
> 'patch' using the default fuzz of 2.
> 
> (The second step seems to occur in the 'apply_it' script, which isn't
> public.  But based on the observed behavior, it must be what it does.)

That script has been public for decades:
	https://github.com/gregkh/gregkh-linux/blob/master/stable/apply_it

> This process is buggy compared to simply using 'git cherry-pick':

Agreed, see my previous message, we don't use git cherry-pick for this
workflow, sorry.

thanks,

greg k-h
