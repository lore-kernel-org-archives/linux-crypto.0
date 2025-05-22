Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788731A0BFA;
	Thu, 22 May 2025 10:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747908149; cv=none; b=g00mwGAUieGkAE9wJWBqzpnNJ12TDALWSdYRIiq47lBQFaPAixEgBFC3lxPUbKn/yujaA+kWDXMNCART0W+Y+CmLVV5wMexa0sv4RakSSQJdz93MiBwirp9CsnGowAwYkSypP/TldRfc5zoXyB7ObZY16HfXY8SjXyGnBCds0lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747908149; c=relaxed/simple;
	bh=M7vpJbdglBWx0pLTeRrfMUOYPlLg5tymUbcB8q2JhAQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kMQM0/xw/QIP3jGjP9+sWddipvC+PNPSvRsOGbf7KCdKJWIa5QIUO6o7MhakJEB59WC1Is639XIJvruvnA9YiFTA/xEnAKyrqc+/8/3u+T+rHXAtNxrGuV2jKD2CnnAWSXtFF2zV2pdjJQXsp4d6d5f92BYvg0Yxzh1UjLZKOEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=SC/gSDWZ; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="SC/gSDWZ"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54M5KLEO014435;
	Thu, 22 May 2025 03:02:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pfpt0220; bh=6BkNedkYMdsuiITPzExAUf7fT
	5Kq5mq4WM3Ajj76sHo=; b=SC/gSDWZq8tZ47TE9wcdO4ac5+x1rEEmsWGxEW6aZ
	7LIvvtYnK9XLqU8o3d2kJLUCU/RJnGojyj3IV2BjtlekWrpzc4sKCa+oZc15g9yv
	lsq235QliIrdy1JD7dAN5qVbwSSoR6V3rJax/GnOTvtT8jp7/ui3/aftF6Avvqut
	tAvvrilxeeIK3yYmJpvNefmf1syQNhj1UDtYHkcIohTrZlFE04CSIsT49v+yZT+F
	D979wTWCjc50+V3uGW2CICPlBIui8SNchRcIzvRE1yG+Si2o/Et5A8Nppzlsilfb
	+sZ8eW+e5Cxr9ra6qhfbNnMPriA4gd/vPRGG3LOxDECHA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 46swp68fne-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 03:02:09 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 22 May 2025 03:02:08 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Thu, 22 May 2025 03:02:08 -0700
Received: from optiplex (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with SMTP id 0FE323F7084;
	Thu, 22 May 2025 03:02:00 -0700 (PDT)
Date: Thu, 22 May 2025 15:31:59 +0530
From: Tanmay Jagdale <tanmay@marvell.com>
To: Simon Horman <horms@kernel.org>
CC: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>, <gakula@marvell.com>,
        <jerinj@marvell.com>, <hkelam@marvell.com>, <sbhatta@marvell.com>,
        <andrew+netdev@lunn.ch>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <bbhushan2@marvell.com>, <bhelgaas@google.com>,
        <pstanner@redhat.com>, <gregkh@linuxfoundation.org>,
        <peterz@infradead.org>, <linux@treblig.org>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <rkannoth@marvell.com>, <sumang@marvell.com>,
        <gcherian@marvell.com>
Subject: Re: [net-next PATCH v1 13/15] octeontx2-pf: ipsec: Manage NPC rules
 and SPI-to-SA table entries
Message-ID: <aC72F8DUpFh02ZAk@optiplex>
References: <20250502132005.611698-1-tanmay@marvell.com>
 <20250502132005.611698-14-tanmay@marvell.com>
 <20250507155814.GG3339421@horms.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250507155814.GG3339421@horms.kernel.org>
X-Proofpoint-GUID: s6tBtMbyIXtsI_gdnOEmmN4YLMm441Oo
X-Authority-Analysis: v=2.4 cv=DO+P4zNb c=1 sm=1 tr=0 ts=682ef621 cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8 a=rzR_PAGEfb2iwjc_MlYA:9 a=CjuIK1q_8ugA:10
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIyMDEwMCBTYWx0ZWRfX++/IVGxvPjlb AiZW/zxaY3aAaHzJtiYEdJtO0dQ0NJaE6q79OQ2PUFp1R+h//Zp7n/m6gZJCUdFOYfwod1gqFLx Lux44UYts36g+UwCa095jSnxKnj9Z/RrNk1LNq/4eyY6aRNtj5Y/nE+G1x29ezUeu79agVORZ+H
 EuhT+SEzywOy+Mn5QcuAwIbUbdCAUG9sGKVghYs3Koq/hgQDen1CeifO1UMNx4m2CvKWF8Fp7Zl BiUoWiojLE55cj8ASwF5CCai4tIBwC14yakEE+kkOOynbFu2JFxiTBTa6ZLdhAhbtkHp2l8Bqeb vic1bzaZvCKT97r/X//DuVIS/CY7yRJh3ouQi6rRpX/DOXlj2uRJat0J9hIzeN9la+0nvrx8J9S
 rM3tvpVghVnuWpT8SufjDfkZPkBhRk1+RpR7K2DmmYMVtk9u4M8b9enmG/n0LrWgd0v5EXFx
X-Proofpoint-ORIG-GUID: s6tBtMbyIXtsI_gdnOEmmN4YLMm441Oo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-22_05,2025-05-22_01,2025-03-28_01

Hi Simon,

On 2025-05-07 at 21:28:14, Simon Horman (horms@kernel.org) wrote:
> On Fri, May 02, 2025 at 06:49:54PM +0530, Tanmay Jagdale wrote:
> > NPC rule for IPsec flows
> > ------------------------
> > Incoming IPsec packets are first classified for hardware fastpath
> > processing in the NPC block. Hence, allocate an MCAM entry in NPC
> > using the MCAM_ALLOC_ENTRY mailbox to add a rule for IPsec flow
> > classification.
> > 
> > Then, install an NPC rule at this entry for packet classification
> > based on ESP header and SPI value with match action as UCAST_IPSEC.
> > Also, these packets need to be directed to the dedicated receive
> > queue so provide the RQ index as part of NPC_INSTALL_FLOW mailbox.
> > Add a function to delete NPC rule as well.
> > 
> > SPI-to-SA match table
> > ---------------------
> > NIX RX maintains a common hash table for matching the SPI value from
> > in ESP packet to the SA index associated with it. This table has 2K entries
> > with 4 ways. When a packet is received with action as UCAST_IPSEC, NIXRX
> > uses the SPI from the packet header to perform lookup in the SPI-to-SA
> > hash table. This lookup, if successful, returns an SA index that is used
> > by NIXRX to calculate the exact SA context address and programs it in
> > the CPT_INST_S before submitting the packet to CPT for decryption.
> > 
> > Add functions to install the delete an entry from this table via the
> > NIX_SPI_TO_SA_ADD and NIX_SPI_TO_SA_DELETE mailbox calls respectively.
> > 
> > When the RQs are changed at runtime via ethtool, RVU PF driver frees all
> > the resources and goes through reinitialization with the new set of receive
> > queues. As part of this flow, the UCAST_IPSEC NPC rules that were installed
> > by the RVU PF/VF driver have to be reconfigured with the new RQ index.
> > 
> > So, delete the NPC rules when the interface is stopped via otx2_stop().
> > When otx2_open() is called, re-install the NPC flow and re-initialize the
> > SPI-to-SA table for every SA context that was previously installed.
> > 
> > Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
> > ---
> >  .../marvell/octeontx2/nic/cn10k_ipsec.c       | 201 ++++++++++++++++++
> >  .../marvell/octeontx2/nic/cn10k_ipsec.h       |   7 +
> >  .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |   9 +
> >  3 files changed, 217 insertions(+)
> > 
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
> 
> ...
> 
> > +static int cn10k_inb_install_flow(struct otx2_nic *pfvf, struct xfrm_state *x,
> > +				  struct cn10k_inb_sw_ctx_info *inb_ctx_info)
> > +{
> > +	struct npc_install_flow_req *req;
> > +	int err;
> > +
> > +	mutex_lock(&pfvf->mbox.lock);
> > +
> > +	req = otx2_mbox_alloc_msg_npc_install_flow(&pfvf->mbox);
> > +	if (!req) {
> > +		err = -ENOMEM;
> > +		goto out;
> > +	}
> > +
> > +	req->entry = inb_ctx_info->npc_mcam_entry;
> > +	req->features |= BIT(NPC_IPPROTO_ESP) | BIT(NPC_IPSEC_SPI) | BIT(NPC_DMAC);
> > +	req->intf = NIX_INTF_RX;
> > +	req->index = pfvf->ipsec.inb_ipsec_rq;
> > +	req->match_id = 0xfeed;
> > +	req->channel = pfvf->hw.rx_chan_base;
> > +	req->op = NIX_RX_ACTIONOP_UCAST_IPSEC;
> > +	req->set_cntr = 1;
> > +	req->packet.spi = x->id.spi;
> > +	req->mask.spi = 0xffffffff;
> 
> I realise that the value is isomorphic, but I would use the following
> so that the rvalue has an endian annotation that matches the lvalue.
> 
> 	req->mask.spi = cpu_to_be32(0xffffffff);
> 
> Flagged by Sparse.
ACK.

> 
> > +
> > +	/* Send message to AF */
> > +	err = otx2_sync_mbox_msg(&pfvf->mbox);
> > +out:
> > +	mutex_unlock(&pfvf->mbox.lock);
> > +	return err;
> > +}
> 
> ...
> 
> > +static int cn10k_inb_delete_spi_to_sa_match_entry(struct otx2_nic *pfvf,
> > +						  struct cn10k_inb_sw_ctx_info *inb_ctx_info)
> 
> gcc-14.2.0 (at least) complains that cn10k_inb_delete_spi_to_sa_match_entry
> is unused.
Oops.
> 
> Likewise for cn10k_inb_delete_flow and cn10k_inb_delete_spi_to_sa_match_entry.
> 
> I'm unsure of the best way to address this but it would be nice
> to avoid breaking build bisection for such a trivial reason.
> 
> Some ideas:
> * Maybe it is possible to squash this and the last patch,
>   or bring part of the last patch into this patch, or otherwise
>   rearrange things to avoid this problem.
> * Add temporary __maybe_unusd annotations.
>   (I'd consider this a last resort.)
Okay, I'll rearrange the code to avoid this issue.

Thanks,
Tanmay
> 
>   ...
