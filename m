Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD7334DB7F
	for <linux-crypto@vger.kernel.org>; Thu, 13 Nov 2025 12:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763036917; cv=none; b=Lv8IptT3OgpqjPLZa9iMpQgA3tAwIouSHCXuFv+xGbJavilipvxFmU4BGjEveq2x32cmY9A65zhdqQ5+Kd41WinM+hyTrEiSxzPph3NutUBQXLPxMb9csjqkbc0jD7eE7yHocTQ8V9K3gQF6wAF9s+++XQIdmMMf80eJ2nQ+rD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763036917; c=relaxed/simple;
	bh=XRz5CpX58FzZ6Py48iS5tMNcegYVIQP1CxQVyYVTqHU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PjKPVzRKx76VKYYPNLOyYDL6M1gqRpxbKXQew1hQQ1Lz6xURG8n9eVI/YEpIFYduWYRawJyT08qSPSUkLfX0GgOLRrPOIpk+HIOsk6ZY+KKLHUzaiP8JfU8N2mASwJgYNUw5ENTQvN9VodrXAI+kng5WZxQkI8GFC3aHGlJWBFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=dCLzmV5w; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=dKFIOxix; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="dCLzmV5w";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="dKFIOxix"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AD65oMV3563726
	for <linux-crypto@vger.kernel.org>; Thu, 13 Nov 2025 12:28:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Dc+nXsVIfk+kYw0a9SDHakUwMtVHi1qybXAJiieTfWo=; b=dCLzmV5wSYFmslfA
	QHRxOADcLZOP6Xqh1NTonQP7J6xadJEou5sDtmcyuezGVFSAz8LVBmWQ2KXisKsQ
	ZynF2EHUFLlH13rTe2BDFNWmXnjBk6MNIAUCeYrUS2oYy044zsHM7iSFE1vmxVxX
	xsZHYNvPinm7FkMhDfdd1/J6obNP4UIn8CfFHo+TdxR1ehsfsoZapgIvuEhfkgyk
	mhxdxFPdi0OPRWqpSAom58m/4j0FK8qdC/1x6nnqxCuWDQ3OVrMunz+4x/DI8cp8
	KoV202rFi5gSt0ZVopd+ntX+7kIRKtnPkkJV9uOTxP/JLPKCBxKkrY470lPa5AYW
	sWmwVw==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ad9rvh3wj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 13 Nov 2025 12:28:34 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4ed7591799eso21136151cf.0
        for <linux-crypto@vger.kernel.org>; Thu, 13 Nov 2025 04:28:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1763036914; x=1763641714; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Dc+nXsVIfk+kYw0a9SDHakUwMtVHi1qybXAJiieTfWo=;
        b=dKFIOxixz222choDUNiZwrqABjooXNHFL21MblzlmSn48j6JBWOUK0xVMiyVoRdTqx
         //DBxo4onRTkEapgMtHo+Ix7N+xrlmEBqJtnnCV6XKjVtc6nLhVVHAOe2SYCe1HUv5pr
         19AKif4pc0xp1CxW5WvNC65iK4QvYedzlYUXQNN0i0rrdWGbmavQVTy3jHHFefdItRuF
         d0Sgn0WnP91DjI/0nbHrCPdgT3XXcgldkO50zy2UzAK67nQep7yPXVkpA01B3bKw+Aa2
         Wh/QAM9ZcDFPVhZtNP3Gi0QiyV8z72i/3SBYHBye6TxBw86KkgScJgBqVQPZTWQGadpI
         UxfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763036914; x=1763641714;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dc+nXsVIfk+kYw0a9SDHakUwMtVHi1qybXAJiieTfWo=;
        b=VjrY4XlqbjW6eXqV4CElrtHlA6HHGK5b37kcCgWICiNrNvUbxt17PQyx8e08RmyQzg
         xfEmu/AcJsx2BixlA0vD8cf7rH/jLCbqGJaDBx29ZEWnHZw4mMymmWvwteXIhere/n/u
         hHtiMfpsauwQFNNmh6w08bGt9vc/tnW9Yrd5LPX9T/cg4iQVTSoS301dmfXwLmcdcpYs
         fIpALFZiTk6O/vNopPsTWH7zaFFUi9l9ETR8291csiosC4bfVrysvXsqLFmgvkXKfko2
         mzh8sJ8DZllLHkiRpy7NpBWp7t3mv0Ew7kB26jrezPiY8CKtJaA4vY27pr6kjb2An3S3
         XE6Q==
X-Forwarded-Encrypted: i=1; AJvYcCVW1z1TGiE2bmuyAOScuzAkBWq02ZBlizDbePC/9YmfhaCptkgxpyV+zN/oWBoJQSPdvS8NA9b4z4S6HTQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPlbeB2uYLAZ8sc17KSaEeXpKdpov3HDxjfKT/LEDlQYc8tKHc
	/pz/3Q4wf6GXCHd24FaOja33n0Y26xb6UKPFRijcYPXVC7jUWZBMGE1EF8ZB3s+rUozs54J6wra
	8QLye5byfYlcmZhK42EynRgA2KstJ3XKixW5RcScjNscDiIXbtHLBbZIjwDrmNF8gkeM=
X-Gm-Gg: ASbGncsYrLmz38bI/rUR6bpeBRJFOT5pUdxuGiTiEthsKPJmnCOSbEWR2YRZHqAbruK
	m/Aautpy7fTUqXyn+812aAcOcbqCr+s4i+syc04tLRm0pEKcHOEqPy3iSG9wLXtipBnmMCrt91k
	gy9ALsFC7mTZjNxt/V3HpsnDbNfsB9VNRyVHCADmAkM8KoJ7w3XudJ4cUXByHrch0HtWXJzsFbI
	6JmP8EDR8m5oFlS3kKvEK5/GIfzjlOGNkoETGc/Fz9lIMJdyrahefr7Xs5FHng7Q4/wbk0PnKSY
	0498WmgwhZ1lb17nBFhPOuUf339jaLTN0gN53Zn/Cmb6VXtTtprcTaF0Z6lsgPJUJUn8OigqlPI
	1CKiLgmpaK90O1+mfyeW1yvDWSg9JUT9rBQ77zz4RYtHsfgH5JSSqzavIcriCR1UPHCGqbg9ZBJ
	jy84kXggMPvlFm
X-Received: by 2002:a05:622a:450:b0:4ed:aa0c:5ed3 with SMTP id d75a77b69052e-4eddbe1fb65mr90593541cf.56.1763036913589;
        Thu, 13 Nov 2025 04:28:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHl424EUsKOX7ilgawVQ1n2x4FN4hOAJvrDsPMxj9xL3zRt+q8/YlY9Rp/WoxcRjg0fZHCeZg==
X-Received: by 2002:a05:622a:450:b0:4ed:aa0c:5ed3 with SMTP id d75a77b69052e-4eddbe1fb65mr90593041cf.56.1763036913059;
        Thu, 13 Nov 2025 04:28:33 -0800 (PST)
Received: from umbar.lan (2001-14ba-a0c3-3a00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a0c3:3a00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-595803ac925sm367710e87.10.2025.11.13.04.28.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 04:28:32 -0800 (PST)
Date: Thu, 13 Nov 2025 14:28:30 +0200
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Udit Tiwari <quic_utiwari@quicinc.com>,
        Daniel Perez-Zoghbi <dperezzo@quicinc.com>,
        Md Sadre Alam <mdalam@qti.qualcomm.com>, dmaengine@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: Re: [PATCH v8 01/11] dmaengine: Add DMA_PREP_LOCK/DMA_PREP_UNLOCK
 flags
Message-ID: <m4puer7jzmicbjrz54yx3fsrlakz7nwkuhbyfedqwco2udcivp@ctlklvrk3ixg>
References: <20251106-qcom-qce-cmd-descr-v8-0-ecddca23ca26@linaro.org>
 <20251106-qcom-qce-cmd-descr-v8-1-ecddca23ca26@linaro.org>
 <xozu7tlourkzuclx7brdgzzwomulrbznmejx5d4lr6dksasctd@zngg5ptmedej>
 <CAMRc=MdC7haZ9fkCNGKoGb-8R5iB0P2UA5+Fap8Svjq-WdE-=w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMRc=MdC7haZ9fkCNGKoGb-8R5iB0P2UA5+Fap8Svjq-WdE-=w@mail.gmail.com>
X-Authority-Analysis: v=2.4 cv=XrX3+FF9 c=1 sm=1 tr=0 ts=6915cef2 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EUspDBNiAAAA:8 a=KKAkSRfTAAAA:8 a=5NgRZS-Cu3st9J7LMwIA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: J8ucK4vdGiefi5y2yUW1NNdziDsZ22Gx
X-Proofpoint-GUID: J8ucK4vdGiefi5y2yUW1NNdziDsZ22Gx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEzMDA5NCBTYWx0ZWRfX/rq4XFv2RKt+
 05PU2RhVOsVTosXM43u3LyLZ8Ukf+3YptmaGtRRRBt/IETOmtFenwiY6iAIpFnrlLgms0ydNQiq
 jq9erK9xtGkgMnpR5/WtEWL8S+tJv04x4xGc4jg81spJ/uzNzEe8fcCERng1V0CxX9eCsRy3iqm
 9KSdihsXp4TeAma+YwBwV4yK+ADOavtAbeB5SHxi5pooRm/WM8aBRm1Jgeb4Yxm4HNjKbC0Fe1S
 2lK0ku4wKo6V+UcIGBtanxhqMHSZAoep9U+baoF07/hTySMvbvJtl5a3FxiZlKxf7JiGbgZxDSC
 QfVQx1SPJ6DFH6oT6mQrm4i8Ra16ttHlZQt5GW5jUu8+T3J2t18/SnUCGaqZbZprZkA0hN0/fxv
 AB7nkLyQgSSoMCJub8ANDLMAfp01OQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-13_02,2025-11-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 spamscore=0 clxscore=1015 impostorscore=0
 phishscore=0 adultscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2511130094

On Thu, Nov 13, 2025 at 11:02:11AM +0100, Bartosz Golaszewski wrote:
> On Tue, Nov 11, 2025 at 1:30 PM Dmitry Baryshkov
> <dmitry.baryshkov@oss.qualcomm.com> wrote:
> >
> > On Thu, Nov 06, 2025 at 12:33:57PM +0100, Bartosz Golaszewski wrote:
> > > From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> > >
> > > Some DMA engines may be accessed from linux and the TrustZone
> > > simultaneously. In order to allow synchronization, add lock and unlock
> > > flags for the command descriptor that allow the caller to request the
> > > controller to be locked for the duration of the transaction in an
> > > implementation-dependent way.
> >
> > What is the expected behaviour if Linux "locks" the engine and then TZ
> > tries to use it before Linux has a chance to unlock it.
> >
> 
> Are you asking about the actual behavior on Qualcomm platforms or are
> you hinting that we should describe the behavior of the TZ in the docs
> here? Ideally TZ would use the same synchronization mechanism and not
> get in linux' way. On Qualcomm the BAM, once "locked" will not fetch
> the next descriptors on pipes other than the current one until
> unlocked so effectively DMA will just not complete on other pipes.
> These flags here however are more general so I'm not sure if we should
> describe any implementation-specific details.
> 
> We can say: "The DMA controller will be locked for the duration of the
> current transaction and other users of the controller/TrustZone will
> not see their transactions complete before it is unlocked"?

So, basically, we are providing a way to stall TZ's DMA transactions?
Doesn't sound good enough to me.

-- 
With best wishes
Dmitry
