Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73FA23AB285
	for <linux-crypto@vger.kernel.org>; Mon, 15 Jun 2026 06:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781503939; cv=none; b=PlAzz7uVi44E2w3vKQjzo9ndRrVLh22R0ld1R1pBzcY/I4AXfL95M6kmg/SNhcYiOEvIOeCQWgV39m2zl4WA8TkB2bBlHHw9YpcmGmRvMw+f49qEQMjcKELUX6paWOsXx8ZwJ6PShfbSmNGLib9yhAinIGtV9XrCzcuv1l6YQc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781503939; c=relaxed/simple;
	bh=tSmedz+Oh3jsgXRS7vmeVV/V32mqeZtZmMWPq9oxuyM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ojCVbDmpD+mHzfuMi+6jm4sL0cU08XsZX/5bXDEHvNOGdbt9KzV76HMvTcsOJMTF0MStrGUgxy7oIgoC0ZD54fol/3HyUETu5N6XmA1sg9i09POVvyRBFqKnEePuSQGE54YTY50o/VIPog/Z4qO00fJU6jGFsfKdwYXVdL/thsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=fj/r2Oki; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=FQopCJ6t; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="fj/r2Oki";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="FQopCJ6t"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65F1k3T43286262
	for <linux-crypto@vger.kernel.org>; Mon, 15 Jun 2026 06:12:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	d7gViC5SQ5ULIBq1coSdam39lZ/15XA8vuP7rC+uGlI=; b=fj/r2Okiyd2UR6wZ
	Y1rcqwZr8omOQmyljZnvOAe9QblheLc0csC6sEcR0R55StY4JVtT+4zisDd3eIGP
	TCkwvQaMYXya84TiaIYNR5AJ0HiL2S+mShZ0OXR3XbB3ogncQd7aBJnxcAAGxFAu
	l1aC3+zuWTQy2p9QTCPMzzlq0ZC/zqsdcxrvyqm+YJHIBbcGXm9LC1/3SwUJ9OMR
	oWLZJPvq37v4B26bDAQBkpsq2LOGZ8qyRCZk8/enVWH9Qx9GZw8vAeZZ8Iirl/sY
	fYbbzbr310w59E01f5VV/RKYJD38nRyAEd5CLrB/Hawb6RTnB6xLoamiHrGTjSGY
	Vc41WQ==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ery8wwtks-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 15 Jun 2026 06:12:17 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8421ffff8a3so4040463b3a.2
        for <linux-crypto@vger.kernel.org>; Sun, 14 Jun 2026 23:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781503936; x=1782108736; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d7gViC5SQ5ULIBq1coSdam39lZ/15XA8vuP7rC+uGlI=;
        b=FQopCJ6tw9sJ45cmpjSgiYXxwTTrEAiSP/62knX1LuPnY34S67+Row7biGS6uwrM4r
         kMq9uGk01yLdrrhGNaLTSoBeTueE3veSBJPcgYxWKc0dDxdmFgLIG7NaIbvo1f5JiaR7
         UAh0ilL63jJ028IvtNH2UsH2enJGSejP4UUmAjaZF21A8EsaGUrcSFEpzaICtIpaC8wx
         5R280g2+DTsUu83U2hbyqcXGcaGXVEJHYlwmNbKPmRtqM5YULN8T5+71121RJAIexE1/
         0N7p6UnEIr28h/8E115ZiLdWPjPJc9iD5RcCaS5sAJNgj9WlNU7zR7r90x0fRKiinyLO
         M5cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781503936; x=1782108736;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d7gViC5SQ5ULIBq1coSdam39lZ/15XA8vuP7rC+uGlI=;
        b=qY3t9mDL48fOe72D+tcfU6fvUrJw40gNgXPwI/4US3QLoCb9oRJZdLrCmfh7esD1Vi
         hnNbQbtWIZ5JkCWVLZDVjdYaS5frJ+ueblCcjshYZZeR70aRRkS4KmPTkmx9Kj3tSMUy
         x0EgF7Uh4E5lslDKB6FmGV6nN7k3EqKM9meg7YiWJqkWlOMwlWJICsALw2+J8IOKTviC
         q1zpw7mbYmkYCKUVoQn/pZAulhHPwZkY+qMzcFUBFJwxcIf2bOvv2TN//MxhzphGzL/3
         LFiEZ/QoYWhJ6peKSaOWdH+V3F/ExNmDmsZofbKFgO8G1MStJhizzO2fagCvbCffRKdH
         z4ow==
X-Forwarded-Encrypted: i=1; AFNElJ85uwKeNyts0u+WidbEHQf3pPXbnHOqCi/2IBzwt+2ih85dH1MHLmwu8+wZrxsZKOAJezJywqpOHbb96Jc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdApLJWqqi3MrcNEw8tzx9n3xE6BeyLsxfbFhNNP+cwIio70zg
	WwUYb2eJlm5c2qU/laAuSGsdFDYsET4Ekf7EsmFQwyhUGo0I0QNCjyeH7KcULITkF0VlSQNm4Lk
	VkzA8Gxlxe0WWiy0xyTC9fyfAEUKJWeze9Jl2DGLDhdH5DlR5CdoSMFV2Q6c8qvNTTfQ=
X-Gm-Gg: Acq92OGQRxIV47XEgsfyKswlE3iGeBLyvDxdgRDuo2JfLOz6Jydq1kJsTZlsKJZle9Z
	Fzj47iqj+NFjwYhPMZGeLkBqsEGJdw+dhgq5t5kC00j//480t0G1F232981y2XPamU/tSfPsWeJ
	YmxWLxGhxfQELYDkXMOyK41EYLxv3AwseIKr/vwhXCyPpYpbHunWthL4rzlSlngdfel02LnjyRp
	BXEWhn1jaNCCQO3Vz/dhgcc7LiNMUHsoqVKvfdsCqAZQz8o+0X6ollIKUx1XdFbTZo94qDGr11W
	kP5LHIbhu419sG+FJDx3hTzGFtIvRvndMLRSp1BLymkVle3+ykg8tAQcE+X+Gc/QX+mDqdJwZrR
	L59HmViXpu8ICIM7XcuH91rgng0U0wAHSLzm4TjTS2Cg1IqQot6E3Ito1K/x8PthworOKGHzcN6
	b3YYnTNSKE5pYKY4M=
X-Received: by 2002:a05:6a00:b43:b0:83e:e897:a394 with SMTP id d2e1a72fcca58-8434cc16b90mr14124645b3a.7.1781503936450;
        Sun, 14 Jun 2026 23:12:16 -0700 (PDT)
X-Received: by 2002:a05:6a00:b43:b0:83e:e897:a394 with SMTP id d2e1a72fcca58-8434cc16b90mr14124600b3a.7.1781503936008;
        Sun, 14 Jun 2026 23:12:16 -0700 (PDT)
Received: from [10.133.33.21] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434a934a97sm9132161b3a.0.2026.06.14.23.12.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Jun 2026 23:12:15 -0700 (PDT)
Message-ID: <06529f97-1b41-4fb4-8953-8496a3663ce3@oss.qualcomm.com>
Date: Mon, 15 Jun 2026 14:12:10 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] dt-bindings: crypto: qcom,inline-crypto-engine:
 Document Maili ICE
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>, aiqun.yu@oss.qualcomm.com,
        tingwei.zhang@oss.qualcomm.com, trilok.soni@oss.qualcomm.com,
        yijie.yang@oss.qualcomm.com, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260609-maili-crypto-v1-0-0f577df56a61@oss.qualcomm.com>
 <20260609-maili-crypto-v1-2-0f577df56a61@oss.qualcomm.com>
 <20260610-mighty-dalmatian-of-piety-2fa184@quoll>
Content-Language: en-US
From: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
In-Reply-To: <20260610-mighty-dalmatian-of-piety-2fa184@quoll>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: iw9xpiz9xWpa1UrfJuZuUefR9X_EaKSd
X-Proofpoint-GUID: iw9xpiz9xWpa1UrfJuZuUefR9X_EaKSd
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE1MDA2MSBTYWx0ZWRfX/RNxQtzTiZja
 RLgd/Ace9k3FKtE7J91E3EQWhlBMjKRPObqkaQ2NZfS81KfbD8r7b9DjS8iX6SGsX0uLUSCnty2
 ql4KBnlw5gmFlkNixJSOAXKOtzQM4n0=
X-Authority-Analysis: v=2.4 cv=IqAutr/g c=1 sm=1 tr=0 ts=6a2f97c1 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=1TaJruIST0psWsyvLVoA:9 a=QEXdDO2ut3YA:10
 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE1MDA2MSBTYWx0ZWRfX/+gDsDWyUwjs
 OSVAnvHdTRfY5gINKYNYzJVPfVdeb0J+gdVKbEOylHCJkb+qpj2cqLHUHwltSLglSH8WsJ8ZYjq
 ym3NOqI2BiR/0WkwaQAFn5IrNO9XUCa1YxjlWoqxLYwAwajKH/yk0ehEhXaknF8gMWCzxnRV2Pm
 drKvXZK1T43OgLDTWCZo55M69R4lYRuhSu60eh2HNwA3y9m4sBhbd0uiqu+Wyam8DXVmQQd5I/e
 gly58YYJ5U9QVW4ShZ/ultymaJSEPP1YPFhCektZJy1P5CmyyyEDubtrbu84uQpvIg8+EkUrKs0
 CLegj7IQ9bq2sSQ9W0Hkpm+wn+Zxq7HmgRBoxFUqo0sjxLXn6chzKx2jCPqHPgPFSPHbNKkXGzS
 HgQOI7S7CEtZ6QNtqlb4wyMW6Pp2upzz4UE4b0LRM11h3QPaGa7tj2RDVcmSwl6ept5w1xqx0bI
 wGnQsa9bQirREYvhZow==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-15_01,2026-06-12_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 priorityscore=1501 malwarescore=0 phishscore=0
 adultscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606150061



On 6/10/2026 4:55 PM, Krzysztof Kozlowski wrote:
> On Tue, Jun 09, 2026 at 02:08:57AM -0700, Jingyi Wang wrote:
>> The Inline Crypto Engine found on Maili SoC is compatible with the common
>> baseline IP 'qcom,inline-crypto-engine'. Hence, document the compatible as
>> such.
>>
>> Signed-off-by: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
>> ---
>>   Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
>> index db895c50e2d2..c9489f6b8081 100644
>> --- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
>> +++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
>> @@ -16,6 +16,7 @@ properties:
>>             - qcom,eliza-inline-crypto-engine
>>             - qcom,hawi-inline-crypto-engine
>>             - qcom,kaanapali-inline-crypto-engine
>> +          - qcom,maili-inline-crypto-engine
> 
> Why clocks are flexible?

I have just noticed that this patch has been merged:
https://lore.kernel.org/all/20260416-qcom_ice_power_and_clk_vote-v5-1-5ccf5d7e2846@oss.qualcomm.com/

Will add qcom,maili-inline-crypto-engine to the eliza/milos list in next version.
( Maybe hawi should also be added together? )

Thanks,
Jingyi

> 
> Best regards,
> Krzysztof
> 

