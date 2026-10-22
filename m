Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792655139;
	b=KBr1EMe9JFIy2D4WZ+gcno3X6ad12uJh0XsLtvAQLvFmrKUFyjhGwTRDlz3eCMhAezqZ
	 ZA3Q1sRq7nBYrgVJKHq4cwdy7ipCF8anCmmT5XN6KwH5wlhwu3MQwtYOZt3E7WNSa7fUW
	 /2RQo5n/on8aM2nhWNicygCNLYF5AATucobHhJiRj0eiqKqpquKt0z5z607/C/PilcnUD
	 rKCYGfLm7pGhOpWVhaux4///GALTo9ubHt5EnpyrdpDt7HHnqlm4LpKHuUg+qNFzCD8Gj
	 RuNWJnx/toY7tpE9/F4DavJgyFTk6YvVuD6p7kdgrNMJuO20YCH9SsdAJkZf+mM5UCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792655139;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=VWNhUBbEj98a0eKk1XOTo+BnFUwSU0QxEzvHKDZ337I=;
	b=ikthEvoh20kO/9TwuIhTppbgnZA65vO+Ka65+l3o3EibXyggtYyO6LEywomo/jdkY3oS
	 XFFsjYjS2ltBF8oSYH4V10JtmtP/wntlp7UrLxo0X3LcgZLqVr72C7kDN8+dXy1bQX6Et
	 LLDOy4Q+9bUbfDIpnQP59/Li3DnKfGytTmiGJ5g+Wb9MEQGFkBObVcHjl6hr+xXCS0Kwz
	 rmOCMaU+OIEszR9ifnGv3EE2Gl3w/tFNsPDn7BYFpt8r9lIgYr9gozqhUcX0URxknaiJw
	 W00UUVmFZ2OAWXzgMFUtssumI5G77DCHDfLkJODRDbzmYVgP7O+6VY4SddC/YdzF56w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=daya9Fgv;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=PaV+ukH7;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B95606A319
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 07:45:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10B95606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=daya9Fgv;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=PaV+ukH7
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69M6xu581560103
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 07:45:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	VWNhUBbEj98a0eKk1XOTo+BnFUwSU0QxEzvHKDZ337I=; b=daya9FgvA3PourQb
	baUmIc9oFQBTsU/VeU8tgdghMEXnbBsqOktM/8Ftk6g94URWdBADi3HSWuFk1d8l
	ozeS4fNIcWYXJ9gVVvet9SiOZPUODXfO1zOM0fBk4ZQ/NRXa8qW/ktrLXZ7haueF
	frwOElWV9U31UPNoAq+JfGmGuiJR1qOnAC4wUFslxCfCkvE5OxeEz8//ZK1uTbhI
	a3qfw71ZmhzYacKpTYP1ydWzKZSlodWTBwrZQ94wexk7KI7OfW/yInRWdcf+Tn+J
	yRRuy/75xC4hR8ruji4zHGW4pn4ZRKVZUp6ENqtALpsW0/TYANWgAQRnL3E2R3C4
	ZEPp3A==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hf93ahafr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 07:45:37 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-5338bd59032so2479951cf.1
        for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 00:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792655137; x=1793259937; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VWNhUBbEj98a0eKk1XOTo+BnFUwSU0QxEzvHKDZ337I=;
        b=PaV+ukH7ZvMqvdlZZjGTiO422mxvNxeYfxXOL5hnyqYVE3hsOrm7skEPc6n1kJSvK9
         YzSWBzd2CDBKL63OdFPzcQUDLnT5HSl5L1bUxXWAwW9Dezg1NvS3bzTnU/enb2VodoDf
         q/VL+eGYOaUzZwtYz4Aot3oTqD+OeA9czv+BYoq4PLwTsOny1FtJ67gW16iCKw6WlQhk
         Vx38M5MYV0wvtczMgF6iwKwJFYuhyXpuhnlcLo9m9lxfFKMzjBPKPebrjObwCmOI7lCt
         b4mOgNjn7jubBGhcmr8S0wPNy2DHJqQP+Nr1EPGqQxwUqmmbBRmq+h+dLiPg1lx8WXrK
         /Wbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792655137; x=1793259937;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VWNhUBbEj98a0eKk1XOTo+BnFUwSU0QxEzvHKDZ337I=;
        b=ChFWFGFl31PTqdpoRKuYap7xOlhg726KNxRtAGJ6pUGpRhGxX6WposN5Z3wT1JfZnz
         Y3E/+Uj80dapt2+xVUaORtKieWqctIV5j7NECGe03DLgEQWe2ekc0otZB8VE8io+ACg6
         8aDnHSh07o/7S8clHu4dNXF+ZXo1LPc4WdTHUjZ6APBlVOKd27fX720w8gLP56FqVPfL
         PH7XJE85w2aqQ83LJFJkvvPAghajrzQ9OlR+7917NXdaVcBbBQN/pVtd7IMI+/bcuQzR
         5pqROl//TX4/cu98HRwNUXU43WqA3wOsrDZ35fkZTWjv4Oso/wPIqP8t4z6pNluUlGYW
         wexQ==
X-Forwarded-Encrypted: i=1; AKwUvBypYoc6HKKt0qFKUVASS5ZCLESzli9AXdhTsFaNA3196egw6cXqGf/IpI4Sp5saAmw4b80Uyf4GxhiQPX4=@vger.kernel.org
X-Gm-Message-State: AFq9FYLrJMne0SPkkKGCQTGPiDs4J816RArN6PtBLaAiudD7PRmC9GBi
	tOGpFbyP4gr3+KNiQazjKGbK1i2wamqL+AJVq4v+INquVnOhM1Ie9+Vjdxa5Yf/vGTe+y2zDwox
	Fm1aJUFGWL5+31hvyppfYkbMZdKQ/zVew0vJd6QxJ89jlZgn28Z0JWuN0MKANixMWjI8=
X-Gm-Gg: AYBFou2V/kO8qGSZg8LjxkBGqrReLdwEctqtXmGyVK5FP10SvFzTH8OD2dUlKOzxWy5
	Yv/kMt4hQYLOcWHlnZiBQlqRXm4JkypACz2y7h+wpeSKFLIRAowyREDw88PDmM9MyLKkoGVdp0a
	oyHH02c5xOxfOAtF5M98HDxpUQRG1Lr2AhXsHrRDXZfm4vSwFFLotDeFfgIfuYjRn0nbY7lr5Ui
	mdPg2G3gv+PZKDs1haXLpyGmEYQsMlaWrQDwa5WKj69aHG9/vFf/u0VI8hOzZB/Io7TeJfhssqR
	iDT3yjl/o5CjEQ17Qdnlnjto2WfzUknC6xCWt7051pxOGmKO/17MIWhtfp/p5IPZ1wFaoXddL0j
	nTkj/LOXH1qgb9rTt904FPw==
X-Received: by 2002:a05:622a:138e:b0:536:662:3776 with SMTP id d75a77b69052e-5369b857ce9mr84820291cf.3.1792655136802;
        Thu, 22 Oct 2026 00:45:36 -0700 (PDT)
X-Received: by 2002:a05:622a:138e:b0:536:662:3776 with SMTP id d75a77b69052e-5369b857ce9mr84820081cf.3.1792655136379;
        Thu, 22 Oct 2026 00:45:36 -0700 (PDT)
Received: from [192.168.226.26] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c468a59689bsm76332866b.48.2026.10.22.00.45.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2026 00:45:35 -0700 (PDT)
Message-ID: <6b539621-20a4-42a4-bf1f-1fd58f803581@oss.qualcomm.com>
Date: Thu, 22 Oct 2026 09:45:33 +0200
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] firmware: qcom: Add a generic ICE service
To: Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
        Sumit Garg <sumit.garg@oss.qualcomm.com>,
        Selvam Sathappan Periakaruppan <selvam.periakaruppan@oss.qualcomm.com>
Cc: Basant Kumar <basantk@qti.qualcomm.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20261021-ice-migrate-tee-svc-v1-0-b035be7aab0a@oss.qualcomm.com>
 <20261021-ice-migrate-tee-svc-v1-1-b035be7aab0a@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20261021-ice-migrate-tee-svc-v1-1-b035be7aab0a@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIyMDAzMCBTYWx0ZWRfXzXlL1wyApscU
 QO6EDzY77yc6BjP9p+WUuHmSL8na+ZH6A+71TA3aGeurs5GjLmCxEuhsJ/of56jWuXNARU+QVCt
 NrL4Rpk6PRxzabR7Ei8/LRTq1WcG6883ZrdfteAKJHVFy1N9tGfARJcQa8Xo2uCm19v6aWasfBA
 tfs+eRV2xBFWNkI5jkJxQEjzIVSf9hsQZgg7zrgUuI+TAReLYMWR7hVu0V6V2fTPbZBCPZnTlbb
 7G1Dnevi+F/p8QI6gSfCuzUErEhSH4yuqagquh6XuuXWWSPZnzXCuW1WizRn2GePqY3ysNVonrG
 InLXja1plCBO/RxG9IRKTUIsV+2Cx1NktX97eSfH+sla1L45IgtUtKLE5RNXkeESzKZEdWE2mMD
 aX4QKDHa9/gaz4qZ4c9oIonXL+QFGapZRurG+q3BAO5m32AP7WrwpvDh0p4vD3Yg1fe5iYZ42rw
 UiGgwCjGZVNJHPsy6xg==
X-Proofpoint-GUID: etQfi24qezSnhTyRqGMvuSIi7iAeVPpP
X-Authority-Analysis: v=2.4 cv=feg4WEQF c=1 sm=1 tr=0 ts=6ad9bf21 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=IgLHovSQZjQVHc4R8FYA:9 a=QEXdDO2ut3YA:10
 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-ORIG-GUID: etQfi24qezSnhTyRqGMvuSIi7iAeVPpP
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIyMDAzMCBTYWx0ZWRfX9gTyzkkac2Lh
 KvMFTYwfQYF05GpGtlldnIpNXIVP+4IgzaQ0EjAdmSsnzEdq54+qC97rQ7XyPqz+3fMdADZKCTV
 gAKJ8PhBtGRdQvVjlekSRTMh8MZhel0=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-22_03,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0 suspectscore=0
 spamscore=0 adultscore=0 priorityscore=1501 malwarescore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610220030

On 10/21/26 5:43 PM, Harshal Dev wrote:
> Qualcomm platforms such as the IQ-9075 EVK now boot with both QTEE and
> OPTEE. However, the Qualcomm Inline Crypto Engine (ICE) driver
> currently only makes SCM calls into QTEE. With the arrival of ICE
> support on OPTEE for Qualcomm platforms, there is a need for a generic
> layer which re-directs the call to the correct TEE at runtime.
> 
> Add a generic ICE service which acts as a common layer with different
> TEE backends plugged in whether it's an SCM implementation or a proper
> TEE bus based implementation (such as for OPTEE).
> 
> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
> ---

[...]

> +bool qcom_ice_svc_ops_registered(void)
> +{
> +	/*
> +	 * The barrier for ops_ptr is intended to synchronize the data stores
> +	 * for the ops data structure when client drivers are in parallel
> +	 * checking for ICE service availability.
> +	 */
> +	return !!smp_load_acquire(&ops_ptr);
> +}
> +EXPORT_SYMBOL_GPL(qcom_ice_svc_ops_registered);
> +
> +bool qcom_ice_svc_available(void)
> +{
> +	if (!ops_ptr)

Should this also be a barrier read?

Konrad
