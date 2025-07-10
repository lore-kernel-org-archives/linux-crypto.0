Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5069D28C2B7;
	Thu, 10 Jul 2025 08:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752136827; cv=none; b=bT3cDNK+P+PBpcqkXh+T+2w6wUoi+qCFG3eryeDJV1G5eoW0dF7CoAAPZyO/MOZ9KTywz4r+G+zQqqP3qWYwnDCXeJNwd62zOpzr5AVuDX3SRrCCMgCZ4DnOmoKfXONH0771wP7ZYDHe7iyHVcrb24e5hED9SceRBGVP24tR0kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752136827; c=relaxed/simple;
	bh=k8QYU1NiNaTnKoiWQNFMKCjrByVIcOn1yXxiqWINZrc=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iKqc+0L5P5mwdiEJVS2Kpr0a0WIMAFQNGqV/YzZfhXsgFZKiGCa2Kowu+KZ9wAbj5chSqdKhhuV2QaQZBQAUGMi4+wueyjcd9L2ILtIeTantfIy+F6d7gVW3FheK/YUUWV9sdj4PUp5p+gQbVCS8zuG1gJsyEoLBJx99aqvyDI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=gesfyd+F; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="gesfyd+F"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56A62JoD005273;
	Thu, 10 Jul 2025 01:40:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pfpt0220; bh=xaeNAsq8SKhg81D5XrW0Cp4l0
	a+Gg3NDnHtyBEMoAGg=; b=gesfyd+FM1rCey7NtAYA+TGghHIIDsygfRGtg3yAG
	LlSiU8MTYvn56sl7aFeKSzqPmq9kiPRYPoOiPIoklT7c6IJJTI7Haprbv+egW5MZ
	g6ujz7x+6pHn2KUguIRHQ8aX2xnsr+hS8ayGuvJllYrkuVPl58LAJo6bMTxnsB6O
	nqBzFWH64qaDMW3Ee21OiACrx9r1hXsiWmyaP9EUIhKdN7/krr18vp7N6iFgEJxk
	Vd3C16ZA/OB+weITy4sTi9emTDSLvPSNYvzL0gPntjuNR3gaTsD4a93kp4JpWDEl
	yXU0kgUq/UXTche81sgZL8y+CgSJTHV7W1vb6jDO+Ux1g==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 47t7w3gfjw-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Jul 2025 01:40:14 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 10 Jul 2025 01:40:07 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Thu, 10 Jul 2025 01:40:07 -0700
Received: from optiplex (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with SMTP id D9C395B6940;
	Thu, 10 Jul 2025 01:40:03 -0700 (PDT)
Date: Thu, 10 Jul 2025 14:10:03 +0530
From: Tanmay Jagdale <tanmay@marvell.com>
To: Simon Horman <horms@kernel.org>
CC: <davem@davemloft.net>, <leon@kernel.org>, <sgoutham@marvell.com>,
        <bbhushan2@marvell.com>, <herbert@gondor.apana.org.au>,
        <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 14/14] octeontx2-pf: ipsec: Add XFRM state
 and policy hooks for inbound flows
Message-ID: <aG98Y985la89vYR7@optiplex>
References: <20250618113020.130888-1-tanmay@marvell.com>
 <20250618113020.130888-15-tanmay@marvell.com>
 <20250620112249.GL194429@horms.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250620112249.GL194429@horms.kernel.org>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzEwMDA3NCBTYWx0ZWRfX2qprP3RMsJTL o0xmT2WaV7J8gHOv5HblrtPZlfQR7SbTuGhUjDjzASN3o/AWcBWuGPosZ+hcGqwus859XNAUHux iqYY57OG6TwlCDXgx26w2GtOYBlzGFSzA4iVCURXSEkAc9Pgv9SuYqqmqhQIteYMV8CxSbfdlJQ
 D5DSFSyq04FykYktpVOkNisYYch/BCP7RHxOG0KXPXvXwPjFfqcBCzIMbEjaYs9B4Dye9IaIcw7 qOOdCjRSXg13VHODn8c3AiNJIlaHuAbP6vx/J1zhujRmMCS1SrknFQAi9hTKuUyupDlsu+t6QZA 6V8+Llem07Q2BFzUHOeCuxvCTrt9+oDaH+qXEgjp8kkWaOM9odPzaGCrK1RDgqvnk+I8B7lvifD
 6gc8LTBrHP6NeqEgTJGU4h4SDQ4gL8MsPo9kpFWjqhfjVOpmc0TSqLmVhMGgHwMcOt/kTCZg
X-Proofpoint-GUID: Ce3dUlXNwKf48bYRfIh2pf8BUspLlIJv
X-Proofpoint-ORIG-GUID: Ce3dUlXNwKf48bYRfIh2pf8BUspLlIJv
X-Authority-Analysis: v=2.4 cv=dY+A3WXe c=1 sm=1 tr=0 ts=686f7c6e cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8 a=xWn14IjVmXkPw4t3ZSQA:9 a=CjuIK1q_8ugA:10
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-10_01,2025-07-09_01,2025-03-28_01

Hi Simon,

On 2025-06-20 at 16:52:49, Simon Horman (horms@kernel.org) wrote:
> On Wed, Jun 18, 2025 at 05:00:08PM +0530, Tanmay Jagdale wrote:
> > Add XFRM state hook for inbound flows and configure the following:
> >   - Install an NPC rule to classify the 1st pass IPsec packets and
> >     direct them to the dedicated RQ
> >   - Allocate a free entry from the SA table and populate it with the
> >     SA context details based on xfrm state data.
> >   - Create a mapping of the SPI value to the SA table index. This is
> >     used by NIXRX to calculate the exact SA context  pointer address
> >     based on the SPI in the packet.
> >   - Prepare the CPT SA context to decrypt buffer in place and the
> >     write it the CPT hardware via LMT operation.
> >   - When the XFRM state is deleted, clear this SA in CPT hardware.
> > 
> > Also add XFRM Policy hooks to allow successful offload of inbound
> > PACKET_MODE.
> > 
> > Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
> 
> ...
> 
> > @@ -1141,6 +1154,137 @@ static int cn10k_outb_write_sa(struct otx2_nic *pf, struct qmem *sa_info)
> >  	return ret;
> >  }
> >  
> > +static int cn10k_inb_write_sa(struct otx2_nic *pf,
> > +			      struct xfrm_state *x,
> > +			      struct cn10k_inb_sw_ctx_info *inb_ctx_info)
> > +{
> > +	dma_addr_t res_iova, dptr_iova, sa_iova;
> > +	struct cn10k_rx_sa_s *sa_dptr, *sa_cptr;
> > +	struct cpt_inst_s inst;
> > +	u32 sa_size, off;
> > +	struct cpt_res_s *res;
> > +	u64 reg_val;
> > +	int ret;
> > +
> > +	res = dma_alloc_coherent(pf->dev, sizeof(struct cpt_res_s),
> > +				 &res_iova, GFP_ATOMIC);
> > +	if (!res)
> > +		return -ENOMEM;
> > +
> > +	sa_cptr = inb_ctx_info->sa_entry;
> > +	sa_iova = inb_ctx_info->sa_iova;
> > +	sa_size = sizeof(struct cn10k_rx_sa_s);
> > +
> > +	sa_dptr = dma_alloc_coherent(pf->dev, sa_size, &dptr_iova, GFP_ATOMIC);
> > +	if (!sa_dptr) {
> > +		dma_free_coherent(pf->dev, sizeof(struct cpt_res_s), res,
> > +				  res_iova);
> > +		return -ENOMEM;
> > +	}
> > +
> > +	for (off = 0; off < (sa_size / 8); off++)
> > +		*((u64 *)sa_dptr + off) = cpu_to_be64(*((u64 *)sa_cptr + off));
> > +
> > +	memset(&inst, 0, sizeof(struct cpt_inst_s));
> > +
> > +	res->compcode = 0;
> > +	inst.res_addr = res_iova;
> > +	inst.dptr = (u64)dptr_iova;
> > +	inst.param2 = sa_size >> 3;
> > +	inst.dlen = sa_size;
> > +	inst.opcode_major = CN10K_IPSEC_MAJOR_OP_WRITE_SA;
> > +	inst.opcode_minor = CN10K_IPSEC_MINOR_OP_WRITE_SA;
> > +	inst.cptr = sa_iova;
> > +	inst.ctx_val = 1;
> > +	inst.egrp = CN10K_DEF_CPT_IPSEC_EGRP;
> > +
> > +	/* Re-use Outbound CPT LF to install Ingress SAs as well because
> > +	 * the driver does not own the ingress CPT LF.
> > +	 */
> > +	pf->ipsec.io_addr = (__force u64)otx2_get_regaddr(pf, CN10K_CPT_LF_NQX(0));
> > +	cn10k_cpt_inst_flush(pf, &inst, sizeof(struct cpt_inst_s));
> > +	dmb(sy);
> 
> Hi Tanmay,
> 
> As I understand things the above effectively means that this
> driver will only compile for ARM64.
> 
> I do understand that the driver is only intended to be used on ARM64.
> But it is nice to get compile coverage on other 64bit systems,
> in particular x86_64.
> 
> And moreover, I think the guiding principle should be for drivers
> to be as independent of the host system as possible.
> 
> Can we look into handling this a different way?
ACK, I will use dma_wmb() here so that it is generic.

With Regards,
Tanmay
