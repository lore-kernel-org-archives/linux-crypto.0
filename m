Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD942E543B
	for <linux-crypto@vger.kernel.org>; Mon, 27 Oct 2025 08:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761553660; cv=none; b=Cnj6h6KJpWZ26ZyISLA7jngJ9vaU8yECipGqEztWAQ5KQiQCCc+QJSfPllA4p7NlERywe1NIJyvsQRcXgcr6/CIPowWi8gnsZMXaCrG5fJIPFw0ySWikvzpUTGfrPWT/nj3czumR0POCiGQftTl/8D71KbtiTwOAAFARLNMAKJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761553660; c=relaxed/simple;
	bh=SD7mFn3Azck8G6ddO0hF8piSL6ovIEwmDhL2dXByvlY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RGa1d44p5XTj4jRgyX/rFQtqdGmBAqLs7LmyjjQ5wd77+YbVvVIufVrBFW+jdhC7zuXPmGo4CwgEuVTePkm0LOuD4E+U4qrTxxEYS4ECgwnoGIEvLF4YxjTi8dcJyujTrHbnHHy2Vu0eTN/Xh+brVZmcJulEX2qQCH0diRiXleg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=nWLQY8qL; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="nWLQY8qL"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59R3H9ls1503208
	for <linux-crypto@vger.kernel.org>; Mon, 27 Oct 2025 08:27:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	fYQEo6dIiW98w97foyLVsGnKPCs4nvCityw2Go+JiO4=; b=nWLQY8qLLmuxGDnr
	JIHJrWvauWSgETYrqhPtZC9vlMFGI6Hj8lrQI/7dtlO60JPNh+ijJsR/e1ulqhiz
	uqOPzMCisa6glDP4LDE6CXa5TJV3S/dDgbbtv9n08XHmMxnCVXtMU8NfGLPHhu+t
	fZwDw3zJwb5rxLIW/RQGGn8m+12C5wIqhdP12V9i1m+hklhlc+FL1bWSZLgl7BxH
	4fcrkhERtG7O0dXUoBZstWZMZCGDNo4OtONZedvYnMLo4SYaq85ZParz+dhTB9zR
	aoOk78+nK/wM0pWBYCYJiru/L6TemfQxBMD0JMmnOiCsqrEZWW2lGLQ0uzMkx0nw
	spg2Gg==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4a20pnrsb1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 27 Oct 2025 08:27:38 +0000 (GMT)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-87c103b902dso11528986d6.1
        for <linux-crypto@vger.kernel.org>; Mon, 27 Oct 2025 01:27:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761553658; x=1762158458;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fYQEo6dIiW98w97foyLVsGnKPCs4nvCityw2Go+JiO4=;
        b=kBUSOwRgc/5HmeO92D9aI/Gt/RZh8/J2DuxXIxjy15DnY4ln3Lo45pEYJTwH+rc2Xl
         pVra74+Dj0Mg+rXp6d3+L8P4lfJ3ThchZqmTvNnKrei6C2o8mtjmcI56+xP2i02/7rcG
         So77ZCVfjsGDK7x8ydaOEu5xfJToB7d1YpU7jIGEAD10f01zJ8mjkfSDPBlhHCgin1U4
         RYbli/UCvKvkHX+XzdmSnZ4VYJ6K0XIevxFFL6+SvCFrgXx4OZGYuRVoYbLmGyDA7+EU
         +W3cuolOje9qXOmcI6SCpiK/Hfj5Cwx30MHjIrNtxTeEIvmfWIEL7uK+SSOPk+xgKrNn
         O6NA==
X-Gm-Message-State: AOJu0Ywm6f3hpWLk12n2TVY9irnw16dnvKEXTA8NAYmMvJM3w2zbyUXd
	EVEVZp4WDnVEa4KnKlnqPzbUQeFr1YLQCf3uVtMS2QUzI/QJu4eDgs9oUgRnsWLdmy9lbFXyHq4
	hhE+U36Y3CEfgxDe72/Zm9koiZexQ3PlAVs1olx3gJCK7p809eHxyNPlLid043yfZ1sE=
X-Gm-Gg: ASbGncvDjOgmjYvzIdtYeyzudUM44Bz6yo2OmRVVHcb4S8BVM3IGkm+wrXMfai39twe
	+MTmgUPU5bRdJC1GGWbbkutAhmQE9sfHmJyIEwJ615uQUv3zAvuKmwad1aVQxNnwD5E4NcnPkKs
	ZDHFto1fnrBePh+bWx6XdcPRoYHFrWGguvXMlyx/D+w5Pn5JSJXIsh8JepOnsnIb6UgIf3ZLyQO
	rg2tb3ziBUlnVEjqDDEfyWl5bxYPgEeZ7EMxkc3H7VIsUJT1fbzrxwmWSi6nVqr+pWXvhLAQOkp
	qUybpC8YjIk+lKxZO8JGsq+fOBa/H+pdN+gthX8Am9Z2zUOix9cFpETQfkA/ZQ1BFBkzsaNzbqM
	Tvip1COfGbbNwTKMDIyi1/FZn0svjd0qYOIp+qNd85bruaCXKsRzuRMiI
X-Received: by 2002:a05:6214:19c6:b0:87d:f8d3:2456 with SMTP id 6a1803df08f44-87df8d324a4mr156569886d6.2.1761553657626;
        Mon, 27 Oct 2025 01:27:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEw4iXYcaTwz3Rp3bM1QNtADojUTF4L8DQ6lROhsJhLze0SnEaWSmqFqR5f8Qej1VLUJuyOjw==
X-Received: by 2002:a05:6214:19c6:b0:87d:f8d3:2456 with SMTP id 6a1803df08f44-87df8d324a4mr156569726d6.2.1761553657204;
        Mon, 27 Oct 2025 01:27:37 -0700 (PDT)
Received: from [192.168.119.202] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b6d853fb3bdsm695248266b.52.2025.10.27.01.27.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 01:27:36 -0700 (PDT)
Message-ID: <b622f606-e9c7-40b5-b05d-4f011a98faa5@oss.qualcomm.com>
Date: Mon, 27 Oct 2025 09:27:35 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: qce: Provide dev_err_probe() status on DMA
 failure
To: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20251024-qce-dma-err-probe-v1-1-03de2477bb5c@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20251024-qce-dma-err-probe-v1-1-03de2477bb5c@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: _-8UCgw2Uxnzg4eZc0-a6QcRYwQXi4-q
X-Proofpoint-ORIG-GUID: _-8UCgw2Uxnzg4eZc0-a6QcRYwQXi4-q
X-Authority-Analysis: v=2.4 cv=A+xh/qWG c=1 sm=1 tr=0 ts=68ff2cfa cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EUspDBNiAAAA:8 a=25NbGeS3ZlacgUnTFUcA:9 a=QEXdDO2ut3YA:10
 a=OIgjcC2v60KrkQgK7BGD:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI3MDA3NyBTYWx0ZWRfX0omG5t4yPk+T
 mCU7xOFDZZkIvcuVwddqapNOc1pVmEEwoe0BaRDEFq1ix4wdu/hsej6uod137qFCQThnH/LgJxN
 gmthbFhG669AYaHY3QataWwoI2nc+WBsS5tg/9Jdu9hyeKNo4ZTJfxukonb4lcw/xY/LzBQCMle
 DU3+bRh0AizHwnnLFPPqc4waQFM2xbSjvFs/09Ef3ljjAwxLIYylDuHrBSixHrz9haHXXhrg+L2
 vdqCxQAMxZwXPB3s5m/j8y6O6Woo4MM8hHU+erszk/ru6H9hCkQcr1Zoikpw79hKxcgBSbuJZGA
 W3QiCPLc0otkNsYY/Yw9I5vBcp1hBK4TdBvCKP9SePNX1gX8Ark6AXsg7iq259tH6ZWY6+CdjQQ
 Iv+K3HtxuuwbiSpr8DvJxfoWmSu6GA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-27_04,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 suspectscore=0
 spamscore=0 bulkscore=0 adultscore=0 impostorscore=0 phishscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2510020000
 definitions=main-2510270077

On 10/24/25 11:35 PM, Bjorn Andersson wrote:
> On multiple occasions the qce device have shown up in devices_deferred,
> without the explanation that this came from the failure to acquire the
> DMA channels from the associated BAM.
> 
> Use dev_err_probe() to associate this context with the failure to faster
> pinpoint the culprit when this happens in the future.
> 
> Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
