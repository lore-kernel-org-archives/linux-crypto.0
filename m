Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC9739DBD4
	for <linux-crypto@vger.kernel.org>; Mon, 25 May 2026 06:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779690585; cv=none; b=THxTw30I33YBYtHG34vbDUuLOBeKgOkzZffYZuSt3XPfDaECbel7HlQXwEWODrLl/u7TXM++156U8r7Q0xo+knn6YlBGF8/5ph7AbfqOGKs4D0SudWD6KwR2340XFNSXDiWjlb1slv4S/ckidfPP44pK/Srt6/sqJTwcsW8pTFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779690585; c=relaxed/simple;
	bh=GHwHM2Pf6KaA2vthdyaGDntjXWUE3ensLonH0SzHyMU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SFMQGJRfn++iQ7E6KcYMnKl+eXvGyPPLerY6NWqQkQBSMGeWqbnrIZan3YL3T08//rZdjccBV6CcqQkgRH9SJkSWBrUjPh0dU0NWn09rCCp+C75M5tJCsggQvIO+AWlNSs7+1K9oIjSnHSfLF0hXNB3bZaEcNybXqRRIp1f8Y9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Ve7tV7mM; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=M8WMtrkW; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Ve7tV7mM";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="M8WMtrkW"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64OKfGR51392536
	for <linux-crypto@vger.kernel.org>; Mon, 25 May 2026 06:29:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	FdIrsOqTvAtPVjBT+JGYNekw3r4qMnKczAPJbhiSasE=; b=Ve7tV7mMp8QvF+42
	6DWaCZPyb51vcb3OWG2A1fWxOI7zTm1jllpE2R+oh7ju7u1eGYzZDHQ/FpFuw9GG
	j/mVh9dlwX1EYgBDnWJ1cDFqK93XYHTAjvPUHTkPnGsUEH6jUzoNImm2C4uRNk2F
	xiebWDSRDrglWr+seh4Z7Iy6BPytSYpfPBAKEdV0gmBFlozxERO14Z4BEYd1LM1Y
	VTiCA1IvM1w+dpadbyrfUcFC9CfL/TvMflraVvfmFARIz93obC6WBcTJ3XUmnqPK
	p1HHxBKjMtzk7/O34VXU41dXUyFaS/M9XZE7y6zdmyn/YOy9eDEzCxaQyjrxFwah
	9Ky1AQ==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eb3txn8w8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 25 May 2026 06:29:42 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-367bb9caa54so8240140a91.2
        for <linux-crypto@vger.kernel.org>; Sun, 24 May 2026 23:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779690582; x=1780295382; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FdIrsOqTvAtPVjBT+JGYNekw3r4qMnKczAPJbhiSasE=;
        b=M8WMtrkW0Bsd9iGbSdvTm/uXprAOyTD6Ukan7qsXFnsFu7LhMFZ9GcHei6/YdJHtrF
         ZKqDhFRWlYJUS7cAAZVSmd/8P/t0fm+VnIWxAcuN+bc24xfJNvoJnzNu2igqi67B9dKn
         3NX5Q4GI/wz/zOkE+pDE9PPbHcTWY5ErGs306XC2P9oA32D5URlvK0s97nmSdLuhXB7s
         iWoD6TDg/in25uzAqR0whpyRW+6LGOz/deGWDwtMx7T6Ak2RkecN1pfhhXudaaMDN2K9
         /h7kh0ODzCQ0dAMt4fDKL3j+rQkNOjmriPCc4XlmEI97vOnP9YqT9HlFOCX9mlOdAtAZ
         GFsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779690582; x=1780295382;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FdIrsOqTvAtPVjBT+JGYNekw3r4qMnKczAPJbhiSasE=;
        b=dTA30EdoGqDZKMeAPXLtVGHN4WebfpH8szLylEm7y2t83Bnv0iGJie7i2yj/D+i2lH
         PTOR+gnFUo13WSNqETz3eRVgpcSYom9JD9bw4HtFD6hr1MTHFxgdgj6zsuityaAQz54q
         CnJQyMa57VVULjW0/c+GIVEdq8PizaNaPi7xgQDqTJlLuLqKEYWIkQUMTZ4Zrp7RMlJ+
         4Pgvnk+/exAm0u1M7/Va74udCi+LLKYkfQZzoSLfDQzyFwBxxD+K8QSaK4yI2XfciPnA
         1pAqUEVi+NTmmLL7JdHl6VoFFNT9DKCzh58ZIbmYaeIRg5hMbykuSTQqe1aj819Z4HEK
         SZaA==
X-Forwarded-Encrypted: i=1; AFNElJ/fOdwBEHfQoR3s0ErFQH8IUxrTOmsDFG0lIAT2mByu+oiMsIi9sAu0xEIDtCFGQSbyP/sVutUQhqwlJcQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzG5r0DZAMODtXPJXRHSnJd/66n4J3XTCu5z3TCQvdD8SSd6r3t
	MIb9zvqWLuO6EakR4xOrMXK0tHLjAJ6EM+MJetvhrgXzBqR3yZlS90CSK3S67mKOX2Hd6YWjaBd
	tMSat655Ogd35qowZI0uzJV/y/j01dS8pJXSeAnUJaMYH7iUn3YIJANW+5v5pS4m8Lu0=
X-Gm-Gg: Acq92OG+5E6V82WPkvLuGXIi+f22r6VGnBoguWHY7tawOLpCOutOo7iXEU/QfTZAh1z
	CpCl07G6sA6ypefOCGhLAT3lqGWAP51SClYhkD90hBIdiitfVz/yA6plURSYGEwjZ8+zTR7WuSW
	VYEg0Evc8Fv70R2rhbtS9qNWgemy3S/EtBXau2x2b14w/jUth2bK6FlEOP8W2DH5uWIwHIUMGTA
	8EDPhC0n1ix1K95Twns5RogsFnjG0WzIE4OWdY31a9iFnZSXld2R/HO6tXq6XvfFqs6PlRNk/VL
	3Irj6vqbNOUQk3XSeFD+M0mFwd6HDAjZN+FuDpd51euaeyS/ZPUI1+Ytx2nnOYLgfW6Z7+v+3U1
	afWFZmC5tpro1lw7/bGeQQPrFtS9a0BoHPe2TGF4qlm2qHlm6Grta99d5d0EZfAM=
X-Received: by 2002:a17:90a:c88d:b0:35c:cba:3453 with SMTP id 98e67ed59e1d1-36a67693ee5mr13860533a91.22.1779690581706;
        Sun, 24 May 2026 23:29:41 -0700 (PDT)
X-Received: by 2002:a17:90a:c88d:b0:35c:cba:3453 with SMTP id 98e67ed59e1d1-36a67693ee5mr13860512a91.22.1779690581236;
        Sun, 24 May 2026 23:29:41 -0700 (PDT)
Received: from [10.217.223.47] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36a72c4ca35sm8718531a91.9.2026.05.24.23.29.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 May 2026 23:29:40 -0700 (PDT)
Message-ID: <e36172c6-4424-4b77-9b3c-47dcdbdff05b@oss.qualcomm.com>
Date: Mon, 25 May 2026 11:59:33 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] crypto: Delete Qualcomm crypto engine driver
To: Eric Biggers <ebiggers@kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>
Cc: Demi Marie Obenour <demiobenour@gmail.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Russell King
 <linux@armlinux.org.uk>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <20260523-delete-qce-v1-0-86105cd7f406@gmail.com>
 <20260523-delete-qce-v1-1-86105cd7f406@gmail.com>
 <7rgfuvv3hai7g4wt4accbkejtzdt5dnb6mkj6x7ox5sz35q4n2@h7j6rr7extuj>
 <66317f6a-645e-432b-ae11-8f40569d4117@gmail.com>
 <d97382a6-6c5d-4a3f-89cc-3ae9b432de3f@kernel.org>
 <20260524204537.GB110177@quark>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20260524204537.GB110177@quark>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI1MDA2MiBTYWx0ZWRfX8bBoICC4q8IS
 MgDqQ2SFussEIpREZxxyyqUOZ662GuCgIMOpfHB5vMjsFoZICYAgjmSIAn8jzT7CuRFFe/IHS52
 mjpbQB6EE2O44Z4aGd10b+Snrs9gJVfppJpCp2IJcLgma/kiFBCuL4ncJ+7dpWJR1yeRmZM+Ss4
 Q1nWGr6LxyUR/yogclzwvE1JQyvaiUe6ACEPxDMzttL1yG45/wmryK33u/2NYJrKcFpevcNmPhA
 LYjmvbTD5CXNa4NW7KkHNH/6NzW+oZ/vNIFOT7tTPKRi6sdz2Xoddq93h0Kxyf63Kg4DPEkVNX8
 wWaUZHGBx9GBbD8YtYmrdkmY5l7ygZAX+XwigEiVdM/jwCYX3TddtZyGM+SqrHlqI8swVlsfXgb
 bnK9HboBWRzFsrZYwSKhjD5z6tYC1r6U+gFLnBR2bWCN/aOqKdWli579CF1fHQc0Lv+mb5kIVfz
 WPBuLphgZsrKx7Q4Zsw==
X-Proofpoint-GUID: 5UEFM2807gwC_YdtG7LVgC92sE_S_IT8
X-Proofpoint-ORIG-GUID: 5UEFM2807gwC_YdtG7LVgC92sE_S_IT8
X-Authority-Analysis: v=2.4 cv=MetcfZ/f c=1 sm=1 tr=0 ts=6a13ec56 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=84HhrvKZSfYMtnHzFl8A:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-25_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 malwarescore=0 adultscore=0 priorityscore=1501
 impostorscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605250062

> This driver is more than an order of magnitude slower than the CPU for
> both encryption and hashing.  See:
> 
>     https://lore.kernel.org/r/20250704070322.20692-1-ebiggers@kernel.org/
>     https://lore.kernel.org/r/20250615031807.GA81869@sol/
> 
> There are many examples of it having bugs as well, for example see the
> second link above.
> 
> That's why it had to be disabled via the cra_priority system.  This
> driver was actively making Linux worse.
> 
> This isn't particularly unique to drivers/crypto/, of course.  This one
> we just have data on, so it's a bit clearer.
> 
> I've yet to see any real reason to keep this driver.

https://lore.kernel.org/all/c1697372-54ec-4f57-85d9-ad375ff1a44d@oss.qualcomm.com/
Kindly check my latest reply to the thread. There are numerous usecases
like DRM(Digital rights management) coming up and qce driver is required
for secure content.

> Crypto drivers need to be held to a higher standard than other device
> drivers, as well.  The onus is on those who want to keep a particular
> crypto driver to prove that it's worth keeping. 
Sure, I'll be working on stabilizing self_tests infra for qce.
Kindly allow sometime to go over failures in crypto selftest and will
submit fix if applicable.
So far, i am observing 2 ciphers failing(xts-aes-qce and ctr-aes-qce )
with CONFIG_CRYPTO_SELFTESTS enabled.

https://lore.kernel.org/r/20250615031807.GA81869@sol/
May I know how to issue reproduce steps because I didn't observe
crypto/ahash.c failure with CONFIG_CRYPTO_SELFTESTS?

-- 
Regards
Kuldeep

