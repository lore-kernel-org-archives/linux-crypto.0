Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435BD257AF6;
	Wed,  7 May 2025 12:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746621390; cv=none; b=r/a84wLqZaOpkENZ3BheIcfTM5wTJRHIGXxAbuFN+5igqyCGPdoRyzTkglmxTzr9yxDk6o5zTf6rkP8EksNeJq+XOuBzAe9hBLiMf6HoLsBS78Sha2zO1YYPMgjtZXnNc2MgSirV9tV5DrYup21WtKArfp1xb9xuuSEeQpAbq6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746621390; c=relaxed/simple;
	bh=MwSEEjKCjF/7nGabal+tGMtp0qVnx0UYQgD2hVtyBfk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gASyehfRM8U7b/dLowJq7RYrj60YoMtyCKEFSQ3+5dgVvvyBeAkckHm0G6PyapY88O1CZOjCp9lzAZKblxDNMpng0k/U/lmxqpVPXl7IxPkRagYdowDo58FspKx13CTAhKHGV1STd4aQaY2xqm14BgPkXbAYdFYVGHVuOON3Yos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nh4etkXD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nh4etkXD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF24C4CEE7;
	Wed,  7 May 2025 12:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746621389;
	bh=MwSEEjKCjF/7nGabal+tGMtp0qVnx0UYQgD2hVtyBfk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Nh4etkXD2QmdXeFIxepaVQ36xE/CnoqL71J4FagfBBbAJsZH9WfLTDXPDHB7PMjNQ
	 0Ey6JCc5Cty+Ne91cafy6vhdUgF9t/0UDambHAc0jt0Y+7lmZdzxXzwivE1+MCffeA
	 /l4MHYO9yaCaueOyI/2h2/CMqptIWq7QNgHMKXVkeazg/LdYmjcORZh/kQqQ8VQINx
	 4QlwnqJVsaIqTYShXwG+epsnC9Pj1pRvyHmnM8BK6E1WlbkCLGoJ7CWk5Mr3Zb/EiN
	 Mwlpzt5drHPEuaRZYEAeSyIV+SYm6FFHiN3FPuMB3vO+/EXKF2g3yPIAwjFbQ6fgvo
	 zmzfu0CrynEvg==
Date: Wed, 7 May 2025 13:36:22 +0100
From: Simon Horman <horms@kernel.org>
To: Tanmay Jagdale <tanmay@marvell.com>
Cc: bbrezillon@kernel.org, arno@natisbad.org, schalla@marvell.com,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
	jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
	andrew+netdev@lunn.ch, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, bbhushan2@marvell.com, bhelgaas@google.com,
	pstanner@redhat.com, gregkh@linuxfoundation.org,
	peterz@infradead.org, linux@treblig.org,
	krzysztof.kozlowski@linaro.org, giovanni.cabiddu@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, rkannoth@marvell.com, sumang@marvell.com,
	gcherian@marvell.com, Rakesh Kudurumalla <rkudurumalla@marvell.com>
Subject: Re: [net-next PATCH v1 06/15] octeontx2-af: Add support for CPT
 second pass
Message-ID: <20250507123622.GB3339421@horms.kernel.org>
References: <20250502132005.611698-1-tanmay@marvell.com>
 <20250502132005.611698-7-tanmay@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250502132005.611698-7-tanmay@marvell.com>

On Fri, May 02, 2025 at 06:49:47PM +0530, Tanmay Jagdale wrote:
> From: Rakesh Kudurumalla <rkudurumalla@marvell.com>
> 
> Implemented mailbox to add mechanism to allocate a
> rq_mask and apply to nixlf to toggle RQ context fields
> for CPT second pass packets.
> 
> Signed-off-by: Rakesh Kudurumalla <rkudurumalla@marvell.com>
> Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>

...

> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
> index 7fa98aeb3663..18e2a48e2de1 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
> @@ -544,6 +544,7 @@ void rvu_program_channels(struct rvu *rvu)
>  
>  void rvu_nix_block_cn10k_init(struct rvu *rvu, struct nix_hw *nix_hw)
>  {
> +	struct rvu_hwinfo *hw = rvu->hw;
>  	int blkaddr = nix_hw->blkaddr;
>  	u64 cfg;
>  
> @@ -558,6 +559,16 @@ void rvu_nix_block_cn10k_init(struct rvu *rvu, struct nix_hw *nix_hw)
>  	cfg = rvu_read64(rvu, blkaddr, NIX_AF_CFG);
>  	cfg |= BIT_ULL(1) | BIT_ULL(2);

As per my comments on an earlier patch in this series:
bits 1 and 2 have meaning. It would be nice to use a #define to
convey this meaning to the reader.

>  	rvu_write64(rvu, blkaddr, NIX_AF_CFG, cfg);
> +
> +	cfg = rvu_read64(rvu, blkaddr, NIX_AF_CONST);
> +
> +	if (!(cfg & BIT_ULL(62))) {
> +		hw->cap.second_cpt_pass = false;
> +		return;
> +	}
> +
> +	hw->cap.second_cpt_pass = true;
> +	nix_hw->rq_msk.total = NIX_RQ_MSK_PROFILES;
>  }
>  
>  void rvu_apr_block_cn10k_init(struct rvu *rvu)
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
> index 6bd995c45dad..b15fd331facf 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
> @@ -6612,3 +6612,123 @@ int rvu_mbox_handler_nix_mcast_grp_update(struct rvu *rvu,
>  
>  	return ret;
>  }
> +
> +static inline void
> +configure_rq_mask(struct rvu *rvu, int blkaddr, int nixlf,
> +		  u8 rq_mask, bool enable)
> +{
> +	u64 cfg, reg;
> +
> +	cfg = rvu_read64(rvu, blkaddr, NIX_AF_LFX_RX_IPSEC_CFG1(nixlf));
> +	reg = rvu_read64(rvu, blkaddr, NIX_AF_LFX_CFG(nixlf));
> +	if (enable) {
> +		cfg |= BIT_ULL(43);
> +		reg = (reg & ~GENMASK_ULL(36, 35)) | ((u64)rq_mask << 35);
> +	} else {
> +		cfg &= ~BIT_ULL(43);
> +		reg = (reg & ~GENMASK_ULL(36, 35));
> +	}

Likewise for the bit, mask, and shift here.

And I think that using FIELD_PREP with another mask in place of the shift
is also appropriate here.

> +	rvu_write64(rvu, blkaddr, NIX_AF_LFX_RX_IPSEC_CFG1(nixlf), cfg);
> +	rvu_write64(rvu, blkaddr, NIX_AF_LFX_CFG(nixlf), reg);
> +}
> +
> +static inline void
> +configure_spb_cpt(struct rvu *rvu, int blkaddr, int nixlf,
> +		  struct nix_rq_cpt_field_mask_cfg_req *req, bool enable)
> +{
> +	u64 cfg;
> +
> +	cfg = rvu_read64(rvu, blkaddr, NIX_AF_LFX_RX_IPSEC_CFG1(nixlf));
> +	if (enable) {
> +		cfg |= BIT_ULL(37);
> +		cfg &= ~GENMASK_ULL(42, 38);
> +		cfg |= ((u64)req->ipsec_cfg1.spb_cpt_sizem1 << 38);
> +		cfg &= ~GENMASK_ULL(63, 44);
> +		cfg |= ((u64)req->ipsec_cfg1.spb_cpt_aura << 44);
> +	} else {
> +		cfg &= ~BIT_ULL(37);
> +		cfg &= ~GENMASK_ULL(42, 38);
> +		cfg &= ~GENMASK_ULL(63, 44);
> +	}

And here too.

> +	rvu_write64(rvu, blkaddr, NIX_AF_LFX_RX_IPSEC_CFG1(nixlf), cfg);
> +}

...

> +int rvu_mbox_handler_nix_lf_inline_rq_cfg(struct rvu *rvu,
> +					  struct nix_rq_cpt_field_mask_cfg_req *req,
> +					  struct msg_rsp *rsp)

It would be nice to reduce this to 80 columns wide or less.
Perhaps like this?

int
rvu_mbox_handler_nix_lf_inline_rq_cfg(struct rvu *rvu,
				      struct nix_rq_cpt_field_mask_cfg_req *req,
				      struct msg_rsp *rsp)

Or perhaps by renaming nix_rq_cpt_field_mask_cfg_req to be shorter.

...

> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
> index 245e69fcbff9..e5e005d5d71e 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
> @@ -433,6 +433,8 @@
>  #define NIX_AF_MDQX_IN_MD_COUNT(a)	(0x14e0 | (a) << 16)
>  #define NIX_AF_SMQX_STATUS(a)		(0x730 | (a) << 16)
>  #define NIX_AF_MDQX_OUT_MD_COUNT(a)	(0xdb0 | (a) << 16)
> +#define NIX_AF_RX_RQX_MASKX(a, b)       (0x4A40 | (a) << 16 | (b) << 3)
> +#define NIX_AF_RX_RQX_SETX(a, b)        (0x4A80 | (a) << 16 | (b) << 3)

FIELD_PREP could be used here in conjunction with #defines
for appropriate masks here too.

>  
>  #define NIX_PRIV_AF_INT_CFG		(0x8000000)
>  #define NIX_PRIV_LFX_CFG		(0x8000010)

...
