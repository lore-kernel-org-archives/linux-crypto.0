Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D9E3822AB
	for <linux-crypto@vger.kernel.org>; Mon, 18 May 2026 17:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779126716; cv=none; b=Ap7pd3agrcR5dl1vh8F3q2cAl5zrk1S6X6qBtT2QUn5y6SgScZf+J4hVYWoMm2ySNZ8/Wl1Dcv2IwAwS9D3wDjs6GTre2sKk0+0XSNBKxQqeNj1kg+Uydq1fLD8/Lyy7IYI5xujV8CM5q9xiYmMyUCkMuRD5gwNjAslGFRajRpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779126716; c=relaxed/simple;
	bh=YO0xaV+puJb+FXu8XxI7Miv+9xXb71hwJzUKynMUnYw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oP0y5yT7FJfiqClldXy/YyEgZmtcmTaFj6LPEtNqjmCeFrzSU4jVN/SeyjE7adnlIQVWLku7PMgDM1pfEHQPT1JWD1KygEarHvii2lPZje9vsZdjK1HdR4fqjRkrPSr6Xb012xm7ZyDstl4wFKsfJlde/tQsHx4W43VYyBs4X5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=D0+NDR23; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=dDjC0tGH; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="D0+NDR23";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="dDjC0tGH"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64IE0li22892861
	for <linux-crypto@vger.kernel.org>; Mon, 18 May 2026 17:51:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=W24vIOGiSP4y29K9PfNEC3xc
	hhMtUW4j//8Nr4NBCog=; b=D0+NDR23gr0Hf9uN9SsTR97Wpa/hUSXks34Z4fPc
	ytW9M2nokM2oR6fqX+mL0I7KfQtCXwXCPHUcUkqZD/006ngkEKbeFTjSa7fMsvE+
	zMcUWUNuiDLB6MoFr2ooNeHmcPFtHDRWif+cRlWyXrPY7kF+XcEJkk178y4MIBoD
	BKZaBrXwe+FzmKeExjDx3GfI/Ad+KCq3L2djYW9f0nAMwRf2u+KeRlzn8jNfS8Y2
	wNlU3Sk4kcWZjh3yXvVxWYRT+b0yjz+SHKYU6MeX156S0Qwqz2UpnwHtTztCQTSK
	OjHRfa4h4faErBt85SDg+UUaIMe9cH/6tBIowaAbxvSaVQ==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e7xk1afdh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 18 May 2026 17:51:54 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-514cbe73d00so91248151cf.1
        for <linux-crypto@vger.kernel.org>; Mon, 18 May 2026 10:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779126713; x=1779731513; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=W24vIOGiSP4y29K9PfNEC3xchhMtUW4j//8Nr4NBCog=;
        b=dDjC0tGHbk76CsBAbyEOg/s/WIx5Sbtwq3Gmhd86dgMQiDE6vKYZhTP/i3CUTnDcyV
         bzsHc+aiNhgwQhfEEx8yf+Ws+AfyYipf+bXSrVbRyU4Df/dTvFPsIzDvmI8CmTVUBAoH
         nHwvWaZ9Sjvj94MzE7yFBSWGmv+KGh5WwU8u8E8GaNCE3C8sravQyE4xGsvjWuyBn2lM
         eDu1GG2zCYyRjG6/qe713+itq+Uj4Md2PixWcuXTjhDiUQSm0DwEh2rHvAw2r7nUcjKB
         oAAIK/W1hjnGcHmZkCW2IQ1WdobTOlGI7ZOPs/aocq7eqC0vEAGNPn0YKyUUwEEWwVhK
         h85g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779126713; x=1779731513;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W24vIOGiSP4y29K9PfNEC3xchhMtUW4j//8Nr4NBCog=;
        b=GKQL+pU0Uc2CgraDCf/6TBZ2QEDHGK+heQhAMfaglhTg91bSRHS+F1aYcYDNCUEYe8
         w/gt5pAV2aM7fa6wWqWrIMs2y/CGWfEXZSpzxp4jgi1c5D02CCK6XuF02Orh1f6BnURk
         OlRB7V2xzK3MDn9zDMvdX2cxfJesQaccXsj+5ih9sijUO5PaSbGhgz5TFy+RPpeNpMYA
         UfGmMZnStR1o1pq7i+1LG1DX///KmC17vq+zCgMreSMyR377v7VtW3IhIsGgOcskukbg
         Wiq++vpC5kavJhdcuAaJwFgOyY0/8pTZv1bxbf2kFReDiJhH2Fq6TsF2mejPzVCe9VRi
         7fZg==
X-Forwarded-Encrypted: i=1; AFNElJ9Fj/29iQSamWbCJizHilG3E+GwChquiD6El3C7WkTkcJIGyO8RUPRkTSh9EdQ4z9H/DQPHhTdkjjm6V6k=@vger.kernel.org
X-Gm-Message-State: AOJu0YyjXB3voQQRdA6bVHkGOQeh13pj9oGdDdGg41s8+5o0XwcNLKw2
	d8nvI3uUdlgkfur0eSy8IkTjjvydxAzy3Yk/xvDyiQ0H+9mSfOn/MLhYYXeOdeIBME4qKUaU5ZX
	PE9kl09b3aynn6iYrMg8yC0xjJ4NXesRpxLQrJcAhNqT4cUEttM6UuvMZHcOnlTrhTc8=
X-Gm-Gg: Acq92OGpeerKltOVS7acG1uS96N159V7+27A9PFvjltBemVESPSWFBGLYj1KEueeDJF
	td2XSqLRjKurd+W7gofBKMqDOUHzzVep7RqH62IZMou0ZRDwJ/+O4VtP/+0tERx7GRVYg9GJ3w/
	guSisBHoBBn9iJ2kMvWuqxxZqPlWLQnJqEUlP/7w2gdEUruTaG3QbQVk5q6vJvrgsbtFtDYCoRO
	2/fV3nsZZbOGijnI7rhEbkwoI1etlFp2aBQc84I4W1wRkj+Nh8CH2cVh7B7qHx49zi/2Adtkl7c
	4X10VaaRwdZEbudJVfW2+TznWHfJkjOeftJSXVqcd/kkHitBjVORoLyPV0zYh/9rbnFV+t/bPwv
	70mZr4RTjAn2hRV13I3o3WUHtkp0f+5mbKE524zmj2EnbKjwMN8p3PSmSleidpChngK/34c9LZb
	Y50jCkRQ+gHsXR9AnPbjy192ZfOoAzmylAOvo=
X-Received: by 2002:ac8:57d6:0:b0:50f:ca25:fb48 with SMTP id d75a77b69052e-5165a26b016mr236818241cf.55.1779126713013;
        Mon, 18 May 2026 10:51:53 -0700 (PDT)
X-Received: by 2002:ac8:57d6:0:b0:50f:ca25:fb48 with SMTP id d75a77b69052e-5165a26b016mr236817891cf.55.1779126712506;
        Mon, 18 May 2026 10:51:52 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3958878a103sm13495791fa.29.2026.05.18.10.51.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 10:51:51 -0700 (PDT)
Date: Mon, 18 May 2026 20:51:49 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Harrison Vanderbyl <harrison.vanderbyl@gmail.com>
Cc: andersson@kernel.org, konradybcio@kernel.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
        neil.armstrong@linaro.org, maarten.lankhorst@linux.intel.com,
        mripard@kernel.org, tzimmermann@suse.de, airlied@gmail.com,
        simona@ffwll.ch, jikos@kernel.org, bentiss@kernel.org,
        luzmaximilian@gmail.com, hansg@kernel.org,
        ilpo.jarvinen@linux.intel.com,
        Douglas Anderson <dianders@chromium.org>,
        Jessica Zhang <jesszhan0024@gmail.com>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-input@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH v2 0/7] Add support for the Microsoft Surface Pro 12in
 1st Edition (Snapdragon),
Message-ID: <qfoobb7xrqkc5ivs3v3wcymbhywwqe6albcijchdmkhwrvdatg@pbsnwdrawko6>
References: <177869930359.1496076.12020223802779537187.b4-ty@kernel.org>
 <cover.1778822464.git.harrison.vanderbyl@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1778822464.git.harrison.vanderbyl@gmail.com>
X-Proofpoint-GUID: DVhwCfV1T5naXdu4lwECfDGcry6bivk-
X-Proofpoint-ORIG-GUID: DVhwCfV1T5naXdu4lwECfDGcry6bivk-
X-Authority-Analysis: v=2.4 cv=BICDalQG c=1 sm=1 tr=0 ts=6a0b51ba cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=DHJDpsF2dBqhSPlo:21 a=xqWC_Br6kY4A:10
 a=kj9zAlcOel0A:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=9VIlvAo4FWx-UwQJ4rAA:9 a=CjuIK1q_8ugA:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE4MDE3NiBTYWx0ZWRfX+SRDNo7BYgzi
 eKUSsE3o8R+fe5H9lTEnOSkip2VIMqfvBUSUi1mUjTSc4Y8L3aE51DvoZfOecqg+x9LBhHXMkmI
 SiBwIfa5T4xlyRSWJzq28cn0a1q2cY5FJbwNdmcFbNGeXeX03az3m+07gLGVtL5QglG2QhR0XD8
 lD9Vm0XSCKiqBe7TorUXm7aD8RT8fMKz4dvBgzio6IhcYAmEKLiiVshRfLTHCY/kaDnDFuKUKp2
 cZKyMd8LNzbjucQy4ljsy1Lkisgq9k7/drXFYtVYH0w0oadpk+PAPphPfVlSOMqsiFVDRKEFmvz
 jxgYJT/G8kXGSOyNLehcKqbL0oEBU0NWYZOYLqq3XU8kPFGVQt3LoODEViosj2ovHJIvxTkHvBc
 Am0WeBScnhJXdEF6RJ4d2JVG1Azr6fdGzec1u2PnEAtzWB8z91m9vZxHVQ3SOUWimSwpIfBxNxP
 3MsEGLvr9QvEsxq6lCQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-18_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 clxscore=1015 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605180176

On Fri, May 15, 2026 at 03:41:45PM +1000, Harrison Vanderbyl wrote:
> Changes in v2:

Please don't send new iterations as a reply to the previous iteration.
Always start new thread for the new iteration.

> Ice device tree: 
>  - Updated to use 0x0 formatting
> 

-- 
With best wishes
Dmitry
