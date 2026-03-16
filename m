Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62B517B50A
	for <linux-crypto@vger.kernel.org>; Mon, 16 Mar 2026 10:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773658595; cv=none; b=qdyKCakYhhFY8MGqAu3yV7fkHVgzHYMJmj/POuphj6DIU5q+UCYSobbt7OMxUFK48EpElqhk3V2PbVxbQzfCN3WrbYXi0/DS0jqhPJXKlN50qvOSXW2Wky6J43zrrbKzxhAHKBUecg1O4o6Q1BJn66h1xNmecRhuLAsbDntqcCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773658595; c=relaxed/simple;
	bh=hXzTpM2Tf9bjZTy7Ife+OSpt4rnqkBMKo0z7sfLlGCc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F/GNZGsDPEWWzOGytXswtax+cJPLLURLYz9uiekxXuzFVivNNsg9Q3EylVZoQbcnP3pLhd28IXL4fUIgGJHk2+lw/YnX++zwRYF1p9ff7afFTiTeSvvpgULkgRnaFdmwqUUpmj2HL1Hlf2gMmZeuDYGeUteiapHn73j1nKRRl4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=fKa9B2de; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=KDxmykEU; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="fKa9B2de";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="KDxmykEU"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62G64foD663052
	for <linux-crypto@vger.kernel.org>; Mon, 16 Mar 2026 10:56:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Y57dvznnesnOFOCEA9bp6s6C11GTzXM09NSfe2xDwPY=; b=fKa9B2de1JYD3qvS
	RbLtKpYzukeQc/e7BgRUeP4Pih87C0429Ay96fhnm67BWuy1SRDDM3ksmNiW6Oev
	C9NKEI0xYeWyIGKcVMjAxwsOhTQf3mG781FeSIkKnUjYSrrl/JmzRVTu2Fr9i4wE
	mKjknPrxsLQ1fkyCBJwewIS29wn0iVIsrwikYpyf5Ck5Z2OIZBNNICVYKokZM14N
	b9KXh9Uh/XKMGKYLL07I90l9u8fE5gcypjG/Y0+5ooUOLCwF1UPIfHtPwTecQ3sz
	f9uE3agoi/O3CWCiq5yoa9sPmIT8ZKhDXKDjbPPO4yNognxO6fpjSidsdItcu1iK
	pWdkuQ==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cw043na7f-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 16 Mar 2026 10:56:34 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2b051befbb8so15526855ad.2
        for <linux-crypto@vger.kernel.org>; Mon, 16 Mar 2026 03:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773658593; x=1774263393; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y57dvznnesnOFOCEA9bp6s6C11GTzXM09NSfe2xDwPY=;
        b=KDxmykEU2919/UQlrs7ohBnq80Zn2Nc8Tj088nULBsnvwBJEpX2zLAiVaheUD6MFq5
         QRzQFBKs5WTATTordkZFquJhMBnmMTYO9PzjM1lwAL+8VuV1O+n/oqLMLUsBsn/HbInw
         pOgFMN/amQvKJ20VAxao00C2utF5KModEF9C1LbXZRfOieVM6SDYMPXWJ1wbVhd210GO
         8CwbUm/qArhwdJBwK7twQuXnMr3UqQvdtf1QKRf+kAkgsjca3HtuigDr5ePsS7FrbWMl
         7B59BLYpTM/9KY/GnT9eQo2NqxkDQVcUhssnYj8mS9HOQVweVz7Bvc1zWhbXhA++08sw
         nxPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773658593; x=1774263393;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y57dvznnesnOFOCEA9bp6s6C11GTzXM09NSfe2xDwPY=;
        b=jIt7PROpyqilJ/DgRLHMP5NgNIx6XMJHVpC+JPt7lLAkM3b5m9f5slceixtdFMulMU
         pBa5G6ysYhc9SKCxqV8ct8SDdAN0Vj7gC4aorEC3GjJL4SFFRcEugN8Dj/hRquozXJa5
         wBg7ABtrKycwU66AZgG/1qYp5P2ZsKcXv0UQeKZMmiI0JfVsHSniefoqI61Iyd+IiN6N
         1gVy5YZM3NkKzoCwMXYMkVo0JRbVaNIIfwxXqH3oDNPw9Txmi1xwiCDH+yAe7J0TVSXJ
         Umv+lkvYpYBt1kgzX9uEPeSo7XBQ/B8gD2r3SHYENeS7OXUw/ujRMSq7sa76XgI8vPt6
         wbdw==
X-Forwarded-Encrypted: i=1; AJvYcCU6zs09TbsTaXmaG8ZtURzJlgOpBziFGT1qYaHNgwXbMnIxCNsE6p1cte43vc4HzkkyuzHcNZ52KD97Xew=@vger.kernel.org
X-Gm-Message-State: AOJu0YwqRVHLPXxaZdZfpJeSepmbSeLba6MIDw6S2SyzAdSdS6DBJs6e
	16+f4gLYqNzVjESiToDRzBZc3zzR5uwQ/3tUvvcd98DA5DFIzPDrG2s0+xswmz3BhoYqHwxknNB
	DOeN9kq8uMke2Zpnavx6J9kFdXhoofZ5orLF3TvwLxt4t7YnhBgXHHeXx0ZgN9D/viJ8=
X-Gm-Gg: ATEYQzzG1zkTn9k4MUzCAM67ebU2HJ1eO2QX7xcRqSB5k/yFt7Jq/P9mRxzrdpZIdVF
	gOhGLcn0JFlc30dUrsYRjL+XW0yvDbGU4N3rBILGU3gacnERJrEzleG5YjbmH/IuIhwcFDB0bYZ
	F559CVPCLCK90BJh+L7hcfkwKG0twApmmf636QNbD2aSXWLm6h9LxXNZXHsMpmUfCuQzzbX3IEL
	MG1J4HVUAecOAmV/HDGanKd8OsI6ETyjw0d7D1Zyh90LlekdIAzve5cfB5C5qCOQ+9KFqp4Uu3B
	YjmypxV+0bz3+/5I6iX16oNsheuoXlYxl/QYH/yey3NHR20AajCSQXaxGVlfJLC1AvsbQlsXBFE
	zuwSDI2zijxL/qoamkaJKDz1lJyi8qqtB4nycdOuwaqg61Z86ddE=
X-Received: by 2002:a17:902:cec2:b0:2ae:4a6b:68ea with SMTP id d9443c01a7336-2aecaaa88damr134743995ad.43.1773658593402;
        Mon, 16 Mar 2026 03:56:33 -0700 (PDT)
X-Received: by 2002:a17:902:cec2:b0:2ae:4a6b:68ea with SMTP id d9443c01a7336-2aecaaa88damr134743655ad.43.1773658592934;
        Mon, 16 Mar 2026 03:56:32 -0700 (PDT)
Received: from [10.217.223.121] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b05b4ca68csm21200455ad.79.2026.03.16.03.56.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2026 03:56:32 -0700 (PDT)
Message-ID: <48daa237-aff9-45ef-919e-665e5ed27f66@oss.qualcomm.com>
Date: Mon, 16 Mar 2026 16:26:23 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/11] dt-bindings: crypto: qcom,ice: Allow
 power-domain and iface clk
To: Krzysztof Kozlowski <krzk@kernel.org>,
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
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
References: <20260310-qcom_ice_power_and_clk_vote-v2-0-b9c2a5471d9e@oss.qualcomm.com>
 <20260310-qcom_ice_power_and_clk_vote-v2-1-b9c2a5471d9e@oss.qualcomm.com>
 <2ac2efad-3533-490e-bb42-f21c4e950277@kernel.org>
 <a2d6c630-e4df-4cdf-8b10-64d87d24bf8f@oss.qualcomm.com>
 <b2d852c4-9f52-4ad4-a916-ced19c599938@kernel.org>
 <972bd9c8-4671-4151-a3a9-d7eccdf83913@kernel.org>
 <fc3d1ef4-1a0f-41d5-a742-81305ee7f521@oss.qualcomm.com>
 <87fe32f1-b2f2-4b9c-9e54-03be35c921f2@kernel.org>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
In-Reply-To: <87fe32f1-b2f2-4b9c-9e54-03be35c921f2@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE2MDA4MiBTYWx0ZWRfX9NulbZ1DaqQA
 kRf2HAaCdkud1ftdaIoM0e0htO8OOG248yuWPbTddXjJPK3R+b3GGBKd4J2X9lqTky75gl08Ghb
 iB8CBWD0rup4aQ9FG3kuAUkVJq4M/P3k78V3qGD1A7nhyd1Fc3ZfcARC0qrq2CGs2GiYZ23qrbE
 ulNeBeqfHNodd6c02nsQZYxL0t2XEVO/PMydwFt8tZ7Zi1SmDfeOg54+X2uC2iaYXZ/NknRwknr
 dCqmnHHdk7qL9seY7IMXQCeUsx70KT6Snn8HFzlla6f5nqIEwPuO1JjPky5UTLt/Sd7Nhnonl49
 0jFMmdweIJWbsECxWGva9GA3bM6C8GljSMTvc82K7Ry0OjD0yzfB43C8N9imbkGkU7+AdYPSncQ
 U/H4lqXtEf5qYROeRZh6qS6OkCTAHtzyYx3cvB8/mC4kOpk+j0gYlP4guPT7OT9B+MMNA4/h7p6
 2pAik9/EEhmrLNf9n/A==
X-Proofpoint-GUID: WDRgMgsBrpo0tYhk4iwGreYBrb_6kEUG
X-Authority-Analysis: v=2.4 cv=fLs0HJae c=1 sm=1 tr=0 ts=69b7e1e2 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=fxH43373OejRyu7CQr8A:9 a=QEXdDO2ut3YA:10 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-ORIG-GUID: WDRgMgsBrpo0tYhk4iwGreYBrb_6kEUG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-16_04,2026-03-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 malwarescore=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 clxscore=1015 adultscore=0 spamscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603160082

Hello Krzysztof,

On 3/13/2026 9:28 PM, Krzysztof Kozlowski wrote:
> On 13/03/2026 12:45, Harshal Dev wrote:
>>> Except new devices, like Eliza and Milos. And then this should go to
>>> current fixes.
>>
>> I'm not sure if I understand correctly, do you mean to say that except for Eliza
>> and Milos, new devices need to change their DT binding to 'required' with
>> corresponding DTS changes. And then, the patch updating the DT binding also needs
>> to be back-ported?
> 
> No. All new devices must require this. You only preserve released ABI,
> so fix unreleased ABI (Eliza and Milos) now, before it gets released.
> 

I'm already being annoying, but I will disturb you one more time for clarification. :)

By saying 'fix unreleased ABI now' do you mean to say that I should add another
trailing commit at the end of this patch series which marks these resources as
'required' in the DT-binding without carrying the 'Fixes' tag? Specifically so that
Eliza and Milos carry this constrain.

From what I understood from Bjorn's comment, the DTS and ICE driver sources will reach
from different trees and either could be merged first. To maintain bisectability we
should first merge this patch series followed by a subsequent patch which marks these
resources as 'required' in the DT-binding along with accompanying ICE driver source
changes which fail probe when 'iface' clk isn't available. Of course, the subsequent
patch will not be back-ported as a fix.

Many thanks for your time,
Harshal

> Best regards,
> Krzysztof

