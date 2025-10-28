Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC53F308F11;
	Tue, 28 Oct 2025 10:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761648365; cv=none; b=uvtEAra1n42HYT/fswVuc7t8nwfgyKp+w+Onii7oO+cHsm8wuM5tpBjfKc1GSQHCfPWFS0zpkZ1/aqxwMV+Hra/pqZITFe5V1aKtj47TUWcSUGMyi/dtXlTdIdNiiVqlZjJrSdz89+ZZ2hR7097pd+M3aEgUQNooRAVHIt8Wchg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761648365; c=relaxed/simple;
	bh=OR+uAfcQw2O6nFilneRt7rzxEcwejJ3fRf5OkOr0ieo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kjqNnBBSmyViu4pJK24Xf2owPsode0NnM6MnN6JpvzmUM1tvXQBgkciWINIfasTE0A9kFdtyowqqC/1cA1CDF83P0lJ++QDGZGamHP2Os5aXqvdZZKxEJPhQmE0AYB3X2U0cv7UWzrZ8kyDPMBWTWO9VZO7WPe/pktxSqAiwcHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c343zk4h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c343zk4h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6753AC4CEF7;
	Tue, 28 Oct 2025 10:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761648363;
	bh=OR+uAfcQw2O6nFilneRt7rzxEcwejJ3fRf5OkOr0ieo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c343zk4hY5mLI5zerO+zyY1QXAk/0q0p6I6PslbbeSJpGbJjw6YztTZvSr0e6buJF
	 lHru3CLDS7Aq3CVCWGiMonqy3+EBkCcaU5BT9pyiV2DZtPhRdwIxich/veZ2PtmkGd
	 E/pmpc4qVBUjJBfkT+SnhbWkJmmuXeEengv74MES4zuFs0qO+vuE/ZuwRfC2pLYQpS
	 aHT+hrSdmK2Q0SOjPHWC9mR1Pkp0/vK+YxMZa8lOhsqTJ0HoIZ9PN1PEKGzdOmVGkF
	 wlzNayTjmoQr3F1Lzi9ObJ0f0/RHhduYHlmbjeJPkcpe9uYy/vPQ8rRTWZ8BxGnrxE
	 smPPTmedVXG4w==
Date: Tue, 28 Oct 2025 10:45:59 +0000
From: Simon Horman <horms@kernel.org>
To: Tanmay Jagdale <tanmay@marvell.com>
Cc: davem@davemloft.net, leon@kernel.org, herbert@gondor.apana.org.au,
	bbhushan2@marvell.com, sgoutham@marvell.com,
	linux-crypto@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v5 08/15] octeontx2-pf: ipsec: Setup NIX HW
 resources for inbound flows
Message-ID: <aQCe50-IRGsxbqUv@horms.kernel.org>
References: <20251026150916.352061-1-tanmay@marvell.com>
 <20251026150916.352061-9-tanmay@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251026150916.352061-9-tanmay@marvell.com>

On Sun, Oct 26, 2025 at 08:39:03PM +0530, Tanmay Jagdale wrote:

...

> +static int cn10k_ipsec_setup_nix_rx_hw_resources(struct otx2_nic *pfvf)
> +{
> +	int rbsize, err, pool;
> +
> +	mutex_lock(&pfvf->mbox.lock);
> +
> +	/* Initialize Pool for first pass */
> +	err = cn10k_ipsec_aura_and_pool_init(pfvf, pfvf->ipsec.inb_ipsec_pool);
> +	if (err)

Hi Tanmay,

Not a full review by any means, but this appears to leak mbox.lock.

> +		return err;
> +
> +	/* Initialize first pass RQ and map buffers from pool_id */
> +	err = cn10k_ipsec_ingress_rq_init(pfvf, pfvf->ipsec.inb_ipsec_rq,
> +					  pfvf->ipsec.inb_ipsec_pool);
> +	if (err)
> +		goto free_auras;
> +
> +	/* Initialize SPB pool for second pass */
> +	rbsize = pfvf->rbsize;
> +	pfvf->rbsize = 512;
> +
> +	for (pool = pfvf->ipsec.inb_ipsec_spb_pool;
> +	     pool < pfvf->hw.rx_queues + pfvf->ipsec.inb_ipsec_spb_pool; pool++) {
> +		err = cn10k_ipsec_aura_and_pool_init(pfvf, pool);
> +		if (err)
> +			goto free_auras;
> +	}
> +	pfvf->rbsize = rbsize;
> +
> +	mutex_unlock(&pfvf->mbox.lock);
> +	return 0;
> +
> +free_auras:
> +	cn10k_ipsec_free_aura_ptrs(pfvf);
> +	mutex_unlock(&pfvf->mbox.lock);
> +	otx2_mbox_reset(&pfvf->mbox.mbox, 0);
> +	return err;
> +}

...

-- 
pw-bot: cr
