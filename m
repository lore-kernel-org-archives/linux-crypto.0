Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1160332ED57
	for <linux-crypto@vger.kernel.org>; Fri,  6 Feb 2026 10:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770375400; cv=none; b=WJO2+J1ly46b2hbPA0Ya4Czc46aLsYcHu/uNPH90FssM8I+oHulL0quJxScuuquCBeqdozqQmAk/bfVHd1kDm/uiybTfTW35lvIoBuKblh6gd/vj3nuvUEOEMdXW+x78MKrbjCCtr+yXi2DCcnQms6/B9Avntdk/tG/8ANRu2Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770375400; c=relaxed/simple;
	bh=aZl8IAnz0pZeeMfLUlvBAGgM2DlLQ/LBzYOhQVy6uP4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nIDpprI1EeHJMkGCvCj2wnICLM6sJw3YvkqGLT//694sNpOkU50kaDAkKucpcNXLnYDbCUBPvO1rNRwAwfE/hlGlRbfct8zrg3Xw0wyVp1bEYhYL22FNmmMuXwDfwmI7l3p9bLQZ/Eih19TmlA6jFgQluurEJwo8Gvxu+lA3ZSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=hzf3kaAT; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="hzf3kaAT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=lxTPj3ZxZPl0lKFs8oJBJhIi2w6Kxr95PSqhAoYw8XI=; 
	b=hzf3kaATcpHRgF8F3kDcC1i92m9AAo0BDhUSfGKT74l+LHuqtGTa1b9Pjh0w4xDjknJFXMrKppz
	RAjXfpAvSBITWQoHhsKKYQljHWFrP6O2kU4/8hwVNyHhW4BSG+NutQgYYX+V/mSfSSHihAAN0+ETi
	Al1zSqc1YRhReoF1zRKxY8HA0lY/9L84RRlfz8sfp8NBCv13M7OGNABoaAfYyUq3wiVM+D+Uk1nDq
	lCzNVBDo5rqOjYpyBEjXOOXvex6rHV2WIRiWSTcNF8Xt7+nEHYnSI9K3g3jU3T3FkbWSqKip+CpPj
	9SmsjusjEjia/habdFWo55Wry6XxQoJ/J2qQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1voJVk-004zSi-1m;
	Fri, 06 Feb 2026 18:56:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Feb 2026 18:56:28 +0800
Date: Fri, 6 Feb 2026 18:56:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Mario Limonciello (AMD)" <superm1@kernel.org>
Cc: mario.limonciello@amd.com, thomas.lendacky@amd.com, john.allen@amd.com,
	davem@davemloft.net, Mark Pearson <mpearson-lenovo@squebb.ca>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: ccp - Add sysfs attribute for boot integrity
Message-ID: <aYXI3PumDNvT1AxK@gondor.apana.org.au>
References: <20260123033457.645189-1-superm1@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123033457.645189-1-superm1@kernel.org>

On Thu, Jan 22, 2026 at 09:34:53PM -0600, Mario Limonciello (AMD) wrote:
> From: Mario Limonciello <mario.limonciello@amd.com>
> 
> The boot integrity attribute represents that the CPU or APU is used for the
> hardware root of trust in the boot process.  This bit only represents the
> CPU/APU and some vendors have other hardware root of trust implementations
> specific to their designs.
> 
> Link: https://github.com/fwupd/fwupd/pull/9825
> Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> ---
>  Documentation/ABI/testing/sysfs-driver-ccp | 15 +++++++++++++++
>  drivers/crypto/ccp/hsti.c                  |  3 +++
>  drivers/crypto/ccp/psp-dev.h               |  2 +-
>  3 files changed, 19 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
