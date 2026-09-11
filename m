Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E06F3148CF;
	Fri, 11 Sep 2026 05:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789104586; cv=none; b=uKr3R1qvPNhJOSMYt9e1Gyk6wMQD2T1QdZ0Vm4EerRt7I85Kl5lGzSYeAfLpP10Vdu0P/YI+gW0kGQLsEUy/XRoVugXRfoh35/9r0rVdeViEhSF13nNc4SRCdfjjAbzCVQDUES1nirwpyTW/LqfDCA4hu1icjJGtXq/iYK4+DNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789104586; c=relaxed/simple;
	bh=UVm3UijNZnei1xaCdiJpBw7KE0glJ7jNnfs5WbGloeg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GhZm07oJGMIM4RrN7CSszQA8bYnupnOzFhelHNx/VmNgrW3BpgA6xBJS6XV6K866AxwUe8+rIc5wUzn3xctRRmrD/dCwi0oL1EVJcPPucabtSFVpULrDsSqxHMaP80ea4V13xOxtoawUq+3vRl09q0tJDF2dcJkHi/5QnlcL/TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=ONLiLJSp; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="ONLiLJSp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=eAkmSFxEapr/OWEzeHTZRFq6RfOULXKfw/VYTwth8bI=; 
	b=ONLiLJSpewQtgDqGoRdoeaEzn8YVSOLdeighfjbG+T89vBc31mRvWLbfFIZPAzRFoHBUXfB8Zyf
	UlPhyM+XKIDWd/J5vHH32HZIsxSmPgec5qsA51QPtmAXmbt+Xb9SZv4LLbu5u88+FS90O5y+Pz3UH
	1L+vdRr32OIIPfHu7XDnIx9R76ySqMgLSFUyQnldk8j7VLZWpRSYv5bteaIdDBj8P49stHCwRHmD7
	uQXEzr98lb3CvYCDElxaBX34f65ehze2za4z834EAN241Y+O0t1uY4r+fpWEAticm4tqMYyx+YwZ1
	YMt7lAziwlfIzLtDV55CaUeP6KRsnVqhES4A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x4tpP-0000000Cu8A-2TFC;
	Fri, 11 Sep 2026 13:29:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Sep 2026 15:29:35 +1000
Date: Fri, 11 Sep 2026 15:29:35 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linmao Li <lilinmao@kylinos.cn>
Cc: "David S. Miller" <davem@davemloft.net>, Frank Li <Frank.Li@nxp.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	Fabio Estevam <festevam@gmail.com>,
	Leonard Crestez <cdleonard@gmail.com>,
	Radu Solea <radu.solea@nxp.com>,
	Franck LENORMAND <franck.lenormand@nxp.com>,
	linux-crypto@vger.kernel.org, imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: mxs-dcp: handle zero-length skcipher requests
Message-ID: <aqORv0iyPUE2qKep@gondor.apana.org.au>
References: <20260828093209.3179074-1-lilinmao@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260828093209.3179074-1-lilinmao@kylinos.cn>

On Fri, Aug 28, 2026 at 05:32:09PM +0800, Linmao Li wrote:
> Zero-length skcipher requests are valid no-ops, but MXS-DCP queues them.
> When such a request reaches the worker, last_out_len remains zero. The
> CBC completion path then subtracts AES_BLOCK_SIZE from this unsigned
> value when updating the IV, causing the offset to underflow. On
> decryption, the resulting source address precedes aes_in_buf.
> 
> Return success before enqueueing zero-length requests. This avoids the
> invalid source access and leaves the IV unchanged for a no-op.
> 
> Fixes: fadd7a6e616b ("crypto: mxs-dcp - Fix AES issues")
> Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
> ---
>  drivers/crypto/mxs-dcp.c | 3 +++
>  1 file changed, 3 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
