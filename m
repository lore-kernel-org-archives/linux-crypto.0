Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4C338F25F
	for <linux-crypto@vger.kernel.org>; Wed, 18 Mar 2026 10:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773830365; cv=none; b=nMApKzviNJ+QRUq2tndeXsa3pxJlizucNs1zUbavnQcd1EZWavTHGTNULCCIZardUzX3Qte8uMJrNaj9FPT71Gw3JpBO+u17sKoV2b9n0Ny01n2HG+DH4whkXi3Jigt1PY/0sK8KCOFO7xGOsv+zs38ZZWCczm1UKBUig0Y3oIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773830365; c=relaxed/simple;
	bh=Lu/1Gg8AcMocYblP2/duop3ZtFJxThXGBBLZjOrc7z4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QcV1R1fTRdk6VWEEHa0fJ3Mz755Mnr95Gx2lgBhWMKsyVOvbGCOso72N9LULbZsObDcwXFaNYaSBJ+rXRoTZJtGtnCoJ1Gav4V8n+CidCcxP53NmeLVt1zH5lPufC2CR5skITqmgJTdyepJ5RydswB0/22jNrK0HXW4U5pFJqk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=GDu7bQQp; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=HOQp9xE/; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="GDu7bQQp";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="HOQp9xE/"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62I9N3aE3358710
	for <linux-crypto@vger.kernel.org>; Wed, 18 Mar 2026 10:39:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ZHCpdutiIPCDZe+ZxRsP2OGSZ1DdSpbzypkIBafBf9w=; b=GDu7bQQp8kU3xilx
	vimp/0nqTr3r4KyTjQaIfFFSxP+/Lpv+Evn806VhWahbu+1rRNhxiauk3EiWKOh1
	Vni9DfG6utPiv9mOeO4nsocC93yZZYTUyn8aqjvvCZWerCiXy7j1vCnnDUZjmgoi
	IHDvtf75wPK0yDFT48penoWismdDG6i2y3Vm0AQsVtN4ikXnN46IrYObXbcUp1K8
	S3hpapmvBvmaak7zibxupSi1ea31CwRmDUV33UIujA9Ijv4Lq3YPajv0VNFR77TS
	qkVQeMTnCDXT5B5UwnQ+Oz4vDOHZ/94/dbMlvllGZlYrj/e/tWEcB4X5hVJkgJOg
	ia5o2w==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cyscb09ma-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 18 Mar 2026 10:39:23 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2b0565d77a6so39090105ad.2
        for <linux-crypto@vger.kernel.org>; Wed, 18 Mar 2026 03:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773830363; x=1774435163; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZHCpdutiIPCDZe+ZxRsP2OGSZ1DdSpbzypkIBafBf9w=;
        b=HOQp9xE/ByrxTW6XIOtfA87RRgnpGKv2VqmoakFsXwwbDp9fZTHLpdYD11m/IQ+eZg
         pDKc6fEyMqJ8KEyXaGO7clwYqV06JTlHrQy01dRi3tvhrzQrEaxecMQiRb6Do2a4+Trm
         QD35dIvhiA9w2seR2ndSs6SPPnHUpSJgfQqHza0+d8GJaAshB013bGKPPLItJEFzU+0S
         AW33tv9NisbbJLTh3zJgpmR0vN5+XRw15+4TZqrcutqtQ7ABnppUDYFRoN0o/aUgM1OU
         vFHbWMf0dExeTZ9hwP845mOXfpSIR0pjXPWIIKMeTjy4XUe05I8CHgYXyp63fqpVMWBz
         OboQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773830363; x=1774435163;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZHCpdutiIPCDZe+ZxRsP2OGSZ1DdSpbzypkIBafBf9w=;
        b=j6Qe+5J6EvFcvdplB2zXJElhabim5g0PHNZ1JVfDLKZwLHL0I0EBV02OBcAlSkT/JV
         IgMf7q5N0QOnwvH3SGUbBp1raDHNAWvDTA1Gzlru6yn/JS0F49iGn4ZxCtXrjDBaffrW
         9Fhu7qW6KH7AX9HL06ox/wEmmmrbR3UvC+m1/V7iF781luZqRDQfYMZrRgBR86uOOKU8
         vAfR9i+mMNP3sumfTQAQ4Ud+poMEC3HXvPrqDPoxEN6uGzhrV81RJMiS2YTDMRuZij7x
         WSPjeQ3utn8ioTgYNlkKEvI3L9TRIc9TymZkdT993klChh8MQCg3rAPxEVXlAfco1L0Z
         qfMQ==
X-Forwarded-Encrypted: i=1; AJvYcCVfzgaF/AruxsvcLroYzdy9kvHvtX51eNMLA7///gTBrxILPxw9MGWWZJRsvtkhCksp8VyMrwFbWp+V6Sk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTCwVZJUL0Y6bTDj3qzvePsIJPIuQ5rDTsmdhpwg/nr4f+Uu4Q
	Agyg21OaL6p7XllgeO/RUroPqW98WzAsJDe6zkgqhImMZ2ZhyDExmEBKPKC5llEyMaFXaDOwFq4
	p5ugmu03tnjsKxdlbmyri+h+pwROjPQgCTO0kdzdg1+DpSqWlYifxZ0yYQueBUhRIKkQ=
X-Gm-Gg: ATEYQzwhOi/CFmMHyThaykjroQrMvsCByaoyHuTgjhuzmilN3Znr2Vre9Lc4BS/BWX5
	HLf+RNNWr5X+R1IkbI6s1e49eZsPzr/CA6Wst0EqcUyHymbiiRUyCQ+gSiohwMd1yw5Pl2deU7G
	IJUe/YBwNtx/6G0/U0YH2x/zreJFtEtN9A24aYnbtSddhj3/Rrl2n86YewEjaPA0eyVXqS2U8nm
	fGPJcA8aTGxMPnZh4idEoslnAdhgEomUr6piXLk75wzmWkMSIunapDGMZo/pmgdOHBfwKT8wE4H
	2w02pd6cwTerQwGRTGLQ8AeFpoGtMETSCIK92kSQE+56ti5mqbiM5PpCGBZ1NQfUp6dkvcXt2P1
	4mgr1FqRRvy1nwonhyFctOFHCuHWiO5+Chk1qmXcWSvU6tmHo0eg=
X-Received: by 2002:a17:903:1112:b0:2b0:5be9:f423 with SMTP id d9443c01a7336-2b06e40e3b2mr29694965ad.43.1773830362704;
        Wed, 18 Mar 2026 03:39:22 -0700 (PDT)
X-Received: by 2002:a17:903:1112:b0:2b0:5be9:f423 with SMTP id d9443c01a7336-2b06e40e3b2mr29694415ad.43.1773830361919;
        Wed, 18 Mar 2026 03:39:21 -0700 (PDT)
Received: from [10.217.223.121] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b06e419270sm21556485ad.1.2026.03.18.03.39.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2026 03:39:21 -0700 (PDT)
Message-ID: <8d210e75-f471-484e-8a0c-9b8ee7900106@oss.qualcomm.com>
Date: Wed, 18 Mar 2026 16:09:12 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 12/12] soc: qcom: ice: Allow explicit votes on 'iface'
 clock for ICE
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
        David Wronek <davidwronek@gmail.com>,
        Luca Weiss <luca.weiss@fairphone.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Melody Olvera <quic_molvera@quicinc.com>,
        Alexander Koskovich <akoskovich@pm.me>
Cc: Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
References: <20260317-qcom_ice_power_and_clk_vote-v3-0-53371dbabd6a@oss.qualcomm.com>
 <20260317-qcom_ice_power_and_clk_vote-v3-12-53371dbabd6a@oss.qualcomm.com>
 <8863f38b-51df-43ea-995c-08b9fb04f4dc@kernel.org>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
In-Reply-To: <8863f38b-51df-43ea-995c-08b9fb04f4dc@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: EyaVCAueFWn0_IxFOdheA6di3cv8xOxx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE4MDA4OSBTYWx0ZWRfX0wzSbqqNaZ8O
 VxGbAll3i3TMiYBAY4MCaA11O+2oxLB//2pX+QXhgQszbZYEbOkzEaic+MkUlnR/f3bqSliVQuv
 Eizqx8wUnzpKuoRb744ycA8tKyOs5LoOuRqglP43rBAmw0/9prslssQtzSAv5NnT7HOx/6PrZmf
 /un9VAE7R9UvCgmb1yV0C2PZDN76UVtCaq7V6FpHeuBstYkTNkEURrh2oNIVKc6qrgoi3+Zbm5D
 pGoMPWYe9Gj9SgL2UkQKxpxPKJ9UdEU+j5lHjsJ4tEj9Ck7PaUVu3tg2uTw9LEd96btbfDmH+Eb
 sPklDswksMRR2zjp1T+ByQafBVlIYgZulxPcT9AyFusMpFv4FdT8oRdk+32NIz8MHyYXLFgxeLQ
 5DDciWz1YeJX1XkG6HZzQyYZwCuhsbB9v6Lm3VNBkNZb/Rd2C/FWMg18uzsUBlaYQ8pXetU33iq
 cICRSiUJVg0b8fTVu5w==
X-Proofpoint-GUID: EyaVCAueFWn0_IxFOdheA6di3cv8xOxx
X-Authority-Analysis: v=2.4 cv=PtCergM3 c=1 sm=1 tr=0 ts=69ba80db cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=EUspDBNiAAAA:8 a=7T9o6mVONip3bYQ_lJkA:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-18_01,2026-03-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 adultscore=0 suspectscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603180089



On 3/18/2026 1:03 PM, Krzysztof Kozlowski wrote:
> On 17/03/2026 10:20, Harshal Dev wrote:
>> Since Qualcomm inline-crypto engine (ICE) is now a dedicated driver
>> de-coupled from the QCOM UFS driver, it explicitly votes for its required
>> clocks during probe. For scenarios where the 'clk_ignore_unused' flag is
>> not passed on the kernel command line, to avoid potential unclocked ICE
>> hardware register access during probe the ICE driver should additionally
>> vote on the 'iface' clock.
>> Also update the suspend and resume callbacks to handle un-voting and voting
>> on the 'iface' clock.
>>
>> Fixes: 2afbf43a4aec6 ("soc: qcom: Make the Qualcomm UFS/SDCC ICE a dedicated driver")
>> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
>> ---
>>  drivers/soc/qcom/ice.c | 17 +++++++++++++++--
> 
> Why the driver patch is after the DTS patches? It is explicitly
> documented as no-go.

I will re-order this patch to come after the DT-binding patch and before
the DTS patches.

Regards,
Harshal

> 
> You do not understand how patches are being applied and you think you
> can fix inherent problems in bisectability by creating incorrect order
> of patches. No, you cannot. Read maintainer soc profile and entire
> development-process document, so you understand how patches are applied,
> what are branches, what is current RC and how kernel is effectively
> released.
> 
> Best regards,
> Krzysztof

