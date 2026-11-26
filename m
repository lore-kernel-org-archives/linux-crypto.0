Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795702614;
	b=xlNbPWLgbcwvavjniR8tcBnAF5g/TlHnGkbO+y5pcgK3CTy9VYHNtE1iaiP6+aJ66yyE
	 2M5bUUBMZmH1s+UP6JTCgRG4jsFabLwbRDfekO6xIP85oPkL/AZasPn4OJaGimPlQXcSq
	 XQFMNzm+aaEWrYFURVKGOJ7nQYrd2UizH7ts41Nv9Im6JtXaroVxYG1tt9MAw7dvwSEwe
	 YtLoBwI8jAkX2HezYMesw+uhp8phkbNyH62/BHDV+oAMz3p7oepzBchZR0vauzsjktfKk
	 tjZd2FONSuzPnbCApzNbGAn817M/Cq82j95TuqESQOElwbqqrySSWp4zVaNSEEGnY0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795702614;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=81VUyM9OyNKUT0VpP18THwSLW7N2IcKNAzwm/Y2Nd04=;
	b=diEWI/MViipslgRlbGyaL8NCciRY/SVWdWxnyYciBKmKvHl+A7M9SJuGXMcvCddPYu4V
	 C3TUvuUBQ8B7uA38sBdvazgIJW7qulraiIewQYmrCM9+p4Fe/pxRz4KaXQD+HKbJ25sgq
	 7O8XnJiJ1fLgS/uVs1ovcxiOH5sSzEt9uuEhv2HYhJaSodUR7oJtqPUOlf+HbntqpaRb6
	 eyO5Wi+o9bgrT9x3avaDGvE/9URh7/Z0waIt0gKon7jmFXDDPFmYPLRuymqNF7Dn1/npr
	 XHF+01Ge1uBBk9hAT6xy2qjfDnUXoFF8Ve4M7S2cM2GoJIsPq/uuU6bhf93DfcTKhEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=GWx0JCOG;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=eTmTi2HT;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BBD4606A323
	for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 14:16:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1BBD4606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=GWx0JCOG;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=eTmTi2HT
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AQBVTJ84128655
	for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 14:16:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	81VUyM9OyNKUT0VpP18THwSLW7N2IcKNAzwm/Y2Nd04=; b=GWx0JCOGicO0i4LW
	G4Tew6ke7Z38UvBMWbvtQ0nk5TvnngWUI5xdJJdAuoV7XhvJzd5cHgrU5HjfBEEL
	SO7PE+zqMDEqV3Vyh4/HDSYqte54Sigk+KSYn90RV1P+tfJfHFS5MFoBvmMILDIu
	9FPtEZawDTrbxTXHBeZceFFMA2uRSK+NkGYGNtE6S0ctoeGEhT6C9WgxLBe8heXo
	kqs4UZxrElCwFGRfjGGjEh9gAFn4msgsWzRMursE3tHNibr9hppCoV8swVgR3nRH
	lXXrJffwBvWD0SkKtlTMaDPKvbbldhMn+Eo3k536gcbrybBKUvViobR7R/swALKk
	iCczcA==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4j62vav8mg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 14:16:52 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-530cd3dff25so17072701cf.0
        for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 06:16:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1795702612; x=1796307412; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=81VUyM9OyNKUT0VpP18THwSLW7N2IcKNAzwm/Y2Nd04=;
        b=eTmTi2HTS+/zYBVxzOZ/wJNY1vydahLtkySrZ5RF2oHXwhAifl3QLLBhx3D+ynnc2O
         FBXELO1Rt7xqrpZDkXgxa6Exl5gXBdWxyuyX3vW+054sZfePh0LQyJhWHkUD0Uf1KZoU
         meC54OkEcULUem63G1pxMbhCePawtKxIv20I7z3Ewzzd8ReKig3MDHiFlpt78cs+rAD1
         Zfg8O0TqfNF4VkmI5sBmGVYVpFldE3LxrsVIWUE/n3B8AzWcbiRpBediw2AnO7jt5Tom
         ZOwxBwHDHfrtdoIPKygHIET0puGq71L4q+1Ph7B66EFP3eLNfvi0dqc/NOMsR8/RqYQV
         yU+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795702612; x=1796307412;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=81VUyM9OyNKUT0VpP18THwSLW7N2IcKNAzwm/Y2Nd04=;
        b=1osAj2nCTL1He80d7CTbzwaw3ypFNohQlKCL7QTjnUihFgQpnlDdAZnpmwvwh23Q5D
         cjAqBH8gQ/c9qAjtaHjmClQo7XyOrlqsg/WxMCGeRStOsMkdg49/QJDijS9RATG3SnhT
         q1iJ5ThC4E6nKMDa1HOXzY0LdpDhJodaoTPO0cGFmkvu9Sav7Z+C2MZk0y9ynSgnCc+X
         7ocz3Hwe74461hggDkMyYh8jXGn4mX+kcNf/tODLr/BEbs2UeIBWGXtbTXnzWx5m08FU
         /yWDhcPWraUXhv2OZVr4//s+nbQiwaWI4eOL9nLCaTWxxuqQY267Bl8Bo5M7aNHffV0p
         My3g==
X-Forwarded-Encrypted: i=1; AL+hErFaoqYcPhmUJ2Q4iZONLII7R2sZs8q2brN8/U0mvVj/Dz+NB2ZM5tMaWstm80aL8wrvKMrY/oSESvdVm4Q=@vger.kernel.org
X-Gm-Message-State: APuU4Z+LEx61KZiPrQRYHWcZx720gYo9Ke2xyzMJsLbNFfYCM/FdeLG4
	XUvk5Wgbcy9WR4bHoLV4CydKgezIiq3zBYCz6btrxJa0I6Jc5wkSDKylGOq2RV34kxn8/4qYRBA
	pjJcasMYQUzGWzJPrZMQ9Pg7WU4z3HkUW9UqFv8UtF3gzfg/0WbHCk/Qk10Ls8rah3kQ=
X-Gm-Gg: AZFdTZe3skPnVXlvl7b9OvS+dkfA4y0vz/Hrs2QW1cZe3SNylAaG+xxlHUnY/1mwJjg
	CndFG9dDd6cPQtu3VkqMcblyAuM2U2s6E7LXWHhTILpt1ohKl/jQyB2DZiPUkxlEYq0RdGmY4qv
	o9G6Sc25QRoz32cHQyHjEwggv1fmWKudga4jhFVetuAgWPo7f7ihiFCNrgubz/pJDuVQHjsew2w
	i1z+xOg7SwnTTr2vYeoN6RECg4mpSxxEr3mpH7c3sTeM5l5CXBZr1+gs4TsHz4EUvfYHet2+ZPl
	mFEmbi7Pxk9cdSQJFaluqqbOOb2WBSdxrLsnGapJ9DcmhDPSTA+NEpTsAWHxcEvmJL9hCHdoBRD
	8pwpGfcM7WO6o+QEMPMZc4O/ZYn2YE3iBOGiMV1m4y0qATV7zSUe0Vfo3H6uUXmkHi3LNjV0=
X-Received: by 2002:a05:620a:1118:b0:949:95d6:4039 with SMTP id af79cd13be357-949ba9c1d91mr3824485685a.3.1795702612015;
        Thu, 26 Nov 2026 06:16:52 -0800 (PST)
X-Received: by 2002:a05:620a:1118:b0:949:95d6:4039 with SMTP id af79cd13be357-949ba9c1d91mr3824482985a.3.1795702611598;
        Thu, 26 Nov 2026 06:16:51 -0800 (PST)
Received: from [192.168.226.72] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6bb11ff543fsm2858929a12.2.2026.11.26.06.16.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2026 06:16:50 -0800 (PST)
Message-ID: <5cde45d9-40c3-48b8-8074-41342d0cc11e@oss.qualcomm.com>
Date: Thu, 26 Nov 2026 15:16:47 +0100
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] arm64: dts: qcom: shikra: Correct QCE node
 configuration
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
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
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
References: <20261116-shikra_qce_fix-v3-0-9ae31470ef48@oss.qualcomm.com>
 <20261116-shikra_qce_fix-v3-2-9ae31470ef48@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20261116-shikra_qce_fix-v3-2-9ae31470ef48@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI2MDA1NSBTYWx0ZWRfX62t/4SMi40Lm
 FRQhtvSNIBnJbsTYWDc78PompMCDFfQvq7RaLr+FXwq7ZGPdphTQZo/j6l//zxQUApJJcQjXQhY
 dS48XI1HnphoEzz1DbFaySxEWsD+2VA=
X-Proofpoint-ORIG-GUID: WAqxgYHJxZp3fUZd7l0yKwn3c8he1q0I
X-Proofpoint-GUID: WAqxgYHJxZp3fUZd7l0yKwn3c8he1q0I
X-Authority-Analysis: v=2.4 cv=QZPzLcbv c=1 sm=1 tr=0 ts=6b083f55 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=i8PxzMkZueSLsKX-AXUA:9 a=QEXdDO2ut3YA:10 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI2MDA1NSBTYWx0ZWRfXxwGTlAncafHG
 QHcQZAA33U7kRAeDx302bk4uN4/b4x27Y2a7acOVENdAh4yI9ZK7zjyaRniWt0GJFAHSdI+2F4H
 WGEjkLThJ17JtzW3NJW/ubuukh4PlDzFIg7pFsSNTIDZ5wrFXBNJKccPdpdzkuZpRJWjWtszBTb
 3VHKpjHRF3jPMFH68qVag2PJQdphVEVK/mi78yIAUapVmTc5YuBGrQiHITQY/TtocdGjD2uhAkv
 blV9qjXWTGQjK8bKG+Apd7/rh3NFEbeTz9jnx8W03FGHFHdohor+WAQYbrb1a9GflOknqEUs1FX
 d/dosi0sGeccVnYOpj+RKgzYgLlKt231u8vzeP0kc2P8UFflBMW3MpnT2HGMiZO7RaRfKqER8jZ
 Fr13cy+vJE8J6h+Did9tKNnEL8J+gXrblYanVBpvLOVb2dLF9yXrnc+THJKZyoZb0UMsmFGnzih
 +DCpK+VIVSVyacGBpcQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-26_03,2026-11-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 bulkscore=0 phishscore=0
 adultscore=0 malwarescore=0 impostorscore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611260055

On 11/16/26 9:59 AM, Kuldeep Singh wrote:
> Shikra QCE requires an explicit core clock, which is missing from the
> current configuration. Adjust fallback compatible to "qcom,ipq4019-qce"
> and specify core clock to match updated binding description.
> The crypto interconnect path is already described by SCM node, which
> votes for MASTER_CRYPTO_CORE0. Drop the duplicate interconnect vote from
> the QCE node.

I understand the need for the clock, I don't quite see what we
achieve by removing the interconnect

Konrad
