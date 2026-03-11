Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5AA3A1698
	for <linux-crypto@vger.kernel.org>; Wed, 11 Mar 2026 08:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773219398; cv=none; b=lLLFRQ022biPk52DRfahPFfn8Ll/WjTLZNlEspt7iIGgrTXc93mR6lV7/keW02dhPG314Pwu0hdoSWHT5IiRsZjc5lzMddbqfy+9NFgleWYBgcs/PiEjFbU4bWo7dKmqhPtbUZr5w1cHaTkG0u+k0JSkU6PzpXiSew7xBa9TSb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773219398; c=relaxed/simple;
	bh=GxhyEOLS942YERY522cw1a/tosTCri9aYho+t2RDWNM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uekO6es7z3O5t/m6t4F1n5+LgCdrKeb2zAKEer0DwxoWx23tM49q+d4n0GyZWGz8iQpQJPSfI4LcFSEXZHE5716imL07tV8in9MdWu+0Cr5YbLxmmZ9ftX7kPCxSzw5GgeFsabgCzP/H9s0mykKVXEE69eFrKYuRmrxQ994kYc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=S0Rl+f+9; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Q7K4UOqa; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="S0Rl+f+9";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Q7K4UOqa"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62B6hIwp2677054
	for <linux-crypto@vger.kernel.org>; Wed, 11 Mar 2026 08:56:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	pl93YixHoiXJRlfs0OC+xUhIllfIU75ORxITZTmWc/M=; b=S0Rl+f+9vCPnI9qC
	eEiaMpLDIEFN8aD6LBP9VEQlHz6L/ndG+TSVH4vBerkVjELtft+mc0evvM4omCsp
	/61XbzfWagl2khT3UXmTaVSkIyZ/f01Z4HXeKKrx4JikSxeWWwOFnSxcoJZ65XFT
	5SEEpMIcbgoim0sQI/ENbVbzWxxIBMz9sgZJa+WnambHBx3XuA44nOgzx/PZ1Arr
	JRPz/T8/eBP1hwHdgainqlJZORL7OmC1tc6HGSafgV4uxV6VPcdbm5jbTGmetkRA
	pP4G4lRDQPwjy/PxBBTzk+ESI4OnkmqOwAjvctsoKDrHIUDdiMaHRGL6HkVB+sqO
	9b7rOA==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cu3cd0fkd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 11 Mar 2026 08:56:33 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c73783c96baso3646389a12.2
        for <linux-crypto@vger.kernel.org>; Wed, 11 Mar 2026 01:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773219393; x=1773824193; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pl93YixHoiXJRlfs0OC+xUhIllfIU75ORxITZTmWc/M=;
        b=Q7K4UOqaYY5lQ3u0i7V0aDfqilXwd5HNDgDXF1oxUG+hBHu9nTIomVp130082uyhRI
         xgvxBr4ryzHMDWWSZ8gR8LfubQmyyi6GdrvxDzIFHBPJBItceiL4jqy/rzcd5/LT64SD
         W89Sn4L7/6s0Zany3ZEPWLqwg0E3b3Mb5S03RTC6IcvxZl4bp3odY2/OfCHPHsFhTuyD
         4KMG4lr9qaViF1fIz0Sk5cyNduXlrhbOH0VHe/IeR0oPgAqzVu54RGOtubxmSnL5R6w8
         N0tHMRuIJz6k/t3yLLb/Ra4uhcUtMo88ZR9EcFWJfW92HcUIQZsc9/jsdQyMVUWQwMW3
         CmXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773219393; x=1773824193;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pl93YixHoiXJRlfs0OC+xUhIllfIU75ORxITZTmWc/M=;
        b=m/1Bpfznk+c6VFTIdlJVG/ZyY0cBhxbrFmJq6/WfChOIROvC+WhtofKDsd6CKuiE0T
         rV7EDCKjPDAH62MZH//nK/sR3ypGERD6Yn19zJEbf6qziCifOAVeGgHYftTerUUhF3mK
         4rhRhi03KZcg9B1HnOvq6wZY7roHZdVgW+GHQWQQJiBLshQbM985EEs6CCwTOgQwxtkg
         KPi6X14/6h5g8JXk1f1gXQwlvslWQmBTKWJ4AqjlLWnq/LhPGZazZPj1WVk6M6hIPpBx
         y9uMYxNp+Bd3+7aBzbef/D5EdAc3KF71ikC4AwYLAfF1a39X6KjrR2NgUcrU/sO6DXBn
         EYPg==
X-Forwarded-Encrypted: i=1; AJvYcCUCHlvEfAZRLVL2dDfP3Y5CgRT39xvV/HWN9FCM/+dkyw+HYTuDlssXBcx+MSMTszS5XcwEFqextiNwPWw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwXLmNK6FHBLmx8J4jzSfswBGDv93QC9DZI0r4ja8WgC0JJGFy8
	0ZD1I/cMqGIJtrzmzSkrtfmoNZNUyfWmAdfAVssCfJZMsFNwmjsLhPLVQnP3ay2gPzZp8euqaS/
	wCeRaFTKeEkn6ija8/+BFIi978W4T3qWpjOJ1LXswYDdBxwXwn91Z9M1O95HpDwOc2Ck=
X-Gm-Gg: ATEYQzxUQSKHxbhnoJqwP8SEh8bSJx/PPAu7jIPXPBRoPhohbkycYKEwp/2WO5wSvkZ
	x7l0LEgtvQq008KT3UNifo1AaBw4qhebD2CZELRwqKRHDXeYXHbZueAs00ZiVBz+PzBXasCYlq0
	If4UlSupJg7tiGBo5jb+uGrVCJqTxMKq2iHM6/ycLDs9D68pfBy3BrCLvH4N4ror6bekweluJaK
	WsGnw/ZntUe6qsv9na/zsZfw3739rHSev9gYniCuBgLxjkM0xneHxXh4V2bTykTIhVtWepnGm/U
	GUsTiHnkPLL2VpY2iC1QMrE4I92t2eTTgkKJhfwbZaHM91qFiIlZHKLFl0QakT/RoHJhFTXWlqu
	UZ2hGeEmLmzfGVrC3lRgxsiCHaXqhJaSSRdTMn1pgJTrk9JhcYvA=
X-Received: by 2002:a05:6a21:496:b0:398:71f2:59b7 with SMTP id adf61e73a8af0-398c60e4310mr1515127637.33.1773219392839;
        Wed, 11 Mar 2026 01:56:32 -0700 (PDT)
X-Received: by 2002:a05:6a21:496:b0:398:71f2:59b7 with SMTP id adf61e73a8af0-398c60e4310mr1515088637.33.1773219392343;
        Wed, 11 Mar 2026 01:56:32 -0700 (PDT)
Received: from [10.217.223.121] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c73cdf2725csm1523345a12.13.2026.03.11.01.56.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2026 01:56:31 -0700 (PDT)
Message-ID: <497b2adb-bcab-4c81-b6d6-56e7102f416c@oss.qualcomm.com>
Date: Wed, 11 Mar 2026 14:26:22 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/11] dt-bindings: crypto: qcom,ice: Allow
 power-domain and iface clk
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
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
 <a92cbf85-5937-4aef-985e-a5d12031d4e0@oss.qualcomm.com>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
In-Reply-To: <a92cbf85-5937-4aef-985e-a5d12031d4e0@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzExMDA3NCBTYWx0ZWRfX2New8TKJZKdY
 k/WVwsoTmy3MW8n43OOmyDOoRcjHwUd0/FqvRZmHYGe9cMAKGtMyO8cgf1Ojt8lwEbGroTXU/KC
 SbB9YAZDBRd2ahkMN/18TnKgVb3OJdsWVLD2P7+mkKqlg0EcQHePX1Coq6zQr8zgUKXC7tJt3Gn
 yRDtjRwXVeQG1eEl47vCpsZ+DRFTp051TMrwLtuAtB1qxQfq0ZPFcIMo5KoyHmVMVX2PljZ3mOj
 g8pNJrofRccXwNGvBdwbRAg4EsnemrKu8Gjn+jqYTVDh+ko7rXYbxFtgnJ9vV+/hOTMV6nVNA2b
 5gzfDHQkCdS0wcY5BhAtpy0Pie8DAemXs+RvPAdTpVTKfm3wgaVryw6+2wghBUFjZB3LzZ7NI1z
 Je3tX36zx06VKeWealHSZQE+ExrsHUa82r9Ku3app2FrOvqTzEGTrWG6PxIGxbJKdUe45xHwPVa
 UTD0NS1PItMoFNAUCPw==
X-Authority-Analysis: v=2.4 cv=O/U0fR9W c=1 sm=1 tr=0 ts=69b12e41 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=8h99a6YZr-iq8KHAznkA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-GUID: Sg5bcPBaUTuk3o2RLKQKqalo4a_afs2i
X-Proofpoint-ORIG-GUID: Sg5bcPBaUTuk3o2RLKQKqalo4a_afs2i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-11_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 malwarescore=0 phishscore=0 impostorscore=0 bulkscore=0
 clxscore=1015 priorityscore=1501 spamscore=0 suspectscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603110074



On 3/10/2026 7:43 PM, Konrad Dybcio wrote:
> On 3/10/26 9:06 AM, Harshal Dev wrote:
>> Update the inline-crypto engine DT binding to allow specifying up to two
>> clocks along with their names and associated power-domain. When the
>> 'clk_ignore_unused' flag is not passed on the kernel command line
>> occasional unclocked ICE hardware register access are observed during ICE
>> driver probe based on the relative timing between the probe and the kernel
>> disabling the unused clocks. On the other hand, when the 'pd_ignore_unused'
>> flag is not passed on the command line, clock 'stuck' issues are
>> observed if the power-domain required by ICE hardware is unused and thus
>> disabled before ICE probe. To avoid these scenarios, the 'iface' clock and
>> the associated power-domain should be specified in the ICE device tree node
>> and the 'iface' clock should be voted on by the ICE driver during probe.
>>
>> Fixes: f6ff91a47ac57 ("dt-bindings: crypto: Add Qualcomm Inline Crypto Engine")
>> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
>> ---
>>  .../bindings/crypto/qcom,inline-crypto-engine.yaml       | 16 +++++++++++++++-
>>  1 file changed, 15 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
>> index c3408dcf5d20..d9a0a8adf645 100644
>> --- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
>> +++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
>> @@ -28,6 +28,16 @@ properties:
>>      maxItems: 1
>>  
>>    clocks:
>> +    minItems: 1
>> +    maxItems: 2
>> +
>> +  clock-names:
>> +    minItems: 1
>> +    items:
>> +      - const: ice_core_clk
>> +      - const: iface_clk
> 
> Trim the "_clk", we know they're clocks, because they come under.. you
> know.. the 'clocks' property! :D
> 

Ack.

Regards,
Harshal

> Konrad

