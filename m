Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795163820;
	b=nVDWal5TDyDpu+DuRWCYH1dEAxSbCtyBH5ubosmXxwczXm29mKwxYDuelqmxMnGvJGq3
	 qSMXIm+fK9eSHJPLqhUoRDR8B0fr/3SRHBMx9Rq3h6javVXD1ccbayVyvZmwg9kJPol5l
	 PE+wIpygvBjBFnK/xv+5NgxS+J9gp08151EwztzgdaKv8lP2fGgs5Cze+4jmUTMAi1E4M
	 XJSm9kr3IU0kBEQc+Jpeh1geQbMIoXVW0JmUFJClOqJV9wkZ1Z/Hz/rT+ZiYOH/8g6hSb
	 QMji/JAnhIRpM4WuG6vnXMz06rFj3r3WxCve8GMBsWtU4zFz22pAgKyaIxjggFm2cAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795163820;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=/LvAr3BbXaRFsNH7WIibnZuiPeBJRtU12clkeRljYRc=;
	b=zDIo2vVchMZ8LtBwzKEWi9XU48NyT68LY3g7Q1WD7C6AXmjpLxuO4A3YKxSoNB3JdPQF
	 AdkqkhMJxiowiW46b5SLA+189U3zSR8akSLv3ixWjxS7LwNBUcgXjtaYS/Bi74lldul16
	 KJLf1SeO8U4x9ZGR8j2Nz956Ao3i5eNe0GyuEJ6A166pIDSf6Zjx5v8ztCiFdCl2dbSSw
	 25q8t0cM8RXjJ+VGV/qABklgrfNcreoym25CEYxZFws0WBtdxe8arJUz8lkaiZ1bRtRkt
	 3cE3PKM7PNmFV+Nol/8maYR+zvb7k2kwceJjBmY7GzV2ihdHCSrUc9FdxFZNu3STR6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Uf1VTMux;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="KKx0/uLw";
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C60606A33C
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 08:36:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8C60606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Uf1VTMux;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=KKx0/uLw
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AK7eqga144444
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 08:36:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=/LvAr3BbXaRFsNH7WIibnZui
	PeBJRtU12clkeRljYRc=; b=Uf1VTMuxbK70bP3kiUk9/DfuxZ37IF0jt/l0lFQS
	QbsrruOofSPLVvwf9tahQbJxfXKVlxe4QtFonl+W+ssKVekQYO5bAl1b7wGz3jBO
	axsiMWgEGFHmRqvHiDal9bDbWzTSNXroqDbNImLiabiJ0aOX13SHE2lJ5+bq7zLP
	Na5y+zKWDLYEraejq5eqCoeKxqbDXIY7Cz4Ne+957a1stcjsz6pcwNDyEdltwI2G
	hIbmxwNJU4MYFuDj/lCALuRefnm8FlTSqK/v5AAd48TwDp6Gzdb2i7QK/h7DYQtO
	ViW4zXjlxskF25p/gM+SKrCoHS8YXCAQaR8fGbcd+n1Tlw==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4j2fsbgttc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 08:36:58 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93f33438950so125103985a.1
        for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 00:36:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1795163818; x=1795768618; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/LvAr3BbXaRFsNH7WIibnZuiPeBJRtU12clkeRljYRc=;
        b=KKx0/uLwEExofgAmGjFzKmYOBpVN/8jDfupIZ2biM9GgsQ+iDjCiW8+XihojIEo07f
         F5V0mxvE6ePXE/OWz9HuMsFO5LSE+ycjo3QjNL6Z1C5pScxgEfhA0taWafoiyQ+NwkOV
         OD5HkCzjJL7Zadi6E7MjCj1bLd0oJCy6/1GRam6qcZHZSaG+YnWTrOC7oJXZV4ykolZ4
         JIsZuMLTocByV90VcPDJZVSeEV7zg0mRKWTTrA8qHevcyQNQehr1rTiikl1HtflUUa9D
         szBEgL+NJ7IignTGAc3yazfjFfFCEWAiQoSty2GhwUnnbvW2IubP1aI1pGjFyTzitFMl
         n2Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795163818; x=1795768618;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/LvAr3BbXaRFsNH7WIibnZuiPeBJRtU12clkeRljYRc=;
        b=imfX6RAkU3C91Qa6/pE9CJK6dsng9+LLXkYDkui6RyeAi9HaV3050VBGIAhi5bCOrc
         8+hkQRlSJs61IUxJEc5OTKIJ2PXSd7uPL3qGUAlZEMRYVKTRT9AVocht/LEdGB17ZFNa
         NNraUKiUXohyJ1ZHxxPjyRnDvsLUTqHuDtKoVPwQ6ZkGaASM8Ysiw0ayepTjA93QwUWg
         v3nA94YQWnA7Yv28pTPP3t2gVydxNKcXFFWxtJ5TXfGEe9tX7kAnoF/BpAjST+2i8yO0
         eMPU9rFvcov+c/lm2GFX+mwE0RcijgZrJ23bLEgtYspjDpSRyzE/HhaEXnaesT4ORvPO
         uG2Q==
X-Forwarded-Encrypted: i=1; AL+hErFtB5ul1axANjBnrerTJCIxNs+xphJXvg+IwSS88FREcdTJntEu7GkjvH0qTMC8QH8BJeFuCLeoOx5qPUk=@vger.kernel.org
X-Gm-Message-State: APuU4Z8q9ACjbjDlHu1nYvlo3gJqnoyZdBYCU064vwXGqesOHRVZenGM
	Ixodj9HF+IuKBnPQNTK1eGlX8IBkFAQTwautt28nm2ncP3Xh/F2lMxe4TphXWCxNAl1HphgsmCc
	XHZg+9i02ZJxkq6qUkNlgIZMG46fS1IZaAewKHpLGYEAmwlygKTrloBDgRPokXRx7VUI=
X-Gm-Gg: AYBFou14HJI5Fyr/TgBrvscLsDDQ9n831RWqsP8oGopIqYIAqQ+ATNhHQWDJvWFloRH
	HT7ZwzqPDuE8mQSRS2PGD6JsaQlVo36/xbT0uU4VDzqePZmxxyPAjoDuMSfbczkvPOXsN81l7op
	FpU9kykzNUjBVClhDGo0GKZDg44mKHQqAWJLUmiWkesyMhOHW2tBerErNMEO1BufRDNXhi8rlI5
	1GbfhYFtY4uxI6e4HhlcA9pp6u5bUhl9XLpQlQre/R+866gBkTbIDBTFGJzzv5f/rzm62SVebpc
	yQ0BpImOxXRl/1oPwyIekaqsCmhpAzcRIijsl24ZVGfTqT32I3hd02kNrWxbr6XhXf/XXqvrHHO
	FpFIeIp+YwtPX/gTSP1ZWnoHa4YvnK06bblwOV9Aedqqfa1ag4SNQLMW0aiX4W0p5
X-Received: by 2002:a05:620a:28d6:b0:949:7656:ca0a with SMTP id af79cd13be357-949ba99ab2fmr411424585a.35.1795163817801;
        Fri, 20 Nov 2026 00:36:57 -0800 (PST)
X-Received: by 2002:a05:620a:28d6:b0:949:7656:ca0a with SMTP id af79cd13be357-949ba99ab2fmr411421985a.35.1795163817235;
        Fri, 20 Nov 2026 00:36:57 -0800 (PST)
Received: from oss.qualcomm.com ([188.27.161.77])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb853a9687sm111410415e9.10.2026.11.20.00.36.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 00:36:56 -0800 (PST)
Date: Fri, 20 Nov 2026 10:36:55 +0200
From: Abel Vesa <abel.vesa@oss.qualcomm.com>
To: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
Cc: Abel Vesa <abelvesa@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 2/2] arm64: dts: qcom: glymur: Add ICE node for UFS
 inline encryption
Message-ID: <gdsrcec2y7vglhrwe3nf6oacvlxgkudu2fm55qnselrsgetihg@3a65cpxavzsl>
References: <20261118-glymur_ufs_ice-v2-0-7ef4556eea15@oss.qualcomm.com>
 <20261118-glymur_ufs_ice-v2-2-7ef4556eea15@oss.qualcomm.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261118-glymur_ufs_ice-v2-2-7ef4556eea15@oss.qualcomm.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIwMDAzNCBTYWx0ZWRfX5PntouhiWg77
 vPwtd9bUC7lnZHQnwKeHJdOd0BEkwL8UVWrqkPVbsbzOlkseaL/LcOjgHlCq95czdoqpRElryGc
 7UhlzHz78eTgHxQVqLcKUajNhw0MP52U2118D3DB9P9zZKkvgipe48yLLDWQ0tGzafrUq8wHmEt
 iCxMgHSl6KGuEM+zh9kmusGszz3tn1ICE6c1C8UrItj//i5cOjwkMbFMclQaXoHr1kihUxA/WAw
 iHh3SQwCt5SyJ6cHszNTY6A9dAXW+H/4FM5HJqdefivvFI23Uj9e0xcKMRcnioIrqhs5lEGp6o1
 X6pl4NcbgN6A30JV2qMYiO2ouaoyJC8g2QcDDLCulqF6olK4nXF2r/cvcSw3a8IQWCkLGI6AbBj
 UVUU0bTSo3lLJxr0y0HTF6FIRBO2B9C2rb6hKlq5Mh74zPom0lSRaRNbp5EqMavke3YNYACQYSs
 oM77HEffDS2KcqoushA==
X-Proofpoint-GUID: _HLPDTaLgEBwX2GfD_FmmXJHA0nX5etv
X-Authority-Analysis: v=2.4 cv=DeiCOftW c=1 sm=1 tr=0 ts=6b0006ab cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=asF+/XNaGoxFafzDDLC1GQ==:17
 a=kj9zAlcOel0A:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=xToav2RPaKhFB7xxpWAA:9 a=CjuIK1q_8ugA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-ORIG-GUID: _HLPDTaLgEBwX2GfD_FmmXJHA0nX5etv
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIwMDAzNCBTYWx0ZWRfX0brqQDH2C4jx
 9ZANnEUuYmN+0XUjK0xSQxyHI85ubNV5GcD9Y1iQgjcfObb2LFGGKqn1VPQq+OKbDke49r3GKN2
 kuoBG9bu1OuZCEJBS/uRORqlU3C4LK8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-20_03,2026-11-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 adultscore=0 impostorscore=0 malwarescore=0 clxscore=1015 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611200034

On 26-11-18 17:08:54, Wenjia Zhang wrote:
> Add the Inline Crypto Engine (ICE) device node to describe the
> hardware-accelerated inline encryption for UFS storage on the
> Glymur QCB board.
> 
> Signed-off-by: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>

Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
