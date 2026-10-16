Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4256B42255C
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 12:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792155154; cv=none; b=LQl7fAVLoRw/MEpd4oJsobyHtSdcBfRC5cAoEjpjj3sCaJEEOg48njhT9Yei+h6EPJ0ioTVzjgRAwFD+3DhPXJIXc1iN/GTaCtvBlk5WtyTjyeWuXYE82fdkvhcRTNyWcdTK1f/dlUenUkya6jPQOzIOkC/YFga/t2sf7X6CjMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792155154; c=relaxed/simple;
	bh=QGqaZ7i9dKEfrVnbt6JGQYBUklOVHj32bMfbdLDrZn8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ifN2agx1G/YYJIMbzfaFROuMSsZ1VIIM1u5DR/L3SQYR26CfF6VFx1wh+8FiqJCgVdPgh6IK8HJSEpDbVdvpcywGrBfNZto1/NJwpZvwv2ow1sU65Z99oqjUiCLqy+e3WGdMUOKOh5KNsDZAnNaGT6P6Z2vFX1W3TTDGbX6IpSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=BiCdtCix; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=DQnl8jUn; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="BiCdtCix";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="DQnl8jUn"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69GAAAmF1946257
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 12:52:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	l5p8F5gLdJ5GtjeEk2HF7/oDkM2Pu19Oyu1v/XHNad0=; b=BiCdtCixAewQFR4R
	vpWjzHDOou7cC31j3b5syQk6RhdCJ2MhpgMPjPQdl+TtlShBREQ0z7e0zJFyS3Jg
	IoXTjERN0ElN1okwlwXibUYmGXOh7N4lV6zyGdzMtyn1ie23bLxA5RNWQ4x7cmdx
	wjTMUZB1H8yyuuRbwUwIHBLB6jstTIrmF4q7zXZjbQXivlhvSIlrI69Y30L0C4DA
	ScYkLJYNAa2OZ9HXaJOTuPtcaOhP5uBdvgSEtsFwOUNDd7xgh2+DB29wWX5bvCPi
	nkcEBtHcxhvxd3s9e8cxIY1QGE0gjnyaVTivUBx8kV0ZPUnf6m9yIB7t2gcXn5qM
	kM+InA==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hbg5ys0sf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 12:52:32 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-3552883bd19so14652035eec.1
        for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 05:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792155151; x=1792759951; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=l5p8F5gLdJ5GtjeEk2HF7/oDkM2Pu19Oyu1v/XHNad0=;
        b=DQnl8jUnn6gQge69SPfCwsAB0pWRbkqDzAOkpFwWxFA9SBrNqMYspkX5/tvyLGG6to
         vcPEHf1gwJKLTzz4RYiypA72MKa0Aw9Q+iVl+ajrRXIkEOl+hcTYAO/pGEopbikpGPl0
         LgpmdG0P36ONRKF2XeGEKBv9V8xz8JkmpGlaiynsyf0pAITsMsV9iEo22OPQQ4w7mwt7
         LfE76TA04kWzNJ0tZAr3IrMzv6fBJybKFEtT47gQc1/DraHqC2Pv7gUYdBQIlhF9r0v1
         euAmZgkOkJMCtSkd9Xaq98vgZ4Ws6ssJ7QDd+e7ZTGih80miEz6KbfkBw6H1Y+Q/EEXE
         7USA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792155151; x=1792759951;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l5p8F5gLdJ5GtjeEk2HF7/oDkM2Pu19Oyu1v/XHNad0=;
        b=cHeq0aDvjO43KrAM1iRDT5juMM7CwiS2qgspytKPzltCgZtBJ472DqcmkNpccvU0eL
         cEv5yj8qIo2SAkZWxGAopKfK9ueERtfOdAH915K/KCpxB3h+RYSkf1N789CMMs56IsGp
         CDCnj8FaVeHJefavMTcas22BB4lm0P/ghNBYgsLCHnM3mjSMe2UntatODvnjhCXtZJok
         jDHDTfN0RvD1icxVfO5MWddqLFz1bONGcb8La6/eHhm5p/qjdyKh47HQSjuipLPox+Xt
         ylU5vjZnysqVivdtFYeSn8ImdzAznoHzrBsPHelxocqe7YVWUdSzoKY5fZFXOe5SekIs
         VPaw==
X-Forwarded-Encrypted: i=1; AKwUvBxkF0lxTEcW1tPprVzjiq5nzemwnfxXZa3aIj/SHXXuBaNK0ny7ADtTMNTqqo0tCkrynDTHv8c3ai6rSUE=@vger.kernel.org
X-Gm-Message-State: AFq9FYJrtpEtZHk/dYStcN9cVa4fsy+h2JQ8d/wm5AuNniyR6g+kGuVj
	MlY6tQOrCF+6vvy9/Xzbv5J1cZo3ZsFQ0ApVNqnZBnK/hZCAn93tZUssEiIRnkhkLXTVfkcgGj0
	qnNHq6LVFWpMsKFuF9uYJol1AiIyslLrgn7PiOjPBdK3Ad3g9eM7bmUSeS8LD4wIVyFQ=
X-Gm-Gg: AYBFou0TqkRfD6UtAX9ZOu8FyNUAFMxIliSe7atKHXTWZMtblOVcF+cgjSMFAVNEkeA
	f8O7SV2VtFUa6AByTnP+eHjt/FfsWm2e1v67vmWOOUufuYthzUMXW0krqPAMC8Gd5KmTqReIo54
	gbNVJ2ArxONXUFCXmhCjcdxzQgxAg1DrWOx/VrWLWVSy8iNN4V958otlVFWtzqnoe8GMzwoiLIw
	He5DRTyPuIiu8vq/y0IuGL3ZwQyQ33zxE3xHsumZ9gMV8u3CMZD7X9dbZythj+wxxuFViOSfqu6
	SVBrylFZNjx9FKX90ZdCGZwcEiFhcEnij6H1abU/5Nl2OmSDUzsrHiOhAwBHu9Uh++0iFh9WHpZ
	UoF9DPZxpXL+HHcyHJE2DljNYN1Ws+XQ=
X-Received: by 2002:a05:7301:1929:b0:351:7ec0:daa3 with SMTP id 5a478bee46e88-3537e04eeb2mr30724447eec.31.1792155150948;
        Fri, 16 Oct 2026 05:52:30 -0700 (PDT)
X-Received: by 2002:a05:7301:1929:b0:351:7ec0:daa3 with SMTP id 5a478bee46e88-3537e04eeb2mr30724421eec.31.1792155150391;
        Fri, 16 Oct 2026 05:52:30 -0700 (PDT)
Received: from [10.218.31.125] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36081ab80f9sm11558273eec.12.2026.10.16.05.52.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2026 05:52:29 -0700 (PDT)
Message-ID: <1a11724b-3f2e-4c4d-a8e4-eb9c0dc3c18a@oss.qualcomm.com>
Date: Fri, 16 Oct 2026 18:22:23 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] arm64: dts: qcom: shikra: Correct QCE node
 configuration
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Bartosz Golaszewski <brgl@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>
Cc: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
References: <20261006-shikra_qce_fix-v1-0-8ac54d81edb4@oss.qualcomm.com>
 <20261006-shikra_qce_fix-v1-2-8ac54d81edb4@oss.qualcomm.com>
 <18d6a6ce-afc6-4590-ac26-0aca6dfafae7@oss.qualcomm.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <18d6a6ce-afc6-4590-ac26-0aca6dfafae7@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: kx0zFzw6eM3MmroetVOimg2TA44tAO-g
X-Authority-Analysis: v=2.4 cv=M+HYuCws c=1 sm=1 tr=0 ts=6ad21e10 cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=9GsNmjbEMOpVDnpVqTcA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA1MSBTYWx0ZWRfX2rJPBR8yZzhf
 zXRORq7YY2CuuQx9o9+6pnE/GU7NVSQfxainC8eMPHErsOBLAxm+caVbG0HDXKxMAb8931Ji2BU
 fKeBXeYhYHWd5zx1sYdIr7YeOJvaREM=
X-Proofpoint-GUID: kx0zFzw6eM3MmroetVOimg2TA44tAO-g
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA1MSBTYWx0ZWRfX4eFJgr78N9W+
 B3Yq4mG1cWEMOgO5KVkxYrA4YAha/copigMbk9KU0CWA6UHOaISiuBUgLLV3ALJMvaLrjS9GlS1
 bTjM/Q/LnIVghV76HztepaKjNAxZ0nF/Dazhqtdp0esMND8xEYGJFm10s2ssBqaK5xKulJfacSC
 bcpv0RztKfiAsI1usB2IS6wNCHj6oQ7EJTZiuPYrGCeci2b32xZXVaSQiYTzeelP3Y4WYY3f4CP
 XXqtLvbBp7sVsD589B/Y+f51U6PTboHRxqTPDHTv9YSUvV70Mzze95pAIC650Ks2VLfHonvVsAI
 xiiFeo6IGZRE5hCVFZ5YBjXdZ4IKMTViGlQm+VL7wB1gcIkRxjoZvz+0mzccOtoE1qRSnJM+Ss9
 fD94nqPigVKPMjdXTEsYKl7FtbbR+KAh6549lfcznoZLBQutQNbPH7wqi8/yx828PGgyOXjMtr/
 Cg/nbk33+YGSvlNIpkg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 impostorscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160051

On 16-10-2026 18:01, Konrad Dybcio wrote:
> On 10/6/26 1:14 PM, Kuldeep Singh wrote:
>> Shikra is derived from Agatti and uses the same QCE integration.
> 
> This is useful, but..
> 
>> Update the QCE node to match the underlying hardware implementation by
>> adjusting the fallback compatible and related properties, including
>> clocks and clock-names.
> 
> because the compatible you switch to says ipq4019 and not "agatti" or
> "qcm2290", the argument falls apart.

Ok, then I'll update the commit message and avoid adding agatti context
for shikra changes.

-- 
Regards
Kuldeep

