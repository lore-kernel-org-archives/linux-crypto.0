Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C2F1E7C08;
	Tue, 13 May 2025 06:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747116571; cv=none; b=PF07Sp5pR7r/WFTmeCnOLrVv463JF+wrkMFzfu/VajZeq9F9mBXbKMZh6W3YqnloN0u3mq++KPUxGbQuxfmzWr5c7ubPmMv/xvjjHLzboG5fNaRrQLfH7/zGcb8HRqf4JcIYVjYg+itg989jNFvp0SBqfnWWD2D7szphCeP8ca4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747116571; c=relaxed/simple;
	bh=DBAUxqh2hy8YWYEFdl3dKLIh+4+WUnk78OJrN/k/deY=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zh8n1e/8pJ2nF0B1vnbHIJSldNviUEhMzeTTcVTaZy2FrHWQkK0QslPBTpQ5TgMEWoWspCqVl4lA7Dm5D0sRY6XerOvf9EMwVjUCtZt4AbGaxgpa68UUOnORfoDKLLKeY94HxGoNpdfDPjuyEiw2Rn+aILHQXuFBFBS/VvPVhYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=OXL6USZh; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="OXL6USZh"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54CIOSFA002657;
	Mon, 12 May 2025 23:09:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pfpt0220; bh=LTcavfpOP7R4BqtVts9MdBa87
	U8Ph1y46o7oytL7FNY=; b=OXL6USZhfEU3wDSoGpfIZKspcY9t7/bXhBiURoCu7
	sw/gUDJH3H0xoH4NYjOsEaS3hqoByB55QS6FPy8JRltt1hXoyS6r9oXeJ/OMiIHz
	6WG/k3XxxBfVELuoMQ8JTW/yYK0H+ut7a484YnLVZZ8eYOH041x/zI5FtVCrOuao
	yusL8WpA61fOUgEa1sx1HvpH21xzpzYDoeyb4JzU6YwbWHPet1RcMjI1WVtdB76b
	CtxReFNt1zamUfW0ZOI4rBOeCZPfbN3YJ8gdSNf4Wi3LKFYGjndQEtiiMr23CxvO
	2surSxZ+X7RxQ+URzK4Gw4ZkdMMNQ4AiqXnbxHqZlT0EA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 46kp7ms5kf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 May 2025 23:09:11 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Mon, 12 May 2025 23:09:10 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Mon, 12 May 2025 23:09:10 -0700
Received: from optiplex (unknown [10.28.34.253])
	by maili.marvell.com (Postfix) with SMTP id AE0B43F7077;
	Mon, 12 May 2025 23:09:00 -0700 (PDT)
Date: Tue, 13 May 2025 11:38:59 +0530
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
Subject: Re: [net-next PATCH v1 04/15] octeontx2-af: Handle inbound inline
 ipsec config in AF
Message-ID: <aCLh-9EchqDFeW66@optiplex>
References: <20250502132005.611698-1-tanmay@marvell.com>
 <20250502132005.611698-5-tanmay@marvell.com>
 <20250507091918.GZ3339421@horms.kernel.org>
 <20250507092832.GA3339421@horms.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250507092832.GA3339421@horms.kernel.org>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTEzMDA1NSBTYWx0ZWRfX8HgQU5K6rkNp UUJ2SbYIcR+KLtR1L4k0WdRjh7ClPtRyTKw2NaBjZacih/+8Q2J8SVRrmzb837mMcsECC7G0c7S A8XTjpAU+eMo80z3nC1bivKxo9jFg8yT2pYbah6e2HZyk6Bw9big+/7BsvfSRr0w1pZRnAOAgpT
 k/d1kmwfCDO7gJLdKqtLxZXDQI6md7oLpzBpseaBt+Z9VSu7Ho49hsOXmtxiH/03SckmJDcOyNN myJryKm42N5wTzXuwHydi4Ha1CalLArOlgN0SvWXvyE6P1CGsUBT+vo5/TZvv7CBcpj5Gxnr0TJ rX/UVqB6si306ihjIejk5cmQYRwdHTEy9qir4ARcNxqOyoNurhrCk3fOGuTUhz83B8sBMt81ufF
 rQCZH5Y8ZaI8ZQLTBD3PdJzzU0J7n4sfJswilQ9q0ZoZOc40h81l1JkpHxl2VdFXtzrNU/MD
X-Proofpoint-GUID: nxpD1rjwKRq7ByMbXYvpALJydRp9jkFW
X-Authority-Analysis: v=2.4 cv=YsYPR5YX c=1 sm=1 tr=0 ts=6822e207 cx=c_pps a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8 a=FGfcEKYBuW_uT_4AAXsA:9 a=CjuIK1q_8ugA:10
 a=OBjm3rFKGHvpk9ecZwUJ:22 a=lhd_8Stf4_Oa5sg58ivl:22
X-Proofpoint-ORIG-GUID: nxpD1rjwKRq7ByMbXYvpALJydRp9jkFW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-12_07,2025-05-09_01,2025-02-21_01

Hi Simon,

On 2025-05-07 at 14:58:32, Simon Horman (horms@kernel.org) wrote:
> On Wed, May 07, 2025 at 10:19:18AM +0100, Simon Horman wrote:
> > On Fri, May 02, 2025 at 06:49:45PM +0530, Tanmay Jagdale wrote:
> > > From: Bharat Bhushan <bbhushan2@marvell.com>
> 
> ...
> 
> > > diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
> > > index 5e6f70ac35a7..222419bd5ac9 100644
> > > --- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
> > > +++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
> > > @@ -326,9 +326,6 @@ static int cptpf_handle_vf_req(struct otx2_cptpf_dev *cptpf,
> > >  	case MBOX_MSG_GET_KVF_LIMITS:
> > >  		err = handle_msg_kvf_limits(cptpf, vf, req);
> > >  		break;
> > > -	case MBOX_MSG_RX_INLINE_IPSEC_LF_CFG:
> > > -		err = handle_msg_rx_inline_ipsec_lf_cfg(cptpf, req);
> > > -		break;
> > >  
> > >  	default:
> > >  		err = forward_to_af(cptpf, vf, req, size);
> > 
> > This removes the only caller of handle_msg_rx_inline_ipsec_lf_cfg()
> > Which in turn removes the only caller of rx_inline_ipsec_lf_cfg(),
> > and in turn send_inline_ipsec_inbound_msg().
> > 
> > Those functions should be removed by the same patch that makes the changes
> > above.  Which I think could be split into a separate patch from the changes
> > below.
> 
> Sorry for not noticing before I sent my previous email,
> but I now see that those functions are removed by the following patch.
> But I do think this needs to be re-arranged a bit to avoid regressions
> wrt W=1 builds.
Yes, I agree. Will rearrange the code blocks in the next version.

Thanks,
Tanmay
