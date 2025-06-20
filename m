Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A153B229B27;
	Fri, 20 Jun 2025 10:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750416948; cv=none; b=ihcRd4qIzyBiJ0ElHD5eMSedU08SUWsOZ3n1hPA3Gf6MOkFQ6yWL9sVBIAYPZK3Lmrk0XBKmwJLG4H1cYC2jrCQgEQruhuuQNXIXxIel8r79vHE2KeWIkpqszU1hmGZCbpI66wCIlNCywCQguivQxcGEK2Z8GibRNln/QD7P3gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750416948; c=relaxed/simple;
	bh=k97+mPlv7DCXcx0kQwSS6z/Atoes8Yz92s3zVuX//jE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f4ajUHWbDXJvp7fmyykYnVNQyJmFSN7yNqwLNcH4xIcHHlwRFNaFvxxYqbyQzGr8tpFFchq5cpGNtZGj8/G1uMo+aDx53bjd+APLKHntDHr4ecN5q7RV5KyLc5p3QW1nj9hEZNnt02+wMczejXNI6Jm6DOWtYn8RQDSpp0zW46g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UBj7cyBc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UBj7cyBc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 629ACC4CEED;
	Fri, 20 Jun 2025 10:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750416948;
	bh=k97+mPlv7DCXcx0kQwSS6z/Atoes8Yz92s3zVuX//jE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UBj7cyBcXOTbJyypjPgMlL4vh9t4/aIP3lqJoS/sOrDz0zRH7ylnpO7jYOxwDZOjv
	 Nf+6MlDY7DcWyA77A6RoQVNDkhADEX6/ucCUUYcyF0SnkputbY8Q7YFi4Wgrb1urBl
	 /TPQKtQ659VWsiZsEfLH4Dk8LapkK+hB+tAepGhMbiV+YtUnfE2n9sL+JQNbau4lou
	 xWKQj7wNawfl6TgMwPOpYPflLAzhrmKOwlolW+2r/7PI+qGGzBXU5QTF1W85uQxzO2
	 wktXu3HoidxlK7HwmLXVx/heg7cXppdzNMICiFvxsxk81vKfV6MU1ZrfClMr8G0Np8
	 I1AG5mai4pczw==
Date: Fri, 20 Jun 2025 11:55:44 +0100
From: Simon Horman <horms@kernel.org>
To: Tanmay Jagdale <tanmay@marvell.com>
Cc: davem@davemloft.net, leon@kernel.org, sgoutham@marvell.com,
	bbhushan2@marvell.com, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
	Rakesh Kudurumalla <rkudurumalla@marvell.com>
Subject: Re: [PATCH net-next v2 05/14] octeontx2-af: Add support for CPT
 second pass
Message-ID: <20250620105544.GI194429@horms.kernel.org>
References: <20250618113020.130888-1-tanmay@marvell.com>
 <20250618113020.130888-6-tanmay@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250618113020.130888-6-tanmay@marvell.com>

On Wed, Jun 18, 2025 at 04:59:59PM +0530, Tanmay Jagdale wrote:
> From: Rakesh Kudurumalla <rkudurumalla@marvell.com>
> 
> Implemented mailbox to add mechanism to allocate a
> rq_mask and apply to nixlf to toggle RQ context fields
> for CPT second pass packets.
> 
> Signed-off-by: Rakesh Kudurumalla <rkudurumalla@marvell.com>
> Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>

...

>  void rvu_apr_block_cn10k_init(struct rvu *rvu)
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c

...

> +int
> +rvu_mbox_handler_nix_lf_inline_rq_cfg(struct rvu *rvu,
> +				      struct nix_rq_cpt_field_mask_cfg_req *req,
> +				      struct msg_rsp *rsp)
> +{
> +	struct rvu_hwinfo *hw = rvu->hw;
> +	struct nix_hw *nix_hw;
> +	int blkaddr, nixlf;
> +	int rq_mask, err;
> +
> +	err = nix_get_nixlf(rvu, req->hdr.pcifunc, &nixlf, &blkaddr);
> +	if (err)
> +		return err;
> +
> +	nix_hw = get_nix_hw(rvu->hw, blkaddr);
> +	if (!nix_hw)
> +		return NIX_AF_ERR_INVALID_NIXBLK;
> +
> +	if (!hw->cap.second_cpt_pass)
> +		return NIX_AF_ERR_INVALID_NIXBLK;
> +
> +	if (req->ipsec_cfg1.rq_mask_enable) {

If this condition is not met...

> +		rq_mask = nix_inline_rq_mask_alloc(rvu, req, nix_hw, blkaddr);
> +		if (rq_mask < 0)
> +			return NIX_AF_ERR_RQ_CPT_MASK;
> +	}
> +

... then rq_mask is used uninitialised on the following line.

Flagged by clang 20.1.7 with -Wsometimes-uninitialized, and Smatch.

> +	configure_rq_mask(rvu, blkaddr, nixlf, rq_mask,
> +			  req->ipsec_cfg1.rq_mask_enable);
> +	configure_spb_cpt(rvu, blkaddr, nixlf, req,
> +			  req->ipsec_cfg1.spb_cpt_enable);
> +	return 0;
> +}

...
