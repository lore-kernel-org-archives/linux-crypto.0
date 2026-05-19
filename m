Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FED3EFD02
	for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 08:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779180931; cv=none; b=ZyFSL9fIh1JtewOEmnckmAM+dcpUh1Z5/lV7yIKfI22N3PgfklanIUJS9TMkVtGJ3UBxWJLGcDohKfOCDTp+Pu0uqHLCV4rTF0gkthAFKYFVENh4FAj0WByCGI9tJ0j4yLFO4SOIDmN6gNE5d48qE4OeAOBxTkYvKxEfScPHqqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779180931; c=relaxed/simple;
	bh=Pvg0y4IvYgyRyjgGSyPm0Vv3Ghs2hJveIaCUm/K4Qg4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ND0Zg8DWOqvORdr8HEbcrQhWysj+/BeKpH5NNaSvL7t6k+IPH9BiV+Ao12smIsYaamAQ70K9tbhNTKku/3l3Qw7cV/fu0g2hfhbWuGFrcyithMPg6T350oz251M7pM2GurtjyLzjxwfvZ/YLoXAoNH7ivchOVLYkyCEYsbiv1E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=TQHgc4Wp; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=c/ioRg+T; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="TQHgc4Wp";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="c/ioRg+T"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64J6gmK61737112
	for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 08:55:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	LQ+0FnEJugjYxtjlpuNz1AMACB0wuPR4vp/JFTyrtdI=; b=TQHgc4Wpx28xJfm+
	nTuFt5EYDOkev0Rxiioh2PUjtKDIW8liibfSjiadElGJBgU/PUWFYxG5xT0iuTDY
	iH2zfeM4FDrfwhm4nHwhO8tJyPC1BdkiadNVp3mB919J0I+GOy7Y8aRAl5Cou+/w
	PtIIHcS8flFX7orG/S/qzdxsAhL/KGNBoYSepgklMJk6IM2jdJZ7KBztJ+K1HzAf
	wmolCJ1Zx9ctgAgA6EP+B6KEjYCXWEZSau0xNxGqjFWHnnvbd82/f4gGu+OJKEu3
	6Qg+f9iigDyhZr+BFRgY6mJ191wIddKgVSehNNz9bizLwNx/AIUK3qUn33Le/1FP
	Bl+Ulg==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e8ju90jkm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 08:55:29 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2bc6899bfb1so33524845ad.2
        for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 01:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779180929; x=1779785729; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LQ+0FnEJugjYxtjlpuNz1AMACB0wuPR4vp/JFTyrtdI=;
        b=c/ioRg+T4qMGG8EjcfxkWmI9ZM3HKGC6VCUZQSzb7cWSs6ZagDNTA+IyT6KxHwPrzO
         4BbYbHRyo5pZJN72hft1eabr+XGHJ6Nbet4WZ17dxrW+meHDAClbF8UHoCz051YpST1E
         ihY/+5sACPGWEVbexfKwRCDhmH5qRKLGBo5lSzBdJYfDfRzMST03T9JVuKWYtYTA5kBC
         zs6I+xtctQ9tyzs4JYfGwBRYvnRZkGircjts6/spdKnosroFDR+EURp0hS8lLfL5DWX2
         lIHoTNXf1SWFwdfolwcfJdvxX6pwxMkN/llpgOS9rUTBJeZmGvPHGG3kW+erbjAz6bQf
         fgXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779180929; x=1779785729;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LQ+0FnEJugjYxtjlpuNz1AMACB0wuPR4vp/JFTyrtdI=;
        b=VYuxKc6rlv4Fl7SmwfcwkgDjX/Yhs5qh2zj+KhGApCa5/z1e804nIDDhqRpfq23Xyw
         dwFfFiO+0ObvCe7aE/OGX3r7AV+FSZE/DlmCdUAvQFdWNDOKc2qr9hVKXV06l2bvMFX+
         1UO6kkFvHP7Ie/HxCgyuaAiPnGlRjQs36evuiUT+0S0N2baedK7uTwF+oT9pWb2z+YOU
         P/McYlAtUmV40y8DDBGDYGmypJBu13Pc5wwiRQ+67zuhWux6ebmlSMVJQ0I+olryw9x/
         HpkqNGO9sUZL5Yz0/vPoLCnLSQ4wizRuJGbaaMc8U2wvOWvv3W4L0UXKOqHW+XZ2CFCX
         K48g==
X-Forwarded-Encrypted: i=1; AFNElJ85pfAhmvGvLCVgLYOk6dYyQAFzqa0C56KZEoP0kDvL0ISeKJTqooTCkIAmRJ511rgBOmPOSkNFdNd87rE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyykqbDPX0/DMHyYAC3AXe3wRDv+IuB8dSPqJ1dfw2O/T/HKvag
	CQ3pM9dyUYyDo9PlRUlcsYX0w8bJ7+n7cWIelHc+i5I8X5TUXNpbXcVQSCcdQSNZofCrE82m66m
	2hEizyeQDMJODRiFbiDrqpICEC/KTJoqkvJo1GgmIMFShxIYORWWwlMzfqxy+20SC4Dc=
X-Gm-Gg: Acq92OGQhI4BtzZXdTXzbfCFqexFbqTG5qjk20lcwkVCy98bpYccYwczrY+nf/92KYd
	L53nAv1rgftQmz69qLGv9oPq1e7tfmXWaLDQUeQPjNop+XLW2FfVRJxkDm6DA0Hq0Y6S7m8+SGi
	w1Tcusx/tJ/UU3ZEtQ8JvUPMD3YNFzWpO2hJjoOoFDHir8bvcuQlqO1I1dF7JDximjeLZg6fqIg
	EMscccrXzpiGBZ/UqNcDKJ3oR5nx4ukxKSJTDgtgYDLyOANN7zk+mOrZ0q8DMeYe1Qf4XnPOKu6
	7ns2NKNEsO2u4qIDOw668rWG5wV6Jy0ZXzma5+fd9J2UK7QvDrmndu3mrhNxvgmHBQLt3BiBFKc
	b2/jLYW8+U0rGoGuGU2vbx9qZ3/dEu0/P/PbREX98UKH+SifXIOKTeLdhz0Dx+3w=
X-Received: by 2002:a17:902:9a94:b0:2b4:65f6:e24a with SMTP id d9443c01a7336-2bd7e7849a3mr126807085ad.4.1779180929108;
        Tue, 19 May 2026 01:55:29 -0700 (PDT)
X-Received: by 2002:a17:902:9a94:b0:2b4:65f6:e24a with SMTP id d9443c01a7336-2bd7e7849a3mr126806705ad.4.1779180928271;
        Tue, 19 May 2026 01:55:28 -0700 (PDT)
Received: from [10.92.176.107] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bd5d11d6easm193406485ad.72.2026.05.19.01.55.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2026 01:55:27 -0700 (PDT)
Message-ID: <e0a49e4f-08cc-4faa-a7c8-ee7ac14615f1@oss.qualcomm.com>
Date: Tue, 19 May 2026 14:25:20 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] dt-bindings: crypto: qcom-qce: Document the Shikra
 crypto engine
To: Krzysztof Kozlowski <krzk@kernel.org>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Frank Li <Frank.Li@kernel.org>, Andy Gross <agross@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
References: <20260515-shikra_qcrypto-v1-0-80f07b345c29@oss.qualcomm.com>
 <20260515-shikra_qcrypto-v1-1-80f07b345c29@oss.qualcomm.com>
 <181abfec-a6f9-49d3-9428-21a169a94246@kernel.org>
 <f40798ef-e066-4814-a26c-729dcdb9f5b1@oss.qualcomm.com>
 <166e09b6-2fd7-450a-b7df-b59b961bdfe2@kernel.org>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <166e09b6-2fd7-450a-b7df-b59b961bdfe2@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: ET-mChttOIGRG9vNte6B6c89Jh2UAisQ
X-Authority-Analysis: v=2.4 cv=eeUNubEH c=1 sm=1 tr=0 ts=6a0c2581 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=-1BLe5um57GLRqdpntkA:9 a=QEXdDO2ut3YA:10 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE5MDA4NyBTYWx0ZWRfX0DTgqaJsluaW
 qEF0XiGd9co8bO1ovyb3sfRprHrAo80HC4JTlRl10Mcoe/Sze2rnZWzwiE8CtuPvxRZrOkYSXAT
 2EjLuutLQF9wtbpsxim9eiZEvMTpAGnG9BCHSypJJkSAWYKsWu4y7BHf/HN0e70oac9VyAzEjzw
 NvTmX9+4nz4D6JZa44RIZnIsote9s8c4nWWA++lr20h6aXSW3E7853DxndThAOeCvRASAhYSQQp
 CsgDiL27lHqEdGTNngL7H8u7NAP9s8dJ4KW0+Fg7rY6y7s3MOLwjFxQ/hxAo7lyK5v7ILXevR8z
 WKQhAHrz1/wkYO53qeuItPAS/lPeGHgVJluSWmbFtgZRpecbPZitRPCq78YUcSUoXH9B+s1yGoF
 xoR1A2Kygsn+GFEueGs+Fe5wBPFYcEVsr5gYD6Ic6+vU3I3v4jTMvikbhXD1oH+N43I2Q2UE8Xs
 v6g0AU2Z3Rd2quPIlrA==
X-Proofpoint-ORIG-GUID: ET-mChttOIGRG9vNte6B6c89Jh2UAisQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-19_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 adultscore=0 priorityscore=1501 clxscore=1015
 impostorscore=0 phishscore=0 suspectscore=0 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605190087

> No, about proper patch organizing into one paychset instead of sending 5
> different patchsets with oneliners. That's literally the last
> thread/feedback on internal Open source forum chat, so easy to find.

Sure!
I'll align all 3 ssg modules(ice-ufs/emmc, rng and crypto) in one
patchseries for shikra and send together for ease in review.
Will ensure to follow same pattern in upcoming submissions too.

One doubt, there are mostly dts and dt-bindings patches so i think it's
best to organise per module patches together in big patchseries.

Kindly suggest for alternate opinion.

-- 
Regards
Kuldeep

