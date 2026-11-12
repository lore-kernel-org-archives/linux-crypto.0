Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794476527;
	b=OUURQ/6vCuoYsgq0QWhC9xbhiLozRF45jQUMIfh+7kDJSQuBXkHTewKtPh9/QH0kybDh
	 tBmQmaatBOsg2xPC3e0+m2/ziGY3DIQpNeLS4O35G+46+kK2oFUVnVEqxPNDuWkDni23T
	 BVQTIJm1bPLwysud0g99dDcyu2L3kScmHjD/ZFPonyYu69VWJ+N2GvUF+Ye5sQGi+nVRd
	 hOh0KQ18zKkrAJ4lvp9nzaBnTS9QPuB03caIDjLP7gPuId80N6v//Xw1A1Rr0fJGyhoen
	 fW6EIqbbl2ooBcWx7fbFbi9FlcTRfISOTbh3h8l97bKUehhh4kiWWEq8OVeG3OfJzKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794476527;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=nt2xdcrsDBXkfw85VObtuji4vNEs3iCSWZ4QwJDYQYM=;
	b=qIm9Qq9b6VYySAR5eDrPdYIjk+PImgvaHDXo6e3qhtOJTu+IXnM4Lcu9U3E57AZTwmdU
	 rgB3vxWvIcOaA//ZDXuoUQepV7qA68Wzf6cBdMPM0eNx1mT9HH3236YNNsQh6LOaTy3YL
	 /oz4h5yCD665tv5rDGEyErKO8vf9ftK8ZSRKu/HwmeADLtEcLIBk0QI5w0mLLFBkcIlGv
	 Xp58t0LtEvRhQeQSQSdy4M5iNrZve6MXiXRlzXlambpPoj8wmWWsFTmkJ31wgvvzdmJnu
	 3Bwv/xHlav/jPHvUvoo/FwLgI1qPmxWMe/vCQTrmESQ5SgZF+G08Z641B5rG3qIAuhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Hx3v5crM;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=YxIEq3pd;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB770606A323
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 09:42:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DB770606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Hx3v5crM;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=YxIEq3pd
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AC8rcAj597692
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 09:42:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	nt2xdcrsDBXkfw85VObtuji4vNEs3iCSWZ4QwJDYQYM=; b=Hx3v5crMD7fZ0tUG
	H6Yd2G2fptq2eQL8VifPCei8qqWNoh0xfSTI/5rrcIHF+pmmO8Gm6QAoXLWqvTWc
	gJPJzgLTZYlxF/I47Kv8pMbEVgT0etivLOdubn2SSAfIjgk79Bc95Smjf8YfvITn
	Tg29Ef41AcWVR5Y1n0WRx+HddvmPLmw8gPfo4W0cwHDBIoq5jBPBtSuYK0OFrG+1
	UN1bc892SzAqaS4VEAGB35jkrGO0SnyeBuFeGtLRTJViOdqAua31gpAXp5sXcdfY
	y0DoXhbULxMHMvtsnS5PseH920Aa4XLSafrcqOVS1dc4YeBGmJNpt94waLmisrHP
	ifPutQ==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hvt1543va-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 09:42:05 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ed077a15c3so42325365ad.0
        for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 01:42:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794476525; x=1795081325; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nt2xdcrsDBXkfw85VObtuji4vNEs3iCSWZ4QwJDYQYM=;
        b=YxIEq3pdRHgG8bAw0t6tglYuUfoEF0ToXp5xLVargiTNmk8xkRnhj2UXn6IEhNAW8H
         G+YZF9rixywlDrecDXJahoOWC2uh4wYxNgo5i8bo1Y8N73mi3G3P35XTKBcl75V6e6RX
         waeDd8x1znWWfSgOQYzswY9jG9Y3SdUpjEzJapT9uEwPd8FUjJr63arSpG52TWBN4KxU
         LkSUSZ0UEOohqyXMACp158szDPGEjbFbOR3ob2ZLy7s532Nfdk/NhEaSfLPKhYBNMAz7
         cABvV/OF5HVb3ttyijh2Zi1pkrcTquHsEIb2dMzovXMJD30TTyzyF4un31tUxGCsJiqQ
         8jDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794476525; x=1795081325;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nt2xdcrsDBXkfw85VObtuji4vNEs3iCSWZ4QwJDYQYM=;
        b=qQcilO3c2CJYrz5STDoYh8uFYi5aHlfNhtRbVhx2Gdg5bY1A2+VXUVkhSz0toEkXVS
         mbGOrN1NUnPIYl/eSyF27WJ/94M+FKFzIw0U4FOs6IKVxU0bIR7ptQMbbYvnCxS9voM7
         VqFp/9nvJdwdjAlz5ZDy9bRn8XUb0lL/Ei3sqGTpH5z5AmeRiIfvnCEuEd4S+a+EDU7e
         gfE05TERIolccHZQ7UCiewN4FXH34CzroH1Gfcx3367ijPhzsMIJ7qDTE+djH0YFaJli
         x7Kx9WMFr9tSb2W+9nkALRB3iNINEIMe+TcaylrWJ9w2zkzWAnITgCpxcwkKoc4b71u+
         bo8g==
X-Forwarded-Encrypted: i=1; AL+hErEI0UFbohEM0HGQAIYU9wIBjfX94AkKlz5L7kKdNJHQXw/x2ei9jP6y7n2/Om2dW6DTvB6+22vmZcdpBWM=@vger.kernel.org
X-Gm-Message-State: APuU4Z/k5Qslyj3z+k5n7S/+EimK/dqlZgiIWFHzzUaTzlvXaQuOJttc
	OWQirf/MBDyRfBg4TPNni9O62u3Z32ouomJC1WRw5b3zYAO/X6qnn/2VxJGZhjZM3hy8CLEYpG/
	pCngjsbtwnfUvtaQHRecjQ0OTp9CXMmwbFnYN7asK7/ftLGcihb9Xse/3m3Zu6MX4aDE=
X-Gm-Gg: AYBFou3jWiBQxhoE8RzhhLp8BG6hZsvocX3MDKch+/bQ+cPEgEciBL3CVDO+gJ0WkLd
	HpuT5BHgaR/bBGB7RIRhPiz71L3v3CzmaNBSoxTTxqWN91uySpskhYTHmMHQr5Q9+qoQPwm0pjI
	EpQFqnanMVHx7D7EHwo+w+z/teJThPXiGT5+6PXmIJYYT404vQ4XjMWdFdn/9KmyUKNLJ3SPMHd
	DOp3yjVoUisk1FxKaC3Xr4em3lTcboSLryPUYWTL9OJ3fagVPwKGFsNiWDoQou4b5zuSQZhsGYd
	Tz/vktJyTH7BSzPzJ2EnC6s3QOrav5Z+OD4iioSZzMviesVM3l/k5Mo5Y3Z+a3rb6bbw3IJ9dAM
	PRF04NkJXpcFopFLBpAA1AJ7WglG4J5YyXmw3k025wgHev0bvRcqI7tj/AoJb5IbB6cKV/lTBU5
	APAKs=
X-Received: by 2002:a17:902:f683:b0:2e8:93b5:c555 with SMTP id d9443c01a7336-2edd7aeae6dmr51892275ad.61.1794476524721;
        Thu, 12 Nov 2026 01:42:04 -0800 (PST)
X-Received: by 2002:a17:902:f683:b0:2e8:93b5:c555 with SMTP id d9443c01a7336-2edd7aeae6dmr51892065ad.61.1794476524241;
        Thu, 12 Nov 2026 01:42:04 -0800 (PST)
Received: from [10.218.31.125] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6d7eafbsm30813505ad.36.2026.11.12.01.42.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2026 01:42:03 -0800 (PST)
Message-ID: <c8ec7abb-cd6d-4f27-83b4-bd76a459958f@oss.qualcomm.com>
Date: Thu, 12 Nov 2026 15:11:58 +0530
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
Subject: Re: [PATCH 3/3] soc: qcom: ice: Add runtime PM support
To: Eric Biggers <ebiggers@kernel.org>, sashiko-reviews@lists.linux.dev
Cc: Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <mkp@kernel.org>,
        Bjorn Andersson
 <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, linux-scsi@vger.kernel.org,
        linux-crypto@vger.kernel.org
References: <20261022-qcom_ice_pm_enable-v1-0-f7a84086c651@oss.qualcomm.com>
 <20261022-qcom_ice_pm_enable-v1-3-f7a84086c651@oss.qualcomm.com>
 <sashiko-outbox-181342@kernel.org> <20261024183424.GE2553@quark>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20261024183424.GE2553@quark>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDAzOCBTYWx0ZWRfXxD4iO8vOJbyp
 aAabXob6slV1A0OMkxgHxkOrkLUeCkBENvN9NxinU0kmRSY0OkFcXMucCjzVHCQilPCxkTuI7jZ
 eaiospYig3V3NjdlD+AMxNvxslXng/0=
X-Authority-Analysis: v=2.4 cv=Yrya1IYX c=1 sm=1 tr=0 ts=6af589ed cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=VwQbUJbxAAAA:8 a=FQAUsAXO1x4B5DPK-TgA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-GUID: l_hffnk1Ni_ZywZHIwmpu_N1C_uR6Z7o
X-Proofpoint-ORIG-GUID: l_hffnk1Ni_ZywZHIwmpu_N1C_uR6Z7o
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDAzOCBTYWx0ZWRfX34vp9clSZHZz
 cBsc9PuJjAbYz3slukl0AcabcLuwBHfIdIXxlrawngsfkj5mr1iWmmOCjXbAtGeZr3z+s5G9e27
 fjI9p+VArJiU9LKYtzhrk6fg+Phq2M1S4/EnjMiN0lu7qdE79Xn3szg6JtE6gipcL7VJJfHAEo0
 EZQymetNz2T+iUSOcBFnDDUvvg1QTga+HkgpmC/AOUPwbR80a6ASYuwoQVP54Z0Vf/XhNCBVgNb
 1p5w2q1SxpjrU539EcxrBL+hPh6kRde0k3YWtmyeoklzR5YyLGKbcmGGsUL528tr8LD5BLHsK4p
 c7piUe4ByJL4IDdL/Xs1aTNOev/R+h0ktznRK0NZOjwX+dbVEFrpEqXRAeyXOxE5jQDFSLbTxnp
 MxViXAT7tLsnz6iia8dXR/1YbCT51yRs43erqolR+y6Vhre+Ss7U74oY6dSfa3vYaYFb8q5YQck
 3X/Rezm9GZDMhMM2iPw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_01,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 suspectscore=0 impostorscore=0 adultscore=0
 lowpriorityscore=0 phishscore=0 priorityscore=1501 spamscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611120038

On 25-10-2026 00:04, Eric Biggers wrote:
> On Thu, Oct 22, 2026 at 10:34:40AM +0000, sashiko-bot@kernel.org wrote:
>> Thank you for your contribution! Sashiko AI review found 5 potential issue(s) to consider:
>> - [High] soc: qcom: ice: unclocked MMIO access in qcom_ice_enable() when !CONFIG_PM
>> - [High] soc: qcom: ice: unbalanced runtime PM refcount in qcom_ice_enable()
>> - [High] soc: qcom: ice: clock and runtime PM leak on probe failure or unbind
>> - [High] soc: qcom: ice: broken pm_runtime return handling in qcom_ice_suspend()
>> - [High] soc: qcom: ice: skipped HWKM re-init and unclocked restore across system PM
> 
> I'll review this more carefully once these issues have been addressed.

Sure Eric, sashiko pointed valid issues in current code.
I'll fix in next rev and then please feel free to review.

-- 
Regards
Kuldeep

