Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B2A285CBC
	for <linux-crypto@vger.kernel.org>; Wed,  7 Jan 2026 08:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767773724; cv=none; b=CM4iRORpbA6KMo9WTsliK1PlSIEmwPaMV71cMNewYlAbJdql+ZEpJ245rxb+TB8X8JnJo9DBNJPpSzWrX4smRaDmeN0+08ZO+/7leA6WZUtansM57eSLqhpcnGQtlmZBBJhLAQ8PyRf84SiD4l9QoPX08tXH6mRkDNMToVQMCE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767773724; c=relaxed/simple;
	bh=G9guphynNXUW98iSs3mT8MBJcIn3lVTmI0QZS1vaxyI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZWQNUMsTi2FEy1cxmDex0CuG48qHNuILHmGsVeg9ZVDq0MEjSGaKLbHlcnZUvvzGpoeslJ65Z4PRrNe0ojpC5rQ/6Q7cMZQCo2WvdWbm3lEehAzuGMV5tjaNpZKJRshleuZ+U56OyBAFuNagAC71QRvSwUlSc095rKBxsgPnFLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mEl/JXNF; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XuiEOSGd; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mEl/JXNF";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XuiEOSGd"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6075JfAv805183
	for <linux-crypto@vger.kernel.org>; Wed, 7 Jan 2026 08:15:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=7/ORuAlUmALvoZXoH/iZ/MKI
	plEqAlG1ddTTqoZoxos=; b=mEl/JXNFxLJJvE6uxbB87fe1H11fXhwYZABqNSdQ
	fQZHlZA2lFzIujLrYni+emdMKWB7lomO5QM7nTIwDePkkHx04gkh/1z74aN68BBl
	n6lSD6YQJrHHBHeSyr9N8Xq5a0TL1d3fir8O7TDoK/flHn58qy7H6rlWu9awaWUd
	e0Lyh4RxC5c/G1imEB5MRiQR8oSEmsrUGr3gQgz2GMti3g1iqcYGZedS2TSAJpLx
	0jqNDf8AQGyhAjjGmha1HGfZAvoC8Gp656ixro/deU8BzzjMCVD9lLgMrpLuGkqw
	H0LhIegKAkE1Lnn6M1ixT9ewSIJFEl4wppR39PP+LY5L1Q==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bh7t9j3vb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 07 Jan 2026 08:15:20 +0000 (GMT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-4ee04f4c632so33564421cf.3
        for <linux-crypto@vger.kernel.org>; Wed, 07 Jan 2026 00:15:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767773719; x=1768378519; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7/ORuAlUmALvoZXoH/iZ/MKIplEqAlG1ddTTqoZoxos=;
        b=XuiEOSGdfL69TM+K1UQczYp1LFWJ84CZftNWB/P+FF6154Kgb22VfERnZHlCtoBvGS
         M7pYv+6S4iC74sA7mIzs0FX8UXDemU0jTBWfDINxN/KJt1EkJbciAoazPn+Fv2YFsdBr
         K+Erowks7BPSAs1cs7RrpKHfrSK/nzH2uWJictYKcqY9klsgaXKU2rniCAgBypGZ4qL1
         uNBCRINpUerzsBcQp3Bs08JPiV6bCrfQOecKLSLSpyA2MNB9dgdJ1aTX0S5O2gr90hDN
         BsxEG7ZLNQpbZYIiOQIppi7NW7+gQY5KQ8CWRMmhWDBgdDiqXaKuvpqnh0KWkjHzbhfw
         QYFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767773719; x=1768378519;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7/ORuAlUmALvoZXoH/iZ/MKIplEqAlG1ddTTqoZoxos=;
        b=ArzphvyXCbUTqA+MdXNfyEx7BQdMHO1UwgxnCy+Qp/pqNj5d4oJNMUPCp+TzKjG/ja
         TlAVX/DTk7n/lFrUSJ1olIgSIqiWe0yE2vzuGLjZaZaNkblhlucAtv2EKAhGOzH4dsCv
         oykaZlM+qKHTzBB7OmAw4IwMuKZ7I71f2vPuQZ2ADKeZ7xOxWhUqf/dVPurhzlh/n8jq
         SlN5fT3978I3UGTTBCsUxeCujyZvH6A2FvgUDYCVHWNnwXj3bmmr+5aXzdDdxCrIR9NX
         B+cgSi95t7Kmm1VaiU+Ka1CzwPP97otzt0o806QFmq5G/8MgjV4XXetiBRHhqaELkES5
         /qpw==
X-Forwarded-Encrypted: i=1; AJvYcCVjEDMWlwRLbzpOopCvupYwhCtE5m+/Sf4+Iyd1+RILcKaJpilevubMxtP2Rnik8B1CA84r71CByVMfLxY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWkD9/oYtUqFerYv/plgmrZxLJ1jHMcgTIN+BrLtUOVYPNTk+l
	Pusjh38wx6UAyMgEGgNbydDqgA1hE3rKMp1R5wipN1F3E5WQvIwo77RgLkQF/JcQuCDWR8RjhwW
	wP/rvIy0sV3TRpAUo/UAbz20pRJeDEcOQe5+7TX1My8om6luTr9zs+EGtdRNEUsRNCYM=
X-Gm-Gg: AY/fxX4lL+3hZvOu2hsFCmAntvmXnf4kumKjDS1KuODzzoGhhrjkiy2z8lVpAAG+rAh
	yGMPL8RlJP9UGHCmlMECZM1MQT3kfDZMZJAtWsNmIkDKffZaK2F/oKpTnWnb9gfiEdRVaugtwox
	sThm+DeE4SYCtmezJgHCw19qG69o0/qogadkC4BR25w4IF5odKU68PC7S1IMin9dDfBogN5aGaB
	S6vcWJHX+RpMZB+lZjbDcu9ayh04MwQ3CmIUwr5V0wpAbfG06U/+gloaekjg4Vh8AxgjYi0nd9L
	d9M2tglx9OEu0GNpyLhdXzWhw3uDXaCxGBYR828t5AjBywSi8dPg89QMwgFFchmHfeHFW8iM80T
	dFkCWAdAkqQR2cRbGBNP3ncJjYx0Ipc3mCu29GYkjQ3Om+gBrhLxmGMVINhGYDw5FXl5DQcDIK3
	1QiPT9NK/FohVWO1M9XTCERrA=
X-Received: by 2002:a05:622a:4a18:b0:4ed:6e79:acf7 with SMTP id d75a77b69052e-4ffb499ba21mr20710551cf.41.1767773719511;
        Wed, 07 Jan 2026 00:15:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IELXjesdvAHb2vIW4ryLhR0dlhPdZd4yFCCjpn7vN81UbkGeRCeU9w+cIz6186R1d9MNEBuTw==
X-Received: by 2002:a05:622a:4a18:b0:4ed:6e79:acf7 with SMTP id d75a77b69052e-4ffb499ba21mr20710341cf.41.1767773719150;
        Wed, 07 Jan 2026 00:15:19 -0800 (PST)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59b65d699d2sm1125644e87.87.2026.01.07.00.15.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 00:15:18 -0800 (PST)
Date: Wed, 7 Jan 2026 10:15:16 +0200
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Luca Weiss <luca.weiss@fairphone.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>, Vinod Koul <vkoul@kernel.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-phy@lists.infradead.org
Subject: Re: [PATCH 4/6] phy: qcom-qmp-ufs: Add Milos support
Message-ID: <aubnydfer7ffn4wfezrbdsw3jov4rimswwtxkwqb2ojdkvpvub@yxxqxcg4tlsc>
References: <20260107-milos-ufs-v1-0-6982ab20d0ac@fairphone.com>
 <20260107-milos-ufs-v1-4-6982ab20d0ac@fairphone.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260107-milos-ufs-v1-4-6982ab20d0ac@fairphone.com>
X-Proofpoint-GUID: mUoBFV859-I1pC0JM4I4mM1hozZeys3X
X-Authority-Analysis: v=2.4 cv=QfRrf8bv c=1 sm=1 tr=0 ts=695e1618 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=6H0WHjuAAAAA:8 a=EUspDBNiAAAA:8 a=wMCEmTFnA80afR0hZ2sA:9 a=CjuIK1q_8ugA:10
 a=dawVfQjAaf238kedN5IG:22 a=Soq9LBFxuPC4vsCAQt-j:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA3MDA2NiBTYWx0ZWRfX2hQjuUF4YDhV
 jg0knA74rTBim3H/AwsfHF6ScPh4ksflp3YpsJbFXBIwDx976odzjKzqLC68yU34ggfXNHZrCvE
 zY8zdhEYrF+zCTnhVyxdFSuPXqW4ac6Cl0e1mkSY2YF4Sfgqtxfe52qG8bAHyVt01tiMISR+JYE
 anASPeqxzc0UGEByuyYTvrGYtm2xNUdsJg5r0SamMbbd9OTpgJC94eo0dGqgEsTMdiXwnpe+7Vv
 alBVPj0K5bcUjbt9uTNfCr9UX6QaxW4PxilnU8dWz5Bj5QNPwLuXDwzfebYty3EXZZo/5CleOkQ
 IyukAhpLb8jnNQTbdxia3e0HS1QX1PNcFHzZvEe1Y9zyCp9YuJhevQ2gQZzC5aI5318LQoSNxq6
 KAg9NJHkzYmIf3D7p0Ix3eGiU6M2krl8ml7VXj7vtU3Lv3vqcav3cmRym7DuncId18Ziwn2hylX
 J3wiyrmzilnDqPmiFvQ==
X-Proofpoint-ORIG-GUID: mUoBFV859-I1pC0JM4I4mM1hozZeys3X
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_03,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 bulkscore=0 lowpriorityscore=0 adultscore=0
 phishscore=0 impostorscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2601070066

On Wed, Jan 07, 2026 at 09:05:54AM +0100, Luca Weiss wrote:
> Add the init sequence tables and config for the UFS QMP phy found in the
> Milos SoC.
> 
> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> ---
>  drivers/phy/qualcomm/phy-qcom-qmp-ufs.c | 96 +++++++++++++++++++++++++++++++++
>  1 file changed, 96 insertions(+)
> 

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>


-- 
With best wishes
Dmitry
