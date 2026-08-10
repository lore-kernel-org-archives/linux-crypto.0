Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881BA3A48ED;
	Mon, 10 Aug 2026 08:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786350980; cv=none; b=gjXzOV441aPY9bP9hIbPS5VSNNgXtWGFmS+MlLNBXfb7VazR6GFR3hvgdh7aJW9VE0/uIfcbE1BhdzXMhsOJlcaCCOWb3hS3l0V0HV+VMs1zFzfED5VITCJhjv1CQozRwbHCH7O1ZCgSkWFDQi/OJ1UjHiqBXMqO3fF6HDTnu3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786350980; c=relaxed/simple;
	bh=07dgQZDQnmO+W/r4vpKnsxRITUi+F2Diyczkax9ESpE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PP95uORgUq0el61USnas79g1GuTMPOchDJKay4sxZUpNn22WEfb0cyxO3ZjUgx89xzGKE1YQS6f6+sJqZprSQyz/zLs/fJ3jNHTAQNc5BcyXo1p/jVL5xH8Q/0JV1jrHEThyj45mbi4dAjGbubMmaPhuq6b5iCZo4hit7h2RfK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=HFwb3f0h; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="HFwb3f0h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=m3TAYLcwrDJnMeBY3Y4lUUYmO5fDhCMRki3TfcqwLhw=; 
	b=HFwb3f0h+3AtoudeUJKtv+jjdYLSPxiv+jaEqab7x3GAbJthJFXS7tclcW+AvWfoBDclWTh5Pta
	ypcLrRo9STqmt1D7Qt/6Yr+nqgJu0evtU9GbzNz1Qoba/hpw31/afk9k/PAKwitGSmxsrHUR33YkU
	d+RvAVJVXEME+UpY59S9reu4kflQxj8c+hJksNeKdp5CWfpUN0nJhuLtqGtQNPAnTqCYrC+CZ7opb
	57KuiAc9pCLDP2OpFl9kHdZac8nAFtZwInJJhcYZATRQsBnXrlMCv8KejW5py8CCZ3je/JLdGthwh
	ggtVmf6zQALVmg21AOS4UF5yQvmrB/7jUBIA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wtLUQ-00000003Wsh-18HJ;
	Mon, 10 Aug 2026 16:36:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 10 Aug 2026 18:36:10 +1000
Date: Mon, 10 Aug 2026 18:36:10 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yuho Choi <dbgh9129@gmail.com>
Cc: olivia@selenic.com, Frank.Li@nxp.com, s.hauer@pengutronix.de,
	kernel@pengutronix.de, festevam@gmail.com,
	linux-crypto@vger.kernel.org, imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	dakr@kernel.org, o-takashi@sakamocchi.jp, bhelgaas@google.com
Subject: Re: [PATCH v1] hwrng: imx-rngc: Disable clock on registration failure
Message-ID: <anmNevLkVPRAHTjD@gondor.apana.org.au>
References: <20260802222259.577200-1-dbgh9129@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260802222259.577200-1-dbgh9129@gmail.com>

On Sun, Aug 02, 2026 at 06:22:59PM -0400, Yuho Choi wrote:
> The RNGC clock is enabled manually before runtime PM is configured. If
> devm_hwrng_register() fails, probe returns without disabling the clock.
> The devm_pm_runtime_enable() cleanup only disables runtime PM and does not
> call imx_rngc_suspend().
> 
> Disable the clock before returning from this failure path.
> 
> Fixes: 7a96a64e8689 ("hwrng: imx-rngc - add runtime pm")
> Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
> ---
>  drivers/char/hw_random/imx-rngc.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
