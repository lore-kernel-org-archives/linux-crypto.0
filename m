Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60CB3FB7D8;
	Wed, 13 May 2026 10:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778668538; cv=none; b=W3MXRtyzRViFjavgipDb7jLj36qFZ2/BIRDk7bzRw52jtL96DsBC7wrJ/xC2HCgJvlFmtkB5nlhxgH6GZy9nk+0c9x1Vc5b6oPfu2aqgXrN+axi99Xkqior7O+e03BRZXmKEHgxxcsmIDbjHDQTQASJcAG6KTtJ9HEIwZHUJnTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778668538; c=relaxed/simple;
	bh=PgYUA7hyMQU35w2tWxgO7E3e+8hlDNjjRn+TL+oArtQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OowVJYnybCG+R3ItIl7qfps/tAA582gBhvE30WCFSzFHKYaW9DHByk4PZpTHLpZuG1Zi0fJrPPPH4pUSnvOFDzWfVSk4h8/h/l6vpTsHIGZBZ/3ZJjphTCxRNFnzgPnncxSsn2StPpaaScwQ12ea5YdX0XQJJebGzKGqtNE271M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X38PZ1xc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X38PZ1xc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B6EC2BCB7;
	Wed, 13 May 2026 10:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778668538;
	bh=PgYUA7hyMQU35w2tWxgO7E3e+8hlDNjjRn+TL+oArtQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X38PZ1xcaDPSmYeqJ8ExMKC51VICKf8/X0wLWhLACugcMWLX7CNi7c+lFX9Rg0On9
	 kX9/GYS+b/XLs3RXgpQuw/Z/rwVozY9hl5os0OKVcLVtBumpSLKUby/7TTROeOLbuS
	 /0EaXX8q8MYJj5CElsfGK2vGxQjVBaJIxF+A2qgc=
Date: Wed, 13 May 2026 12:34:38 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: lukas@wunner.de, ignat@linux.win, jarkko@kernel.org,
	yimingqian591@gmail.com, stable@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] lib/crypto: mpi: Fix integer underflow
 in" failed to apply to 6.1-stable tree
Message-ID: <2026051334-showgirl-hurdle-22eb@gregkh>
References: <2026051223-undercoat-reps-6626@gregkh>
 <20260513025130.GA3110@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513025130.GA3110@sol>

On Tue, May 12, 2026 at 07:51:30PM -0700, Eric Biggers wrote:
> [+Cc linux-crypto@vger.kernel.org]
> 
> On Tue, May 12, 2026 at 04:01:23PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 6.1-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > To reproduce the conflict and resubmit, you may use the following commands:
> > 
> > git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.1.y
> > git checkout FETCH_HEAD
> > git cherry-pick -x 8c2f1288250a90a4b5cabed5d888d7e3aeed4035
> > # <resolve conflicts, build, test, etc.>
> > git commit -s
> > git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2026051223-undercoat-reps-6626@gregkh' --subject-prefix 'PATCH 6.1.y' HEAD^..
> > 
> > Possible dependencies:
> 
> A couple issues.  First, this email wasn't sent to the subsystem's
> mailing list (linux-crypto@vger.kernel.org in this case).  That greatly
> reduces the number of people who are made aware that this didn't get
> automatically backported.

We never send out these FAILED emails to the mailing lists, as that
would make just even more noise.  It's always been this way, sorry.

> Second, the upstream commit cherry-picks to 6.1, 5.15, and 5.10 without
> conflict.  (The file being changed was renamed between 6.1 and 6.6, but
> 'git cherry-pick' handles that automatically.)
> 
> I don't know what you're doing exactly that caused it to be
> unnecessarily marked as FAILED.  But whatever it is, it's not working,
> and it is causing backports to be missed.

We don't use git for cherry-picking as we have a patch queue, so renames
will often times fail, like it did here.  This has always been the case
in the decades we have been running the stable kernels :)

thanks,

greg k-h
