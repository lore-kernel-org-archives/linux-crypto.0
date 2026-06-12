Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B958F2C027E
	for <linux-crypto@vger.kernel.org>; Fri, 12 Jun 2026 00:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781225011; cv=none; b=o8K9qnPrxgOlFeRll+2SLdyXWulS6uD/ezb2mSLzXqluaGRAyM5mDycFGMlS6mnJA0Ciqaqlb0x/UCzjW/+YpC/zh0Wgt+sLBGre0gs0iW9oyb+ukTSqjKue0J2VYNgw+7QeHglyFJcJ8hcwFbUXDgbLEVSfeF2efUvW02sGdhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781225011; c=relaxed/simple;
	bh=8jRkw6RfDHQ5Ir+6z83uy96MZP0sokiXORn64ldFT/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mPlXLqXa6YCwSBH2ix92DtCQFW3oIHrYRVLI5SJILPHR0EBdr7DfaS2aTt3j2UkT7xG/eAFCBvNNaikRLJruJwgv0dIY2nvqaISb/O9udUgtwRbijUtt8nD1nNh6O47i/bw2tHOFJ2es06RbH12udqHIvV1AECoQZ69Nx5EVCWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=NlMDORRI; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=WeG4lDoN; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="NlMDORRI";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="WeG4lDoN"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65BMUV2a1864433
	for <linux-crypto@vger.kernel.org>; Fri, 12 Jun 2026 00:43:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=xydnARKVU4Dp8mleKZj0tD/2
	fWrgzfcye+B8Z2l0sho=; b=NlMDORRI4RV+Zaa/yQmUPcvCJNHZO6shGb6hWAwZ
	x/BYMEMdx+H0x0opyojU7RfobPIj8944pAvvhZEqirrINGVKM5hIjk7KRZVx7lWx
	tZlwdKiDL1/x0bUMVLXmoRG55hEYbH6Z69XBNGFLX7MeWxHhAQA1ySI6sscjjWka
	+sMwjGns/gGMQ9pxznzZk2Q72t8NF7wo9bnrVwHImWxXISiTD8qWorfQkcOFA9dg
	FOTdawLOWKYjVVfVtZjGk2MCKos4LkV0+T0sLnxvu/sLBoN5NaVI2Kj1PthxK7RX
	wW7j8F+bCZ+ce9ztrdATt4HnfqUky1rMymoI0LfO09c/Jg==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4er1xchbqa-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 12 Jun 2026 00:43:28 +0000 (GMT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-517ac42d958so6612721cf.0
        for <linux-crypto@vger.kernel.org>; Thu, 11 Jun 2026 17:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781225008; x=1781829808; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xydnARKVU4Dp8mleKZj0tD/2fWrgzfcye+B8Z2l0sho=;
        b=WeG4lDoNstJwoMgAPkxqKQneZziHd8Ut7GazJGdCt2aNV4T6mqDWAO/H69pkxL9LNk
         9iM4KP5ScPCc6U4hZ3zfxbWiHtEq8Sp8vROzONZ0qu1XylCdxZIK3Q7SMQLidceg1oCq
         4UKRGmJAEffcgq8YjaZxbdfEOmIWPd9JGkCNLkQKYooISqvMnbJGl6QTfCvxhLkCTA2G
         TXa8p1qgbJgSa3henmRZ4x38809+DveXaVxKfOf1xsroUKvD20DdGHOHZqqfGEplmR3j
         wWq/dSNpGvHAJ4tgscg6OoxmqLEF1omQmEaWRwwsKm1dFddPuL3dKbxdHzLICo5fYFEh
         TnQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781225008; x=1781829808;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xydnARKVU4Dp8mleKZj0tD/2fWrgzfcye+B8Z2l0sho=;
        b=csOrImuo9hmfDQlU5wXVo1jqwwIWn6rVMvX1ZlufRViYU0vGM/4Rx/ZXNTWksfpSO/
         G2tZ8leQYxxj2CB/8LJ8l+M0lM/UBSKMGbDRTtbPScCsE081qyX1sJH/tYbBbqcGvqrn
         AC/ivYOkcNYdC3xj2ChtHB+AMQPCWviFM6HqvnP2wmQKS3XYuUOWWYFUeSuLxMR+Zyg8
         LLTI8PIQ77H6H7sexCYJCN0b4YEGRJV2xIgSSClPcyM6mTv6NKQjEV1MpKlgzU/V2goQ
         TcPdv28Vd/NFVbHnm4bQb+ZWPazxYIXGxZEfGa3Ue8a03UpoqsJaDilGJmlceMKCaAAH
         wAYw==
X-Forwarded-Encrypted: i=1; AFNElJ8X8kaTZYbqdSQgSsvFAs/8Q8Ax1xB68zZGN+aMj9/Fj+5a3kR7lDcJGL7lTmlCoyW/pBuvTmWHyQ/0Ysw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLI5z/EYbpPJ0JYjoDEP1tVIvk9qgP6p6bh1WDwG1/Bte5KmOw
	7GKkiysIPjD8w/pHrrjXBmXpkzeSvyZRkgQZlXB+Sn79omNoBjoskNx2/tx5X6LYPl1/LbivUGB
	OTGyLFs5bf56ISFSpdo6CXQMc2LW4IroKtGRTnm2mT9uXsPHIeudwphpIeH3e61mVRIE=
X-Gm-Gg: Acq92OEf/XKVVwJ09lleIrb3kbiVdOFuwVe6B50mt0Tj8/curZ7bB4/9+lB/+ptieKK
	Vbnn2XAASiio34stlIpGF0z4TDnDiyUf78b+HKRV5rz3dMMFFvfhw/Q/zLnQIbQmtGR2AOLoUXy
	g1XPk8eC0WlEIK7wAYZQb8yI7SaHIpuI6vVpy78MAnreMUXiTdAf820X9/2y3kVBsOqVhXyN1cL
	84lLhc+bR9Iqq/3FtLZIJFdBub/9b8dVd2v9so7MVLtL5NCvZGMgY9qq2hQueftwMWxq/yCbn6R
	5R5Sw2HxdDNG67ZrdBvZkxxAR8zPa9MymJzdcH+xvbjLPVh4+qlA1DWVlyb6OHHpK+yRBGkkvDR
	FJu1HLrKeiIVyKsq+J2M4Em62ZuAA4BiXWzFrTmPzigc71nbaq989gzEDXPnPxZYWAmb2BPREg2
	v33R7zAtK+4m8z3wyfA+FVg1PHIbejuRIPULw=
X-Received: by 2002:a05:622a:488d:b0:517:9407:5c36 with SMTP id d75a77b69052e-517fe578a22mr7529451cf.53.1781225008199;
        Thu, 11 Jun 2026 17:43:28 -0700 (PDT)
X-Received: by 2002:a05:622a:488d:b0:517:9407:5c36 with SMTP id d75a77b69052e-517fe578a22mr7529221cf.53.1781225007811;
        Thu, 11 Jun 2026 17:43:27 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5ad2e1b327asm60552e87.70.2026.06.11.17.43.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 17:43:26 -0700 (PDT)
Date: Fri, 12 Jun 2026 03:43:23 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thara Gopinath <thara.gopinath@linaro.org>,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Fix Qualcomm Crypto engine self tests failures
Message-ID: <4fzeulsheu5tam6pcymjqkqnqi3ibjgwchiefy27wr7b5i2yhk@4m47fpfbsmwf>
References: <20260610-qce_selftest_fix-v1-0-1b0504783a46@oss.qualcomm.com>
 <20260610184205.GB1158828@google.com>
 <1abc518e-e24e-44ff-9b15-1766dcecd8a2@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1abc518e-e24e-44ff-9b15-1766dcecd8a2@oss.qualcomm.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDAwNCBTYWx0ZWRfX7oOgV2QeX10J
 DxKTa+oExeEhpJkD/CA4gJRevZpXUsXnEU9q+PrhRgN+03e20ejTnb0YgtHtxDFHRFwR9qjKmaa
 lPb3pHoRQv7wkl2LAbgsCaLvmFyrZryNi+HVyqbJrSEROQ8k+mfqK9U7SKvT1a0Nt3v45hx7bJM
 BzfbpDHqu5Dnt4TF+ptOLoo0T+S2wdnIsJOYuzXUIKJfpalKkvfIBRGVcyBUMUHHNGOjyfOmGmU
 XgR3701zLMloC6OySN+f+eV++zno0qWG+uEjZlmsHJQZAvWkfcCFjAjngBa5EoMtKRGqtONHnQ2
 LueoKVA5nSYtkPmN3LltDAByha2uWR8a9aPU2ZgY/+RiK5Xhqx5hL89MaNPf+FlDyXn+90aMMsu
 NhYG38oakVV86/26XnoGDvIPXHiO9PHRWnTnb1M4BLr0Zjl8OxYHayRQyTepohiIKkZJvYb9iPB
 WGeV/6ARRc5tb+I2zxw==
X-Proofpoint-GUID: DtKro2wDNTBmnfNIiBXZ7uqpAHKyGAJB
X-Proofpoint-ORIG-GUID: DtKro2wDNTBmnfNIiBXZ7uqpAHKyGAJB
X-Authority-Analysis: v=2.4 cv=NZPWEWD4 c=1 sm=1 tr=0 ts=6a2b5630 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=QF-RXkosJRkZplQLQDAA:9
 a=CjuIK1q_8ugA:10 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDAwNCBTYWx0ZWRfXykigQJJ9/cKn
 pEmC8cOQoqhdDZf4a2EoOazxcEU9zQZJSQML86JuLqjHk+Q5zcSNZ6rrCI5MF9BZN9c7ZaM+Ttg
 OVMJlm5IAzJ9rIoIXd1gb9ncwRfq7Y4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-11_05,2026-06-11_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 bulkscore=0 spamscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606120004

On Thu, Jun 11, 2026 at 03:17:24PM +0530, Kuldeep Singh wrote:
> On 11-06-2026 00:12, Eric Biggers wrote:
> > On Wed, Jun 10, 2026 at 11:24:03AM +0530, Kuldeep Singh wrote:
> >> Steps followed:
> >>   - Enable EXPERT and CRYPTO_SEFLTESTS config.
> > 
> > So the full tests (CRYPTO_SELFTESTS_FULL) still haven't been run?
> 
> Crypto_selftests was only run as there's some discussion ongoing with
> Bartosz on removal of deprecated/unsafe algos.

pointer?

> 
> Seems Bartosz will be sending patches for algorithm removal changes.
> The rest relevant selftests issues we'll fix accordingly.

So, the old kernels will remain broken? Or do we expect to backport the
cipher removal patches too?

-- 
With best wishes
Dmitry
