Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D70238A73C
	for <linux-crypto@vger.kernel.org>; Mon,  8 Jun 2026 07:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780905586; cv=none; b=bunYIkX8iPGivycEAHiY//vetZ+8z2kCk6WTJCrCv5F3AzItbYgb79+55s6ThbspgZI1UtifFOD1Pz1p3gukcMmJ0MnnRy1JF510PXxaIucI80/90ZlSDko2hECFf0exOKSoF0i91oOaKeULXeuUl/UkZTwYrrF7kHk/a0vG0cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780905586; c=relaxed/simple;
	bh=ylFpAwNTldix6A0s7dSe3/1hV/92cXXTUh5QCauqNT8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WLOr6meb43lj115faaMYBsbqdZi+YwWQZm4JLINHGpNO+CP5Z74zsTygXatry9S7A2U8aJTWiT2/dauI7JsLv8hQ8d+3obnBM2/xSfb4h6HoL+wFQvIcnPuGHw4BeIZAYTQiDnk2+BzfYViFwPJMC3875HXUGHuhtZv3mDQ2jd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=cxeLn7Kt; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Rx4luj8K; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="cxeLn7Kt";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Rx4luj8K"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6586Ra0Q2833828
	for <linux-crypto@vger.kernel.org>; Mon, 8 Jun 2026 07:59:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	qsCO5uJLKaGY4bZNguhIL2FBFY5UouWblNWngdY3+Cg=; b=cxeLn7KtnvnsoZCJ
	2kZmbyjBzURJ3EjGqyCw4Ew2ghtrB+YwZM207uKNR/kafZTZJCe17DgOf6WRZa37
	3CZqschLBJj3jYGlIH+HHDykzrjdwc4PBwFfSZgeL79PBV//PnSjrvooDZ+TNi0l
	WsTltbzPOemwxQp8Zd4ZIYWqIsEaeZjR7ftMT5i5/wlJWfD7Z/wTdlBkPb/Yy5OV
	79FiJMyWXjB0rtjeqDmRjDPytwASKSsU12sK8sJ/ULvUose1fSxvHj+YnZFPbXbI
	tfWPEpSaqZb0oxstFRMS7Ri80byOAtD6OvWvPY2sVvZT2CrXT9mnL2JE4vIAgOHr
	6PL3cQ==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4emaj4xy3r-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 08 Jun 2026 07:59:44 +0000 (GMT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-8ccdd99d20dso11890206d6.2
        for <linux-crypto@vger.kernel.org>; Mon, 08 Jun 2026 00:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780905584; x=1781510384; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qsCO5uJLKaGY4bZNguhIL2FBFY5UouWblNWngdY3+Cg=;
        b=Rx4luj8KEgyPH1yciFHwxsuf12B2uF1i/uucl/VKOys4cKmlJR6n3KigBfSTIqVRON
         4AS9H5FcH0mOXTJpzMpT7i5MMV/lzdxf6JtR7U1DEUzSIicj9ytMsZmzTgdfDs6GQjnQ
         mD6n56kXHIY0TtthVZtPeDKFzQvqgCb/LR9U2ck8r9/r/QCBjaKAbe88/ThQaeFfKFdQ
         9IO+QYRZfeBZvkZnrf6YGpNnoeiS7+vTcBdWOR/hWvsMNF8Dngyy7g1AxQypHQRRuQ/K
         w/dJQEBVuAxCmQ5MFEE0DE8ciQbtzPqWfRr7jLl3PfVcscCfdfpUWG3ok0Dc1Gv5snVV
         1YxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780905584; x=1781510384;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qsCO5uJLKaGY4bZNguhIL2FBFY5UouWblNWngdY3+Cg=;
        b=evknZADkbCYZnZXIbJsBGBjHFVhZeWANv/lhUPLkJpan5g4pWCmYweW2U47j3xFLbh
         ODUBEweVLe/uYwIV63U3byvazdjJHn9rmQA0yHMhYd2vPVLm/N0MSYRLLe3II8MobDZd
         fHW8Qf6/tHduKkl2No1+8MwAIptToD6YKkGR/AsTyxQUYwbs+J+cqPOyjWmWgCj4jGnO
         ogJcbhV8O/sp9HZTS05JJbbLaF0aJGtcl81nvn0d+WbiPbsWbAS4JatX00ZystQFyCk/
         FAHcgFBQWBUUTOU7xV9PX5RvkcOyOcX10G+8UqGuvX6pORpahAADP2vRZfTAXFwK5Unq
         29Kw==
X-Gm-Message-State: AOJu0Yx7ssrwGw2Mi2wsNEu45wrYxsu5EaPLrqF77VlQ1pE4TSy1TZsk
	8K5TzNABnb7ipJlLlEI7Uqy935SCXFOvvU+UNpodJ/H63EKkqTMcfejuV6I/ohHl7WJJnoC+eH/
	lRlHhYm6/dzOCNfbSulKTPKLx7fjBkiqV6oHWq2ntmELm+UsvzHhPBlExuGjfYcn6jJc=
X-Gm-Gg: Acq92OGoDp3BU0DQkmHGRBqsOGLFfSaL1lxKHQudQ+2LPNLMjpSzCs8tStYZT63Gxqd
	AJ368mbAdnlPRK8b0I1kYuU+hqNcMyC3dnRpnAymUtkY+qnv7Msy6WAmJ9wL/xPngcb1NtgYCqp
	QzzOpdW1DShvKDJAir0XaTJGbhnj4dasWcSTs8bJZKZfRqer8uwYI9OVMuVq4I2yzGUKXEBbcO3
	N7IyehsW64ZXAmQsNaT0+Rh4yWAZkcNcX8pyMllMBJGH91W9B0V9Vt23nEzhPJGP/kGEIUFiwpG
	xGcwjVBLJXwaQzlUYHdorsTORGN8NZPRh0MTEBcVhZUct59NF/4zftLJRMOMBuSHGuYPk21oEW+
	1lWySZphNBCJRsMNyYQjhvzeiml7diom8K2K2tUjBT4b9L/Hid2EhzTVL
X-Received: by 2002:a05:620a:1a18:b0:90d:11b2:80f3 with SMTP id af79cd13be357-915a9e00484mr1423020685a.7.1780905583635;
        Mon, 08 Jun 2026 00:59:43 -0700 (PDT)
X-Received: by 2002:a05:620a:1a18:b0:90d:11b2:80f3 with SMTP id af79cd13be357-915a9e00484mr1423019185a.7.1780905583190;
        Mon, 08 Jun 2026 00:59:43 -0700 (PDT)
Received: from [192.168.120.170] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-691afe82416sm1306874a12.13.2026.06.08.00.59.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2026 00:59:41 -0700 (PDT)
Message-ID: <4a72fee8-8593-478d-abc4-b4105ef7751c@oss.qualcomm.com>
Date: Mon, 8 Jun 2026 09:59:39 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] hwrng: qcom - Move qcom-rng.c into
 drivers/char/hw_random/
To: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Om Prakash Singh <quic_omprsing@quicinc.com>,
        Bjorn Andersson <quic_bjorande@quicinc.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        linux-arm-msm@vger.kernel.org, Olivia Mackall <olivia@selenic.com>
References: <20260530020332.143058-1-ebiggers@kernel.org>
 <20260530020332.143058-5-ebiggers@kernel.org>
 <w3nvohaf7qvfwssggdhoqogwtcfmucfzqiuihbtwly6iqa2i46@3tybaiubfn4q>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <w3nvohaf7qvfwssggdhoqogwtcfmucfzqiuihbtwly6iqa2i46@3tybaiubfn4q>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: bk47lEoJ3m8hlpVKewCFIA3QmexIbLDT
X-Proofpoint-GUID: bk47lEoJ3m8hlpVKewCFIA3QmexIbLDT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA4MDA3MyBTYWx0ZWRfX8CUYnNxsoNSt
 CudWgtE6wAFG6JlAUICRy2lfnLGPNZu3bY3qeo5uxdH0Eeiwz6Hme4OKu+MA7awlBXXQFhmPXsu
 pu/SWGTigmec3mKh5uu5xU023yq0qJ4QY9ldCw0mzKDNvqcdUba+XEiFZlHwDuZxT6ChFCF/wyc
 zN8hSjmxleELjsDJCjuq70yCSneZyv9RXn5z75o44BBTl9XEBZKxgL8K3pToTVxsEaFJCrCPsQ2
 QDOcdoDsXmmaOJ1+QfSzD74lYK7WHhBtnBOrXaL5u2kc96sYN/idba7/jYtsImQiweoJirDZKyf
 D7Lu074vUkfPyBlqqRVIj8A27SdowzKoIXDcXBUY00f08qNvrBajcplLBOUF2c9VxIj1PfVi1yw
 /AE+byy+La6870yxEnSwCzSiYSSMq/7cCshPL/ptMexyCn4NocaZ6G2hnauvKfvSSQsSafRjzS9
 Mbzx5CVj3b30+IE9lNw==
X-Authority-Analysis: v=2.4 cv=TLh1jVla c=1 sm=1 tr=0 ts=6a267670 cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=VwQbUJbxAAAA:8 a=rr1I_Jm5zLitNQkIIH0A:9 a=QEXdDO2ut3YA:10
 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-08_02,2026-06-05_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 spamscore=0 adultscore=0 clxscore=1015
 phishscore=0 malwarescore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606080073

On 6/7/26 11:04 PM, Dmitry Baryshkov wrote:
> On Fri, May 29, 2026 at 07:03:32PM -0700, Eric Biggers wrote:
>> Since this file just implements a hwrng driver, move it into
>> drivers/char/hw_random/.  Rename the kconfig option accordingly as well.
>>
>> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
>> ---
>>  arch/arm/configs/multi_v7_defconfig           |  2 +-
>>  arch/arm/configs/qcom_defconfig               |  2 +-
>>  arch/arm64/configs/defconfig                  |  2 +-
>>  drivers/char/hw_random/Kconfig                | 11 +++++++++++
>>  drivers/char/hw_random/Makefile               |  1 +
>>  drivers/{crypto => char/hw_random}/qcom-rng.c |  0
>>  drivers/crypto/Kconfig                        | 11 -----------
>>  drivers/crypto/Makefile                       |  1 -
>>  drivers/gpu/drm/ci/arm64.config               |  2 +-
>>  9 files changed, 16 insertions(+), 16 deletions(-)
>>  rename drivers/{crypto => char/hw_random}/qcom-rng.c (100%)
>>
> 

Seems you sent an empty reply, Dmitry

Konrad
