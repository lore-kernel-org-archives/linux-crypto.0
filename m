Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794483066;
	b=afVhSZgUZCVNHhCsPNaatiaMOEOo2lC5v9rpC3/DZaq+Zq2Sqc8my0A2mc39jIqkwZIL
	 BvVVnvJxBRboqlzjqjvsAf+aGtqq5Gj306yHocSNyWcfroIViR7evdI+J8Lh8zuep4M8g
	 RMnWWYG21N2rOoZSGSnJA+itjxWGG+LbVIvtY9afiBVpfHBfLBuZSdeWPKPel+2KvPnOt
	 Rr7LBVE0XX6h3QfvIMDM6OaKjtdeByQGKFUhmc9arYthZNPnJPwOi4VkWpP9JMoETr0kc
	 NILnMHgtoeXCKJ9hsOP0iB0eCfq1rJKIvA5muMCxoOoTmiO9tb4pXjoCYabAzHw4+dA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794483066;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=QtaI6ngPGNeT1DD/YyV2Ag57CpUXifqmSKUI2JI3pK4=;
	b=ETpa2GC06vVHTy3/91i9Ep7IUy3HSFRkmF0271dH8NqxBWX30/c3Kz0BqmFwo1apg9V6
	 REVF9fGkOKQs5U74RVswHt0dlKTdY19U449VUeWdBsshf7irEajPhfOeOy2d6Vqa6yFoE
	 08yiYsYSTMQi7E+KdK26xGU26NbFqX0OFACKOhPH6czO1dGgtqud5monVKc/zzgKQXUlH
	 3QmwSXSxuW0fM4zXITJvzxX8qXPZFM45fWIem7ttObZgGS+1kId7gFfZubBk/BNSPw/2y
	 T9JoPhB3XUDm66ctarWz1I64E2qxhBlj9i+DLQa8cgkinpE6wTLaPGhJbSazvVGf3vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=noy8g8YV;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=IHaDqmdR;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE05606A8BF
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 11:31:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0EE05606A8BF
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=noy8g8YV;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=IHaDqmdR
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AC9E5Em480536
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 11:31:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	QtaI6ngPGNeT1DD/YyV2Ag57CpUXifqmSKUI2JI3pK4=; b=noy8g8YVf9J5rPmJ
	UwPBDCfjMPKR0RmF3O1R4xqqK4215RtxouUI53FnNoC9ggbOyZ5yfKNhSw5DT2vj
	pJ93GKcm5Y9lx/YDIYENjiInMGcgL3vT42v2b06iyMnGxn7bJMzvHKpfRCXCmAZG
	vCvwppkw666OrlXoRusHBZhvx5z6UP9TxyMed4h1lO5cPZWrwWQ4D0iJfhYo9d1x
	Mr9Apx1eNK2WCkcr0PwgIcd9V2J57kweSJIiPXIyezzIyYW6tnFvB0rSgp1PBssm
	xD2VZGHTH/CIpA2JeqyCllSSay5jVvY8YyxeUoEpX5C2CgGb74roTmgdwvZJ8CtA
	+nBKxA==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hwan4reve-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 11:31:04 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8b7cc3f8a4aso3281916b3a.3
        for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 03:31:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794483064; x=1795087864; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QtaI6ngPGNeT1DD/YyV2Ag57CpUXifqmSKUI2JI3pK4=;
        b=IHaDqmdRB6t49l+r1ABPC0H/gRzWI0foqbJXdf3Oi3OOXaWCt2T/zlXktJC4NgHzpB
         WZH9o36gAAP67sG4sjCZKN5Iw9eaEgNuFocH6wKP0uEM3RCyM8W6j4bOhCjIu5kqQla8
         aPMMBnsP1KanCG2p8st8tYxnynQWmMu5vrUTmXf1rUBcHUqQk/dv1jLUB0WyC5Vu0cxq
         +6AycmpDTvbctcQNlp8nc4uYKSzOQuSBtjyiSdEXkm+NF5SkOFwGWbOUtdaLj37Bm1sR
         owPaLn/N8ZTBBLgFJeLPXPd7rY7tDvv8EleuhMyI0l8wqkO9GMg879ope2z8Y3IBg8yE
         nxJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794483064; x=1795087864;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QtaI6ngPGNeT1DD/YyV2Ag57CpUXifqmSKUI2JI3pK4=;
        b=QQHFU4C80WRTuWnbkWvZCgHD1c9PxAnvSdTM6bTxphEEUndOYEzF+22HIjjikR+h6o
         J4nHk+tI86TrtN+QiVbAF972tSxnH39fhSzj5F6WoNUpVAS9yNsY7RdWg8JA6HxkjudG
         j21TMefE/LMLvDIqCdq6grXw4wNeZuc68Yev5+Q0inKc8fniqNeiFSG7z5rPvEKUApgx
         TO8AEYgzwfauYav9SM7Rw79JbKSEUkSaclIvBB4oFqJ3oNLeN7Fp9e3C+wcVjyG4LNyv
         oR5oy2DvWSMGVpZASI5klHjCnVPMGvohzuaZuU4yRuhHANf47NeHfCd2wUjaUHk+47gz
         2JGA==
X-Forwarded-Encrypted: i=1; AL+hErEwS4MgvFIR+9slwp5zUrkBteNdpF4Pxr9mCMaG6m0bswAFp7M/JpXzxDgW3EvFbU6B7RM70aRTBhCepYM=@vger.kernel.org
X-Gm-Message-State: APuU4Z+zh7nx+5+QU4NbmmmUmy5cvYcAqOuLjssbyFH7zjnXfXdOMZ1l
	9eiZyshvlWXp0jih7V3jMvVAYxv3iQVGR5aDZD40jvcwNAn6PLtRbrkQx8m38YNL/e3bztCk2iQ
	m9opXhzCkqwInQezGqRVZCwqEclHP8a1qwmlpF0O5gPOb3V39mIFtQu6lRt6M2Y0hioM=
X-Gm-Gg: AYBFou3Stbka9eWgQk9tmAw9u2q1bg8z5PATIymKsyxyYSR1+9I8GhvQmzjuV2f5YXu
	8xMShOgFbr2hGJvWWBgJJ/u+prHXDSHnnkGO3wrF5tspkxeleNF0yffS7mrvyfpyQ2op/ruf6Ib
	OXodufWQ+tOFsfnscHRUGZ70asZwTad1BQjTQBNEwutn1Ox0oAGQgdzswK/uHk6TNbdWyLzgtLg
	WkXEd28l3RSOdxj+B4r/irHXFFy86FrTY7vhKT8plUyRRQgBc+urHQ8f9m0WiaXlYN/0z+9PPZ1
	gGFaztFZ6dyQ3bOHyJpSZZMotx35HcAERA4sBh5Ew8kOaXlgaAaLSzi4LehLSv7liVIsBG2g4Ox
	C7QWZzduz1x+viza1dNJZPl2ZhTTzcqpTkI0VDaMAyGCWWvPFx1KQYTmbtgGoyhhcZMyBhSMccd
	NzJ0Q=
X-Received: by 2002:aa7:930c:0:b0:88d:4b30:1c11 with SMTP id d2e1a72fcca58-8bc19dcf4eamr4997935b3a.6.1794483063965;
        Thu, 12 Nov 2026 03:31:03 -0800 (PST)
X-Received: by 2002:aa7:930c:0:b0:88d:4b30:1c11 with SMTP id d2e1a72fcca58-8bc19dcf4eamr4997900b3a.6.1794483063458;
        Thu, 12 Nov 2026 03:31:03 -0800 (PST)
Received: from [10.218.31.125] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baaae3e110sm3264720b3a.36.2026.11.12.03.30.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2026 03:31:02 -0800 (PST)
Message-ID: <172229a8-a4c5-4103-a38b-e4cce3f18718@oss.qualcomm.com>
Date: Thu, 12 Nov 2026 17:00:56 +0530
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
Subject: Re: [PATCH 1/3] mmc: sdhci-msm: Enable ICE before enabling crypto
 support
To: Eric Biggers <ebiggers@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <mkp@kernel.org>,
        Bjorn Andersson
 <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, linux-mmc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20261022-qcom_ice_pm_enable-v1-0-f7a84086c651@oss.qualcomm.com>
 <20261022-qcom_ice_pm_enable-v1-1-f7a84086c651@oss.qualcomm.com>
 <20261024182904.GD2553@quark>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20261024182904.GD2553@quark>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: _FgWVMkDjT7SDgRoJfmW42Um74QdBLit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDA0NSBTYWx0ZWRfXyCrFmrV+RthZ
 1LW9rlmTtuzFMYDZUqcGVbHEbo0TPO3ZpiIe/NhntKN2Oj4MaE4IFN+Pupeyvwk4Rb4+Y7EI95Q
 5yJEGhtNLBsupP3F24qP99c0ILqIBI4=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDA0NSBTYWx0ZWRfX92y08r/ielO8
 3Ou3i4vtgVDArbRlK5x1t5uPljxZSquo4kCoBP/iYJIeBDYgQCKd/qPG66uebhFsx3BWtExwZqm
 7gsdmiZJ1LJUM8srBL03KualyGe/P7RXnOM8kV6FeUkitk8+VVVSYQ9meeYCt2w33xAIsfPsWnt
 iFZDkTPWbukMk1N92xs2BosdMnCkCNgmiZ9KB7W1Unk4cxKp5lBE/8leN45xjAQtyEF+CUVxA/0
 sMgyyPrg89sHC/bYKvHg8Bd5jSRZahyPSOgsXSm+9foo1e0f3S5iyLuVvMfXIFXW9h6qNgdt904
 l2W3LsiANclAgDcdUPnBBibfjvhxFKLK6vmmjulRR5UDgXTtrqXmdhYYpqnWUvfvxhZsM8EIiHu
 DO7cTUgCosG6XMvrpyMp8iloIBYVdfCeeht/xCa0YeaBa2Gl/y6oIOTMzrxlnMwpHI1uve3F+0l
 nYRkSJwzcMgoF693IEg==
X-Proofpoint-ORIG-GUID: _FgWVMkDjT7SDgRoJfmW42Um74QdBLit
X-Authority-Analysis: v=2.4 cv=Gd+CDgXL c=1 sm=1 tr=0 ts=6af5a378 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=fvpZdPw5ZEdYVRYleWAA:9 a=QEXdDO2ut3YA:10 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_01,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 malwarescore=0 phishscore=0 suspectscore=0 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611120045

On 24-10-2026 23:59, Eric Biggers wrote:
> On Thu, Oct 22, 2026 at 03:21:50PM +0530, Kuldeep Singh wrote:
>> Remove ICE enable call from CQE path, since ICE is now enabled
>> during SDHCI crypto initialization only.

Sorry for delayed response as I was away on vacation for more than
2weeks and hence couldn't catchup on the thread!!

> 
> This change makes the low-power and "optimization" settings in
> QCOM_ICE_REG_ADVANCED_CONTROL be set only once, during probe.  Is that
> correct?  Those settings never get lost at runtime?

Yes, the low-power and optimization settings are set once and are
retained over suspend/resume cycle.

-- 
Regards
Kuldeep

