Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45129225390
	for <linux-crypto@vger.kernel.org>; Wed, 10 Dec 2025 04:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765339300; cv=none; b=E9Zb/27PUojPpQnfQ3GCvLbkU8mLz9P2POEcQCc6Kp8dS5unriez+bQhMKdpxAbFb8awpwBq0giWAsxNNzjIr5GYdLXgRbDr4IwnLqK4cKrBaoRUfOwh0kkyOxje+4scLZDcqUO1YzwZwAtRY8wJU/avxCMg2VtFOnqX3bRfQ3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765339300; c=relaxed/simple;
	bh=VtECjHUO3xGDK9B/G9gi6XQmOhondkiYl15lGVWWDj8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HfslJ/jACoBq5wKPyCNEmOmB6Qba4ce8A43Yn2g1i7ypHni0N8d4j3bX3rkZPBprufw2fq5cz7Up/1uo5VeJyoCvyJSkb4SnTuyV6J+5TkhOR75UwHvLGUNujHTFXygfdB66B/kDtvgQkgrL4N3oeHIeZUVGKhje7ic6eEYNq3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JjcHBXKU; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Wb8AEiDA; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JjcHBXKU";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Wb8AEiDA"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BA3LRmn1810558
	for <linux-crypto@vger.kernel.org>; Wed, 10 Dec 2025 04:01:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=MqiK2oV4ydfSYTKR7Zx8jO1z
	t60wSHlnWIxEEXBfXUM=; b=JjcHBXKU77FDyu/9srzsR2eJZHcVGnZAIAVSJvWU
	8iuzpG7i1SzOJhvPML7i27o94CyGCZwxUCIm02Bvq91Ux6XvfqqRMX+XB0bNHyHA
	CG+HY5f3MiIDUlDp701lzkPBa0RabAmiyNuhFe8mMEnNH1NqS9MBbyxGnFfKs9DW
	fLaRnL6EX9i5XfLdgrvIoqBI9eIk9ffLlbkoNB4IzfJ3Eag55Ywy7fS8qy4G1auN
	PIddMznblOcGAbWa0I7qLkBIqhx0iZ9btO+IChPDGsEpUaa/XbW5QJV3mwCknSOS
	WZcmmaqYTWL1HGtClSBBDa1dKZWjep18cmk1qpysenY4Yw==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4axm9catec-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 10 Dec 2025 04:01:38 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4ee0193a239so72068131cf.0
        for <linux-crypto@vger.kernel.org>; Tue, 09 Dec 2025 20:01:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1765339297; x=1765944097; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MqiK2oV4ydfSYTKR7Zx8jO1zt60wSHlnWIxEEXBfXUM=;
        b=Wb8AEiDATruQhaYECrk0DWRN9XzUP2bl7k2UPD0UiYb0814CeN4t2iTHaB2I3GRIwA
         iCDcyy0w3aIOfjrVp58TulHKkRbaJ7ibBXTiL6vyyp3yfCUMAFJyT9Rp0jBM2ePSlVgb
         D8P3YameJ2/M0pdTp1FBA4LHxvcsMEGLO9ugMEFFUj6RZWZsfdgox6tGrZ7n3ipIVIat
         10n/XIKKuhBODke83pPEB6coICDRJekIJGecjyvxXmqdB5WFWnaztdQAu9sTwmPJJtI5
         PiUrCxyRAZlOB0iDcdFNXirmeBxe9ouNDprjdRjafGiuM4KIIK+xsoURyaviXRJRWz62
         JkiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765339297; x=1765944097;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MqiK2oV4ydfSYTKR7Zx8jO1zt60wSHlnWIxEEXBfXUM=;
        b=BsQLEWXXLjSpK+IhDleD2rRnsC8x6iFzzphjdUQ09O96kRdGA9gQI3X9MXPYXvL62q
         N11nSBxJ3NUPdpqSLW9EyNF1mLt4nNzXWpbMS6rh+bdrDvBx31G3LmoinIIgfcSJ3Zo/
         voHDGAPrtXHuAjwNO3M6pqEKmPqQcsX7lrZ9pvnc9wfdanP+iQIHMeAih6/nx4otccF5
         OSuaAfCIO+6dxCi1nEflqjET18Lw5JgQvNDrq+FWE3NwwE1Ik4tCNNhf/pCsUAw8r0dF
         JRBJaAn6uhuknHFTnyN/wlcTdAp9z/3K8yxYAKITDkg/BwQY0urV1aMmHqYZrmUbmkfw
         TEIw==
X-Forwarded-Encrypted: i=1; AJvYcCXJwmAjCfjdBfuJ5bt8INjSxYZqhsgFCrS7vdMzjUalon/Xf+uO7B/QJzkllYfeD75VUYdA+p/EFn4HThI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwlmcR+HI24UM7Oh2jUEB8qJMdv1LCj6Rc8TqCLlYi4gychAonC
	HjaWqMpEPbRJf5bZXpjyNIulqHK32Vr7JZFtu9/VESN+Ef45HhFvfK5yjNDv00gDN2sqK59SDSN
	t0EeYAmJ52Y0lqk6Xpu1WffoeH1rrgnfhSi96C1MAONMhFq3YGluXL42SvnGMgDcaltg=
X-Gm-Gg: ASbGncu0e46SKvW32XYC/CdFAxKtaB9e/mZd5Cxo0EU/u2qtSmEmWBP1Q0OW6JXA/Pw
	W4ZEah6Vp6nn/gRWZ4Nd1Y/WTc3l6+8ull/n54yKnRN88D/rQGI7TxerJ7HoxfwwxBUlcbUrtCn
	QZgo0YsIzoVyyxalmzN6eYGKMH44GnMBRzIzbjTymiPL3AU8Stxo26EqD1IPUWJBRIPCMgAIP4f
	OgOMs5ucfQOQOx3ypQSfLvvQM2mpnQcHrUix9Q3jTRusFr1tPKk1tjJdib/y5Cjug6yf2cv05Q2
	wpKa4cuZ317QZiaxJjjRG52PPHjwUNX73PpolLtD/+zQngXtCfZmNSIGEVgXEdDiquX8ogfHuwp
	jg0h9AJOf3seDN4ORMAVyDonXFnckDD2ZCwDNic6T1nVBkbMXiMkT/Bp5yv8B7/kpOhSg8fHq1S
	YK7Yi+/98Q6Mk1S8kZSyysodw=
X-Received: by 2002:a05:622a:188d:b0:4ee:2080:2597 with SMTP id d75a77b69052e-4f1b1a846cdmr13831361cf.38.1765339297543;
        Tue, 09 Dec 2025 20:01:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFR6q8iXUcqUwTpaJVE3qBT3yDxxuu4wFZVSU6r3pLHR6MDtUDQJs8YgKtaZD9Q1cInJatE+g==
X-Received: by 2002:a05:622a:188d:b0:4ee:2080:2597 with SMTP id d75a77b69052e-4f1b1a846cdmr13830901cf.38.1765339296829;
        Tue, 09 Dec 2025 20:01:36 -0800 (PST)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-597d7b1a7c5sm5946794e87.11.2025.12.09.20.01.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 20:01:35 -0800 (PST)
Date: Wed, 10 Dec 2025 06:01:33 +0200
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
Subject: Re: [PATCH v4 9/9] arm64: dts: qcom: Add The Fairphone (Gen. 6)
Message-ID: <ysncf5bdxklhcuvxunmzd3gudx3qt6oq4ihzip6afb3fg5z27s@eonocdzxxw6f>
References: <20251210-sm7635-fp6-initial-v4-0-b05fddd8b45c@fairphone.com>
 <20251210-sm7635-fp6-initial-v4-9-b05fddd8b45c@fairphone.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210-sm7635-fp6-initial-v4-9-b05fddd8b45c@fairphone.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEwMDAzMiBTYWx0ZWRfX+9thjGpIGenz
 FsR/B1rmEB67vatmpU0yHfeoeq3Vqodirys1tCOF9Ob6WMCmd4JOg4FmrqOjqgOWzw/SOU15MDL
 DnTOV8xdGpoBADK+Y4IzQPQFYbLZhV7mhqu2C+bCNGomlowvpP6A/8MqyBsTtXoBfWs8uIt3Waq
 qUhNFMMEi65AH64nqMXoa6NvKWM0ml90F0GMKwfuSZYbSEKZSI2ZYsQlV74CJ8JomyjMAPHK0Ir
 DAjBpQHdWqXpoauPK+kaZ2GgyBK2OKrpi5DINaHRRd3XaWN6U84tHc3ZxV+NLM4ePPekastyM32
 urTUL6LBzNfgfsDI/m6DlwY+WraqaU/5g59EOMlPfilmSEBEJuBjSt0jUgPLyd6D3jQSKS6TGcp
 Tz8RYmH+fIA46BWZtXACORUcItxcDA==
X-Proofpoint-ORIG-GUID: i92-Un3PVHfW9q-1lyuLcY0fknZMIN_-
X-Authority-Analysis: v=2.4 cv=Vcj6/Vp9 c=1 sm=1 tr=0 ts=6938f0a2 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=6H0WHjuAAAAA:8 a=EUspDBNiAAAA:8 a=9_MgF4w4W-WW1lAcsO4A:9 a=CjuIK1q_8ugA:10
 a=zgiPjhLxNE0A:10 a=uxP6HrT_eTzRwkO_Te1X:22 a=Soq9LBFxuPC4vsCAQt-j:22
X-Proofpoint-GUID: i92-Un3PVHfW9q-1lyuLcY0fknZMIN_-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-09_05,2025-12-09_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 malwarescore=0 impostorscore=0 suspectscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2512100032

On Wed, Dec 10, 2025 at 10:43:33AM +0900, Luca Weiss wrote:
> Add a devicetree for The Fairphone (Gen. 6) smartphone, which is based
> on the Milos/SM7635 SoC.
> 
> Supported functionality as of this initial submission:
> * Debug UART
> * Regulators (PM7550, PM8550VS, PMR735B, PM8008)
> * Remoteprocs (ADSP, CDSP, MPSS, WPSS)
> * Power Button, Volume Keys, Switch
> * PMIC-GLINK (Charger, Fuel gauge, USB-C mode switching)
> * Camera flash/torch LED
> * SD card
> * USB
> 
> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> ---
>  arch/arm64/boot/dts/qcom/Makefile                |   1 +
>  arch/arm64/boot/dts/qcom/milos-fairphone-fp6.dts | 790 +++++++++++++++++++++++
>  2 files changed, 791 insertions(+)
> 

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>


-- 
With best wishes
Dmitry
