Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC4A264610;
	Thu, 22 May 2025 09:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747905741; cv=none; b=myhh6Ee4Bl8RfU0zLm1UZ9h6sfEBh86v+vG73aU9AxefBtKlbp6Yld2MaMLUS4qsBZQODh41EykJKfZMdjkeqxjuYrmIBVl/IINx3aKi3ntsGFFXAAWzFi3YKMFVvDMPgkAOjHBudxAluDral6Qn+IPOSj9YSPqpaBe85Ne89A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747905741; c=relaxed/simple;
	bh=Kc587A2Fx0EyjRROTIYd15K32+Jcj2thHWlVFSezv/c=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lQ054jk0pVeZYcLIKKUhEL5ZMyKqRaeP7bzwjVjuHjaHH0IwvbgQ2HCX9BhPhVJzY7R+pkGEhb2DdBt6265Ei/F6cjFqXyChnFHSxajTKMWHFlr82lKJ8p7hT+aeumkXcXTcMoFDNfx9PnWOXCRYUqFBvbeaZo3fjDrZ1L+7PMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=O3QhSCJj; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="O3QhSCJj"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54M6WIam008628;
	Thu, 22 May 2025 02:21:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pfpt0220; bh=AS/TcJ7cmLOB+ZLmbKmU5Cdjf
	txToHQTNxnfSnqjuYU=; b=O3QhSCJj1X6rN0dXTOhnK/4OXLWxI1YM8TOqpoEV6
	OStTP0JVX+jbKAbaZXVAtTmgonIFBMStQxXxmp6vHNYbaYWRT1/x9BXkc9I5FPLZ
	OWB5HnGj9bkxizx8DMg72vE4uZtXQCNMLtw8lLal+9zPp/Hk8OyQglAEhg77liJg
	xybsf20G5V0RWq1Bbn4o1W/tqPdJDcfVFbQeLPpuN7UhKjW2JXOVI57OFxWV1nA+
	pJpVGYAcaF03tWigNG88iUkgcmCQoSaesASICOhAZZsaXGWq0dn1pdKFV/BF+kP/
	wQU4AYHc3Ne+bPji8+bCMZPUQ6A8H89xm4pfSYMuWg4Fg==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 46sxr1g98m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 02:21:54 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 22 May 2025 02:21:52 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Thu, 22 May 2025 02:21:52 -0700
Received: from optiplex (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with SMTP id E30D95B694B;
	Thu, 22 May 2025 02:21:45 -0700 (PDT)
Date: Thu, 22 May 2025 14:51:44 +0530
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
        <netdev@vger.kernel.org>, <gcherian@marvell.com>
Subject: Re: [net-next PATCH v1 09/15] octeontx2-pf: ipsec: Allocate Ingress
 SA table
Message-ID: <aC7sqDaHtFk-K8oV@optiplex>
References: <20250502132005.611698-1-tanmay@marvell.com>
 <20250502132005.611698-10-tanmay@marvell.com>
 <20250507125625.GD3339421@horms.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250507125625.GD3339421@horms.kernel.org>
X-Proofpoint-GUID: qij0y2j8xFsmT6GCTGwSUZXIJy9bAk9m
X-Proofpoint-ORIG-GUID: qij0y2j8xFsmT6GCTGwSUZXIJy9bAk9m
X-Authority-Analysis: v=2.4 cv=LYU86ifi c=1 sm=1 tr=0 ts=682eecb2 cx=c_pps a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8 a=XLaGVqOJLA6SmLViI-gA:9 a=CjuIK1q_8ugA:10
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIyMDA5MyBTYWx0ZWRfXxwG0E6W2G08s t1nrin2JKqnMo0/zDITFhUbGg09HIMRJJo/9LcRywlb4W1GGR3AHC/AJkvu9rmDfRL30WxtwY7i jv65ixHET2bYk4xZjcPOaDgcyGUHi/SiH1aV9lKY0nm3nc8jYE7p3fw4nFIQL5npDKwItSpOm07
 9/v5kQDa23LWFV5cma+ugqHL5n57ij5NlNC7nTsWA0KZZsnUpNP1wO6vV11jaCtbEBVIhjrv8Fz FhGPE1K7rMti30KoZ2z0Ci+fPwHvl08wIeATHFDv9Q7Xm4qE66fbNf9hGOSEi9u8EX3goArb7yC jqG06th2R24kbHeZkOOJ4dgpCbNPliPlK00f7Z/PcSwwlrAOZzk9xLhjnqkt3eEX2DyBH5TsSoc
 LNYMWW1l5sBAVa+lw4IGv6Rdk8oZzN4rT+ix4BfdB+7t/yVw/Bd9O+m79B0Jkqy31wNNhPVE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-22_04,2025-05-22_01,2025-03-28_01

Hi Simon,

On 2025-05-07 at 18:26:25, Simon Horman (horms@kernel.org) wrote:
> On Fri, May 02, 2025 at 06:49:50PM +0530, Tanmay Jagdale wrote:
> > Every NIX LF has the facility to maintain a contiguous SA table that
> > is used by NIX RX to find the exact SA context pointer associated with
> > a particular flow. Allocate a 128-entry SA table where each entry is of
> > 2048 bytes which is enough to hold the complete inbound SA context.
> > 
> > Add the structure definitions for SA context (cn10k_rx_sa_s) and
> > SA bookkeeping information (ctx_inb_ctx_info).
> > 
> > Also, initialize the inb_sw_ctx_list to track all the SA's and their
> > associated NPC rules and hash table related data.
> > 
> > Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
> 
> ...
> 
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
> 
> ...
> 
> > @@ -146,6 +169,76 @@ struct cn10k_tx_sa_s {
> >  	u64 hw_ctx[6];		/* W31 - W36 */
> >  };
> >  
> > +struct cn10k_rx_sa_s {
> > +	u64 inb_ar_win_sz	: 3; /* W0 */
> > +	u64 hard_life_dec	: 1;
> > +	u64 soft_life_dec	: 1;
> > +	u64 count_glb_octets	: 1;
> > +	u64 count_glb_pkts	: 1;
> > +	u64 count_mib_bytes	: 1;
> > +	u64 count_mib_pkts	: 1;
> > +	u64 hw_ctx_off		: 7;
> > +	u64 ctx_id		: 16;
> > +	u64 orig_pkt_fabs	: 1;
> > +	u64 orig_pkt_free	: 1;
> > +	u64 pkind		: 6;
> > +	u64 rsvd_w0_40		: 1;
> > +	u64 eth_ovrwr		: 1;
> > +	u64 pkt_output		: 2;
> > +	u64 pkt_format		: 1;
> > +	u64 defrag_opt		: 2;
> > +	u64 x2p_dst		: 1;
> > +	u64 ctx_push_size	: 7;
> > +	u64 rsvd_w0_55		: 1;
> > +	u64 ctx_hdr_size	: 2;
> > +	u64 aop_valid		: 1;
> > +	u64 rsvd_w0_59		: 1;
> > +	u64 ctx_size		: 4;
> > +
> > +	u64 rsvd_w1_31_0	: 32; /* W1 */
> > +	u64 cookie		: 32;
> > +
> > +	u64 sa_valid		: 1; /* W2 Control Word */
> > +	u64 sa_dir		: 1;
> > +	u64 rsvd_w2_2_3		: 2;
> > +	u64 ipsec_mode		: 1;
> > +	u64 ipsec_protocol	: 1;
> > +	u64 aes_key_len		: 2;
> > +	u64 enc_type		: 3;
> > +	u64 life_unit		: 1;
> > +	u64 auth_type		: 4;
> > +	u64 encap_type		: 2;
> > +	u64 et_ovrwr_ddr_en	: 1;
> > +	u64 esn_en		: 1;
> > +	u64 tport_l4_incr_csum	: 1;
> > +	u64 iphdr_verify	: 2;
> > +	u64 udp_ports_verify	: 1;
> > +	u64 l2_l3_hdr_on_error	: 1;
> > +	u64 rsvd_w25_31		: 7;
> > +	u64 spi			: 32;
> 
> As I understand it, this driver is only intended to run on arm64 systems.
> While it is also possible, with COMPILE_TEST test, to compile the driver
> on for 64-bit systems.
Yes, this driver works only on Marvell CN10K SoC. I have COMPILE_TESTed
on x86 and ARM64 platforms.

> 
> So, given the first point above, this may be moot. But the above
> assumes that the byte order of the host is the same as the device.
> Or perhaps more to the point, it has been written for a little-endian
> host and the device is expecting the data in that byte order.
> 
> But u64 is supposed to represent host byte order.  And, in my understanding
> of things, this is the kind of problem that FIELD_PREP and FIELD_GET are
> intended to avoid, when combined on endian-specific integer types (in this
> case __le64 seems appropriate).
> 
> I do hesitate in bringing this up, as the above very likely works on
> all systems on which this code is intended to run. But I do so
> because it is not correct on all systems for which this code can be
> compiled. And thus seems somehow misleading.
Okay. Are you referring to a case where we compile on BE machine
and then run on LE platform?

With Regards,
Tanmay
> 
> > +
> > +	u64 w3;			/* W3 */
> > +
> > +	u8 cipher_key[32];	/* W4 - W7 */
> > +	u32 rsvd_w8_0_31;	/* W8 : IV */
> > +	u32 iv_gcm_salt;
> > +	u64 rsvd_w9;		/* W9 */
> > +	u64 rsvd_w10;		/* W10 : UDP Encap */
> > +	u32 dest_ipaddr;	/* W11 - Tunnel mode: outer src and dest ipaddr */
> > +	u32 src_ipaddr;
> > +	u64 rsvd_w12_w30[19];	/* W12 - W30 */
> > +
> > +	u64 ar_base;		/* W31 */
> > +	u64 ar_valid_mask;	/* W32 */
> > +	u64 hard_sa_life;	/* W33 */
> > +	u64 soft_sa_life;	/* W34 */
> > +	u64 mib_octs;		/* W35 */
> > +	u64 mib_pkts;		/* W36 */
> > +	u64 ar_winbits;		/* W37 */
> > +
> > +	u64 rsvd_w38_w100[63];
> > +};
> > +
> >  /* CPT instruction parameter-1 */
> >  #define CN10K_IPSEC_INST_PARAM1_DIS_L4_CSUM		0x1
> >  #define CN10K_IPSEC_INST_PARAM1_DIS_L3_CSUM		0x2
