Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112F3246335
	for <linux-crypto@vger.kernel.org>; Mon, 14 Jul 2025 10:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752489962; cv=none; b=h6BINhUUwtDEQvsSDDh463ZQXVrYcw03yEYcNNB8bS2jc//299xTs9Rro1FUzn/WJ5RPXDnFtbYKr2wZP/sJ1uMr6C+IVk1I61j+3+bVL/P1plgZ5l1NOd0UIcjtlg6Fk/XGAQURk4Tndnlr9+dCNPOGDOlSsVlu4bBT8C3jrJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752489962; c=relaxed/simple;
	bh=GsngcRU9ghE95V5sobt8zThiAoxS3bXWswd84ZP946Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EHokOTmqlkvP35si1MXvRyd95A7sYUTz6O99360zDQY8WbsTcjNBtl8hMj7N6ZGzalqmpZgsJT6lfv0rcgJ7mI5P6C/Py5I0d47VGRQYKLssZcvf+M/n0gwhIWRUOhICHLlCpka51c1cZXiKBkc+t7GZUhnfCC3dW4dDLg/3+To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=OjgikyEb; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="OjgikyEb"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56E67UVT005599
	for <linux-crypto@vger.kernel.org>; Mon, 14 Jul 2025 10:45:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	NvkMX/SfCrQy1ThgqRjv/mjGrsXTIeTx9QKU6pkfYrU=; b=OjgikyEb1mjfDte1
	wtP/hpabasFr7CEflySVgYGJm5q0nSReES76WtUDsAjuVaGWqBaidYYc+ixjFAyW
	B1c+hS+/h5RiQtj9mbC1P/SNWh13uGAsktQ+25BjHlJO2Yp713g1b5IHML/EBtSm
	7GzjdcMCTjs4eqzESvGMBglzsukbovmXSYVcRUR95hJqGozKR0o4Tq+VKiIzkcFL
	d2fSI2y5SYSoWoqem9sJnwPZTiCFACI19+lhnsk1Jfkwn0Ld6LVvaYjNUlAeoL8U
	XKNcKYWWEsO5Gslfhw/4ku1cVVXMLjTp13cMhyuFWE+l4Q/IgOCH250QMqJZNIJm
	+gON1w==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 47vvb0ryfp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 14 Jul 2025 10:45:58 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4ab77393308so1040121cf.0
        for <linux-crypto@vger.kernel.org>; Mon, 14 Jul 2025 03:45:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752489957; x=1753094757;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NvkMX/SfCrQy1ThgqRjv/mjGrsXTIeTx9QKU6pkfYrU=;
        b=ELhnnPSIEGpNssNfN+/ffHf5147xEkhIKX/lkNih5f6ystxHId05x6ji/FnsQuFOPs
         s77sOUuFu29u6t7exKPHD7tBolXXmCN5v9dJEM2tgDBhTo8CJfkU2S3PmKXhpbbi5idV
         nNdvoAcmvBINBfat0nZXGThkNNhhkNIuWKSTDGDAsYnFDNI2pGm+KAJ/lcLyIApfA9H+
         QpX+NFyYrq5kgtkoUM+xe7rbdjSc0hDwb5TF3pF36SJhEl5EnOPMWYf57o7ALlTPu/gG
         jkqy8Lhq63GOwqdVlwg+ZCIQvbpHSTJidLYNoIlwFq6wUDmsCOE3AVlTzyTeCsLID3l2
         5m2A==
X-Forwarded-Encrypted: i=1; AJvYcCWiXWa8jLR38fnr5pZ8/VXSdOkINncpSGu+rqyiALL2HtLSH6z578TXkMEaoDgQo/1qia2SLa7z2vG0hek=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCyCuXHxNSxze+KQFukgAdDk/+PdLUIK40DnXC7AT2w/VVGf6c
	AG0baAU6ofr85o+WdZ9H6oH589/uFjUoI2MXbSoqdt2uldNEI45wcop0Q0dgLsomStIG8niPTs2
	NNJwB0QxBFFd7nHeN+YzL6lnJ5SvNT5iBZs5mlzocQN4wMaVOGJzNqotDtWhNNagckGY=
X-Gm-Gg: ASbGnctMsyH+nAVZox0FRzNJRPjqeK3PswJyMfQ4f84xPuCpOHtz3bNRsZ6CL1IyPwv
	nCcLncUC7+h6P/NAGu063pfa8r35OSoqCC9X6jUSZAsVdjaAMTPWOWTcumuktgsN0ksoPc0aklU
	K/CXHa+tI+JBfIBZHLzlId8wYcjzFHA9roCwafU6DLC42on4/WtRbyK6ucOhoUpXuz5NaL9s1Vi
	Xk+y5l8OAhOkiEChHQeQTSMor++H8Ea7fL9oOsiRtF2CaU/O3MiY3/jEttz76/EuE6e1+ldDhPa
	Wew2gGBgEmlCGDd0Tn4xoTYOFK+tzas9+8Lc6NMvCND162oed/nXoECWGSSKwd/TIx9Qb2G35zX
	zPrwkyJ45wkr0VFskzJat
X-Received: by 2002:a05:622a:2308:b0:4a9:a2d2:5cd5 with SMTP id d75a77b69052e-4a9fb85981emr61407091cf.6.1752489957155;
        Mon, 14 Jul 2025 03:45:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IELfiE1hbm9W21cfQCQReZLaomvmcfube3hO9vSP/hdiOgPjCPkHWjuKc+mXLxmKJJITonrVA==
X-Received: by 2002:a05:622a:2308:b0:4a9:a2d2:5cd5 with SMTP id d75a77b69052e-4a9fb85981emr61406911cf.6.1752489956642;
        Mon, 14 Jul 2025 03:45:56 -0700 (PDT)
Received: from [192.168.143.225] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae6e8294c15sm803864866b.117.2025.07.14.03.45.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jul 2025 03:45:56 -0700 (PDT)
Message-ID: <e2b92065-e495-465c-957c-ac10db8fec09@oss.qualcomm.com>
Date: Mon, 14 Jul 2025 12:45:52 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 13/15] arm64: dts: qcom: pm8550vs: Disable different
 PMIC SIDs by default
To: Luca Weiss <luca.weiss@fairphone.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Robert Marko <robimarko@gmail.com>,
        Das Srinagesh <quic_gurus@quicinc.com>,
        Thomas Gleixner
 <tglx@linutronix.de>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Amit Kucheria <amitk@kernel.org>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>, Lukasz Luba <lukasz.luba@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Cc: ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-mmc@vger.kernel.org
References: <20250713-sm7635-fp6-initial-v2-0-e8f9a789505b@fairphone.com>
 <20250713-sm7635-fp6-initial-v2-13-e8f9a789505b@fairphone.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20250713-sm7635-fp6-initial-v2-13-e8f9a789505b@fairphone.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: qFH59uXdFgdD0ma3dvi77zjcfQdan-Sg
X-Authority-Analysis: v=2.4 cv=B8e50PtM c=1 sm=1 tr=0 ts=6874dfe6 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=6H0WHjuAAAAA:8 a=EUspDBNiAAAA:8
 a=yhMgBbtfkmf45w4ReXcA:9 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
 a=Soq9LBFxuPC4vsCAQt-j:22
X-Proofpoint-GUID: qFH59uXdFgdD0ma3dvi77zjcfQdan-Sg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzE0MDA2MyBTYWx0ZWRfX5hY2Xr/dKkIY
 x4cxbKi7ehEeQKHkZIHcj7y1yn/S0UNM6065Z6FJFUzeL8smlW7IdTBnp64F/l38DpuMaJoqBZm
 5AzBUM4b9kC4m8xp3hXxjulIO0tjAiS9ObgMWQb9ktWc31kqGtqVfoLdzM/NnTLTWWAQUIzsuYZ
 2yZrUiWQPrOj45J3EFoGN/5pzvk35UF2hHjZ43YCsQacEBjkrT8VAxh2VZrjpghJU/dnVlhbxou
 DFOtOGGUDeMJnT5+MTeYzL7LLr1SQ4ADG2GzA1UEI7KlWYRVtGXVbHhyVMrujBaT2IJv3hREqRX
 /NI8XbBain9xKraDlKEPKdEhnJgnLOL0OQZyyog07KCphGkTwbpQNp4zwDxbitkPs98vhRn6DvS
 +uar9hrNLbZ2PNfWkdID+7kab4zLIaCMIjTUHTGBZZ9v+zEGmJiImouON1YaP9CIzgxRoROl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-14_01,2025-07-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 mlxlogscore=669 bulkscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0
 phishscore=0 priorityscore=1501 impostorscore=0 mlxscore=0 suspectscore=0
 adultscore=0 spamscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507140063

On 7/13/25 10:05 AM, Luca Weiss wrote:
> Keep the different PMIC definitions in pm8550vs.dtsi disabled by
> default, and only enable them in boards explicitly.
> 
> This allows to support boards better which only have pm8550vs_c, like
> the Milos/SM7635-based Fairphone (Gen. 6).
> 
> Note: I assume that at least some of these devices with PM8550VS also
> don't have _c, _d, _e and _g, but this patch is keeping the resulting
> devicetree the same as before this change, disabling them on boards that
> don't actually have those is out of scope for this patch.
> 
> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> ---

thanks

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
