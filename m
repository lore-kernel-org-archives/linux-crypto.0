Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56DAD3AB5B8
	for <linux-crypto@vger.kernel.org>; Fri, 12 Jun 2026 06:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781244671; cv=none; b=N5i6VMDLAhl2RtTqQCEPNmC280J5jAsz4B8gF2NcbzSc/3/1TN76KssdR/LlMSHhUS7hL6L5fjN02e7QkBnZM6z9/tpJMcr0JqIp2FpZARpJLenQgF94I2Bp+nR5AlRMHQLs5Agb4032ACKMZLWSS+Zq8nuHc9HhPWRExtdx85E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781244671; c=relaxed/simple;
	bh=N+Gm2HSJFkbJXuQJt1G46yvDEIW6X2a740Azcl2U7co=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pj8WcB5DzywoTPZv+7WhHScW4DzESU1gJ6VlY7B3TutLx7ll5muBf1EXY7+KdG75TQlsOzEE8pvoNQlTi0ow55nYkGK7konKaijJGLBybajbmAOeeEH+AvrGDyhTUwuHgAtYF75g+mC2qMgy18WjCxwZKAPklRp1ivt+HjxTrrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=j164tRX0; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=UY9T/ywO; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="j164tRX0";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="UY9T/ywO"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C39V1S2411515
	for <linux-crypto@vger.kernel.org>; Fri, 12 Jun 2026 06:11:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=ekVFbnV60CHye/xjBKq0eWUj
	dvANtvBJPng1GEY6wXA=; b=j164tRX0Tt47C0NZe9QfkkCG8Li5HXkCUGGWXGiZ
	RHz7JvQ6yPOHkvTS6tzcwA37DfQTWUaqhQI+bsTwqJBNYhVgs7Saaj9cjY6KlOYT
	v0bZ2+OBMDcinHj7GvvGaoKJB4zFvcu2242QDqycXjRRl/hEjvdKtzvWeVMxP1Hs
	t7r3JfvVJoi7v022vv2h3t5l7l1B9Id09HZg0Em8MFLfJIvBWnAQWqnf4U7fqxN/
	a4hHA2qPMVq+p1Gc+ZxeGeWgbscKjS9OR5SfHpI72sjUjdo+Bfll8TgkXc/2srU5
	rLuOSlUTlmL+gn1xmPXp3wlLkXSMTusP/XHtny78dL5UJw==
Received: from mail-vk1-f200.google.com (mail-vk1-f200.google.com [209.85.221.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4er165abn4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 12 Jun 2026 06:11:09 +0000 (GMT)
Received: by mail-vk1-f200.google.com with SMTP id 71dfb90a1353d-5a2afc494efso699386e0c.2
        for <linux-crypto@vger.kernel.org>; Thu, 11 Jun 2026 23:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781244668; x=1781849468; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ekVFbnV60CHye/xjBKq0eWUjdvANtvBJPng1GEY6wXA=;
        b=UY9T/ywOtE7gRroNv1znTmNpFu4zC9OBOsgUp08kq6opeQud8MVe43Jd+JE7fGrKRL
         W2xvJDgQirW3IapHWUm5O+abbNUgnJdtMHX1FrEK6zr8uEtgi/fjSr+6f19S+xA0D3Hb
         lwagbf0OkKCNOxZXxF1vueYneWGqP3hO/kUe26MkWRL2clN0xIdy8fW/0mqbrnri44wi
         EpRyhBpHSgWxKJNVrfktcol+fQSL7jnIOtloO5ryaVCbLgsnOoY6AcWe2USAQipMgP0G
         TU3sJ7rJ+AO5nsbul3JVCpp/ypCwKDfWXHaxfk1fWVjjEePjIfXj53d5MTvYOr0O8sbS
         0f5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781244668; x=1781849468;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ekVFbnV60CHye/xjBKq0eWUjdvANtvBJPng1GEY6wXA=;
        b=QIJ5+7AXkSm+ndvOZ8nF5C7jJNXsJ/koRcTRNTDvJU383Ws9Yzg1kOcUAvOooFrX4X
         AX0exljXUwNI28ZoK1LL2XwQfRqYttvZj7TpbQuUxkKALDBvDCJ+9rWUlqpcXewTltp2
         KpZm7C7Q7vdEqDF6+XekH2+cEKg09fmM/MunNme5QGTsjSgGbapRBzQmHv/IAwvkEavE
         B2Pp+JDWf5+2WVqZ9HSyw5pT0S2ErCVqQnlvWYOQKtb2kldtohRWTBOJODOaIK6Y0cDE
         mzTaWbxEaYh9a2T9KUsv1pbVmsQScVr+zZHKo39fboyKayRB2nLp+l+R2ND3EsZ19/1V
         8m9g==
X-Forwarded-Encrypted: i=1; AFNElJ/mnXVlEsQL3dcWRIQTTy/dGc8EzJCqzoVuwFfXocRikkdiN+nPX8bjzJC8ABBoFUywggYNqwoJ85uklHE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiNuM68lvKycM7L0u3OwnpIi6wEBZh9jDd6HJXNt1ysD2OsJPM
	Ai68LQYXke8lVONZ4X7Hwnu115lgTSyX9jieWpf0ggLWpFd/e6F7SZ6K6LXf8uA81MiyFMTY/ll
	HrTZOWSgCBZnvurCuey28jU2tm13IU9N1nvVcDoSOtu1a3FMp/53CXX4ZMOJLiR6CwNo=
X-Gm-Gg: Acq92OHXBW4CiP4iQz0dUL4lwJF/7xEGcJjXZ9oP2+Ki1KyD2vuWjyTHrEQXv73yXFL
	F/7lbDVBQYVcldsc4ZaLnmx4Ci4GmMfGKWw1G1saoyzk3UcaaICERWMIhSUYjJs/E6TXuIdAIbs
	k5Yh4MxyWCBdMihkWiVFCDaZ2baFKfrOoaWlpQKC0owdL0+zoJCEcO5gMLmIw01nT99TlzHdGYh
	0NkhKIqWMYAAVQPsaCU7JXShZ289qnERbUgmMDjVmf5uEq0zI0p4rS0t4FaAXPRAZgk+Ha8qA3f
	R/ZUB6woJOL5Bbb2vMsn1dQuxV9v/nwqdJZ8HrmyezEqyNKh4p3m9Ysh1za3fuw+xyEV1J3nizC
	M8NB5EFwbQiCk7mwQdsmRgoMCD6b+qMtMmxPt+Eo4xabZtIK+rqTYyQmYI3AriTsxur0POFEk7W
	YkfbLiWPoai0TRs0ge7p2VCt67xsgDUWpC8og=
X-Received: by 2002:a05:6102:8019:b0:631:7781:fe91 with SMTP id ada2fe7eead31-71e88b1b9aamr611366137.9.1781244668614;
        Thu, 11 Jun 2026 23:11:08 -0700 (PDT)
X-Received: by 2002:a05:6102:8019:b0:631:7781:fe91 with SMTP id ada2fe7eead31-71e88b1b9aamr611349137.9.1781244668166;
        Thu, 11 Jun 2026 23:11:08 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-39929f1b4basm3579991fa.24.2026.06.11.23.11.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 23:11:05 -0700 (PDT)
Date: Fri, 12 Jun 2026 09:11:02 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Bartosz Golaszewski <brgl@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Thara Gopinath <thara.gopinath@linaro.org>,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: qce: Fix xts-aes-qce for weak keys
Message-ID: <wesx5ccirum4yjrg3d7bstv3alvddrghsancm3fj2hhgo23z7u@pi6ngkzezgkg>
References: <20260610-qce_selftest_fix-v1-0-1b0504783a46@oss.qualcomm.com>
 <20260610-qce_selftest_fix-v1-1-1b0504783a46@oss.qualcomm.com>
 <533motquixnbence674lawbnlnxevcrcnysymwncjis46j5uoq@wcemraangg63>
 <aiuA8CCGcfP6MdLy@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiuA8CCGcfP6MdLy@gondor.apana.org.au>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA1NCBTYWx0ZWRfX9nZLxAo3Qa2K
 SuwM8s/l3zeDK19/NmJmMgwFLYu9XWRDccvY/s46RI4sx0B514WnpIkrDz346L9OPNrIEW4ukXH
 FDPMI8MslG4rihdHjwJ4RpXF579QafGRzusQL1viT5l4rX9TLuqszB0oKnQ//eCYBGrsSqtCRmc
 nCg/KPe3kvjhoqD24TXLbmsB2AhAVXaUhYwWE/Za0H7FFFY5ra+0aK90esKsFU4GAPD7vWI8vu6
 JMRyf92RoO0B5KwE2JBcxg2v+ffgBiI1vdH/9D5MSFXrRwXxbGrNebJ5du8sUqNqupwpqpHv3hN
 8Uy7M3YJWATohbSDUdcHEbvjVfC3ULwWF5/Gwgy7O1okTgFpS7Wc9s7ajvRLGx1bQgRvLoSh7Da
 z3tOBeKA+9XA4bEZGsuJjwfSwCGPNM7cGGGzMz5aHJzhD35vxA1cWLWAazJuNCuM4zLgbQGv9qa
 3gFZeUKHYNghDWktmWg==
X-Authority-Analysis: v=2.4 cv=LNpWhpW9 c=1 sm=1 tr=0 ts=6a2ba2fd cx=c_pps
 a=wuOIiItHwq1biOnFUQQHKA==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22 a=3eZhI8LKvID409CYhekA:9
 a=CjuIK1q_8ugA:10 a=XD7yVLdPMpWraOa8Un9W:22
X-Proofpoint-ORIG-GUID: dZQg-zA56saLrYX-pschnDu10UuX5Wvq
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA1NCBTYWx0ZWRfX36cj1qKPEHiM
 DSHwtT/4FR8AoLSv6j7eT24Vj5aBrZ2E6lphv2pnk9Y2IxnnWVyIDYy5WrqDhLjmAUgw+I7abX0
 3fYkgI8c9kPMYlzeM0p5iy8JEEqfbZ0=
X-Proofpoint-GUID: dZQg-zA56saLrYX-pschnDu10UuX5Wvq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 adultscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 spamscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606120054

On Fri, Jun 12, 2026 at 11:45:52AM +0800, Herbert Xu wrote:
> On Fri, Jun 12, 2026 at 03:40:49AM +0300, Dmitry Baryshkov wrote:
> >
> > > Fix xts-aes-qce behavior by using generic helper xts_verify_key() to
> > > reject keys early with -EINVAL for FIPS mode active(or FORBID_WEAK_KEYS
> > > set). For non-FIPS mode, since QCE hardware cannot accept the keys, use
> > > software fallback mechanism to encrypt the data.
> > 
> > No, if it is a hardware driver, there should be no software fallback.
> 
> The driver must support everything that the software implementation
> supports.  So if the hardware can't do something, it has to use a
> fallback.

It's unexpected. But you know it better than I do.

-- 
With best wishes
Dmitry
