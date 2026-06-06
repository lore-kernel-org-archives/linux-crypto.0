Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5303B7B98
	for <linux-crypto@vger.kernel.org>; Sat,  6 Jun 2026 20:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780779395; cv=none; b=D34krB7G56DgzXKZ7TEmQOTZE7dJOyyYDk3nmwHLtpCtS93PDlhd6RjteS7GcfRcb/md1YyPMjqHqLnfM28aMfybgp4RrsBnwgkbtNGkD0HZ+X2BKEIMq8s/ddeREvfUpS9H8mrWWTS44Z4tvrIfLYJxYbK/E7zD0sLV9gyG/0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780779395; c=relaxed/simple;
	bh=vy78W//SRtt7ax22hJTO3Yi3mnrdE5br07hh8/x6/U4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y2fZnzuAPQupEj4k6HehBMMvmwrh4YbrqLsVmMHJwEekVSs1wnBKbLpD1qfK9Gv4neJx+k1rhhAqqqEKsg9Fra3glahOF4UiWcc6Ubfq3AvWW+T7JhL1uutCgzVyL7S1Rq5JhnpR5j0skP4GWmy1LCZ9b6SUdq4rTQLuFHKaHhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=bWfiWDrM; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Lk9Ou7el; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="bWfiWDrM";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Lk9Ou7el"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 656IiXZC2679994
	for <linux-crypto@vger.kernel.org>; Sat, 6 Jun 2026 20:56:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	TJf6VxqlRqIaoomMLbPEONsAHBXuZjssJS33E0d0eeY=; b=bWfiWDrMkIWF242M
	+9p/OjT0GACmMbgnBTJ7kJ1yvBpnd7HSNLmIReEPThOZitm32mX9659BHir1kt2j
	t4DyEQPeJf5xCU09e5fuc7ezL1OZ5aiPpiGkS5Nj8P3HEiSWOAQOQLjkoGkF1+U2
	pduime/3pael9tVnEK7Ppp9xS4UC8sUJMH7ub6UUvZOaTyod3h9Al6C9UsBDsrpy
	dcqUS1CwbgQbOYxm1kwnQGohLHCixpQZWZQ4dwnGDeI63c98ichPzWL42+qei8oH
	u3OeB2+g5TE3EeJRLc+cQ7Xgw/arL3TBfJS9YNyp21+TBIlpnBcCUWPBXJ9zxA+6
	8GOBEw==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4emaj4tf7b-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Sat, 06 Jun 2026 20:56:31 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2c0c36f4b76so30736375ad.3
        for <linux-crypto@vger.kernel.org>; Sat, 06 Jun 2026 13:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780779391; x=1781384191; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TJf6VxqlRqIaoomMLbPEONsAHBXuZjssJS33E0d0eeY=;
        b=Lk9Ou7ellgi9z5DCq36Q/WROcw/0BqCREz7k5+mG8orfKXNSVu+jNOqGZlM73t2O3a
         AV8cgK7F/E8hx9pDjw6rQN+Mw6KCEuD19kBzOcGi9qlXuzS6QXbLUxGYIkCv0Y6TrMoH
         952QFXrOcIv6sjuRUVJx1QNutARF07eQfJOlqgjVzYN1yhb/gmzpeC/PJSlUZYq7BC9Q
         kabx27smcdd9FLQXH6c48nbY2RyL84mmeoXJfVya2y5ftEd72jOPAJUxvYsydYP0uHrK
         c2cwKyHT5c+MR2RTIXlUYNFpHu7G81P37TQgidbfLtWBKWZllCilpGPAX4KY/sjIOdeB
         v2/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780779391; x=1781384191;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TJf6VxqlRqIaoomMLbPEONsAHBXuZjssJS33E0d0eeY=;
        b=I7RH9L3Y2XR2RMNbbgH2pluDSyGP6VRw8xfg1F9EyLDqGJh7uUyDd11JI/SKF58uNO
         x94NA+kdd8PChv7IMUxuQNNBz5d0I7LIDe32lVmJGkqOGmW5xyWecKuEZmtJPJSUmp6U
         FnKxtKgQXpSFbleosjtvPNCE8tRU0FWYotckDrm9BoUv98pdCY1/Tw/0IamfduG61CMM
         PRdvI9Jhr7A8ywMp83bNezJpBKhfPTVN3j35GzUcDlGMith1srxm6OegWg9ElpLVbNXO
         aH0YQEdyGpMpg4n7XgE54oD+6pas8NVwdAd7I9ivsr5NPBPNz4DNoMX5gt6Mm+BcTqKF
         y1JQ==
X-Forwarded-Encrypted: i=1; AFNElJ+3Bd5wgvNccSIfUkV8PRjt2UXgW1rXYjUHiB8iTBgTCv+nUHp2d81nDS3pjT5V/Ek0tCRNnLpXgi5XrCU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTNrjkAMW0wc1G8CVySFoCcdxat6rEfNoapshOUtJtUVqWavo8
	kBbLvrAQ0nBixJhSBeuip3SGXsP+PPDK9mqUlfTHegAzVwfQxgetVTa/M/K4p2coQ7jWgXF/Qpn
	TOJFS1LbKg+ACATJI9HbBRQdOiTdNio5qkSr578wrZSQZlYelR30bIpY44EDCMWgDXKk=
X-Gm-Gg: Acq92OHuEtfKCPnSa/cPyPnAUbjEIxj6tPNUw8XD5bN3AmMlpGY8T0QwwWwkz5FvgNG
	FyzM5LN8gB4Ue1ie7IOZ0Gyj/EAxF5FcEtv8Z+4WFiSdU6937F1AbPn9qgXm5ehQyM4htBrGyWG
	HNhIXzFnXcv6L5Q9Uxr/5hzZo8UJYIb2GFbw133YoDJmiEzyP/1S765bjB5ljEE5gHaHwFrxkwz
	EnVnYHVpduCYmJImWjOrVX92UMR0zODk+VRzSh1seofsBY7/ijoQaivjcbuO70pe37W61sQ0phs
	Ujmpd/WYUAO1J/n0EuoK+xKyBEbD7JiyuxZ6i7Qjvqr32UugsQD9Mjqa/5l7JvQLYHRLwIPSmV6
	QMGb1vTjUY21R4rsALO5r+h5mTWMCc8uJIJfPHDEM5wIsMCU1g1zZ6sEAXtnA2fw=
X-Received: by 2002:a17:903:19e8:b0:2c0:bb2d:a30b with SMTP id d9443c01a7336-2c1e893e978mr99638805ad.32.1780779390793;
        Sat, 06 Jun 2026 13:56:30 -0700 (PDT)
X-Received: by 2002:a17:903:19e8:b0:2c0:bb2d:a30b with SMTP id d9443c01a7336-2c1e893e978mr99638565ad.32.1780779390329;
        Sat, 06 Jun 2026 13:56:30 -0700 (PDT)
Received: from [192.168.1.8] ([223.190.87.199])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c16609e2d7sm135379395ad.39.2026.06.06.13.56.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Jun 2026 13:56:29 -0700 (PDT)
Message-ID: <14fbf0ac-c5cd-46b3-a42e-8cd2ccd622f5@oss.qualcomm.com>
Date: Sun, 7 Jun 2026 02:26:21 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] dt-bindings: crypto: qcom,inline-crypto-engine:
 Document Shikra ICE
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Konrad Dybcio <konradybcio@kernel.org>, Frank Li <Frank.Li@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
References: <20260521-shikra_crypto_changse-v1-0-0154cc9cc0de@oss.qualcomm.com>
 <20260521-shikra_crypto_changse-v1-1-0154cc9cc0de@oss.qualcomm.com>
 <20260530-amphibian-mindful-saiga-ffa982@quoll>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20260530-amphibian-mindful-saiga-ffa982@quoll>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: iKAzhrhcIs4a91ax9fTKldyK9aUvZrUP
X-Proofpoint-GUID: iKAzhrhcIs4a91ax9fTKldyK9aUvZrUP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA2MDIxNSBTYWx0ZWRfXz4byHEqR5ptd
 r2+mVUXzySaotYTfPpbbtxGZkPWLwNVWEWXfwUGaM5JbllJLVpPvSOazHeT4ybNrWP231FJ/kTD
 OJvwclhgZgDamUbga+rBzI9PL8JBKpnh50rPLg2tJIHUrRQqWkz+1hD/CicqOU7xgnYCNX16Nfn
 tUvGITQXwSqoc5f5oRFdX0EOKoJSkjQpSym+yfHtQTH3vvyclsuFj97ZQqgVvuRRC2InqAmDLQr
 eRO1w2iZk5wlrgw2+4bwhLM0cRgLxllC7eyS143H+3wkTnVzYDjN57O6SguMxez70yIdzh3GSh3
 a+CQNWHuxUfak5qHjBm0VL1z3CEt6dES45zNdlOgj0cKiN/Rxfcf78blaY2mjuy4N2B9C+vUhrS
 aFeKt01stgPbpUOJuDIOugVf3QubfKZNJWhnZvWrxTYVClV3GP8Z77/1DISj9yDhQrP9fSAfklq
 TYm4TeWqOZmKjzWYVmw==
X-Authority-Analysis: v=2.4 cv=TLh1jVla c=1 sm=1 tr=0 ts=6a24897f cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=hwwt4TTrG29xD97kRhuzDQ==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=hQ3fLCEdGXPuY6oLI0YA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-06_05,2026-06-05_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 spamscore=0 adultscore=0 clxscore=1015
 phishscore=0 malwarescore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606060215

On 30-05-2026 16:08, Krzysztof Kozlowski wrote:
> On Thu, May 21, 2026 at 06:47:08PM +0530, Kuldeep Singh wrote:
>> Document the Inline Crypto Engine (ICE) on the Qualcomm Shikra platform.
>>
>> Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
>> ---
>>  Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
>>  1 file changed, 1 insertion(+)
> 
> Missing constraints for clocks.

Sorry for delayed response as i was afk.

I think you mean to update shikra here for clocks.
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml#n57

I've an alternate suggestion for this list.
Let me send patch for same.

> That's also v3, not v1.
As per previous suggestion, I clubbed all crypto modules together and
sent them as one series. v3 is only for ice whereas rng/qce are still
v2. That's why i kept new series to avoid this confusion.
Kindly check cover letter for more.

-- 
Regards
Kuldeep

