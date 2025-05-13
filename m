Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8021C68F;
	Tue, 13 May 2025 05:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747113139; cv=none; b=W6Ifku89B3z3ssI5P46/4Nzo0kVEZtfvyQko2oxdlfjZGr+xKYIvnTRTPyf6h5v2RkMmgILYvgvroJIbO3w/7WFfKhnhq6gEA4kGEbt14cNuIMH6dnusCHcMMEAqhNhBvnqzSZ6OtmwytxTQMg9jdihUU1cgwzzsf0/0Utas4/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747113139; c=relaxed/simple;
	bh=FSjS40jOAhFJSGTMQ79bEsum4RlEHI1izczMihBxcWA=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mUKpnCQQvvTHFCr++mCzobjD6UGNMER82agdSQWy/713gahT/GTFWLvKZbeYQIwLg5xHIPnrurMTSjP/jpX1HaPy+cGSVd3EqEmnIi5yAnbt3DxdDv51ftir4Yo8XLPIkwnLV8VHfMCMgiaIm38CHkEF88Ay6JRWE8quI66mnoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=LyUg4sFi; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="LyUg4sFi"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54CMF6Zu006427;
	Mon, 12 May 2025 22:12:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pfpt0220; bh=lTp3ZCcbLXGuNs3STLqxAeiDa
	RgMSlPfiJGK6ixYL4E=; b=LyUg4sFiYrcKAj1s93tsCeCSTEM0praKZ+ZmtzjOL
	HNrjluUY5OEgj3fpud6/Ei3fF7ul8Wsoj7uIVqsihyqa9znveLo2AYN3CfEoDMPR
	IFM2V+wxtQTdOhOwXis81OT3ejzv/RTPu9rD/pk26gyAG57oJrCXJMztRTKCYM4B
	YKZoFtWvVFctrdI3KhL308w57ap4fm9cbfMDyUefMyuzGTfHOBkK7SjaZuAqtwHg
	CGCkWJY5uBEQkfPmos2zdZu6JsxRZcSA5VpprKGqDSuzSwjOYBd6BkJ23+lvGer4
	/N0lzzcRugCwZ6DOgFkWqlci/1rQS1AJnd3gV7NqHLwGA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 46ksm9gn61-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 May 2025 22:12:00 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Mon, 12 May 2025 22:11:59 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Mon, 12 May 2025 22:11:59 -0700
Received: from optiplex (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with SMTP id BF01B5B692A;
	Mon, 12 May 2025 22:11:50 -0700 (PDT)
Date: Tue, 13 May 2025 10:41:49 +0530
From: Tanmay Jagdale <tanmay@marvell.com>
To: Leon Romanovsky <leon@kernel.org>
CC: <brezillon@kernel.org>, <schalla@marvell.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>, <gakula@marvell.com>,
        <jerinj@marvell.com>, <hkelam@marvell.com>, <sbhatta@marvell.com>,
        <andrew+netdev@lunn.ch>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <bbhushan2@marvell.com>, <bhelgaas@google.com>,
        <pstanner@redhat.com>, <gregkh@linuxfoundation.org>,
        <peterz@infradead.org>, <linux@treblig.org>,
        <giovanni.cabiddu@intel.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <rkannoth@marvell.com>, <sumang@marvell.com>, <gcherian@marvell.com>
Subject: Re: [net-next PATCH v1 00/15] Enable Inbound IPsec offload on
 Marvell CN10K SoC
Message-ID: <aCLUlStHT7_Aob4o@optiplex>
References: <20250502132005.611698-1-tanmay@marvell.com>
 <20250505175232.GN5848@unreal>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250505175232.GN5848@unreal>
X-Authority-Analysis: v=2.4 cv=LYA86ifi c=1 sm=1 tr=0 ts=6822d4a0 cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=MHN3iWPakF92ANTadf4A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTEzMDA0NiBTYWx0ZWRfX5MuxfrCTDASi dicVZEohjUTrzPeJ2J6gudlxyA8t+/6bbrIJfv7QNfEXSvyiY4S1p8K/hC4lS225rNRLsmr1bB4 CUpaRYM5zl1//zPRElUMvRKAKFg1dBupAMw4e9gvwbG5dm1RPVmBs4p05K3lVurMNYhB7aGUuP4
 dZoRuJAGmrg8uJR+iq8dASd0Sn4qOM8+0nWJVCUsQbF3BzKcWqjk2fWsx7g7K3sbB0FdmbihrOs eBtwkbKpeWX+HrIHqGTafmhX9dj+i9FUTalQ0h6s8DjTaP/kwngY3iHoD9sJTOKcsHKe4zfYLWK qabC21ZjrXv1vhM1Gvryjs+s+ZszcqLId5a2Xy31HPxOBhozrk38dbR6ZgEi1qgrI5/E/eVBmZ8
 S1xuy7+ViFUrgmRKT5ZnFj7iFMOpNClhx3otbggAuEYc7hrjKnmd4x8lbLtb6aDyY5uRe7aJ
X-Proofpoint-GUID: IY8_YJqX3ivQTfc_sta99w4wzubmIv0V
X-Proofpoint-ORIG-GUID: IY8_YJqX3ivQTfc_sta99w4wzubmIv0V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-12_07,2025-05-09_01,2025-02-21_01

Hi Leon,

On 2025-05-05 at 23:22:32, Leon Romanovsky (leon@kernel.org) wrote:
> On Fri, May 02, 2025 at 06:49:41PM +0530, Tanmay Jagdale wrote:
> > This patch series adds support for inbound inline IPsec flows for the
> > Marvell CN10K SoC.
> 
> It will be much easier if in commit messages and comments you
> will use kernel naming, e.g. "IPsec packet offload" and not "inline IPsec", e.t.c.
Okay sure, I will update the patch series with the kernel naming
convention.

> 
> Also, I'm wonder, do you have performance numbers for this code?
Sure, I'll share the performance numbers in the next version.

> 
> Thanks
Thanks and regards,
Tanmay

> 
> > 
> > The packet flow
> > ---------------
> > An encrypted IPSec packet goes through two passes in the RVU hardware
> > before reaching the CPU.
> > First Pass:
> >   The first pass involves identifying the packet as IPSec, assigning an RQ,
> >   allocating a buffer from the Aura pool and then send it to CPT for decryption.
> > 
> > Second Pass:
> >   After CPT decrypts the packet, it sends a metapacket to NIXRX via the X2P
> >   bus. The metapacket contains CPT_PARSE_HDR_S structure and some initial
> >   bytes of the decrypted packet which would help NIXRX in classification.
> >   CPT also sets BIT(11) of channel number to further help in identifcation.
> >   NIXRX allocates a new buffer for this packet and submits it to the CPU.
> > 
> > Once the decrypted metapacket packet is delivered to the CPU, get the WQE
> > pointer from CPT_PARSE_HDR_S in the packet buffer. This WQE points to the
> > complete decrypted packet. We create an skb using this, set the relevant
> > XFRM packet mode flags to indicate successful decryption, and submit it
> > to the network stack.
> > 
> > 
> > Patches are grouped as follows:
> > -------------------------------
> > 1) CPT LF movement from crypto driver to RVU AF
> >     0001-crypto-octeontx2-Share-engine-group-info-with-AF-dri.patch
> >     0002-octeontx2-af-Configure-crypto-hardware-for-inline-ip.patch
> >     0003-octeontx2-af-Setup-Large-Memory-Transaction-for-cryp.patch
> >     0004-octeontx2-af-Handle-inbound-inline-ipsec-config-in-A.patch
> >     0005-crypto-octeontx2-Remove-inbound-inline-ipsec-config.patch
> > 
> > 2) RVU AF Mailbox changes for CPT 2nd pass RQ mask, SPI-to-SA table,
> >    NIX-CPT BPID configuration
> >     0006-octeontx2-af-Add-support-for-CPT-second-pass.patch
> >     0007-octeontx2-af-Add-support-for-SPI-to-SA-index-transla.patch
> >     0008-octeontx2-af-Add-mbox-to-alloc-free-BPIDs.patch
> > 
> > 3) Inbound Inline IPsec support patches
> >     0009-octeontx2-pf-ipsec-Allocate-Ingress-SA-table.patch
> >     0010-octeontx2-pf-ipsec-Setup-NIX-HW-resources-for-inboun.patch
> >     0011-octeontx2-pf-ipsec-Handle-NPA-threshhold-interrupt.patch
> >     0012-octeontx2-pf-ipsec-Initialize-ingress-IPsec.patch
> >     0013-octeontx2-pf-ipsec-Manage-NPC-rules-and-SPI-to-SA-ta.patch
> >     0014-octeontx2-pf-ipsec-Process-CPT-metapackets.patch
> >     0015-octeontx2-pf-ipsec-Add-XFRM-state-and-policy-hooks-f.patch
> > 
> > 
> > Bharat Bhushan (5):
> >   crypto: octeontx2: Share engine group info with AF driver
> >   octeontx2-af: Configure crypto hardware for inline ipsec
> >   octeontx2-af: Setup Large Memory Transaction for crypto
> >   octeontx2-af: Handle inbound inline ipsec config in AF
> >   crypto: octeontx2: Remove inbound inline ipsec config
> > 
> > Geetha sowjanya (1):
> >   octeontx2-af: Add mbox to alloc/free BPIDs
> > 
> > Kiran Kumar K (1):
> >   octeontx2-af: Add support for SPI to SA index translation
> > 
> > Rakesh Kudurumalla (1):
> >   octeontx2-af: Add support for CPT second pass
> > 
> > Tanmay Jagdale (7):
> >   octeontx2-pf: ipsec: Allocate Ingress SA table
> >   octeontx2-pf: ipsec: Setup NIX HW resources for inbound flows
> >   octeontx2-pf: ipsec: Handle NPA threshold interrupt
> >   octeontx2-pf: ipsec: Initialize ingress IPsec
> >   octeontx2-pf: ipsec: Manage NPC rules and SPI-to-SA table entries
> >   octeontx2-pf: ipsec: Process CPT metapackets
> >   octeontx2-pf: ipsec: Add XFRM state and policy hooks for inbound flows
> > 
> >  .../marvell/octeontx2/otx2_cpt_common.h       |    8 -
> >  drivers/crypto/marvell/octeontx2/otx2_cptpf.h |   10 -
> >  .../marvell/octeontx2/otx2_cptpf_main.c       |   50 +-
> >  .../marvell/octeontx2/otx2_cptpf_mbox.c       |  286 +---
> >  .../marvell/octeontx2/otx2_cptpf_ucode.c      |  116 +-
> >  .../marvell/octeontx2/otx2_cptpf_ucode.h      |    3 +-
> >  .../ethernet/marvell/octeontx2/af/Makefile    |    2 +-
> >  .../ethernet/marvell/octeontx2/af/common.h    |    1 +
> >  .../net/ethernet/marvell/octeontx2/af/mbox.h  |  119 +-
> >  .../net/ethernet/marvell/octeontx2/af/rvu.c   |    9 +-
> >  .../net/ethernet/marvell/octeontx2/af/rvu.h   |   71 +
> >  .../ethernet/marvell/octeontx2/af/rvu_cn10k.c |   11 +
> >  .../ethernet/marvell/octeontx2/af/rvu_cpt.c   |  706 +++++++++-
> >  .../ethernet/marvell/octeontx2/af/rvu_cpt.h   |   71 +
> >  .../ethernet/marvell/octeontx2/af/rvu_nix.c   |  230 +++-
> >  .../marvell/octeontx2/af/rvu_nix_spi.c        |  220 +++
> >  .../ethernet/marvell/octeontx2/af/rvu_reg.h   |   16 +
> >  .../marvell/octeontx2/af/rvu_struct.h         |    4 +-
> >  .../marvell/octeontx2/nic/cn10k_ipsec.c       | 1191 ++++++++++++++++-
> >  .../marvell/octeontx2/nic/cn10k_ipsec.h       |  152 +++
> >  .../marvell/octeontx2/nic/otx2_common.c       |   23 +-
> >  .../marvell/octeontx2/nic/otx2_common.h       |   16 +
> >  .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |   17 +
> >  .../marvell/octeontx2/nic/otx2_struct.h       |   16 +
> >  .../marvell/octeontx2/nic/otx2_txrx.c         |   25 +-
> >  .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |    4 +
> >  26 files changed, 2915 insertions(+), 462 deletions(-)
> >  create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.h
> >  create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix_spi.c
> > 
> > -- 
> > 2.43.0
> > 
> > 
