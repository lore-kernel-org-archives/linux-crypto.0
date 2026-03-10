Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D31396B83
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 14:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773152037; cv=none; b=a+GQjtJ3KnkA3O8G/n0Tgz8ttVMxQ4X67QOS5c3+fByn6p1T33+pr5yYh8PvzC1xFM0cen+uxPwq3BnJ2/P4CxrQxJxwQlNVtmabN7kMXB8gWtonw1mEq5o+T4mVEJyejkfv7LE/zRcseHSPVXHZ88vCm6ZfZ986cQ3dI0dzkVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773152037; c=relaxed/simple;
	bh=TgyjPvdRcam0qo8VsSYVIapChIfqCnvkFJzQeUg7kf0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p/7qpN6Y4ATyprTliv5+bC4DemJphIfKS/M0uDayhS6tSUwn8Mg1CrUem7xhguU/U2rP4fSTpVV5BoVNRN8if+L4km64hulx7uIuW6XcTrMUPdlpv81Cewm5hoKiKEkR/ExU/3mX5fwHsvKCezj/eFi4tN9R9I0NTQiLLVFz/4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=AV/e0rwm; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=LPKahM39; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="AV/e0rwm";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="LPKahM39"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62ACaVux963384
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 14:13:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Sa+gULIzj+R2VtMLbbQ8yLiDMiRWe09PKwmLNCGVTQs=; b=AV/e0rwmZSB3iqAR
	IfFGhVgsnZmsZK5nYHmca/HF6ZW8kMEnIgvLePHBd7XnoA8nKYmZGQU2edBK6oHJ
	a1nbytXTBaI9zlrZc/dtrAqSWc6Yw6GauTn1ziUfJw+ciNMaiU7TFsfe7CSCzzaI
	Fcl3Xstxstn3NKblz4ZYMmFoaAVaId0E/nhiT8nhojHcxp6BQTgXnnnKXak5nIyz
	ZvSVGb6tTNPY3uYqxIZG9hmHKIuX6TjO2PqjOFt9E0ATX5ZXCxhFjPecLrkgkWk2
	Xlxh2CCK2IlehMYAA1AciToYNEA1J9xmalZOm7TWm9DH8gRmQlWYIR5wTe8DYcb5
	xMdyNQ==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ct477khrp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 14:13:55 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8cb456d53a5so51077185a.2
        for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 07:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773152035; x=1773756835; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Sa+gULIzj+R2VtMLbbQ8yLiDMiRWe09PKwmLNCGVTQs=;
        b=LPKahM39lgzYLdE90SbBFizZAKPsimZrJieBl6MDtpCwZbK6pBayaRfFcyizhB6FWs
         btobqroS4P9UlXup8M+igZPmOnIzLE0SyYw5iTfDDJMHaBHrNiQeLN68x1KVzCFW9HxU
         SzfPWGf5tDliXFlXqordcEH1ik/v/7rl9CdGWcxT6gYNvvyYfv1VOIMw2KVrgtkwFXam
         ckvk6LdvhisAysWTHN7U7e5pTlFJjaFtnzS2BYuAVyFpnKxvDG34UldMNpg4cjhsxSj8
         vX28nvxp8b5xfrdXcMdKvm36UtIz4YhEQRWBmY0W1KT8180jUmbnkm9SBn/rcOxGsAvy
         phvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773152035; x=1773756835;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sa+gULIzj+R2VtMLbbQ8yLiDMiRWe09PKwmLNCGVTQs=;
        b=D3Yv4gnPlx8LHk5oJ+/HqWqJF/WhDWpIE0Vuu/XjZFI81hBqtScn1lIhmvJ0LedU8l
         VUiFZ/pDbvPhVQR3be5RySc/Bc2N1FFEQL0F8xVsipYmkHd/wYYomM4T857ai+VcXnKy
         TDzFG0oBFqMqRR5hq1mgZI4fYu6aAI8JqlNbx+ZQbAnBV48qXmCYuAXcJKuLhTAhUt0a
         vbw4cpG4Nm4C3h/6ljLivGeI5/a5+YvuFlKMowgm226pGJIPlR2kcVqASk430ERuQYTt
         rn6iaYLioqkqldk1A8ouqagKWGgDGPFPNCpIn5s9zzCrFsYP0+18TOVeSXghIsdZx41u
         X79g==
X-Forwarded-Encrypted: i=1; AJvYcCW7eoW15hyaUSKqI7g5Sm8ZhbNL8Eh6k2OG2MRSe+ZVPHLPbRXXsWK2xe0od0xOgN/dAxM1JSdmuzqHcWc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhYHW9K4kb07QYkpExy53f2iB10Tq+LNef/nJwhbFdNJGXA+rI
	KUIr2x/3M3Un9QkcYXd0XMVcy6g78SBti74f2uZyFe08vLi0+QwwdRoXuDDi6nwNDDw/ho3Lr9V
	u3NZxJjN4AvPwnAb3wSNYbER/19NJLyPnQsK45F1SXHIs8tog4CSM784gOSntiB4Hmck=
X-Gm-Gg: ATEYQzxFiBXIuZ9GSSayfOeGsRd6B165gxMr2jRo9lNhYOxeHl+ZMlAc7QkMtbquJzC
	hraFhRW9sK/fs/tiOT6uF7QIQPbvzfkReOiqpZ15JWLLzneUBooaeAD0X3IJ+mW/CpLDPy3A01E
	iVZsR4TMmk4fOFVOAr7HIoPuU/JiRuwx+cuDVq5kdM8KobwI/y64h+73klLgVy6KFs8H8NrB2zG
	sWbkIxSUapgO5Nt7UMhEMyfdYzzy4xoPGSBbLGUWccZ8mvzrBwh2IGXhjNUN+343CiLeJChDuH9
	jn6atb9anFMnGDGeeOLH5iNqYOYebNgf1ZIg7FrXb1mhAwdC7rB0KYlaIO/+Miuz6WZtS/E5Vw/
	8MnE3YlTodcAlPkmD+l4KdAIJwdatXYbaqfArbKl/u2y5D2SsQHjhxPRe/BpjzI3eUXl4x/vMva
	KwmYQ=
X-Received: by 2002:a05:620a:45a0:b0:8cd:8d50:16a0 with SMTP id af79cd13be357-8cd8d501f65mr624306285a.3.1773152034666;
        Tue, 10 Mar 2026 07:13:54 -0700 (PDT)
X-Received: by 2002:a05:620a:45a0:b0:8cd:8d50:16a0 with SMTP id af79cd13be357-8cd8d501f65mr624300385a.3.1773152034121;
        Tue, 10 Mar 2026 07:13:54 -0700 (PDT)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-661a4fd67f1sm4239660a12.22.2026.03.10.07.13.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2026 07:13:53 -0700 (PDT)
Message-ID: <a92cbf85-5937-4aef-985e-a5d12031d4e0@oss.qualcomm.com>
Date: Tue, 10 Mar 2026 15:13:49 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/11] dt-bindings: crypto: qcom,ice: Allow
 power-domain and iface clk
To: Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
        cros-qcom-dts-watchers@chromium.org,
        Eric Biggers <ebiggers@google.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        Jingyi Wang <jingyi.wang@oss.qualcomm.com>,
        Tengfei Fan <tengfei.fan@oss.qualcomm.com>,
        Bartosz Golaszewski <brgl@kernel.org>,
        Yuvaraj Ranganathan <quic_yrangana@quicinc.com>,
        David Wronek <davidwronek@gmail.com>,
        Luca Weiss <luca.weiss@fairphone.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Melody Olvera <quic_molvera@quicinc.com>
Cc: Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>
References: <20260310-qcom_ice_power_and_clk_vote-v2-0-b9c2a5471d9e@oss.qualcomm.com>
 <20260310-qcom_ice_power_and_clk_vote-v2-1-b9c2a5471d9e@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260310-qcom_ice_power_and_clk_vote-v2-1-b9c2a5471d9e@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDEyNCBTYWx0ZWRfXxT5IXl6g1EaC
 5SiYvdJNGay6EjU0aI0w3au3havqO2iBSYZZ/gKKnPOERzKFSntZ/iFB6rFLxh2d3cRVBhOWXCB
 B+5HBNBzi42IAR9MS6Hf000HarzUBNWibBT/+a31ccc9EAnpWbgCoRYfKDSa10sFF53xVyRB5GB
 BGH4GuK/NO/tTWebIf1vGfHDAXenCSWReQev969ErVY6XTmi23VmaE9E8glg968raaFLF7KSVDP
 56YR1L4jmQMP2dQmWQgy0JI2PuTaWvQH0gouJFtCsUMeRF1dtLqWnYmAF0Hd7jGMbFfNleb52Du
 8DhEY0qmsf2P6hO1NpV5R4DQ/H+GbHa+vIc+lBKF46BLRWFOK7olnP0hVf0aNc9M2tQXdeeXYJq
 ntdTYAuTwbXm/8NGTLyakkhMsRXzWu5w7bZVsh7fcPSlPELEfNlp54yS29A5RARsWkFz5aNOEGP
 ZWOhiRT70ZLQX6c4pTw==
X-Proofpoint-GUID: KMgf1pWXcAO01edVuoLfxjQF6oM0-YlL
X-Authority-Analysis: v=2.4 cv=KLxXzVFo c=1 sm=1 tr=0 ts=69b02723 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=T5VBltHwqSPm6ePZaXsA:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-ORIG-GUID: KMgf1pWXcAO01edVuoLfxjQF6oM0-YlL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_02,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 bulkscore=0 impostorscore=0 spamscore=0
 phishscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100124

On 3/10/26 9:06 AM, Harshal Dev wrote:
> Update the inline-crypto engine DT binding to allow specifying up to two
> clocks along with their names and associated power-domain. When the
> 'clk_ignore_unused' flag is not passed on the kernel command line
> occasional unclocked ICE hardware register access are observed during ICE
> driver probe based on the relative timing between the probe and the kernel
> disabling the unused clocks. On the other hand, when the 'pd_ignore_unused'
> flag is not passed on the command line, clock 'stuck' issues are
> observed if the power-domain required by ICE hardware is unused and thus
> disabled before ICE probe. To avoid these scenarios, the 'iface' clock and
> the associated power-domain should be specified in the ICE device tree node
> and the 'iface' clock should be voted on by the ICE driver during probe.
> 
> Fixes: f6ff91a47ac57 ("dt-bindings: crypto: Add Qualcomm Inline Crypto Engine")
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
> ---
>  .../bindings/crypto/qcom,inline-crypto-engine.yaml       | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> index c3408dcf5d20..d9a0a8adf645 100644
> --- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> +++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> @@ -28,6 +28,16 @@ properties:
>      maxItems: 1
>  
>    clocks:
> +    minItems: 1
> +    maxItems: 2
> +
> +  clock-names:
> +    minItems: 1
> +    items:
> +      - const: ice_core_clk
> +      - const: iface_clk

Trim the "_clk", we know they're clocks, because they come under.. you
know.. the 'clocks' property! :D

Konrad
