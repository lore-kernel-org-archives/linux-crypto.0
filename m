Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3574B6FC3;
	Thu, 10 Jul 2025 08:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752137099; cv=none; b=a4URdBCqSdF3TM9mlMXmPhagnJc06IjJ0mIlgHHv9tHwmbCq8PgszBzl4N44hKh/G1nz4Ks11cCXKddPXzKZ7FoE4GxawU2Rs36NeJDEGuG9xaYYW9PhLb6wr8Ma0xKqhfetyWquAyxHWmeTFJCurdK1uNULgrYLEozu4fN8AQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752137099; c=relaxed/simple;
	bh=0DeIS/eUKc5l8nyQlnzRZZMUEK1nHPCumjn758um+H0=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KCAg6AqjlSAseaBWP0KQDEqpBMgqnsArg8w/1JdfHE8XAEmTyrRm4oOnp8UlPj9IqNRSIVobRbHMVGM8L2jJASSWctwxOjCtvBK5/j18uBnABRar5IGJeRGnaLihYr9k+//Nixxtz6dA0543xpOIVFaD62p/X1Mb8yKVgJSAmlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=VHbJ5ziv; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="VHbJ5ziv"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 569NcE4G028281;
	Thu, 10 Jul 2025 01:44:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pfpt0220; bh=f4wV+OEdxP/NnVe0R8EZ110HL
	V6sAhW7nZL2hCAMY3Q=; b=VHbJ5zivrULuzEm+CLFbhliBE3NMiupuWIjVkyABY
	+ODugE8E2qJjb3iARs21exacDcn2vBHFp1XCP51F06sxuOid4pDMbmdPYmtlb3BL
	OOdSvngV5uRsxx8XAD+renNTZaJ5AOYrAcCOBIg7FE0rx1dPXBd0qvGRqVMmT8J5
	twMQXtezbALdDUVqAn5A3yOWUZHJiCaR7ZHGDN+81e4a+L88d5qPqtOMQPh6mZey
	u5t6+lDfI594HXWZpmBmMQCZOaElXbKjbGhvR0aWIUFYW7fJORBR6ztGTp1qFAgK
	WOvs4ZU4MBlP8Xpc7yJYv970tuKRcZ+Eirz4IgLbDud0w==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 47t26d97q3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Jul 2025 01:44:50 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 10 Jul 2025 01:44:49 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Thu, 10 Jul 2025 01:44:49 -0700
Received: from optiplex (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with SMTP id 69EFF3F7041;
	Thu, 10 Jul 2025 01:44:46 -0700 (PDT)
Date: Thu, 10 Jul 2025 14:14:45 +0530
From: Tanmay Jagdale <tanmay@marvell.com>
To: Simon Horman <horms@kernel.org>
CC: <davem@davemloft.net>, <leon@kernel.org>, <sgoutham@marvell.com>,
        <bbhushan2@marvell.com>, <herbert@gondor.apana.org.au>,
        <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 12/14] octeontx2-pf: ipsec: Process CPT
 metapackets
Message-ID: <aG99fdMVhJUNhxtZ@optiplex>
References: <20250618113020.130888-1-tanmay@marvell.com>
 <20250618113020.130888-13-tanmay@marvell.com>
 <20250620110657.GK194429@horms.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250620110657.GK194429@horms.kernel.org>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzEwMDA3NCBTYWx0ZWRfX1JOxMuumyVo3 ZazVfy6JmgnC3QcbC2kx4EEkBGJ8pI7ZtQkCT9R+Unih6KP/YC/VdVbEyl9OGjjk7NrDAOI6ZJA pfDt7WMzC+niz404yBSN/sfEuLxV/gvv3xC67YqvqQBYaA+1Z6hWSuBG++H832BLfVRdZEPad1C
 kK4WS3dMWuJxDKvpbPoaxSSCHyMi9dOZOl3436P2RHu0Qe/ArBX133wjWU4iDWxChWRAfbjQogV Irhxfu7AKVc+LSVM1qkT2EZKg09KwoFqwen/2WEX+JizMQuLF5dHuCO4ZDfjTIpuSO17kne1ciP mym95dJ5JOFGA5ztrryhhdmewdWeP2yF5PaYiropo1KpInpUT16ijrZvvmt8k8Xb25OIv3ZMaQl
 0QmyZ3JsWaUJ5auFqz0nR7r4bAqQVXjTKhVzgVmNd174VsqMT8vKnInkSy8Bd/1KvBsaqBM0
X-Proofpoint-GUID: KEqZ1-LRdpnbRpSQs1QwHKIvGJzVjeIV
X-Proofpoint-ORIG-GUID: KEqZ1-LRdpnbRpSQs1QwHKIvGJzVjeIV
X-Authority-Analysis: v=2.4 cv=O8A5vA9W c=1 sm=1 tr=0 ts=686f7d82 cx=c_pps a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8 a=BK0mZRYZI33l8Kwai9EA:9 a=CjuIK1q_8ugA:10
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-10_01,2025-07-09_01,2025-03-28_01

On 2025-06-20 at 16:36:57, Simon Horman (horms@kernel.org) wrote:
> On Wed, Jun 18, 2025 at 05:00:06PM +0530, Tanmay Jagdale wrote:
> > CPT hardware forwards decrypted IPsec packets to NIX via the X2P bus
> > as metapackets which are of 256 bytes in length. Each metapacket
> > contains CPT_PARSE_HDR_S and initial bytes of the decrypted packet
> > that helps NIX RX in classifying and submitting to CPU. Additionally,
> > CPT also sets BIT(11) of the channel number to indicate that it's a
> > 2nd pass packet from CPT.
> > 
> > Since the metapackets are not complete packets, they don't have to go
> > through L3/L4 layer length and checksum verification so these are
> > disabled via the NIX_LF_INLINE_RQ_CFG mailbox during IPsec initialization.
> > 
> > The CPT_PARSE_HDR_S contains a WQE pointer to the complete decrypted
> > packet. Add code in the rx NAPI handler to parse the header and extract
> > WQE pointer. Later, use this WQE pointer to construct the skb, set the
> > XFRM packet mode flags to indicate successful decryption before submitting
> > it to the network stack.
> > 
> > Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
> > ---
> > Changes in V2:
> > - Removed unnecessary casts
> > - Don't convert complete cpt_parse_hdr from BE to LE and just
> >   convert required fields
> > - Fixed logic to avoid repeated calculation for start and end in sg
> > 
> > V1 Link: https://lore.kernel.org/netdev/20250502132005.611698-15-tanmay@marvell.com/
> > 
> >  .../marvell/octeontx2/nic/cn10k_ipsec.c       | 52 +++++++++++++++++++
> >  .../marvell/octeontx2/nic/cn10k_ipsec.h       | 48 +++++++++++++++++
> >  .../marvell/octeontx2/nic/otx2_common.h       |  2 +
> >  .../marvell/octeontx2/nic/otx2_struct.h       | 16 ++++++
> >  .../marvell/octeontx2/nic/otx2_txrx.c         | 29 +++++++++--
> >  5 files changed, 144 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
> > index 5cb6bc835e56..a95878378334 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
> > @@ -346,6 +346,58 @@ static int cn10k_outb_cpt_init(struct net_device *netdev)
> >  	return ret;
> >  }
> >  
> > +struct nix_wqe_rx_s *cn10k_ipsec_process_cpt_metapkt(struct otx2_nic *pfvf,
> > +						     struct nix_cqe_rx_s *cqe,
> > +						     struct sk_buff *skb,
> > +						     int qidx)
> > +{
> > +	struct nix_rx_sg_s *sg = &cqe->sg;
> > +	struct nix_wqe_rx_s *wqe = NULL;
> > +	u64 *seg_addr = &sg->seg_addr;
> > +	struct cpt_parse_hdr_s *cptp;
> > +	struct xfrm_offload *xo;
> > +	struct xfrm_state *xs;
> > +	struct sec_path *sp;
> > +	void *va;
> > +
> > +	/* CPT_PARSE_HDR_S is present in the beginning of the buffer */
> > +	va = phys_to_virt(otx2_iova_to_phys(pfvf->iommu_domain, *seg_addr));
> > +
> > +	cptp = (struct cpt_parse_hdr_s *)va;
> > +
> > +	/* Convert the wqe_ptr from CPT_PARSE_HDR_S to a CPU usable pointer */
> > +	wqe = phys_to_virt(otx2_iova_to_phys(pfvf->iommu_domain,
> > +					     be64_to_cpu(cptp->wqe_ptr)));
> 
> Hi Tanmay,
Hi Simon,

> 
> be64_to_cpu expects a __be64 argument, but the type of cptp->wqe_ptr is u64.
> Or, IOW, be64_to_cpu expects to be based a big endian value but
> the type of it's argument is host byte order.
Okay. I will fix the structure definition to use __be types.

> 
> > +
> > +	/* Get the XFRM state pointer stored in SA context */
> > +	xs = pfvf->ipsec.inb_sa->base +
> > +	     (be32_to_cpu(cptp->cookie) * pfvf->ipsec.sa_tbl_entry_sz) + 1024;
> 
> Likewise with cookie here.
ACK.

> 
> :Flagged by Sparse.
> 
> ...
> 
With Regards,
Tanmay
