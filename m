Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2356B1C3C04;
	Thu, 22 May 2025 09:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747907843; cv=none; b=l2gWTNp9hcQN8olkUtSxgzAuXZwqqEcA0wk+OagX0gd63ethmHKQ9D5c12NLktoLtA1ZasoNpos/KDrEYmJIhA7zrpPIXxRWxTLVuiwP3fHBPTsswLNZaHoO/PP4rdeL+7TkoKU2os6mlAfrHFva11+4/xr+LaLI55AR/oGBP0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747907843; c=relaxed/simple;
	bh=I+T2DFgD4Wkhez1vjEguVZ232wfoYzqajr/YfVynwOk=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xv6lmGPooFulTaDVzkvou0nKY7YIrjr73+8KoY/J1waEf6rKAOo/LlJ2F5etzHMQI6UmdMNL8/gz2eokAAU4SPoQDdBFzItIw8gZJUu422sRSPBZZVxFRBmiBXSky236fP652+jwR1jvj8osh7qUCBwcBLw5wbjbwhcck+tVFjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=P7hKRzYr; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="P7hKRzYr"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54LM5u1r008998;
	Thu, 22 May 2025 02:57:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pfpt0220; bh=U5c7mPteqm2QUW6HY0HaYiBAa
	DrbsHXfzznmnKoaOjA=; b=P7hKRzYrXR4vtRMss82gvrzPREdnS5Sbx7n199BIE
	Ddus++h7tkBbnI8VjfyORwFpTMon0w04M1EHKr3yH/X9EraJTTif767k2ZILhhlC
	3aO1GITj7htEHHbUuf9x1dnJ3ElIa54H9yz2akeS83GxTnezHcdixU6t5kDcGLAB
	MzLnAi9nmw4oqDt8kAFoH7zadYQtPZJGhTq+JGQLKyvabtr2/SN2H/pfbsWOo/Gz
	ciAU2exPTBIMsDDL+kaZXjV/VbbI6JNqHS90wO2zwqXIr4HWoqFDbjWFtzA+QBbx
	b/jn+5wdKCHS2Qnbl49NCMViVOlf0nXDq6f/T6Ctgp2hA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 46sqap94kg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 02:57:03 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 22 May 2025 02:57:02 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Thu, 22 May 2025 02:57:02 -0700
Received: from optiplex (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with SMTP id 70DD85B694A;
	Thu, 22 May 2025 02:56:54 -0700 (PDT)
Date: Thu, 22 May 2025 15:26:53 +0530
From: Tanmay Jagdale <tanmay@marvell.com>
To: Simon Horman <horms@kernel.org>
CC: <bbrezillon@kernel.org>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <hkelam@marvell.com>,
        <sbhatta@marvell.com>, <andrew+netdev@lunn.ch>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <bbhushan2@marvell.com>,
        <bhelgaas@google.com>, <pstanner@redhat.com>,
        <gregkh@linuxfoundation.org>, <peterz@infradead.org>,
        <linux@treblig.org>, <krzysztof.kozlowski@linaro.org>,
        <giovanni.cabiddu@intel.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <gcherian@marvell.com>
Subject: Re: [net-next PATCH v1 10/15] octeontx2-pf: ipsec: Setup NIX HW
 resources for inbound flows
Message-ID: <aC705Y7wYuz0VBE8@optiplex>
References: <20250502132005.611698-1-tanmay@marvell.com>
 <20250502132005.611698-11-tanmay@marvell.com>
 <20250507134620.GE3339421@horms.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250507134620.GE3339421@horms.kernel.org>
X-Proofpoint-GUID: DM6Zzi29iDZqzoj-n7lfV2d8l9h30JFP
X-Authority-Analysis: v=2.4 cv=HfgUTjE8 c=1 sm=1 tr=0 ts=682ef4ef cx=c_pps a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8 a=9AdEF_yJOJiG8JO9BV4A:9 a=CjuIK1q_8ugA:10
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: DM6Zzi29iDZqzoj-n7lfV2d8l9h30JFP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIyMDEwMCBTYWx0ZWRfX1PTh1w7/ba4W WOztI0fVvvp4vK9C6d92Uq8GhdKKedqhODoZF/3s5+ykr9iZ+7lYc4UlsFNx68Bsa5vm/9Y4GNz MeBXkvreEZjeRuDH1Wg1F692pvh1ZFzW49v6mIOw0lxQnsI+udaVKDPoEBzroopyLi428GYnjKG
 6VOmdSK3OzzE2ZbWNUdYHhK4DCqIbOsEMkr7+Pt7ZBYCm8rzxOxfc3DqIfG0kkV9kDTNP97JT0U x/UtqZSK1UHZ5TOAviiL4/cCyNBA8jz70IgBz9koWpCfloKV2uBrhwG88EdrdogjXUvM5yFTdjf I7bBcmCwE9Zm4jY/uD0AorH1UXiLqz5B6mokFxFPFJtDEnbnhABfyLxE+ru+MDzJ6X5tLUllZnq
 0SjhVxinQzJ6lJiloGm+TqqwAqSRpsTpT7on5OZGE/yJPhGT3j22gjbxlcw5ggJsdSpLiVr/
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-22_05,2025-05-22_01,2025-03-28_01

Hi Simon,

On 2025-05-07 at 19:16:20, Simon Horman (horms@kernel.org) wrote:
> On Fri, May 02, 2025 at 06:49:51PM +0530, Tanmay Jagdale wrote:
> > A incoming encrypted IPsec packet in the RVU NIX hardware needs
> > to be classified for inline fastpath processing and then assinged
> 
> nit: assigned
> 
>      checkpatch.pl --codespell is your friend
> 
ACK.

> > a RQ and Aura pool before sending to CPT for decryption.
> > 
> > Create a dedicated RQ, Aura and Pool with the following setup
> > specifically for IPsec flows:
> >  - Set ipsech_en, ipsecd_drop_en in RQ context to enable hardware
> >    fastpath processing for IPsec flows.
> >  - Configure the dedicated Aura to raise an interrupt when
> >    it's buffer count drops below a threshold value so that the
> >    buffers can be replenished from the CPU.
> > 
> > The RQ, Aura and Pool contexts are initialized only when esp-hw-offload
> > feature is enabled via ethtool.
> > 
> > Also, move some of the RQ context macro definitions to otx2_common.h
> > so that they can be used in the IPsec driver as well.
> > 
> > Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
> 
> ...
> 
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
> 
> ...
> 
> > +static int cn10k_ipsec_setup_nix_rx_hw_resources(struct otx2_nic *pfvf)
> > +{
> > +	struct otx2_hw *hw = &pfvf->hw;
> > +	int stack_pages, pool_id;
> > +	struct otx2_pool *pool;
> > +	int err, ptr, num_ptrs;
> > +	dma_addr_t bufptr;
> > +
> > +	num_ptrs = 256;
> > +	pool_id = pfvf->ipsec.inb_ipsec_pool;
> > +	stack_pages = (num_ptrs + hw->stack_pg_ptrs - 1) / hw->stack_pg_ptrs;
> > +
> > +	mutex_lock(&pfvf->mbox.lock);
> > +
> > +	/* Initialize aura context */
> > +	err = cn10k_ipsec_ingress_aura_init(pfvf, pool_id, pool_id, num_ptrs);
> > +	if (err)
> > +		goto fail;
> > +
> > +	/* Initialize pool */
> > +	err = otx2_pool_init(pfvf, pool_id, stack_pages, num_ptrs, pfvf->rbsize, AURA_NIX_RQ);
> > +	if (err)
> 
> This appears to leak pool->fc_addr.
Okay, let me look into this.

> 
> > +		goto fail;
> > +
> > +	/* Flush accumulated messages */
> > +	err = otx2_sync_mbox_msg(&pfvf->mbox);
> > +	if (err)
> > +		goto pool_fail;
> > +
> > +	/* Allocate pointers and free them to aura/pool */
> > +	pool = &pfvf->qset.pool[pool_id];
> > +	for (ptr = 0; ptr < num_ptrs; ptr++) {
> > +		err = otx2_alloc_rbuf(pfvf, pool, &bufptr, pool_id, ptr);
> > +		if (err) {
> > +			err = -ENOMEM;
> > +			goto pool_fail;
> > +		}
> > +		pfvf->hw_ops->aura_freeptr(pfvf, pool_id, bufptr + OTX2_HEAD_ROOM);
> > +	}
> > +
> > +	/* Initialize RQ and map buffers from pool_id */
> > +	err = cn10k_ipsec_ingress_rq_init(pfvf, pfvf->ipsec.inb_ipsec_rq, pool_id);
> > +	if (err)
> > +		goto pool_fail;
> > +
> > +	mutex_unlock(&pfvf->mbox.lock);
> > +	return 0;
> > +
> > +pool_fail:
> > +	mutex_unlock(&pfvf->mbox.lock);
> > +	qmem_free(pfvf->dev, pool->stack);
> > +	qmem_free(pfvf->dev, pool->fc_addr);
> > +	page_pool_destroy(pool->page_pool);
> > +	devm_kfree(pfvf->dev, pool->xdp);
> 
> It is not clear to me why devm_kfree() is being called here.
> I didn't look deeply. But I think it is likely that
> either pool->xdp should be freed when the device is released.
> Or pool->xdp should not be allocated (and freed) using devm functions.
Good catch. We aren't used pool->xdp for inbound IPsec yet, so I'll
drop this.

> 
> > +	pool->xsk_pool = NULL;
> 
> The clean-up of pool->stack, pool->page_pool), pool->xdp, and
> pool->xsk_pool, all seem to unwind initialisation performed by
> otx2_pool_init(). And appear to be duplicated elsewhere.
> I would suggest adding a helper for that.
Okay I'll look into reusing common code.

> 
> > +fail:
> > +	otx2_mbox_reset(&pfvf->mbox.mbox, 0);
> > +	return err;
> > +}
> 
> ...
