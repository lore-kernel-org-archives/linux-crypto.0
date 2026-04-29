Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74BF33FCB06;
	Wed, 29 Apr 2026 14:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777471659; cv=none; b=jRuzHSiW3CssUa5hxYiZNboJcxOTaCX0iVkFJdF1f83pY2pc//oxno3qwb92iMRAqSh/iGDlrPxdBmvrGhhD6adc2Cy+Y4HiIpmug9j0oDkfZonz9XJ4g3Gid8J88yly5vaXCQUW+l7oz5E80AC/7i3t1ccddDlzPm3NncIQxFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777471659; c=relaxed/simple;
	bh=t+CtLWscud7YleLPv0d4CqDcLOtNX/7MHLTrIWcs/Ns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sO3kgBZUkAfJtI9BAZKP2Afe3vgtZpo5vSN19j+xVYvTDoC7WxR/9Gjs2ZBrXPf3I7H39o9Vde527At2eUytBQG1Oi4G0NuZO8tm0T+GUuIv0DlaGA9TWTWeEJVaLiiwxevK1O+Z0BTYu0N8u2IyVXtoYGOsgnmt7fnr+LPQqF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jzFWrbmh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jzFWrbmh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63DC8C2BCC4;
	Wed, 29 Apr 2026 14:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777471659;
	bh=t+CtLWscud7YleLPv0d4CqDcLOtNX/7MHLTrIWcs/Ns=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jzFWrbmh51edLTkDHtzDUCQZKNm37EC2tB9/rAxSQkX3EVdrWAZ84V2rrdWefQNsZ
	 E5wdwgWpV2Fds6URB3r6o/97bCOfrpqJtiXXBdnBL9fL4oWSW6EWjZEKP536l96n+e
	 z26yjtJjtK9P1SeRdsLcdrONTwp2nhtnSzQnUhJwK27AF0iJYlLd3I6Jq4Ou7v8AEm
	 MWiI9860SoMsqAw/Ptxu/CHI9YB9UpFRhsdOrQv17TDyFxIkrzLYbQsZAXVsDIsUiM
	 sGLLzwEZ/mt+v7rDzay93cpIqkCxOByfReeJo601C/rEaZXszU+RfyHFNj4BupPtu5
	 nk7iq/dcpoDiQ==
Date: Wed, 29 Apr 2026 08:07:36 -0600
From: Tycho Andersen <tycho@kernel.org>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Ashish Kalra <ashish.kalra@amd.com>, John Allen <john.allen@amd.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v1 1/4] crypto/ccp: Do not initialize SNP for SEV ioctls
Message-ID: <afIPW6IYp3abgwB4@tycho.pizza>
References: <20260427161507.32686-1-tycho@kernel.org>
 <20260427161507.32686-2-tycho@kernel.org>
 <26259583-bf58-439b-980b-76460e8ebece@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26259583-bf58-439b-980b-76460e8ebece@amd.com>

On Tue, Apr 28, 2026 at 04:56:36PM -0500, Tom Lendacky wrote:
> On 4/27/26 11:15, Tycho Andersen wrote:
> > From: "Tycho Andersen (AMD)" <tycho@kernel.org>
> > 
> > Sashiko notes:
> > 
> >> if SEV initialization fails and KVM is actively running normal VMs, could a
> >> userspace process trigger this code path via /dev/sev ioctls (e.g.,
> >> SEV_PDH_GEN) and zero out MSR_VM_HSAVE_PA globally? Would the next VMRUN
> >> execution for an active VM trigger a general protection fault and crash the
> >> host?
> > 
> > sev_move_to_init_state() is called for ioctls requiring only SEV firmware:
> > SEV_PEK_GEN, SEV_PDH_GEN, SEV_PEK_CSR, SEV_PEK_CERT_IMPORT, and
> > SEV_PDH_CERT_EXPORT. After the firmware command, it does SEV_SHUTDOWN on
> > the SEV firmware. Since these commands do not require SNP to be
> > initialized, skip it by calling __sev_platform_init_locked() which only
> > initializes the SEV firmware. This way SNP is not Initialized at all, and
> > HSAVE_PA is not cleared.
> > 
> > The previous code saved any SEV initialization firmware error to
> > init_args.error and then threw it away and hardcoded the return value of
> > INVALID_PLATFORM_STATE regardless of the real firmware error. This patch
> > changes it to surface the underlying error, which is hopefully both more
> > useful and doesn't cause any problems.
> > 
> > Note that it is still safe to call __sev_firmware_shutdown() directly: it
> > calls __sev_snp_shutdown_locked(), which skips SNP shutdown if SNP was not
> > initialized.
> > 
> > Fixes: ceac7fb89e8d ("crypto: ccp - Ensure implicit SEV/SNP init and shutdown in ioctls")
> > Reported-by: Sashiko
> > Assisted-by: Gemini:gemini-3.1-pro-preview
> > Link: https://sashiko.dev/#/patchset/20260324161301.1353976-1-tycho%40kernel.org
> > Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
> 
> I have a similar patch that I hadn't gotten out that added an argument to
> _sev_platform_init_locked() to skip/prevent SNP initialization. I wonder
> if adding something to sev_platform_init_args would be better? This could
> then be expanded to prevent SNP initialization if the KVM sev_snp module
> parameter was set to false.

Yeah, I will also need additional params to init_args here:
https://lore.kernel.org/all/20260427204847.112899-2-tycho@kernel.org/
so I think adding it there makes sense.

> But for a fix, this is probably simpler. It does skip some of the checks
> that _sev_platform_init_locked() has, but I think all of the checks that
> matter are performed for the paths that call sev_move_to_init_state().
> 
> Should this go to stable?

Yes, they all should as you point out, I'll add that for v2.

> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

Thanks,

Tycho
