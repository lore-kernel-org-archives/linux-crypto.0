Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211616;
	b=Q7wXXk2r9K/INH22D5gRUPPdPulMpz7/UvdXksT0eluDs0Q22JxMVQOkP8wcvZ6Rsxyu
	 qFQh/t0c38RZk++imuBI5UtY8yolfk9ftefmWfRRxJg/JtjhSldNZN69EMj22It4IgE9j
	 H8N93Zdo0Lu3p/xX3rI0lioBEP6mhcy6Q0RbhJhAyNVAbvprhmuduu27S+wtDdFPUDILQ
	 Dyfl7oqV1LX1TirIpT9ZkW/4fXJ2YLUR3JZLOrFf7uLJOkkpeW6Eak9EZcBByC3SOrvhc
	 TDvTRHe+GMXzONTXWQ+jdglxqF0jY1nxFsoDlck7TsJxBGOgaKsYNOxXJvILXI2PqEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211616;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=CFK0bHIx//cx8sRRThyrjkkVTccO/azrN5XQVnxuXSM=;
	b=sFMDd9pt2t+WmPDdaqiLR9SVvH/CpoaM7/jGftWs9bOXwj3H80YfJR8o/u8Un6pIC4uq
	 hzedZ3coOni4lk13Vk0qtCGJZc9v6B17Boe9sSvO6lWZFtCiEaT2JGX4lCoeaGilcVXZN
	 8utprJtd5dk4pX/el1pF05pISIzDSR0TYzmScoFBVtXyFDkax+R0osNh07GEdGV0FKFNF
	 sCbPndGkYxasCf/CEIzSRcVAZEzCn7Cpyb6CykS7tBlaOEGYcYWKqC/A7uR4VPQuaQwkM
	 c5WfEHmUjMFzxNYFD/FcHthMwL8WuKjpFQ5vkBwB596gIN5jx3FDh48HaGj4DCiNEng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TzEA3rNu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0023E606A31D;
	Wed, 28 Oct 2026 18:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TzEA3rNu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 908211F01828;
	Wed, 28 Oct 2026 18:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793211615;
	bh=CFK0bHIx//cx8sRRThyrjkkVTccO/azrN5XQVnxuXSM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TzEA3rNuiQLjrVCIdnlvJJQeVsoGMufpwbfW3Iui7e2Av6ZpAs3kZmhts2pI3ZgOy
	 mrPsgZN+r3mAT1I7d5ptmjTWjw18dimz3mbflAAQBAzNN5DbjImHzhg4ERWHWUngMu
	 Fvs6f+ENWjOruRtiGqt6A2Bd+2cEyA50UqusqJGaPZL1lG3uoa03U7iEiEPl/dfHcn
	 28oh1VmNowV5ozpU0GeSaRyMkHaZCawba6ee1BhyAhHxPYMi1A2D2zmhFiviTQOBsf
	 nEZkf1WnbWy2OcMKtRLMWWCGSph0psXbh7rWD+w//fZ5+rokeDOoWl2s6+xerAKOvg
	 MF7ncu4inJxqg==
Date: Wed, 28 Oct 2026 11:20:14 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: gregkh@linuxfoundation.org
Cc: Jeremy.Jean@oss.cyber.gouv.fr, Jason@zx2c4.com, stable@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] lib/crypto: arm64: Fix lost Poly1305
 carry when resuming NEON" failed to apply to 6.12-stable tree
Message-ID: <20261028182014.GE1876@quark>
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
> 
> This process is buggy compared to simply using 'git cherry-pick':
> 
> - It has no rename detection.  Any file rename, like what happened for
>   this commit where poly1305-armv8.pl is in different locations in
>   different branches, results in FAILED.  This happens regularly.
> 
> - Incorrect backports due to only *one* line of context being
>   considered (since 3 - 2 = 1).  For examples of this, see
>   https://lore.kernel.org/all/20260512173933.811124271@linuxfoundation.org/
>   and
>   https://lore.kernel.org/all/20260515154719.961677988@linuxfoundation.org/
> 
>   This is easily reproducible.  For example for the first one:
> 
>   git checkout -d v6.12.87
>   git cherry-pick 2909f0d4994fb4306bf116df5ccee797791fce2c
>   git show # correct backport
> 
>   git checkout -d v6.12.87
>   git format-patch -1 --no-base 2909f0d4994fb4306bf116df5ccee797791fce2c
>   patch -p1 < 0001-usb-typec-tcpm-reset-internal-port-states-on-soft-re.patch
>   git diff # incorrect backport that was actually sent out
> 
>   The second example is even worse, as there the incorrect backport was
>   actually released.
> 
> Just using 'git cherry-pick', as contributors are already being asked to
> do in the FAILED emails themselves, avoids these problems.
> 
> Can this please be fixed?  This outdated cherry-pick process is reducing
> the quality of the stable releases.

Any update on this from the stable maintainers?  Requiring resends for
clean cherry-picks is a waste of time for everyone, among other issues I
mentioned.

- Eric
