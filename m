Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388D847C107
	for <linux-crypto@vger.kernel.org>; Wed, 23 Sep 2026 09:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790154849; cv=none; b=o1la0HdKfGbn1eWPFmB5gjHiSpPR7yj1R/yCb3Fv7cBHLYhgHug1HfvV0haLY8qp9MeJssHkXB9LFw1xS4BRLE4TrPCwysuBiAEPPcMdCJLvlZSJOHpmk2QSoW26SOOlRUeF7olfaoQUxjAf3iarVa89zce1xdAlN39euniaDmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790154849; c=relaxed/simple;
	bh=GmHvoTmS+qmcicI5zLev8OjVf3pQOvJkoRhV19kiIM8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hdb0ro9Ga9ImMsJjXWGtWjO1MQt6szynOOwn3RA0Mj/jhLsH8yi3/1ojcmcslPVvvhfZNZ86IvsOnP72jOZ/jvEo07FsaaPw1zQWZm3M9Faxm4aBSXYI6zEOsMM05PWTzoQsDElUw/BJ3OA9qDxE7RZi/E9lEmzOvFUDcNtgZww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=A40Ok8Aw; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=TuALyoN2; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="A40Ok8Aw";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="TuALyoN2"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68N8JegJ3178081
	for <linux-crypto@vger.kernel.org>; Wed, 23 Sep 2026 09:14:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	mV/gojTVmImKJZBOpC9s0FdYNTfJGxjHgrYf43x+M0Y=; b=A40Ok8AwRaKC9w11
	n2SO8xlP+PGzlB9ZLgRSgTrzACaV4xim6erL7C1YtmK8VrepFEzHKBjf+pHGGwNo
	J/M/7v5lWvo8Wg+fl2HGrqE+tYKgAP5Gblm7PlwrEuWToxWdGAKcLPy0pgX6ujqk
	6Rguh63qxor+yU4w3D+2ED+Pnzhp5Q5O2uucFk/Qo8uKwjI49s0o1hJEN+WLantb
	jBjc8MVNlQOQlC3rxoNoOz7X8XQD73zWaWV5cNqElWYiawfdvvvLUGM/lWeUG7by
	PsiQ4XHpE0pmDc7kktKLqtHxQwtt2n4qtoHBdOZaRO/s4iqYc/92gMCWHwPK8dL7
	Zf+uxw==
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gux863jdp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 23 Sep 2026 09:14:07 +0000 (GMT)
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-9106bb33cdfso1643756d6.2
        for <linux-crypto@vger.kernel.org>; Wed, 23 Sep 2026 02:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790154846; x=1790759646; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mV/gojTVmImKJZBOpC9s0FdYNTfJGxjHgrYf43x+M0Y=;
        b=TuALyoN2REifA/6qdks1JwAPWAPQ/pIYBrOV8U0Vnhs86sCStwqLMVkOAx+9LDbr8y
         hr0rXMC0jkNYRQsTGJefO4SsUcqpPM2mbg9UZWm92nHtiq3q3/DGha5ZYa9jIo9nPVfj
         fanKexmhgvOzapy2JDLz1I18IPqfffBcSR/3kZnf1vjUPm+S48s9tvAmxkiJ7nuTziZ6
         SSD+cyAnal8/t9R0WW94puiv3KBrjhSNM5zxPpNyi23vvEh3Ml/lSoTgh+8WjGbRz4gz
         HxKEj0iKBC/z3rKkJEGgKfl90F2fi10t0RGcSUdP7ABWZAupTZO8uC+nv+dIPCNx/hYK
         2g9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790154846; x=1790759646;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mV/gojTVmImKJZBOpC9s0FdYNTfJGxjHgrYf43x+M0Y=;
        b=V/6Yk992l5voscR7ds3iblTnC0WsL47xUzZjC1GWSIS/XwiX8dEkP8fJ31yzUPUFo2
         qJ8djH0o3CKsZFNl5onfvmzibV4iRo0CNIl591P2Suh2pDnSxfsHyLlJP9Jl1F5Dno4B
         kzTvqAi30tVYl0xTMQqZqVRg0KNl9R+AoXRpFlUNB8xqPgb5Wa3Cu3eerCVxAjZARwc7
         DZGBCinCp7t8MRYAWvfZ4woB13vm/vsdpjt/eQ6yssxXzeKlVysHL1WnKVDgclmay5Dd
         A7HlYgFDSFj8v9PzqMfIu8hzYYdnbyKkswzpqTklCgC0Fm62Uu4VMTBgwjcPs0/BGuGE
         NhoQ==
X-Gm-Message-State: AFuF++mo5ulg440BGdpvrYo6sUDIdOmHdXkSgu155PC9XlvPJ3wH4VFX
	LYdSzcFHZyEeUPja7OXBC6a1ItTeg7O7rySiIgXxUq97KGxiiNXpWtXnEQpnf2jaCdAKCbBoCth
	hx6cNjeENfu09RfsvyaVFocsl+qmH9IY8jxpqIWWf8mWItp4sr+nHSIjNj19dJNrmm3E=
X-Gm-Gg: AYBFou1KqefgH6yGvdRbcoFmalDxDA3ykaotVz//JqCvVpbHBGmHpOevXIlBdTnqIRm
	sc1lnRiTYjNpPOm7uGIkXyK945RvCTMbqh37oKLy25xpi8BZ1yTneaZ9aEU7VTqJwoLXgbJ2M3M
	PQC2LCgjRVZSEi7K/k7U79Hab8epTmx73547NVw95irCM2kqxUSMSPTOeOwXBzV4u9Rv8gL7H0H
	7EZSb8wsX9LIxqHplJqvF1aMo7XNEVjTqB7ysgPmMYxdf4ZX7j+5YUTZzc66CbQTy1OeVg9bph9
	23lLX8a0i48LWBPPL9p9ydX/p5HviioZcghCLyKA1VVC8Z7392zlQO8To8R5lovTSSWi+wTUV29
	jDWsZF0qkU4j76czTHMBpdQ==
X-Received: by 2002:a05:6214:1307:b0:90e:8d21:714 with SMTP id 6a1803df08f44-9140c3d4acdmr34671236d6.2.1790154846484;
        Wed, 23 Sep 2026 02:14:06 -0700 (PDT)
X-Received: by 2002:a05:6214:1307:b0:90e:8d21:714 with SMTP id 6a1803df08f44-9140c3d4acdmr34671086d6.2.1790154846102;
        Wed, 23 Sep 2026 02:14:06 -0700 (PDT)
Received: from [192.168.202.12] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6aab37eadd4sm1201464a12.1.2026.09.23.02.14.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2026 02:14:05 -0700 (PDT)
Message-ID: <0d04e028-39e1-4798-a0a1-22997e2b1499@oss.qualcomm.com>
Date: Wed, 23 Sep 2026 11:14:02 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 14/14] arm: multi_v7_defconfig: enable the Qualcomm
 Crypto Engine core driver
To: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Eneas U de Queiroz <cotequeiroz@gmail.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Demi Marie Obenour <demiobenour@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Russell King
 <linux@armlinux.org.uk>, Abel Vesa <abelvesa@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, brgl@kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <20260922-qce-fix-self-tests-v9-0-b1aa742e79af@oss.qualcomm.com>
 <20260922-qce-fix-self-tests-v9-14-b1aa742e79af@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260922-qce-fix-self-tests-v9-14-b1aa742e79af@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: LXeziF7FGikcaeHJoFzXyXyHjrYsFF6h
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIzMDAzNiBTYWx0ZWRfXycSd6/GeDVUc
 /VjMD3zlG4K+seN6PYi73+/Ri9WsEsuiK8JDurkehueUSxrj+W/ehnK8G7fmKRtMiJ2fgP3d33v
 V3hnaT7u01M4E2b8nhUkh7tFG6jglhk=
X-Proofpoint-ORIG-GUID: LXeziF7FGikcaeHJoFzXyXyHjrYsFF6h
X-Authority-Analysis: v=2.4 cv=eIOGH3p1 c=1 sm=1 tr=0 ts=6ab3985f cx=c_pps
 a=wEM5vcRIz55oU/E2lInRtA==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=pb4zj8aKiTCSHAFuSYYA:9 a=QEXdDO2ut3YA:10
 a=OIgjcC2v60KrkQgK7BGD:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIzMDAzNiBTYWx0ZWRfX4ipN90xprAaB
 jlk0InOus1lOqKw86qm3hGv7n21NliEjsAoWbSmLIgRVyThO8562ey4+rBi5RsHVR7l2iYxklGs
 7zdzuTFbAVM6ulQ+T0gMKQk8s0y4eWjp52p8vI9ohv1sjc9StrF4COPzNHay0QWrlrc1fdWky9N
 eUkyKgjJPhLo7W4aDRKc0HgleQkz71ZdCs6N9vxKN3tmZMwltXxHZ7qWwvdifhGwX3iI9iUT296
 ZWmzWrgUJeKLm+UUUgdDXMfff1nUucX6a2qrXFvELwbAG1A3BQTtlIQGj1DEIjpNbpjUKDWgAGn
 8bHcWe10SwhMK2MbUOFpEcCDKVJa3ODDM8ikIv1GlmSwIKFrZrGqTztiG5Pv6/F4ww0o3Va5U3d
 VmvovzXk5RnzzmiDdL+2R5pe60GpQnbnpma8uGumxrrZX8j4Pqf2zPtBS2eInxwXl3uUMCrhZrh
 7u34I50drS6Y2MmsTew==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-23_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 phishscore=0 clxscore=1015 priorityscore=1501 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609230036

On 9/22/26 2:57 PM, Bartosz Golaszewski wrote:
> The QCE core driver should be enabled by default as it binds to the qce
> device node and scales down the interconnects if no child auxiliary
> driver is using the IP. Add it to the multi_v7_defconfig. Disable the
> crypto part of the driver by default.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
