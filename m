Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBD93E4506;
	Tue,  9 Jun 2026 19:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781034524; cv=none; b=JhasCQ2l/xeU5P7cgQ70TrUOeRJzk4iC8SyqsQEd6RENC2meZSrf1XwReweueT2LP89+jb0e9eqVm31h3uWEwCPaNmcC/s+0Uwt7z6ZDlSV41fVTSVDSERJ46/olSyhfYRh67dCJe5veA5gcgyd6H/EvYGvkxfol2BbjjVieL8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781034524; c=relaxed/simple;
	bh=l6RnRIk3EoHuI0ccLk9wHhdJ8KCs2MGnEqe8d45twGM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GeebPNf6OUEjT4IucGXFRjo8DheMR0ISFfmLSgoFmlGUpNnDsuzbpNI6fFEtst2npunrs6IHvOG8UKQlwyrcX83Sfh0Fr0QTpxhufAMt8rBd/fTcBZbF94nkBBeykIHPOYqM63JmrdDlwSmZ9NaW2bdFcdbuM3BU1Tn4Iv043QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LoBQ3CcO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LoBQ3CcO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5E41F00893;
	Tue,  9 Jun 2026 19:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781034518;
	bh=0OJ5sM1KMUYbsT3crReV4OUzGvF64qijDCQxUmQDsw8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LoBQ3CcOe/TZ3ibRps5x3GbAHfp1mLlSDysppyNf4Vmz9LcbNuyAPdvb1JKi2QZBh
	 kETJLi25Q1z42goFZrWxK9iNXaAflStKonJEUp9NHhbY9cmVYs8zeva5dA/ggbbRhI
	 0PfugCkEXwPFIMBxYclXYey/e17/EaXXHUl0f0cUaQgXyRuWlT7za6RdBm4NLqhr9D
	 2CbjQIHQOrDKSaIEwzHOIwsubORfkS7pA6FxXaCyXqK/mHX1KPk2RpIE0MUDOG3vzz
	 PdFWDW87FbNrkcxs6EfxFuT8kDp5RQ8RYYkTWkh7fVmSJmCgG2d5qXwj6/N9E2Gwg6
	 lnRobxBCYTyoQ==
Date: Tue, 9 Jun 2026 13:48:34 -0600
From: Tycho Andersen <tycho@kernel.org>
To: "Pratik R. Sampat" <prsampat@amd.com>
Cc: ashish.kalra@amd.com, thomas.lendacky@amd.com, john.allen@amd.com, 
	herbert@gondor.apana.org.au, davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, aik@amd.com, nikunj@amd.com, michael.roth@amd.com
Subject: Re: [PATCH v4] crypto/ccp: Introduce SNP_VERIFY_MITIGATION command
Message-ID: <aihsp-uQrd2g5vJ0@tycho.pizza>
References: <4957b07dbb4029a4c59bb3cf35f068c36284aa48.1780693665.git.prsampat@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4957b07dbb4029a4c59bb3cf35f068c36284aa48.1780693665.git.prsampat@amd.com>

Hi Pratik,

On Mon, Jun 08, 2026 at 08:58:01PM +0000, Pratik R. Sampat wrote:
> The SEV-SNP firmware provides the SNP_VERIFY_MITIGATION command, which
> can be used to query the status of currently supported vulnerability
> mitigations and to initiate mitigations within the firmware.
> 
> This command is an explicit mechanism to ascertain if a firmware
> mitigation is applied without needing a full RMP re-build, which is most
> useful in a live firmware update scenario.
> 
> The firmware supports two subcommands: STATUS and VERIFY. The STATUS
> subcommand is used to query the supported and verified mitigation bits.
> The VERIFY subcommand initiates the mitigation process within the FW for
> the specified vulnerability. Expose a userspace interface under:
> /sys/firmware/sev/vulnerabilities/
>   - supported_mitigations (read-only): supported mitigation vector mask
>   - verified_mitigations (read/write): current verified mask; write a
>     vector to request VERIFY for that bit
> 
> The behavior of SNP_VERIFY_MITIGATION and the pre-requisites for using
> it are bug-specific. Information about supported mitigations and its
> corresponding vector is to be published as part of the AMD Security
> Bulletin.
> 
> See SEV-SNP Firmware ABI specifications 1.58, SNP_VERIFY_MITIGATION for
> more details.
> 
> Signed-off-by: Pratik R. Sampat <prsampat@amd.com>

Reviewed-by: Tycho Andersen (AMD) <tycho@kernel.org>

> +	if (dst.mit_failure_status) {
> +		dev_err(sev->dev, "Verify Mitigation - failure status: 0x%x\n",
> +			dst.mit_failure_status);
> +		return -EIO;

Elsewhere the CCP uses EIO to represent a failure to communicate with
the PSP, but here things worked, it was just in an invalid state.
Maybe worth a different errno here, -EINVAL or so.

Tycho
