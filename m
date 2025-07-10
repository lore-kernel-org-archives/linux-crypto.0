Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29AF28373;
	Thu, 10 Jul 2025 08:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752136982; cv=none; b=CYDxf6Vv7hQfEGMnYGqrz21+rdb8lcMLrjcUSz0aIRJ7IkFIzetGDcI+QmM5awJLiJHKEPmkCymVbEu5n2aqL5nsUDgEq8NpiQU/0PmB5lx4BNH8sGD4v6cbirt6UhwhKzg+rY5sDEEhOPDWU70IfMWSEEYQiZ+ZZsLJQmXCqMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752136982; c=relaxed/simple;
	bh=g459028/JSadOIU5ioN9lGsXNXo9bvmMiYxbBIqYAjw=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LJrC9G9WHGyu8GNd/wDuViC6O3/zZZ5mGgJLFEPdr9fvFS/hzDCFRkAvLa2Zzccri1/oLHX3Ez9waTzj8+Sx2eHHfaguC5WnktV/VC7dvkcRZAD5yVl+gdKblsxlUC3ID3BsvZ/3kHdo9B8bvps+D3ytU3Pukx+PKxUlE+aOIX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=LWu3s865; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="LWu3s865"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 569NWUIP004022;
	Thu, 10 Jul 2025 01:42:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pfpt0220; bh=ht5d0M9rmt2zm2KkwM6vY0I9R
	sgkRykgZ4IGgkysBTY=; b=LWu3s865BtK+1JjDdBMWe9olbl7Jou+vrLrfWe9nx
	16gc/Hr2U5aJTY9C45Qp+n9BUe1+79v41hUOIsWSGU0QHkhmyIJZithdwNrl+cqH
	l7WNI+jOe094TQItU3FzdGE9+0apCDiI+J0Nj6eXM5LR4/EukxVu6xqbpEpCu8c3
	MmYhpq+4nnuz8wAI+tuWndELex7fNSNOa4+nv5kbkaVZO8HT6kxnLcyzP+ATFa9H
	6vpJvljw1g24hW+8Xo2dg9P0Ua6w+Sd+gf8QdQ3TWhVF4x+hG6AC2rqysVZDr7xH
	ky1Q+gJPsXFpe3PBzpgL3QOgoTRLTX1K6/hSNRgXmm+xA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 47t26g98eu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Jul 2025 01:42:43 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 10 Jul 2025 01:42:42 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Thu, 10 Jul 2025 01:42:42 -0700
Received: from optiplex (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with SMTP id 5DB9F5B693B;
	Thu, 10 Jul 2025 01:42:39 -0700 (PDT)
Date: Thu, 10 Jul 2025 14:12:38 +0530
From: Tanmay Jagdale <tanmay@marvell.com>
To: Simon Horman <horms@kernel.org>
CC: <davem@davemloft.net>, <leon@kernel.org>, <sgoutham@marvell.com>,
        <bbhushan2@marvell.com>, <herbert@gondor.apana.org.au>,
        <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 10/14] octeontx2-pf: ipsec: Handle NPA
 threshold interrupt
Message-ID: <aG98_m30GHBGtLIt@optiplex>
References: <20250618113020.130888-1-tanmay@marvell.com>
 <20250618113020.130888-11-tanmay@marvell.com>
 <20250620110038.GJ194429@horms.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250620110038.GJ194429@horms.kernel.org>
X-Proofpoint-GUID: Z7fgeOgn1PDE5_FCqGbv1NA8SvpBaCQi
X-Authority-Analysis: v=2.4 cv=TJNFS0la c=1 sm=1 tr=0 ts=686f7d03 cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8 a=nDdoMcYX8gk1bqBtB7IA:9 a=CjuIK1q_8ugA:10
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzEwMDA3NCBTYWx0ZWRfX8HJBEkePRp+8 cG/ABt8qW8G0jkKtF/eAtE0PSAJ6b8ZgTidEOuepL5PIV0+BKJILFPjJOjfbB3nuRLxTflLnAf9 Lm9tu6Yj5BZV99ekHFTfNs2/Oli1I5yxVxx1VhwRniJGgg4RooMjb8ZqXG63hYbXv6otNoakMow
 +tXzrBqiK5mRW94ykfDQPM3zQO3MjRU0pl9UUW26ijqBPwm0/SdT/3lhH3RNc1DG9VeD3OEN+mu DiU687fr6XaroUW9zd1f3msP+/ZHp88W7/t/hUk642uUu1sBSXdLT7QlP5BXTNYPDUCPfRaLjIJ B5ZY4VOcJVqWchVKZU1TY0EFkZjsUZvTDN5CPIRbYzvVwYsvtH/6NFiV7QLBSWUlEmfJPIUXIEr
 /NqzVt3dxDIwBdMcMe6erLqvW1UmIwQpelf5SWFqBFvawy3vdbgRGXQSxdnwjM5Zlom8yHj5
X-Proofpoint-ORIG-GUID: Z7fgeOgn1PDE5_FCqGbv1NA8SvpBaCQi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-10_01,2025-07-09_01,2025-03-28_01

Hi Simon,

On 2025-06-20 at 16:30:38, Simon Horman (horms@kernel.org) wrote:
> On Wed, Jun 18, 2025 at 05:00:04PM +0530, Tanmay Jagdale wrote:
> > The NPA Aura pool that is dedicated for 1st pass inline IPsec flows
> > raises an interrupt when the buffers of that aura_id drop below a
> > threshold value.
> > 
> > Add the following changes to handle this interrupt
> > - Increase the number of MSIX vectors requested for the PF/VF to
> >   include NPA vector.
> > - Create a workqueue (refill_npa_inline_ipsecq) to allocate and
> >   refill buffers to the pool.
> > - When the interrupt is raised, schedule the workqueue entry,
> >   cn10k_ipsec_npa_refill_inb_ipsecq(), where the current count of
> >   consumed buffers is determined via NPA_LF_AURA_OP_CNT and then
> >   replenished.
> > 
> > Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
> > ---
> > Changes in V2:
> > - Fixed sparse warnings
> > 
> > V1 Link: https://lore.kernel.org/netdev/20250502132005.611698-12-tanmay@marvell.com/
> > 
> >  .../marvell/octeontx2/nic/cn10k_ipsec.c       | 94 ++++++++++++++++++-
> >  .../marvell/octeontx2/nic/cn10k_ipsec.h       |  1 +
> >  .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  4 +
> >  .../ethernet/marvell/octeontx2/nic/otx2_reg.h |  2 +
> >  .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |  4 +
> >  5 files changed, 104 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
> 
> ...
> 
> >  static int cn10k_inb_cpt_init(struct net_device *netdev)
> >  {
> >  	struct otx2_nic *pfvf = netdev_priv(netdev);
> > -	int ret = 0;
> > +	int ret = 0, vec;
> > +	char *irq_name;
> > +	void *ptr;
> > +	u64 val;
> >  
> >  	ret = cn10k_ipsec_setup_nix_rx_hw_resources(pfvf);
> >  	if (ret) {
> > @@ -528,6 +587,34 @@ static int cn10k_inb_cpt_init(struct net_device *netdev)
> >  		return ret;
> >  	}
> >  
> > +	/* Work entry for refilling the NPA queue for ingress inline IPSec */
> > +	INIT_WORK(&pfvf->ipsec.refill_npa_inline_ipsecq,
> > +		  cn10k_ipsec_npa_refill_inb_ipsecq);
> > +
> > +	/* Register NPA interrupt */
> > +	vec = pfvf->hw.npa_msixoff;
> > +	irq_name = &pfvf->hw.irq_name[vec * NAME_SIZE];
> > +	snprintf(irq_name, NAME_SIZE, "%s-npa-qint", pfvf->netdev->name);
> > +
> > +	ret = request_irq(pci_irq_vector(pfvf->pdev, vec),
> > +			  cn10k_ipsec_npa_inb_ipsecq_intr_handler, 0,
> > +			  irq_name, pfvf);
> > +	if (ret) {
> > +		dev_err(pfvf->dev,
> > +			"RVUPF%d: IRQ registration failed for NPA QINT\n",
> > +			rvu_get_pf(pfvf->pdev, pfvf->pcifunc));
> > +		return ret;
> > +	}
> > +
> > +	/* Enable NPA threshold interrupt */
> > +	ptr = otx2_get_regaddr(pfvf, NPA_LF_AURA_OP_INT);
> 
> Hi Tanmay,
Hi Simon,

> 
> ptr is set but otherwise unused in this function.
> Probably it should be removed.
ACK. ptr is unused and I have removed it for the next version.

> 
> Flagged by clang and gcc with -Wunused-but-set-variable
> 
> Also, Sparse warns that the return type of otx2_get_regaddr()
> is  void __iomem *, but ptr does not have an __iomem annotation.
> 

With Regards,
Tanmay
> > +	val = BIT_ULL(43) | BIT_ULL(17);
> > +	otx2_write64(pfvf, NPA_LF_AURA_OP_INT,
> > +		     ((u64)pfvf->ipsec.inb_ipsec_pool << 44) | val);
> > +
> > +	/* Enable interrupt */
> > +	otx2_write64(pfvf, NPA_LF_QINTX_ENA_W1S(0), BIT_ULL(0));
> > +
> >  	return ret;
> >  }
> >  
