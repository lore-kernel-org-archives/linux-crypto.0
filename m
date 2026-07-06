Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF76741F7CC
	for <linux-crypto@vger.kernel.org>; Mon,  6 Jul 2026 12:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783339325; cv=none; b=r6NukgKvqRt6gBzPzriSaYh0Fgjj0tP7usC41XJef5p9vDurkPIeao1Z94X7/sBnp96PV0mfoX4VvokmSz6CkWG9y8dpUko83c67/3r/Ym1mPe6HGkVJgYMkP57qbWTxbMYGOBlAoG3rgnoTUFhOAV5wyrdWyOu2Brw4pW4Myi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783339325; c=relaxed/simple;
	bh=ibd9j0TYhA3ef6VnnsN6ZGeTU9TDGcUj6xKZLhqifXo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hzyferehnumYEEqLURcVBkjd+JwVwynnq+BXDkYHtOKaSa74OZ2HmKVgarH2rQ3pAqcn61YOtouxV/OC4nvkNO5oh+bAxB24ToH/MsaNj3KHielL09Ztt+1K0uLOjzde3bMIy8oEamz1BjvgcB2csPbUcAK3uT7C4LDuPzlJNAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=I/2Ep4gQ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=UiziOe7K; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="I/2Ep4gQ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="UiziOe7K"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 666AxCOG238118
	for <linux-crypto@vger.kernel.org>; Mon, 6 Jul 2026 12:02:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	jRfU2tL6xvmoxRw85U0zq8PguQiagILdyl9QqLKfIk8=; b=I/2Ep4gQUtfyQBSC
	nORKngLwgB1B+83CKEG+wcwb9jvwmBHNmIfUIblF8x1PEQjfL285Evu1KUJKFCW0
	AbngmzoJhZpN2c4ApkUIUtmo5G9DSL5wa23P8qrrsTNcjN9smIuhNcPD1nJXk9uo
	6vx4+uwOb8S2lJG4siYDCb5fp0QiUtC9j093TpUpgjXkboZR4CKZ9xcXkmuXCzbF
	Dd3eB7vHVG8W4FsoOpgvL0R9oiSDb3YK1X/He5a0ygbw6kxzR69Jq04TH89jQaKM
	7GiXmLM7Y40fi5NV3TauLMjysN0vOLKWPObi70UqokqQNi4SbhvDItv4tbtg6lUD
	4eKt4Q==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f88t88u68-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 06 Jul 2026 12:02:04 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cc73f47bdcso34306675ad.3
        for <linux-crypto@vger.kernel.org>; Mon, 06 Jul 2026 05:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783339323; x=1783944123; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jRfU2tL6xvmoxRw85U0zq8PguQiagILdyl9QqLKfIk8=;
        b=UiziOe7KqWeIgee4Yb63U5pTcrbDWGL3GqwFQMab5ODaz9pF6ZiBr5MyAoCkEv6qKi
         sBqUBVpcCFYGhhPvh6r8PFHCQDNhfIWyqvbLP3tHuvlvuukyYsxyAdWVzFfou4Il0O/y
         ++tjNkZljx5Peg4ZGutAru3ic5Fu2aZskny1B5jIGg1HUrryyeB2f2oGGnorERHP2Xw5
         KwhxYiQbqXbo4yJdq7qs0uhXWJcRtKVjSPKY64YgxbaDt2Ie5T5zRH0+cpJAX8tLpYPk
         5ta6oZ8OXzq2WVJYmsLUYMGoqXRKMDzC7COjeJGfvp6HVwO+ZD1wD43gHQoQbgjyp451
         16Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783339323; x=1783944123;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jRfU2tL6xvmoxRw85U0zq8PguQiagILdyl9QqLKfIk8=;
        b=Rjqeq6A2zwnOF8ZykPKFTf4htqIErywrs4bpYTa2T5ycKEq2Aw+X/JCniAAIE7AHxc
         oHziofxgeFjJze0GPhQjD9ngG9cBDZxpICzVP1+gy0RZecisOzpmDUVd5oqbQe6oycYE
         AudqE6zgPG7nChUNjhqPFqWqpjh4+/taFhmnsIc1T0liBbKl6ZpG+EyX2kYAW+OSCnTY
         JRbnQz1bmmyU8ek/jUWTzKJxz4mDmSsArMOH+/+HsldjKSxULoLjQvg/Br4cCVrSBDQm
         TEZvvyhrrazMslZc0FUwxsGAFekuW0CjBQOl6dUHd871UhepjoS/RKGWx533WrgQt5m1
         S8PQ==
X-Forwarded-Encrypted: i=1; AHgh+RpxT8ixf0X/QlOpu4wAbWqSZCjcQrinzdqh+KrLeNXjYnWsU8EgJgEypKgUuJQWRsdPQNYgt49eZnzsq7k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBKqyRWzklHF5+B8hWDmCtA4AyiXWJQTFHg3BiW90Q2hegu77v
	+GH9Nwm0YgIyN28AKpL8f1Kzmiio1rr/zzarh4jKb6IPGLCjbCyCo+B1ds3Tgriv9XJGIM5n51S
	Ma5jWm2ZOgdSMp39GXYCn5FZLMItw5DSLvkkq/R/t/eeK7WZNqDwanRdGIyUnNg3zZxY=
X-Gm-Gg: AfdE7cmHByjFgp1YgGArLO+Wx1FEcnVHkt46Eju/Ye52PFxyugm0p0QLOkHaBGeJmy8
	27LDhqdCPOXpZAGdYXontfdtA4ZIlR+FUHbBRjEJL0xpCDH69//mdyw9qYOXUtP9DQlcKtLYoX4
	LInAQflHg4UfVz64syaySlQyGpd99i9aiRLE21CuGEgqajNZ50IWm32BTUjJoZa6uBFD02fly3A
	ayIXj0tHBA0Qqsa0x1Zzp1xqqzLAUS9gVxU5I4Q9xSIE4iNHqxQwjags+/B/AeKOf5qtHC7tUi5
	7IN0oVKRQDTHaliSUwkFivnDv5RY5clHi/kfQxZpORhsaP+UtdCU4HG9yFz6WOC32grrb6KMvq3
	AUCed4rMiBTp75Ihl3T9tiM8SapwMcQhYpbrOv7tlkSs=
X-Received: by 2002:a05:6a20:2589:b0:3bf:b3d5:ce2d with SMTP id adf61e73a8af0-3c08ed5080dmr302601637.7.1783339323387;
        Mon, 06 Jul 2026 05:02:03 -0700 (PDT)
X-Received: by 2002:a05:6a20:2589:b0:3bf:b3d5:ce2d with SMTP id adf61e73a8af0-3c08ed5080dmr302556637.7.1783339322904;
        Mon, 06 Jul 2026 05:02:02 -0700 (PDT)
Received: from [10.217.222.146] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c9e8eb10645sm6364018a12.4.2026.07.06.05.01.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jul 2026 05:02:01 -0700 (PDT)
Message-ID: <4a2a6773-75e0-49b1-8e47-a9094d84f5ce@oss.qualcomm.com>
Date: Mon, 6 Jul 2026 17:31:54 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] dt-bindings: crypto: qcom,inline-crypto-engine:
 Document Maili ICE
To: Jingyi Wang <jingyi.wang@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>
Cc: aiqun.yu@oss.qualcomm.com, tingwei.zhang@oss.qualcomm.com,
        trilok.soni@oss.qualcomm.com, yijie.yang@oss.qualcomm.com,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260628-maili-crypto-v2-0-f8ce760f71d6@oss.qualcomm.com>
 <20260628-maili-crypto-v2-2-f8ce760f71d6@oss.qualcomm.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20260628-maili-crypto-v2-2-f8ce760f71d6@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA2MDEyMSBTYWx0ZWRfX7GNFdmZIVkYu
 KQ4fR8SOoe5RaoZMCR7BTBm3zYZB/rNR5SkGuBeThoH55ULKJov8yI3Ih/C+joe2/C22ZN29iND
 LBxhLeDhlz3EMGtXoxSuJClAin3dZI4=
X-Proofpoint-GUID: qde0u29u-EZGz1j4rk_YgKHzs0Rj7QgC
X-Authority-Analysis: v=2.4 cv=C6zZDwP+ c=1 sm=1 tr=0 ts=6a4b993c cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=2m2jUygTAEm4Nlw8oZsA:9 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-ORIG-GUID: qde0u29u-EZGz1j4rk_YgKHzs0Rj7QgC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA2MDEyMSBTYWx0ZWRfX9fgQ/jVxkwRb
 xlbZ3z1pD/Wz7bmJ4IYhhWyHbDIuqYaTUkhu3JVtAXUrjJSRuu08qWqB3QHBCg8wO0va/xdZ/Mw
 ICfgd8vS2DHRt66csPNZK6aRqUaf9dggDzYnhRgDgjPGA75VU6DQpEf0mZ7pmquHxsXuKY10mk0
 m1wR7l6m70gdq56q+NG8B91xmdWwKOGMd64g7IOsDeBCFEiUiCW/dXyqdqW8tKjpn5FR6wmN+dr
 4Tjzvb4amkfEveLNmoo62ZQSZVWqBtXQ/6xikDL+Byoict76947qj9iolMtOd+oKvpuKA+ghVDA
 hRhog622H8AMwPzYMXYIsVsNBXJIyVR4eX88F/Z1p2eh9JdhqeRj5q4HchDRvktWTP4DLA8SveG
 smbjVS6ZsQ6NsCLW8gVOVgpjFutwM2QlRCZNGpRkP3Bhyqlz+D/Sdoyy3SEgGlW6JlbKvqyqM/D
 29HUz97xTaqoidR02/A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-06_01,2026-07-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 clxscore=1015 spamscore=0 adultscore=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607060121

On 29-06-2026 12:14, Jingyi Wang wrote:
> The Inline Crypto Engine found on Maili SoC is compatible with the common
> baseline IP 'qcom,inline-crypto-engine' and requires the UFS_PHY_GDSC
> power-domain and iface clock. Hence, document the compatible as such.
> 
> Signed-off-by: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
> ---
>  Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> index db895c50e2d2..d80f8445393b 100644
> --- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> +++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> @@ -16,6 +16,7 @@ properties:
>            - qcom,eliza-inline-crypto-engine
>            - qcom,hawi-inline-crypto-engine
>            - qcom,kaanapali-inline-crypto-engine
> +          - qcom,maili-inline-crypto-engine
>            - qcom,milos-inline-crypto-engine
>            - qcom,qcs8300-inline-crypto-engine
>            - qcom,sa8775p-inline-crypto-engine
> @@ -62,6 +63,7 @@ allOf:
>            contains:
>              enum:
>                - qcom,eliza-inline-crypto-engine
> +              - qcom,maili-inline-crypto-engine

With below patch, maili and hawi addition can be dropped in the list.
https://lore.kernel.org/lkml/20260706-b4-shikra_crypto_changse-v3-1-23b4c2054227@oss.qualcomm.com/

-- 
Regards
Kuldeep

