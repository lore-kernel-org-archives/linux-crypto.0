Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1180837A846
	for <linux-crypto@vger.kernel.org>; Tue,  8 Sep 2026 05:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788845972; cv=none; b=hyEyteON6rN7+8hrQNk00+RcfPSLvHW2TS3zE64XINf9UTxgNsHEHhlqoZatrxT3WQ2qqN1EuuIRw6WkQqWodRSVgTWGpKlPfhLwHTepdVv9aE0aZ7IjnJTeRi2jFktj96VVBWT5Dj5c5QHUJvFu/341BgVxwicvHf4agXcpNS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788845972; c=relaxed/simple;
	bh=5aoWEdoIK4LG8jJFDqvXeQojo/uZNre8Vv41wWy/GXA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XygwoEOUF0jbp5ZIrT+FTJdLDNi2O46FpPx72C1F1ZSWJ5mbff6xGR6us14URca8QUgLfy3S9lqWLd+b48DJdpyl/RJ+aS5koSHhHWAXpgHm+6+Gv/0U0v7F5n1POnLJmn9iFSeml+RQdlOc0+f/vWD8K0lSCQ+yTjiJHnG0YGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=a/BhhBwL; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=OHYyu08p; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="a/BhhBwL";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="OHYyu08p"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6883p2VK1150721
	for <linux-crypto@vger.kernel.org>; Tue, 8 Sep 2026 05:39:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	zgXJRuS6j45tDk50aJ/oEXxMgdJ1P69nwuH1jm3ZTs8=; b=a/BhhBwLUUXM2Ams
	UKjGYQsshyhWnq0ujOrCSpk/JOiNz2KONFU70OA3hdAd1l0mfZQNyi8WaX18yWzE
	OrR/69sk3b2aiiM3NLp8jBnf2HP22qz/XAAMOaB7sQ+1ZOuTKM95XDRo0fXt0bFA
	X86WfZ7abxpF4BltOTHPkdSkG9kNLSnI3ZPXwTPNIxy7PTS3ICAYaPSK6796TC0o
	4ESSUwfkyJ1AGSeWg6ijNKIiC97n8BFnifRRgfSHHeaeyG/VZZ8M59+nmxLUl+UH
	r0lmoS1q1yx26J75WiH77edD0D/dfMnWCe/sPhSPj90u/dU+PBBrtAODWZrmYVSm
	iacqIA==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gjatjga22-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 08 Sep 2026 05:39:30 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-398d292eac1so8788865a91.1
        for <linux-crypto@vger.kernel.org>; Mon, 07 Sep 2026 22:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788845964; x=1789450764; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zgXJRuS6j45tDk50aJ/oEXxMgdJ1P69nwuH1jm3ZTs8=;
        b=OHYyu08p5NRQg2U4MsVq0oEp6wVODueYqaJkWfWIMc3AwURymxuiKLCrxIZB9h/XVt
         3bjJogXSnHy2IQk1TivU8/M6EX1ttcRnBnHOYRAZKTue9h80EY5bz//JpCaYK0g9Wq9D
         SOjjb7YkL5PLQp4kacYUJvzh/NswScSwV4UQqSUJCUxbCZQu/CMlJjj5mN0G57zUbvIW
         WoyoNYAwim3hJmnccjGS+vqdp1hATrk/EmjNQGwx711IuHpGypj73tqjt0t/kTGbYPak
         F4qjsPcrwmN/1/rKv8+WmPcbTGFCJ8C/sUWxjDtDlfRPU1mg5p/ygEt8OVHXGmVoz9gK
         li7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788845964; x=1789450764;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zgXJRuS6j45tDk50aJ/oEXxMgdJ1P69nwuH1jm3ZTs8=;
        b=eOP6TBjjIoIdV0SKDr3NpIfigUUxO9HNhK3BYwgcrX5GOSt4rxx1mDx7C72daW3Ju/
         MVq4/yp09JsIfvb2eaXVeyMY3bKLanZpChgwf2a+DttpAW2zmxGZjBLykZGSRfTkF/zc
         BYSIyb7Saq/uCh5nn1ikhkbu8l7gOQRn8YQPA6sAkFMkZt03h4gyGL/opKpyCuT8VVyA
         m6pl7+LRmSAP7E+IihTfWemZgKG0Ad+GRbN5HI5xA2IY15/Du0ywnXHdbpltS9TTZWJQ
         qRhBCufr5NgfTxMJVdg+ChYUahpNWn1TiXP2ZA7W7jgzrxEIGg3clyLMnhv3YXohSD24
         Xjqw==
X-Forwarded-Encrypted: i=1; AKwUvBzUTuCc/edsd4/gWRb9u+iAhyvYoT3e1/MaWODzhNa8272PU/oSWAWU6axrk3ikqjmQwYTIfPcLtcVhW8g=@vger.kernel.org
X-Gm-Message-State: AFuF++nV5HTFPCjr3k0YJdtg1HIqwcg8UILSwp8f+tNBC5CI396lz9va
	cvkmaoTI2SzcoJh67hV1a+iIJpE8/q2jccN1xYlaF4q1+M5cf0Uqex0PPydcvZ5Ux3B8cr8AYfl
	LKfVzm+fHhrSbtZ9b88m1rv3JBPv6F+uwElLvcAg4JJlx2EnyK5Hb72moVZnurbp7DQ0=
X-Gm-Gg: AYBFou2FyyIZUob6ACLCfEFUbh/DMMDtui33HkzYiPhKlRO6pkmrxnSmiVmhLfK02XI
	uCpUX9lmcq/NF0nerQFCO0jyK2XtNb6j4Ofbgtrgrl3v7V2eC1HVmA7FOn593b70iGEj+Ui+pDa
	ZvFWuBTcLjKjK3W4ZC0V3TGl8AnKeuXEYopNW8YMrv1NInLevnZyWaVixd1SVrKnvbroiDBFgFs
	yL4SVVqbH9fOIE4iOdbSI3e6XF6miZS2reVLPa2ojWJxZypstq+ZA6hhmL9OTt/tWGmTEG0W4zg
	kzA73enRqNNaY0Nbu1F741GwH9zQF1cWfJwhuJ+d4wwkqpvBq0O6XBVmK7e+3KZCSWPyEb1AwgE
	ac5beUlOKcXBeNZHy+qGGW2qRKAx8jg==
X-Received: by 2002:a17:90b:2b43:b0:38e:c7b0:84ad with SMTP id 98e67ed59e1d1-39b25ed34f3mr46802515a91.0.1788845964462;
        Mon, 07 Sep 2026 22:39:24 -0700 (PDT)
X-Received: by 2002:a17:90b:2b43:b0:38e:c7b0:84ad with SMTP id 98e67ed59e1d1-39b25ed34f3mr46802442a91.0.1788845964016;
        Mon, 07 Sep 2026 22:39:24 -0700 (PDT)
Received: from [10.92.169.30] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-143243767e1sm27672840c88.6.2026.09.07.22.39.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2026 22:39:23 -0700 (PDT)
Message-ID: <8d10d92f-0afb-425d-a517-1a7b24b80342@oss.qualcomm.com>
Date: Tue, 8 Sep 2026 11:09:17 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/2] Shikra: Support for QCE
To: Bartosz Golaszewski <brgl@kernel.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
References: <20260907-b4-shikra_crypto_changse-v6-0-0676f61894b3@oss.qualcomm.com>
 <CAMRc=Me=JxgZv=cuysWhmwQjUp5eHcxzkzoPUnDWipjoNdn4Ag@mail.gmail.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <CAMRc=Me=JxgZv=cuysWhmwQjUp5eHcxzkzoPUnDWipjoNdn4Ag@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA4MDA1OSBTYWx0ZWRfXyrCJFrd2YmYW
 LM2xU1J8hiVYRC+6xjln1/bwZbs3PfyOUmA6ixp1KauGYGZ3AaeA1r+uRbYe5Sd9wvNonVup0kl
 bSUe2qR6P0VnF0OPWlGmLiNst76QTh8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA4MDA1OSBTYWx0ZWRfX4HL1A1PUJq25
 Mb/kkjO5oVgV7GEaxPipqs22qyMXQMfkgvxoOc7Ey9SUuerecFtSvOQ/2p2EXzs9ICDo9By+YJa
 1aihrYNP+WtIFcbLtl8GOgVyLQADR3WpH81M170yape/p99ToFxGwDPPSZ34G21JbgEwQKTrjK6
 76jOVctgirVRQQzZ0Hzbt+pWr7lzWaYyJsKLDNPOO+VWMRWp15J47mMrLfAe8o2WCmfNAY24eVo
 CS172IZiz3/O37ON+HH4plVoxCtrhiIMO3bl3l/QReIDyzIFDIPSf15t7rvZFLuPD1Bc2SJDgje
 EYS4EbyUfuOu4ap6KguJjtN4PeaE9bpZdgTlVGFf2abBjgFy0nB3hF2wtl1/DuLTy/NcR4AZcZi
 ptlQpoN7saHCoCyJ+TxoYf9qiCTIn0+jnudQUF4NkZSZBJSP/CyW63KWWckUv+Z7ekaBvakNZ03
 8UTqWiC3hSQlPWX2coQ==
X-Proofpoint-ORIG-GUID: voJ_pEecrdXARGoY60X8Rb9Xd6ESaM1U
X-Authority-Analysis: v=2.4 cv=QrduG1yd c=1 sm=1 tr=0 ts=6a9f9f92 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=rOgB9dYqbrrgEkEPSjwA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-GUID: voJ_pEecrdXARGoY60X8Rb9Xd6ESaM1U
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_07,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609080059

On 07-09-2026 19:16, Bartosz Golaszewski wrote:
> On Mon, 7 Sep 2026 14:03:35 +0200, Kuldeep Singh
> <kuldeep.singh@oss.qualcomm.com> said:
>> This patch series enable QCE support on Shikra.
>> Shikra is derived from agatti target and QCE was using different
>> compatible configuration.
>> Also, one more reason to update QCE is, clk-smd-rpm was doing proxy
>> voting and crypto was consuming it. With proxy vote removal, qce need to
>> vote for it's own clocks explicitly which is already being done for
>> agatti target. Adapt same mechanism to Shikra QCE too.
>> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/arch/arm64/boot/dts/qcom/agatti.dtsi#n889
>>
> 
> This looks like a set of fixes to something that's already been queued, why
> is this a v6 and not its own new series?

Umm, both commits are having fixes tag so indeed it should be new
series. I'll collect feedback on current patchsets and send v1 version
next time.

-- 
Regards
Kuldeep

