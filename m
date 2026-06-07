Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7937232AAA0
	for <linux-crypto@vger.kernel.org>; Sun,  7 Jun 2026 20:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780865587; cv=none; b=tU+eObyf8aP3ik//qHOex1fYycHAoZUq5qxb25D3fvUED0DjHOzuOHSgK/fTak8ziawLpsMyi7cuxeorgEAUctcdzH2aZDdgq6JABkG1uKkxNQ+8OgLP0X/JFCdKD8zK9jDZWng6CskejsjRc6dBbYWOlFV7X4Cge8ZnGr/iA64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780865587; c=relaxed/simple;
	bh=nSG49t2rWl45pGWYF1OsDUoVekoqCmWTFjRJ1mk0I2c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GOtLMaTAvN5TkfzjFdufw8GjMnPcaAQaSClgC2qkC2bIaPQPuS76ANe/iuY/iEIaj8OSmmr7Wg2SU0w2iBoyQlg9ncF2lp86VNaV0ax+I+ScWLEzf+7Lu6D98EqEY69/ve98TvJqsFqAJMbtmVZxZrh8ZEp+I0dsHNgCQ4xFu2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=TTUSJ/G6; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=IXwUF4+I; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="TTUSJ/G6";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="IXwUF4+I"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 657KcdXL1080892
	for <linux-crypto@vger.kernel.org>; Sun, 7 Jun 2026 20:53:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=p16AzikaBGvxHOE7IgOcj9y4
	UVGtNm9juMaQ099Gfyc=; b=TTUSJ/G65OWYRJ6OpkesxCLBy4cHdz2HNiXFJvj4
	eF7eELJQLuDGB2/hbv77pWXNZ0TxKtLWjHWBK4k/hKnL/mx0R6s7Q5BJaM20UfPU
	xNHkO5MFc6dqZhAPfolh77LZh/4ArmqVGXuP9inBnHJpuCW3dlHMUY58wmv+5Hjq
	E5Z0/SENEagL+uK5XsnZw/ghm3Cpac1g11wwk6ubdv20xuO2GQt3k6Fe/saQmjYM
	/CKlZjZ9dFDSQBKyp0JHjf+i7DIE2I4IN90VwjPgVpfAUIa27CWfX31pe7KDEPcm
	RU3L0CE+B0uawkjjqpdDGgJqdOa6nPjWV+tyvnl9pCoNLQ==
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com [209.85.217.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4emcadvfq2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Sun, 07 Jun 2026 20:53:05 +0000 (GMT)
Received: by mail-vs1-f69.google.com with SMTP id ada2fe7eead31-6cfc66167c4so1475556137.1
        for <linux-crypto@vger.kernel.org>; Sun, 07 Jun 2026 13:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780865585; x=1781470385; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=p16AzikaBGvxHOE7IgOcj9y4UVGtNm9juMaQ099Gfyc=;
        b=IXwUF4+ILgHq4AKH3BaBfbY9Ua0ItNEk3XyISsfBG5nC5v2F41+jf9GdOeZbJ2Ax5s
         5PLb4KLDcJk1fNncC01YF9uhc7LdqP/V3UYi0HWdLnSNSskttpa8ucEMoCx9u3WjUFNx
         bw5OOdkU7v2VPn4tRhT/a+uK2RmoHSRvz/nsXBxxxtEWayUetbXJN9mM2K4OA/I+/zU4
         Yt3IXkRW3mJpmiqfffxufUMMP8zlhPaSjejzihQRRgeudRlwAF+lY2eTLqybfWbAbfq+
         72bZdZj+rzH/zrGqWT5boE0C8dXg4VVEbLTDTmqitfgg7KQWMOypzPQKnj8JK1hKztZT
         w2oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780865585; x=1781470385;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p16AzikaBGvxHOE7IgOcj9y4UVGtNm9juMaQ099Gfyc=;
        b=o1Z5EqHwJvihcT40tzfpYPHbHVSpJkMsddm9pmNHn21r8WSdJoIfpy/kq51ajRLbcd
         RszQJTGPFeb4GXGt6Y57c2dKDEHXwhILaJP+4yUAOwk5EYHkCEXtP/vVX6QXJJP/pZWK
         9yxiEViL/u5NOP8vEQU2g7msH5IdYneyxeCPgGvoHmCoLEYzt7FiyRcUS9HZH/3cE1gi
         LU6b09V8nqjIlxmCUAm9vmRje+8Vr3v0/fmYkQTJBD3k25Pc/izZPghIZxtv0zkHY+F5
         u92W4VS44zxNaQ/wu5At2IquRGYfVx3UePdDimm2ugoOBmKUZbqfa67kh8qh8zFmPlhO
         40MA==
X-Gm-Message-State: AOJu0YwMDOTi7H4eZL86yNxGhWXr7YT0wo4gfbivZEbVUi94beGNszWB
	7GN/NrJzfWC80jKh1PEmEGXv6MqCDDtl+flB8CgHBtiTRE0OQU67jIhE0MfUt6Khc/Ju295y3fz
	V0RSgvLarx5bZDx4MdAJIlyBxoOcKjAsNJW1GfVQ6pxvuh2B3nThJxgzxE1kG7iRlFi4=
X-Gm-Gg: Acq92OGnUWrJMKfMDuEGCaaMFvdoimi0/FcLQcAiZkA5DTiHnKQMxLqVO/5CHZ6wAEY
	j0yqNnh0lxQi/+j4KKhs1p/PRQSaTZVknE9AQ8oIizxLxDFzghzFtxaa8bY2TK40J9vzbjuVoY7
	yO5xnRsChXg8hEKp948koXPscuJyJgQsMkCK+YXlNIQDOXP6bw48cY9g4crDO7jTKUVgrPrhJEH
	OLWfDktrwb90qBzLp/vToNSOfMymUz4Jlkz2FgjWraoqLsB1cnkHsDkFux8T0v+lilYX8cQ/PD3
	ZFxBWZzKQWmhmoRT9S/NvmNaRPzMq8roSMKvK0VLkDnZzxrOPeLdMtIlWr9O+eR/X64Hztk/b8I
	xIBd30ilbC1ilmOV2wrq/iucEYnOisqsh7afFN49sfSTdIZaf1Q3/J2yZGHJk+Za/vazict6Zgu
	GhFMX+H4A1211wjb7VdkhrQemulDHQ80OMbxcyW0jzM000ig==
X-Received: by 2002:a05:6102:6890:b0:6f0:3ba3:7d84 with SMTP id ada2fe7eead31-6feef09ad6dmr5751326137.5.1780865584623;
        Sun, 07 Jun 2026 13:53:04 -0700 (PDT)
X-Received: by 2002:a05:6102:6890:b0:6f0:3ba3:7d84 with SMTP id ada2fe7eead31-6feef09ad6dmr5751314137.5.1780865584069;
        Sun, 07 Jun 2026 13:53:04 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5aa7b990486sm3244065e87.68.2026.06.07.13.53.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 13:53:01 -0700 (PDT)
Date: Sun, 7 Jun 2026 23:52:59 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Om Prakash Singh <quic_omprsing@quicinc.com>,
        Bjorn Andersson <quic_bjorande@quicinc.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        linux-arm-msm@vger.kernel.org, Olivia Mackall <olivia@selenic.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/4] crypto: qcom-rng - Allow zero as a random number
Message-ID: <qf4lum2jd57aevapv7nognmepjpgrj4kylwkdbbslco4zn22ab@pudydze4e7ic>
References: <20260530020332.143058-1-ebiggers@kernel.org>
 <20260530020332.143058-3-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260530020332.143058-3-ebiggers@kernel.org>
X-Authority-Analysis: v=2.4 cv=DIa/JSNb c=1 sm=1 tr=0 ts=6a25da31 cx=c_pps
 a=5HAIKLe1ejAbszaTRHs9Ug==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22 a=EUspDBNiAAAA:8
 a=VwQbUJbxAAAA:8 a=Ovu24umgMWGFFTF80NAA:9 a=CjuIK1q_8ugA:10
 a=gYDTvv6II1OnSo0itH1n:22
X-Proofpoint-GUID: 1TE_8pbGA-vJcmg1q6VX2N4OrSGGfNPn
X-Proofpoint-ORIG-GUID: 1TE_8pbGA-vJcmg1q6VX2N4OrSGGfNPn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA3MDIwOSBTYWx0ZWRfX0MtqzWeEPJFS
 jjnih2vOVuYU07itpFVNCFOGo5fIQYZpMF78aM4yu16aGoyyos01XslYBEIA3WyQwEEz6l0VSt6
 e0esqMn9lslv2ynmMpMwSVQ3fY3w5cHBPXHrIDzkYiejPiorIqnKFY6bqvlFhHSk94xOy9/yFgS
 qL3ZLFn9gKMHjWTzPMDJRSC3vgIIeADOFLGrIw9W/HUsvesTrdBJRm0maeFuOGDvOVl1/Z5T3A8
 Y++wRsn70ja3f+Wro34No52QOMoTxpLaogJnwIdGMipEODETQeSZCQH1hxr1jmEOE1vIfrL0Lul
 yHY68Ozukqjg4npVH11BJMA7jyUkmwAD+DoqWteanS3tWeFr7iHzYsKl/XZl+cytOC/CNY4J2PT
 VuicVNVILtcLmu0C0LfYsOy98L/2PStqX8zUQEdE+vACSSlIhS6NAKKIBhsMGRJV4kd65SYH9L3
 UJ+gnP6VdxXh8iUFn/Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-07_04,2026-06-05_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 phishscore=0
 bulkscore=0 adultscore=0 malwarescore=0 clxscore=1015 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605210000
 definitions=main-2606070209

On Fri, May 29, 2026 at 07:03:30PM -0700, Eric Biggers wrote:
> Zero is a valid random number and needs to be allowed.  Otherwise the
> output is distinguishable from random.

ROFL.


Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

> 
> Fixes: f29cd5bb64c2 ("crypto: qcom-rng - Add hw_random interface support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  drivers/crypto/qcom-rng.c | 3 ---
>  1 file changed, 3 deletions(-)
> 

-- 
With best wishes
Dmitry
