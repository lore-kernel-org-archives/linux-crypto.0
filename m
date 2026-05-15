Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9625726B764;
	Fri, 15 May 2026 06:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778827552; cv=none; b=psu1QdxlL8mRlmT9lWl1P5bggxdB+2Ik5qnDTdyvnZa70e9FW0Ou16fOiGj89aUqqlrmUHRnLyiD4+QvqB3cJ9D93OO0GTAfdSnVWYbXGCGTOzGTpk48n/5Ffz/EDio9Cxrcv2MmaTcrNvUpsxc1blsIVrZgYUHM7wsOAUlwuDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778827552; c=relaxed/simple;
	bh=fdhRKJPCGZXjAWQoCegJr3llv8cjpNm22fP8NssyrcE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X6oef8Qa31/ptpHrZz1FuLvQ4junpriCRL5tGg61Jt0Ei5NiZYueTc9o02VbheaK9UomaKAtxuuIcvc44Nx6DHwAzH+CemtfBrrwptizRauIyobCcn+mo07A02dtk4uOT+RkhVMcRMlAWPloOWVtoZWTy3H/mzuobXBl7lLXnkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lz3Q1eVJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lz3Q1eVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3608AC2BCB0;
	Fri, 15 May 2026 06:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778827552;
	bh=fdhRKJPCGZXjAWQoCegJr3llv8cjpNm22fP8NssyrcE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Lz3Q1eVJw88rpf/bioyITL0kLSmO09UYalnIIAZdaKP1Q98TXOj1p0pNisUPyMSPm
	 SIb0lVZ2qf+ZfVErMKZDQFQJGTdsIwHCwa2B+WZiCYKPsAiM3IKhbDA32S1qQsBlzG
	 3gpve1hugc24Cj5+jaPMvz3LOQbNlBhkkJyvpSEQvu7pzRD5GBCfer8ibe+3OXOAYO
	 6WAYK1TZFSudpNkz6yEIQvL+fB8dkgodOAoQi4XARPCNP34/p+F/tTavMPBMLE/vxl
	 7X8oF0JtUZJUVi3vGQHOeUUl/bTU3+THtqIQuiG7dCPwt4TBAOTYdyeZTsPVI0P+Y/
	 z6quxt3HhPjcw==
Date: Thu, 14 May 2026 23:44:27 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: lukas@wunner.de, ignat@linux.win, jarkko@kernel.org,
	yimingqian591@gmail.com, stable@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] lib/crypto: mpi: Fix integer underflow
 in" failed to apply to 6.1-stable tree
Message-ID: <20260515064427.GA15865@sol>
References: <2026051223-undercoat-reps-6626@gregkh>
 <20260513025130.GA3110@sol>
 <2026051334-showgirl-hurdle-22eb@gregkh>
 <20260513170445.GA2128@quark>
 <20260513225934.GA501859@google.com>
 <2026051530-lushness-attest-bcbb@gregkh>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026051530-lushness-attest-bcbb@gregkh>

On Fri, May 15, 2026 at 07:45:40AM +0200, Greg KH wrote:
> On Wed, May 13, 2026 at 10:59:34PM +0000, Eric Biggers wrote:
> > On Wed, May 13, 2026 at 10:04:47AM -0700, Eric Biggers wrote:
> > > > > A couple issues.  First, this email wasn't sent to the subsystem's
> > > > > mailing list (linux-crypto@vger.kernel.org in this case).  That greatly
> > > > > reduces the number of people who are made aware that this didn't get
> > > > > automatically backported.
> > > > 
> > > > We never send out these FAILED emails to the mailing lists, as that
> > > > would make just even more noise.  It's always been this way, sorry.
> > > 
> > > Yes, this has been a problem for a long time, resulting in lots of
> > > missed backports including the copy.fail ones.  It's time for you to fix
> > > your process.
> > > 
> > > > > Second, the upstream commit cherry-picks to 6.1, 5.15, and 5.10 without
> > > > > conflict.  (The file being changed was renamed between 6.1 and 6.6, but
> > > > > 'git cherry-pick' handles that automatically.)
> > > > > 
> > > > > I don't know what you're doing exactly that caused it to be
> > > > > unnecessarily marked as FAILED.  But whatever it is, it's not working,
> > > > > and it is causing backports to be missed.
> > > > 
> > > > We don't use git for cherry-picking as we have a patch queue, so renames
> > > > will often times fail, like it did here.  This has always been the case
> > > > in the decades we have been running the stable kernels :)
> > > 
> > > Again, this has been a problem for a long time, and it's time for you to
> > > fix your process.  You can still have the patch queue; just use git for
> > > the actual cherry-pick.
> > 
> > Also I should mention that your own instructions for "reproducing" the
> > conflict use 'git cherry-pick':
> > 
> >     git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.1.y
> >     git checkout FETCH_HEAD
> >     git cherry-pick -x 8c2f1288250a90a4b5cabed5d888d7e3aeed4035
> >     # <resolve conflicts, build, test, etc.>
> >     git commit -s
> >     git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2026051223-undercoat-reps-6626@gregkh' --subject-prefix 'PATCH 6.1.y' HEAD^..
> > 
> > When these instructions are followed, there is no conflict.  The
> > "conflict" is purely because you didn't use 'git cherry-pick' yourself.
> 
> Yes, that is true, we are showing how someone else can potentially
> resolve the issue.  The magic is in the line:
>
> 	# <resolve conflicts, build, test, etc.>
> 
> We issue FAILED emails for any number of reasons, we don't go into the
> details of why it FAILED, otherwise we would have just too much
> information here.

I'm not asking for details on why it's FAILED.  I'm asking for commits
that cherry-pick cleanly to not be FAILED in the first place.

> > So just start using 'git cherry-pick', and stop asking other people to
> > do it for you when there are no conflicts, please.
> 
> That does not work in our workflow at all.  Given the huge flow of
> patches, and all the different issues/errors, the odds that a simple
> rename will resolve the problem is very low.  For that I can not slow
> down the whole process for all submissions.

I've been doing stable backports for a long time, and it's happened
*many* times that something cherry-picks cleanly for me but you say
there are "conflicts".  Here's an example from just 2 weeks ago where
you spent time "resolving" a "conflict" in commits that actually
cherry-picked cleanly:
https://lore.kernel.org/linux-crypto/2026043050-drainpipe-salvage-07c1@gregkh/

> > And please start Cc'ing the mailing lists.  Linux kernel development
> > isn't done in private email.
> 
> This isn't a private list, we are cc:ing the people who signed off on
> the patch directly.  They are the "owners" of it.

And sometimes the "owners" don't do it and other people involved in the
subsystem need to do it.  Or the backports are wrong and other people
involved in the system need to point that out.  It's not much different
from any other kernel development; it should be done on the lists.

- Eric
