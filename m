Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7D726CE3B
	for <linux-crypto@vger.kernel.org>; Thu, 26 Feb 2026 06:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772086453; cv=none; b=i4tlFTif6QmklhGUakIFFbpCx2/tTka8iUBMgsCMHBxjLOwk/JfFpA5SPBRSGSZBULY/YArxIJozR5obJH+Q/xLXIMoSMpFYIEgE4jEPHlqNWRCxE7yUH/LNQCE7Zn+JMutkxC9wthGjna982agtRZfwG935F3E0orrQd2x3lyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772086453; c=relaxed/simple;
	bh=m+AQKCxO/LycJ/O9uPJYO7qZo0j4nsAa3IseTsVVrv4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AoMhMs9o3cHsWYwffqXSRH8G2Z5m96bvyGDAumnH7HQzRmXeQ1KYcFEsuLjWWRYEE6WqdPmEFAi6j57eF/iDiFdFoaW+A/9o7bsnd/7aeF6bwco454gcfCO43khSOx9A6gwAi4mEHYJVLSDNgLyYM9IoIGvUkHu/QvOYCwyMcOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ms86ZEQt; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YNjszvZ+; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ms86ZEQt";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YNjszvZ+"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61Q4V3vf2617940
	for <linux-crypto@vger.kernel.org>; Thu, 26 Feb 2026 06:14:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=bhxKk2mKAOrKAUcO1cv8XTYS
	PnL0KRsykixJVQdAXmk=; b=ms86ZEQtx5mYD+GDtgkhR+/7q8PT+AwHsekfG00Y
	Gni4JgNzCXKdB+MkiLr4s1ymi5A6T1q7JrL0SNwCsYfpyjx640ZPE//Fmoz7RfH8
	IpBLb1ur0rZNymlpu43EjTzqp9ra8ov4ZsuPUmYAtWgwApzMkLyPL9Q7riBXQsJ4
	J3/Xiu5O6PkbSIy3HGWwyDirIUlsYU0Zo9JPnnNRRQeCCkWCDdYvkctxADQfXlEc
	Ct36PxQoWeiY+pr3p/A6OaqGhQgRdTLtqOu9JhtheEaO8tNcwRkRzxS/KhgfZTy7
	wEmi6Uzv2ktjfkEeSz9V6UcyNXONJEHBL9pYg5sT9dMMGw==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cj559hyqn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 26 Feb 2026 06:14:11 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2ae04f5897cso3817145ad.1
        for <linux-crypto@vger.kernel.org>; Wed, 25 Feb 2026 22:14:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772086450; x=1772691250; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bhxKk2mKAOrKAUcO1cv8XTYSPnL0KRsykixJVQdAXmk=;
        b=YNjszvZ+/QjbY8k2K7QQWgnUAwizypUnf+vz4QdjHSjGDqX5YedDcenjR3G/tAXF0y
         9jBftewn3/VRWw1GTUYN8QUoQQyZ7kw6J5vLAlaUlE2ctdYPSDsG50a6FbBIbTbhOlXx
         1xbiZNScr+haTy5k71mxq3R1m6fdYMRRJ/xG37Zj1t69S+Dz2a7UaZVpy2WtLyNN4Scy
         7CKJhx8O4dCKakRZ126VEYFMIkJTrzoO5vqTQYtFuYecpdcQOeXP6ETjVeF7ffmHeUqh
         7fT/+pA4/CfIM7OK3ylJZ5Q5185rkA5uvwV3ZCLrY7fUzI9KTL5cBiuGjtbVG39S0+7L
         tX3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772086450; x=1772691250;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bhxKk2mKAOrKAUcO1cv8XTYSPnL0KRsykixJVQdAXmk=;
        b=KxNb35a1LoD1T7H+5v6ndUXnM5FMmpIRKMb9RzAvJ+z6x4ND5FvrFuxyp197xub2hO
         +O3PEK3OX/gwVxAr9pUHWPBF0/62aXKHz5x98WwPWOECWmRJHZZebAYLdt6ym5vnYr/+
         NBs3IsdKtFdR+pMdF0+hIsc63YQ3JE15E/LZJ1DwrUeY+NU21vcl5JMYS12Cp/l0Fopw
         NR6xCBQhpBOPlvTHPZRLmGDe7hf5xUW+cFYlRfCdmphMp5SlfP/azrW19cvurjixrOvV
         3m9o6rFfv1SCNolP00nU6hIg3qx2FoMpPr/xV/7zavYZHOiKwn9jOVDLIHHS5MsuN/Il
         ZQpA==
X-Forwarded-Encrypted: i=1; AJvYcCXCOMDL5+QL8IEJhbaOHx4NCx8yQB1HUk66qF3JV2aWQDFedwJdINP/gortrP/jbNqDmf29zwidzO8t5fI=@vger.kernel.org
X-Gm-Message-State: AOJu0YypdiVrFqEekirWv09h80Gp2t4ACC3Hz2RmwdF/GmoCGzz0uAE3
	ZYyQUgdUIOZ3vCRlqE8JhX5V9V8iqwlTlUkWoaOVZHqpDOJFgJSnygJt1CBrtiPHv/TmyIgGiR5
	wldrTp1Kpggsk9DCqqKAZH5pXHyGKNzsqu4ob/0oiHLw7b0PRqS0LFnJuyrj9KRHfKdw=
X-Gm-Gg: ATEYQzyAxrzV9HcJmfYM7/dyFcJijtD1pMehYYWKrSb1GSHi9QEoa6uyoPh0smQa8fz
	UvIUaO8wky8Lxyva4W/37vIx16YqAe8LiDxrrvRP2qcQuN+7oK05oqFI7yMJBjITryUPaCH6CzL
	EdcKcdTWtJVZsXUzdgmvbohQIWAseA31niXI2YRrEmlAdwXq5MamGqtPdn7E+id3AlSrenMLcTN
	0ZxFWU9NFuQqeuTyjGWj8Bu5XHMxOS0UqjOZKk3waGdpQmYSGdUqGzNi9nvNLCz04n8Tg/SlJPi
	E1+ty+Lq+7BBGz3uZp0BSSBq5OQE3cNijBi+bH3Ir7hv2QCU2n8kJemWwXlRBKtlIrVdL5CwWIn
	vCq1XfoarIfnTVeQmQX0nDUn8l87/mUF3o0qBNAP3diU/2o1SemBTI3+Jt4A=
X-Received: by 2002:a17:903:a8f:b0:2aa:e3d1:1430 with SMTP id d9443c01a7336-2adf7943a52mr17975765ad.23.1772086450450;
        Wed, 25 Feb 2026 22:14:10 -0800 (PST)
X-Received: by 2002:a17:903:a8f:b0:2aa:e3d1:1430 with SMTP id d9443c01a7336-2adf7943a52mr17975445ad.23.1772086449916;
        Wed, 25 Feb 2026 22:14:09 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb69fa43sm11406555ad.46.2026.02.25.22.14.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 22:14:09 -0800 (PST)
Date: Thu, 26 Feb 2026 11:44:02 +0530
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v6 3/4] ufs: host: Add ICE clock scaling during UFS clock
 changes
Message-ID: <aZ/kqmGF5EJDE76W@hu-arakshit-hyd.qualcomm.com>
References: <20260219-enable-ufs-ice-clock-scaling-v6-0-0c5245117d45@oss.qualcomm.com>
 <20260219-enable-ufs-ice-clock-scaling-v6-3-0c5245117d45@oss.qualcomm.com>
 <f984c9a0-9ce2-49f9-927b-e69c26f69176@kernel.org>
 <aZ7x7gG0OZEQSKVy@hu-arakshit-hyd.qualcomm.com>
 <784d5711-3f3a-48af-ab1b-9a8834249445@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <784d5711-3f3a-48af-ab1b-9a8834249445@kernel.org>
X-Proofpoint-ORIG-GUID: FMKj6IF-LaUC2dHU0i3WoBjjPClRcJbY
X-Proofpoint-GUID: FMKj6IF-LaUC2dHU0i3WoBjjPClRcJbY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI2MDA1MyBTYWx0ZWRfX3SPrKjuIg6oX
 3qiBMfMD5ZCofnJ65ro1v08wl4o1cE4BrgiD7Zlgu01o4GFKN6UZOsRSLEHt9WV7kAZTF1xqgZo
 PE0ufYNdW1NAcjA6xDWjfhEMECYVVfom+hR0C67AChjZgKfFMi1CR+jtZ6JMHom4wKEobeKW83G
 l2bJUviq2ExwMqQFle8RgoumAzUtS+mRKSqXcx3wynEo8DaAFDDCXseo0zwKR/WD+7tCHl0/y/8
 nAhVdHft+p3L+r8rqqut8kaWgSAI31ZKFLBtjSMVEIeGTBJ7bHICYgF65GR+9tHv9Ba5V9DuQvp
 RtuXvPcc7kM5N5xA8lKhlBEAY9qKC3iD89Wp775/VuZ6eXv5oM4+LJE1KP0hog9T7G6nufohwQ8
 6mteUGYaVSSuFAbzF6jXZfNt2xFBTWkTg3ROmeOQ4VNPh6uJyimEQ0iFK9T7qi8u5ST/bs8C+e3
 UO9BxZBd0QrBNVHNVLQ==
X-Authority-Analysis: v=2.4 cv=TcybdBQh c=1 sm=1 tr=0 ts=699fe4b3 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=vLMaN86HkaFgGR5djpcA:9 a=CjuIK1q_8ugA:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_04,2026-02-25_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 impostorscore=0 phishscore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602260053

On Wed, Feb 25, 2026 at 03:12:18PM +0100, Krzysztof Kozlowski wrote:
> On 25/02/2026 13:58, Abhinaba Rakshit wrote:
> > On Wed, Feb 25, 2026 at 10:00:12AM +0100, Krzysztof Kozlowski wrote:
> >> On 19/02/2026 10:39, Abhinaba Rakshit wrote:
> >>> Implement ICE (Inline Crypto Engine) clock scaling in sync with
> >>> UFS controller clock scaling. This ensures that the ICE operates at
> >>> an appropriate frequency when the UFS clocks are scaled up or down,
> >>> improving performance and maintaining stability for crypto operations.
> >>>
> >>> Incase of OPP scaling is not supported by ICE, ensure to not prevent
> >>> devfreq for UFS, as ICE OPP-table is optional.
> >>>
> >>> Acked-by: Manivannan Sadhasivam <mani@kernel.org>
> >>> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> >>> ---
> >>>  drivers/ufs/host/ufs-qcom.c | 21 ++++++++++++++++++++-
> >>
> >>
> >> SCSI/UFS is not respecting subsystem boundaries, thus you must not
> >> combine multiple subsystem when targeting UFS.
> >>
> >> Please split your patches.
> > 
> > Sorry, if I fail to understand the context here.
> > This patch-series is already split into 4 patches based on the subsystem.
> 
> s/patches/patchset/
> Please split the patchset to not combine independent patches targeting
> different subsystem into one patchset.

In this series, the UFS subsystem patch depends on the new ICE clock-scaling
API introduced in the crypto/ICE patch. Without that ICE change, the UFS
driver cannot call the scaling helper, so the UFS subsystem patch cannot
be applied *independently*.

Given this dependency, splitting the series into separate, standalone
patchsets would break bisectability and lead to build/runtime failures
if they are not merged together.

Please let me know what is the preferred approach in such instance.

Abhinaba Rakshit
