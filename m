Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792659889;
	b=Q6yqOdgQvLzKSMlF/A+3Jt2Vv6N2tmg3k//awfWN/hS8MCIFYehuYEuUjWwgw/tA7Jvo
	 7D99Z9Ca5zRIQIhcQx9ytCJPqiPNdPpUr+fZlpY2K3nmF+pNIuzuLLmuYOtdweyZHVAfR
	 kPtJikDaO2bcZy6j0Dvv1A8gJ8EF9nFJDPv+hm4hyh0h1Cslr7C3IGdyvgUPYFZhJoCLI
	 VrleL4iznKQbpnWtVEsPNWvMh+TNlXMBl6WonD/AW9Q2X6WzAvWAsX3uHpO1Z1jiVn/fX
	 u1WAdR60fNKQ07a1mpxhXMm/Bs9g2WlBJz/ptoiGNBYbXZfy+9aJW+cZ4CnRedelRww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792659889;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=D0SnzBaUgKaKCBmz+EoWBqVmXukamKFPd93LngtNdqQ=;
	b=B2NuyMV3JMfw1CzIJFWOydppE4vSSGnry4eUX74SQcmlyJhtGISpEijmDws6i7IZe3Ve
	 rNzePzTNKgsYiGRBuWydBUmiSj5eb1TSErLhdFhlbtFNq4OVjvsHKbz1oBrVe4rs06+22
	 ayKXTL+7wisnRQKDnFQ+jMhFJOv0MTKOm2wLNnEXoGEPsOy4WitwxRRlWNR50kV63cZLz
	 atTa3JgDRnA+1feE4rMJ5vf5OCNdr3Eb6FhFgrSvLhWESs4mI7P6IBdUJaTg9UiYzWOeJ
	 JqCf0aKpI8G+aja+eaTrqMtsIDeV2ZX3a9LET1JUaaHsodfGOVGFy55o5y76xVOJzQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=QEbChZoX;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=MPP3IIuE;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61761606A32E
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 09:04:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 61761606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=QEbChZoX;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=MPP3IIuE
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69M8LnIV3194722
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 09:04:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	D0SnzBaUgKaKCBmz+EoWBqVmXukamKFPd93LngtNdqQ=; b=QEbChZoXe8SUQilQ
	v1DuEY5ECmVDOGhoRCzNdIMh1N/Ryw3mScFCEO4OAfzCVJg2H/Eg486DW1hyHz21
	0I4WgaeTiQq140nHo2pObmyJJLDzs0u6PQW6oOA758cus8KQJIO7yOiNej/0gNQw
	h6VoFPyBWUlrnTCwMxjKua9/+RfFvDDGITtAwqe1YgzerP7TtaXdLNOkeRnl3LkJ
	ZlRJaAouwQSY4pJCYRrGG5rulR1rKvligTj8SUKbgxnDqRaC8J7ext4KxptOTpHk
	TN8D8uaWbFlpq2F5um8vn3EmbsS2AicPl8ez9B/bGZOJ7C3E4AYur/WHbBXX5hWX
	6Q76NA==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hfewq0716-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 09:04:48 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93ea8a9cfe6so43789985a.2
        for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 02:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792659888; x=1793264688; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=D0SnzBaUgKaKCBmz+EoWBqVmXukamKFPd93LngtNdqQ=;
        b=MPP3IIuExSnL9EUYNbx32OLPP3d092SqUqiOOPWCXf8W3aoQixWjKmSOxOtzZzbjiq
         QLlWgfGy57rZq6bN84sRAUIkQSkkb2VFVHPyCo2f2SXi9MjYTka47NPEGOUlm7aRPRz/
         w110HqHoXDq3jUqqhZkYUZ7FKmuLWU1FL/kM9ZpdurJWnjEBZs3LHF/ie++l9D17q4BW
         T6dUle7C4wE5tCNm6mlaR6GefB+dpDtFI+ITvyPL7xvFnMH3QrZjL7OB97T1SqIx1bu0
         Hra2vsmdylKwmF+gKbCMp3szY5jw5mBf/TXa+ay6eyCk0yF3vAQpA2IDhQ2P6/4IkWhB
         MKgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792659888; x=1793264688;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=D0SnzBaUgKaKCBmz+EoWBqVmXukamKFPd93LngtNdqQ=;
        b=byhJESG5ACdEHML3i2nfLQdSdSlEg2iUUBHGGktrl+8LmDpjrdRuIDH3wJkxditJR9
         2m+8/HoctWdan8pQUdq83kEkwsv1WwySAveddyDqzhGMRI7RxUeFnYmRKX54XiZYi7fP
         MpQGVIQEP9Tpp9Xr+ncFqwbu0zau7q5kXFIgdm/7z39q87LH4vrCotkVrt6EkyQ39lOZ
         sLfmPY3UWgDKX+tQHlwbtTN/b7QghATTg9Bwansvdj/7aU4FbDsU3RVRIkc6WweDSLLf
         KerRhmKA2Zz8wM8wrvCiuJYJJRvKodb9wMII4WQftKsjIx6zdjmS26F+02I+89UWkfmJ
         GM4A==
X-Gm-Message-State: AFq9FYImLEodqfqBmV+W2iiJHR/n+aTsrEn8gm1JYUelvUNL8KuqgEjQ
	vaMbl3AMBcpXMlgbdyPubl/qeUhsN8X8tcadS2JPRBp33IzaumuCoiAHRXL7BbecPKTHPvXDPXk
	vQRSyIyLOdFM8IVbhw5VDUwmjyAOjd2GUhnki23k21zLwzXAsCa77VRS6Wd3UsLCceuA=
X-Gm-Gg: AYBFou0enMxQY3tVd83OprMIe7abSwQGEUyucEfAjvwh0Qdw4B4xFhbnzhcls3rOLpP
	YYM4xsv4+E/2qmKrPI8al1ZDjB23BaX9eBkPF7mrJ4t1WRONqhleKMlVn73vAXJIdH1u7GxWhee
	YgdANtAgceNWJ+lPhQbLvYOH7lt0hztjxun124jMQlkN6KdNCOdcdDwxNxjA2qb85K5fTj85yXC
	AbZJJh2KJKYkUjhdZ/eJLEcXyiZTHhCSEOSpJGYWjEK3U+X4GBwwehWTuaf8Rz9iepwZcirNXT2
	XIDbjO0GV3bT+/LRWUsJayn5/IJcKBx04tkUQnD87htn5X/j6VOj9AF5BKnZrhrOgz+qgHXAKQW
	p0/Md48QfPjrJdRPlEMAWwA==
X-Received: by 2002:a05:620a:2b91:b0:93e:e111:2771 with SMTP id af79cd13be357-93f57e9331fmr986295285a.2.1792659887618;
        Thu, 22 Oct 2026 02:04:47 -0700 (PDT)
X-Received: by 2002:a05:620a:2b91:b0:93e:e111:2771 with SMTP id af79cd13be357-93f57e9331fmr986290685a.2.1792659887103;
        Thu, 22 Oct 2026 02:04:47 -0700 (PDT)
Received: from [192.168.226.26] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c468a5e13d2sm81040666b.72.2026.10.22.02.04.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2026 02:04:46 -0700 (PDT)
Message-ID: <39e5f5de-c9bf-4817-b0e6-c598d421feeb@oss.qualcomm.com>
Date: Thu, 22 Oct 2026 11:04:43 +0200
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
Subject: Re: [PATCH v11 2/2] Revert "crypto: qce - Mark QCE as BROKEN"
To: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Bartosz Golaszewski <brgl@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King
 <linux@armlinux.org.uk>,
        Eric Biggers <ebiggers@kernel.org>,
        Demi Marie Obenour <demiobenour@gmail.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Pankaj Patil <pankaj.patil@oss.qualcomm.com>,
        Birk Skyum <birk.skyum@pm.me>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        stable@vger.kernel.org
References: <20261022-qce-fixes-broken-label-v11-0-0d33c34fd0c3@oss.qualcomm.com>
 <20261022-qce-fixes-broken-label-v11-2-0d33c34fd0c3@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20261022-qce-fixes-broken-label-v11-2-0d33c34fd0c3@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: DCDak_hmvYZbguLbBiGah97tKgqVbHXN
X-Proofpoint-ORIG-GUID: DCDak_hmvYZbguLbBiGah97tKgqVbHXN
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIyMDAzNiBTYWx0ZWRfX13uwZRFKW8kq
 Z94uWZJ7Iq1RLLcvdcvpYPEK3JlrRKqOut6lTMoJ/GhsgjAZqbafV4Pj15OI2QRM+Jo8s3zDUfb
 sOtl0Ib3C0zFlp9XCl9aGjQVGOXx8aA=
X-Authority-Analysis: v=2.4 cv=G4OJgNk5 c=1 sm=1 tr=0 ts=6ad9d1b0 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=3IWs9GYwE_XJkEP3BLIA:9 a=QEXdDO2ut3YA:10
 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIyMDAzNiBTYWx0ZWRfX1vfioh+Im+UE
 5lByw6u47G/wya29wEQTgaroG1Wo7zJfRjD3CkFFxf2EblN1tYn3icZQzEW3UUYNt9yYVt5rhSz
 HIwVKlT9JUaHCAfEqLMCBguiCiiLENQc5WaGnMPHbOjoGAI48l2SJFIjzxCTKmeQce+TzkcB/Hw
 DZx4Zjp4Uxa+b8A+y9nj+QrLlhhI6E0gBQmGRklS32SlCtHVxQkaBZ63Pl4/NaiXMGb3sv0bFuq
 wM5/586iUptVnfXm1I26r8lBE+aXK+5jKXBhtWA27yvdLNJXgGpdJrOPWd5h6i1HKMMhaMEnC/p
 te2P+vawtxUma8LFT/99Lc/GOB1GTHEeffwpdxM5/nPu5GcOPpndwD8hqyvtdTGU0h3ehWWy5uF
 3F8Q0bzRCju51yQKEwuCaaYOjQ4dCdh9khfyVawy/HCDaRTUg1PdxpWIyzofR3BtHfNRnVl29LJ
 IMk3KnUYtm1WNmv94LQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-22_03,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 phishscore=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 adultscore=0 malwarescore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610220036

On 10/22/26 10:58 AM, Bartosz Golaszewski wrote:
> The self-tests for this driver have been fixed. The crypto algorithms
> are only registered if the user explicitly requests it with the provided
> module parameter defaulting to false. There's no reason to further keep
> it unbuildable with the BROKEN label so revert commit df373d39c6f0
> ("crypto: qce - Mark QCE as BROKEN").
> 
> While at it: update the Kconfig description by saying this is an
> "offloader" and not an "accelerator".
> 
> Cc: stable@vger.kernel.org
> Fixes: df373d39c6f0 ("crypto: qce - Mark QCE as BROKEN")
> Tested-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
> Tested-by: Pankaj Patil <pankaj.patil@oss.qualcomm.com>
> Tested-by: Birk Skyum <birk.skyum@pm.me> # X1E80100, Lenovo Yoga Slim 7x
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
