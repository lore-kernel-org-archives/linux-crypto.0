Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F33E155CB3
	for <linux-crypto@vger.kernel.org>; Wed, 26 Nov 2025 01:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764120985; cv=none; b=JV9vV95TMDe3Mj35t1yF3FTmEWc5xlYTDGOCYWbkzBVUiZ9Cd5K02+9VWgSdnBneKSlML2iN7prVYPvvyFSz9jXGKCMwTVqf/ldEpuZ4GyXpzKU6dj5uemreRsbx3Z5JcDQtAq5l+Mn8F+Rfwl/oTD7mlpgLeSGTPL8Stl7bc4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764120985; c=relaxed/simple;
	bh=5nxFjc0sHR8+o/Crg4to4Kyd3oL6uwnMXC49BEMnnzk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y3FBCaWVj506yQJPPd3dFs4QXCecyz5BuXbSCi0GgDwm7f7mJQZHVaa4C4VWM16kSmsuFfcrhomxmMEXdHe5v51juLIuDnuD/vPkXZgSAxcVAiPJWKzJ3oaIe7OoCeMfup6Yx2UZ8VpzSBCN/0csjHTxBkgM7xzRpTl4xMIDPL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=b1m1kcoR; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=F/NDR2Sa; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="b1m1kcoR";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="F/NDR2Sa"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5APLV8Yh3666224
	for <linux-crypto@vger.kernel.org>; Wed, 26 Nov 2025 01:36:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=JR8co6q7+nFf+m5fF38AXna1
	AqxUc5bFRHQ6sjd97l4=; b=b1m1kcoRr7gBpPUEfpf2MUJZ4Fa4mz4BABevyi4V
	08G0XMdNdchhves9ujEWecsxzWYzPXfnj3coRv2v9kMnV+iOxJ2GP4RlqmrRUFyJ
	333uILLO2jrB0yEe+sZtHU8jrRiYKW0riWj2pCnYlxokdX42xIVPJWZzUrQ84GNb
	6fXOwXyU3yDFBae3eq7Cwk5+wEuWz6GnlH7eZNRBE2Ji7CdBXfH/MQ8gNLieGmbi
	MQ/Sz3HB9VTe6BTsoxM+t6fKM+JlrujXrpGMoBWmZqY2pITl9pvgPiEBXHnyE2Ba
	I4jDoLp0osSQDbzi3iN1Qj1yUaHfXtndc4mXZ2Fv31e5Cw==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4anmemre9m-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 26 Nov 2025 01:36:23 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8a1c15daa69so565949585a.1
        for <linux-crypto@vger.kernel.org>; Tue, 25 Nov 2025 17:36:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1764120982; x=1764725782; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JR8co6q7+nFf+m5fF38AXna1AqxUc5bFRHQ6sjd97l4=;
        b=F/NDR2SaKRL1x2ZAZK9zfAyXJ9yMecjHF/0NCRfU7tqqtI/qLLEmxAO5zcZ+/mc8NP
         xKYICLv9IUbVF27pluuBiXXHKaaqDB0pJlBrNTJTeWK0PoU/3+ezWBZ++XLHdr1dJk8E
         TOGczsF0gG7rsEaTLX/mgpI6wILQA8Sydb8HAneJMHpS9PKA4uQdoHFDHRKCMYZiBCeC
         tsm3qN2miXp1NmIzG/HnzsRDO4VT9msOPLg57XMl8khPFvoZdkuF5OFkZRpc9Q4EotUK
         bIv1KmAvvd4SejKe6DCrqZGrXobuXkyfFjlJGf0QVwiUzhUoYxiwp+b4iwxHCqdpI241
         EyGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764120982; x=1764725782;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JR8co6q7+nFf+m5fF38AXna1AqxUc5bFRHQ6sjd97l4=;
        b=SL7MTY4q8XqEmc6rd8fVzZ6lI6HsTK5Z7mSJuGbKP3G+K7EsUHhhJLQ+Db0gLkDr3l
         QFieh2jve1D9BbPveLff1gN91Q06OW/R6RpN9yp2jRgp42X/AMSw8NYCdhqoU3xK+3F/
         7B2fJUhqGBu8z4YH+7f3OB/gb2f2lSCwVFVXgcST9cJV5lT7p9FWhQMJN7JCqN+HwxvD
         JwIL6Xf25KuNM1SoyNtR4/gTzoUSphfsPGJUmVxV47rOjuVMOXKY1oLx3/nf8sPoR6OS
         VjCCkWU1C1HQHtqH8BTgmh8DiM8aQB/JAehemLXk57+hV2Zn13plHpNXBJ/wcom1yvL6
         pEXg==
X-Forwarded-Encrypted: i=1; AJvYcCUTSaJrrJvwS92TEoaNwGjx98qEN5WF8EP99yfeK5vwrxcqiSm1dv8Flj8br2Pn+N73o+Udwd7Spo8bTyM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUGPahFvbL3IvCHuQElD5XQuXwPnfnGlayVjKanT8W1vxmAuHK
	6ca7t3BU05BdABKH7ftSKlw+zhfK73IVjXNXNp0W5equWBsF2cO9PyhBpqd0a3MeQtdyhsgNFO+
	xMaCE4MItNvqlXLs52Aj10tJVvewcrbzsk6ipvgwsBMjmwvOiKQhuOSm+Ub+RMjUA+kU=
X-Gm-Gg: ASbGncvls3pG9FRjHbNMX/k+OFD9wcIuZd4stHbIHRSdXZFlZ/HvilDvkCt6siRXz/W
	U+PEFH6Q4qY46SE6CS2cDKwk9kyDgz3jjowfeHm4/3R6V7pVEPL0sqkVJxNT0WDkqwTxzZMC6Yc
	TJT2RsAbMOswuuCI/SloJY1ovqJaH0NbVNMy7gL8497jtMKkvW/rCwMlglOCH+yVnxn8PiBZ2Ja
	7bN4/jrgnInnVmFjuphjD8yej+9QVt9Dn+oLkxltaoK4Im3VJ7PcuRSOaqjlPuWRdLEfkdloPkE
	aVQN1irVpLVSSvvBdVZOq5xTu8C5R2sH3ieBFpu5SqNpyw8r4FKLzJ5TWMYKx8H1v5hA0n9o3MJ
	a7rxltvw/cJy9cb53lPky0sVC73HOAWB9ltf5LJrz2Twb1xHeUwj2wyWzD6po28kvMOYvmx9ljH
	qpGzaKUk6kLiQMeQuQb1/nbb0=
X-Received: by 2002:a05:620a:3f85:b0:8b3:19dd:46ea with SMTP id af79cd13be357-8b4ebdbebb6mr675906585a.72.1764120982600;
        Tue, 25 Nov 2025 17:36:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGZqMmHNCGd63AwXsQLn7Ik0qDiC/u/CEwulFZwrLtXGsLoqnKqjaj/y7rHroR9hMGl3FhDIw==
X-Received: by 2002:a05:620a:3f85:b0:8b3:19dd:46ea with SMTP id af79cd13be357-8b4ebdbebb6mr675903585a.72.1764120982186;
        Tue, 25 Nov 2025 17:36:22 -0800 (PST)
Received: from umbar.lan (2001-14ba-a0c3-3a00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a0c3:3a00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-37cc6b59744sm40049251fa.11.2025.11.25.17.36.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 17:36:20 -0800 (PST)
Date: Wed, 26 Nov 2025 03:36:17 +0200
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Harshal Dev <harshal.dev@oss.qualcomm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] arm64: dts: qcom: x1e80100: add TRNG node
Message-ID: <ygpjsoxhpigj4t7bcphzhrkjljqermm7rte5gyxtcjelgtete2@65mzcqwakgcp>
References: <20251124-trng_dt_binding_x1e80100-v1-0-b4eafa0f1077@oss.qualcomm.com>
 <20251124-trng_dt_binding_x1e80100-v1-2-b4eafa0f1077@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124-trng_dt_binding_x1e80100-v1-2-b4eafa0f1077@oss.qualcomm.com>
X-Proofpoint-ORIG-GUID: iCoB-2wjZf3gALVRoO4F7mB6lPllNQK0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI2MDAxMSBTYWx0ZWRfX0NlSdDLvJvDR
 4yGAwIzLt8Fxhul/o+Y+wIwdWUtNwuVhKaDuwBBgXfhTv63E/S8+SrOl0LNKpOzW9CIxdCsaIzT
 uThiL9MCjrfW9avfO/RYh6wnE6QsKEEnesQcjvHVvodWBXk0DZWE1Fc+oYgFKhbGuZLPhOVJBAj
 w5960/rwmlS+f1TkzZjLeSKvk6nM498iOStwa5Rn3pQJ4vhX9nkxw+AnqlXRy/d8NI7RtHtiBV0
 C2zApYr19mXpsETSjtbm8lG7oAX1+OuEpyqiPRor3+myaNMHUdcWzelnq/VyfHfMDie8RW75lbx
 stgjpcVOu94DA2RkoeW8NUZz/K3HkEcJ0W5tX1cRl8F73px0WD0dM5JTA22JIpyP+4las3Qb4UM
 hCtTll7HgpIB7ciX9p5jh2qEZF1MYw==
X-Proofpoint-GUID: iCoB-2wjZf3gALVRoO4F7mB6lPllNQK0
X-Authority-Analysis: v=2.4 cv=bZBmkePB c=1 sm=1 tr=0 ts=69265997 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EUspDBNiAAAA:8 a=WmeePSlto-DxRHfBUH0A:9 a=CjuIK1q_8ugA:10
 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 clxscore=1015 priorityscore=1501 adultscore=0
 phishscore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2511260011

On Mon, Nov 24, 2025 at 10:38:50PM +0530, Harshal Dev wrote:
> The x1e80100 SoC has a True Random Number Generator, add the node with
> the correct compatible set.
> 
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
> ---
>  arch/arm64/boot/dts/qcom/x1e80100.dtsi | 5 +++++
>  1 file changed, 5 insertions(+)
> 

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>


-- 
With best wishes
Dmitry
