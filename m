Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE15314B63;
	Wed, 13 May 2026 02:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778640773; cv=none; b=fXI30YDXrS9YvazKGeYjqomu0tHIsITjAoDa5iBh/zhvdSlUD4MKXZSXCd5vmGdBxSC3XMWLlOnZaHLnLZNvmvZOtTcbxdHhEYgwCuPyk43IuMlZVIwn/4oRBNss6zOpZO43dUELgq2YKyxNw8rtX9ihHSyy1BOXahHiuJCBRL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778640773; c=relaxed/simple;
	bh=2676fvscMyjK0OHdfxMRrCy/Jw9r9ZG+EZ144GRJAac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MYaDd3pNfvvgQIiF91DXt/WZVQsX/asnq5uZAlqA8PgbtvtBI+D9prFn41gKz6uN3VzFHi64LPE8nqxMQ/CxKfpmzT7RQfp+yAijcHhAZwv5DsmNfTjzm0B+40tTlddxWNHDqxTG2gRUd4gr41XuJlQebhZn0UILdjLdQLKNcB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XcnQ/Hfv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XcnQ/Hfv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED52C2BCB0;
	Wed, 13 May 2026 02:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778640773;
	bh=2676fvscMyjK0OHdfxMRrCy/Jw9r9ZG+EZ144GRJAac=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XcnQ/Hfve8mooLMOavb764ZOVphPq5/lPWXEu6rBY+IHDqJ6WweTBCBNhF0XCPOru
	 IF36sPg85LRJXDbTPo85WN3VwsYhOQmEiClVuVQ2oUuIxFKGNarkS9VvAm4vRyKnK4
	 aN/p7lzdOWxo5sjqKuv458SZqheE22c6thBqOS19meaSEDpbCSg1D+LHxNGR3kEV2+
	 EAAo7uxMCoYTbYgU5PdopOm9aTG0IJZh0y4nTAD2DNQHXRrLpCli0Kl2P+ReTMCbRI
	 KxUUNk1K5mPtRtijnskA5gldvxC6Xi2nmVlk70rc5SFqIgDMPW62HLjhE8UZ7gRyb8
	 J+0dmmzTouIqg==
Date: Tue, 12 May 2026 19:51:30 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: gregkh@linuxfoundation.org
Cc: lukas@wunner.de, ignat@linux.win, jarkko@kernel.org,
	yimingqian591@gmail.com, stable@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] lib/crypto: mpi: Fix integer underflow
 in" failed to apply to 6.1-stable tree
Message-ID: <20260513025130.GA3110@sol>
References: <2026051223-undercoat-reps-6626@gregkh>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026051223-undercoat-reps-6626@gregkh>

[+Cc linux-crypto@vger.kernel.org]

On Tue, May 12, 2026 at 04:01:23PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 6.1-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> To reproduce the conflict and resubmit, you may use the following commands:
> 
> git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-6.1.y
> git checkout FETCH_HEAD
> git cherry-pick -x 8c2f1288250a90a4b5cabed5d888d7e3aeed4035
> # <resolve conflicts, build, test, etc.>
> git commit -s
> git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2026051223-undercoat-reps-6626@gregkh' --subject-prefix 'PATCH 6.1.y' HEAD^..
> 
> Possible dependencies:

A couple issues.  First, this email wasn't sent to the subsystem's
mailing list (linux-crypto@vger.kernel.org in this case).  That greatly
reduces the number of people who are made aware that this didn't get
automatically backported.

Second, the upstream commit cherry-picks to 6.1, 5.15, and 5.10 without
conflict.  (The file being changed was renamed between 6.1 and 6.6, but
'git cherry-pick' handles that automatically.)

I don't know what you're doing exactly that caused it to be
unnecessarily marked as FAILED.  But whatever it is, it's not working,
and it is causing backports to be missed.

- Eric
