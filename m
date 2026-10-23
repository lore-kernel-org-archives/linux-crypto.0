Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792739752;
	b=4D4w1M1k+yoIlhUB012aWY4JyD2Xpodiq10pAMqavMSykY9hYfl59wAGvTGKBhYbOP5J
	 1sDNsWx1FGpjOq425xK3dVJTHvXc3Wo0ODMyZdgwAcEqveNBrsIFTQ1bb9OzrWCRiH7eF
	 aeUfOxT2ghZgntXQToIQR6RBcNFdceJ9IoBL17LO8gPT4KAURNDwc1Ul7RbtmZAPy2LOx
	 nw/3TBwDbH8fXgScZ1a2mVS3VhCt4bWkyPcVnKMq+kJHvVBSOswgNHD+4C2HXeV0QmL3w
	 YRAImv3AvphGYXjtMWaxyGqWa5XP18paHsN3Uw7OoeR16Y6kRmBY2GiWQpKghNTQ9fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792739752;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=emVHzhFuBmzNbJfl8jaY3Tt35lmId6ThMENQGGl8GI8=;
	b=jKzTY/hVhvZVGSB2t19gQrtn1gr0ryu5QIDLzyVkLbx5IMR/VbuhTGi/FKracM/w4/Gz
	 2Z33oZUo6Cy+exkqFjAvOcYyriHMcIczVhk+/0SJCR24MKs0xPPJH1r/5vnWJEKeS9qhQ
	 819SRZs89Nx2XqrJINdqTcyEx7+RZLsGHMvz+lmlTcejqNtFiMEI41CRisEuhCxtgfGuV
	 NzluohNjqoJYktLaB/jtCAt9PF9uMgawo5FpFjCVARyBxVTQrh6k7blnqskNOIt2ASF8v
	 j+9hMzFj2yDy3oJA+m2Psq0thYtvQnCGgia/tDQNGkDjsFvASEcPwU26loxOoOLJwrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=JooB3BEN;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=NdJ9sFtZ;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E752606A31B
	for <linux-crypto@vger.kernel.org>; Fri, 23 Oct 2026 07:15:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7E752606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=JooB3BEN;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=NdJ9sFtZ
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69N7FUH9588023
	for <linux-crypto@vger.kernel.org>; Fri, 23 Oct 2026 07:15:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=emVHzhFuBmzNbJfl8jaY3Tt3
	5lmId6ThMENQGGl8GI8=; b=JooB3BENF2M6A+kMTs+lcpmhxo45lK1YVBhiiWUz
	6oOPEsndL57QUVmC25/WlQOLn6wEoJSJZVRWPGofaNphBkiCvQvIeKD0po9c8Lw7
	aCQkFpzl5zS3ui6GoqwJBdrockwrqRVuYGXvZ91Qa0S7nCUR24vQMk75J53f61XH
	G5n4SO518jchVGwClNlxe9epKA+DA2aFYNCemKjH3yTS9qdD/exFsOGlWimghTJ5
	zBxNtB61CKbLQHN2M6TcBgY0C8BPnDna+2vRg9wC9kJbzZhODMhKWv8k+DV57F3A
	+acndsY1AwMi79TKIpbPNQ6OrEMj8FDtz7b/SeBbQB7dMw==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hfsmaswu5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 23 Oct 2026 07:15:51 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93f1e62510cso127465785a.1
        for <linux-crypto@vger.kernel.org>; Fri, 23 Oct 2026 00:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792739751; x=1793344551; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=emVHzhFuBmzNbJfl8jaY3Tt35lmId6ThMENQGGl8GI8=;
        b=NdJ9sFtZdSBjkiRWvDN1DDFmBZRlKH67dY8o0kMqfSB5Pt/tiX/0IdbtFX0H52MVJI
         NzTq96s/NV0ro8asGpaFFW4MfeyGXWB9rLXKtY9XgnEOz5tb6P698/c88mKcMgj2Mau5
         H2tOERfhYW5Xr05gzXYydo2/F9XvCJE+uCZ2AsdSSkLbBuaFu1Maf6S3Amb+mPP9DKuC
         VoN2lFnP8wMe2i8ka/8e2RmG2yq1dcnqF6Olkqa3fsJxrYuH70H2yN1o38YO2//q5Lqu
         eNS5+fZd9jDp9yfOTkm4ejlvxzRf/P7Xh6wHCvIxvrYTpe2dFcy9TsS8i8Nz55N5MM2U
         HFoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792739751; x=1793344551;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=emVHzhFuBmzNbJfl8jaY3Tt35lmId6ThMENQGGl8GI8=;
        b=gEld6YBWNA9oX+PE8Hb8Hi+Vk5su/9X2jO39LGasjKVk3ceZl/yKup2vLkmSdHRbWk
         eUn9JPauMLNRk8GkVy/N1vjnHZqDOaoZHyk2s3E2QB4KOZemJi65er97MpHeIwdQVeEf
         /HrdigWSjRtpEraDRkdyFOmneP5wWbpfFtIuXJhhbtMItcIY1+TxIWy0DGhxa1y/br+d
         HYyBthAZp9/z/ADyRYh3Sm3/SvlaVTveIEfqIUjw8Qdt/caE066ZS+4CCE0Jk5C7mjcR
         h0pv24YxCo+d3GBlFccQwWs+nLYaYFYTNc46BWUuFZsgScvlYqcOYNmEB+U9jYVBRhkO
         HqzQ==
X-Forwarded-Encrypted: i=1; AKwUvBx7Nfj7rOJeqHehaR3i4IQPQSXAX416HwapSKhb2hnoTxcPAFSfsah80T8str32zTT0Pcli4zmIhFr7Ebw=@vger.kernel.org
X-Gm-Message-State: AFq9FYKkIHvAXzeSn7doKv+Ia3JPs6jh/pqsQWLn/N8jVe5AjOCRPaaT
	jFbGXuHIifSubeIILh9DtPeuDZkM54B7ruBOQzOpQAI2E340MuYT2WWZGxs+yeuqqKI8YFjp511
	B0pnrhupy46xrE2ZTw2CGRw3H3Q7QviY7eHCAKtwFMzgkjDS0l1muhvFD7Lt70WDL7reD2aan/5
	8=
X-Gm-Gg: AYBFou3YFMDUoA6qhNLv30BFWQBuLnn2zqG3fk/HsGivBBYYcSY1/7fW7gdyadbjC8/
	UZZQMIZuYJxyjQlKalgKuBcvsRBTsGLRLtNedjn2OStkMNs5H5nfHyXjcjd3XlEX2n0FibJWpXm
	Mf8Yv9R77rwS34dp7DPh3wKZM0m2gJ6FhjqQjyjR7KBpep7GMKTiXC7LtiAUDtMqJUDCjYV7nZL
	UxaEDZLSfznxFLG7HW1fJVTbiXpHYc8Jc45vuYLfevSdGpG7pXFtR7QOS0dG2VwwflzLVCpe8s7
	DZSCRkRcrvJ/9BNoxRz2SW4gPY1RmIFVUhZhTNGUjA/Th3ERu4rTdO4RiEckP6Zy92iubkW6VXH
	0kwRsIy85lHDS8ah3
X-Received: by 2002:a05:620a:470f:b0:939:1222:b9f1 with SMTP id af79cd13be357-93f6f420cf8mr281436785a.0.1792739750542;
        Fri, 23 Oct 2026 00:15:50 -0700 (PDT)
X-Received: by 2002:a05:620a:470f:b0:939:1222:b9f1 with SMTP id af79cd13be357-93f6f420cf8mr281432985a.0.1792739749888;
        Fri, 23 Oct 2026 00:15:49 -0700 (PDT)
Received: from oss.qualcomm.com ([188.27.161.187])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a211be9660sm36763725e9.15.2026.10.23.00.15.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 00:15:49 -0700 (PDT)
Date: Fri, 23 Oct 2026 10:15:47 +0300
From: Abel Vesa <abel.vesa@oss.qualcomm.com>
To: Harshal Dev <harshal.dev@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
        Sumit Garg <sumit.garg@oss.qualcomm.com>,
        Selvam Sathappan Periakaruppan <selvam.periakaruppan@oss.qualcomm.com>,
        Basant Kumar <basantk@qti.qualcomm.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 4/5] soc: qcom: ice: Migrate to the generic ICE service
Message-ID: <52xwxkqrbleq3upuvyorj3ikr6xefpqc2izkdqef3dlruzftwi@gmqsgo22ik47>
References: <20261021-ice-migrate-tee-svc-v1-0-b035be7aab0a@oss.qualcomm.com>
 <20261021-ice-migrate-tee-svc-v1-4-b035be7aab0a@oss.qualcomm.com>
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
In-Reply-To: <20261021-ice-migrate-tee-svc-v1-4-b035be7aab0a@oss.qualcomm.com>
X-Authority-Analysis: v=2.4 cv=V7LoQuni c=1 sm=1 tr=0 ts=6adb09a7 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=Qvngrl3H0rQgGg+94q4QgA==:17
 a=kj9zAlcOel0A:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=GPN60YVRCDtHV3IpRhQA:9 a=CjuIK1q_8ugA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAyOCBTYWx0ZWRfX5sw3eskKxmCD
 yO3tauBnLQNAzoe7Fqa70mMC/Zk2lZ1jjNexge7dXrjbNQaPL8PSqU2mJO6RF3UFjQNOD1/w6eC
 vhl+ijrGw34HwbXrtDOKQyBD6Zd5YLE=
X-Proofpoint-GUID: 1Waf2N0buqJMlyxOTd9lfkExZ4P2MDln
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAyOCBTYWx0ZWRfX6Hk1jb0BbQI6
 mVJI4ItilLw8i2GVcfnuWuCgdqIQkysqny4T5T064PSxiYSGToJh78Alu7TY6LgTYi0cQRKfqsV
 B17WXulLmokVYenww9uC2LFFpK/zRLtz3N7e1EC+5+PC9E5DrVxLcmu4/ZFBavT+g7dGbePjJH2
 wIdLFe0G1GqyCIQfkzJulZDSanA6WvEiNWdjDrWfXALwJQeQvSvd6ClSi0UG8CJSSW1ZufGh2n1
 Z06BQDVhy46NC3R7+lx0CfeA/SIRUASYSXrt5bzurrpqYzkxOELMXLbpx0dDf3R1yETar2Z5ZSb
 pxHQhaaSdlvcHujV3pEiVqBDWwRvmg5IdaLIGnVksaVs8vnyUU+HhxwG/XSBZGy43PuXAJExHqh
 tlUJ0auKzuFhESggUlpKIVrchOoudx7dVR0yxLG6WvVrRBUhIiOTUtS5th2Klb1KkV5HvEtKz6r
 XlRT/g9NzLk8ql9nwFA==
X-Proofpoint-ORIG-GUID: 1Waf2N0buqJMlyxOTd9lfkExZ4P2MDln
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610230028

On 26-10-21 21:13:10, Harshal Dev wrote:
> Migrate the Inline Crypto Engine (ICE) driver to the generic ICE service
> which re-directs calls from the driver to either the SCM or the TEE bus
> based back-end driver at runtime.
> 
> This makes the ICE driver agnostic of the TEE firmware running on the
> Qualcomm platform.
> 
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>

LGTM.

Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
