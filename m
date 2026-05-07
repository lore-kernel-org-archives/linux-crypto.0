Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B088345CC9
	for <linux-crypto@vger.kernel.org>; Thu,  7 May 2026 10:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778148004; cv=none; b=fcH2lu5x4+o1vSdlfo9Csd8nxQVc6/vSubFYhHCGbEQROqx5kviOX+qUG3IFAMp7Lzgj1LypjWwCyoihcSKgXSOYM8AvjxdPlKHn5gNX1ypefweO5/MuW3W3Xdia6js1DIHHCzgA2RdXPzubbjfbY0n5xkaFGa6ONwmqEhq1/1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778148004; c=relaxed/simple;
	bh=yOCUHpotWozcC1m7TJw1/KIAyIx03i4Pj0MEjLVgVDk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=exZ0tOvnIeYbjSpdQSHENYYNjSuFD0L0EUDU8zrLb57dJQMn6q19xESFufpf4vIZECs6+6siw9gsF5DWpFTULq+lTrnCBeNYTM9bwkLmIhCWdrLcpN9LgNK08XRP/0N0H8ak008hdk1BHVD8OogH2iAE02kzfkRxMAO6MKQj9E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=pf26NcSl; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fMjgTAxs; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="pf26NcSl";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fMjgTAxs"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6479mKgA026622
	for <linux-crypto@vger.kernel.org>; Thu, 7 May 2026 09:59:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	678j4tCJM5XWKuhF7X7zIK6Yx6XfJebqnO6Op1WlavE=; b=pf26NcSlIBQRQfYZ
	yypeuQoNB2UyUWLAnLAz3pSHHAs9SJ98t4o9nAEKtlqZT8CAdA2cDkJZ377bCTfO
	h9SzFdlWGWZJEOVfYQi4Vx5G4Vn0IBb9k5WBIWWpoplx8BatcYr4KNs3xFoLbSXi
	TRR2EBDERTM9GEWW0zAlNuSMrtIljE936x17XiWn2mYI0qynZMVj1dGtW+CC8a9+
	MUed0V7YwCcoOpoeIFU41KNu8jeoknrv7rs8/uOeJ4Bi3UAFz1Z00qDUTmuos2/y
	pFH78DTbnhP/TdGNcTuFecODHOrIeYmQvweD7sJHKjIyywBtHPvkrfjDgf7C+TVt
	wz+iMA==
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e0k1t1bbe-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 07 May 2026 09:59:58 +0000 (GMT)
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-2b81ff82e3cso1044894eec.0
        for <linux-crypto@vger.kernel.org>; Thu, 07 May 2026 02:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778147997; x=1778752797; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=678j4tCJM5XWKuhF7X7zIK6Yx6XfJebqnO6Op1WlavE=;
        b=fMjgTAxsWD4BO0a7SpBE592cg6IEXflLeXfjKzsz4dnMiZj9WEgknKRanU7CuHs1b5
         9XFzt/WGFx42lYLmeByCOGw3pq9oObLR0f3s6C+uf2KBzYV1H2tLWH/PzWBOFmGd6r10
         CuqFEsMkiOqiPESAPAC3qa1LKDe6/raAEm7s1iM1jPDvQPDejbg5w/dAvd2yiSGm+uL9
         Xyxrpo9gqv8ilPp3tbeBH2EpPnroUHlptIwVAY+6Lyst/aXybrB56Z8rHfgRwpC+2LCX
         qvG6Jt4xAgmLuhLBUUJV+/W8jtMWdWClMRPTVYwmWaXKp7bSQA+eG6SZHGLkT3z2bF15
         iC2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778147997; x=1778752797;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=678j4tCJM5XWKuhF7X7zIK6Yx6XfJebqnO6Op1WlavE=;
        b=BfbeO8udP7a4i1k1dDMU3IbGsxAIuCKvNKVqIwReC+Yx7mCqymKgJEUx13T41ym4Me
         BBhVaw7CDirja1wy/s4SkokxfogpKM7KkS2g32/wADmG+Wn47LtOTMDwLX//bPSGbGtX
         jAgqF0G3+KnyRr7ydez6CLA4Zig7V0xloVb6sMwjeIjCZf+Sg3EvhFNKGzisXyAtmaKJ
         4Cpf85kVw7frRLLfoQivelKX7g7Gd0pg3qaTYWa121BZAo7lEz+W7UU9gDYgkXn1Zku9
         bdzMJgNPnDheTaPsX8ihAgr7rLpnk/viwsMy05YDr/GeQ0PwbujwxowS+SqpHTWAE31k
         +dIg==
X-Forwarded-Encrypted: i=1; AFNElJ+qW+LHxHcQsV8FsWibhEHfOQ4VN9Cck90oUFtBuFZcjexZGi30q/XsmywiiOPLqEA5cxCtczVCJk2V7E4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHjKmLjQVXKY8iMo8Y9li4IE9Lxl/GPheztnLOYi8BiQqPbWZc
	rWZb5ajshNU5Iurj+V0wJ8a2FnktnyTIiVFp+0JFH82VLNCHnUrqk7uvItCq2f8XxCyI8BYhA5R
	ceqWYXSufQpPKNP1ZBjZ3UkMEjtqu9+flH/yUKVw4DhItl+4Yy8IG6Nloypxrsv4q6Qc=
X-Gm-Gg: AeBDietH2Y36jYUQnnocmO8nG5Tnp/1dgbzFV7p9tmGOYoawWo7oYrx19KQ4JZCUdAk
	5tZoiN7xAOtrz+bmdtPZR54ICrWNueXIHhxV3ZNIqVBNYMwbgKPR79ro1U9mX3DpQPQ/n5cGVIi
	dlsyA/G3cHQlyG/LbD+5zB+W4r26C5WaS34jOyPu0rc4T/j8XZGl88E3V15bdZ0lFIb7M5JMcYR
	eQOSCOV06Co3gtSkh0BEi7tcsWmXRT6D61RXJBtSWsaQj6zVG8hOC98uj72le7jiuNSPFD632tI
	UoKVKDlm781n/Vlf+DXTGy7Bs9ik8+MVfvDu2fuVW6cAX1XioUV5SzFL1+eeYjJX4Fk/8SnHWTn
	A1ca9RgWucp/c0TZw2EkVdFpVjmp4DSuiMw4VSzetECupl3NC7ICKcvL9iTCuoIFNa2MSh5rk9c
	YILeQWZJq0EaP6DQ==
X-Received: by 2002:a05:7301:1006:b0:2d9:db50:c6ce with SMTP id 5a478bee46e88-2f6e1e3166bmr905286eec.3.1778147997097;
        Thu, 07 May 2026 02:59:57 -0700 (PDT)
X-Received: by 2002:a05:7301:1006:b0:2d9:db50:c6ce with SMTP id 5a478bee46e88-2f6e1e3166bmr905276eec.3.1778147996489;
        Thu, 07 May 2026 02:59:56 -0700 (PDT)
Received: from [10.110.10.111] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2f56fd92780sm8102758eec.23.2026.05.07.02.59.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2026 02:59:56 -0700 (PDT)
Message-ID: <4fe79c7d-42f3-4001-a5ad-a61c491ae29e@oss.qualcomm.com>
Date: Thu, 7 May 2026 17:59:51 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/3] dt-bindings: crypto: qcom,ice: Add sa8255p support
To: Krzysztof Kozlowski <krzk@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        ebiggers@google.com
Cc: neeraj.soni@oss.qualcomm.com, gaurav.kashyap@oss.qualcomm.com,
        deepti.jaggi@oss.qualcomm.com, bjorn.andersson@oss.qualcomm.com,
        quic_shazhuss@quicinc.com, trilok.soni@oss.qualcomm.com,
        konrad.dybcio@oss.qualcomm.com
References: <20260430032136.3058773-1-linlin.zhang@oss.qualcomm.com>
 <20260430032136.3058773-2-linlin.zhang@oss.qualcomm.com>
 <41da4b77-4d0d-48bd-9578-2adefe5466af@kernel.org>
Content-Language: en-US
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
In-Reply-To: <41da4b77-4d0d-48bd-9578-2adefe5466af@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=EoPiaycA c=1 sm=1 tr=0 ts=69fc629e cx=c_pps
 a=Uww141gWH0fZj/3QKPojxA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=DO7WzgAb8V_MQCx-KrYA:9 a=QEXdDO2ut3YA:10 a=PxkB5W3o20Ba91AHUih5:22
X-Proofpoint-ORIG-GUID: YURlEfZTWPq4y-ucHhEWCdgGZNeg2AMS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA3MDA5OCBTYWx0ZWRfX6edf3wbhwGJM
 EyaHakHY2AYVy8vzra5Dw5Tkw/6C1F43G2W73X/ntkmueMZkVHklK5IJRNU1H3Sz+YzGrAfvlFd
 KnM/z97UIVh/FDEkDbLafUvcXiMFkPfqdOAyX2c3U2oZ9p9VXb7eVlqmouDCVdLUYRsWY7LnPeV
 SKf9+w6R/BZt1Cu6FCMHzMM6aubVcjBDvrAvSsECnzF2HEXOVLLnmCvLik5y//ydNe2JC6yA0z8
 mCJF7m9ObC3hFMjLJMt4WXXTDmrnCe/ccK9iEK6zfAE251i51n/nyQGgvCxOS3hYPAT90Yg5PXM
 Y/MeZ83OYmCY+DYiRhTN2XechbNDk/jLFIVA/IICQEM1qxqa2HHsaIMLqpL+Ia/nH7d5Jc2Sudt
 Cxga510lShkPa0bw0EjiuZAfqocOx8F1JfhLmd9HH3UJz7qyGn77Ng3KtCqtYTt73xSFp29peIG
 DNH5B5S4FoxDlXOzxhA==
X-Proofpoint-GUID: YURlEfZTWPq4y-ucHhEWCdgGZNeg2AMS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-06_02,2026-05-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 malwarescore=0 priorityscore=1501 clxscore=1015 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605070098



On 4/30/2026 2:13 PM, Krzysztof Kozlowski wrote:
> On 30/04/2026 05:21, Linlin Zhang wrote:
>> On sa8255p, resources such as PHY, clocks, regulators, and resets are
>> managed by remote firmware via the SCMI power protocol. As a result, the
>> ICE driver cannot directly access clocks and must instead use power-domains
>> to request resource configuration.
>>
>> Add the qcom,sa8255p-inline-crypto-engine compatible string and make clocks
>> optional for platforms that use power-domains instead.
> 
> 
> Please use scripts/get_maintainers.pl to get a list of necessary people
> and lists to CC. It might happen, that command when run on an older
> kernel, gives you outdated entries. Therefore please be sure you base
> your patches on recent Linux kernel.
> 
> Tools like b4 or scripts/get_maintainer.pl provide you proper list of
> people, so fix your workflow. Tools might also fail if you work on some
> ancient tree (don't, instead use mainline) or work on fork of kernel
> (don't, instead use mainline). Just use b4 and everything should be
> fine, although remember about `b4 prep --auto-to-cc` if you added new
> patches to the patchset.
> 
> You missed at least devicetree list (maybe more), so this won't be
> tested by automated tooling. Performing review on untested code might be
> a waste of time.
> 
> Please kindly resend and include all necessary To/Cc entries.

Thanks for your guide!

I'll send a new patchset on top of the latest kernel version
(branch: next-20260506) and update the to/cc list based on the list of
scripts/get_maintainer.pl output.

> 
> Best regards,
> Krzysztof

