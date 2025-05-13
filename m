Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05DC022EE5;
	Tue, 13 May 2025 05:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747113522; cv=none; b=IGabc/E3r++Ick78xThb7iXoS8TZz/MD/TQLTOIXAvC/IUPUbatLBFMSQlg/DK9IDjjL1YYRus5vleY8ac67C8M4/3PWBzZPs1EEK5cRQW85oi0Q3FK7ci1R0Uoi78nWw1BiTyVcrGQwrwtcQ4O1fIiSJTmNUFB6aLkSHCBhyHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747113522; c=relaxed/simple;
	bh=FQEseClqRooUY4kG2KKP/+xzdvUzb5EeQCNbPBjbR/Y=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iaVaYX7edF2FI9iGOL1VbMzmoIX2JWWyizgA9wlouR02K4EFSBX1gEaTgZs20HM6dRt+QPGScOa6WFCwN3XQiLGEkLkspB8vBm6XkFCxe+RGunco/uhKe0hXgvlTxBcUBG+tN1f18i4fozHh8aP7NfFh/BqqO95mV3dREHPff/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=iiMjsO+i; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="iiMjsO+i"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54CIOSDC002657;
	Mon, 12 May 2025 22:18:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pfpt0220; bh=SgOLbvVK6muAKtaVFlizqJJn4
	laHAsEJocIJTZ2t1yQ=; b=iiMjsO+idl+efBjYC4HOws7VN4uyTlrLSasXDWHle
	H6sgg5QGiPbV0Vh1dYHvGpsS/FMoWEwq78padh29ePbvpwVu4+nT7sxB7t8K1G7X
	MOEuqq6Sjl9mmTtTkCqoWP/NhAgjHui+MDbURkZEPsuoblOTwc+27SDEi4+n6WRT
	0lHBHfhZDQb8PMRTQOpaLVVFHBKnWTOZPKSEX0fxP1XtWzcuAVHQIRgFDasPpkyJ
	b8GKA4QJ+LHMgU9zSpTP31FXEEyD1DmNMou9YHyUCRc1eNEiiNblrWiPgcNxrJgy
	5V1Hwuer6cqe5Jd4vC2tslG1uiDwGy+waY3sLRLGAE3qw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 46kp7ms34w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 May 2025 22:18:19 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Mon, 12 May 2025 22:18:18 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Mon, 12 May 2025 22:18:18 -0700
Received: from optiplex (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with SMTP id C44F23F709B;
	Mon, 12 May 2025 22:18:10 -0700 (PDT)
Date: Tue, 13 May 2025 10:48:09 +0530
From: Tanmay Jagdale <tanmay@marvell.com>
To: Simon Horman <horms@kernel.org>
CC: <schalla@marvell.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <hkelam@marvell.com>,
        <sbhatta@marvell.com>, <andrew+netdev@lunn.ch>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <bbhushan2@marvell.com>,
        <bhelgaas@google.com>, <pstanner@redhat.com>,
        <gregkh@linuxfoundation.org>, <peterz@infradead.org>,
        <linux@treblig.org>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <rkannoth@marvell.com>, <sumang@marvell.com>, <gcherian@marvell.com>,
        "Rakesh
 Kudurumalla" <rkudurumalla@marvell.com>
Subject: Re: [net-next PATCH v1 06/15] octeontx2-af: Add support for CPT
 second pass
Message-ID: <aCLWEQxjCr5kPjNe@optiplex>
References: <20250502132005.611698-1-tanmay@marvell.com>
 <20250502132005.611698-7-tanmay@marvell.com>
 <20250507123622.GB3339421@horms.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250507123622.GB3339421@horms.kernel.org>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTEzMDA0NyBTYWx0ZWRfX4qjGc70FBQvD U+pQiUMGW5JgYXTtNLXFN5nyBuHiaD8k9hYIsWEeadisdkajAQTZBWmt7EC7C8CErSss79oRLn5 WmgGUsG++kO5TToJqyulrS4Q9Wes6X9923WYPCRxFBomWbZHrvFvROrie7Rdh1/NigHZZNvadZ/
 mTvRkjCaaRqfMfSLq2KRUi8GAbjEDCjQ6XcJ3w3bVZnNG8zJ56wr7HQFC9jJJWno9VXL+eNLPLs NaQFnek7D1MEPiNfUPiaQbAfwXsCHMpzjX/gJ5v2BlZDCxu9hUCQooAxEcJvpJhe8lQAi3AVOVD 7kVwGXY39ij/bNUV5FbchK2BYMoXdKGpvQkWJdtwZluzc11ergw/RtEc9K/0WmH3OWY1WaFqz9a
 TEwPv5oFkD/EyLGZ9nEG20yeWlLD86qecSyNM1gEi1PJH5gCYenBxQaOYZVr4MCIE64SVBz1
X-Proofpoint-GUID: LIcbjLLgcPlpwgeezn_vofp_xDBDl5Xn
X-Authority-Analysis: v=2.4 cv=YsYPR5YX c=1 sm=1 tr=0 ts=6822d61b cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8 a=63xwS2YjP-eCkoVN3FIA:9 a=CjuIK1q_8ugA:10
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: LIcbjLLgcPlpwgeezn_vofp_xDBDl5Xn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-12_07,2025-05-09_01,2025-02-21_01

Hi Simon,


On 2025-05-07 at 18:06:22, Simon Horman (horms@kernel.org) wrote:
> On Fri, May 02, 2025 at 06:49:47PM +0530, Tanmay Jagdale wrote:
> > From: Rakesh Kudurumalla <rkudurumalla@marvell.com>
> > 
> > Implemented mailbox to add mechanism to allocate a
> > rq_mask and apply to nixlf to toggle RQ context fields
> > for CPT second pass packets.
> > 
> > Signed-off-by: Rakesh Kudurumalla <rkudurumalla@marvell.com>
> > Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
> 
> ...
> 
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
> > index 7fa98aeb3663..18e2a48e2de1 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
> > @@ -544,6 +544,7 @@ void rvu_program_channels(struct rvu *rvu)
> >  
> >  void rvu_nix_block_cn10k_init(struct rvu *rvu, struct nix_hw *nix_hw)
> >  {
> > +	struct rvu_hwinfo *hw = rvu->hw;
> >  	int blkaddr = nix_hw->blkaddr;
> >  	u64 cfg;
> >  
> > @@ -558,6 +559,16 @@ void rvu_nix_block_cn10k_init(struct rvu *rvu, struct nix_hw *nix_hw)
> >  	cfg = rvu_read64(rvu, blkaddr, NIX_AF_CFG);
> >  	cfg |= BIT_ULL(1) | BIT_ULL(2);
> 
> As per my comments on an earlier patch in this series:
> bits 1 and 2 have meaning. It would be nice to use a #define to
> convey this meaning to the reader.
Okay sure, I will update the patch series with macros that provide a
clear meaning.

> 
> >  	rvu_write64(rvu, blkaddr, NIX_AF_CFG, cfg);
> > +
> > +	cfg = rvu_read64(rvu, blkaddr, NIX_AF_CONST);
> > +
> > +	if (!(cfg & BIT_ULL(62))) {
> > +		hw->cap.second_cpt_pass = false;
> > +		return;
> > +	}
> > +
> > +	hw->cap.second_cpt_pass = true;
> > +	nix_hw->rq_msk.total = NIX_RQ_MSK_PROFILES;
> >  }
> >  
> >  void rvu_apr_block_cn10k_init(struct rvu *rvu)
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
> > index 6bd995c45dad..b15fd331facf 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
> > @@ -6612,3 +6612,123 @@ int rvu_mbox_handler_nix_mcast_grp_update(struct rvu *rvu,
> >  
> >  	return ret;
> >  }
> > +
> > +static inline void
> > +configure_rq_mask(struct rvu *rvu, int blkaddr, int nixlf,
> > +		  u8 rq_mask, bool enable)
> > +{
> > +	u64 cfg, reg;
> > +
> > +	cfg = rvu_read64(rvu, blkaddr, NIX_AF_LFX_RX_IPSEC_CFG1(nixlf));
> > +	reg = rvu_read64(rvu, blkaddr, NIX_AF_LFX_CFG(nixlf));
> > +	if (enable) {
> > +		cfg |= BIT_ULL(43);
> > +		reg = (reg & ~GENMASK_ULL(36, 35)) | ((u64)rq_mask << 35);
> > +	} else {
> > +		cfg &= ~BIT_ULL(43);
> > +		reg = (reg & ~GENMASK_ULL(36, 35));
> > +	}
> 
> Likewise for the bit, mask, and shift here.
> 
> And I think that using FIELD_PREP with another mask in place of the shift
> is also appropriate here.
ACK.

> 
> > +	rvu_write64(rvu, blkaddr, NIX_AF_LFX_RX_IPSEC_CFG1(nixlf), cfg);
> > +	rvu_write64(rvu, blkaddr, NIX_AF_LFX_CFG(nixlf), reg);
> > +}
> > +
> > +static inline void
> > +configure_spb_cpt(struct rvu *rvu, int blkaddr, int nixlf,
> > +		  struct nix_rq_cpt_field_mask_cfg_req *req, bool enable)
> > +{
> > +	u64 cfg;
> > +
> > +	cfg = rvu_read64(rvu, blkaddr, NIX_AF_LFX_RX_IPSEC_CFG1(nixlf));
> > +	if (enable) {
> > +		cfg |= BIT_ULL(37);
> > +		cfg &= ~GENMASK_ULL(42, 38);
> > +		cfg |= ((u64)req->ipsec_cfg1.spb_cpt_sizem1 << 38);
> > +		cfg &= ~GENMASK_ULL(63, 44);
> > +		cfg |= ((u64)req->ipsec_cfg1.spb_cpt_aura << 44);
> > +	} else {
> > +		cfg &= ~BIT_ULL(37);
> > +		cfg &= ~GENMASK_ULL(42, 38);
> > +		cfg &= ~GENMASK_ULL(63, 44);
> > +	}
> 
> And here too.
> 
> > +	rvu_write64(rvu, blkaddr, NIX_AF_LFX_RX_IPSEC_CFG1(nixlf), cfg);
> > +}
> 
> ...
> 
> > +int rvu_mbox_handler_nix_lf_inline_rq_cfg(struct rvu *rvu,
> > +					  struct nix_rq_cpt_field_mask_cfg_req *req,
> > +					  struct msg_rsp *rsp)
> 
> It would be nice to reduce this to 80 columns wide or less.
> Perhaps like this?
> 
> int
> rvu_mbox_handler_nix_lf_inline_rq_cfg(struct rvu *rvu,
> 				      struct nix_rq_cpt_field_mask_cfg_req *req,
> 				      struct msg_rsp *rsp)
> 
> Or perhaps by renaming nix_rq_cpt_field_mask_cfg_req to be shorter.
Okay sure. I'll go ahead with the first suggestion so that the function
name is in sync with the rest of the file.

> 
> ...
> 
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
> > index 245e69fcbff9..e5e005d5d71e 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
> > +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
> > @@ -433,6 +433,8 @@
> >  #define NIX_AF_MDQX_IN_MD_COUNT(a)	(0x14e0 | (a) << 16)
> >  #define NIX_AF_SMQX_STATUS(a)		(0x730 | (a) << 16)
> >  #define NIX_AF_MDQX_OUT_MD_COUNT(a)	(0xdb0 | (a) << 16)
> > +#define NIX_AF_RX_RQX_MASKX(a, b)       (0x4A40 | (a) << 16 | (b) << 3)
> > +#define NIX_AF_RX_RQX_SETX(a, b)        (0x4A80 | (a) << 16 | (b) << 3)
> 
> FIELD_PREP could be used here in conjunction with #defines
> for appropriate masks here too.
ACK.
> 
> >  
> >  #define NIX_PRIV_AF_INT_CFG		(0x8000000)
> >  #define NIX_PRIV_LFX_CFG		(0x8000010)
> 
> ...
Thanks,
Tanmay

