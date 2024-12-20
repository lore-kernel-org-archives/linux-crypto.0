Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1EC1A2643
	for <linux-crypto@vger.kernel.org>; Fri, 20 Dec 2024 09:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734687989; cv=none; b=YP3Ly0MRNU5IGpw8ghsUmiu0zr1ckRbZb4eZzzwfdCsf/kmikiItD32DSLPrb8E9DqVhqFJ5wmvhcIfVdcq6UP9TcHrG8OtzQOO7YpaBUBQkai+sBxxLJFIX9JX2r6CmL8jq1OKM2Ty/i2tGcxkOU5HJ5sdp3qOzvldw465NwO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734687989; c=relaxed/simple;
	bh=mBNfBE7oeLsgdg4CtNXU6wSkywoB8HLK8sQBF7se2oM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qx+fYE0qFmt25663aQuz6p0SdfMJDhVeHpUDPh9RnPiBUL9y+L1Nw1g19q9a9v5tbCGPIegPZpWVSySWknSrJJzR+nGUmTC3/oy2kf5smHUV+qV/HZTV3FhzosCjLAgdHvX8W25XFeXI8ixeqFT00IKJlRlJ68/pmoSbTcwiWUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Sb5yAL0O; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Sb5yAL0O"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BK5egfR004935
	for <linux-crypto@vger.kernel.org>; Fri, 20 Dec 2024 09:46:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/keBtx+lziY+J4n4NX0Uz08s2W2+4V/g5gGeBJI5lpU=; b=Sb5yAL0OYPsAeaZb
	V5AqpokDUyYeK7E4CQfBU9OujTFFmyp3TTaUOSj3APr5Z9iTnookzz2yps4bQfV9
	Lk+3jnpwpr2b69mQJUedKXuYzNGOHFih086MkYZJ0HHgkiTrsR3rBvaAqfHrPRtY
	2j/HEEgSVVB8OQ6ouSOqflxjM20eaDUJi2tv/yuryO42O7W812rlQn6QHvRCGlrn
	LZTFLbDX+qkSOAoEFc+887azX7c6rI0aeHrCyEwLmASIEvmpuy3YL1Z4IOuOWVyE
	7yke9XxiAdkZ5TqThqFyLVb5XqMbJMStfmp2/dWUcjkiZ5o1Ei++qJolBz11Ewbt
	XTsnog==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 43n2n5rn3y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 20 Dec 2024 09:46:27 +0000 (GMT)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6d8e7016630so4025946d6.1
        for <linux-crypto@vger.kernel.org>; Fri, 20 Dec 2024 01:46:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734687986; x=1735292786;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/keBtx+lziY+J4n4NX0Uz08s2W2+4V/g5gGeBJI5lpU=;
        b=HD5T4j3g7Jxl5aZX3fsJxF8fab7FFd/fTX6NoUs7yXv9Dh7EuZSDmoypxFCLmi/f+D
         Yf4G8Bhx1Hc13rwQUvQD4frA3Qkhejyi4VOR9gAwAqVWD+RAR+ta7pBXZ8Mc0e0Tvlgp
         9n5rc15kctmH2xTOiluoF1uGoUv1KoLC1jMnPJ/YmNFIfUaFKvJbFlf6AvGfASTd1Gx/
         AcxzsTSLz1KenuJpfIo7ozzyMXfQYDPQ6c9rtJG7AgbdfckLUdWa/Z9unRX9zDk7Cy+q
         mNXQJ4q8d0JWLK6++V8yoYUXCPmFI1IY9dIHxIgcNnqMEAyYcb8Os6v7heHVUVScHW2v
         w3RA==
X-Forwarded-Encrypted: i=1; AJvYcCUJL0szCV5QV44gmrAx9InyEICclaJc1C5Gv9iToGBTk1pjwIynRnMVb+XVymE6iwxC9dDU67RmfhWg3OQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4h/+w/amLotJFMA5sd3Y85LM9FJlxc1qxIHxOhSpdkaWJ0snQ
	vlnaF/okZYAS5fcYfNNELUs6fwxBf+dUeWTRV6gxVlYEzb1knfskMmHN8xbxw0mxLjVNS923ixx
	Num5MEE/v5ZZTGcu1sHY95TZ10cigWBE0YYkE41Cly0Sea1rwGFN7pl6RInLFxlo=
X-Gm-Gg: ASbGncsTXdqwV5w7eXj6DdyH4B9N+d4nnont7ijQFLXw+39jngiEGr6aMhoT6q06n1z
	eHiCRFUkxdLtyW4nzwOlCVxstpDTZjKzgUJ3UffR0QvA0uXUN1lSA1fjQzoRgnoyv+m4EH7KS5D
	nipyD1Gn7d1bt9tzjl1NpWSd0Pz5znkcZ1kwXHz4MN7jaVKLPvvg5PeCfnf2K3nT+X4pWvuGLR9
	IHBZ3V+OHmyDLo4G93+dKUUC4K2o3nDjLQHI/Kfi7Rsj1pMkozQ2oAzoLyXpKNxNSZUD3Htlf/n
	7T5DZYCAdV9qHukXfEkVG9g0tHmz0J4N4EE=
X-Received: by 2002:ac8:7c56:0:b0:467:6379:8d2f with SMTP id d75a77b69052e-46a4a9a3aa9mr14334351cf.15.1734687986083;
        Fri, 20 Dec 2024 01:46:26 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHrWm/DRMIqTiN7nrqZdEWZUIfJVqGG7OhaCG2Jr00FGVKrkXP3kiVCmMy6B+itTJQHB9rOlQ==
X-Received: by 2002:ac8:7c56:0:b0:467:6379:8d2f with SMTP id d75a77b69052e-46a4a9a3aa9mr14334211cf.15.1734687985753;
        Fri, 20 Dec 2024 01:46:25 -0800 (PST)
Received: from [192.168.65.90] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0e8954bfsm160794066b.60.2024.12.20.01.46.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2024 01:46:25 -0800 (PST)
Message-ID: <041c19bc-980b-4fe6-9627-73358fcd9851@oss.qualcomm.com>
Date: Fri, 20 Dec 2024 10:46:22 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] arm64: dts: qcom: ipq5332: update TRNG compatible
To: Md Sadre Alam <quic_mdalam@quicinc.com>, herbert@gondor.apana.org.au,
        davem@davemloft.net, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, andersson@kernel.org, konradybcio@kernel.org,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: quic_mmanikan@quicinc.com, quic_srichara@quicinc.com,
        quic_varada@quicinc.com
References: <20241220070036.3434658-1-quic_mdalam@quicinc.com>
 <20241220070036.3434658-5-quic_mdalam@quicinc.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20241220070036.3434658-5-quic_mdalam@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: eSIs6c0Kl92EYTAcEHNCCljZYS6nkXUS
X-Proofpoint-GUID: eSIs6c0Kl92EYTAcEHNCCljZYS6nkXUS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 bulkscore=0 phishscore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1015 mlxscore=0 mlxlogscore=675 adultscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412200080

On 20.12.2024 8:00 AM, Md Sadre Alam wrote:
> RNG hardware versions greater than 3.0 are Truly Random Number
> Generators (TRNG). In IPQ5332, the RNGblock is a TRNG.
> 
> This patch corrects the compatible property which correctly describes
> the hardware without making any functional changes
> 
> Signed-off-by: Md Sadre Alam <quic_mdalam@quicinc.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
