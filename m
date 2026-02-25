Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4603ACF1D
	for <linux-crypto@vger.kernel.org>; Wed, 25 Feb 2026 12:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772024313; cv=none; b=OeWjT0+BJwFgLEdvNNVFHxlFPYR7YQcQeknyLTZjWNL/py9suCazZHXE7mjrAjjQLj5wmtFFiva0dcrplTT8yy/PYDtLzfjsornDGFGW70MLrq2dM29q1OxmK1lrJZJawhpLeH3Q+bgYJIFkXHKyrt/G+yGrjj9nutSUwknbdiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772024313; c=relaxed/simple;
	bh=rsrJV9JSs10oZW/p2B67CK/bbFR/ySGiAGre+fdGkZw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D3sJdK0hiTRIYjl8KYE387brdTzOFXLwZMrEBP2alYpY7v0qTL6R9uCL0ZiTloHM5p3xPZU/dJXqOCQnuoLXc5dk9zByFU2SmupAtcimjm5qpuAM12WntZT4VZ1OIdWAQ0RytCKymdmeh4TTVDT7lypf63bHTuO6yvmU0bsVi04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=S6rBZTr8; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=kbRyvgBI; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="S6rBZTr8";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="kbRyvgBI"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61P9TBdG1579559
	for <linux-crypto@vger.kernel.org>; Wed, 25 Feb 2026 12:58:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	qwtkGTva8UpevosmA9Ul3qK787+uQN8ysaiDcYLDNr0=; b=S6rBZTr8Zjxs9Gtn
	UdNivAqShe3BsUS2ZGthhRKo6Jo51V1PnP1JCAk7d4saqZK5WlI39w9QH9rPkMo3
	W0Q4G5NPRIfZqJlLZq+p0SVhIB5sHnJ4Yo1LRLV/3cD0JFrnW/WIKuJcjumN60hN
	PZgaLgDu8eL3CTn7TyFTDb5/5ysOQGpLynTC95ytm8xUEop7ruhoR5xS3SCvMkBC
	myHqwnNMsiIVzjB/+EiXwTDcwoeSzuiBuCSelHaIP/BcDD4eoHpcayV+j9WWCmSU
	xYH5Nym8xhsX/RxK3vLkCicTc9NCplK4yZv9xCRud4osH8uMRXJVdOuyP9fS4A9w
	TEchKQ==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4chg1sb90w-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 25 Feb 2026 12:58:32 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-8244932b122so19559532b3a.0
        for <linux-crypto@vger.kernel.org>; Wed, 25 Feb 2026 04:58:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772024311; x=1772629111; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qwtkGTva8UpevosmA9Ul3qK787+uQN8ysaiDcYLDNr0=;
        b=kbRyvgBIQzWEO+RDMMrPdI/NRQTeWWDTsjyUTU89zl6JCISawB2Shv3W34J7jjJeRs
         WA/biO1gJ4vFSUF44cEOsZO2WTNJc9WRwYdhw8RKIJ6w6AYns9fAAQlQhkuQ9pIWLEuw
         70fSap9EsbKTIRRtlsViVFXHDu4r/C5476btEJcRiIUJqlzxf6AiwNT7jYjM5leGn/sN
         tVXvAXdck2p1QIJhXMNIlWtuStnUPrACjXEYoERX7mi2suu2lXZKifFY2yhpTy2uJkof
         8RgnW6Afmi90QzcXVXcripyPbyFR5qejCxQRIsk5P9mtIofdFiVDIuubuacYyGb2yLYW
         HO9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772024311; x=1772629111;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qwtkGTva8UpevosmA9Ul3qK787+uQN8ysaiDcYLDNr0=;
        b=KjKPHCZDY4AJVNS6O0lzDxcpoP1VxM/aSlMGIyoctPpDKsQOeKgf8Hn3/mjNLym1mF
         p05Yuz8JwdgqwnhxoYpyknW5k45ttew1xwyRPrihy+cG53/KMxAWOQeZgutAUTxeZH6G
         8WkRrt/ftqeTi4TXxgCOG/9vnm4NpHT05B6dOp7rH2Vt5vYBx81we3LKAOdqkbHvhwsF
         4DU3udfo1etZ3WRCq1X2stkNJ4KDFvj2IAVkcWeaf17j0WCgU1j60OabLwDTGVfWLMrs
         HD0zGOyx/MEpHPoSrmSJMvrhX35xxftj8zfWrePlz0twjNG8CXhEGP/lyHzgKzo7I44g
         /I/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWp7h3KJkaRR9tsg/Fy5lpznuyGQFRAaZYXdyI9rvwo8r5XAK64fnS0BO3vNdNAMlr15l+oQ/HO08UaEvM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFfpZgWfZ24XhEeEP1sHoiMiAUx9zc+RWkwcf28Yp8yr+/vgE3
	Ho8iXk4JM8KtVOYELO1ShT40EPQTXy2xMcJZday3OCgEPwJXLZtxKqFOqMzxk924IrigeaT/uyv
	MDpPWW5zFUvHBnh8+Wgtyoug6VtdZATmUPyJ7a3a3OBH1XbWnLjtbxMXUmRNuvLIPA/s=
X-Gm-Gg: ATEYQzw7vZZx1l3V1H4DcdbNefA+mERHyROspeFeW4Ti+wBRg+GiGoEROXqUdnNLiIo
	ziwzZk7Zy2GKbwI8FfwjZaTmkJHmkt6YZVrhSRJiq6OKm8UAuaeLQNfH3k4ti96COsuG4HeM2MK
	C3uO/WmPI/ik6vnRPV0OotNBUEEiC5OMHWw56xQK3XukjoTelKkxC5W2138ofWw9irSVtY8nAzJ
	gfCUiI/ty8KAF0yxSiYcoGP10+MXLW5FOS7NJNs3uZPAnbAwJYmL5U9UrIIIGfOxejk4520nSyr
	bz/6VzF0WyIOcmkcDEMrMC58JzfSRwCwJSvcAKvblx9ctC25fAtCCFZ7qBA1pG92xYDHGdASfs9
	k1uj08yz+Q0rnSE552EFe+R6o744WD49uLQflPIXgHYptLyproYBx1rWVJMc=
X-Received: by 2002:a05:6a00:4b11:b0:81e:8e66:38d9 with SMTP id d2e1a72fcca58-826da8ee310mr14805863b3a.17.1772024310895;
        Wed, 25 Feb 2026 04:58:30 -0800 (PST)
X-Received: by 2002:a05:6a00:4b11:b0:81e:8e66:38d9 with SMTP id d2e1a72fcca58-826da8ee310mr14805844b3a.17.1772024310447;
        Wed, 25 Feb 2026 04:58:30 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-826dd8a55d7sm13750737b3a.46.2026.02.25.04.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 04:58:30 -0800 (PST)
Date: Wed, 25 Feb 2026 18:28:22 +0530
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
Message-ID: <aZ7x7gG0OZEQSKVy@hu-arakshit-hyd.qualcomm.com>
References: <20260219-enable-ufs-ice-clock-scaling-v6-0-0c5245117d45@oss.qualcomm.com>
 <20260219-enable-ufs-ice-clock-scaling-v6-3-0c5245117d45@oss.qualcomm.com>
 <f984c9a0-9ce2-49f9-927b-e69c26f69176@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f984c9a0-9ce2-49f9-927b-e69c26f69176@kernel.org>
X-Authority-Analysis: v=2.4 cv=ZKvaWH7b c=1 sm=1 tr=0 ts=699ef1f8 cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=p40s0NTFcljArWS5TpEA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-GUID: yJyQBSgDQWA95R0DHRv7aKty1TRPtTVP
X-Proofpoint-ORIG-GUID: yJyQBSgDQWA95R0DHRv7aKty1TRPtTVP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDEyNSBTYWx0ZWRfXyCQogvwr1w5P
 qDlGTfb/Lp/pgjZpTZ0/Hl0rk4qFilZuq7L3J5conlA6tSB8fdPHu4BY3RvpF78J/gYttJ0gzm7
 GhGsnvz72HUgyMRhrhYhn8Ry90FyY9sdWSSbTmBkiq9c7dqCZvriwG+MBkjs1PKcYcg5mS/5oS4
 wvntdZ+NOIIFi4QvfNjJF+d3T3jmVdzEJmiym7JYNfEqmbujPgu7QJ8VlSUsd5DjUh1FrG1TkHW
 ReHjg8D1Hc/ICJM98MqBR1L/cy6/3wn6uDxeeveLvCOnIsSPuDggVEK90BBapI+Hnss1cEMuBEW
 80F0ImtXEEU6/zlFwtOPgXgZJBjw88AEGDr20RpmoU4rD7PRiPoR7isMdQoDeJ7EFWN0V2pAblQ
 ssL7vFZ+BwPm555s6tQqOx0h16GoMHGOKYVwL4pAa1+uatztL+PT1piv5sIlFi+zRaB6U0ph8lY
 HkelEHqEF2wy39zumOA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_01,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 adultscore=0 bulkscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602250125

On Wed, Feb 25, 2026 at 10:00:12AM +0100, Krzysztof Kozlowski wrote:
> On 19/02/2026 10:39, Abhinaba Rakshit wrote:
> > Implement ICE (Inline Crypto Engine) clock scaling in sync with
> > UFS controller clock scaling. This ensures that the ICE operates at
> > an appropriate frequency when the UFS clocks are scaled up or down,
> > improving performance and maintaining stability for crypto operations.
> > 
> > Incase of OPP scaling is not supported by ICE, ensure to not prevent
> > devfreq for UFS, as ICE OPP-table is optional.
> > 
> > Acked-by: Manivannan Sadhasivam <mani@kernel.org>
> > Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> > ---
> >  drivers/ufs/host/ufs-qcom.c | 21 ++++++++++++++++++++-
> 
> 
> SCSI/UFS is not respecting subsystem boundaries, thus you must not
> combine multiple subsystem when targeting UFS.
> 
> Please split your patches.

Sorry, if I fail to understand the context here.
This patch-series is already split into 4 patches based on the subsystem.

If the concern is the UFS patch mixing subsystem explanations,
I can refine the commit message.

Otherwise, if you expect the UFS patch to be sent as a separate patch-series,
please let me know — though I feel these patches are more appropriate to
land together as they are quite related.

Abhinaba Rakshit
