Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792659876;
	b=JtLc2smNB/mRTmugE+kebDfekX4mPtsLQmaV6Oc6NYn5XbiUa+NnWO3ocYCLRljbrvJg
	 5PuTTRCPPo3xl/kgyOsOocGSI0uKxJrPHxkLP+rWl4gaIz5TQGDjXL0ljkFhWU6aO0yqN
	 +sej5dj8jQwvMVVLeoPRWIMh0CKW2+IMJFlobDsvWYHgSChwgv7TplQThWo039iRbeoAP
	 ZFr+qpclBjNmHCAve0wukaJypqNyeM5z/5T1MeIZJ+zLqNJIonrx7e6UfHRPIvE2sOv0t
	 RINxoecvtcX6ob+TFUQj68+R54P4lZHdM6/CCS2ZKIveiwew1RNn+rLi4lz9QQcNCCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792659876;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=gnkS9k+2/tXEDPTycA0vOUMBxxhav/Et+SuLMPjpzJQ=;
	b=oCdA6HXcfsL4C9Ow/vnNu+WfbAZuXSH6ANDCdHib7hTm6F7UtxJBzKuTnHw7RFI89P4I
	 uE/FDLuyJtwIVJqybXnjfU4ZeCsrg6w3Pd99V7Aor9inMRJ0iktMisebOHcupY3Ah43fe
	 4FAhc1GbdeUsHt93BIqedo88yD3djCHlpss9ljljVoLVNho8fOrGAxrK7hP58+2vDsLWA
	 suD9ksi9qlEcXGJo7fAXBM3+7bZsk48c7Wz5SXmokJcXgHHJbK+qWeMfuzKUsEp/6JDAD
	 iKoHE2gXxgp8HBGlL+05bvYXyjyp8Rl29kDObgj66TMVc4PrR4/WhZLYFeaIUTWX05Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=iwdV+474;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=B12sLeHX;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA9F606A31D
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 09:04:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1FA9F606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=iwdV+474;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=B12sLeHX
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69M761Gt3039000
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 09:04:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	gnkS9k+2/tXEDPTycA0vOUMBxxhav/Et+SuLMPjpzJQ=; b=iwdV+474yLO5p50S
	vwhffizSEih/hIHI0dZ3QJGTkQPu3Pab9WOI4nahgE1oE2+USj2yzz61VZlc8u6I
	IzEcH93XSHV7M81IWVRGfLoFN64HyJMzByJ5I12MzYh4jAP14/PHX2J8c8vlFxOb
	KQ9ipcIJvarE9FHwREmHE88evVwamVvQ9i3VoqwAqpTqtyrN7jLZDDdmqby2AJdP
	7ExLBMF3XMWGLagjG5dtqZvwSAt67oUJouFWiKOK1K1QKTdBE7rlgXtJtvcIvtBg
	7Ki5oDD3DVd2A+N1/w4I9JVzvo2/5DK8QqPsHyP7FeVbecNnTkEPbznSAbVFjgxc
	70TDfA==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hf93ashv2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 09:04:34 +0000 (GMT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-917a04d1cb2so3809266d6.0
        for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 02:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792659874; x=1793264674; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gnkS9k+2/tXEDPTycA0vOUMBxxhav/Et+SuLMPjpzJQ=;
        b=B12sLeHXgtj84/PgsM9tkJGsm+B6aUNnFdQW6v7Us5vDnpjY0VbgvLSJv8qpgJTZqO
         V4rEdGYKIxIdIXJhXtXeJlAvY+jDNetQ4z6jbzlFi4AqdXg0BNgSqhWFZ9nBvffF9l+A
         FOQY9Qzo/p+7/ibaSaheTzEHJSA8vP7ofV7wQnwlO+ktKNpVJfJaUEiOetaW4uO1M1qV
         zUIze8mRQ/J/jehy/kJ0OG86yYRpNh6EGkRuEZrnytewlka2oAAC34NqbPRWW1R9Q2QK
         frMC2mNXA2Y+Aj3yUGA9iLBwZ3RrB8d/Z0rcChCm7XD9T8DJySLyJ/ToX5fEaeL2oSXv
         uDXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792659874; x=1793264674;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gnkS9k+2/tXEDPTycA0vOUMBxxhav/Et+SuLMPjpzJQ=;
        b=Juk3w0oTGb6NSqC8Ghf/JegXpnlfD5Ymvl1QbQoJGqVTdJGcsZ/sC0z+QtyZTG40RN
         SJxKRNml4G/GoDLt/KClRbWNIkrSevk2B7GWy0KEpZlOIE0DfaOrebXuHNzmW0fXfmOy
         qG+/Q8/w3W+vBG2U6PInFy7DmXcwdaGSbMJ9AMcvJ8R528wva/Fq/y0LnaLFsE6SoNGb
         ZIeZBFBto/5qrxjG6AU+bLGMHEJ3XCqZh0teYSesy+gsX0CmkED49qabjh9AFjGkp0V9
         UurelauzCArWdLMawE6CFGY0sSi/SRFvJKgVVfLD62pkXJiSvTNFVir5sy/NfEuk9las
         gusQ==
X-Gm-Message-State: AFq9FYIRXoMao4hUcvdz0zmhJljLyoxfxvGd+nmgP6Zuqqn4vWhJxact
	KkLKDClnCVYIxpbyKfetOFxtXq0WA+Vsjw9jiVg6Z3PSJqR26HzOscRFjwW5djgEFr61B8s+SYx
	VMFom88Xf+HDl2rvb9+PmlnxoJIGKKv/ssCXgQPx8nwmbgCTHQ40WN/JTcTd9Nuz52Lc=
X-Gm-Gg: AYBFou1o6WnjvmXhvVuBEn/w0IvdLSenBOUbgOWiZJfsFCP8aQ80nTfgelkLQ+4Dy1x
	03b5rcHRnBDwOzqToetn0oh8RnWz9v42y/uqi/1vELZ6EHxGOFwp95R7/CyezctOElBSfFERPz8
	IZ7HCsYCxCqCPjkNwlodt8TLV5qoSH43sFxGvD8pYtyq1AttU5eW1s28UbbWdfZVA6Jp525MK/+
	vAT+bxWaQs18B1V8ObWlHE+qKvS6VvbOoR4J2PKWlWIlkoDGgtRiVastBV1LTcyDK4XroMafoSE
	CpnTDg0N+kurI9YuQncE51LZLJ4JHJDlUqDJrTVOBrVSaGBls4nmClFwRvZP1CPz/W/wfFpVqqk
	HSrrDyzh/oVTytlcDi02Z3w==
X-Received: by 2002:a05:620a:6844:b0:93f:211f:7ba4 with SMTP id af79cd13be357-93f57fb9f56mr903740785a.5.1792659874210;
        Thu, 22 Oct 2026 02:04:34 -0700 (PDT)
X-Received: by 2002:a05:620a:6844:b0:93f:211f:7ba4 with SMTP id af79cd13be357-93f57fb9f56mr903737385a.5.1792659873706;
        Thu, 22 Oct 2026 02:04:33 -0700 (PDT)
Received: from [192.168.226.26] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c468a1f29aesm85858766b.11.2026.10.22.02.04.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2026 02:04:32 -0700 (PDT)
Message-ID: <97c2268a-0cff-440c-8e21-f19a809ad377@oss.qualcomm.com>
Date: Thu, 22 Oct 2026 11:04:30 +0200
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
Subject: Re: [PATCH v11 1/2] crypto: qce - Only register algos if the user
 really wants it
To: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Bartosz Golaszewski <brgl@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King
 <linux@armlinux.org.uk>,
        Eric Biggers <ebiggers@kernel.org>,
        Demi Marie Obenour <demiobenour@gmail.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Pankaj Patil <pankaj.patil@oss.qualcomm.com>,
        Birk Skyum <birk.skyum@pm.me>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        stable@vger.kernel.org
References: <20261022-qce-fixes-broken-label-v11-0-0d33c34fd0c3@oss.qualcomm.com>
 <20261022-qce-fixes-broken-label-v11-1-0d33c34fd0c3@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20261022-qce-fixes-broken-label-v11-1-0d33c34fd0c3@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIyMDAzNSBTYWx0ZWRfXzkzVsUnDY7d/
 WEGiM949jnbZmHjwbNCJu9nPL4CDhkv68RbnsCutYCYMLXNZRFZokcHFNjkIO4AiqRt+OOQ2GUS
 UaUn0Fw2Hqx5qky2odyNZmTYajlQ/Px58nljPMQftYZrP5BdtFJKbBRzzblp9JTNDslVru3CTK1
 kVvcwioMm6YVv8LRKUBBphRz5VB4jy2v2YyH7yWvqTdoODBTSm7MiC3pDtm0WWDJKdv7JKDB73C
 I0Da9XvUs30c+Zmq2hpUzO4h/o/eCBsLLhgOGFPIxJ7v493xEiFGxzPXqyGM3UeyxMt+W9VN2ST
 2J612uJPUE5TPPzQP0zQ4HwTeowsCE8TmDZvKqN99k9SGyXcm3MAcvu5ZR2bLST6eNYcTjd+uXg
 nPw6El881HE/kqTNgVYW6+g7PU1AVDQ4DqLMpIkmfTUFCVMUXmCqi30SA54wICEkrd+SWHaSNrF
 3nfTucJHiklFpqehxHA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIyMDAzNSBTYWx0ZWRfX/S6lyPxN8ad6
 hyp8y0v6ZezQmxuzq5jW8cPQnArS4yexj/B2sLsCJg0XTW/DFzFO00F5I4+sv65h5sZqeufXdp+
 VXssfzPH6XL30v326lJBq5314HeRbfU=
X-Authority-Analysis: v=2.4 cv=QPn91QLL c=1 sm=1 tr=0 ts=6ad9d1a2 cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=LeLJCEefvvVT7qkYm4wA:9 a=QEXdDO2ut3YA:10
 a=pJ04lnu7RYOZP9TFuWaZ:22
X-Proofpoint-GUID: hJ8mZ0JOhgAHhvYUQMJmizy-Gpr0h3Ml
X-Proofpoint-ORIG-GUID: hJ8mZ0JOhgAHhvYUQMJmizy-Gpr0h3Ml
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-22_03,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 phishscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610220035

On 10/22/26 10:57 AM, Bartosz Golaszewski wrote:
> This driver's crypto algorithms still have a few issues that need
> addressing which don't currently trigger any self-test failures. For
> that reason: don't register the algorithms unless the user really wants
> it.
> 
> Add a module parameter to the QCE driver that by default causes the
> driver to *not* register the crypto algorithms. It will only be one if
> the user explicitly passes the do_register_algos argument as true.
> 
> The power-management part of the driver is kept as is to allow scaling
> down of interconnects gating of clocks by runtime PM.
> 
> Cc: stable@vger.kernel.org
> Tested-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
> Tested-by: Pankaj Patil <pankaj.patil@oss.qualcomm.com>
> Tested-by: Birk Skyum <birk.skyum@pm.me> # X1E80100, Lenovo Yoga Slim 7x
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
