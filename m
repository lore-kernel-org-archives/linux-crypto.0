Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31BFC101EE;
	Tue, 13 May 2025 06:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747116763; cv=none; b=OxsTf9umW/i3F1rCPx9dCeFCeXKMXnOu64Exq28Wa+NbnPcy71OfFtS+qxgZP6kCYHxi+BepClC/AY3XkZxkWGvzxLusEFD/rui8cXk8WQCZdvY1jkzlRvLd1251F6anCJUlTQCHIfcZqh/Nt54fKuhPcY4DGCuf2sUWTlOPoUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747116763; c=relaxed/simple;
	bh=p64bO3K4W8tGMzIR2yPBwFJkK/o2ty54bUOLqfL09TM=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t3o9EDF5yowwfYPGj0lvzq00+BWoZ5+TRkE+zjFKaUmfv6UHwy2iwkJBtmws9lsujj5yEXn1BrjtBwvY6TAZSbjjx89xideTEADXwk0fFaSeOOKXsmVdMbAsCS7yrjxjf8fZUosEkolqw8f0DjJ4biQVcR/tofEd7B6zZ/WEcSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Bt65S1qM; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Bt65S1qM"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54CNfi1H026767;
	Mon, 12 May 2025 23:12:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pfpt0220; bh=U5kOMZuzPBvMyY4bCoAF/fh2o
	1zBtyRTqAPgXNnaRQ8=; b=Bt65S1qMv1+fQ4Lmalt50zSvgGgoYZhMFa8m8udxL
	eeFSEQYihR0liRKGCuu8IFmAXJ2D/hzeIb1qEC+5owPhekQI9ImnXBvtxe0jUhuJ
	YRbbRWS2K1HRGvrTGy/5b4Nvi+8zLoVK401adNv5wwihqB8/Cf1QUTbj8/tnmHQU
	XPWltEBuLGngUZ8S/hyKNd0VFdE4TJrzigmzJzQWAqnOVTmRSpLFtGtGBJYRG7GD
	prlTMV1wx1POfz/EmT8G1yXNA+LseYHAlP0je3vmS5ETDSdQYnPMEAF5pLritSMs
	j/kA8qHQ66ESP68mmpHcwPnHhk1YCD01OPVmeL1IXNTWA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 46ktvr0kmp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 May 2025 23:12:25 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Mon, 12 May 2025 23:12:25 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Mon, 12 May 2025 23:12:24 -0700
Received: from optiplex (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with SMTP id AC5013F70A4;
	Mon, 12 May 2025 23:12:16 -0700 (PDT)
Date: Tue, 13 May 2025 11:42:15 +0530
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
        <gcherian@marvell.com>, "Kiran
 Kumar K" <kirankumark@marvell.com>,
        Nithin Dabilpuram
	<ndabilpuram@marvell.com>
Subject: Re: [net-next PATCH v1 07/15] octeontx2-af: Add support for SPI to
 SA index translation
Message-ID: <aCLivwtIq5zwVFKI@optiplex>
References: <20250502132005.611698-1-tanmay@marvell.com>
 <20250502132005.611698-8-tanmay@marvell.com>
 <20250507124517.GC3339421@horms.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250507124517.GC3339421@horms.kernel.org>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTEzMDA1NiBTYWx0ZWRfX4pgD43kFI/cW CIA1lqbjCkuRcZJSt2JhPK7hVaLOUs1WX1bUQC3dwCTYUAln2KkbBAG3//SgFaalEtP04IjC5Yb hrFnWqd1eAX8e7MJNXPKR8eMSU5diTXFNtATaKa7tETF/Jr0BXsqYzVkEeN6nefiqFaHgpvYZkw
 ymM3vv1jTnTLKAk7YEEVCCWpSHIkA+1TppwVhmhKFedC554OseCwW3g1f3AMrirzQG1BwJw8VAD T8l2Lel64ytBkBFyB/R1qB6eFajEGUForqrOfe6KiWUHi9DKf/1gu5SK6Q6oHN8/0BX2NoKr5vt 93xJ50Am0f85nEwmThno78xdVNnNf5zIcAv43aK70CA1+NCYdTOXSjKmJkwq03FxNZNkV61f+iu
 /c5bL8AnmB1+JcKNWnLcNyxjPNZoK07JSL2edfWNfOfPc24xaj8OWBfBEkijcx9H131j6MHi
X-Authority-Analysis: v=2.4 cv=V6x90fni c=1 sm=1 tr=0 ts=6822e2c9 cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8 a=fMs116VxaZ394lWZzjIA:9 a=CjuIK1q_8ugA:10
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: Vp5ijUOX21Gbk8xEyHqlbuNUmgRkwazK
X-Proofpoint-GUID: Vp5ijUOX21Gbk8xEyHqlbuNUmgRkwazK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-12_07,2025-05-09_01,2025-02-21_01

On 2025-05-07 at 18:15:17, Simon Horman (horms@kernel.org) wrote:
> On Fri, May 02, 2025 at 06:49:48PM +0530, Tanmay Jagdale wrote:
> > From: Kiran Kumar K <kirankumark@marvell.com>
> > 
> > In case of IPsec, the inbound SPI can be random. HW supports mapping
> > SPI to an arbitrary SA index. SPI to SA index is done using a lookup
> > in NPC cam entry with key as SPI, MATCH_ID, LFID. Adding Mbox API
> > changes to configure the match table.
> > 
> > Signed-off-by: Kiran Kumar K <kirankumark@marvell.com>
> > Signed-off-by: Nithin Dabilpuram <ndabilpuram@marvell.com>
> > Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> > Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
> 
> ...
> 
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> > index 715efcc04c9e..5cebf10a15a7 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> > +++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> > @@ -326,6 +326,10 @@ M(NIX_READ_INLINE_IPSEC_CFG, 0x8023, nix_read_inline_ipsec_cfg,		\
> >  M(NIX_LF_INLINE_RQ_CFG, 0x8024, nix_lf_inline_rq_cfg,		\
> >  				nix_rq_cpt_field_mask_cfg_req,  \
> >  				msg_rsp)	\
> > +M(NIX_SPI_TO_SA_ADD,    0x8026, nix_spi_to_sa_add, nix_spi_to_sa_add_req,   \
> > +				nix_spi_to_sa_add_rsp)                      \
> > +M(NIX_SPI_TO_SA_DELETE, 0x8027, nix_spi_to_sa_delete, nix_spi_to_sa_delete_req,   \
> > +				msg_rsp)                                        \
> 
> Please keep line length to 80 columns or less in Networking code,
> unless it reduces readability.
> 
> In this case perhaps:
> 
> M(NIX_SPI_TO_SA_DELETE, 0x8027, nix_spi_to_sa_delete,     \
> 				nix_spi_to_sa_delete_req, \
> 				msg_rsp)                  \
> 
> Likewise throughout this patch (set).
> checkpatch.pl --max-line-length=80 is your friend.
ACK. I will adhere to the 80 columns in the next version.

Regards,
Tanmay

> 
> >  M(NIX_MCAST_GRP_CREATE,	0x802b, nix_mcast_grp_create, nix_mcast_grp_create_req,	\
> >  				nix_mcast_grp_create_rsp)			\
> >  M(NIX_MCAST_GRP_DESTROY, 0x802c, nix_mcast_grp_destroy, nix_mcast_grp_destroy_req,	\
> 
> ...
