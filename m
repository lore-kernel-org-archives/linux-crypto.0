Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E97F2EC0AE
	for <linux-crypto@vger.kernel.org>; Sun,  7 Jun 2026 20:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780865525; cv=none; b=rWZ5ygWeknuO7Z9BKA9NJL+eb209HYwQyMqKIYsK8hxvM+gIdvYSJAMfgMnFkfI21xyd+Oo9lZN1Dw2pJoatMOWxy+1foNpTOR/Qj33IKute1ztYSOpiP57mW2Zm01lapy+g0m4VlDv2xWG3s6r+jCAeGyzRcw85hwhTgFg3EJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780865525; c=relaxed/simple;
	bh=BjkvTCRYz0fa8976imPRZK+W4llqBkazHf7ThLm7PCc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cz7wTmbdh9LxYgwEEZjsTBHPRkXwPZsUE0ryH7RywjT0qykrl4+RfAdate8KTZ1SesxS8O0M84nQFKIu9awz4Hs/3VLDgi5TK4idU+163W2YsL88Fmimc3UWpqJxaFuo9QoWimHvcWHBPq2HYtbS3luAfaDjsETNqyA05L9oTso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Z0U4/Rem; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=WbvTFWqF; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Z0U4/Rem";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="WbvTFWqF"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 657Ek9dx336060
	for <linux-crypto@vger.kernel.org>; Sun, 7 Jun 2026 20:52:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=+pIB02ijY13PTRTW3b1mGVCc
	zD2F0d4S/o/0/235A1c=; b=Z0U4/Rem0CA/ZN9xGxn11yk9brb6N3/rIDnleJ+J
	5FoB/O3jx5GHCTkyLhKhl+63GMWpjpTL09GuBLtv6JOLgXS7vNxklZ50H12Xg7aB
	EsFOXB7AK9oi8I+PYwLU0CwMyR7zlksRmplvAi8dQak+puVi8A5tC3X7LCqPYSh4
	cyPaMoGlAvDEI3LKuq+HEXLL67WAS6/yBLpahA1ScMV6E8HCaJiAwY34ILrz2+RZ
	+yXSEQnUM90ErccGQHlcC8IS5hCCGGRtgeDqedezIlVEm0XB8HdgNNMinND6YBH5
	Iu04MJohkySzLkOHjz8YUyCd+yf+xiz1zYCZWOoFUenA0w==
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com [209.85.217.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4emcqgvf35-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Sun, 07 Jun 2026 20:52:03 +0000 (GMT)
Received: by mail-vs1-f69.google.com with SMTP id ada2fe7eead31-6cfd65ab97aso5407295137.1
        for <linux-crypto@vger.kernel.org>; Sun, 07 Jun 2026 13:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780865522; x=1781470322; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+pIB02ijY13PTRTW3b1mGVCczD2F0d4S/o/0/235A1c=;
        b=WbvTFWqFEyuq7+zZSR6ew6K2qq6SPVL2N90XpQudI2Dlt8LPrmRt0NcxV4pdLVdWNm
         l/Vt2X6FCUlhm92TsiQLl26nTFk2Ell7AzQb1hE2eIonHd3GSTpEsLG4rEPlxMuccsRu
         1S2zVDwfkFZuUr/zxj3YOVV2VxzaKmgoXl0Ewi3N5O4qnXp64sfoDY9FViFUdeIcpCuF
         1f9+5eiBEhBMwwxs/0LAZHGFYc+lg6NpYw3stKyLk9WLhTFriffV9vhjclLDbQtlpzLv
         kvfPjUKb9S39OU+xSajKZvCF72O4CGmIN4mkCaY11/NXb6WU2J79mLPXZv1pvD35haMN
         9xhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780865522; x=1781470322;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+pIB02ijY13PTRTW3b1mGVCczD2F0d4S/o/0/235A1c=;
        b=noN1cQRP+FDCqdE42/LOmTL0wi9W9kd128wZ2zd5/ji6LB8OSDDtYzPG40CGsBASEv
         w+gF+JhAxkBoNzhZn/4rGVapBzxsKEMgtnUHWKGfWgNPUB0UhJCrDoIAN3dEMg2ZpMND
         cglr9wx5/uqgd7joiT74ftitfIaUKi8EUGoGIAHZhoSS8IRQ4nMHS7NNKIWUoyhReF64
         9fmjDPGNMpE8erFc0ZYIjv6SlGqgbvGe2Ajld11bUVG5YZs6/EXz0oEuoyHlEC14opAR
         C0mLyhSYUzjmuEvmVbrBbiVMvmiLDGQ5EbpP5HRivqqahb+g8wo6xjqNviCT9z8XJGpx
         DXxg==
X-Gm-Message-State: AOJu0YycmGo0C26XFqdGGvS40fO42A2eL5ke+E8rgsfRaTC2COHKIzrQ
	2SDKeAYsN4qrjooR0Nwob/US1OwKIMZ56oNXW5Gn7jhNJ3T+5bzd+jTv2xIkn6XdvIyjkSY/VkB
	VcH8xIaPDiHiMN4j3LpeuA4iphV78LPsLXxNNUZKnllrBpl8KhKgAuH62VM3P7T/fOV4=
X-Gm-Gg: Acq92OG4h+w7NWGLcskqjN/7WYkJConEtT+CcytUN6zGY92sfC6GRGH2qSsm9TxF6g7
	oeEe3OTPYAanLggUsogJ0W5Ov4hO0skRT6tIJLwOhH9CY9ARRF3CqHMj+emtlkXn0UlY4VizgZZ
	lENpTX+XFK+JMZcKzR4C0Ca7ss02+DHCs7bKk1U3YmQ4T5GP+JJY7xIE8rOztxRdMPnXCDt+0Ap
	6hZYgRpoEbMkRCNzLq5M8raufnO0Br7vz6uxCVhAxnjSI/kY74rYvgBpR8hm68XwhBySNjUb2eG
	fQIvl5J7qoUum867H9EzgxLtO0yLsAgqOsKhetfkyANdZbM0tBvhUQ4hB2GJJRHTcy/j5r4z0+q
	aOl+h+jgPQE6+m/ItRQKonEvY5J6KgMKr7kZiGXRkqRRaWcm2hfjnmPM8m/4llIeEGmwHHHJXyO
	ln+L6zyo2Y1nvnYW9LoAlaJUMnkTBpF/zAQyeUQRpFWZoddQ==
X-Received: by 2002:a05:6102:548c:b0:639:1e8b:ecd9 with SMTP id ada2fe7eead31-6fefa23308cmr5994402137.20.1780865522376;
        Sun, 07 Jun 2026 13:52:02 -0700 (PDT)
X-Received: by 2002:a05:6102:548c:b0:639:1e8b:ecd9 with SMTP id ada2fe7eead31-6fefa23308cmr5994394137.20.1780865522035;
        Sun, 07 Jun 2026 13:52:02 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-396ac2ed9eesm41476591fa.40.2026.06.07.13.52.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 13:52:00 -0700 (PDT)
Date: Sun, 7 Jun 2026 23:51:58 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Om Prakash Singh <quic_omprsing@quicinc.com>,
        Bjorn Andersson <quic_bjorande@quicinc.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        linux-arm-msm@vger.kernel.org, Olivia Mackall <olivia@selenic.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/4] crypto: qcom-rng - Enable clock in hwrng case
Message-ID: <ldquuwgt3ktbpsnrvgg3ld7lzt2gebvoyzw42jji3xmj6vm35g@myeavdjxraii>
References: <20260530020332.143058-1-ebiggers@kernel.org>
 <20260530020332.143058-2-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260530020332.143058-2-ebiggers@kernel.org>
X-Authority-Analysis: v=2.4 cv=dJGWXuZb c=1 sm=1 tr=0 ts=6a25d9f3 cx=c_pps
 a=5HAIKLe1ejAbszaTRHs9Ug==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=tI4jJ0bUc5TXO7XjffgA:9 a=CjuIK1q_8ugA:10
 a=gYDTvv6II1OnSo0itH1n:22
X-Proofpoint-GUID: G5UnsdWzTK3LED3g3rcziqH4jfDwlv3V
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA3MDIwOSBTYWx0ZWRfX43WRsvuMWbti
 6gTvM5roBw7VqKg/QnyHKhzueqUeiaQIFhi6GLQiZc+SMDs3hD96jzT940Uh7k0oAjSz5pWIO7P
 imteYdX6L+q2GRhIGIkcEwPfzgXcyn/5lamdO5P0qOMC3YrqyUp73+bqNq31wZXqS7fXgbU/ARI
 /zHKwIdzFCX8ZryUFYmuypuQqoiJzLz6tPcTYfMqUXtIXtYXE5U7APih0lLblvdrIL5fJfVPkmY
 GdLRCJdSVHF7aNGKWjIrFXmt+aUJCb1rA453w7skl9AKyrZ9fsRiE0J7J+KbiTLQcZyY7GQvavM
 D09O3usubcgMlFpgpAtC8CQMHlHXGjL5twOnGfU1qvSDosRwF39dU4H9g08AAyTmOJkBIKu5njV
 RUYpsGc5Iu3nHPsVvV2KwiJNK+CkoBmx9bakGHLLaEDH7PFXy6KhHrx6mSLco4pTouoj45zS8UC
 bJWer1BXH3YovL4olyA==
X-Proofpoint-ORIG-GUID: G5UnsdWzTK3LED3g3rcziqH4jfDwlv3V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-07_04,2026-06-05_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0
 clxscore=1015 lowpriorityscore=0 impostorscore=0 suspectscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606070209

On Fri, May 29, 2026 at 07:03:29PM -0700, Eric Biggers wrote:
> Fix qcom-rng.c to enable the clock before accessing the hardware.
> 
> Fixes: f29cd5bb64c2 ("crypto: qcom-rng - Add hw_random interface support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  drivers/crypto/qcom-rng.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>


-- 
With best wishes
Dmitry
