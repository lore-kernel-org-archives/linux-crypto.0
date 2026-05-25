Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235E733F5AE
	for <linux-crypto@vger.kernel.org>; Mon, 25 May 2026 10:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779703768; cv=none; b=PfW/yZ4UXuyLLsd3/aX21XvvVSeLm52zKg8Jg0yAaKZvUOXkAbhAloD7A5MkDWico6WukyPDyA9krkjui26robRX5ohKE0G3/wtDdXqZlEbGBvtAmTsgglJGdqE6O/jZr7Fag1aQ9ck9HKKuLdPSgPM0zYrgY7fJLyDYowpitLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779703768; c=relaxed/simple;
	bh=pL5Je4HEVAXuL8Dnept9BFi+dGF+KXCSL1ZyZpgB6bA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NPPIW4JiZPx2Iqe9NN3BrBVXVquuh58P4u3lm9haYMMQlXIPCteo73F5Qz5DqrsVRnvdbSSz/VM9eYIRFWBnjyWm+R6GDOKbjyrOf8tpUHQeZKFogfTTGG4D1ZANHRalEqrcKooIMXqwlcM0I4lbz/Q8S6bVW1xkQmRrtykOhhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=p788T9Kn; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=h0Gt+H0D; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="p788T9Kn";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="h0Gt+H0D"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64P7HxH3671784
	for <linux-crypto@vger.kernel.org>; Mon, 25 May 2026 10:09:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	mES8tIhoFRE+W8uiZK4kjvVI99II0q8vFZyXwvCLDlg=; b=p788T9KnNJ7LO0pA
	BkFJ/Y9VrXQtDOfiTHO7kDeAlLpdV33E4fNdpY66ykC2+he7ucc3kpaRbvQB5eUi
	t+4bd0PMm1YErNlk3x116kOEyeuNt0//f+QB1vtFNBlGqu5nX0WXFZR63XIqA4U5
	BcMvk8nq4KU0i3mpu5obWzzpe6zMiSZMKmmYOgsapf/4LG0Icp+fuTiO4YRAvt/x
	8NTLYafssm4UKovjY3UnxvLurqKvkDUT8K1thBM9ssq8Txn3zLn1I6kEYOtXd4wq
	lZz1KZOrUzXZpX6rhyJvGIo+PQIN+cnHIIu98Ytz0wreygCTxKZwdwc50xAPNf13
	1MIOxg==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eb4f3e5at-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 25 May 2026 10:09:26 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-83565161a6eso4899644b3a.1
        for <linux-crypto@vger.kernel.org>; Mon, 25 May 2026 03:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779703766; x=1780308566; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mES8tIhoFRE+W8uiZK4kjvVI99II0q8vFZyXwvCLDlg=;
        b=h0Gt+H0DO8zJKahKcMv9lAnTacn31qfaNdOCgy4QMmYEo9jCh4PkpH2cxf3oG0SBv4
         2MXJ5iDcWDYIToEKkC3cbth+saN0lkvKkG93uZ2SBK41Gc0ux2VYkRIWtcLaUtFZ5+0q
         G35akXk/qEM7uuCajZrIz+SsV2SYaR6s6jiiETpN44dsOosJBiEpdTzPaIisDzKh631Q
         6xir/wozIGCObpGeB9ctRco5F5pQBVAFYOYFRTGrGRnD/yV+MqnKogSZL9fP05gBay/8
         in2ADHTqm0IaNo9WAdQfyOANX3arS5wSx69QHce6We9YtHmrychl/p0ldJP9+aBD0W47
         kVQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779703766; x=1780308566;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mES8tIhoFRE+W8uiZK4kjvVI99II0q8vFZyXwvCLDlg=;
        b=hbafm7Vo9c3KFfxYVi+NaTBdeRLK7FV5ZEGyGE5QpI7Xge9mcVMs+E1G0H6ObU8S/l
         X+KGyLu4GT1DMZFPKxHwQh9bkiED2la2zP5K2ZcqS37C5K2vHty0Y5Mcue45vAGp++Q1
         PxZ3F5pbMv1mw91giRUTlbl/z8LUs9bp4IfbqEyRvLr1Xk1b6GbPPpYK0Hqv3rGqQKSw
         UKl29p13kEctlX5cLxvNl0y4BC/Af943Eb2n/lS+B230hFzvW7fdaA2kGwtNa2hb33d4
         WKeDWiX5dM77fyIr7AcNnicOlWO/7QUa0CTSuSM0TXd/Jerb3+ZqjHQ4h4mWkILu8EA4
         B7hg==
X-Forwarded-Encrypted: i=1; AFNElJ/W5Grbae9PAYxvqk6Lc4SI7va2lTRAebdfKnh2l1yafrosMB3LFlb4PoVsjx/8f6UKM8xJ7uQV2Wo8+g0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwySoOOpIPaEqrwjxOxcMrHMPhhQhdh6LyvT221lEhmb8tDJaFB
	MQjB8dFaPPcm0d3wDFgGlB2TpKwwz7v0NDE2vP+XeGfdyBEZrvHDkKPXelpEay4D4ISEYrDWimI
	Pefc2EhZn9GkWhu7yyx+RObljyio/ZS+lXOqtlL9W9wL23AaeUOWTZqomSJrMs5JN+g8=
X-Gm-Gg: Acq92OFqm+NkjY1ik51zup9zwvI/c8EIHVmOB4prxumTUc/bBP0PNh/LNgI94Ay18Ug
	61ItCqUGmQAYPHl4ZV9wckqTUXUmGzcy2KiNzRlO5Sp4bD1jTiTiTVnaZQ2blGzcx3jghwJL9S9
	txp/PU85QKyR/i1gzJGuilPPdKvzdZVK6/FvLH79bpcwjQowLuQEjJMe9wWWGOSsxEYhOJovOcI
	aeRPyQA1kuhx46qSPR58aPlTa6GJk80GO2pCSHu5B+mOS4vzzm+EH8PUvoOZqDz7CV6ZLT2HfoO
	tvhq3GtpQw3bJ6rRDfB3pJ51jfYE/4Lel1gmZbZc/mVmbjFADAzymmnqkE/pXvtC8+VS7K/uEGC
	YoDmNeOQCQMGBu9wBrdGoGKTQTfnkaQTPm2XcjibHXgunyPDvDoc=
X-Received: by 2002:a05:6a00:f8f:b0:827:33cb:c7a3 with SMTP id d2e1a72fcca58-8414b4281e7mr12803379b3a.10.1779703765845;
        Mon, 25 May 2026 03:09:25 -0700 (PDT)
X-Received: by 2002:a05:6a00:f8f:b0:827:33cb:c7a3 with SMTP id d2e1a72fcca58-8414b4281e7mr12803345b3a.10.1779703765407;
        Mon, 25 May 2026 03:09:25 -0700 (PDT)
Received: from [10.218.19.63] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84164ff71c4sm10428735b3a.55.2026.05.25.03.09.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2026 03:09:24 -0700 (PDT)
Message-ID: <8a1d6c78-fd16-4994-bae9-cf75b1e7e3c5@oss.qualcomm.com>
Date: Mon, 25 May 2026 15:39:17 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] arm64: dts: qcom: shikra: Add qcrypto node support
To: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Frank Li <Frank.Li@kernel.org>, Andy Gross <agross@kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
References: <20260515-shikra_qcrypto-v1-0-80f07b345c29@oss.qualcomm.com>
 <20260515-shikra_qcrypto-v1-3-80f07b345c29@oss.qualcomm.com>
 <8dfa0670-7605-497b-9d53-db9b4a8a3d8d@oss.qualcomm.com>
 <57c26520-42dd-4159-bd2a-69874945cbbe@oss.qualcomm.com>
 <algvollvttjlu4qpawi3gnhwponwml6pts47ebmcvrjvlryl3a@qjq5ildo4qsm>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <algvollvttjlu4qpawi3gnhwponwml6pts47ebmcvrjvlryl3a@qjq5ildo4qsm>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: CJdgaazFGvhwOLGg-hnwvHRaCsQ-DTWA
X-Authority-Analysis: v=2.4 cv=WvYb99fv c=1 sm=1 tr=0 ts=6a141fd6 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=tA9iMH91bGDi15m1H0IA:9 a=QEXdDO2ut3YA:10 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI1MDEwMyBTYWx0ZWRfX5wN6rOYqpkwy
 ZpQH6yImQqzI6b5dj9nzw6/uMJIv/CbFO0lB3V4DNBUohJQXIOgduNTKCiZbQAHVPskS2lBLRGh
 yAlvef9p4LBjDXpw7x3FSdo4sOHLyKHiB31yAIM7qObnWmsXgSNeiVZKO3DcsueahFEn5GjfldP
 kSbD5mkzlWOUkB3qE9fDB+AVRtkTo+IL1+RbzQM0QnOZlA0dOmdlPUPvY9ZnVXmSU5CR+PLyyMu
 jYYR9G/vE53RqxJgDxbwTDibxbmwYK3j6e/lcX5QJ46gQ9RDENbwpmz5oHWS9gOqswU/yUMT3q7
 REqV1yCal3M7K6wWQM+p0iTahJHjKlcWSHfqMuOapteZUeLuMDLoQ0Mp4jXrsCint1H1CaBkL4Y
 Cm6/nInpMUF9u2EwcP8UTq8fhFUUe6/HwYORpbkPYxKcFjKyez7O99zrdHvI2ACHT5quuT6ub6h
 wevTMoaWMFE8765x2NA==
X-Proofpoint-GUID: CJdgaazFGvhwOLGg-hnwvHRaCsQ-DTWA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-25_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 clxscore=1015 phishscore=0 adultscore=0 suspectscore=0 impostorscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605250103

>>> These two entries are logically the same (SID & ~mask) as the first two,
>>> does it still work if you remove them?
>>
>> Yes, resulting sid is same for 84/94 and 86/92.
>> Basically, the resulting sid could be same, it's an optimization which
>> smmu is doing which can result in same SMR(Stream matching register)
>> routing 2 different sid to same context bank.
>> So, 2 sid can be used even though resulting sid remains same.
>>
>> Also, DT usually dictates what hw capabilities are supported and hence,
>> captured all apps entries here to match the hardware description.
>>
>> I hope this answers your query.
> 
> It doesn't. Can we drop them?

Could you please explain more on what's missing?

-- 
Regards
Kuldeep

