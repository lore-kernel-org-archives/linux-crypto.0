Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324BF14D296;
	Fri, 30 Aug 2024 05:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724996332; cv=none; b=ZgWMUlC7p24e4gLvKLi8ogOV5BG2qpkfKZNW+dgRfo4gKVqhnnTPkrmBbA2hccdcwXPVOG2WPXneCyxQSkgJIAyv+v2wrW9ySAps93OfAKFKIL0WlLf5UPXEpnSvKMgbEVgW4kVhkbFPHBID6aKIx+EgqGbL/JRNMPybmeoQ21A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724996332; c=relaxed/simple;
	bh=EiAKnoXuD+ZSQJ80+5eYay6HYffvSnssrGlYJPFJ6KQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GYqGI9/iET7kJcjWNpcgm9yq3CrKXoOhOCzKzbuhfx/Fxp8JweRy23xsab9C9wcE+8zL0CHw7gqlzucmFJp19d23/tEpuDIHLa71hzA5NX0UmOudPpJv8y+a/VzGFhTLYmU5eK2JNToxd9HQqx/HcVSWIyka+ZMU4LmitRp539o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=VjRMhq+N; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="VjRMhq+N"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47TNX9r4025957;
	Fri, 30 Aug 2024 05:38:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=ja6r/hYFLJnurcmWFOQAF8Yj
	hL16KH3TBkD+qbqTjeA=; b=VjRMhq+N26YreyUIdeMz28YasMId6Te1Wj/Pp2h2
	3RtWrwv8rAP9Q9BWKLqOD2ajNpo3wAoNqF9cxobOybr2hpNmeDi/7WAsDpFXRHl6
	AykRLRzW6loGCBGsHTJdIp6bQmx8D95gY2kndOSHQbbiCbDv1xh8F3yeZ2Ub29Yw
	UM0DS3ZK+R3xjzZx/uFcMNDXswd8H571NnSrTkcq7LMW1g5OBVH/sKVnhjLq5HJn
	U7CoFTIR2TwWhXtBJrlbnWkccQEEqYBrfD6YBSxlDPGR41HMNRV2zIank/9VPxnX
	RTQsHUD1mmd5CQUl2chdpkf1xQItlYj0I8U8UY1+oANQEg==
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 41arax2f1j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 30 Aug 2024 05:38:45 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA02.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 47U5cibr031280
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 30 Aug 2024 05:38:44 GMT
Received: from hu-cgoldswo-sd.qualcomm.com (10.80.80.8) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.9; Thu, 29 Aug 2024 22:38:43 -0700
Date: Thu, 29 Aug 2024 22:38:39 -0700
From: Chris Goldsworthy <quic_cgoldswo@quicinc.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Chris Goldsworthy <quic_cgoldswo@quicinc.com>,
        "David S. Miller"
	<davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: Driver supporting HW decompression and SW decompression
Message-ID: <20240830053811.GA28271@hu-cgoldswo-sd.qualcomm.com>
References: <20240316002443.GA31904@hu-cgoldswo-sd.qualcomm.com>
 <ZfUiwajCAO5tvW14@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZfUiwajCAO5tvW14@gondor.apana.org.au>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: gBEZWrEp-fEXcl3nJdAqnEdAeLFyBmmh
X-Proofpoint-GUID: gBEZWrEp-fEXcl3nJdAqnEdAeLFyBmmh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-30_02,2024-08-29_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 impostorscore=0 priorityscore=1501 spamscore=0 clxscore=1011 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2408300039

On Sat, Mar 16, 2024 at 12:40:33PM +0800, Herbert Xu wrote:
> On Fri, Mar 15, 2024 at 05:26:21PM -0700, Chris Goldsworthy wrote:
> > Hi There,
> > 
> > If a compression driver were submitted upstream that used HW LZO decompression
> > and SW LZO compression, could it be accepted? It would be geared towards
> > decompressing boot images on IOT-type targets with exteremely limited secondary
> > storage.
> 
> Who is the intended user in the kernel? In general, Crypto API
> drivers will be accepted if there is at least one in-kernel user.

Hi Herbert,

Digging this up again after we've settled on more design choices internally.
We're planning for this block to use LZ4, and in the kernel we'd like to use
it with zswap.

For our implementation, we intend on capping the size of our history window to 4
KB, in order to reduce the area of the block, which would mean that we're only
guaranteed to be able to compress 4 KB buffers (the LZ4 spec uses a 64 KB
history window).

IAA faced a similar limitation [1], but I just want to make sure our situations
are identical w.r.t. being able to get out driver accepted.  SW will be able to
decompress compressed content we produce, we just can't compress buffers of
arbitrary sizes (users would need to break them into individual 4 KB requests).

Thanks,

Chris.

[1] https://lore.kernel.org/linux-crypto/ZLsvdS6NbaetDFe1@gondor.apana.org.au/
