Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE4E359704
	for <linux-crypto@vger.kernel.org>; Mon,  2 Feb 2026 12:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770035108; cv=none; b=PMvv3SZhT0FUSqwBEhdpE0RggpfTvnMhR6CENx5hKfE+ltgB07Yl2wUqDc2d8S1fxT0lRV0w4CzU4FgGnv57OU0lCwsxtP6KxFajzXZNdsB7hGFicN/CT7dpsknThxsmChZVQKFs4XbIdCuCnpjRA9ou7zXg9R0y3suiuU9EKVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770035108; c=relaxed/simple;
	bh=gUCF9+jSXyb3JIC6GV9eR70rJwXnnHWNLadFygf+hu0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=roWWCbwBkvbGSgjkyB3+7lPU+w8Vf5wd/xsu9dGSo3LG/V8HJBBEhTqino11hbx8D5xQlDGJ+WqQ+yy5cIuW3BwnwbKZAmKHTzIQRsQYbXBP76RDehVS3wBk9sCLLm82GvAN9eB5WB323x5NOrEZrRHT12ewT50NC+24E9lrZP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=g9lvvJQq; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=hFmOyD9O; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="g9lvvJQq";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="hFmOyD9O"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6128AKLN769243
	for <linux-crypto@vger.kernel.org>; Mon, 2 Feb 2026 12:25:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	xI/twei90NFc37s8BZBKjsNGdHURMt/JPbtCf1osmek=; b=g9lvvJQqF+7AKUg6
	4z7/PjIQ72WmlWUz0HZTyXGlA9ixxwvHSEIFOlM5VRN8rsruCRLUwuFpwJtmCoN2
	D+v5DC1e4neZOJBLR+PgqyXAjZ2oZceXY1v1qKYHazMoTdvpB8vlWchpMG1Oq91S
	r5YQDnuW4J2l7ansf8VXSX2nRabFidAj2hgO+qg5UYjD8TXD8F2AoTm4VPIKCpB+
	/EKnlPVZ86bMP676PFPa+XOgLodZ0xEpaSgbxOTuIhBQI/sP5+HFKIjVvj4iWgoP
	atqtAi2Ct6+ODW5jEyyoMhCCPo3BLZau1YhAQ0/FG2pMCxN3wI4lFt8mn4s+iXAC
	mSyJwQ==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c1aredaab-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 02 Feb 2026 12:25:05 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8c522c44febso95754285a.0
        for <linux-crypto@vger.kernel.org>; Mon, 02 Feb 2026 04:25:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770035105; x=1770639905; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xI/twei90NFc37s8BZBKjsNGdHURMt/JPbtCf1osmek=;
        b=hFmOyD9OEYsiJakumR/4u9hjOf1uZWCAY77U2pMQ6jPnMwu4WxcatTl4CRLFggxSUD
         nGuE91yTwKmuxkdx+30HoQ/wWG8ANxP27+Y8wS93tPV9rSFTsIOxkDta4PaseXackdjU
         eQMmgp5dOy1PiqsOAyFR9IJUDVX00qrmD6tiZrILIt3n4OW2ZZFtdrYV1Hge2AYyL761
         4IfRR6WsQDpiW3it5JZAt7yjMm4OhDMVYVnKAORhwotpbuGHnJhOjh3L5/4AeUuF5X7a
         O6UGWxuFUTFiCZ1WoOPXsUMWe472NvWk9m+XHpTpzOKUaeqtaLG2wCrVClaldsvjedB0
         F+ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770035105; x=1770639905;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xI/twei90NFc37s8BZBKjsNGdHURMt/JPbtCf1osmek=;
        b=YC4P5bWcAzg8W1h3vycREuWKUIk078eV0v4c9DKCJDMKX9vPEweZOCAcFSAYgb36Eu
         rTfBZjUdHR/x80EmqMwXbTp3IrVupTipEuL5cK/bmnZT7PPxyY/SVoBh6hSFP7KvMLiu
         KMASBYbZqHSbiMmftuv9oryppTKOnrL3ZykxNqM5M7LxFKfpOJChQ0FRq+NqUqUCdoK8
         l86i7qWpgFjrCTkB/6Pq7l/M1WPHfLIDljDmLmwX0l32tb6AeMIymY1/Eyrq9j2yJXl+
         YkzMk9qa6KI7w4Tb+E3R1uP9LC7WHCa39WGQleftwLyo2yry23JuupnD+de4JtvOfXwc
         YjFw==
X-Gm-Message-State: AOJu0YzJFzQb6xy2bmeZPhjZvaRtY4JNvpmlV0gOTPlVsJDR3aGbNIGJ
	DARrYmtz3I40EnCKBCTq/IkTgmRkgUVCIZeOJCu9onSz8hFKT65CzXXLCCTy5nr1PUmTBSCsnUm
	iPmMQL1XJVAAjwygcsbTt3z7sBofiv8m3sfu0M10+5JmIJUWgrFxbXVaWbeOiKXuVCYcDShhjyK
	U=
X-Gm-Gg: AZuq6aIZGZCI7U+kOicyv6/9VyxcqS40chb8cygpflnvbgfxjx9Cn3s+3vKeMJnXRv5
	s4n4ngZellExydJarew9pfUxEXRiaZgUiFyb+FSqaQ8LOI0yhHA8tqTvc68KVeSVign7IhZNK3t
	dnhEJhM6biIpInOULTo9HilX0jkyryA2sR8TLimcY+WvDOAtm4O8uMS9Jfuhs3gRSUInPJKSb2S
	ivzKnGGu8AGxVQ/fgaWLGiCRqChCfpDa6mz0RE/4UtN6VzdY7pr8+viCSyX+4PjjkBHYI/1nl7a
	wiDZFeiGityJXBCbtphBN9GzXPKQ6B/D4rwjrpCIJ8vFw4Sej6cXQmroNmTTgNPQxdzGaUrDQ0G
	LF0e7agBc5z7/7+ve+WqjVdjFHwjLMSN0Tt12iuXEfrgWsHTzWOFqlnPXQDYEhjtxuvk=
X-Received: by 2002:a05:620a:31a4:b0:89f:5a1b:1ec9 with SMTP id af79cd13be357-8c9eb25aa3amr1079736585a.1.1770035105234;
        Mon, 02 Feb 2026 04:25:05 -0800 (PST)
X-Received: by 2002:a05:620a:31a4:b0:89f:5a1b:1ec9 with SMTP id af79cd13be357-8c9eb25aa3amr1079734385a.1.1770035104740;
        Mon, 02 Feb 2026 04:25:04 -0800 (PST)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-658b469e6b2sm7608999a12.26.2026.02.02.04.25.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Feb 2026 04:25:03 -0800 (PST)
Message-ID: <b5d7ac9d-64f1-4666-a950-d79347854ad9@oss.qualcomm.com>
Date: Mon, 2 Feb 2026 13:25:01 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] crypto: qce - Add runtime PM and interconnect
 bandwidth scaling support
To: Udit Tiwari <quic_utiwari@quicinc.com>, herbert@gondor.apana.org.au,
        thara.gopinath@gmail.com, davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, quic_neersoni@quicinc.com
References: <20251120062443.2016084-1-quic_utiwari@quicinc.com>
 <a2c6cbdb-a114-423f-a315-6e5e9ab84e5a@oss.qualcomm.com>
 <ec9e420a-932d-4265-8cac-dee003933898@quicinc.com>
 <c1749b86-0016-4314-9497-04e952683060@quicinc.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <c1749b86-0016-4314-9497-04e952683060@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=NNfYOk6g c=1 sm=1 tr=0 ts=698097a2 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=5YqSPhDMRtzW0TTUFusA:9 a=QEXdDO2ut3YA:10
 a=QYH75iMubAgA:10 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-GUID: GXkbRfqovgDHTYmBA0Qkb8Be9sRbNPCx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAyMDA5NiBTYWx0ZWRfX9bSwQkf/0vtz
 KIJ9eSEg7NTR/SrEa/YwDKxgplztyyfztu9z3t3+pAlkxrCAjNNWP/t+vvK1a44A+e02O/3eE2O
 M9qrN+aHYWF6OryngtMLIREl2wAWjU3x/fWA+cKeC/+7OdzYW1BgIKLXd6cRdSciPSJH2x1YxbL
 syjn383ikKvUjiq/VLjf+Rou5DzxgTNEt9J/RmASQcgVEjZDoy1q2XQ9wT+M2llwk3cUb5/x+HB
 wAXbYgADO4bSS5PamXSQaJd07e5SEBOAGeA5lIIgob33GTsYZQDD1vU6XIzoNftBfl2FaqC9ioT
 ugi9thJWRMyXLT+qwDpJ3Mgx2/VzLlRWk3lDbz5FOB222V2Uji4APtSUc7w5IVSez0ObHtibb98
 fD+jsY6kCNR3mNqjdZxa2v98MJz+PGUdVgHwhZlxR1vu+LhYUjqi9mN/hJ0JitCfywO5kV8AlCA
 E4RLXd2kUupSGAM9VCA==
X-Proofpoint-ORIG-GUID: GXkbRfqovgDHTYmBA0Qkb8Be9sRbNPCx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-02_04,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 adultscore=0 priorityscore=1501
 clxscore=1015 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602020096

On 1/27/26 5:27 AM, Udit Tiwari wrote:
> Hi Konrad,
> 
> Gentle ping on this.
> 
> Do you have any further thoughts on my previous reply regarding the PM runtime optimization? I am happy to spin a v6 if you view it as a blocker; otherwise, I would appreciate it if this could be considered for merging as-is.

Sorry for not getting back to you on this in time.

I'd prefer if you used these helpers, as otherwise there's a lot
of unnecessary goto-noise

Konrad
