Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794392026;
	b=GxkCIPSa/6D1EJIBZgA1TuolAv78PsA145fo1rZHReT4SepeH8BBydpdM4pR+7bHY25T
	 7rL4u2xwesvQVFB1NwgyrPSXsMgeujKtDrq3LX+HIHfD6tlURWB2u4Qh6UjzGlNgD4NQj
	 Z7omNRW7VSZduJLPifDPkizw6u1fQzj3bkaXgQoSyY0vTQ7AXCscI2v7PJYOmPmKNvfhk
	 2NfXhU1k32ZLPg7wO9g7zr4ka37k7lmY53B7REYMv8qA1dl0RohHKSd9iuHNCAOi4zzbX
	 irLiTKB3mcaoVX/eFg1IgBq8+Z2famGxQf8yWutn9pcpKscYgjtbuOojSI2aOoxFGUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794392026;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=5McJnxb83WQY6Kyk4BRcLwQ/t8a2Otwl41DlY+4EO5Q=;
	b=km4QBfjTnmalQrLrMxdKnfqsD2oqeDEcjgbYx45LAH+aCJjAsTjq7FVJg9yX4NdKD+Xh
	 Atd7STZBkTpsgXtxStfCn0VwXG22Fsizdv00s+VUmiZjiQlv5NLGQNjF5tTeoW+MdcBQg
	 +fQ9JGdZWphvR8crHcfAh2TrBZzhxM8ltQQA6giSL/G4z2avhPBSsF2ReSy/wElp8IKQv
	 pMSyR9B25n2b/fUV1oH97em04T+MwwxEhD/yOdKSVEGUlvBUAU3BN1dueTO1TECmX/3QZ
	 xyepDYjPg84qCB7fpDb//bWcckmiMiT15/KnNd86ATqjn9iVWY+xoX1ujyfzpATB/Tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Hx7qaaDr;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=UOpiTRlG;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A86B606A324
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 10:13:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A86B606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Hx7qaaDr;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=UOpiTRlG
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AB5LBWW1052930
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 10:13:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=5McJnxb83WQY6Kyk4BRcLwQ/
	t8a2Otwl41DlY+4EO5Q=; b=Hx7qaaDrgNyaX1pYAxVX9pZF39S6QKy9m7Q6v7yt
	24I+xxtIM5XoHs0dBHptK1Ir+wxRh3oYHIggv9PTq/A9/odrPASt58sspaYYd8RQ
	tlqxxE6rx/EPDv/meyxv5bqJou2dAN3R62caSMqA3Xp48qRWYdko0vd7/LhGqUeq
	9skyEkcpkzHdKMJ9zNuXortCeomCpHxj+e/9bbI7PxTUY8V2yGLS20iOh4cgCHmx
	Q4LOKAS4es4o90jpYemRpDA4rrFFvaMclm3swKwUhJ/0ufbSShXuLxh5KlgkNJRc
	hvtZ5Hi3UR/OJYIvaE3UCnzIzlczMLST59CgeloZYQml2A==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hvdrh22hq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 10:13:45 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93f6f4fe531so542768885a.0
        for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 02:13:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794392024; x=1794996824; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5McJnxb83WQY6Kyk4BRcLwQ/t8a2Otwl41DlY+4EO5Q=;
        b=UOpiTRlGeZym+Yl/c1KdTpZpSLEXAyKj/EVyc36g13N9he8c7CltOzE+QlGG8+O3ps
         gDmUWOI4h6D1RSJ4oHC0MdSs2Y4tF7w9f+ZzDc3tYFCHlWYy6L0QD7400ohEOVyUQjbu
         x9ZXbtnfc7Y/KfixdVXUl275vn1ac/qO7ulD8HvawppDw8ff/VbazlzaNwquiZQhBsZP
         NRBloS/CBZbLy2wCch4ZTj8uVcSg3Ez/G+872Eaftj4+ui/x3DEUHIwIAi0SzSHi06zu
         Bn8+oOQBm/GXHrKAJTrWhQaxxAs6Gr2eZwJI66Yx0v+ldKb6XHMZHjiHGcdrAlTs0tPD
         s+tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794392024; x=1794996824;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5McJnxb83WQY6Kyk4BRcLwQ/t8a2Otwl41DlY+4EO5Q=;
        b=vguQ9VzskvB4F6hpg9WAoj4PJAxIbbSR9NnFdpigGQCWMFUejYdsa9CSWV0B5eBBcq
         36AfGkSYKztXGvZrbgtKmNde/Gpfs1NHlO6eLb7Kv8TZ1vDv0EsUFtQgyOaDX0OlAA7U
         89iK+8i+qSSmelvnMdeL3pG52MT6dpXTwN0sZ05wKKPQ8IP2lGguIzDduea9bTfgeIfa
         Liar3GtOds7w5XY/HuzS1PoIke+fJW/4+I5UUSzF1MmezIhR9tNRc8ELQEyjs6hxUMJ7
         W7YpzBknIVDiN2o8mat38za4ar8OQBWdeTmjNB1m8tZS8kxKRiqn0hzOsQLmwNo128uO
         Mf8g==
X-Forwarded-Encrypted: i=1; AL+hErF5EqY3AvzQWuFghuYbdITrbfFLGrYHCZVD7VcHkVmaXpBBrC0cxR3ElPwJZnx5ZrhEX9cCDafASD6umnY=@vger.kernel.org
X-Gm-Message-State: APuU4Z9o0RKtTzmNVoMKSxCutEMZWixYtuFV2/+6bkYPV4rQp3mg/je3
	DFcRmwMhO3SbE0YWY2eUb2QUn0KcWO9btZyGRucsL7hiJgaVulMXNRuEdurdeFw7fb38PeRNVIZ
	WIxzDh8CVqDBdpPXanh6cXbuDbdjQEhbzti1BRgQ/L2iYZlMTcw3kK6gn8qq7oZEwEWrpYms7dn
	U=
X-Gm-Gg: AYBFou0gaustNp/pIxl701N7bmHr9PbYsYf84FxlO1WbLL6QX7u7czCChsr3R/vK9Z1
	NWn+NJ6K1bOAHGk9jmQIS5/9qm3ww1Ibrc7RYw46aU7+k37YH7LZ4ZHc+71L2SF70sfnyou38n6
	4rHPlLf6aqnz82DgVIbEjmRsnEcesx+pDEMiljkMDAJ/Wz15xnoHbsCs1vRw8THjgWelVLliHhG
	YzY4HbVPdO88+96c0cj1OwMp94jCNHv2+WyT3c/PzhEoxPCEHoUnezFiTqdZBj7O/rlIhaZnmGW
	hNAnfA8vg2Ap9c0VMsCwbMX0cX4nPiaSd72zcHv45yR+I1fK22Q6HB2gGMoPS+/KbI0eHJzCCwJ
	LN8Q7OWIYUwIkhgkNFIrthHHmaNJXtzscodW3XCD1Vv8wa4jcjvzMnoqbzE9Ga6Ex
X-Received: by 2002:a05:620a:6c11:b0:93f:19fe:e6ca with SMTP id af79cd13be357-947aff8efecmr302492485a.43.1794392024344;
        Wed, 11 Nov 2026 02:13:44 -0800 (PST)
X-Received: by 2002:a05:620a:6c11:b0:93f:19fe:e6ca with SMTP id af79cd13be357-947aff8efecmr302489085a.43.1794392023805;
        Wed, 11 Nov 2026 02:13:43 -0800 (PST)
Received: from oss.qualcomm.com ([188.27.161.77])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4983600bd6esm10339577f8f.28.2026.11.11.02.13.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 02:13:43 -0800 (PST)
Date: Wed, 11 Nov 2026 12:13:41 +0200
From: Abel Vesa <abel.vesa@oss.qualcomm.com>
To: Demeter Barna <me@fromdisposition.org>
Cc: Abel Vesa <abelvesa@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] arm64: dts: qcom: sm8350: Add the inline crypto
 engine
Message-ID: <m54copzsq6jovs7miluvkwwczxiquq67n5vgddy34vd4otycxw@ezowb2pkeesp>
References: <20261109-b4-sm8350-ice-v2-0-fd5e84985e90@fromdisposition.org>
 <20261109-b4-sm8350-ice-v2-2-fd5e84985e90@fromdisposition.org>
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
In-Reply-To: <20261109-b4-sm8350-ice-v2-2-fd5e84985e90@fromdisposition.org>
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDA0MCBTYWx0ZWRfX8IEpoAGygg7e
 0iAJhrSBrrJtlD5C/vurZoiHrN9I9jjYPU2XlC4loEfTRFOLouq8MzKlYMZwBlm13VLzhxL7oBd
 50REJc5tG6UnffR9RWVHBTNBuJt5Kck=
X-Authority-Analysis: v=2.4 cv=PoQG/AM3 c=1 sm=1 tr=0 ts=6af43fd9 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=asF+/XNaGoxFafzDDLC1GQ==:17
 a=kj9zAlcOel0A:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=Tt5JBQAfAAAA:8 a=EUspDBNiAAAA:8 a=z9-AyCJIoEr-Zpo9GLwA:9 a=CjuIK1q_8ugA:10
 a=IoWCM6iH3mJn3m4BftBB:22 a=kpHMOrJS8sLNr5ru0mYA:22
X-Proofpoint-GUID: R2yGwUDsNcAQhKUBLPBv-Z__Yk5Z06S3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDA0MCBTYWx0ZWRfX0D6qkDxdhH+U
 FdVa7jSQoArcW6OMECPFFEAbjsDhaiYjov5RGFgL7W9WwM2W7D0Eb4kMZEQoO5eTCNdcHC5KVJs
 zI9q8sW/Y154NjOaGM7G9MACWeaSjiFKSvvgvK5ILSSk8FbSm7v7kFARM9pURypeTpfew/BnnNl
 vdO25SHYWapIK5TGkOODLnaEaWm9enfr1FafDoIJEdfzTmkKDSSIFQk4dF4BVFyRFkOIOV12ySa
 Nkf6rOQi8ZOTiyreWMU2CMNR2YAoSRA881MKC0FV92AOd2SLn1KoWXcD2gxcqQzb/0ezgi6CJua
 nzmAy4VLmCvje/p5o1X7t3cJ+GJiLRhM/vvrUpZ3B3ApuTh2SXhRFIP2icYUk51zADr0E003u9B
 Wi+WQIl4GoUa0YF69oqlvODfGrj89PPMi2XFwRAcxw+zqtODmRbpFgfqvIVCl2rAqKwtfk09KBz
 Od3ZQFimw/v5Uf8DBuQ==
X-Proofpoint-ORIG-GUID: R2yGwUDsNcAQhKUBLPBv-Z__Yk5Z06S3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-11_02,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 malwarescore=0 bulkscore=0 adultscore=0 impostorscore=0 spamscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611110040

On 26-11-09 13:55:30, Demeter Barna wrote:
> Describe the UFS inline crypto engine at 0x1d88000 and hand it to the
> UFS host controller with qcom,ice. The region covers the engine and its
> hardware key manager (0x8000 + 0x9000), as in Qualcomm's SM8350 device
> tree; it is clocked by the UFS ICE core and AHB clocks and powered by
> the UFS PHY GDSC, as on SM8450. Without it the UFS driver logs
> "Disabling inline encryption support" and fscrypt has no hardware path.
> 
> Signed-off-by: Demeter Barna <me@fromdisposition.org>

Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
