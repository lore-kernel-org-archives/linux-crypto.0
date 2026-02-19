Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C37A26056A
	for <linux-crypto@vger.kernel.org>; Thu, 19 Feb 2026 14:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771510601; cv=none; b=jz+XEwlFZzImEzLAtw1sBvt8qIziJ5KNscPyw6ONzFkDPy4oPVPW1NqLqFMGY6AQ/ZBV2ZdX8ehcnVOvOY+fOTGgxbg8aXq+zm5ba09U13a3FumZ6gno6XBvZfJpw9Rv2potDIQ8H03u+hdk+D6bzRMQhLWw381WnUv1P2NtDtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771510601; c=relaxed/simple;
	bh=HETJtyp/JHXsiMCimm8i4MBIY+1eT0ucGCYLZLoJtZE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l50fujJibhpEUmIvbmsfi/6PhcBKS7NIuOU6048s1o5ZWQTQ5pBXLgLIjjFOeiVkjACKcs7a5SeN4VoxrPsPrZEEjhgvkrNZeBdbpWhU83a8Gs8hZ1nS4DDCUZey2iXhy1QtuJoI3AcCTDqtf4GtIkZoZk8xpocmEvmQADPCjCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=MStE8fBt; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=OXH0nrA2; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="MStE8fBt";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="OXH0nrA2"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61JCS3ZW3077781
	for <linux-crypto@vger.kernel.org>; Thu, 19 Feb 2026 14:16:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	eVTlPMAt7Z1bsoOzdrd3oAbIg8fsyWqJ8xySgQqtea4=; b=MStE8fBtZOUKUu9n
	vUMojD1crSoWkyPBexB8gFRzTnVcIxFjVxLFfjijQV7GdM7m+ywo2kZXF7QOgNxI
	NvubO/E4hPofPyPZQUnZUYudJ120aGrighx1bw2QQX5Gi5mdAhf14BMOLAatKpTF
	BF1BTHMV4nFcD/0QCdLACBj5DEWonKzDnRmoJ9cgijs9ezRsBgidRhEeTlxxrjOh
	RQQ4/ietCynJV33JpS+iejysbPud8ZooZzfoenKRbH74TwUk3PadCPuPVFvO0UD7
	MjyW03yGCE9ZINYsaUqWr3Y9PIMAyFBV14wFYSHKl8EIjAnh6xvSOKRwf7UGXWWU
	Ry3Ktg==
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com [209.85.217.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cdrk81rnr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 19 Feb 2026 14:16:38 +0000 (GMT)
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-5fdf2ffbdaeso213819137.2
        for <linux-crypto@vger.kernel.org>; Thu, 19 Feb 2026 06:16:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1771510598; x=1772115398; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eVTlPMAt7Z1bsoOzdrd3oAbIg8fsyWqJ8xySgQqtea4=;
        b=OXH0nrA2+93+e+K98A/G83O0xqSYC/u3kWsCVKVr+7q+ZvLPgFXC0dwYQJYT5hrAtq
         8QqzZoooC7zReOJi14J/Tol9Uldk02Mg27d6L1ZWPbqGTu/bXmGgwDgNbfhmGp6Pi/aY
         pv/W3ZkoIlCG6tfU6JBkVUM1ldCMWJVRxPvP2Z0wEe9o1KR8nieTS2HoZNRXprPWfriZ
         OGCb97ETl6hxg7xk8xov4tjYC1GPZRFfE43fOqNw0w1ngCtyyS5ZCZTM1tZ+KJmD8ImM
         gCUiL4dJNp/uCEYrJ+1opDtxxjYrqKkoHyz28MN7iPh7hpw1RwRme3sii/Cl1+2lQQ2y
         zZMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771510598; x=1772115398;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eVTlPMAt7Z1bsoOzdrd3oAbIg8fsyWqJ8xySgQqtea4=;
        b=w0lJFw3Lz+nyimGl7pPGMFf6pbz7TT3CdjEmGKeSBMHRkTRLkF+rL+qkJfUqQ1T1mG
         rCjPDt9HAmjrCx8nQXGiyIa0qP+fijTJvFb/hs24noRxd4dkbSOFTEB/dePq/vEYXPrO
         pOSPlpQvohrJrmwMWWlC4GlsW6pZTvDXNI12cWxr1i+/mw7flaeW0ctV6b6liW/639E/
         I4L829flzBJSRf/SnYcwkhSNn6rqZ5+OC8NNT88G7qZorrk6Ik7YKNbOzMxbKOj3GJn8
         kx2RrC2TUrHA5Vg3qpswmk2c0FmJ2BCE51loYcOA37BcD9Ngc6S6OyBse/Hi4g+Tf9MH
         vZtQ==
X-Forwarded-Encrypted: i=1; AJvYcCWU9+WD7/YF9G73hpVx4b47rMWY+Ze//FwICCuG+GpQ3JXIYvKtL/1Px3807qNXNRUYXgU7+S4tW0ThXnQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZY8/5OMKh+4WIIPKvO67Pvn5lEfi4TNQ44s4pARzJBeFwlK5f
	Owp7hbvMR4Y07i5LJm4Rr1wjMb0gypGQ6jP4hPPMHosYoFvFcRKBh9okFehUpBKFPsb3nqJgKnQ
	eg2q1CeR5tRycvZk0DU4scSS9Y5b25fjsNrcC3vY1X9QoNd20MydmBnqgUMY74IQiVao=
X-Gm-Gg: AZuq6aLlkBN0DYYGSVm+w7mbcdNRD6rx7R6oR8pp+C/GiFhux0DVcPCfkLkCL107Jeh
	HK6yU7v16srdOwqbcXVguTyKWIwkOemeCWhmxExQ+6TvNq3IIJaxLR6t3kjwvFEVQdF0wNDeB5Y
	ROAS4lpj3HWFz9sf//FmgEMM1F5eTARZbZjEQFRXY9Nc55BQRDAHV7+IMWFaKhSr4Rzbu8AhRUC
	rDTPs7E8NTeFvXcGzEq6ez3lJQSCaMIthAA9BLy6YhZ9lKQKSGU5g1HG731f59mYBHOTSbIH6Cj
	EQBoYFzi2fHhick0gbVgjixQKGM1QHJJz4Xz5krqQmsVmT+NZqMBbu0h+GmoKokA+JkDNpLsLyi
	zhG8jIDlAXo3Bb10S3q3+97TIZPSuJGirm+h7uBjfj4jVGbYhhjz6mN+zONO/4+B/ZxklD2IghA
	yPnnc=
X-Received: by 2002:a05:6102:5087:b0:5f9:3927:4b1e with SMTP id ada2fe7eead31-5fe16f0e687mr4498226137.6.1771510597934;
        Thu, 19 Feb 2026 06:16:37 -0800 (PST)
X-Received: by 2002:a05:6102:5087:b0:5f9:3927:4b1e with SMTP id ada2fe7eead31-5fe16f0e687mr4498180137.6.1771510597414;
        Thu, 19 Feb 2026 06:16:37 -0800 (PST)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8fc7665563sm573056766b.47.2026.02.19.06.16.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Feb 2026 06:16:36 -0800 (PST)
Message-ID: <15495f8a-37b0-4768-9ee1-05fd6c70034e@oss.qualcomm.com>
Date: Thu, 19 Feb 2026 15:16:33 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/4] soc: qcom: ice: Add OPP-based clock scaling
 support for ICE
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20260219-enable-ufs-ice-clock-scaling-v6-0-0c5245117d45@oss.qualcomm.com>
 <20260219-enable-ufs-ice-clock-scaling-v6-2-0c5245117d45@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260219-enable-ufs-ice-clock-scaling-v6-2-0c5245117d45@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: JQ5cPZTl1f_pLl5jJ2azKhvotnMDIFjj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE5MDEzMCBTYWx0ZWRfX2HWsR5CwwMvt
 ca9jVXXX/KIvqUCmxLeiNT3zuCiet7WTV2h4VRvZW7Hkn3Dyo6Rz/G3SN6pYAPlKRUL190bOz9a
 NoG140SqKIaSRP5Iecl/AOUlg5MvuNBSwauHPgYhpwkFYQIJpwFSuw/is2hCxI9CzYqHZW2hoPJ
 qpG76XM+hWC2+vp1/ZBM/s+Y6pjw3LSJQbb92B5gZlDsGS5q4UgjkFz3I/0TH7DoOZh36/MGUHz
 xAS3w/CHrb0NyWtBII6veOHuDfH/ot+jRZPFD0uvOPuIaWjMfn5QsxHP0lf0fpm54DF5haKh8x9
 h94594UscuouZnxmy48eoehjIAca4JEFcFDliezx8/NifcNTQoJrPTjQ4yMwYOVb1xjNQ1H0wTx
 qRCyEZDq2jMr04K9u817fKuqk+BDiZ/pVVUBzFSQKCbmGaawHKL80XN9glgifhDyHlmXnCsAQ7f
 1rhklY6YHRUVDkOufHg==
X-Authority-Analysis: v=2.4 cv=MJBtWcZl c=1 sm=1 tr=0 ts=69971b46 cx=c_pps
 a=P2rfLEam3zuxRRdjJWA2cw==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=EUspDBNiAAAA:8 a=jUDvDPFTW8JP9J0CQvoA:9 a=QEXdDO2ut3YA:10
 a=ODZdjJIeia2B_SHc_B0f:22
X-Proofpoint-ORIG-GUID: JQ5cPZTl1f_pLl5jJ2azKhvotnMDIFjj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_04,2026-02-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 clxscore=1015 bulkscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602190130

On 2/19/26 10:39 AM, Abhinaba Rakshit wrote:
> Register optional operation-points-v2 table for ICE device
> during device probe.
> 
> Introduce clock scaling API qcom_ice_scale_clk which scale ICE
> core clock based on the target frequency provided and if a valid
> OPP-table is registered. Use flags (if provided) to decide on
> the rounding of the clock freq against OPP-table. Disable clock
> scaling if OPP-table is not registered.
> 
> When an ICE-device specific OPP table is available, use the PM OPP
> framework to manage frequency scaling and maintain proper power-domain
> constraints.
> 
> Also, ensure to drop the votes in suspend to prevent power/thermal
> retention. Subsequently restore the frequency in resume from
> core_clk_freq which stores the last ICE core clock operating frequency.
> 
> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> ---

[...]

> +int qcom_ice_scale_clk(struct qcom_ice *ice, unsigned long target_freq,
> +		       unsigned int flags)

If you're not going to add more flags, 'bool round_ceil' would do just fine,
without introducing new custom defines

[...]

> +	/*
> +	 * Register the OPP table only when ICE is described as a standalone
> +	 * device node. Older platforms place ICE inside the storage controller
> +	 * node, so they don't need an OPP table here, as they are handled in
> +	 * storage controller.
> +	 */
> +	if (!is_legacy_binding) {
> +		/* OPP table is optional */
> +		err = devm_pm_opp_of_add_table(dev);
> +		if (err && err != -ENODEV) {
> +			dev_err(dev, "Invalid OPP table in Device tree\n");
> +			return ERR_PTR(err);
> +		}
> +		engine->has_opp = (err == 0);
> +
> +		if (!engine->has_opp)
> +			dev_info(dev, "ICE OPP table is not registered\n");

dev_warn(dev, "ICE OPP table is not registered, please update your DT")

Konrad
