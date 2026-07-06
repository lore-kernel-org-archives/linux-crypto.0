Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3336438462
	for <linux-crypto@vger.kernel.org>; Mon,  6 Jul 2026 18:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783362370; cv=none; b=mCltyOdUXy41w+xJMls/83Tm1TZxkWwGKwkh8dN3g9DXN/yQdBX/k1f0zDQTCCLErZLnOyKu23bETPdRXBm/XfPz5/y8vnxovDblzoHkS5XA1MfvPCwcomhMbZx92bplD0m1KEa4wPVNisPdFzh2zZ6ETCX+7HqZ4+lpE/iBXpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783362370; c=relaxed/simple;
	bh=a3oNKlr4mhy8oV9tBLz8pFFNqII/cGarZHTS05gJ9ug=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=psCpJJsjuk26GfuIfUgbtUij2ZeiwbRSi8FKG3tJBJDEVcf3Nr4NFtw56o+04zmgxrym0W78AdH+RHpikHMB/2PlZKaN3xjD2LRCcN9bCw8ZME04UN4saBV8kEJNcxDW0rMyzJACqLzmz+2DP4WrLo59nimix7uv4ofwIsI6XgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Nnzd729W; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jsS5pW8h; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Nnzd729W";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jsS5pW8h"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 666FF3CE981458
	for <linux-crypto@vger.kernel.org>; Mon, 6 Jul 2026 18:26:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	55amyOyk3SFaqX4ySIofcBlt5TbW1fvejlu8KZh8qf4=; b=Nnzd729WR/SQpRS6
	bIFy37y9ersudNsomaGBoM8S/fkl4V3+NzMxoecDUDcIwiSrCZaF2osCnVFvisJs
	fIgjO1Vq71sirnrVzszRkYbp7U9om3P/m+ibN4pQC0skeYp9CoZFBF15CKu23mIM
	1nfKuF5XfUG4gRSuEYQOEQFyZmgSvwBPv8r0WziIcqF5D47o70VAV/97ZT8PaW/H
	WWcBP38HIXCsx+LIGBS1QwxzXIjy0KbrgT9m43qrZGy8qQXJzYHUORD8fl1HEpTg
	UHdGMqvYD4XS/rMiZoaVq1V11YD3mER7Zvi+chD8qDmOkD7r/dSwV0sNCFkoVVNG
	eMpR1A==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f89kgtg9p-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 06 Jul 2026 18:26:08 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3855a987c0aso1734472a91.3
        for <linux-crypto@vger.kernel.org>; Mon, 06 Jul 2026 11:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783362367; x=1783967167; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=55amyOyk3SFaqX4ySIofcBlt5TbW1fvejlu8KZh8qf4=;
        b=jsS5pW8hY4V4isAle4M6icCuGE+o8+HYynh7PytM0xajkzOEg76MiwTQibQUZVyUtr
         IGRlNsb79uCxy3S8RFGp3tVWwLvDcowU9ANLSNgo1dmaZCFtKEkXHQENbHUXp5wgvX0U
         0GhY8Z0zBcqIIc2HXAmw2XVg83QHCrP5Nm510t35Qqg8AJA+9WVbuP9HZdN9vXuz8yGc
         gIYuWr+sNJfFFzljNpm++B/lOhFRrZylacoXqRMkUfKvY4B3mHDsum5ZlZ/inrqLDTEp
         RebJqvIx4QOr0U8KcmQtPlratP7FfKr0RA/vUYAzMfQi78NcrLPaf/yZghd+UWMkeTX5
         vC3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783362367; x=1783967167;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=55amyOyk3SFaqX4ySIofcBlt5TbW1fvejlu8KZh8qf4=;
        b=ZBomnwgNwCj0WoMC7fzHfOt5otSV2U/7TPLpGRlzTBlhA60GV5GuQaQmOCZtZNsFIT
         pwlgX/pSrkNC2Q5eW7MXVDdRlL7tw3FChfR7zNVVRJbQRQQXxbrTNNwdMpyDEW1ukMfd
         fslETlcijxNRh9eDpCVz9fL2TFE/fPSYTX6T9+dVK/tfvv8lrdf53x33Lc99d6Frjm+V
         kIzTlYQig5DGoOO8GTnHIjBervx3piQGCECnDo2A05f7DMoaCMD8CfCloWJfGlhu0NyD
         wg3PPDn3MTAhzbTHiREl0AUyGKn8eXbdWZyrvqVKDj/NdwTj2w5RdvDgNhiKqh/r13TL
         zrmg==
X-Forwarded-Encrypted: i=1; AHgh+RoblvgUmKr/BRCD+F2axNkdKrqhYolUmcPi6asA36elCWzTn2G3byX65Rz55ldyUFTatMRAzkiOdqTAmsk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/yg9VXyAqzUq3bkIh5VQ7d1AhR3wn5pWmJ0owiWzTMQyOhjVa
	GzgsvY3A6zRp3OKR2sQMpboJfmcem9RL9KR8AwbsEsrWx87XEiM5/OSTjIJplXG4MoRVqgBC4pU
	wucQn3CZTk5YtZ+maQRb9pgqkz6n4hC7CYlY7/iHBG4juiHFGPhyDlyKTOmvtbeA4m4U=
X-Gm-Gg: AfdE7ck4b4G5nVvSc2LLh/yy6OyZEDFraL+lO6UkibI+ZPq2L91NDSUZ/FukQPr+OxH
	Q7BqpfsYIxdy2mPpD0TU3cc53R7Ro+e67T07PaqUyU51+rpjjp62u4PzHZQdqVQ5jT8GDVJ8sD1
	K/f57ISzMPKQk0R0wgvbWYekgee78twHzcWu/1FLpATfKqyY5IrXlef0mM6BxN45NqvJv1rbgL7
	heR0RCavh1YP0uz/Vr8/vS5JMTt317PoczompLPlAFhyEftav2rxO47cVfst5CNEXNf0hPoLQmG
	KbYwYtAh8xFnqJDcisryki1UPKYDDy0v0t+ZE5yKMJPD2HcPbAXyuLbbWfYQhcHBmrYNYL8wxwq
	jkyAP5fQsiY1E6Bnqj8qDJzi0lFiNYoezq0ib0X5b2Wg=
X-Received: by 2002:a17:90b:1d52:b0:37f:d9dc:557 with SMTP id 98e67ed59e1d1-38756ce150bmr1900102a91.16.1783362367366;
        Mon, 06 Jul 2026 11:26:07 -0700 (PDT)
X-Received: by 2002:a17:90b:1d52:b0:37f:d9dc:557 with SMTP id 98e67ed59e1d1-38756ce150bmr1900057a91.16.1783362366914;
        Mon, 06 Jul 2026 11:26:06 -0700 (PDT)
Received: from [192.168.1.10] ([182.65.247.208])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30f1595e912sm63180552eec.31.2026.07.06.11.26.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jul 2026 11:26:06 -0700 (PDT)
Message-ID: <3857112f-3f5a-4116-a999-eeaffd59ec94@oss.qualcomm.com>
Date: Mon, 6 Jul 2026 23:55:59 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND] dt-bindings: crypto: qcom,inline-crypto-engine:
 Document Nord ICE
To: Krzysztof Kozlowski <krzk@kernel.org>,
        Bartosz Golaszewski <brgl@kernel.org>
Cc: Shawn Guo <shengchao.guo@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <lumag@kernel.org>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Jingyi Wang <jingyi.wang@oss.qualcomm.com>
References: <20260704004408.2303468-1-shengchao.guo@oss.qualcomm.com>
 <b693a9d2-4f1d-4c17-8a63-99c7ac79ed41@oss.qualcomm.com>
 <20260706-busy-grumpy-limpet-c59789@quoll>
 <CAMRc=Mcg-6XajFJCjTDgGACQ7YLGggw5TEtHv4QMEA=dFLOhTg@mail.gmail.com>
 <549ff994-6b6d-49c3-a764-4c1e134a4a14@kernel.org>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <549ff994-6b6d-49c3-a764-4c1e134a4a14@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: 8OtgDtBSzlgQuVCOIPDyTETnWAGTEgVd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA2MDE4NSBTYWx0ZWRfX/gSQE253JUSd
 BuysiigJD0emCCJI+fmmT54m04ewVxXLPd3AAFyqBYBSXuU57kD30IY3kIKZL5LKXBkNsivTOiS
 nDGWDQtnF8zgEKBiUp1V1+C4WlEDzjEkOhkQepX+c3ldAMUCGsW2Uw1WmAzdoYt4UmrQVmOUlkk
 H6FEqmi02XK6G9UKW1RgXIVPD/uQ3yJNqyCKgI0cv5QpVUmOs0T0KxRde2xsyhg+fOVrX80vAOW
 Kbuve8P6dRN61Kn9Acd0ZswKgduhjWOK3cd4xxKVo5Q0pDqjSIUvDHaLPdt3CgozbioXG/y6ntF
 fUjOtn7C9V30NatvcGeaRhYYQKSL90HPiBXj1sjyY1R0cCHo1a+TqugXdp/0pnribi4JdgEF+9X
 xXRjjgv4BREgmDIUaZarKnZgkuHpJFIlFVxQoY2tBkiQ6S6uOY9RXp9e2w+4o0Twdas6mCocsyn
 bNXBq8zDgqSqxdKtMPQ==
X-Proofpoint-ORIG-GUID: 8OtgDtBSzlgQuVCOIPDyTETnWAGTEgVd
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA2MDE4NSBTYWx0ZWRfX9SgSP2D/Qk56
 KHAb5tYNlaF+ppoPk2iJvApSgKodEZeddrZztPA2WHqWfJHtF64VQjIOC3b4qAOOy+jNULD2pqW
 ODHQnrqfE+uHhcKPOJGj7aiqBhlKK+E=
X-Authority-Analysis: v=2.4 cv=c6Sbhx9l c=1 sm=1 tr=0 ts=6a4bf340 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=PVj2vuZyEA0yLiFZlqDmwA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=2G9IhLSBF7q6IwnLtzAA:9 a=QEXdDO2ut3YA:10
 a=zZCYzV9kfG8A:10 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-06_02,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 clxscore=1015
 adultscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607060185

>>>> With below patch, we don't need nord entry here.
>>>> https://lore.kernel.org/lkml/20260702-b4-shikra_crypto_changse-v2-1-66173f2f28b3@qti.qualcomm.com/
>>>
>>> Patch has conflict. This (Nord) should go after above one, with this
>>> fixed.
>>>
>>
>> The other series still hasn't made its way upstream. This one's simple, can we
>> queue it now and rebase the other one?
> 
> This is not point of rebase, but conflicting work.
Yes, my patch[1] can be accepted straightaway(after review) as it has no
dependency on any other changes. The rest series has dependency but not
patch 1/6.
It's best if 1/6 goes in followed by the other efforts(Shawn for nord
and Jingyi for maili/hawi) to avoid conflicts.

[1]
https://lore.kernel.org/lkml/20260706-b4-shikra_crypto_changse-v3-1-23b4c2054227@oss.qualcomm.com/

-- 
Regards
Kuldeep

