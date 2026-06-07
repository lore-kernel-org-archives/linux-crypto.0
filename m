Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E6E2D6E72
	for <linux-crypto@vger.kernel.org>; Sun,  7 Jun 2026 21:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780866264; cv=none; b=ULU2R/boAFw9lqPdfWjVjxrjs944W6PgzzJ6vQW9U//7d0tBOcHZ2Z2WHJMo9KxMQT44W2yEUTyNBzdVOrzAM9P4S9dXFdp5EAfyK0xaMauM7eau6ZnjE3Nk0WGa+vZo8n97fIx9qhKmKMCbF7uh9d9kzJSy88bLuouu0KOg8uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780866264; c=relaxed/simple;
	bh=YFM8Rpcz67toyEPjtzr4xH0TJGazPRywTTpdTkonNU0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=laLluq5WpWSU05PnXRcfISJ/Hdn5YatYWGHA8jdtt0yk1qGRirrQoG4i9EMloK32cnmeXSoQp/3qvXC6TEM1P1ioLfr51GS9MCHCp5Zm0mxecNMx5KEZmhouBQ1g8YaBLA7fvOesdiF0bebnh9fmkwM0+nJkiy0hIcmqa183Wcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=eCrSty12; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Ap/xsJsC; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="eCrSty12";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Ap/xsJsC"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 657IqHTu1377795
	for <linux-crypto@vger.kernel.org>; Sun, 7 Jun 2026 21:04:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=BWZgigx0DvyxZq/E63C/bM6f
	vlHso1VIcFlYQNbtNAw=; b=eCrSty12+SQsC3xarRKCfXECCGpwZH5EsuuJcFml
	HKsDRVRODAmyqTpwzX5AywCWHyLS8ktUHCEA1h1JPudVQgX6P4Qmrl4/++E9YBZ1
	9wSY/A53ZMDNN49QJgo27x+ju9a2WCCjTBIqhKZrp58UJZKSlWu72e68Jdf/THkg
	wNN9FqmecSZfmYRmHLV5n4DG0t+LnFfhIt7prpEvOhw0I6YpszW32ZEAmoqRM2ch
	S+/kpoE9e1Z36CnsZwJj7JMLiWuFd286IlvEXyNIwdHR7fvAPoQN4/mllZqKvef0
	QQe1qwWqukcWi3YNBmCQpyk8NWrNorYg/DAZnJ+9ovzz3g==
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com [209.85.222.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4emaj4w39f-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Sun, 07 Jun 2026 21:04:21 +0000 (GMT)
Received: by mail-ua1-f70.google.com with SMTP id a1e0cc1a2514c-963b744b61cso3677021241.1
        for <linux-crypto@vger.kernel.org>; Sun, 07 Jun 2026 14:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780866261; x=1781471061; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BWZgigx0DvyxZq/E63C/bM6fvlHso1VIcFlYQNbtNAw=;
        b=Ap/xsJsCOkVibOFZfDkvwO1lrnyE+G5LreWsHg32hAX3IXF+0b8eTqfWodOtCkOKxf
         ZTKsO+tJiq1fpyOsFbD5pT+j9tANZiScFcReBDDoOt6NTeWFArcvF749g56mrpc/chSA
         Z45WjBSsQR654A/98hJ6Fv45tm1LBQLaGXouf47LPMbVLdLuoLjrPJsQwbbjnNYrN1tQ
         OqaM8PvpW7SyYcifq8GWMeiIf3uTmp4xrAPA9+CUKMICn/9EPuAwEAllKhLwM28Sg7VN
         KK3wTkpBVwC4KHxkF1EhknhDj0XtwyFoVBn6FkQ4lfrpAutFaHsS8dcVmvvNaXDTfUac
         QM7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780866261; x=1781471061;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BWZgigx0DvyxZq/E63C/bM6fvlHso1VIcFlYQNbtNAw=;
        b=lLIbr2SKAfPbZh8upLQjxJNMLoCO5F+td1eP9vzvy6US8/kQbrRT8D+3Gq3/igmOtE
         at086KOgCzrMDxCowZtaLRoE/GJjJKgqZj+gvRlX/gD2Xfh93rOyoCf2CnMYreWOCX3W
         rhUXfInPDNNnoRWaiFgNH6MJnP3UYJep+uk91V3PAwdA2Zuj6lUAix5I19kNs4XVzG5E
         S++NrnDTqZ1/F+wbJ0ZrXO3R4LoG8yAACA4hNPYsKP/RqI46Ua+igBB00xGdInN+ld7g
         2XFHym0R3NRu4wYRnkSE/6TYozq71MDLwJc3jo0EzdZCRoRF631ObG28CE+CWdvROv35
         J/xw==
X-Gm-Message-State: AOJu0YwlsQKRS6vb1EoBvjoFtbi72nAkNgxZ3BXBn81dL2RklqX+lY1w
	Xar8vH+Jr9dPdVkXUWwueNFeu/qvgLZuSg4bZIVNw4tdzw/aHe+obDhMzVHiPAbca9+xjVBPMCf
	fgF6xGfcQ5BAkvlcKNKnUhQVkjnbSOxKIFflTFyG1wPCPz12Hygp9hJ7dWPFx32bIN3U=
X-Gm-Gg: Acq92OGNRftaZZc0tLMQnSg9QRyDXd8h6i1SullOxgU7CLjPxycotDv5GJWymVBqb6m
	aF+7x5YCaG0Nj/PHBQW9zoOAOVUefTIih2LbFkjZKRqv1+gVi0v5eBfVfQHQnPNeB+SG4jWqnOM
	M6/9rk9u+IrL3/YJ6iu142zFkLSc1HBoZgvrR3PCbfZGu4xgs7oVbWl8a62R047+aFwaQ2Z+XQa
	Uc7QUPb6ImDiUQaKSWRrjLIJTFrCRNySvGIAMttU+Nc3E0s6wlIsHRIiGuwrIo4kiECZSF/kqJi
	0XNUw9n70dUhB/JSH6bJCXhgv9TnHLd/gD32uHYDJCLLx8M2JsCt8xxOzLmS8//MtASi7YA41jZ
	SL+H4rsdNFKzhIsoqMe2x3VfWTI8tV6CBAIm2NEst6RjBDOpW2gaJ4WFUdr/UN1Ry6MgObfQFuK
	TTrUEHSgApfSFbc4owfyQ5wMOMZN0mRRT1UvRMcjIXflJlEg==
X-Received: by 2002:a05:6102:54a9:b0:604:f29d:84be with SMTP id ada2fe7eead31-6fefa60bafamr6097231137.3.1780866261350;
        Sun, 07 Jun 2026 14:04:21 -0700 (PDT)
X-Received: by 2002:a05:6102:54a9:b0:604:f29d:84be with SMTP id ada2fe7eead31-6fefa60bafamr6097222137.3.1780866260951;
        Sun, 07 Jun 2026 14:04:20 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5aa7b992a66sm3238464e87.74.2026.06.07.14.04.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 14:04:19 -0700 (PDT)
Date: Mon, 8 Jun 2026 00:04:14 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Om Prakash Singh <quic_omprsing@quicinc.com>,
        Bjorn Andersson <quic_bjorande@quicinc.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        linux-arm-msm@vger.kernel.org, Olivia Mackall <olivia@selenic.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 3/4] crypto: qcom-rng - Remove crypto_rng interface
Message-ID: <sikqvtj7brxqbyh2k5qyzhvsibkdwhay27hrcdxlb32emkhes2@xbzpqnnek2xh>
References: <20260530020332.143058-1-ebiggers@kernel.org>
 <20260530020332.143058-4-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260530020332.143058-4-ebiggers@kernel.org>
X-Proofpoint-ORIG-GUID: AokGR-8V9AUik6MSIVhKUmAjgKFvObaE
X-Proofpoint-GUID: AokGR-8V9AUik6MSIVhKUmAjgKFvObaE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA3MDIxMiBTYWx0ZWRfX13rOPXkyjqhz
 HjeufUM4CsXe0/X4cKUgebIHVJziEpVYJC1KVzK9+lp+Z+AWME7SPuRtNt6xy668mNsCEeiA7gq
 n8jYAUeU9nwOV+X8S20mlJ0IIQaTLEg36u9+xyH6K4TGYONQBtdCAcR4QwteKOfvvIxtdsFIOrr
 M1WaEYrUfhawszA7F5Pt+M/ooyakgE1oUlLy7Y6GVI1Jms01zwrbirLS4835Tk5QlDGCoJPSOZ0
 +EzMkJ+gW+aHAjhFB4iIkCZUj7voW6cAONHIPYHoPV/GW5A9Yom8Baq5TFIZKD7PUBNdaX4CpcZ
 dYLE3i0sHG6wYRukxQHz14DDMa2upL8t9QUPhK7HGWVDb1Yf9y+B0HPTU8/xvNgicmeGVRQq854
 I+rQ2+aNbJmaQspzMNCw9fiGvsUzHwBLAHF/oDetBWpKOBzOsdTUL44+OhR1PMxS1BUXsByWeDJ
 Y+c64uAuAVAAtXPlZ0Q==
X-Authority-Analysis: v=2.4 cv=TLh1jVla c=1 sm=1 tr=0 ts=6a25dcd6 cx=c_pps
 a=R6oCqFB+Yf/t2GF8e0/dFg==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=3_uRt0xjAAAA:8
 a=VwQbUJbxAAAA:8 a=LubSIuSeZRPZGAbx3RQA:9 a=CjuIK1q_8ugA:10
 a=TD8TdBvy0hsOASGTdmB-:22 a=z1SuboXgGPGzQ8_2mWib:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-07_04,2026-06-05_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 spamscore=0 adultscore=0 clxscore=1015
 phishscore=0 malwarescore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606070212

On Fri, May 29, 2026 at 07:03:31PM -0700, Eric Biggers wrote:
> qcom-rng.c exposes the same hardware through two completely separate
> interfaces, crypto_rng and hwrng.  However, the implementation of this
> is buggy because it permits generation operations from these interfaces
> to run concurrently with each other, accessing the same registers.  That
> is, qcom_rng_generate() synchronizes with itself but not with
> qcom_hwrng_read().  This results in potential repetition of output from
> the RNG, output of non-random values, etc.
> 
> Fortunately, there's actually no point in hardware RNG drivers
> implementing the crypto_rng interface.  It's not actually used by
> anything besides the "rng" algorithm type of AF_ALG, which in turn is
> not actually used in practice.  Other crypto_rng hardware drivers are
> likewise being phased out, leaving just the hwrng support.

It looks like Debian codebase knows about exactly two users of "rng":
kernel itself and stress-ng:

https://codesearch.debian.net/search?q=.salg_type.*%22rng%22&literal=0


> Thus, remove it to simplify the code and avoid conflict (and confusion)
> with the hwrng interface which is the one that actually matters.
> 
> Note that while this means the driver stops supporting "qcom,prng" and
> "qcom,prng-ee", it didn't do anything useful on SoCs with those anyway.
> 
> Fixes: f29cd5bb64c2 ("crypto: qcom-rng - Add hw_random interface support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  drivers/crypto/Kconfig    |   1 -
>  drivers/crypto/qcom-rng.c | 175 ++------------------------------------
>  2 files changed, 9 insertions(+), 167 deletions(-)
> 
>  static const struct of_device_id __maybe_unused qcom_rng_of_match[] = {
> -	{ .compatible = "qcom,prng", .data = &qcom_prng_match_data },
> -	{ .compatible = "qcom,prng-ee", .data = &qcom_prng_ee_match_data },
> -	{ .compatible = "qcom,trng", .data = &qcom_trng_match_data },
> +	{ .compatible = "qcom,trng" },

This means that the devices won't be bound to the driver, which will
affect GCC state when we finally get the clk_sync_state() supported in
the kernel.

I'd ask to keep on binding to the qcom,prng / prng-ee devices and skip
hwrng registration (possibly with some dev_info message).

>  	{}
>  };
>  MODULE_DEVICE_TABLE(of, qcom_rng_of_match);
>  
>  static struct platform_driver qcom_rng_driver = {
>  	.probe = qcom_rng_probe,
> -	.remove =  qcom_rng_remove,
>  	.driver = {
>  		.name = KBUILD_MODNAME,
>  		.of_match_table = qcom_rng_of_match,
> -		.acpi_match_table = ACPI_PTR(qcom_rng_acpi_match),
>  	}
>  };
>  module_platform_driver(qcom_rng_driver);
>  
>  MODULE_ALIAS("platform:" KBUILD_MODNAME);
> -- 
> 2.54.0
> 

-- 
With best wishes
Dmitry
