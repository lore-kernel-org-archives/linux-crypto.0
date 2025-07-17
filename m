Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A2710A1E;
	Thu, 17 Jul 2025 15:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752764933; cv=none; b=Z6ry6bH4G07AthZMoVC9hzABQMzssBxhLUkmZJ0YPJPxtbh+jl4ScBKBixn8YKADJS4PaXBGBDqSaghyOCOSmWh8E93IApBRwcDGRKQMozndyWEeG0kJz28Stx3MCoT029lt2C3J/PdnEo3pgbea7JWQBofGPkeny+E5g4b3+GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752764933; c=relaxed/simple;
	bh=/Eq7NOE5+XIRCyse9ECEmTJALImm86ypRzsIq6t2SnE=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KLu2jCQczOcZkSeq5CpXaaZu7mbuLyFql6ly3xsPbWp+7d5yh42HO8U0Ltdsq5TfMt2N8eUq+zLRvfIGV5EJytW/GeGs9hDqaELEVgXnfDwKhyYCi0VKAX+WNCo8H3E1s4tHkDlwLLDVag9EJbkDgcg8K9o8Xwx/shVfGtF2z0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Fdqy24+Q; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Fdqy24+Q"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56H9e6ub019647;
	Thu, 17 Jul 2025 08:08:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pfpt0220; bh=zL1/WKk2kbs2RG2LuyEl7KF3H
	DssQBVuXmgH86kdMwU=; b=Fdqy24+Qa0AHORGBVxVvpklEGEDSCxITCE5deNQ5B
	r88ahmJeILZedTJTNWDPiCrYWSyRDatQFNDmm+ymw0pP5dVDk/Dsc5J4p3ohOnCP
	VFs0uOJLiayd06RAhF0uAS5ZQrpNxwar5JG1rxARgIVjtl9ZByLcPNPQRQIPyIej
	bVFKSuCtTcPaZRaKkRGbfYhnFzpL8SE+atJtn54sdKWrWTFh8PMt8xkZSaKVe5FH
	elOiFHxQMs9oWM1dFasa4mG8aiTsiBEfM1QwQsxR0Y7K+GoTMEMo4bXZpB0hm/ZI
	iMSHBOtoH94anC3A42/yE174WFDLALgi5oKmVlGrzM8cQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 47xvpc8vyd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 17 Jul 2025 08:08:43 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 17 Jul 2025 08:08:42 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Thu, 17 Jul 2025 08:08:42 -0700
Received: from optiplex (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with SMTP id 72EEA3F7044;
	Thu, 17 Jul 2025 08:08:40 -0700 (PDT)
Date: Thu, 17 Jul 2025 20:38:39 +0530
From: Tanmay Jagdale <tanmay@marvell.com>
To: Simon Horman <horms@kernel.org>
CC: <davem@davemloft.net>, <leon@kernel.org>, <herbert@gondor.apana.org.au>,
        <sgoutham@marvell.com>, <bbhushan2@marvell.com>,
        <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v3 12/14] octeontx2-pf: ipsec: Process CPT
 metapackets
Message-ID: <aHkR9xKzLmlT7RGF@optiplex>
References: <20250711121317.340326-1-tanmay@marvell.com>
 <20250711121317.340326-13-tanmay@marvell.com>
 <20250712133950.GB721198@horms.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250712133950.GB721198@horms.kernel.org>
X-Authority-Analysis: v=2.4 cv=U8ySDfru c=1 sm=1 tr=0 ts=687911fb cx=c_pps a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8 a=WR_fGqPjigfsp-EJftMA:9 a=CjuIK1q_8ugA:10
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: S-vAfiR-lBpAZlEbAk8CyXeZ1t7pgpZH
X-Proofpoint-ORIG-GUID: S-vAfiR-lBpAZlEbAk8CyXeZ1t7pgpZH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzE3MDEzMyBTYWx0ZWRfX/TSAt3t2AN9+ yRQgRMz9/D6lSgZboq57HP1tMk9HlDIZuvJGdaTev173OsOXkISYqN+Vii5N++CZi5y/xnrfN4R rc6XW2pnIlMSMOwJhAxsNr8M693TfFEkre+E4gK2Ys5y4vM4CR0zowQWlglkKtRz5+JSh/B5tp8
 vhmDCkqAwhgGiOGAU1nX3vu5X5kFGExR4qvqcnCE2duVTEZQnuwC8x7KxYLW+MWiZJM7GbxW4Ux XPW9NWNNd3lLSR4q/eJrRO3P/3jO3Uu9xl9k+UoDrnekhg5fap1LKOkYE7XmgdfRNnvmjzDxhkG BIp2yGJoUgUpTarhPAh7qEVS+VY5CYS8V3MYdNDRERYLjOUN8CYU1GVBixJYASfsbwz5sqRRo7g
 AANuHqpeSOQxlbNeHnYi61LMo2WpPLbjYD61+4C0Trs/fxcVdBoy3nh6LEytFplCqm7GoCgP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-17_01,2025-07-17_02,2025-03-28_01

Hi Simon,

On 2025-07-12 at 19:09:50, Simon Horman (horms@kernel.org) wrote:
> On Fri, Jul 11, 2025 at 05:43:05PM +0530, Tanmay Jagdale wrote:
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
> > Changes in V3:
> > - Updated cpt_parse_hdr_s structure to use __be64 type
> 
> ...
> 
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
> 
> ...
> 
> > @@ -302,6 +303,41 @@ struct cpt_sg_s {
> >  	u64 rsvd_63_50	: 14;
> >  };
> >  
> > +/* CPT Parse Header Structure for Inbound packets */
> > +struct cpt_parse_hdr_s {
> > +	/* Word 0 */
> > +	__be64 pkt_out     : 2;
> > +	__be64 num_frags   : 3;
> > +	__be64 pad_len     : 3;
> > +	__be64 pkt_fmt     : 1;
> > +	__be64 et_owr      : 1;
> > +	__be64 reserved_53 : 1;
> > +	__be64 reas_sts    : 4;
> > +	__be64 err_sum     : 1;
> > +	__be64 match_id    : 16;
> > +	__be64 cookie      : 32;
> > +
> > +	/* Word 1 */
> > +	__be64 wqe_ptr;
> > +
> > +	/* Word 2 */
> > +	__be64 fi_offset   : 5;
> > +	__be64 fi_pad      : 3;
> > +	__be64 il3_off     : 8;
> > +	__be64 pf_func     : 16;
> > +	__be64 res_32_16   : 16;
> > +	__be64 frag_age    : 16;
> > +
> > +	/* Word 3 */
> > +	__be64 spi         : 32;
> > +	__be64 res3_32_16  : 16;
> > +	__be64 uc_ccode    : 8;
> > +	__be64 hw_ccode    : 8;
> 
> Sparse complains about this and I'm not at all sure
> how __be64 bitfields function on little endian systems.
> 
> I'd suggest using u64 members (not bitfields) and a combination of
> FIELD_GET/FIELD_PREP, BITULL/GENMASK_ULL, and cpu_from_be64/be64_from_cpu.
Okay sure. I will switch to FIELD_GET/PREP mechanism in the next version.

With Regards,
Tanmay
> 
> > +
> > +	/* Word 4 */
> > +	__be64 misc;
> > +};
> > +
> 
> ...
> 
> -- 
> pw-bot: changes-requested
