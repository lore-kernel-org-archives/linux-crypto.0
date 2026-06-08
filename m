Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A893AC0D3
	for <linux-crypto@vger.kernel.org>; Mon,  8 Jun 2026 10:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780915026; cv=none; b=AmsEwmVejOovwORrmRDJyRoKKcrzyRSoN+AMBKTSj6AREofi5kz/ORwrUj/aNjzc8bx4rKcRn9pEUo+dh//mgLhIxO/ZZkpBVesx07mHk1Jpkrn/Nul2X9uiN4W/g048pi2/6axMGXkm3YZLH0CZQz+ZswRNAPEznUVE+iqOWoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780915026; c=relaxed/simple;
	bh=aiDAVGEiUc0oYT+3S9GzOXw5GdKTypTgkU3+VwBquFY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MBthciBVMAx3PmByN97bhxRkoN6zE8ZNU5En1OcBrPRIEPacf8XKgN0Cew4ILTXD05Ne2hG75ZLh5CelFAK01CfZL0D6EmUIL453Fz7jIg1MceTOkAFwQHwCJIr0HVQVD2BcnrnTk9MLLWC5GID3xN6ntE6YCRKdYowIqKeaaUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=b/rYwJ/6; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PGilS/o2; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="b/rYwJ/6";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PGilS/o2"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65892L0D2677815
	for <linux-crypto@vger.kernel.org>; Mon, 8 Jun 2026 10:37:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	j5Se8C//N9UnMC3RGnV4j8r4mQ1Cde/I25SKzifZks0=; b=b/rYwJ/6vqt7glV0
	Y4RDY3zATS06Q+W95x1Qd1STh2jP/4iptX55wyZP4ccsJjxIJLw6ufYBWVyBafZZ
	YJq3tPJ+21gVf2Y/jwtauFIS8yb1eD6EdS8gyNXJjgJxRDhZtnUYv4yg0NUQLO9s
	4NO6UMO5ttmM3TghdkdZu6/dP0c8qPWqIr7IkBdpJWflEZNLxczoC55K6123LuJF
	cCkA4pKgw+tOL7Wnp4AXvdAtFjkXJDCim5HtgYuEIhCyTkXexUblsCM701UcsIgB
	0xMvK1oMOhIiuOxdePro/HYnvenBW2WgpVnajnfnpOxs7B+IrmMUe4vjuzRrZ6qz
	huHPhg==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4entrkrdps-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 08 Jun 2026 10:37:04 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-36e09ec696aso7142100a91.0
        for <linux-crypto@vger.kernel.org>; Mon, 08 Jun 2026 03:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780915024; x=1781519824; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j5Se8C//N9UnMC3RGnV4j8r4mQ1Cde/I25SKzifZks0=;
        b=PGilS/o20aOLr52Vm+xY1zuK/mSEfPhQp3AOua1CEt6wFI2yl+1ictLwiAoffhyqgV
         BFEFic/41AP0TJ/O1dDu5er0fPkJ55qx5xz5T5agZeCMNgu+bQGar1CDbjc26LAaNynO
         VdV9zFkauSuvpZm8+26h12itCp+gKjpbn/Uft29b9+4Ew94HW8DvnL6o65Mg0pkdjtUt
         RFCUEVhd51KmcQfB2NDL0y4paO6IF25lITzQCX+DRQW4xBQ4BTnLU96taR76Uomt8NXz
         ICT6kMt7cUVNSZaR6DXrQwKeLJF3o5RuLq5ZjhNhIvOF3pAwY2MAJzr91i6rT6xAMvxs
         mfdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780915024; x=1781519824;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j5Se8C//N9UnMC3RGnV4j8r4mQ1Cde/I25SKzifZks0=;
        b=dn6C8xSCAbf590+zhSzNuDQu0XOH/wM71ImM0u4WVJaF/GfvoRJU3j41rG1uKTaV3g
         VANcNP3BhA4E3gTFDpYprTq+UCuBMa87mFWk637DV/FhEgl7BUrYOct97Pr/moPTIdR/
         iBdHzuqwuFGwtexKElMD7LBEuy67QnmD13yiNEx+fCFgxINBUcBaDLezbPrwpxLd53oa
         x63aL1PRkOvjAj2c27hZhOUlxf0ULkDuzXVt2ZrfvaFK6tS3awx/EXHR7Xe8XFPwPXMP
         0eOCFFMd2rvo0sDARle8EqcePU3bp8DlP8X83r8Kpntn/GxjpgNvbLjVM4MXogRjM8Ae
         nZTA==
X-Forwarded-Encrypted: i=1; AFNElJ98nbLbaSz5KcqMTBVIY60nauDgbGP98XGzSpOC1OJA5SdfGe29bs6pAP7Z1OLBumbLEZA+aGWcufqv/yo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRuHs+5EG/TdBVnKK7er6HivSCvrIQLvMI0uKHjXNf8TAllHLV
	ykmQHDIPh9LAmp56OrRsi7ReSahBGsYTrXWf70mwqjak2OkSXdDegEyKpH0X+Nh8BCQOVOZF/mt
	FW9+QKSMrB9N9bmBNxncS5AG8DoviPiGiOelK+yXPyHZGl/UPL1da5lsd6KfnkYdcA+g=
X-Gm-Gg: Acq92OHWBMCHqQyn2V9+Bfdnd7iUdhm/G6i7kCDI0MdBRp9T8PzcV9sW0vblt/kfHLn
	ahinzCkl8aHYy1BwwnF8dkAxk6uvIvLGEtNKhz7V1qftdRn3ZHEtO08gSZdTUrYvtMdENjp8VvA
	az9JT+MAWKm/KkbUI1Fc8KZy01FLf9Lg8oHpg1eLscbFfLij7uFge6KZI/h2avHbNOkBxM54Y68
	Rm588ASiUSKj53/x+hOl/bs5v5EcM8h2qrPCiC8DfcnYkkCZ4BY6MdbjsWRjjCTtY87lK5TG3cK
	6pXndQfbKNbIbBgLKSUMcXYaZJ+pMmbOB9Gm1JSc1lLlxXSFUUihfZ+Qz1vR62PAviEVzR4Z2Ct
	OAjejK3V/rR/xLEPeCLLTuKRwmUqMrj1YwISrvIdRDvuKnQ8DVDb3Nx0l28eSGD4=
X-Received: by 2002:a17:90a:d884:b0:36d:b680:3041 with SMTP id 98e67ed59e1d1-370ee82fb58mr14402647a91.4.1780915023695;
        Mon, 08 Jun 2026 03:37:03 -0700 (PDT)
X-Received: by 2002:a17:90a:d884:b0:36d:b680:3041 with SMTP id 98e67ed59e1d1-370ee82fb58mr14402621a91.4.1780915023259;
        Mon, 08 Jun 2026 03:37:03 -0700 (PDT)
Received: from [10.217.222.59] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8428221c3e4sm18338118b3a.5.2026.06.08.03.36.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2026 03:37:02 -0700 (PDT)
Message-ID: <a5faf969-1032-4814-b9ee-c851d28961a2@oss.qualcomm.com>
Date: Mon, 8 Jun 2026 16:06:57 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] Add support for ice sdhc on shikra
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260515-shikra_ice_ufs-v2-0-2724a54339db@oss.qualcomm.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20260515-shikra_ice_ufs-v2-0-2724a54339db@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: oY3rwmZIHX6165A76g3PiEq5NuwCQiIO
X-Authority-Analysis: v=2.4 cv=Z+3c2nRA c=1 sm=1 tr=0 ts=6a269b50 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=GO_outlitdoLqHpc7vUA:9 a=QEXdDO2ut3YA:10
 a=ZXulRonScM0A:10 a=zZCYzV9kfG8A:10 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-GUID: oY3rwmZIHX6165A76g3PiEq5NuwCQiIO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA4MDA5OSBTYWx0ZWRfX6oiJQdkrC0/h
 YZGsLpD7lsa7rq45F1New+Fxk0v8s0zSZcfTVMt/yJjdYwZQXiK1m9qxZ1aoFC30gZZcQ9e0lns
 yFgW2EF8tee+zwovlBiYPUg1b+3nLy1HjhPfKluZVOnQJtb5XEYW4cz7Cci1dkrYUdIvqvkTjfx
 JNhaoPOrKccNv0+4NbK+dOj/PU/Kze4gh66NqxJMN825+4K216arRWJDogydkxRQ5SlOXdsGqzX
 HwVBzUiQ5zMCXx7xzfxFkCsNtmIoiNRHm80x9qSIosytban2T4XX9LoCkGA+vd98B1OlwU33ACH
 vwPdw1WoKwhZ6qT/UTuF45dz+ZlZJ5A+EC9/0b1VJuIQ50xqYgR5dwIEdem8Roap5xuqtbTuPq5
 enwMPlK45jmPyuR2x5kDjFYuQ3U96JCvnCdOXwlNOt4yIFZHhIYz1q74LVUiEsWDz+8ee9mYlZ5
 ERpTuqRDAaR4OU/xtCA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-08_02,2026-06-05_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 malwarescore=0 suspectscore=0 clxscore=1015
 adultscore=0 priorityscore=1501 spamscore=0 impostorscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605210000
 definitions=main-2606080099

On 15-05-2026 16:16, Kuldeep Singh wrote:
> This patchseries attempt to enable ice sdhc on shikra similar to other
> platforms.
> 
> Validations: 
> - Driver probe on bootup.
> 
> Dependency on:
> - https://lore.kernel.org/all/20260512-shikra-dt-v1-0-716438330dd0@oss.qualcomm.com/
> - https://lore.kernel.org/linux-arm-msm/20260416-qcom_ice_power_and_clk_vote-v5-0-5ccf5d7e2846@oss.qualcomm.com/
> 
> Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

Kind reminder, rng/ice/qcrypto patchsets are sent together sometime back
in single series and please follow here[1] for discussions.

Please consider this series as inactive from merger point of view.

[1]
https://lore.kernel.org/all/20260521-shikra_crypto_changse-v1-0-0154cc9cc0de@oss.qualcomm.com/

-- 
Regards
Kuldeep

