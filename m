Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1428A330B2D
	for <linux-crypto@vger.kernel.org>; Sun,  7 Jun 2026 21:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780866301; cv=none; b=csMKLMqDdWjiR5iWBZgGh7LepbW3ig4WrEPtmk1P/IjSymLzWKk88LY0MlhINcPyOvmDCLKHfELDuuP64Cz1ZnaXBHXMf2bsAXnmHV5jqnubwt68IW0r5qy7+5R8XJ9bNN7nmkABfR5+XjNMAxCoDNeOru0Bqwry2R8CrGkzpj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780866301; c=relaxed/simple;
	bh=9zR5AOWHKt/GYerk6Uqs9WTURiwzh2mrCZp0c4b9z7M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jPP9s7OrZZIUv8/WjQH3a5gZ/f2/bwitEY2S4KTCD8dbEDNYMjzrD7na1W622mu7LFYYN0tfT9ZEm257p/Eu32R1DB3NdeAes1glZfB16ZiBRDV7hD1vtJwEHVhbOQAVisXn4SLX9miU6jg8IX/tEerKrFsd4ZKYb4+oSy6XeWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=nBtg5fYH; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=SplEZb86; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="nBtg5fYH";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="SplEZb86"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 657El1sk827191
	for <linux-crypto@vger.kernel.org>; Sun, 7 Jun 2026 21:04:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=Wy/LHbrdpEkRnrsqrOcU9s26
	gNhiNWxa1iVHyLEUNxA=; b=nBtg5fYHYO8wewfI6r2Wga8ZZdTZ2eFLabsxSOwZ
	O4i97tmZVGOROFS5hwz/KuwBYfW6sq2uNrvkMwTXXQ3pWbRZRYWc/ek+M8+y01HJ
	vVHqD3MAIcsEPTCAsWURTpo1SfQshB5TBYBiCxua/UuMHixmE5WlXQfnT3fwrdGF
	acZwoYSNWwwRoU/Ptao03Wqs9XoLs6x+pjj77eCsC/kGajK7CUBTK1ZP1gdIzSi6
	2zJbkISv10iYWGdg32s2h9dXusgjFVOnFiAw44h2ByfttCJ4tJPI9aUNKZYJM9Lt
	28ZqF51u50ItyckTYkslD74jNOokkt6yE/osS8Pknh/RLQ==
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com [209.85.221.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4embx6cpjx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Sun, 07 Jun 2026 21:04:57 +0000 (GMT)
Received: by mail-vk1-f197.google.com with SMTP id 71dfb90a1353d-5a77f8bdc24so607348e0c.3
        for <linux-crypto@vger.kernel.org>; Sun, 07 Jun 2026 14:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780866297; x=1781471097; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wy/LHbrdpEkRnrsqrOcU9s26gNhiNWxa1iVHyLEUNxA=;
        b=SplEZb86Jgi7JbisixbMnbrbEEXG7+mFdlpJ2ErQSEFsRhuMqt37tFhxJKI8jiL71z
         5y6fO4pMJt/AvauAQQ1xiIq4mgAgPB9fHDJKlr6z9HLpBO0Zos6vLBBJIWes+HNYX94h
         gCRhe3BiH/XM0HZwY/Fm9GTSg+ZxVOAHcBHPiGFPlLG4xtR2dpuhUH88Aa/pPxzyCyKX
         uxAFcEtqhlP/hz/lcE8lu7kmnyzib6/X7VwwWki7/066E5eAQBj99DxS1kbQ+JO9TPsW
         0o7n4USPVkMON5P89PNG4/+PUsxq28Z0LHz9/1ahZNxAwKMZEl9syP3jMDw5n3cMDC7N
         T8mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780866297; x=1781471097;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wy/LHbrdpEkRnrsqrOcU9s26gNhiNWxa1iVHyLEUNxA=;
        b=fpJ2S8RMjdA2m0QGDRp5M+5fRY6qdzYrQec/ZdKfwvgUnt7+FTb2XjpVspipetJ5rm
         XysHOMMsFk+56PvfdfnECQp01ik9qptaErU9bATSqcGHPeOGjDvySJwf1MMwbniTjoHj
         pw06xImMEH7crhrJHJjHSUs5L9n/neoLWb+iy2U4XYuLmimd3fUcvFyvLeLGraUvyVwW
         aNDzgP6IQO63g1n1P7xuWOeqqLdjZiNy2dOc2oBPWhXuXTUJVEvze0frsaZruTfiD0Vi
         zOZCcwP8Eu3+oKVj+QBJYXwxUoJ+b2P/cBh3F0j958F/74BtuVlUCcKX7LJQ7o7azcL0
         MReA==
X-Gm-Message-State: AOJu0YzCKh2kwGzrDMrchkIjC+vb5ZzngmjHCKEW3bARBuWPECcL3bx7
	Tr1uzzyZfxJzpV1lSKTrncIniJbitvYTaZbcB/g/mvaPO9CE/7nkVKPdL+WNWV8O6T7eEFFncmW
	dBV0A4cm+YqJzEMk4wfL8uX+hxm4HyeuVUhB5hDB+JWpiyzNdqz+WQw++bruEdoCG/ZQ=
X-Gm-Gg: Acq92OERt0PWFT3WdoTWv2FWs6o1TYTpKk0oJFs1A41lQpgOZQVRKK3ANz2AXonNAoq
	Xomia3eJqYn2SQP7MyL/ulUH5qr007xVJc7gCctUYr2slnxeUdPFDPIEWJU14V3Mtik9P4EUHEC
	tcPyr5Q0qwKNVkzD13uUkc9/bMcb2LaBJnJ/vQ0D2h8yQN2ggEaZV1nmNlffPvlNaZzhKQK8gkG
	lxmU1F5Kw68KY8+44x1Re/hzP7LpZ48juG4aq8oqJ/OxeDgnTuGqNpYaTW6vWyzxl+DJrlq5tiQ
	OyNeunnN6N51Xi3+QZPdvaY4SmtixdbT8mSKbJ+qa1no6p4zfR8DP5fIYtcN6T60zo6rENDaNmn
	wRWy+GJn4RT16rVeoRoDa0rL5O7NTBrjcJp50J1Pbrg1MAx9CC8uUEH+DtBI4u6nxMYYMD64RhH
	7KHPeDu1sZv9666htMoaTryoRHk0rC8++IC1x/B0AZbnI4kw==
X-Received: by 2002:a05:6102:580f:b0:62f:46be:8318 with SMTP id ada2fe7eead31-6feecfb41e8mr6467938137.6.1780866297507;
        Sun, 07 Jun 2026 14:04:57 -0700 (PDT)
X-Received: by 2002:a05:6102:580f:b0:62f:46be:8318 with SMTP id ada2fe7eead31-6feecfb41e8mr6467929137.6.1780866297141;
        Sun, 07 Jun 2026 14:04:57 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5aa7b990d37sm3343521e87.70.2026.06.07.14.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 14:04:55 -0700 (PDT)
Date: Mon, 8 Jun 2026 00:04:54 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Om Prakash Singh <quic_omprsing@quicinc.com>,
        Bjorn Andersson <quic_bjorande@quicinc.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        linux-arm-msm@vger.kernel.org, Olivia Mackall <olivia@selenic.com>
Subject: Re: [PATCH 4/4] hwrng: qcom - Move qcom-rng.c into
 drivers/char/hw_random/
Message-ID: <w3nvohaf7qvfwssggdhoqogwtcfmucfzqiuihbtwly6iqa2i46@3tybaiubfn4q>
References: <20260530020332.143058-1-ebiggers@kernel.org>
 <20260530020332.143058-5-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260530020332.143058-5-ebiggers@kernel.org>
X-Authority-Analysis: v=2.4 cv=cvmrVV4i c=1 sm=1 tr=0 ts=6a25dcfa cx=c_pps
 a=JIY1xp/sjQ9K5JH4t62bdg==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=VwQbUJbxAAAA:8
 a=b4jLiGy6nbOHC2eZWhgA:9 a=CjuIK1q_8ugA:10 a=tNoRWFLymzeba-QzToBc:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA3MDIxMiBTYWx0ZWRfX3JyZVidUWSzw
 OMCHL9WF5muaeycnoLUidIrAfreidxMlTeGLH6rkiR31vCy1OqudkAkjqOLzgL1wu72Rtv0FgWp
 OmE5Cnm1ePqsci7arg9tEbBhFJ5NhYQdd1Nei4AIfr+IR3LZxl872rDAK7WBYlOXzIqm84z+FFI
 1cHiEAPLHUh/3oKOMVhKvisT4lPk6vz7/ejiUmPQqQUCsDgywuh4dqRO9EPe0kB6ce35Ajdefcm
 l9UNV5nZY2gHXbRp81x9oWvKXBmYZCll+KuXdeyRUxpSZG9lrH7+Vr0BDawayZDKAKk0ZjdcWDp
 4TYr6FEGlCcE3UhkkVNoOHiLgj9qrke++1yorctte+C0czV8hgh2qGvs2HzKYqgQQh1YcaJlC+M
 YwmPFVdBrPrFBjasBGQ7jQDC0FmLkiPyNDOZi+e+bAf5az0lyHKJCN2/WHVOWZMuoCiN/fkb63n
 KzfBBPQLcbs1cTtMAjw==
X-Proofpoint-GUID: P-tNny4qOp5fjsv6U8pGTmYFmjJwfXCX
X-Proofpoint-ORIG-GUID: P-tNny4qOp5fjsv6U8pGTmYFmjJwfXCX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-07_04,2026-06-05_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 suspectscore=0 phishscore=0 clxscore=1015 malwarescore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606070212

On Fri, May 29, 2026 at 07:03:32PM -0700, Eric Biggers wrote:
> Since this file just implements a hwrng driver, move it into
> drivers/char/hw_random/.  Rename the kconfig option accordingly as well.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  arch/arm/configs/multi_v7_defconfig           |  2 +-
>  arch/arm/configs/qcom_defconfig               |  2 +-
>  arch/arm64/configs/defconfig                  |  2 +-
>  drivers/char/hw_random/Kconfig                | 11 +++++++++++
>  drivers/char/hw_random/Makefile               |  1 +
>  drivers/{crypto => char/hw_random}/qcom-rng.c |  0
>  drivers/crypto/Kconfig                        | 11 -----------
>  drivers/crypto/Makefile                       |  1 -
>  drivers/gpu/drm/ci/arm64.config               |  2 +-
>  9 files changed, 16 insertions(+), 16 deletions(-)
>  rename drivers/{crypto => char/hw_random}/qcom-rng.c (100%)
> 

-- 
With best wishes
Dmitry
