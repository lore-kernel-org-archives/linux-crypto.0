Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C612323535B;
	Wed,  7 May 2025 09:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746609566; cv=none; b=Ml31mExI4PmKwNxXTCzcoEEX0KyTvfgx8KNGdPfEoDvJEsy3/qyWG7xrvnn6yHk8qDQ5y+tCfXf0SXx18K1+HkDaSOpZF5ILQRYTwa7HtKbzXZCAuQYBpycPPJcx4pt1PxHbJEp8xERDKjnFqcCy2Vr9w7XlwNcoyQtPghyYLKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746609566; c=relaxed/simple;
	bh=xWzxV0NL2hKfTdmxVr7+NPAKQTfC6jKi+qpbaYgNWvY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sXvEe8kwm0lzI3PyOf+KOvsQfj4bAUJ9oPVUAetFVD5Nc4p0u3JBKyb6+9AAuvlO4xlVdAkRpfXyqFqJ+xLdnTgVGyAVTSyJJVztBOM6KghzzDP1iRy0hiqWud6/A9utRofUAok6n8yI4tmBDOCaM/KZ7nrZQJV4zokx6X4sHfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oFEWpuKE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oFEWpuKE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09782C4CEE7;
	Wed,  7 May 2025 09:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746609566;
	bh=xWzxV0NL2hKfTdmxVr7+NPAKQTfC6jKi+qpbaYgNWvY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oFEWpuKEGI89faBWoqvs7ujFsrFWCmfPMqcfFjdDl8AWpGvX7oiTZQO71RNmjd14s
	 dX0WQFYyVG//xYFxUbCN/27O6gETEm1jX55W2vhZme43PKIgG9KdLutb2wtwvjJVbx
	 Ynhz02nWsG+xdgfvmaW2+X6wZUBFZpnyLttiCFMQmLgKxlo2vGyiVUXM+qs+72XCy9
	 2AaHqchsrWVvazIDDUD6Qm6IVgWGDE/w2qN4G9xMzgtbpbt/5lV5Nppof7iBXNJchJ
	 wrsm9aBXChh63y57uDyDfY5IpwdoDQ2ydUkbDf/el3nby/EEAur3fslrNcttn4p0bK
	 pQ5Su+hCnTLyg==
Date: Wed, 7 May 2025 10:19:18 +0100
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
	gcherian@marvell.com
Subject: Re: [net-next PATCH v1 04/15] octeontx2-af: Handle inbound inline
 ipsec config in AF
Message-ID: <20250507091918.GZ3339421@horms.kernel.org>
References: <20250502132005.611698-1-tanmay@marvell.com>
 <20250502132005.611698-5-tanmay@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250502132005.611698-5-tanmay@marvell.com>

On Fri, May 02, 2025 at 06:49:45PM +0530, Tanmay Jagdale wrote:
> From: Bharat Bhushan <bbhushan2@marvell.com>
> 
> Now CPT context flush can be handled in AF as CPT LF
> can be attached to it. With that AF driver can completely
> handle inbound inline ipsec configuration mailbox, so
> forward this mailbox to AF driver.
> 
> Signed-off-by: Bharat Bhushan <bbhushan2@marvell.com>
> Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
> ---
>  .../marvell/octeontx2/otx2_cpt_common.h       |  1 -
>  .../marvell/octeontx2/otx2_cptpf_mbox.c       |  3 -
>  .../net/ethernet/marvell/octeontx2/af/mbox.h  |  2 +
>  .../ethernet/marvell/octeontx2/af/rvu_cpt.c   | 67 +++++++++----------
>  .../ethernet/marvell/octeontx2/af/rvu_reg.h   |  1 +
>  5 files changed, 34 insertions(+), 40 deletions(-)
> 
> diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
> index df735eab8f08..27a2dd997f73 100644
> --- a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
> +++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
> @@ -33,7 +33,6 @@
>  #define BAD_OTX2_CPT_ENG_TYPE OTX2_CPT_MAX_ENG_TYPES
>  
>  /* Take mbox id from end of CPT mbox range in AF (range 0xA00 - 0xBFF) */
> -#define MBOX_MSG_RX_INLINE_IPSEC_LF_CFG 0xBFE
>  #define MBOX_MSG_GET_ENG_GRP_NUM        0xBFF
>  #define MBOX_MSG_GET_CAPS               0xBFD
>  #define MBOX_MSG_GET_KVF_LIMITS         0xBFC
> diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
> index 5e6f70ac35a7..222419bd5ac9 100644
> --- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
> +++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
> @@ -326,9 +326,6 @@ static int cptpf_handle_vf_req(struct otx2_cptpf_dev *cptpf,
>  	case MBOX_MSG_GET_KVF_LIMITS:
>  		err = handle_msg_kvf_limits(cptpf, vf, req);
>  		break;
> -	case MBOX_MSG_RX_INLINE_IPSEC_LF_CFG:
> -		err = handle_msg_rx_inline_ipsec_lf_cfg(cptpf, req);
> -		break;
>  
>  	default:
>  		err = forward_to_af(cptpf, vf, req, size);

This removes the only caller of handle_msg_rx_inline_ipsec_lf_cfg()
Which in turn removes the only caller of rx_inline_ipsec_lf_cfg(),
and in turn send_inline_ipsec_inbound_msg().

Those functions should be removed by the same patch that makes the changes
above.  Which I think could be split into a separate patch from the changes
below.

> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h

...

> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c

...

> @@ -1253,20 +1258,36 @@ int rvu_cpt_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int lf, int s
>  	return 0;
>  }
>  
> +static void cn10k_cpt_inst_flush(struct rvu *rvu, u64 *inst, u64 size)
> +{
> +	u64 val = 0, tar_addr = 0;
> +	void __iomem *io_addr;
> +	u64 blkaddr = BLKADDR_CPT0;

nit: Please use reverse xmas tree order - longest line to shortest -
     for local variable declarations in new Networking code.

     Edward Cree's tool can be useful here.
     https://github.com/ecree-solarflare/xmastree/

> +
> +	io_addr	= rvu->pfreg_base + CPT_RVU_FUNC_ADDR_S(blkaddr, 0, CPT_LF_NQX);
> +
> +	/* Target address for LMTST flush tells HW how many 128bit
> +	 * words are present.
> +	 * tar_addr[6:4] size of first LMTST - 1 in units of 128b.
> +	 */
> +	tar_addr |= (__force u64)io_addr | (((size / 16) - 1) & 0x7) << 4;

I see this pattern elsewhere. But, FWIIW, I don't think it
is entirely desirable to:

1) Cast away the __iomem annotation
2) Treat a u64 as an (io?) address
3) Open code the calculation of tar_addr, which
   also seems to appear in several other places.

If these things are really necessary then I would
put them in some combination of cn10k_lmt_flush(),
helpers, and wrappers.

But as this is consistent with code elsewhere,
perhaps that is a topic for another time.

> +	dma_wmb();
> +	memcpy((u64 *)rvu->rvu_cpt.lmt_addr, inst, size);

FWIIW, I'm not sure that treating a u64 (the type of lmt_addr) as
an address is best either.

> +	cn10k_lmt_flush(val, tar_addr);
> +	dma_wmb();
> +}
> +
>  #define CPT_RES_LEN    16
>  #define CPT_SE_IE_EGRP 1ULL
>  
>  static int cpt_inline_inb_lf_cmd_send(struct rvu *rvu, int blkaddr,
>  				      int nix_blkaddr)
>  {
> -	int cpt_pf_num = rvu->cpt_pf_num;
> -	struct cpt_inst_lmtst_req *req;
>  	dma_addr_t res_daddr;
>  	int timeout = 3000;
>  	u8 cpt_idx;
> -	u64 *inst;
> +	u64 inst[8];
>  	u16 *res;
> -	int rc;

nit: reverse xmas tree here too.

>  
>  	res = kzalloc(CPT_RES_LEN, GFP_KERNEL);
>  	if (!res)

...
