Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C8330FF2F
	for <linux-crypto@vger.kernel.org>; Mon,  1 Dec 2025 13:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764594221; cv=none; b=bqTe5GBEVOCslIcuDRSHYjfKg4I8DrF4r99t2qTpFMVxdx/MNvrrwwZ0ltGxundyeRE9qtC/tMghDuQJ44BFNHWDZvIYWv8aml6FGV9SMsYCcYqbuTZPQkhHv0x1qu+u2WWXubTqi+LFN4sSnm3tW4BcgguY/BdH/1F0sFnocA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764594221; c=relaxed/simple;
	bh=mQiRzhVPiTBI5fhfG5QlYmYGwxQKVPYJzIQfa/KT8TY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ch6I0J+avuhYeOfrOefdhCX3HIbHqMUnN/PFUsBOBHyB2z9fjzBVwh361+RVNmloCWENVDi00dcu66qHSTYTEHH67ruUGPxlTG2shq8z1D93B5Pizkr2ah+N6aqMWqKMVEPvBvTXjXNROILnAAtJFX3y0UZWXG+wOdgZtS47JiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=KDGZCW8g; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=WE9/hG1l; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="KDGZCW8g";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="WE9/hG1l"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B19a7T5452066
	for <linux-crypto@vger.kernel.org>; Mon, 1 Dec 2025 13:03:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Ctg+o1lzozlYykOwrPvWfRQts5DzAQREjfwDpCaJEFg=; b=KDGZCW8gOwA5z+dU
	7p+aW47KzL7MlgizscFE3966je9YM+dpKsgar8MEH4sqByEgwL1+J9jrLXceq7eq
	TJyhdYKf6ye20fCWdgnOBcNlFGwctx3HiccJhjUkRyJt+KIm0lCS7wAIvbHeP6bh
	/Pa7jVeOs06DEfVzCkrsO13MIyQFBguVgVdkliy/098XcPRVkPHHAYxFmE/B6GVM
	t13lR+epDg0uX8tjgzql64RjdN73HxOp8jPvCw4sa1f9pM3hytFoT5xKqAHdLfGQ
	bTasuVEGwpElWGthBheU5BKFllo6tc1TJmeflm2de/0jH1KQQvlO1Sx/9h5qYmlb
	BBOhCg==
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com [74.125.224.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4as8herhxe-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 01 Dec 2025 13:03:36 +0000 (GMT)
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-63fb6a61e8eso806264d50.3
        for <linux-crypto@vger.kernel.org>; Mon, 01 Dec 2025 05:03:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1764594215; x=1765199015; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ctg+o1lzozlYykOwrPvWfRQts5DzAQREjfwDpCaJEFg=;
        b=WE9/hG1l8o1rVTSvsMTs+LqD5jLoS2EOO8y7/gz03w6xBH1W6VVVhxfjfCcdzZYeyj
         Ua6EhknfVA9o5dZ5USSeqitz7VUgp268rw0E3j+kXs6sc8Bn9h/blDv3WzUy4CtC9WRh
         HMmd8kXVoUj+gxzF8uSJvO3D9XKiTvfIcScVKiuliS3YZ0T85QWUWB3er6B7pF2zLPwJ
         Wll3ZJtNogLWBd53SbwD57q/vgv90W4dXZRVfuzU5U71wVkyX+dyQcCtGfKNCamzksyh
         eVDe3de6TKZFYkwU1agaAlWgwHcEP8DszR+KNcye5AhENjBIN2rqrgCF8nFO6JSAvm6S
         bVhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764594215; x=1765199015;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ctg+o1lzozlYykOwrPvWfRQts5DzAQREjfwDpCaJEFg=;
        b=auE0wIKRp9JE4WBBJio26DC9TjwebkKuZJV1QQjyqWdb+yM1I28CKEf9B9//pOV1vs
         36dn81i3n8D9e5Vluh7qFxHBr8GrJgke95IPxcoebzEJUd/0gg8sI1JPz2wvOtsENtd0
         SJx16YxvlQblc5MQn78UbmKjMmsxWTRoTsujuSpXtriDjnZoRlJKD3QKV7Tce0RIuZSN
         0mhio0/zm09La5vmNcJuDVM4XuT8/En+eBiq7D1C50535XNYRQOVoGzCXCaNkhb5M8ZI
         L6iRA0kS9l/RVfdVgTL+YEE/jbgs1Rstc/oOFyoeP5312iDr/YTzdfT24CKjMnqcScoB
         bBQw==
X-Forwarded-Encrypted: i=1; AJvYcCWhhz2ddPURguns3LHBlxF3oivaZpO6huWKuu51Txux+acE3NHreP102qm1QfpRwfN2siSmWOGxbY8gfAE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/RQS9X2cJnlHDhonPbyyh3nNCl8UplaO0/42fohgLvts+aU0V
	ItaTBdHw/ydK2uxSiNm0lnYMrWw3PYmXaS2V7ha/TF0DEkI8TGrK6zbt1ugmBgsa13ss2acKRgM
	8Inbytlv8inllopl9b8wsSPyqz2xvmPw4A/6Kwqy/lA/xkAFD3DaziQv8WMMGQRKqw1lglE6EH2
	U=
X-Gm-Gg: ASbGncte0NT9kvqadUnyMWdOaT4S3kZvxVnDnw7Hbhq0JbZ1t9K7dfoMaDWHMtQ2GSc
	jmpudWnNNzwjApKDxy7mO70tbIVYmc3U7EKZFW/bpSECdl+S2eaW8Fgq0UjZYU4vgq/8PfoBh7Z
	LLNB6/NSRUMVG0AiFID69Jyf7bV52WsAXpbuLw1e5+gg10MxvEWRC81QkLG9c9FlVLma5OWjCMm
	vCXMbmrYnp/F6PugfTfhkjLHnqNVpTsu22FtjDCfI/4mVY0aMOQUUudxdjPautY6QhmL87nYF5g
	sqS7BngupHLeEqwcvWG6FJ5u4mWyRzAPKX4eAq92wpaKjxOREqWwjtBl0gZjN4XwoNcsdpvNkVe
	Gj2yKyIe2Sd569V0B3Y8xkHbIDTgulg4NWlcECwmZspbNFelaKaxDFbKZ/c3sTAxATMU=
X-Received: by 2002:a05:690e:154d:10b0:640:d0e9:1d7f with SMTP id 956f58d0204a3-64302b44480mr18940965d50.3.1764594215404;
        Mon, 01 Dec 2025 05:03:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFqMXMDUrIWgkKWxZqcL0dH0seGl1iVMJGPq0rXLF1jLMt1txAJQwrRO9ii3mNBnFaFb49pNg==
X-Received: by 2002:a05:690e:154d:10b0:640:d0e9:1d7f with SMTP id 956f58d0204a3-64302b44480mr18940933d50.3.1764594214730;
        Mon, 01 Dec 2025 05:03:34 -0800 (PST)
Received: from [192.168.119.202] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64751062709sm12436798a12.35.2025.12.01.05.03.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Dec 2025 05:03:33 -0800 (PST)
Message-ID: <c15e156f-fd11-4d38-98c0-f89b78044407@oss.qualcomm.com>
Date: Mon, 1 Dec 2025 14:03:31 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 10/11] crypto: qce - Add support for BAM locking
To: Bartosz Golaszewski <brgl@bgdev.pl>, Vinod Koul <vkoul@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Udit Tiwari <quic_utiwari@quicinc.com>,
        Daniel Perez-Zoghbi <dperezzo@quicinc.com>,
        Md Sadre Alam <mdalam@qti.qualcomm.com>,
        Dmitry Baryshkov <lumag@kernel.org>
Cc: dmaengine@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
References: <20251128-qcom-qce-cmd-descr-v9-0-9a5f72b89722@linaro.org>
 <20251128-qcom-qce-cmd-descr-v9-10-9a5f72b89722@linaro.org>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20251128-qcom-qce-cmd-descr-v9-10-9a5f72b89722@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=LewxKzfi c=1 sm=1 tr=0 ts=692d9228 cx=c_pps
 a=ngMg22mHWrP7m7pwYf9JkA==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=KKAkSRfTAAAA:8 a=SbnQZzZDCDfwX-qd_CgA:9
 a=QEXdDO2ut3YA:10 a=yHXA93iunegOHmWoMUFd:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: v627OVy7udIk7BP8h3Aeaq9Zcxv22agF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAxMDEwNiBTYWx0ZWRfXyqA7Z71rqk45
 UmnVfm4gruotX4rGa1u+/2/uWOUXucDZMtJMfMsYntHvdb1++H0zdg/5O/bHRlinf0coGEpNn4e
 9H+0thUvSqFPAmbFX6x2Q0BarLBKHFYi1xxThb0Z4bsbfxVdgse9kr8vklph0VWV3QFQiJk00ti
 /oAVqthMRghLy/wpvjBebNqJ3ErSXqau+Wza3P6IHLYea/sT+S7FO2Xvg8VFTmAnO51dXCpi/JB
 vsNQAd6EyqKGaFp54LhCIBKUyZAPXOXs62kuTLpQhSKlkkfBW0RHIHMITQ1dpUbKCuT4l3eqaVO
 SrjK0aJ7VwVVQ/FcQq+LI8uCeanZ2Yo2OfRPUMSVuwEBm9jqAXYhcqjhfNfvkaKRSgmnXhXn6YM
 Dz6osuAWgOjRvzK/6jxlNPFc5KPU8A==
X-Proofpoint-ORIG-GUID: v627OVy7udIk7BP8h3Aeaq9Zcxv22agF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 suspectscore=0 bulkscore=0 malwarescore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2510240001
 definitions=main-2512010106

On 11/28/25 12:44 PM, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> Implement the infrastructure for using the new DMA controller lock/unlock
> feature of the BAM driver. No functional change for now.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> ---
>  drivers/crypto/qce/common.c | 18 ++++++++++++++++++
>  drivers/crypto/qce/dma.c    | 39 ++++++++++++++++++++++++++++++++++-----
>  drivers/crypto/qce/dma.h    |  4 ++++
>  3 files changed, 56 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/crypto/qce/common.c b/drivers/crypto/qce/common.c
> index 04253a8d33409a2a51db527435d09ae85a7880af..74756c222fed6d0298eb6c957ed15b8b7083b72f 100644
> --- a/drivers/crypto/qce/common.c
> +++ b/drivers/crypto/qce/common.c
> @@ -593,3 +593,21 @@ void qce_get_version(struct qce_device *qce, u32 *major, u32 *minor, u32 *step)
>  	*minor = (val & CORE_MINOR_REV_MASK) >> CORE_MINOR_REV_SHIFT;
>  	*step = (val & CORE_STEP_REV_MASK) >> CORE_STEP_REV_SHIFT;
>  }
> +
> +int qce_bam_lock(struct qce_device *qce)
> +{
> +	qce_clear_bam_transaction(qce);
> +	/* Dummy write to acquire the lock on the BAM pipe. */
> +	qce_write(qce, REG_AUTH_SEG_CFG, 0);

This works because qce_bam_lock() isn't used in a place where the state
of this register matters which isn't obvious.. but I'm not sure there's
a much better one to use in its place

Wonder if we could use the VERSION one (base+0x0) - although it's supposed
to be read-only, but at the same time I don't think that matters much for
the BAM engine

Konrad
