Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB79DDC3;
	Tue,  6 May 2025 20:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746563061; cv=none; b=XKD9a8sIsE+PwzTQDqjX+5rgGI4Des/4w1MyOqlSOe+e9F2uaat6rYnqnQLoVbARVxXPsjMlR+FdKlW7qABQ2QoeodQbB/3bEmM0rOwEKd0fyOKXijAQOMDoKh5t6Pifpt3j4vOXYm9pch/MD2c0V/g9pD4zeEOb6EFqT/AHcGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746563061; c=relaxed/simple;
	bh=l1v6CxI38Sbs0Wn2qw4d4chY/tTAmamzNWgmDWXTfq8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s1XA2rW69VX6/LlENLM4RWKVSSJCZk+pKglka5UHIe7yXmsKMpaqxlPjLLDymJK93u/SO3geg+EvrEijvHRVBfT3KuGLXPYuCU19qxTYnGSD29objKPCCiV/y2L7q3PtKRPEQT1nY3dinmNV/KXJ4ZmQRF7VUC370aU+ntbQ8cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TfqAeycS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TfqAeycS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F504C4CEE4;
	Tue,  6 May 2025 20:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746563060;
	bh=l1v6CxI38Sbs0Wn2qw4d4chY/tTAmamzNWgmDWXTfq8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TfqAeycSKwJRivGnsQBkT2kU5nssyRPLF1UykW4E/HLIx4E5UUi2axO00AtHwiV+t
	 8TL76pvzBGxRZEAWjoDQIGjqTL+SHmfCz/6K9ZyUKfVksHX9vR9nm1a9tPE015v2jJ
	 xVzXOXDPxPHtwg+r9LKYT1tJ+MTtr6wxbmzRYY5SHZWnjnJLENj0hg5sy4o/O6jvTT
	 1LjYf/wjDZsHTqNvUBCGvZJLOoUp/gp8B5gwU8JiOzBt2HDqfPrJWlZ3oIa41YYhdE
	 FBvI86xiJ3UtQEnEQLum1gBpwTTjlDpOtu/cEMnO42aRPRDtwzekfcHLSqgzdGdiTZ
	 /i3B5WS3MgdDg==
Date: Tue, 6 May 2025 21:24:13 +0100
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
Subject: Re: [net-next PATCH v1 02/15] octeontx2-af: Configure crypto
 hardware for inline ipsec
Message-ID: <20250506202413.GY3339421@horms.kernel.org>
References: <20250502132005.611698-1-tanmay@marvell.com>
 <20250502132005.611698-3-tanmay@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250502132005.611698-3-tanmay@marvell.com>

On Fri, May 02, 2025 at 06:49:43PM +0530, Tanmay Jagdale wrote:
> From: Bharat Bhushan <bbhushan2@marvell.com>
> 
> Currently cpt_rx_inline_lf_cfg mailbox is handled by CPT PF
> driver to configures inbound inline ipsec. Ideally inbound
> inline ipsec configuration should be done by AF driver.
> 
> This patch adds support to allocate, attach and initialize
> a cptlf from AF. It also configures NIX to send CPT instruction
> if the packet needs inline ipsec processing and configures
> CPT LF to handle inline inbound instruction received from NIX.
> 
> Signed-off-by: Bharat Bhushan <bbhushan2@marvell.com>
> Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>

Hi Bharat and Tanmay,

Some minor feedback from my side.

...

> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> index 973ff5cf1a7d..8540a04a92f9 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> @@ -1950,6 +1950,20 @@ enum otx2_cpt_eng_type {
>  	OTX2_CPT_MAX_ENG_TYPES,
>  };
>  
> +struct cpt_rx_inline_lf_cfg_msg {
> +	struct mbox_msghdr hdr;
> +	u16 sso_pf_func;
> +	u16 param1;
> +	u16 param2;
> +	u16 opcode;
> +	u32 credit;
> +	u32 credit_th;
> +	u16 bpid;

On arm64 (at least) there will be a 2 byte hole here. Is that intended?

And, not strictly related to this patch, struct mboxhdr also has
a 2 byte hole before it's rc member. Perhaps would be nice
if it was it filled by a reserved member?

> +	u32 reserved;
> +	u8 ctx_ilen_valid : 1;
> +	u8 ctx_ilen : 7;
> +};
> +
>  struct cpt_set_egrp_num {
>  	struct mbox_msghdr hdr;
>  	bool set;

...

> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
> index fa403da555ff..6923fd756b19 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
> @@ -525,8 +525,38 @@ struct rvu_cpt_eng_grp {
>  	u8 grp_num;
>  };
>  
> +struct rvu_cpt_rx_inline_lf_cfg {
> +	u16 sso_pf_func;
> +	u16 param1;
> +	u16 param2;
> +	u16 opcode;
> +	u32 credit;
> +	u32 credit_th;
> +	u16 bpid;

FWIIW, there is a hole here too.

> +	u32 reserved;
> +	u8 ctx_ilen_valid : 1;
> +	u8 ctx_ilen : 7;
> +};

...

> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c

...

> @@ -1087,6 +1115,72 @@ static void cpt_rxc_teardown(struct rvu *rvu, int blkaddr)
>  #define DQPTR      GENMASK_ULL(19, 0)
>  #define NQPTR      GENMASK_ULL(51, 32)
>  
> +static void cpt_rx_ipsec_lf_enable_iqueue(struct rvu *rvu, int blkaddr,
> +					  int slot)
> +{
> +	u64 val;
> +
> +	/* Set Execution Enable of instruction queue */
> +	val = otx2_cpt_read64(rvu->pfreg_base, blkaddr, slot, CPT_LF_INPROG);
> +	val |= BIT_ULL(16);

Bit 16 seems to have a meaning, it would be nice if a #define was used
I mean something like this (but probably not actually this :)

#define CPT_LF_INPROG_ENA_QUEUE BIT_ULL(16)

Perhaps defined near where CPT_LF_INPROG is defined.

> +	otx2_cpt_write64(rvu->pfreg_base, blkaddr, slot, CPT_LF_INPROG, val);
> +
> +	/* Set iqueue's enqueuing */
> +	val = otx2_cpt_read64(rvu->pfreg_base, blkaddr, slot, CPT_LF_CTL);
> +	val |= BIT_ULL(0);

Ditto.

> +	otx2_cpt_write64(rvu->pfreg_base, blkaddr, slot, CPT_LF_CTL, val);
> +}
> +
> +static void cpt_rx_ipsec_lf_disable_iqueue(struct rvu *rvu, int blkaddr,
> +					   int slot)
> +{
> +	int timeout = 1000000;
> +	u64 inprog, inst_ptr;
> +	u64 qsize, pending;
> +	int i = 0;
> +
> +	/* Disable instructions enqueuing */
> +	otx2_cpt_write64(rvu->pfreg_base, blkaddr, slot, CPT_LF_CTL, 0x0);
> +
> +	inprog = otx2_cpt_read64(rvu->pfreg_base, blkaddr, slot, CPT_LF_INPROG);
> +	inprog |= BIT_ULL(16);
> +	otx2_cpt_write64(rvu->pfreg_base, blkaddr, slot, CPT_LF_INPROG, inprog);
> +
> +	qsize = otx2_cpt_read64(rvu->pfreg_base, blkaddr, slot, CPT_LF_Q_SIZE)
> +		 & 0x7FFF;
> +	do {
> +		inst_ptr = otx2_cpt_read64(rvu->pfreg_base, blkaddr, slot,
> +					   CPT_LF_Q_INST_PTR);
> +		pending = (FIELD_GET(XQ_XOR, inst_ptr) * qsize * 40) +
> +			  FIELD_GET(NQPTR, inst_ptr) -
> +			  FIELD_GET(DQPTR, inst_ptr);

nit: I don't think you need the outer parentheses here.
     But if you do, the two lines above sould be indented by one more
     character.

> +		udelay(1);
> +		timeout--;
> +	} while ((pending != 0) && (timeout != 0));

nit: I don't think you need the inner parenthese here (x2).

> +
> +	if (timeout == 0)
> +		dev_warn(rvu->dev, "TIMEOUT: CPT poll on pending instructions\n");
> +
> +	timeout = 1000000;
> +	/* Wait for CPT queue to become execution-quiescent */
> +	do {
> +		inprog = otx2_cpt_read64(rvu->pfreg_base, blkaddr, slot,
> +					 CPT_LF_INPROG);
> +		if ((FIELD_GET(INFLIGHT, inprog) == 0) &&
> +		    (FIELD_GET(GRB_CNT, inprog) == 0)) {
> +			i++;
> +		} else {
> +			i = 0;
> +			timeout--;
> +		}
> +	} while ((timeout != 0) && (i < 10));
> +
> +	if (timeout == 0)
> +		dev_warn(rvu->dev, "TIMEOUT: CPT poll on inflight count\n");
> +	/* Wait for 2 us to flush all queue writes to memory */
> +	udelay(2);
> +}
> +
>  static void cpt_lf_disable_iqueue(struct rvu *rvu, int blkaddr, int slot)
>  {
>  	int timeout = 1000000;
> @@ -1310,6 +1404,474 @@ int rvu_cpt_ctx_flush(struct rvu *rvu, u16 pcifunc)
>  	return 0;
>  }
>  
> +static irqreturn_t rvu_cpt_rx_ipsec_misc_intr_handler(int irq, void *ptr)
> +{
> +	struct rvu_block *block = ptr;
> +	struct rvu *rvu = block->rvu;
> +	int blkaddr = block->addr;
> +	struct device *dev = rvu->dev;
> +	int slot = 0;
> +	u64 val;
> +
> +	val = otx2_cpt_read64(rvu->pfreg_base, blkaddr, slot, CPT_LF_MISC_INT);
> +
> +	if (val & (1 << 6)) {

Allong the lines of my earlier comment, bit 6 seems to have a meaning too.
Likewise for other bits below.

> +		dev_err(dev, "Memory error detected while executing CPT_INST_S, LF %d.\n",
> +			slot);
> +	} else if (val & (1 << 5)) {
> +		dev_err(dev, "HW error from an engine executing CPT_INST_S, LF %d.",
> +			slot);
> +	} else if (val & (1 << 3)) {
> +		dev_err(dev, "SMMU fault while writing CPT_RES_S to CPT_INST_S[RES_ADDR], LF %d.\n",
> +			slot);
> +	} else if (val & (1 << 2)) {
> +		dev_err(dev, "Memory error when accessing instruction memory queue CPT_LF_Q_BASE[ADDR].\n");
> +	} else if (val & (1 << 1)) {
> +		dev_err(dev, "Error enqueuing an instruction received at CPT_LF_NQ.\n");
> +	} else {
> +		dev_err(dev, "Unhandled interrupt in CPT LF %d\n", slot);
> +		return IRQ_NONE;
> +	}
> +
> +	/* Acknowledge interrupts */
> +	otx2_cpt_write64(rvu->pfreg_base, blkaddr, slot, CPT_LF_MISC_INT,
> +			 val & CPT_LF_MISC_INT_MASK);
> +
> +	return IRQ_HANDLED;
> +}

...

> +/* Allocate memory for CPT outbound Instruction queue.
> + * Instruction queue memory format is:
> + *      -----------------------------
> + *     | Instruction Group memory    |
> + *     |  (CPT_LF_Q_SIZE[SIZE_DIV40] |
> + *     |   x 16 Bytes)               |
> + *     |                             |
> + *      ----------------------------- <-- CPT_LF_Q_BASE[ADDR]
> + *     | Flow Control (128 Bytes)    |
> + *     |                             |
> + *      -----------------------------
> + *     |  Instruction Memory         |
> + *     |  (CPT_LF_Q_SIZE[SIZE_DIV40] |
> + *     |   × 40 × 64 bytes)          |
> + *     |                             |
> + *      -----------------------------
> + */

Nice diagram :)

...

> +static int rvu_rx_cpt_set_grp_pri_ilen(struct rvu *rvu, int blkaddr, int cptlf)
> +{
> +	u64 reg_val;
> +
> +	reg_val = rvu_read64(rvu, blkaddr, CPT_AF_LFX_CTL(cptlf));
> +	/* Set High priority */
> +	reg_val |= 1;
> +	/* Set engine group */
> +	reg_val |= ((1ULL << rvu->rvu_cpt.inline_ipsec_egrp) << 48);
> +	/* Set ilen if valid */
> +	if (rvu->rvu_cpt.rx_cfg.ctx_ilen_valid)
> +		reg_val |= rvu->rvu_cpt.rx_cfg.ctx_ilen  << 17;

Along the same lines. 48 and 17 seem to have meaning.
Perhaps define appropriate masks created using GENMASK_ULL
and use FIELD_PREP?

> +
> +	rvu_write64(rvu, blkaddr, CPT_AF_LFX_CTL(cptlf), reg_val);
> +	return 0;
> +}

...

> +static void rvu_rx_cptlf_cleanup(struct rvu *rvu, int blkaddr, int slot)
> +{
> +	/* IRQ cleanup */
> +	rvu_cpt_rx_inline_cleanup_irq(rvu, blkaddr, slot);
> +
> +	/* CPTLF cleanup */
> +	rvu_cpt_rx_inline_cptlf_clean(rvu, blkaddr, slot);
> +}
> +
> +int rvu_mbox_handler_cpt_rx_inline_lf_cfg(struct rvu *rvu,
> +					  struct cpt_rx_inline_lf_cfg_msg *req,
> +					  struct msg_rsp *rsp)

Compilers warn that rvu_mbox_handler_cpt_rx_inline_lf_cfg doesn't have
a prototype.

I think this can be resolved by squashing the following hunk,
which appears in a subsequent patch in this series, into this patch.

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 8540a04a92f9..ad74a27888da 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -213,6 +213,8 @@ M(CPT_FLT_ENG_INFO,     0xA09, cpt_flt_eng_info, cpt_flt_eng_info_req,	\
 			       cpt_flt_eng_info_rsp)			\
 M(CPT_SET_ENG_GRP_NUM,  0xA0A, cpt_set_eng_grp_num, cpt_set_egrp_num,   \
 				msg_rsp)				\
+M(CPT_RX_INLINE_LF_CFG, 0xBFE, cpt_rx_inline_lf_cfg, cpt_rx_inline_lf_cfg_msg, \
+				msg_rsp) \
 /* SDP mbox IDs (range 0x1000 - 0x11FF) */				\
 M(SET_SDP_CHAN_INFO, 0x1000, set_sdp_chan_info, sdp_chan_info_msg, msg_rsp) \
 M(GET_SDP_CHAN_INFO, 0x1001, get_sdp_chan_info, msg_req, sdp_get_chan_info_msg) \

...

> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.h

...

> +/* CPT instruction queue length in bytes */
> +#define RVU_CPT_INST_QLEN_BYTES                                               \
> +		((RVU_CPT_SIZE_DIV40 * 40 * RVU_CPT_INST_SIZE) +             \
> +		RVU_CPT_INST_QLEN_EXTRA_BYTES)

nit: I think the line above should be indented by one more character

> +
> +/* CPT instruction group queue length in bytes */
> +#define RVU_CPT_INST_GRP_QLEN_BYTES                                           \
> +		((RVU_CPT_SIZE_DIV40 + RVU_CPT_EXTRA_SIZE_DIV40) * 16)
> +
> +/* CPT FC length in bytes */
> +#define RVU_CPT_Q_FC_LEN 128
> +
> +/* CPT LF_Q_SIZE Register */
> +#define CPT_LF_Q_SIZE_DIV40 GENMASK_ULL(14, 0)
> +
> +/* CPT invalid engine group num */
> +#define OTX2_CPT_INVALID_CRYPTO_ENG_GRP 0xFF
> +
> +/* Fastpath ipsec opcode with inplace processing */
> +#define OTX2_CPT_INLINE_RX_OPCODE (0x26 | (1 << 6))
> +#define CN10K_CPT_INLINE_RX_OPCODE (0x29 | (1 << 6))

Along the lines of earlier comments, bit 6 seems to have a meaning here.

> +
> +/* Calculate CPT register offset */
> +#define CPT_RVU_FUNC_ADDR_S(blk, slot, offs) \
> +		(((blk) << 20) | ((slot) << 12) | (offs))

And perhaps this is another candidate for GENMASK + FIELD_PREP.

...
