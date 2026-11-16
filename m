Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794829146;
	b=XvyeTuHNbkaMEWjSNX37LjhB/CxsekKpub1slI4xdLpicrrPGyEbTLsm4pF9GTp38zxq
	 NhunRM20qBQRzYCtfdDLwFR6DsxyLtyeRPHq/bUVEKLFH+kbyDv0lzdkfhWnO83gu3Awz
	 QGNdWMEY++Hec4GycIT8CcZaX5Lo38oxEzdZY+s4AN7O25WYSlPU7oUfIpVIl63s8xy/L
	 466J27VMyDlwW21JBUMjPslNHAlUvbSPx5YFNTkmR87PC1slRQufYe/uPzHH4ytHv2m7W
	 TfsFOcBDmHqkLADYOZVN4G0oKqtdv2Gn59vvu68cglgm0Ui8bGeyVlRgQG2RCiFy9HQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794829146;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Organization:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=ajrBayh+hf9TzW6sC/OulW/Cwr8R6pJ38qBUt0Xogo4=;
	b=zlWZdVW7D041fUTdmJIsnW0kEc0J17RVXOCAuCRTEO5S9pXNLXDFfuKnLk+wF5PjVO/H
	 7kbfuP2rrGIZ9xoowmz4oQO0CG3j6rW9P5g8IKVjoGb32Brq4zGSYv9mkdJDD/rdpOb0/
	 z9g/OoObUacyTawinqs3s1zCciD/Te/rAU0GvEalT84uIXjsKVZ/PGlabpYwFlWHMn41V
	 qHFjGyxPk0C7eOGuKXzpyjIOsBLK+5r1vm/w9nFf5pwbiIrbG0M1WFJ2xLaWhGEeYZvqE
	 yUfVKrjHPxJlTF57G0jFcPzZI95+4qylmRNt2S4V9e6wNOtKfL6vBySX9UNce+4INxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=mYu6QDao;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="V/sT3GMV";
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88DE5606A329
	for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 11:39:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88DE5606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=mYu6QDao;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=V/sT3GMV
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGBLOBK1016102
	for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 11:39:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ajrBayh+hf9TzW6sC/OulW/Cwr8R6pJ38qBUt0Xogo4=; b=mYu6QDao5NgEwxmp
	kQ895IHZ4WAirpwoQZRtpAlEV363O3v8ydCIrYrkRvtPejSH85A2wDKYPOE6ulRl
	jYkkrbsddVvpBo2sgKZWD4s6Ppz1tug3BT9GPInX63LcavJI736NmEGw+vDTfTx4
	zbDobSygfNsdcRW5yaYMfugREWxwp0P/GX4HmFqPKHTqljgXn6mNVl1tdtagdCe9
	3OCPikboIAUzdMLio9ZZ7eerFvFNq4P6xJ3aV6LlzSNblvCJabBSFhrBneJz1A5Q
	L/h7B+D9WLSoUMuGHl2O9OK8vnZn7JN2Yk9JOuQB6E4MqxKmX8kVChC0yO7uVlPs
	wTi94g==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4j0003g8qw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 11:39:04 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3b18165dc53so4861824a91.3
        for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 03:39:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794829143; x=1795433943; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :from:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ajrBayh+hf9TzW6sC/OulW/Cwr8R6pJ38qBUt0Xogo4=;
        b=V/sT3GMVr3QURT3MHZPEeHQHt/LwMDK068LxuSYmDf9+7dzMNtIOdJf+eEZ88U9E9C
         Z8Sgtj28SpTvEtgwXVkhU1WdC75SXfVUlU8ACm0hZSoXB9Tn2D4kg6VgxSwvAJHEovl4
         ESguV6ywuNThGKL++uI6bQo+XfEGMxrt2HChaxANM34/OPXiSqt5VwRIN8AtTOysSFG/
         6F2vVEIsxhh8gpCvsenh5k6uXWq+Rm+cTiiwyoQCP8tcJ2NOFSOHHFAKGL81PCcXuXlw
         74jsdoKyVcs6EolRL4GT0dN6MjGEX9Qd2X4MlkiDZrHqnIUBSskDaQGhCVmGFzXEXJpy
         yoVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794829143; x=1795433943;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :from:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ajrBayh+hf9TzW6sC/OulW/Cwr8R6pJ38qBUt0Xogo4=;
        b=C4O893LUYA40R0ZictdJa71rcM9TNDjyk5QNbTRdny7G6tU6Nq4BvHkx5Pp66qQszn
         ZcJeYrM30MKgr6l0qcW37rw/B+2CBqJMWzTJ2XTet4+kAjbydM7yatCtU/LIOIEUOfD0
         UQQ2KP1/23TelJhhNedQ0eg3iLhgrsoJlNopHQKwQWEmsToC3Zob8MaBPqhmqhlHLLKR
         RKQXoDh073TZZN5aqpQCzTULIUMODwSwha2stLRQYpkIVQ+owh8gA0leXr49U8sDMTcm
         2lI1Tqrtn47eHdpV7XlzkKBRkKe365kNCcpmO7eoQkhHuJJxG15I80MpQ7slVnR6sUUy
         pCtw==
X-Forwarded-Encrypted: i=1; AL+hErGsZOXkF/ZgIZE16/05YolKOb9g720q8hPVdEOanYodQOO+g90r/qhfoxXq3t7eYC1Ezh1em4rGIw4905Y=@vger.kernel.org
X-Gm-Message-State: APuU4Z99e8i58RmE1YT1z52aP2rJjAvR8Wjurc9dKv2l3BXB+AC1JQ1i
	NJfMfg/XOJgZkX3/fE0YWFG/h5AcxTAy26sIEx10f9xaP/xAmplR7cjhak2eHPXU1epdSZilumw
	jatemU0xgTNU7FtsSonQNUmoe9sgljj+l1ye+9OYuerz27vy2W0hWfzGgS1fxIW2V1N+kPamtUn
	g=
X-Gm-Gg: AZFdTZfromeRtUqX3YRX10cvSAN0KjW626gJ6E+uGxYePTzW72ZCd6gixxtaKGcCzER
	OMtbSr2nEd4eQ3wMkkVhoo75GJHjF5BOX3oQFh4l8DF7YZ8kDA8Ip2YuiHZOCz1rA/Eli2g+eWY
	SgFGHA1LZNcHS020711vS+uVVNyyvPyjB3aGEDENlcZltmoTIZHldN3Nnw89y2n6QcfiwWetHN8
	pTqew7QaaaUIJIkREp5ln3n/C3T6Az6mMeqef7xLrpS8lfDDl4GQuzLQWILfcmNNobDrCnDmHxx
	N0mRZx0nYwNg+WD9klsdSbSBQMxCFuEX1aIrSpSKuzcjVvna+ETi+bK9gKbIeS/A0OO5eK0m4uw
	F43zWk+WiVEq6f/k79ap9ursOk/zIWMY/O11IlmpmZE4GHD8UleDEX1kBYDIV23iHK2DiQBz6Xx
	E=
X-Received: by 2002:a17:90b:3d87:b0:3ab:2737:3395 with SMTP id 98e67ed59e1d1-3b1b0a3a2f9mr9515857a91.42.1794829143179;
        Mon, 16 Nov 2026 03:39:03 -0800 (PST)
X-Received: by 2002:a17:90b:3d87:b0:3ab:2737:3395 with SMTP id 98e67ed59e1d1-3b1b0a3a2f9mr9515833a91.42.1794829142718;
        Mon, 16 Nov 2026 03:39:02 -0800 (PST)
Received: from [10.218.26.96] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1aeb17042sm16407771a91.6.2026.11.16.03.38.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 03:39:02 -0800 (PST)
Message-ID: <41eb56c7-b1c4-4077-9778-a31a91002511@oss.qualcomm.com>
Date: Mon, 16 Nov 2026 17:08:56 +0530
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/6] tee: optee: Register TEE devices on the platform
 bus
To: Eric Biggers <ebiggers@kernel.org>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
        Sumit Garg <sumit.garg@oss.qualcomm.com>,
        Selvam Sathappan Periakaruppan <selvam.periakaruppan@oss.qualcomm.com>,
        Basant Kumar <basantk@qti.qualcomm.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        op-tee@lists.trustedfirmware.org,
        Jens Wiklander <jens.wiklander@oss.qualcomm.com>
References: <20261111-ice-migrate-tee-svc-v2-0-29d19f6c92ab@oss.qualcomm.com>
 <20261111-ice-migrate-tee-svc-v2-4-29d19f6c92ab@oss.qualcomm.com>
 <20261113215646.GB35210@quark>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Organization: Qualcomm
In-Reply-To: <20261113215646.GB35210@quark>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: AIPQnXMXOLC3GaTcp96zzt4UxMgvXpIo
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDA0NiBTYWx0ZWRfX+uNWhY4S57P5
 xvZSL01QpzuHlEEXakt8fhHkSi+1p4rbn8y+FJbxdk5BoFHrRCnaCbWKLr5LZgO3JqbB7N6N4c2
 U6/VwB+VmEBt6b3/R1Z11vZE3zTPya4=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDA0NiBTYWx0ZWRfXxyviy1t7Gtvs
 Hi44AnYnobpnn1yx73Ac55FGkWpr+8sb+1KitemlLEpVnEFI/LoCy3r3V7skvVeDQzNRcW4HN4S
 09PZvahRKP1ggSwlSlo+1WFtLVv7yMs7C1PeGF9/Ka6twnP/nBw1q9IggrOHvtPQgHKPHep7HKl
 Bwzg7ZnzMxDSiwtwsF8WOaaIOvN21762AWiiGhfKc23xt6Ebp8NR6nh1eVQv0XS3CRLHTYt65Da
 Y88euztj/Ogi5Spb1/qhphb7208TKGkpUiWlLR/qDEYbGWIUejkDOhPqCJwbgIyBmmdZvQxpJTn
 3Y0IvQ6kESYeVTytq8DAANvXCoL4U6aebUmM9DnMAEn3kmVcV9jswES+gJh8WhANWJ480TjAwX/
 hGiXMeQ6CApDX9hIWhMh+2KESgPetrlMOZ/pzNJ+tvBUS42Zb3XjNeCCeZDmHmtgTP1EEwkSlIb
 lvsNBLm08PE78EJyUJg==
X-Authority-Analysis: v=2.4 cv=Z4N5j3RA c=1 sm=1 tr=0 ts=6afaeb58 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=yq9iaoSgN4BPWgwdfiYA:9 a=QEXdDO2ut3YA:10 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-ORIG-GUID: AIPQnXMXOLC3GaTcp96zzt4UxMgvXpIo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-16_04,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 malwarescore=0 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611160046

Hi Eric,

On 14-11-2026 03:26 am, Eric Biggers wrote:
> On Wed, Nov 11, 2026 at 07:47:04PM +0530, Harshal Dev wrote:
>>  module_tee_client_driver(qcom_ice_tee_driver);
> [...]
>> +module_platform_driver(qcom_ice_plat_driver);
> 
> So is this a tee_client_driver or is it a platform_driver?  It can't be
> both.
> 
> This patch feels like a workaround for issues that could be solved by
> folding this driver's functionality into the existing qcom_ice driver.
> Is there any reason why qcom_ice shouldn't just make the OP-TEE calls
> directly?
>

So this is an attempt at solving the problem I described in the commit
message of patch 4/6. Basically, if the ICE driver is built and probed, it
needs to know that:
1. A TZ is available on the Qualcomm platform. (qcom_scm_is_available)
2. Whether the TZ supports an ICE secure service. (qcom_scm_ice_is_available)

With OP-TEE, there is no way actively check via an API for 1 and 2. Instead
the TEE client driver model probes a driver only if the secure service is
supported by OP-TEE. Which means that you only get notified of the presence of
the secure service, not of its absence.

So currently if you boot with OP-TEE and register a back-end ICE TEE client
driver, and the OP-TEE build doesn't support a secure ICE service, the ICE
driver calling a corresponding qcom_tee_is_available() API on the back-end
driver would forever defer probe.

I suggested another approach for this on a reply on commit 4, where we register
the back-end OPTEE device on the TEE bus once it has registered all its secure
services on the TEE bus, and then the ICE TEE client driver can be probed
when that happens, and subsequently attempt a tee_client_open_session() call
to the ICE secure service, failing which it would have concrete knowledge
that the current OP-TEE build doesn't support the ICE service and so we
can continue storage initialization without inline encryption support.

At the core of it, we have two device-tree probed independent drivers, ICE
and OPTEE that need to talk to each other the way ICE and SCM drivers do.
The right approach here needs debate and alignment.

Regards,
Harshal
 
> - Eric

