Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7601FBC8C
	for <linux-crypto@vger.kernel.org>; Wed, 10 Dec 2025 01:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765331796; cv=none; b=S9WThcQJiFpm24yfTB0oVTTWmwvpOLqtJmNbIzVlzjxNSfo0oR1bmnNutGcS2HsJ3RHWRYWP/6o22KNtxkqhj60zCyvZlTOdy30pR4e8NtkWsCHumAqvXmbRbh/Txe9x0G4GTCqQF/DS3xdhGMSBSnITT0eerYBrt0/8RKSeI3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765331796; c=relaxed/simple;
	bh=e4fcYpHyZqzDEsYWXD/fCBBZoJQ6ccmxF1/S33V9RfM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qxIBOkOoLuSr1gbPlSAp4N9pI+nSXoqrBctmHGW0w+dDsaxD5JKGEhq2TAbNxbv8FDUk6FDK5jD8m8J00aH5GARadfgXi3DlrUVSHY7tXcnBqnyCcK5bSTUACu/gzubzeWDrJY0DeSZG6J+s1v/xQkEpIWwdtbMnxVkiLvvS77U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=puiiVmk0; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=FS/eMFA+; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="puiiVmk0";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="FS/eMFA+"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BA0OvJe1613880
	for <linux-crypto@vger.kernel.org>; Wed, 10 Dec 2025 01:56:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=8UlHqByzRs1jqUK0cOJbZ6dh
	LQhbGEcO5swtR+2QQVU=; b=puiiVmk0xmNxyNTCv5jf0lowwjKoFa1l1uihwU0c
	RszUDgGunSBOzJQ+DkPKhs3fChW7c2dqC29w/n6pR61irP/fGNRLPrsYDWI8XE2x
	eo6uuNFmBCKfyeC5m1timrWREhzRaxbvSsaEj1SBcoB9qJy33ZDuJv+avrPmVh4F
	9zwm5AvuxpW7iU9UvZTIP+bKiZsLhSs4N0RnJ60xKSV6XHFpueixdRQ3Pu79umPM
	/4ujEkByUhIVOHZhTo4tEm7D9cHW86olcI5Jjaw9OxVixH2z8H2r4tO5xJy0BN35
	5eS507vu5ZjQkJFGUtJP9yewwZq3HyWV17xIgJL9MV4kUQ==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4axvn4gnw7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 10 Dec 2025 01:56:33 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-4ee16731ceaso5477221cf.2
        for <linux-crypto@vger.kernel.org>; Tue, 09 Dec 2025 17:56:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1765331793; x=1765936593; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8UlHqByzRs1jqUK0cOJbZ6dhLQhbGEcO5swtR+2QQVU=;
        b=FS/eMFA+IihMWuVX+cHlTdzuof1pwjgWaZC3AyueE5jPqJ3Jf1xQlJeVX5aPUbQl9O
         rFbPiA4osmoWmsh5iWFwgY26fvdLxRIehG49aYho3lNTrU2Zz7Vv6bbxX5taA1m56jVP
         gxdMmT6N7YMCZvpHw7QP3ZBUcVt2AVDiMEzFJQNAA/CIa8ywoyE8G/f5YM7DuZS2dwOQ
         +XSTWxSEcWlIVM2K5Mn+OdkMCabvOD2JKB8Hoc08F8N+mkgxZWE3LeugFkgDj3n41rpy
         snQ+gO/O1TMUKSna1j3lrukfaE+9xEd29rRRbiEF9PmZHA+8++J/rxIdh/4ViOX8h9zA
         6+Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765331793; x=1765936593;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8UlHqByzRs1jqUK0cOJbZ6dhLQhbGEcO5swtR+2QQVU=;
        b=vBEuavlsQ2WyN6k4POkHCGevWhAK5xAuiZVRnZE3FV0eM/mzIRfQS+skZ5dKwWL8K3
         JN1mJG15AId3dZHZTFGx8Kxz6jzmzXd2oVf5obUzEDZQMRYzP1ObRT2zUYDgi8QNTWGY
         T9lP4KEqyBhLjrgE4CW05MtUQk0ZvX91l4X9+sVFjOP+qfFxvbm+E2nxzQK/xC+z4nvb
         F45M5wv/yMaj4LPd2WFeA313Og51YluYFhEYxcMso2eZdhg2SANhy+hsSwZJzndXdEjw
         mwy9xRIeeRtJQ252vT9GWvdGxsBCU2sxM8F04ZiU3MYFaLoAfsUf1dTbgS2k0eOTgv0v
         cHZA==
X-Forwarded-Encrypted: i=1; AJvYcCUFcaCd3F6oRk/ji9MkuHrMkRp63q0i60pxCKPrqVwnKTn0OPmDwDYzoxPhQUrcod/oLCEgwXSyeOPbW58=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxbgaym11WWP1S9NquRav1jtZwu6nTtzp35EmlVTkUC9xOIVEZs
	7Mswg1IPdOvnSOzOpe0yUOR7vqX3k+0KfwYfbXZensEnsHpc2bEOHM4D+khE86GhTvLx38O+XVD
	hq+FucGt6Vro9YwBYCZSI0dCDgj9wFWzKAOEYdE2xrkDmVz+LCVWGedaUqvAmcoU237o=
X-Gm-Gg: ASbGncuseKOcRCX9in1zK99oTFMUVtZ4DWw9MgHFlAZyfB/WyRuonfGYK09CZTNxexc
	HdQdYG3Zu0nbDKTJ+Q5FdX5iMv7UlWv6vXv+YkPz57yIPC5o8f3HPOafrKsBVS9OhTh3XhTPZYy
	u+UUsk6xa4sG1oZEzOtpJivWEK71i6zXJP8O8enj8hMGha1B/6Qg/0vlXgocnVOmbQVwepWAb5m
	fSke8C/mxRxhbckqc7iqdy6A3i6s+rFPr8iHbR1h4Bk+EIagrok6Itsz/Yx4HP1bKPP7XGQ/1JJ
	jNiAfkQdJ9XZbIodf0QlGv/6qQzniDKZPABdrDbikTMZ4/U/B/YrfjMnISJbfR2hSP45R82GBBV
	K3MDf82FQ+otpvUTN44pM8UtLPzpVePXKN4ysNsNvsRgqVWwJuF00j/8Qysj+nqz/4GuCDo7mL3
	Y36fszvEbdyjqGgHMvOPO6YRs=
X-Received: by 2002:a05:622a:190f:b0:4ef:bd1a:501f with SMTP id d75a77b69052e-4f1b1a67517mr11770791cf.23.1765331793234;
        Tue, 09 Dec 2025 17:56:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH7gqj3G1BiKUzip4pW3nsB9M1LGKa8ryFA0k+LN0QOWznITPFHf2QMQ02Nxgz2L33VFBTrLA==
X-Received: by 2002:a05:622a:190f:b0:4ef:bd1a:501f with SMTP id d75a77b69052e-4f1b1a67517mr11770411cf.23.1765331792756;
        Tue, 09 Dec 2025 17:56:32 -0800 (PST)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-597d7b245b6sm5681124e87.28.2025.12.09.17.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 17:56:32 -0800 (PST)
Date: Wed, 10 Dec 2025 03:56:29 +0200
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Luca Weiss <luca.weiss@fairphone.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Vinod Koul <vkoul@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v4 6/9] arm64: dts: qcom: Add PM7550 PMIC
Message-ID: <3h2kag7drftc5qiz7h5xapnj2kuaqexvknogkvusgca676cvw2@x2nkz6kmiphi>
References: <20251210-sm7635-fp6-initial-v4-0-b05fddd8b45c@fairphone.com>
 <20251210-sm7635-fp6-initial-v4-6-b05fddd8b45c@fairphone.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210-sm7635-fp6-initial-v4-6-b05fddd8b45c@fairphone.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEwMDAxNSBTYWx0ZWRfX3JSTteP+3dQy
 qai3idTvmvxEMi9HrzsGp53X0izKWTDOfki9Yv8RwFkqCGs5PI/DH0nqwn19HwgNNrmZ6YCwmwO
 7Lsa2+3p+TC1oQkIjIUXWjGHNnrWonp1lCLY1fLprgbapcXninW3S3W6AvjNNIDUZJhQB6ATsjL
 pXMM6Q86owaXFbYhWWQe5lJMPBQrcqR1iNXGEh7KjaS63yq3vDbWV3ZC0Fe5hXKE/ert0h9lKdo
 TTOZus4XLPQRQzsvEgV81vfff/bXR+I9XSXturL+gngvVJmnd3tLTFTNCsJKmXCMj3HdJi9ti89
 8OsDL5ZzWhF8JEGTcPiBVHfSc/z9ZrCapR7jXO6AjCroP3UaODVftmsHrpWb3Jt8662UUsMbFXn
 /fqwSkhlXYhZsk13du+7fP/ejfSECA==
X-Proofpoint-GUID: VlkbjUW0wq77mnoISEX9t3Ar_5hOPJEs
X-Authority-Analysis: v=2.4 cv=EarFgfmC c=1 sm=1 tr=0 ts=6938d351 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=6H0WHjuAAAAA:8 a=EUspDBNiAAAA:8 a=5gdSdrsV3EmceHnK_3oA:9 a=CjuIK1q_8ugA:10
 a=kacYvNCVWA4VmyqE58fU:22 a=Soq9LBFxuPC4vsCAQt-j:22
X-Proofpoint-ORIG-GUID: VlkbjUW0wq77mnoISEX9t3Ar_5hOPJEs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-09_05,2025-12-09_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 suspectscore=0 phishscore=0 bulkscore=0 impostorscore=0
 adultscore=0 malwarescore=0 clxscore=1015 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2512100015

On Wed, Dec 10, 2025 at 10:43:30AM +0900, Luca Weiss wrote:
> Add a dts for the PMIC used e.g. with Milos SoC-based devices.
> 
> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> ---
>  arch/arm64/boot/dts/qcom/pm7550.dtsi | 67 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 67 insertions(+)
> 

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>


-- 
With best wishes
Dmitry
