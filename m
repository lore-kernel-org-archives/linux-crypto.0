Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6AE9277C9D
	for <linux-crypto@vger.kernel.org>; Mon, 14 Jul 2025 23:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752536332; cv=none; b=O/xIZopZecAV0LcjKCapyKTaKW18OMw4YNVo4mDcjDfFGbcBs1RnmuEf9sj8YclQgx9GGOcsDOx2vcKkINDNVO+A8CIlTIbJK8B1EqcvyQh/zj/K2J3dPNBq83CV4r4fu0Nn5JoLD3zCeUNaWHdaRo9NwbpW0Tl2+57pyNsIckE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752536332; c=relaxed/simple;
	bh=BLc/nG6tbTXqBWHXJq4nAE9fz1qrAgmKgywiVncJEsI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U0LCfkbzWZLiB9GXlYPufzQMwDIrb7Aao+xOmZxUUos2pmiEzskunO4PoaOwij4wWdpXwCKuokugqXjmsxOUIzyHhEB/dUdVvwLU0n6C590dTX8pnR0hHJyblCeTgtXD2CqpkUpL5sTqNDSRBvcis3elFz0824hCnOMzkT7Oxjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=e4zaRps/; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="e4zaRps/"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56EGSBiO021180
	for <linux-crypto@vger.kernel.org>; Mon, 14 Jul 2025 23:38:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	wn0uaTpQJ5msTA4q2mSIBqQxq96F8xnwcsNT4npFJ10=; b=e4zaRps/oaXdJY+l
	UdQ8DEc0Nne1nK1lwtaLfJAWHqyiLQziUU3CzDFUCkUNeWV8JnAqLF4ZqflmU+qO
	IaCyiN56c5pDiAQOpJ9+b1AfDTRlfBvVfWpbwY4pCP7ODxRyQwipwVImtiZyO5Zq
	u1YEOXKa37KH6sh1j/GqAfCY8nztz+Om9WIHf6FDuC7FPCXsgZo6i3zcB6Z7X9e6
	T4s9AwHPkBTS9WDnUgqpGgWpprpKj9V+ypnQ0HV7+q4MgprRJMUwYBkd+zMuSwgG
	+3J1azNHufa9RQ/26fQCJmsfd6flX7m+fE3a6H1KmT5/jvGkrb+aWNHeMwONjcg8
	7N0xIQ==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 47w5dw0yb9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 14 Jul 2025 23:38:49 +0000 (GMT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4ab7406bfa1so3010561cf.3
        for <linux-crypto@vger.kernel.org>; Mon, 14 Jul 2025 16:38:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752536328; x=1753141128;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wn0uaTpQJ5msTA4q2mSIBqQxq96F8xnwcsNT4npFJ10=;
        b=POIMBG1rw+A9Hev6cEmXkWDYM1HrFltgRWY/W7chyDoFa7fcdAgHDFEjf7NE/mF6IL
         sfn6/DamcijrzgfCvwZwA98qr2DKGig+7Fw6o0aiavgRmi39jER4oLlBwb/3RkhT9XVD
         LcXL4Zv/r12KNhKk3I3qhYy5IItnsLvamGvzSBTB+esIPgIhNm6ecfTI76i3E/tR4ElA
         qEvuCHgO1Hpcy4KEatnLCq+ItrztoTrtDnU6Rdml89JEPIw0/lOitTF9TloMo06apWb5
         GQyu4zG9KfT8wEWIfUllsEbBggvkVIcPkOSuNxlO5MPamvWSf8+xqdmMVI1aSl+YOsUT
         Frvg==
X-Forwarded-Encrypted: i=1; AJvYcCVXXPUb065WGTmXmHbBekdN28EsVPRjewa1Lq08AyaIs1cnrw+htaiKcG74r5Ck86j+tW7KnoWzFIU6ZCc=@vger.kernel.org
X-Gm-Message-State: AOJu0YybIcvOuhWgIBflGhtaw4d8/9Us6nfHBkSqJCyuXQ6aEu1pvClm
	mfY2mM7i+Nl5IP7zUdsaPP7Mrj/9fKpeG42VKs4xovcXC+JOK8uqmwRhtC1dxpBtfN+L9LzCqXg
	odkCb4OapKAwcdShgILw/F3Dk7JbFAW5yR2JW6sZaIVAu7MpGa4N0FpLDeSvf0HPYLfA=
X-Gm-Gg: ASbGncuMM1jLZ31Z3Ar/umQ3G8hH7E7QMjkn0eXiQXRHdV1B6OpHJhk4zRw+botTKFT
	noZucE3Oe9eqgKWHXu1Fm4NqNC9fB7kU+KUo08GR8MOvNd2g2Hb+lYk7XEgza42zUodqMsLNn3R
	Stg7Ohu9WZJ7yyd8MOtetpQ+2+F79+ELkEYuj/SuyPqtOf+Nx2+xFxmodnXA/Jc0P93Ay18loAb
	ihc1vF1nYOLTj/P+kFYguepzvTh/WQ1aNI0Nv1tyK6OLl61NpbqJc1PLJnWS7jKH2ugvcRPjVMm
	EU6iFuSh5kxrRfS7Ess9Tq0w8n4mZXBgMBlYRzPjkESxUFGkNpVUN9Gzs+ZzATpVLTcxcSeAs7e
	/KYcd2ekOUURHkwxZwi3/
X-Received: by 2002:a05:620a:261e:b0:7d0:9ded:31e0 with SMTP id af79cd13be357-7dde704afd4mr776222285a.0.1752536327960;
        Mon, 14 Jul 2025 16:38:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE6vgTUK9cbHU9/fu7xu5UC9MgWnhvrvZKB6D6M0lFax9GG6pjPJlqFz9LcPg7nXnR+3oUNPg==
X-Received: by 2002:a05:620a:261e:b0:7d0:9ded:31e0 with SMTP id af79cd13be357-7dde704afd4mr776220285a.0.1752536327341;
        Mon, 14 Jul 2025 16:38:47 -0700 (PDT)
Received: from [192.168.143.225] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae6e8316b60sm887600966b.184.2025.07.14.16.38.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jul 2025 16:38:46 -0700 (PDT)
Message-ID: <c379aad4-96f6-4134-8b90-0f1eec8001a3@oss.qualcomm.com>
Date: Tue, 15 Jul 2025 01:38:41 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/14] Various dt-bindings for SM7635 and The Fairphone
 (Gen. 6) addition
To: Artur Weber <aweber.kernel@gmail.com>,
        Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
        Luca Weiss <luca.weiss@fairphone.com>
Cc: Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Robert Marko <robimarko@gmail.com>,
        Das Srinagesh <quic_gurus@quicinc.com>,
        Thomas Gleixner
 <tglx@linutronix.de>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Amit Kucheria <amitk@kernel.org>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>, Lukasz Luba <lukasz.luba@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-mmc@vger.kernel.org
References: <20250625-sm7635-fp6-initial-v1-0-d9cd322eac1b@fairphone.com>
 <aGMI1Zv6D+K+vWZL@hu-bjorande-lv.qualcomm.com>
 <ee0d148e-71cd-4136-b3cb-145566abdfbe@gmail.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <ee0d148e-71cd-4136-b3cb-145566abdfbe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: hsuX5Rh1hxvVB1YH-FShoJyDfyR-E5C3
X-Proofpoint-ORIG-GUID: hsuX5Rh1hxvVB1YH-FShoJyDfyR-E5C3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzE0MDE2OCBTYWx0ZWRfX3KA66bqluC1N
 QHQHE4oJGVVev0Oenf9WfoaR/NhLnR56jJOgCiZO89MWqJdxlFWHLtoUI02krNqtAjd7Lm3MPx0
 Z3NgFLAlhEb/KZBSfFLsV8+Ox2MAAjzH6dFJLKskjj6ps9PBm43v/ZUwbZNZGeDnvAY6MdtL3QX
 kDNdIVOFGdHNjVgrKthBSSSIqpmxSYO2Ji2yvLMpIzEGs6VCxsWtrZrHX2chNawlVrtL+KjBrhQ
 QMrHn7yTnObIEr6Xn4y0HY4R5iWCL1AklAo3E9gEJGCJpPBtr32xpSdrY/9CHkYwxNapXqjmLin
 JSEoLUp6/tXdbTN4CvcNxdYNiYsjotpZmXbXnUyTCatz88K+lZ+cz+Rl/kHhTFezRRD/7GBPWjt
 4+tWezITDPkaGcqdr04dxwaPRBTOw7p/jN85K3Gz0xblKB8ny99fAObY+iEk2OW8imms+mob
X-Authority-Analysis: v=2.4 cv=CJQqXQrD c=1 sm=1 tr=0 ts=68759509 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=ySytLBbe-S1-HUGBodAA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-14_03,2025-07-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 mlxlogscore=999 suspectscore=0 impostorscore=0 spamscore=0
 adultscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0 bulkscore=0
 clxscore=1015 mlxscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507140168

On 7/14/25 8:13 AM, Artur Weber wrote:
> On 6/30/25 23:59, Bjorn Andersson wrote:
>> On Wed, Jun 25, 2025 at 11:22:55AM +0200, Luca Weiss wrote:
>>> Document various bits of the SM7635 SoC in the dt-bindings, which don't
>>> really need any other changes.
>>>
>>> Then we can add the dtsi for the SM7635 SoC and finally add a dts for
>>> the newly announced The Fairphone (Gen. 6) smartphone.
>>>
>>> Dependencies:
>>> * The dt-bindings should not have any dependencies on any other patches.
>>> * The qcom dts bits depend on most other SM7635 patchsets I have sent in
>>>    conjuction with this one. The exact ones are specified in the b4 deps.
>>>
>>
>> Very nice to see the various patches for this platform on LKML!
>>
>>
>> Can you please use the name "milos" in compatibles and filenames instead
>> of sm7635.
> Hi, small half-related question - does this mean that future Qualcomm
> SoC additions should use the codename for compatibles instead of the
> model number as well?
> 
> I was working on SM7435 (parrot) patches a while back; when I get around
> to submitting those, will I have to use "parrot" or "sm7435" in the
> compatibles?

If possible, please rename it to "netrani".

Konrad
