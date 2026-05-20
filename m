Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5D22C15AB;
	Wed, 20 May 2026 16:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295608; cv=none; b=kjPVcZmh/DFdulHXxnGtOQ9TUi9TAhdjgP2QSSSu1h42B384x06BqUGlXz/Yqo2ISERjFAxdamQxZ+fP6yOuOH0nrJpz2opVTXYLfDD9aRBd9sQJVyyO29EaK1A7JHPevh5DzRoTvb9H9ZtBJtAAt5YCig4UM/sXZuvK+UnSE1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295608; c=relaxed/simple;
	bh=lcSoNqYa5+hMUm1alIxu3FTkVDjmU2wHzwnRzAlbpr8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JlYd55B8ibpOzvPum0WHCCdbZWI5xIQ1l1b5vzz1cuPVGNmUwJo9HwfCtTu7WcpGTnBWiVQBym74EPIt4CQQ5l6TRuYnfXfNBgxq8jl6e6GhJ6NLMUKUNlFXGeDXAfzIrVLAwbQS5U+r36FWXocQLS/dmG3iluJWz/gkLqpFric=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QkWXExm7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QkWXExm7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E61C61F00894;
	Wed, 20 May 2026 16:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779295607;
	bh=g3RgmBl7qKnMEm/dw6pD/WS/pL5lnhHZMIJcZklVQIQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QkWXExm7i/XSkuIuDcvp0ZXe+wfUl6WHMnSUVPDzMATDvHlfB8xPCYDI3uGaJ+2WF
	 IfvtaiEOULpgxFNj5PONLnU65ZDR5UmqwL/GKGAVh1fO4H4KwpoYYIaP2R+ZLjFCqz
	 5F2ais3VarVMgHcYH5MBVc8O5jBQGwGtLp3Ys9V+MkFrbCttdm0kOWSE7xjGklBVul
	 tKkNmmPq8lcJBQs1UXDVsFzWBCuISqK2VWStus0bsH2dXj3aqMjQ5X2PblWOlAw2Qd
	 Cwbnr7JLqJW33EMg1TVKVP2sffGsG7WiHXlbgJYQd/6CebgUDSc/uJmTfHiUsfIoEr
	 kpaCdTtzLWr1g==
Date: Wed, 20 May 2026 10:46:44 -0600
From: Tycho Andersen <tycho@kernel.org>
To: "Pratik R. Sampat" <prsampat@amd.com>
Cc: ashish.kalra@amd.com, thomas.lendacky@amd.com, john.allen@amd.com, 
	herbert@gondor.apana.org.au, davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, aik@amd.com, nikunj@amd.com, michael.roth@amd.com
Subject: Re: [PATCH v3] crypto/ccp: Introduce SNP_VERIFY_MITIGATION command
Message-ID: <ag3lS4IB2jz7q1o1@tycho.pizza>
References: <36137b565d183fa2f2985ad098f2e2096f1c432f.1779219958.git.prsampat@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36137b565d183fa2f2985ad098f2e2096f1c432f.1779219958.git.prsampat@amd.com>

On Tue, May 19, 2026 at 02:50:29PM -0500, Pratik R. Sampat wrote:
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
