Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D4F3955D3
	for <linux-crypto@vger.kernel.org>; Mon,  8 Jun 2026 07:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780905392; cv=none; b=p8FC76ZU+odguV+kVogD9LcCf3Ij8bBwDwKWVF7l/dEFYxkFV7uxw0tAbgp7GcV2J+Z/9IBolVUXikjiwGskUdF2IHILYMTHEnI2emVO4VbeJkoMNRwBr9ACofgwRVGYiB3Z3Y3jQtz5garv49VnFw94gcFZxDbtrM3cyD+tx/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780905392; c=relaxed/simple;
	bh=KgdKlDFUiUTqm01bao1Yw3v1dGJE7B1VENQi1CGuzeA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oe52BOgHRSn6uMhrqWDyfRmyFJtlnm6yYxNFmB9HZr/LW39uhoL1UhGThc9/oTVHBkgKlrEBGP3U5ruRSFqErgTBuvTcU3rF0jrvm1h2q1FkGGQn0mgCPnIAVhbT+ShtlRM+H3QgIBZQ21hSpKwpFN5ehYBJGhSgcKwxUOGpkqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=dAc0kSwV; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=anB/7oBC; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="dAc0kSwV";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="anB/7oBC"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6586PkRe2733104
	for <linux-crypto@vger.kernel.org>; Mon, 8 Jun 2026 07:56:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	XedEyF+YcWLWUROV1EIv09BrhpY3xilBgA1jX1UONlM=; b=dAc0kSwVY0WYwsdA
	4bwxDd6F/RhRzXke7WinialL4qoVFhlKqw/VpcsqETJLJpPVuMo0kvnCuQIn7n8q
	MB83TNYVthk/iyHCr4Xknnla0DrhmEfMuziJh6MblufaFAe2Q6PtA+xShh8kTenm
	mlYamFvAzYZp+slMXvZXqdpZ+ZjKFYj4qUgJBGiD8U/xEhdNm4NTHkeSSfgUb7Ct
	G9M+61sWoPcldDirD/HsNKyADfti3IHuO17WTD5Y+MM9VeV5+qjonXfwN9uErigV
	MsIqKrdAbRrWaZZJH0p6ntuB6YV9lYAdCg6MI0zN270hvVRgucAj3dLX9GBRqxbt
	drsbnw==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4emavf6rt2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 08 Jun 2026 07:56:30 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-915ccc2d4d2so32650285a.1
        for <linux-crypto@vger.kernel.org>; Mon, 08 Jun 2026 00:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780905389; x=1781510189; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XedEyF+YcWLWUROV1EIv09BrhpY3xilBgA1jX1UONlM=;
        b=anB/7oBCqmHPi7DLNV02R/+sMDUHPzhQ5zhERjy87LoI5fSfiknR7Sz5+johm9TBzg
         Ai81vtsmSaL5Oeo811O0uB9d5pq/xrSKMRmjlMls19rA7HaBNlnbIe1Y3cdu7f6sS/kh
         3ADZsuQaUO3f8KiltHJXO0oY+6iGMLg2c0uiTNlyNhcUqAjsxZZAYP9FsHhdpXhWVrug
         +TfyVVwGirjY8YQZeagnR0TYRmlsHB2DGwFgvv9W9Xa9zKW7olPLhZSknojrnXqTyd57
         Ao4pLCJZUmv8hfb9NU0RJGu1eJdVQ/1RvHrPRkKXWGSz99x0js4UvKsAfQ5SP+hNLc4J
         Lm1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780905389; x=1781510189;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XedEyF+YcWLWUROV1EIv09BrhpY3xilBgA1jX1UONlM=;
        b=eMvpwicuwkmupCtYPWB2xplr/rP+itimHQTxQyvjdySOeNPT0BhoxrFBI6TWq0cRXL
         x/RVo3XnoVKI+NT9jB9kSajHxx55UIdC3Uk0V+vb4gcXF0JAMeofQGwnHAtu5VAUy4WA
         CTg3Y3TCyGxNDdVhp5eEdfqRueFMWK7UIYJweoFl3gtfsuQSYJjvalYsdYJibP/TcR2D
         5GRXg/7YnaQ7FlkmcxbW/GWceDALddE87hnlBn0xvqLz9SWYkCszAmJL3om2dneeFh6k
         AJDHGgfDxYeYmoyTs83DUoCnFcFmVn4b1fkeVF9F8YU6SAILpPWcnTdmu/lRrt1RHKui
         LPgQ==
X-Forwarded-Encrypted: i=1; AFNElJ/ynzt9/xp5Dr+0tL9PMCb/elJBbVUfIgREwuWW3/cz3g0cjwNTfZdLm1ndvctvtksFmw86l/2ZacXssXo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9NXKQ4VoORGnU9lPj4u79RodxyiFefSY1Qp72rFtgwJh8Qm93
	QZ57u3W+Xm6l52tRMqZre98QfJeRexPcuhdIkhP79z/y89PJTbi+n0Fxi/01wZtZvkPEz03QjjW
	iBRuLLTZNFjp9kZQS/JnU332LPJ+46ORg1K05dO+MwtjcDYcZvl0sImmuAGakaU1f6oI=
X-Gm-Gg: Acq92OHxtP7Qg3aqSkjlCxvBCuHFtUE33Q8o1S20eT+1TbDuQqseIklOiPF2Tn242zg
	H1OArzF7pOy7ZueDV7bZdVvLUt7cCl1tYnoZWVdVk/3QJMEvbQACjnYGNCI0XXgTRZM6J7jMGqd
	IbgAB8Yg80nSkTdEglqtce7RY0/YE+SVuk47BAVuj4Pyz7RMwJseqktpvbOaVu86FVJ3S1KHETW
	GsqYUf2p92mpMvxFAt4nJEV6G2+T7Vi2I4zpoD1pymfh0P+p29wpzvJRTMJ8+27Q+1V9GuIPC6Y
	UEayvDcUN33az6CkxLQjXEjkLPN23oSissoHB9n63d0Yi7AJKdKJows24GH6T53b0K91Me6EKjb
	WaU+HXE9POyTZ/v+MPgfZq9+XHBXkQy6jA39rQQKtKWFX6rsJBcNOGt6A
X-Received: by 2002:a05:620a:40ca:b0:915:83fa:b3d9 with SMTP id af79cd13be357-915a9c21c3emr1311097685a.1.1780905389518;
        Mon, 08 Jun 2026 00:56:29 -0700 (PDT)
X-Received: by 2002:a05:620a:40ca:b0:915:83fa:b3d9 with SMTP id af79cd13be357-915a9c21c3emr1311096185a.1.1780905389135;
        Mon, 08 Jun 2026 00:56:29 -0700 (PDT)
Received: from [192.168.120.170] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bf054e05199sm803704766b.29.2026.06.08.00.56.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2026 00:56:28 -0700 (PDT)
Message-ID: <79266b8b-1c9a-4d91-a567-1f4934128bf1@oss.qualcomm.com>
Date: Mon, 8 Jun 2026 09:56:26 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] crypto: qcom-rng - Enable clock in hwrng case
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Om Prakash Singh
 <quic_omprsing@quicinc.com>,
        Bjorn Andersson <quic_bjorande@quicinc.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        linux-arm-msm@vger.kernel.org, Olivia Mackall <olivia@selenic.com>,
        stable@vger.kernel.org
References: <20260530020332.143058-1-ebiggers@kernel.org>
 <20260530020332.143058-2-ebiggers@kernel.org>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260530020332.143058-2-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=I4JVgtgg c=1 sm=1 tr=0 ts=6a2675ae cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=-B5nq69xhfM--Ug7SGMA:9 a=QEXdDO2ut3YA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-ORIG-GUID: KMYzhIS8YShVAfE2UUYDd6hTucxmslH7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA4MDA3MiBTYWx0ZWRfX95qIqZOAes/C
 m5h9WK1U6OFfkakk+UJE8L9m20dtyU8WqlxX9vFfQwkyv6n3A60uWI9JFa+lFlqNCBIaD04Wo5g
 FqouqZ8euQM96m0csITkzsXa+tU33bymKR2GcsjynK+Kk62eqpI2PLpNUMoWlWkZzkQ9gZUh5Ek
 SEpD1nYz1k703oqFGxUZeFaUuiB6vn+0WLIdNaDq6J6gD/gvhG6wOmaSOhKPu+00NuiynrOgohY
 h9w4s/ibtO012aDi4rf0LnEwkQm6tgiq81RuarnI0p+Sb7EFAhRvDOmZHidtHUBBcor/ao1vxwc
 avVFB+SnGVMzwXW+raunqnXMRqdX2GJVKKcq3+PihPKo5IH8eyr+NnnUDlSF6uZLUX4BvTYsXHi
 Nsc4MGNnG8mUgtl8JDbP7698GYCFBRZAQxVSwKz16Pt4bdi/BI/7fnTht4Ox0QPw9a7d4qa9xPA
 LUskMfl1TULlJCqzMMg==
X-Proofpoint-GUID: KMYzhIS8YShVAfE2UUYDd6hTucxmslH7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-08_02,2026-06-05_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 impostorscore=0 malwarescore=0 priorityscore=1501
 bulkscore=0 phishscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606080072

On 5/30/26 4:03 AM, Eric Biggers wrote:
> Fix qcom-rng.c to enable the clock before accessing the hardware.
> 
> Fixes: f29cd5bb64c2 ("crypto: qcom-rng - Add hw_random interface support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
