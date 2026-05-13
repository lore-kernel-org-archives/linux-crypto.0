Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3196738887A;
	Wed, 13 May 2026 17:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778691888; cv=none; b=f+60IbFCGK1siC0ROhQxDEfgUAQLHsq59fGUUn9xZmUobYk7nCPtZRF3jMNNw5YbmVBfkjHCaE20epuILSsedZbKUxCUkXtJu4BPMtnxPw20LuDtAvgfIGFRfqYdd9jPgXVU4EIiGOX3lGz/qmiKsR6awvjqBtphDx2LABWgIxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778691888; c=relaxed/simple;
	bh=GypdLqU+oACmwsK8Vg+4Mujn2qGmp2FDnQaZtFaemCg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lclTCQgvvXhPkvj1ihGPoNTZD/ziJtHSF0HJz89JTGlVFQ5i1rU9oX9rYPXBTpxNjXaKD3lTPgaqcoGP91HHRavSuqEiBqMsL/mmhqUkWfzUKLTEJ8KFZq3VaF7OampB7JQxrQfCg4cy1SlzXRQuuUBk8BO8GIl6zZYOMZkT+AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZoDvSU/O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZoDvSU/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E44C19425;
	Wed, 13 May 2026 17:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778691887;
	bh=GypdLqU+oACmwsK8Vg+4Mujn2qGmp2FDnQaZtFaemCg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZoDvSU/Od2dFhbOfjKZYsrksK6pLg8V8AI90yr65ivoDN5L8nn0YvzZBHni8qhmzB
	 GIQ/hOP2Oh9GNJC0DKk2FCfCPfu33944rvnSOx3vuq4xaa8YTOeJzM9D36UBzPSxzJ
	 ey/ULlvAiPqvIMfnt8UN5q9yuAIDJmkSz36vwlxy+fFmh2F8fu6h3nZkifwKhRyvns
	 hxGWGU05+hBjZs+vstkTZfcGjSVAemMOBzupYcSeTmJGqZ4qKmp2EfhdxZ5U9mKrRx
	 H63adnSK+g33uRnsUGLmzLcsNKKmW1m7u6cFV2o2Y5tvGgSb/cE4HpipDLLrsRJ4np
	 qcfAg+A9cDz7g==
Date: Wed, 13 May 2026 10:04:45 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: lukas@wunner.de, ignat@linux.win, jarkko@kernel.org,
	yimingqian591@gmail.com, stable@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] lib/crypto: mpi: Fix integer underflow
 in" failed to apply to 6.1-stable tree
Message-ID: <20260513170445.GA2128@quark>
References: <2026051223-undercoat-reps-6626@gregkh>
 <20260513025130.GA3110@sol>
 <2026051334-showgirl-hurdle-22eb@gregkh>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026051334-showgirl-hurdle-22eb@gregkh>

On Wed, May 13, 2026 at 12:34:38PM +0200, Greg KH wrote:
> On Tue, May 12, 2026 at 07:51:30PM -0700, Eric Biggers wrote:
> > [+Cc linux-crypto@vger.kernel.org]
> > 
> > On Tue, May 12, 2026 at 04:01:23PM +0200, gregkh@linuxfoundation.org wrote:
> > > 
> > > The patch below does not apply to the 6.1-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> > > 
> > > To reproduce the conflict and resubmit, you may use the following commands:
> > > 
> > > git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.1.y
> > > git checkout FETCH_HEAD
> > > git cherry-pick -x 8c2f1288250a90a4b5cabed5d888d7e3aeed4035
> > > # <resolve conflicts, build, test, etc.>
> > > git commit -s
> > > git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2026051223-undercoat-reps-6626@gregkh' --subject-prefix 'PATCH 6.1.y' HEAD^..
> > > 
> > > Possible dependencies:
> > 
> > A couple issues.  First, this email wasn't sent to the subsystem's
> > mailing list (linux-crypto@vger.kernel.org in this case).  That greatly
> > reduces the number of people who are made aware that this didn't get
> > automatically backported.
> 
> We never send out these FAILED emails to the mailing lists, as that
> would make just even more noise.  It's always been this way, sorry.

Yes, this has been a problem for a long time, resulting in lots of
missed backports including the copy.fail ones.  It's time for you to fix
your process.

> > Second, the upstream commit cherry-picks to 6.1, 5.15, and 5.10 without
> > conflict.  (The file being changed was renamed between 6.1 and 6.6, but
> > 'git cherry-pick' handles that automatically.)
> > 
> > I don't know what you're doing exactly that caused it to be
> > unnecessarily marked as FAILED.  But whatever it is, it's not working,
> > and it is causing backports to be missed.
> 
> We don't use git for cherry-picking as we have a patch queue, so renames
> will often times fail, like it did here.  This has always been the case
> in the decades we have been running the stable kernels :)

Again, this has been a problem for a long time, and it's time for you to
fix your process.  You can still have the patch queue; just use git for
the actual cherry-pick.

- Eric
