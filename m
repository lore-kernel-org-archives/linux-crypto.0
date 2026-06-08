Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6673E3D92
	for <linux-crypto@vger.kernel.org>; Mon,  8 Jun 2026 18:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780943490; cv=none; b=ANjgDlIuQPT6xzdi3fPTqmxPleBN1+i9pe4EwwpQGVbWQd53qCo37kpe0ejkYA/edJL4XKezp9mQOWAe1+RPb8WsmNOd3ashdhtSyt+DLruIEx0GU/GTY5YflRt7WlpBo50VG6TUhNT3KIPfQzdfFi2euluWPAKYrXbh2UM0FB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780943490; c=relaxed/simple;
	bh=xNum+tWC2aMU452Q4bpTFPsuhLzqpmZUmqcPe0OPSiE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qn4nZ8ujPkgjMgw4Nt1iUiUIwrQd4A1faTM6G4a5GgokFwZD/ljGNHzRQkRI6jJlhqkx0peMFZeOR6DQDiuTqY5bdz4FepeyMdclq3OSRXBxHjUDWRL0vXvfKoJSrneMfV0AFyuN0Y4Im1a/X8qG14eqUQ+o4SWUT9X+gHlTwOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=oXENHefx; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jgwhjVro; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="oXENHefx";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jgwhjVro"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 658FFYFU3479146
	for <linux-crypto@vger.kernel.org>; Mon, 8 Jun 2026 18:31:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=yL3biVRnQzmQP3JTE+TrfcqR
	LaExr7Z+40hJ1bAFkXo=; b=oXENHefxvYDkgrLThJUdpDu9IwUyLKB+g0fX3dIn
	mzPq3pEyVQI0iiKJrMhVVJW72aT4lesVI8JrV93dHXmYjDhipX8BedPGunhk0gyf
	WwJqNiGm1pCttLFX2ZMLKISj6gOJjM0S7gxSgMAXh/rXsHZl5iyt7Gu7SFcg3aQv
	c5POOIOBucgzQo1AzWFdzbES3EKcrEqE/OgWdr0SixCGP1HvlVdZQOBa6qBff0nC
	5p0uOkuznRgW62+mo+FnT2DJBQW/1PMp7r06usbQcJCayDm/Vg1RR3mgB/+NG0Pn
	ooXbpngwfEOoAPimclKCu+YdnRASfyIU4L7nNkp+hFzESw==
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4enxx41dsm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 08 Jun 2026 18:31:28 +0000 (GMT)
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-486d0cff483so1879957b6e.2
        for <linux-crypto@vger.kernel.org>; Mon, 08 Jun 2026 11:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780943488; x=1781548288; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yL3biVRnQzmQP3JTE+TrfcqRLaExr7Z+40hJ1bAFkXo=;
        b=jgwhjVrofuArGjI+m9nTmJ788IGRP9r7RSpVrpfBvnaOShs0+2eV75ODMthq+qGzcG
         eP4PRo96yXTd2KmP5/LKvMWCakYPOhMslID6N0vBuosuJZUPrEXKrJ6x+q1mgR9BRMuy
         ejS6+pt8ejcBv25YAR+Ar690Ak9yeR4hTzwvJabTNqV0CsBoFjZuJBRzfGwVjRm8vqY8
         G2SzPrXoAmJJvNzjIE4Aqb0ZUNmVMR62nNzlMWZHe4H7HDg/JX3muJIr2SLB1JjqeiMx
         JJG8Qy4s/pnMMhxy1xf1Lh2ufJIJRffIfU4hrdJofM2GHHyYrflpFyqCEEplYaUHgn0m
         eihQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780943488; x=1781548288;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yL3biVRnQzmQP3JTE+TrfcqRLaExr7Z+40hJ1bAFkXo=;
        b=sxjvt/QMTF9NG9dI4AuYWoiP2y8h+WjJwR489w6qxb1aOcQkfjULXwIxgjyzRdMfGc
         qh9CUE3oD5b8m7gznikW1uBz8Zv1lUMJiY2Re7o7Z179Tunsx6GOIij7+A52TVALkA6j
         tJYVRBL66DeFR//0VWlxIL9OqAOEemvjJTV/vcXoAqhra5IpVuP8DZStBwzUB23liXHw
         Httb/S2kBSwp7VJa1AIQM0XcAXj5TNMBy3iKJcTu6b5gQaNb/9RWTdnHCXm6tCrfNRlP
         yUKYAZ3iC4g1qyEsJ17OiPg/Jx+P+nsYcA7ER0uWGrO6BoLGp0MEd6wrrK5ZTI7CDXOL
         pgyg==
X-Gm-Message-State: AOJu0Yxdg2PufIhxg3VHDVUfkzVpLf4knfGYxzh0NjZ4ZjgTlvb2zb8+
	AEzUrDbd1MjUBEKlb4g5xXNzNtua1PGJEpZLT+wKaNoMAjH2gNoQEg/bKPcC2qpFyJ9N9FvXRHB
	1A6KbVveFz77/Syk7CbyiyO0rlCo1qyBQ/QxlCojjr7QNOwyLinT7NvWDkSRGn/HJD2I=
X-Gm-Gg: Acq92OGRwT9D9eIYcUKRDce7m5bsyZQ4utqamWcgyR0z8WV/+iCY9xxWzLH4Js2SQpO
	UxsSaHwyofsBRSbr2Fl7i16TlCUZO5XZQfKUfdKTz5Z87ExUrDM0okdn7hZYL09sbAVJT0Uioqa
	TMYrnPt5vOghinNI0LXCDajqEhl8bhMpqBKIVnR8p4eO4gGjDcw7exMUiXxngfBdQl4ROhG0AiM
	LlWWqYVyoPWcNAbdmGmzgkvupXyFVGE+I90GFeESbY6c444rcoZ68Zj8UMq5iLGQvy3VWEffo2L
	RnMfz6kDgPYRtUByO+w3KPOhhPLJfqS3WOXob0/la8k5oR7vbXUkK2SGRCRJsOuKacDgA0LvqZ5
	EELjLH8FfcvFwmFO7743442DFm1V8R5SphWocVpC1Rc9+dj3o2ymMab/VV598GYRixE6yi5mX1w
	dN1x9J30XqRigLEOvDANwv2jxD1g0r5+tBppcqQVZfG260RQ==
X-Received: by 2002:a05:6808:2223:b0:486:89d8:6d50 with SMTP id 5614622812f47-4868dddaf14mr8480548b6e.4.1780943487671;
        Mon, 08 Jun 2026 11:31:27 -0700 (PDT)
X-Received: by 2002:a05:6808:2223:b0:486:89d8:6d50 with SMTP id 5614622812f47-4868dddaf14mr8480525b6e.4.1780943487271;
        Mon, 08 Jun 2026 11:31:27 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5aa7b97ab56sm4037399e87.44.2026.06.08.11.31.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 11:31:26 -0700 (PDT)
Date: Mon, 8 Jun 2026 21:31:24 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Om Prakash Singh <quic_omprsing@quicinc.com>,
        Bjorn Andersson <quic_bjorande@quicinc.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        linux-arm-msm@vger.kernel.org, Olivia Mackall <olivia@selenic.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 3/4] crypto: qcom-rng - Remove crypto_rng interface
Message-ID: <5u2hogvqf273xuapkdeygsoqsncfhbexzcpwgsbddhgg4j7wmm@2t6gnzakxzi7>
References: <20260608175848.2045229-1-ebiggers@kernel.org>
 <20260608175848.2045229-4-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608175848.2045229-4-ebiggers@kernel.org>
X-Authority-Analysis: v=2.4 cv=cverVV4i c=1 sm=1 tr=0 ts=6a270a80 cx=c_pps
 a=yymyAM/LQ7lj/HqAiIiKTw==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=GGXhDfIuiivKoIxXIwgA:9 a=CjuIK1q_8ugA:10
 a=efpaJB4zofY2dbm2aIRb:22
X-Proofpoint-ORIG-GUID: FxyZLUeObj5D4XxOF9y-dISYMnGTcgH0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA4MDE3MyBTYWx0ZWRfX9Qf8Ubef2zyU
 RKSOMHxTXC2zHLgXmnRqccHDlTkBdApFl+biMtC8ZTAzseHWGL1wUxcxTnIDQu1ogMIgaoSP2m5
 Hpv8Ah3P12X9XTv8gQDwtEGNGjy+eyMdx/qRgC7wDd/DQj2DHYDobsmIQJpbh1jkY8vkH/VxR2V
 +01zuw9M2a029KrhPM1/dEaRGJsCVUvXRt8y11KzlYe7Q6qt09K1AEFNiNV2nYnDE6CMW0z7UnC
 gUSbJJADr7M4iAalSzQL8WDOZr1TGN1CV+NzTtBZE08hyrckRuJGRZZpEe2igxIEkzWBw1US/fw
 pN2qHSPLQKs4XxuJdG0hXzhAlTOC5Qqz2ppU7wl0zMrXTAOZM9v7eFV47c7jFNy4h4J13/sK3QZ
 goy2CC8tpw6a/yMOsORFCkpaORycE/DauiPWp8thq2MQwsKv5WORvWExnm9F8RNHw6Y+3/F70WT
 dbP8KSbrcNEP5sz4ovA==
X-Proofpoint-GUID: FxyZLUeObj5D4XxOF9y-dISYMnGTcgH0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-08_04,2026-06-05_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 bulkscore=0 clxscore=1015 impostorscore=0 suspectscore=0
 priorityscore=1501 phishscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606080173

On Mon, Jun 08, 2026 at 05:58:47PM +0000, Eric Biggers wrote:
> qcom-rng.c exposes the same hardware through two completely separate
> interfaces, crypto_rng and hwrng.  However, the implementation of this
> is buggy because it permits generation operations from these interfaces
> to run concurrently with each other, accessing the same registers.  That
> is, qcom_rng_generate() synchronizes with itself but not with
> qcom_hwrng_read().  This results in potential repetition of output from
> the RNG, output of non-random values, etc.
> 
> Fortunately, there's actually no point in hardware RNG drivers
> implementing the crypto_rng interface.  It's not actually used by
> anything besides the "rng" algorithm type of AF_ALG, which in turn is
> not actually used in practice.  Other crypto_rng hardware drivers are
> likewise being phased out, leaving just the hwrng support.
> 
> Thus, remove it to simplify the code and avoid conflict (and confusion)
> with the hwrng interface which is the one that actually matters.
> 
> Fixes: f29cd5bb64c2 ("crypto: qcom-rng - Add hw_random interface support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  drivers/crypto/Kconfig    |   1 -
>  drivers/crypto/qcom-rng.c | 158 +++++---------------------------------
>  2 files changed, 19 insertions(+), 140 deletions(-)
> 

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>


-- 
With best wishes
Dmitry
