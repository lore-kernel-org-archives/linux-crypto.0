Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC531FAC42
	for <linux-crypto@vger.kernel.org>; Thu,  9 Apr 2026 04:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775707745; cv=none; b=henNN605QnDDy+vvjoHpYaAN/e+WBgo/tfR+27jT+iTjuAPGdAiN2BTMiNzyUW+PDUQD54NsXDg8c8L/bpUYYpcRkhuGPhQDlRnjsp6TH4m2okA3pJpp3IaSKpFn39STzINxh9itGP5ojDPStAlpOmSHX+x+Q9+s3jNElLylfAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775707745; c=relaxed/simple;
	bh=ZSf5xO+BLsbBoBd0FQBbT7p9kYdgQNM6EbBkzvXqI28=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nLfysHEhAzDupsWYatbrtUMblCaDYxnGLxaw6ND75zoVX3Yw6i3qGoJ3Rptbvj4SnxjW56X3cGLsr8qjIJFvJg+fCPmRh7bRkEN+aISTzk1pFckAnvl0BAaqdP2u7Y3qFC71LxB34zyiRrHjcO6rTjAZAshyIdQflN9KBeiPekI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=jGLjg1wO; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=FOKKvOYe; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="jGLjg1wO";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="FOKKvOYe"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 638N7EYi1923825
	for <linux-crypto@vger.kernel.org>; Thu, 9 Apr 2026 04:09:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	rTNoDrtKSCQdYNXgupm04bBF1BRz+e09UGrEYCktWOY=; b=jGLjg1wOmB47h/ZL
	arsvpH3/jfQCZDeSzGhOeDhrS/VA24QP3Z3DJIIdFxjvYDeGWpO8e1VxYGpCTGVh
	P5xnvDuLd9Ib//go6jqIoVmp/YVKfQ6RZ4wAw+/GPyP+XwXnex8cz5ZIaBABNrKa
	vWHGKuhhaHfEt5zQqHm53c3J2pMCzbPdyxTujSapp8VyCyXuQEk28qISmfC+SxsC
	Sif+h9O+SNk5Q7TWbT1OK96NuPn4kdTltrd7X+bikHBJ00StOxqoakhY/MN8PlEy
	k/pUIDsHW79cWGMkwbmGSBt6J8uwUHVmRzYKP94KWIg8Ve917gYD/bgGd6+XGbx3
	xP6eeg==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ddt28tbds-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 09 Apr 2026 04:09:03 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-35d93a8149bso532528a91.0
        for <linux-crypto@vger.kernel.org>; Wed, 08 Apr 2026 21:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1775707743; x=1776312543; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rTNoDrtKSCQdYNXgupm04bBF1BRz+e09UGrEYCktWOY=;
        b=FOKKvOYeKo/SwaO5AK1qZmYbK5BAXD6iZ5+9erhlxFl6bQTvUWqyQLXbQq6CI2nO5k
         FiMXg7DUSBXr1v6xW8BBzVxphapo/zeLDl8iHolOHNkLGIJPQXsEQbOXfrkQ2vL5xDlx
         mlumKpQQNIhjP7eh98sUPd8/kShU+jdicXL2kKPwMSMcmpuSz8jZzul1O32lx18hPwu2
         IK7TuLbCpQLahmEh++lnLdeitlJ6hq2ih+TkEEqJapI2+F2dKHkx6aAZ35E3h8gGiXiA
         vblsnByZk5zfUMhO1K+c5+iyx7lsSJl5bdvfynbhhDM+JNT8zad9qWPQco6Sx+OicA0t
         VXdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775707743; x=1776312543;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rTNoDrtKSCQdYNXgupm04bBF1BRz+e09UGrEYCktWOY=;
        b=I+A3ysq8z4hb4AJ8dkeHwmUbcb02B82kcW5JLmDYuYpdAujlVLfbGs7xCX+RPYZ9bq
         4JM2x58JZx113hipByfgGtnp97pOEdUdr/9/DkoILgctjqRZccrIb54CUTYnMX92l90Z
         3B6uA4CE13d973IfeVXVm0s4he0mW6WIuCLmEMG1ObmIYsoc+ZNBc+v77l1Sb/AbX7Qe
         KzUX6NVPgVlfUE0EUqQOyxUgBNpb/zTmyDq608f8nKRuDOhu80kn7OKKBsgpKO/76Qs3
         GAmc85lPoVklejksvAveeSRz/7OmyZpGxM9QXihT9IeFvaKG0yPNED7Ls+Jzc7FYI9bH
         zFeQ==
X-Forwarded-Encrypted: i=1; AJvYcCWfJc21JP/dCverXpGwAG/x+bkGx3FE0N4/Sq7LRslcIC99gxp5zxeGWtW/kYUYcigK1Y5ZhriPzWFgixw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yybifew0PVPSfHdxQVtT1nstXP+nAD4JNUxXEF90aT0lJmJHu8w
	X03ZosRvC8Qa/RdpI0P4XtW28lWhEn4/fuLWl8FIusDTiuTuCjhVKTgbNzrPaaNBgLUt+qlg3CN
	0eO7y/b8kFBzvUbDsxfiDuFtzf9LBjiTvjc4+/S0zHEzRO5JgDkrAwWPC1lHU06BAMoQ=
X-Gm-Gg: AeBDievwSsKPAxw7nO8w3jXoCXX+lWYT1xdcVbEZ472Uso/SeN46rf4ZL7EOmBqYZ2Z
	Jcus5dXeJIKa9K7JLMlEKGynaGeoIhieeEvHUCAlOtUHqABv3NebDcstVMSmwb34k8nIDC68UOF
	bDX0G37po+6VNRBahAvWTVyF+MbA0YFy7Z4UIjv94t2pLMmd/4//g5H6/v5R3l4c1ZGoPzZjCPl
	RWObccpp8sYRktWv5uyM/Ey3841ywu7e0I/0AcMiAqPH5yBz7nC2fkyTEKTvQEU7Aijfx/g3L3s
	VlNwJ8WScbCllD8OSQNLjWf9xmaVo0EKfLW77+FaZsHW1zsv+IrVLAGlU0ooo9Pz6BSM5oe9l4I
	AmKSz0+Ient9fDM9U0g4vHE2LB3f2WMPtiYX/wuRaEHPJvZASBZsL
X-Received: by 2002:a05:6a20:7d9b:b0:39b:e3aa:df2d with SMTP id adf61e73a8af0-39fc928ecbemr1917816637.7.1775707742946;
        Wed, 08 Apr 2026 21:09:02 -0700 (PDT)
X-Received: by 2002:a05:6a20:7d9b:b0:39b:e3aa:df2d with SMTP id adf61e73a8af0-39fc928ecbemr1917788637.7.1775707742497;
        Wed, 08 Apr 2026 21:09:02 -0700 (PDT)
Received: from [10.217.223.92] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76c6561fe9sm19461122a12.15.2026.04.08.21.08.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2026 21:09:01 -0700 (PDT)
Message-ID: <f450b6c9-e577-4d4a-9d01-c331efa8bac5@oss.qualcomm.com>
Date: Thu, 9 Apr 2026 09:38:56 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] arm64: dts: qcom: eliza: Add QCE crypto
To: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260407-crypto-qcom-eliza-v1-0-40f61a1454a2@oss.qualcomm.com>
 <20260407-crypto-qcom-eliza-v1-2-40f61a1454a2@oss.qualcomm.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20260407-crypto-qcom-eliza-v1-2-40f61a1454a2@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: ElBw5JkXsREw_eOCHM17Y15oAakAu-gW
X-Authority-Analysis: v=2.4 cv=fIIJG5ae c=1 sm=1 tr=0 ts=69d7265f cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=9nldhgvQxnsrbX0ZkhUA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDAzNCBTYWx0ZWRfXxsHVV86djgRp
 V0fNhpbIg1SGUrKZI0TCGDR+zJGu4zxhhZB2HRW1cq3eJwvfwudNaGY6uA8xsOgwDBD5WjLatii
 uDMzQX/Eo1+gQDkygxf6VsB0yL6t73koEY70YAxEtESpb2LdH7DzvgoW36A0DhVWQGn1ol2fFhi
 ZfNDnLLnkKZVu0bdI6hiVo10KCpEhJXfUnxaFZmnckwozAM+nRgIvK0thP6wEKi/1uePqdhjlr6
 pVIfBcPjnDOfAIn7mfrY1Tj6otclsvXbqHjKi7z4WG0ezEVHfZan3yFp5r8DZX/Cyc+DMmHZ3Xg
 bYbeEdY4Zgje3E06v4la5r2qSVg2qfNEkiUHJEjbvVs1vlcLEtyRciUJ8b/yRqpijuG7RvbXFIX
 q4NPlAQ4KLk1+96UGBsQvn0hl4k14yZBSdTn9uIg1dlTD1r/cNG34EmNsCscWA0Xs6nPuwHMZh1
 99KSYgHH401vfehY1Aw==
X-Proofpoint-GUID: ElBw5JkXsREw_eOCHM17Y15oAakAu-gW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-09_01,2026-04-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015 adultscore=0
 bulkscore=0 malwarescore=0 phishscore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604090034

On 4/7/2026 7:21 PM, Krzysztof Kozlowski wrote:
> Add nodes for the BAM DAM and QCE crypto engine.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

-- 
Regards
Kuldeep

