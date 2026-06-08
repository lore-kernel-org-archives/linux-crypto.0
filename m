Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C9F3ACF14
	for <linux-crypto@vger.kernel.org>; Mon,  8 Jun 2026 18:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780944211; cv=none; b=ZyEy2qFMPva3m8vormCPmsiBAwzOgxxYT63FvKxc2lS+OlI5eHUW2OLZkaTOIk0uwsqXHN7i8Qe34LWTGL8oq3CsQdtedjj6DqUgk/OzVD5Fns3SYlaJKdf9FVdEU7uFuoJ2n+b0ZDHD8ij0klfmDIoTqQVTZqOZHtb6WSdm6vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780944211; c=relaxed/simple;
	bh=XrTiGoAfj95ZNVlfxHtjtlmUqJv9XRx7IJtBxarrPnQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r5zIZB1ZG4JK5jeYdTyzddChJVQK0osrt2WGPG7+YJIAKtRI/iE4ZbHMlDNEQuZtepgVtPq7P5m21NreCNwcEH7U78NRZpvUZ+lrjvCktttSCnhT+6gG1qDMzZCszfHx9A/W/XwwIfhTEGljEnZV7uYxEuCcWemItAVo1BNBdXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Vb+5NiyN; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=U/ESYooL; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Vb+5NiyN";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="U/ESYooL"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 658FFSWi4008451
	for <linux-crypto@vger.kernel.org>; Mon, 8 Jun 2026 18:43:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Plr6hTzFD6LbDZNeKPjpGhAAeO93r9oSiZKDt2c59H8=; b=Vb+5NiyNxznEyJtl
	l4PuNB9RZ3Bv0pBTGl8aCbsRL3qwtEfljk5lF4r1QqZ7JPnEZRiNIxs1IPce6/LL
	C8hBPQwEanaLG/qn9mtl0SWguf+ZmtMJDKFlACLCn+6pS+A3mHf3+zDxTqB4gbOO
	b3tlHTLUBJmIxK0g8ZaLf9C2QUJsNkj7e9E+YmEiIeF/Bg3WOstY+kfdSdGv9iwW
	dDGhOAj4MopmEFvnK+qq6SHxKtdeXJ2ImhbVh3PRWvJiR+YFGbVgyvBX0jQNLyHy
	zMg7j7dnVW9gRG14afbcmBNP13Ax551WjN10pve/hMCATRXT1ffrMjeiGu/ksyLK
	F4fBuQ==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4entr0jqtr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 08 Jun 2026 18:43:28 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2c0b35fa876so57731545ad.1
        for <linux-crypto@vger.kernel.org>; Mon, 08 Jun 2026 11:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780944208; x=1781549008; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Plr6hTzFD6LbDZNeKPjpGhAAeO93r9oSiZKDt2c59H8=;
        b=U/ESYooLWt5YuqqNIv3+iVkXk4HbMOu6MOXhWXAyi+D22RTwyR5cSpWACmRk1qn3FN
         lOYFEF1Vwr+9dFL1gyWpfQwISl/1sWb50bexRI0fGO5td5zH/xc+hGESvO7RvV7cK/GR
         XPlhWJtbc4eSnyNF8ipcA27JY8U8/SIfMbARSvcaa7JEjkFgKgLJbDktI/QxR7vjtl9m
         cgQONgXZJ/0tBoxAtnqM/auvFChRwBL964PgkFF9H6HFkv6tqqiVwRasYWsqsUE3a+DF
         UN3xm+h1gRH29H76rI/+gQhuPsfOQ16jepOeAEQEteYDqPV7W1V8t5kELNgWS4vFg9VC
         lqgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780944208; x=1781549008;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Plr6hTzFD6LbDZNeKPjpGhAAeO93r9oSiZKDt2c59H8=;
        b=ZlQQuBYeR4sapB//39Kg/AZ9TfSvw3zyvpMimpkVMA/Jq42/pcb9gUGQ8MqJLlIuae
         gi0Aeu2R5D1udzjPtKnjJI1MaPpxrP1+HL/r9XrDfRCiZzoR2wKa7sEOFl2VWHFgo4Og
         OPvYNqPWP84AvWTUJyuCqjhYB1LxucvPqrrstF8LOaYaOvO+fFGHF61i6z+VoOa2EM14
         PC3eP0lSELvdujMVSufgTl1JHvc6+ngyDc8L7zaZ+PSW0LvKnACFrLapD9I+bv+8V/Hn
         xZnokeroWmDWsc+KNY1qBhP6L5N2J+Yq6PL0FSDZqLANZbEzA0UQ8DnIipkSePgMuZlx
         CWqw==
X-Forwarded-Encrypted: i=1; AFNElJ+IN4x3y2Ojv8rZiDItQOmxmjCVSq5PnmZehdxGXXn5xAS+5DQ4RBBp3szADWyCH1OcbFezPeQdUWDsyT0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVpmqsRs8JyGJPkv3OrTqojg3jWxYkXFxErYnnFR36Shq8dAsS
	lAvveYfov/c943/BraeieYKEl78G2LWmtkvT10On8lYnWYlWqOeQ/V+Eb4BnMz7+nIpklI4uE2N
	sqz58IyOgm7obVmd5sz4YpmNClTzrgbQU6ttCgKRdf1aI3uDLZJ5oaSIJmplNEDuI5bY=
X-Gm-Gg: Acq92OGGg598NMJidm/1xP0IF1QTKS9QrsqQYIe3/nVyV7keFGUQuWKz861gdk1/d1x
	5NzDGbzQ/z2THVAgKTSYzhQGc9HMsf3/K5OnHCH2OGu6OlRi6BtKh9GvBC4hKJYzUPPyHs7v1HY
	rbjKGeLsPOheYumcYTiJrqdUWM1lB/e0LWnJXC8HrNMvJQc0/bmgv3dI+pus6AMHcXyZULRhihS
	+iQETh5wxIR0TY4UQUvM9YhgbPzoZNdVjjobjPj6Q2w8nKCSZtCpjiparayWPT3obUeb2KkeOZx
	ID7gtNyIR+BKf76a9N+pdIdbotvNFPn63fjQ9YFgEjXMwnSuMSjQar4Wav0TwKAVrOF5XLXy0xr
	bCnidbS3Q10yNnlcBU699zyi3HLpjs2Cql0d+e4JqZ2vMWs83kPlcN35WBuTHUCQ=
X-Received: by 2002:a17:903:244d:b0:2bf:800:19f8 with SMTP id d9443c01a7336-2c1e7e500eamr172871555ad.17.1780944207918;
        Mon, 08 Jun 2026 11:43:27 -0700 (PDT)
X-Received: by 2002:a17:903:244d:b0:2bf:800:19f8 with SMTP id d9443c01a7336-2c1e7e500eamr172871105ad.17.1780944207411;
        Mon, 08 Jun 2026 11:43:27 -0700 (PDT)
Received: from [192.168.1.10] ([182.65.158.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c16649fcdfsm245047595ad.78.2026.06.08.11.43.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2026 11:43:26 -0700 (PDT)
Message-ID: <11c2d639-d2b8-487f-b627-f507bab25d60@oss.qualcomm.com>
Date: Tue, 9 Jun 2026 00:13:01 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] dt-bindings: dma: qcom,bam-dma: Increase iommus
 maxItems to seven
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
 <20260521-shikra_crypto_changse-v1-4-0154cc9cc0de@oss.qualcomm.com>
 <20260530-spiffy-glittering-quail-dff199@quoll>
 <289a5bca-5491-4fc2-92d9-1102aa664021@oss.qualcomm.com>
 <f9a88104-9292-4cef-af48-58a722194b4a@kernel.org>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <f9a88104-9292-4cef-af48-58a722194b4a@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA4MDE3NSBTYWx0ZWRfX1Bc1pfInVieh
 Ev5A4tec2Hx2NoG7Eb2xV3CoNQepqNJ49o6h3AsQNUxbN6mB81iJ2nlJuaRh0Ra6AEpqOHivoLf
 M2DtglK99vvMFsb8vuNQhlnYpklSxdm+3r7CS7lrEd4Xj29DtmTr/emaLAo0PIJ1BjtChO4QFwJ
 9Wj72ZrCfqToEjjwN/HxY4NRwDPi11QaCxbFTe3As+jlcNQTTNZjgGZ8hnRJVYjJkaXWNR52rUI
 iPtT2kqgpWXWQdy2jLFaaCH392ohu9ODbjb68owk3p74kKAqMGytwKne/l68X871QoNcnEgpd18
 bpCgUNiDWFjLtLLwSU0d3Zlz1KdluLxC0j+yuET4pENKG9U/AKFoeEM6u7vCbLq9xxgTrEVBSS+
 Mc+i6yjbnsy55Xxj/C7//tNdyODNvjSxdrcCS5S1+Ylg+N0gwIRrAgORgxsO4OjpxzXElwoJw7T
 RqLZi1V9TVi6N7JcExQ==
X-Proofpoint-ORIG-GUID: R4TX-I5gWhic4Yc-r7-_IVzD05vtLP3Y
X-Proofpoint-GUID: R4TX-I5gWhic4Yc-r7-_IVzD05vtLP3Y
X-Authority-Analysis: v=2.4 cv=VowTxe2n c=1 sm=1 tr=0 ts=6a270d50 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=wKfY90lum8W+SP9crs9F8A==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=gEfo2CItAAAA:8 a=3IJvv1DdaQ7zVQMhPnMA:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22 a=sptkURWiP4Gy88Gu7hUp:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-08_04,2026-06-05_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 phishscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 suspectscore=0 bulkscore=0 clxscore=1015
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605210000
 definitions=main-2606080175

On 07-06-2026 13:43, Krzysztof Kozlowski wrote:
> On 06/06/2026 22:59, Kuldeep Singh wrote:
>> On 30-05-2026 16:09, Krzysztof Kozlowski wrote:
>>> On Thu, May 21, 2026 at 06:47:11PM +0530, Kuldeep Singh wrote:
>>>> Shikra bam dma engine support 7 iommu entries and not 6.
>>>> Increase maxItems property for iommus to pass dtbs_check errors.
>>>
>>> What errors? There is no Shikra in upstream so how could we have errors?
>> dt-bindings updates are prerequisites for the DT changes of ice,rng, qce
>> and hence updated bindings in patch [1-4]/5.
>> Also, the commit message mention about shikra and DT change is also in
>> same series.
>>
>> I hope this clarifies.
> 
> No. Please explain what errors we see now.
I need to improve my commit message a bit.

Since, shikra defines 7 iommus entry and bindings say 6, observe below
error.
dma-controller@1b04000 (qcom,bam-v1.7.4): iommus: [[31, 132, 17], [31,
134, 17], [31, 146, 0], [31, 148, 17], [31, 150, 17], [31, 152, 1], [31,
159, 0]] is too long
	from schema $id: http://devicetree.org/schemas/dma/qcom,bam-dma.yaml

I am attempting to update bindings firstly by increasing iommus maxItems
as a preparatory step so as to introduce qualcomm crypto DT cleanly
later with no errors.

-- 
Regards
Kuldeep

