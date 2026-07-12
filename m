Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53528365A0B
	for <linux-crypto@vger.kernel.org>; Sun, 12 Jul 2026 18:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783879658; cv=none; b=UaJ3q8XSwMN2Azn1UCGLCXttWJJsmDdywguPqaluNYd3ITv3M8uwfV0bg6bkeXpry6/OjfFN4+HxXArpLbk8pH4KuGiaVKVnRaI3XttyEyIHLM7wAyqMgLnkpaRl9C/WRfewVszRxt8Ev7oV6K7hLkEeOwFYJVqD5zMixHbiypA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783879658; c=relaxed/simple;
	bh=C2XR1xDRNiX21r/FCy3HxMDWvtan9TeVXkb/Shhz/BM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=glt+7dn1Ed5oG+77iJd3UmPvrUt2S0Z24G0Yb9InRysRs2+19TkoOfmHiGXav+kbjbwca4U+JvWziZYMKaTz+r+cEWsuYSnPkyt8ZWg0AzOINHLa1aEOM9fsJ2silc8ZMDGizsAnne7OSCGW5pQmOFV8+a0uTVOp5OSDPX6Ikgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Os1X52Gv; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=SJwrTbjX; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Os1X52Gv";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="SJwrTbjX"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66CGrXUA3139328
	for <linux-crypto@vger.kernel.org>; Sun, 12 Jul 2026 18:07:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	G/b/zf7UQ7sTa2shIGd1d0rcQISGwGw1nhvIskhwF5o=; b=Os1X52GvT5VrnrF6
	1dd56lRQyKEyZVybVYvjJiI91y80kFH2FqmQnPjdwmJXuKh1OYXz+aQiCf/oxUe+
	v6IeTCoDqG6s1RXqBSfDA7SPfC2I5iW6Upgz7vSklr0qa1yB8K+ivrvFVvePh4FY
	e20RIzla1VxJJ8H4BEIGBBumUXPVzyrxtToirWXCcCnu5lu7e5fv+1tg3Q70WNUc
	ucHTqiO4Gp+mZqkM2IX/45FYO/JhkNEMZgHTXJZgRZXX6jhBKZXW5eESa0G59iVV
	mIAOwDg632naAM+uQ7Vv5bgZvwSAipCB2LTdVek5jN/vV/aQRDqpvbodk1uSoXKp
	d3aEjA==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fbebr36kw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Sun, 12 Jul 2026 18:07:36 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38dc8d877eeso1906858a91.1
        for <linux-crypto@vger.kernel.org>; Sun, 12 Jul 2026 11:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783879656; x=1784484456; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G/b/zf7UQ7sTa2shIGd1d0rcQISGwGw1nhvIskhwF5o=;
        b=SJwrTbjXDbf4xE6u1JFdwkpxfS/i+X/0v5hnB+Bjm5IcSV5mq2mqBBGHZ7teJZ3v4+
         5AzIzJygAXTs19ySpQQUbb9TcsZeeWWabb5iBGoSUN/bw8svcoTjzzpYXfhdfhrCDO8H
         Buq5weJvoeMR+JqsQrBQ8MFS00SPpJbeYGt2rTeDJL/JSA52/oAR8WmcGZJ1qSBoEd3t
         cDkVRLBj7Bj1g4i1TPAEmpQauXhObsmOw7oGoN7M+2VB9nV//DotHe49QXz83DSh40xL
         jw6hfEOK2+WtNV6G6PqFpBjsJgCGnCtcX5KjpN7VVObJjjq5CqhO21xR1CYOOBOBRnRd
         NSHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783879656; x=1784484456;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G/b/zf7UQ7sTa2shIGd1d0rcQISGwGw1nhvIskhwF5o=;
        b=pI9LP/eVdOIOKb+W3h3870iF+b2iHIzM1UiK1o3ztn87BRphCQt+Pk3dNF1RjNdk/p
         rpNiYHFi2NnMko4+5X67xWLJlNthfMjSQR0rGXLE7nhT9Gbu0terNSiij4brlOjKgIrC
         +BL0XwM2h+kNKt2Vb8nonvAPt+AsHtmhxdDpShY1DdEVjkmvSZB6apFHWAvDVoGLS0YN
         oMJCy9bKCIUwgnW4yAy5Snzur/3utWvBPiYURcARDLg4YT/EuU+p4VxT1jxmzoVNCN2J
         yzZvKzm/ZbjJ8lo9OU+K9iOjthJlA2TJQ1YtqFP4BKNxfleSCaUhcu72JCoMqYSTk3pM
         Yu3w==
X-Forwarded-Encrypted: i=1; AHgh+RqfUgx+8M947x8YJzpeygwbMHoVMge5rFfsyMTcuYZ2TlBPEPZtOkUg+6ra9KWw31HEn67ZlkreLdQ8Glk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2V8aBq2wNo/aeO0+3rDuwETEzdVhWQOj/Xn6RZZOmVwW80Zsn
	D6ELXfapBUBDuPGrx1ducOCVRaOn9kI+HBEV+yeUx+V0K51vYhompeB7K6Wzpjz+fPycK4sWbdB
	s3qbG8IhT2rq4+ucR/MgitwQNIgtz7xG35xxxtZJUwNZu6i7k791XxQYbCHuYwCMhLgo=
X-Gm-Gg: AfdE7cl/AXjL7hloPu5m56OjB6d0yVgmnVpVOYLunSKqUuivPChqjZYd+WKU9a8ilKu
	fx0yFvMoIjo1LeBnq2oBjE8xw7CL7Ocu/jdeg6Db3aXn7TcjwC80yvnteT0V9yZNdsUgWVf6BQ3
	zRlj9eg9iooJikXzNH7perQ5Zba4ZoHLe7xCqtCSDx2jKbi+Qd0yHcs7qlqF91nFCUfnfWZtjxM
	2EEAq2yFwhBjjcKmhBC2VpHJXeGsZEVYPyb7Bl6p/0LcfbW6PbCwcFKBNpb5jThHHQQPTQv7dHg
	Tw1AiAHyKInr+MKZVEwrw1VibF7SdSY/z2QZilSHR/xO4X2Rjc3U3giPERCtuzfFrThDnggIk0D
	/y0SJdM6sVDWVdKFCShUpUp82dY/a4xNLWRM+yNnnyQ==
X-Received: by 2002:a17:90b:1dcb:b0:387:e0cb:7f5 with SMTP id 98e67ed59e1d1-38dc784208fmr6721477a91.41.1783879655931;
        Sun, 12 Jul 2026 11:07:35 -0700 (PDT)
X-Received: by 2002:a17:90b:1dcb:b0:387:e0cb:7f5 with SMTP id 98e67ed59e1d1-38dc784208fmr6721442a91.41.1783879655488;
        Sun, 12 Jul 2026 11:07:35 -0700 (PDT)
Received: from [192.168.1.11] ([171.61.104.87])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-313b4b97661sm28896575eec.7.2026.07.12.11.07.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jul 2026 11:07:34 -0700 (PDT)
Message-ID: <d9b63658-b588-4103-a247-cdd78910a89c@oss.qualcomm.com>
Date: Sun, 12 Jul 2026 23:37:25 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/6] dt-bindings: crypto: qcom,inline-crypto-engine:
 Fix legacy/new SoC strictness split
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Vinod Koul <vkoul@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>,
        Konrad Dybcio
 <konradybcio@kernel.org>,
        Frank Li <Frank.Li@kernel.org>, Andy Gross <agross@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
References: <20260706-b4-shikra_crypto_changse-v3-0-23b4c2054227@oss.qualcomm.com>
 <20260706-b4-shikra_crypto_changse-v3-1-23b4c2054227@oss.qualcomm.com>
 <20260708-splendid-outrageous-saluki-aa52f5@quoll>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20260708-splendid-outrageous-saluki-aa52f5@quoll>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEyMDE5NCBTYWx0ZWRfX8bBeKJnG/mF1
 eGhqeMXRMD88fEq8Hvom4PWADIn3E0fXr50zEb3rl6JbaEnHGP0eTK+vSQVP5WNZktDTZYvFVxB
 YgzOpuD54rXidMEFNAgNR2KVdl2J5Fc=
X-Authority-Analysis: v=2.4 cv=OK8XGyaB c=1 sm=1 tr=0 ts=6a53d7e8 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=6xD26CRXxLrCpw/8GpIQFg==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=rLjcKV0j-uWbYnTTcGEA:9 a=QEXdDO2ut3YA:10 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-GUID: thH0SlzH71rd_LEP7A32iLu5PVqQXkpi
X-Proofpoint-ORIG-GUID: thH0SlzH71rd_LEP7A32iLu5PVqQXkpi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEyMDE5NCBTYWx0ZWRfX/x0MkmE9Aqap
 PR5zRZ0c2sKulpgpoNmFZ1HRQa8JI6q5YSdnSmL3MA7SKPgYbgLtB8ZRzNqZZ62POlJ5IlCkaZu
 My0wKFFYL1euBw8ajSMJXaihf2P48h6YZZbgswRZjx+W/6si6X2+xrk06ZZBBcHBa3iisZFa9/a
 l6ipA3Ee+DLH9tncnI1W/flE0ZRuITgke/5Xrj7iBfQtA1NSTo1dhFtJaXkYn8yVFMZlMiPDuNO
 naJ+2R1AvXw9qDhYRHjQdKE+yScMn02baCG3JEi48BL9O9oDqGbwvDlAEkgeb+htobaJ9qObK9A
 GCXKgIcvLK6lG6lDB/yfsXWmLxxZPBbHXSxH8zJacppFY+yvX/r0Hgnw/PTImVpJ9rDo1hsPAzU
 cxp+61tgwT0POE7wV6bVIUPjnmH4W6jpq0YIIvnan0QwFpPT1ZlwUMFbAXElDcHfhzCNqHPaD7U
 gh9ybTtNvxoBxKim2Zw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-12_06,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 phishscore=0 spamscore=0 adultscore=0
 clxscore=1015 impostorscore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607120194

On 08-07-2026 12:13, Krzysztof Kozlowski wrote:
> On Mon, Jul 06, 2026 at 05:01:29PM +0530, Kuldeep Singh wrote:
>> Couple of already merged SoCs(like sc7280, sm8750, kaanapali etc.)
>> describe ICE as single clock historically which are recently updated
>> with mandatory 2 clocks.
>>
>> Keep only the known legacy compatibles flexible, and make strict
>> validation default(of power-domains and 2 clocks) for all other Soc
>> compatibles.
>>
>> This ensures old DTs are valid while ensuring any new SoC (like hawi,
>> milos, eliza) must follow latest requirements by default.
> 
> To re-iterate: You change the ABI for Hawi, this must be expressed and
> explained why.

Ohh I see, hawi is different case(compared to milos/eliza) where
bindings define the compatible but somehow was relaxed(got missed
probably) from 2 clocks recommendation.
Just hawi compatible is defined but no DT entry is present actually.

> I do not see any change in commit msg (listing "new SoC"
> is not what I meant is not relevant here - it even suggests like
> everything is here done without impact).

I'll update hawi as separate case in commit message to reflect properly.

-- 
Regards
Kuldeep

