Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3FE25B0BD
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 12:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792153892; cv=none; b=reMAjzlxZI6zYKwFHdU5MqAMz0MjuS/S7kvkAQgN2mwb/vWQ4bZ9+vp0fyI6BsKpumNWuAuCIhrwmeNgTRreY6rFqGEpLxUfIbDBKuCaKV6fc0EMlZVSTB/qX6OeRbznNTlriXirRfIKAZudiajlfomgEpW1AVz/p3yQAXSk8SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792153892; c=relaxed/simple;
	bh=uvzCRxGuooRqn7FD6epZqB7NmrfzTcjHnLeWzrz4Tzo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fjSaNPsiUtM/RSfU0CUaZR1e0rwXn3hLRMBSn/+9rLSgXKiHjzAZM4XyZTnphJN/txzG7uSwtYpLwQh6mw9W1WCaoTezW5lrE/detjwg1Prm6ebm4p9TgRcSTaRz5TwBU0OfXQtgmh3QBrk9maCmLCTk2OLmGQVOHrXhslhkE7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=jZ96fk2D; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=knqCZro/; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="jZ96fk2D";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="knqCZro/"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69GAvH1B1503924
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 12:31:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	uvzCRxGuooRqn7FD6epZqB7NmrfzTcjHnLeWzrz4Tzo=; b=jZ96fk2DZK99DMCG
	2dbDYX+BmrDRCFD0Aii09w4b6OMRgmd5fkhApbmSOWDxLv39fkkPuRGhiSCo/ftL
	XxsqZYpP6AqzXGObAe1I9d1L3DJ5W4tbrCwQTizZLKYSoebm3mpiCUgs11va9bip
	aRa5M5m5y37xd/SdwFa3qx0akBGSguwF9nGPbTX875amUYd5B/OlVJLEKy4XQkpr
	ZazKoRztkvKZEn8BX1JMVSN/iD842raDeOfenO2LHX1WZb19iSxlvCFiWxKVPaOR
	Yv1N/KprMYZ1qgngnUbIVB7fKOz+wBAoj9bq7nTO0tLhX1lteDZXbCdX846SUqI0
	OLiVRw==
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com [209.85.217.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hbjmf89n0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 12:31:30 +0000 (GMT)
Received: by mail-vs1-f72.google.com with SMTP id ada2fe7eead31-77f133855b9so238628137.1
        for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 05:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792153889; x=1792758689; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uvzCRxGuooRqn7FD6epZqB7NmrfzTcjHnLeWzrz4Tzo=;
        b=knqCZro/K1iErJk95NWa552BYNt0A3r6eB5uQ7D2+zg/AwvKkwlkwHKobnQKpY/3RT
         n85R6BpdgiaXQbI3iU5smHsZQEZ5Ewe/agky9gt/h0CSoPbY7XsrMAuA+DMnuwZcqrq4
         Qx1Ce3vw7jWESkBaW7qRtEu4YEyyzfGNUT1KUyK+XkxD8m0+MVp+B/UkFtkYnhBx3r1w
         lo69Qa8cN6IxqPNRNeqj98BLGOPG5ijEX514GnzwG7Y+VRDoOAiGr4KvDX9hDKTSPeNK
         q9W4pd/ruS6hOVXPjzDkxVuTYrvgVTXLROr6CkYZxPgC27DtoEK/T7dmUVkeKKQ9UY8t
         fZhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792153889; x=1792758689;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uvzCRxGuooRqn7FD6epZqB7NmrfzTcjHnLeWzrz4Tzo=;
        b=U3GimrrHrbFUFQ4O5Bco/zNTrm82Hxh4leNJ3fzMpECerULGbdwIMyWrKNRiSkjlF6
         he3Amb+HJgN470IZ3452ilInRyLYDr2sNeUYG82cURCcibWxeCZfypMgiSu8tJtJgDw1
         empFgzk07JDO+FO2Xk7eUcoMnP2tCZPuXSs44Uqqx3YcTeT0aGpUmFiRzE6JBpaaCLXc
         dgvkMEyAhtfyAjoaauIjN+GIfWO10xxMznOKiRikvJudMewd9WPzT8hPmKVtuJ1raEy2
         qKSsPQV4MnoCxTzUllcG7mVD7Xjw0bbMlxTLTzW5DvwYMSd0tQ2j9J2VWeXwbq81d0P/
         0Kzw==
X-Forwarded-Encrypted: i=1; AKwUvBzenI856s/g0aGcq/+zhPPAUhfAvit0nZRFHdadd+g4KYnjQjB5kZohdU9972XOgZSveIqruIlh2S3P/+k=@vger.kernel.org
X-Gm-Message-State: AFq9FYL6MjmlbS0Pldka4liMUIuUI6gGvVjSC9u2+dzo+n45oUoXR0CX
	1pQgtYuL9rEHttPPY1YpGwap9bodmclJpwYIuvVp7S7vJYW8/qOvwb5dd0+pLJJfy0gGPMES5bO
	3XfL32QsqG3P0n7qJuZNLAfIDoKNs91afobuLmSHNa9DfWUxHn6nLO4XBXpDfNKw4smA=
X-Gm-Gg: AYBFou2SCcMhQU/6/fsDH4TmBkFJ7T/oki9T+GfyBsi7iBgqUHKQKF33azFh/fUxyIC
	2K5T7eTmDZ86usjMrt8TC4xdRBBlBXFmHoZwEOrfZSHEahieIOmomc9AXMB9LulNasdEIJvq3yB
	dRdOiGOS/lgfDVl7p2v4IqyOaXRg1Qy2KeYmpmYVWbGu46COeEy/z/p5dw3H1Ol0EGL82J7hXlv
	OdK2HgSnzJ6Gz7mm25XjtklvxaDJ8+6YifTHR1pVzRDAKVyXDN4KxJ8ukOluCdAPWWml3EXmUrU
	M7aSSbdrSePyHuM73AdrSUFy2RDbJCP1WQIAmRIauHFQKTLCrVuGK8mIFv/9FuUf9HwPgIQgX+/
	w8wpjgKZw/eVXOFZhxmEEXg==
X-Received: by 2002:a05:6122:4650:10b0:5d4:41cb:8936 with SMTP id 71dfb90a1353d-5e91f4ba58fmr5094026e0c.4.1792153889463;
        Fri, 16 Oct 2026 05:31:29 -0700 (PDT)
X-Received: by 2002:a05:6122:4650:10b0:5d4:41cb:8936 with SMTP id 71dfb90a1353d-5e91f4ba58fmr5093981e0c.4.1792153888906;
        Fri, 16 Oct 2026 05:31:28 -0700 (PDT)
Received: from [192.168.226.26] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c40919bc742sm66813966b.54.2026.10.16.05.31.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2026 05:31:27 -0700 (PDT)
Message-ID: <18d6a6ce-afc6-4590-ac26-0aca6dfafae7@oss.qualcomm.com>
Date: Fri, 16 Oct 2026 14:31:24 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] arm64: dts: qcom: shikra: Correct QCE node
 configuration
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Bartosz Golaszewski <brgl@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>
Cc: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
References: <20261006-shikra_qce_fix-v1-0-8ac54d81edb4@oss.qualcomm.com>
 <20261006-shikra_qce_fix-v1-2-8ac54d81edb4@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20261006-shikra_qce_fix-v1-2-8ac54d81edb4@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: 7AxAzFA48zL713Tq_ZHKss0TszzAdlHJ
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA0OSBTYWx0ZWRfX4TyoU1RO/fMf
 jfnwJ479ek6pulJlEe9elnNgiHymni78LyFhMOxP41p7ecGVGrqNv0j2tgn3ojXkAEH18FG78oG
 ALdBMTWHSK7v/3j8ZuDY9cZMlS2WbtA=
X-Authority-Analysis: v=2.4 cv=SrAFe/O0 c=1 sm=1 tr=0 ts=6ad21922 cx=c_pps
 a=DUEm7b3gzWu7BqY5nP7+9g==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=mSLAci9PSNYu4dxlomoA:9 a=QEXdDO2ut3YA:10 a=-aSRE8QhW-JAV6biHavz:22
X-Proofpoint-ORIG-GUID: 7AxAzFA48zL713Tq_ZHKss0TszzAdlHJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA0OSBTYWx0ZWRfXzUwHG9b7ntph
 i3L2+OWuvjBgmBU3/N+O0OjauiXRh3qUBU2MpZJrISYKC6kdRYGyCS0npmzfzFnxGqqeZO/e6w8
 tLKB6pw955w80Ga3A3MHweMIgWoqIY5QSh0yGvXsAj7tcbQbVMUFkrBaUh4Kh0sMn+c5uS1LuDR
 g7LGtDFfdQKhuBXfXG0TNGoHdKRdHOjrnj8ehptoEqcAE4jjBM+RUjInIg/O3FqS7gp+czEq+2k
 o69uXPZHZlPtOYlXRM7+neCA1X14H1ds8TDYkLny8CW0qo5t2j7sVCMmuluBuXIztET2WNmlkZ4
 a0W/GadJNbnSO2hTd+DIIpo/R/Qac4C4U9J3Qz2UfctRK7Bq7CXfoSWpIxHGttkQCvSwj4nrOTO
 p6A7DJbbw0mH9yNHsZWuYKWDPnAaVmX+7aJ+lEPpkdl4RZQVkizCzeJozrOb628Ceh9sQw9LBAi
 yNLRS8BARLUz0cI8LSQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0
 clxscore=1011 malwarescore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610160049

On 10/6/26 1:14 PM, Kuldeep Singh wrote:
> Shikra is derived from Agatti and uses the same QCE integration.

This is useful, but..

> Update the QCE node to match the underlying hardware implementation by
> adjusting the fallback compatible and related properties, including
> clocks and clock-names.

because the compatible you switch to says ipq4019 and not "agatti" or
"qcm2290", the argument falls apart.

The real problem here is "the hardware needs a clock and it's currently
missing". The similarity to Agatti is irrelevant in this context, even
if true.

Konrad
