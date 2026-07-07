Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C2629D265
	for <linux-crypto@vger.kernel.org>; Tue,  7 Jul 2026 04:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783399533; cv=none; b=YiQ/4H/ZBOsZC8STAmYmM0RuliiLvRnzej1BtoXmP/IJRk2oZ9btJhRfL3Nf0x1sHIRzM/ZB3n2S12q7l4TXDWM6tkhIyyZSYb+HapuP9UxmQiJoeji/knUVGNRuDV9nNip2uAqvy6o8drs0+Gwvi0i1vs3usjGVU7Jx1dmkJzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783399533; c=relaxed/simple;
	bh=bOaen4HQBqLDxgRE5hyhkg9PTG8dtkmNvWLObiWeEAc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G6ax9WID8dULMqqVJ0KGi1SwQNGaMizH4ADBoYUXvUN1LsMu6Bknoj5L++4wlGqsU/dlncGFoHgZdg1X7x/Mdy/BRqPpZU6xKm8nbRm95+IHw1rHDom8OyR8TAyEthNmTQC+JqgPPkswJ9hFys1Qbz9lbIEwtbRtWp1VOh+JzsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Y2F3xtTf; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Mfi3pp1t; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Y2F3xtTf";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Mfi3pp1t"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66748s3f2629803
	for <linux-crypto@vger.kernel.org>; Tue, 7 Jul 2026 04:45:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	q+k3HncfY880D3KURL9SNiHOlxwrlnkZIkiKMuzSj2I=; b=Y2F3xtTfyd6BLRRk
	BgpGOZOoWOxO0apoZ9nms/Xu0fgEoUlTTi9kW/4wYx9kzSi96rZd5en0OnaFkwHQ
	oay/Rdi+ZtPda9+o/7PpY7NoNgsTaNV9Z4LMG+LkBALufCDA6GF8NfxnpGu+8AU1
	4+KxpMvt57w2yZBl6HCGwVMcnvXUrQsh2GBdbsofVYMkUSzrHmFw/LzD3AP+VLVV
	KoEVOy/SYJyrQ+4GsPKBFS4YZG5EjevP99aAkDP8FsVqhYODsgKzSDvToIjHcCGC
	besq1ArKplIlKmIKnrETi1a+KT3YYzIrYVog1ZFTUcdXmq3wVfPb4gnlNUx5lAPV
	VuQ5Vw==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f88h54h9q-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 07 Jul 2026 04:45:31 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-37fca5f21b1so357280a91.0
        for <linux-crypto@vger.kernel.org>; Mon, 06 Jul 2026 21:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783399530; x=1784004330; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q+k3HncfY880D3KURL9SNiHOlxwrlnkZIkiKMuzSj2I=;
        b=Mfi3pp1teW11+axrC+bBScKRZLUxs8pynUEWG3/cNFv+oPs2fZENe282B/Ddd1+s3r
         bG2rBdXnQWdlNYPuQZyrIejjX4Kls+aGBODS0Md6RvhkCvTzpiJWCKo+z3j8ia6ykV2s
         PrR5Q8clfTwW2Mdss2qdG57GqjoIQHxwxRQsjEXg5H8w7qILwakL+36CFNXt96JPgXtF
         xRLH9V3ZslLwNDvRsAcGX33mxN+TSAIWqBjO1O2l8OGgZYn2p9eOV7o0nDnpJa8EZlsK
         R0V2pjc7QfYVkVkRdUyw9qngW9wIe80WR523hHLCfUH29MvmQ1jxOeWWIVXl8TRlzULS
         Uz+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783399530; x=1784004330;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q+k3HncfY880D3KURL9SNiHOlxwrlnkZIkiKMuzSj2I=;
        b=Fl7ixY3veXFoGGIg7Ta6JVsfJyRaNi9/rhwe7qj7PW3rgSZOttxg5hhkuUUpAJYIWH
         XETmkjcYBtiEYaJeamOSNZrPGFV1/aR08eBZv81xuDgphKN/xD7gJuSvsly8U453Us0B
         LIZYmzZv23nWyNS+4Aoi+M67jTzzFQLMTSpsoKgGp+lBmVvtlccjJbUuGrCf5tPlNoGV
         8VAl5tSRUIONPWYsKIZkg4cQAWiXZW3JukZEvUQt3P5GrtAFGg3/Htjmcr4IKhH3X10T
         Jhij1BXnahz439xOEFE1K/VDL6m0RlSLVSUW4wa3YJZ1J/9ncszdcRavfM1M3TiMBwD5
         /eog==
X-Forwarded-Encrypted: i=1; AHgh+RoIfw5wjGyp8Qfb4LOCQQkCR91EsjMZ5vMLcrG68jHfCgDrYf0rePKm8AQPqkja4CPb22+z0/DnY474ixc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZVu+jAMpsrPzOvW2G5gS8N5A0kW/ikOUd2OGCM/SAgsQEQJza
	v2vhSnEoAo5PvpMkxq4MGMnITGf/WP+65fyTE6zo6I3CcCSETl3UjBMTNLuz1gon8Ut6va52wuM
	tH6blhVeOwnmYD518728tLmI65SsoBiqrpqyvzAyMjWieAgNSzLc3C4BqI6fe+BodEeg=
X-Gm-Gg: AfdE7clKcpClMOh1w7e3SgmL+f+pfuxB0/CsVVzvVg0gBXlQBwt4IotWuyM3/WOOiDF
	7UXsNmoC1TiLhqtduMEcxgY2g9Z444O3UB2twIzXXfvz91/uID1Pu8XmaAivpg6bT7+1WbgoGO7
	/ecJFJ5aryV+hOTHBOK9+pWUirk/99KkKkZ8rrN2/oVebZISrNF2+ysNf44sk7acrhG2cAbHh2L
	xVhxnUkup7B0Bs59DqZHeZ83RxbDOK50/ESXwr/IHmC5Ji+cEBlNisKg5B2zdtGmASLcX8Z+nxf
	6pNhoK67if/otDuKqUamk5+as5YHIhuNuUHjpaguY2yGG8HC9ZlgwFCPp7jjz4JhZ8isCdFD9Uj
	uD1yFuLtgLHvUVQhQIN9owiOf91D007VBvrFIs23AkPo=
X-Received: by 2002:a17:90b:1801:b0:387:d9cc:7dc1 with SMTP id 98e67ed59e1d1-387d9cc8dd9mr1414270a91.19.1783399530382;
        Mon, 06 Jul 2026 21:45:30 -0700 (PDT)
X-Received: by 2002:a17:90b:1801:b0:387:d9cc:7dc1 with SMTP id 98e67ed59e1d1-387d9cc8dd9mr1414224a91.19.1783399529894;
        Mon, 06 Jul 2026 21:45:29 -0700 (PDT)
Received: from [10.217.222.146] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3117483ddd1sm3586885eec.9.2026.07.06.21.45.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jul 2026 21:45:29 -0700 (PDT)
Message-ID: <44d4c55c-bf8c-4baf-aebd-49ad35350909@oss.qualcomm.com>
Date: Tue, 7 Jul 2026 10:15:22 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/6] Shikra: Add DT support for ICE, RNG and QCE
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Vinod Koul <vkoul@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>,
        Konrad Dybcio
 <konradybcio@kernel.org>,
        Frank Li <Frank.Li@kernel.org>, Andy Gross <agross@kernel.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
References: <20260706-b4-shikra_crypto_changse-v3-0-23b4c2054227@oss.qualcomm.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20260706-b4-shikra_crypto_changse-v3-0-23b4c2054227@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: CMmJbQpv2Gb8xzjB251eRm_jDtPcl7gT
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA0MiBTYWx0ZWRfX7UWd6KW2VRK1
 vdAVeDFq+i3CdMP7MTzDGfSgh7w2u9aN7PoYSgo8CeznwJO4s2NMnUzsFI99c3cjvPDPOYWKRnC
 2ScoZ0C/C7Ok/Zir21hxlnlD81LJGO8=
X-Authority-Analysis: v=2.4 cv=EPU2FVZC c=1 sm=1 tr=0 ts=6a4c846b cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=pGLkceISAAAA:8 a=hD90gCo8i-7HE4vOkn4A:9
 a=QEXdDO2ut3YA:10 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA0MiBTYWx0ZWRfXxxlgfJLqJOUV
 HZMb6l1+zfeEqt+qMVy2wKyQdkOT2R6Wa2RAJtNBMBGgGz9irTDfU/kW/JNTX6wGlWzdB52tl0x
 L5EVdNEMYP/0irK7m3CEyD5nR/0p1KuxN3scNWattZHzVZdRsmALFG/UdNsVQeb+1jTghpx0XXQ
 wIasmcjBtR+2sUFxcQuCyH6ZDMMB1LolsG9Hc8FeQccDISYirBk5JjIAM/4LhG0r1GSxPf6prkf
 7C67z+NPrez+RI4Z1rvkEZrVaIXAIB2iV+o8F8kxxQtMj/3XONt9S04Zv82+ogoLEuR8yOzQ/1Q
 aPEYu0JBxlAjW4NKb/IIeyd8Qcz0gwqTaunfScBvvXILz/ociK34OWx4LDacpV4zaeIx2lnWOC0
 QxnMZ+f8B4PxjNJo1+ZFCUHVYFzH1De8uN4/GxM0F0UNpyI4uGza4YIQeqB6SxZLhjrdFgTsXMz
 2XZ9VCSWls9522tXiXw==
X-Proofpoint-ORIG-GUID: CMmJbQpv2Gb8xzjB251eRm_jDtPcl7gT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 malwarescore=0
 spamscore=0 adultscore=0 suspectscore=0 phishscore=0 bulkscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607070042

On 06-07-2026 17:01, Kuldeep Singh wrote:
> This patch series enables SDHC ICE, RNG and QCE support on Shikra,
> aligned with how similar support is modeled on other Qualcomm platforms.
> 
> These DT and dt-bindings updates were previously posted as three
> separate series. Based on review feedback, they are grouped here as one
> crypto-focused series.
> 
> Previous threads:
> QCE: https://lore.kernel.org/lkml/20260515-shikra_qcrypto-v1-0-80f07b345c29@oss.qualcomm.com/
> RNG: https://lore.kernel.org/lkml/20260514-shikra_rng-v1-0-4ea721a1429a@oss.qualcomm.com/
> ICE: https://lore.kernel.org/lkml/20260515-shikra_ice_ufs-v2-0-2724a54339db@oss.qualcomm.com/
> 
> Prerequisite series:
> - https://lore.kernel.org/all/20260612-shikra-dt-v6-0-6b6cb58db477@oss.qualcomm.com/
> - https://lore.kernel.org/lkml/20260629-ice_emmc_support-v8-0-1a26e1717b85@oss.qualcomm.com/

Above prerequisite is no longer a dependency, as sdhci-msm bindings for
defining qcom,ice property are picked for -next by Ulf.
https://lore.kernel.org/lkml/CAPx+jO8t_kQ5q4XmNJoJ1nR4Kro-2M1s_Xj93qxuFUW7VPQpTw@mail.gmail.com/

-- 
Regards
Kuldeep

