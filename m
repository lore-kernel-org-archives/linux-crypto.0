Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090BB372067;
	Wed, 13 May 2026 22:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778713177; cv=none; b=JxdHsEI+jtdPveLLKjwFyAc5iNCf3CbJ9lKsKm4XzX2ixnQ+xg5/E8K7tnX09YhDFTenQvZQw0XZMH7d2feFZ+OODjG4u66wGgALyIRTnW5i9i/ZBcjFNyXSqcAFeC348e0zSfsmrQpKXkasumJSlFImZU6S05nvEbh1U+Zkkd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778713177; c=relaxed/simple;
	bh=SGGsNBa+FkvkfkdmD9n+Zm+wcVxWckVqaHO09K4J/jQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gFXAxCA9xBtPmuscqu16s2I8VV5OuB4VnDihZDagDLPGM+T6ZwniHzujMvBz58DYYdSHYmwtxDYav+2GrTkT17HdZZj389Jx4Nv/9Qi7atIPF10U6Ver0Oy51kS+qJt6uUQJABS6if5wqi4stiFDbtYZf4ZfZnJ+kiTGKSAV/YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eemScf5r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eemScf5r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F13FC19425;
	Wed, 13 May 2026 22:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778713176;
	bh=SGGsNBa+FkvkfkdmD9n+Zm+wcVxWckVqaHO09K4J/jQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eemScf5rEyYvIuw58xNli19jazjfwVZpKVn34D8nYkM9reWs/H9O5KMJ0yaEbMdCJ
	 0YoWf60XADHTYU8dvwJExh0VYTSeuyuNJ0H+XlwpU2rMckylf5SEobebiKrv/LGi6W
	 wz8HBG+EBdCNqpncF9ZPtx/Z9s6tS8WJWn0Aw2fqmImZXZwVra85Ss0ewIDYcCXFQs
	 WZ92XlmGWBOBk03U9Omj3q16JvX676glkBBGwwLmcBbVwbNJG2AKpBq+H+d8EMFCU5
	 8MNXAIsaG0ERjwA/4aiZgQrOrq/TVOEBf7BML2wsK5wiiu9JJ7Q3iN59W8tPkCSiAC
	 tYQuhjaTCvJIQ==
Date: Wed, 13 May 2026 22:59:34 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: lukas@wunner.de, ignat@linux.win, jarkko@kernel.org,
	yimingqian591@gmail.com, stable@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] lib/crypto: mpi: Fix integer underflow
 in" failed to apply to 6.1-stable tree
Message-ID: <20260513225934.GA501859@google.com>
References: <2026051223-undercoat-reps-6626@gregkh>
 <20260513025130.GA3110@sol>
 <2026051334-showgirl-hurdle-22eb@gregkh>
 <20260513170445.GA2128@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513170445.GA2128@quark>

On Wed, May 13, 2026 at 10:04:47AM -0700, Eric Biggers wrote:
> > > A couple issues.  First, this email wasn't sent to the subsystem's
> > > mailing list (linux-crypto@vger.kernel.org in this case).  That greatly
> > > reduces the number of people who are made aware that this didn't get
> > > automatically backported.
> > 
> > We never send out these FAILED emails to the mailing lists, as that
> > would make just even more noise.  It's always been this way, sorry.
> 
> Yes, this has been a problem for a long time, resulting in lots of
> missed backports including the copy.fail ones.  It's time for you to fix
> your process.
> 
> > > Second, the upstream commit cherry-picks to 6.1, 5.15, and 5.10 without
> > > conflict.  (The file being changed was renamed between 6.1 and 6.6, but
> > > 'git cherry-pick' handles that automatically.)
> > > 
> > > I don't know what you're doing exactly that caused it to be
> > > unnecessarily marked as FAILED.  But whatever it is, it's not working,
> > > and it is causing backports to be missed.
> > 
> > We don't use git for cherry-picking as we have a patch queue, so renames
> > will often times fail, like it did here.  This has always been the case
> > in the decades we have been running the stable kernels :)
> 
> Again, this has been a problem for a long time, and it's time for you to
> fix your process.  You can still have the patch queue; just use git for
> the actual cherry-pick.

Also I should mention that your own instructions for "reproducing" the
conflict use 'git cherry-pick':

    git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.1.y
    git checkout FETCH_HEAD
    git cherry-pick -x 8c2f1288250a90a4b5cabed5d888d7e3aeed4035
    # <resolve conflicts, build, test, etc.>
    git commit -s
    git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2026051223-undercoat-reps-6626@gregkh' --subject-prefix 'PATCH 6.1.y' HEAD^..

When these instructions are followed, there is no conflict.  The
"conflict" is purely because you didn't use 'git cherry-pick' yourself.

So just start using 'git cherry-pick', and stop asking other people to
do it for you when there are no conflicts, please.

And please start Cc'ing the mailing lists.  Linux kernel development
isn't done in private email.  I would have backported the copy.fail
fixes earlier, but I never received the FAILED emails (which I'm
guessing you sent, but only in private email to other people), so I
didn't know they weren't being backported...

- Eric
