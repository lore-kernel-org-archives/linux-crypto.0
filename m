Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794827935;
	b=l4z1gCt3VA8q11TDNCTzvXF/RhKlBJlQ9LIcHvrsLkVcGTagoDsArxhLMo35n4btSzfn
	 W2wdixdiGSbbo3UnYnbAJhxcMmjljp/1Y6etCLtbTacrcyNmSDNPsH0SEhngy5dOcv9c9
	 ZOWU3ZR1HEHgfydaJy/Pbj1Vxvs8qJUbeClqb5ry1n7O+g1Ixnst/kabWw1irwhkSCcFa
	 fj4u52/fGAwtTdrhjtcy8iTyAMK+WwUUDOzMTo/p60Fzq5emrpp/1TJFO4LkDk0c5KWTr
	 TZWg+Jczb1Lz5XhTGPLU9FrBZwabcMspabOFCn6T+tcr0pcFE7OtCmjGuMZ+UStULPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794827935;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Organization:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=/M4tNKxMt2fBsOXOhu84GGPzS40IEvP0EO6XY1dI84A=;
	b=Lp7d557EYbGEWeX5ctReWiQQ1faLDB6tgXyz3iNEA/RfaQD79T9CBMd2/qSy5bF1X2t6
	 kK3Mo6O4z+wMLB0+rTKFxy3Bdj0e+f/cVXldjim/A2CuDwhFbVKeuT3bB0YgK2McXm0EA
	 nzQRENv8ECdbm6eOmDvwivcTrZ1BTGlpxPa3nphMmmlG0NiCG8tn3mKGLBfED3RqwSg1Z
	 uW2woI53GXllSQTBEwt0C3Cq+gka7SWephg5CLXS0fW4CZ4deHAZsB10cduEHJaR7IcxF
	 RYJO3Z/6TIkOreUOwGO/eQ5lM8yMnb31xbO27vBpJ78S80uL0slEhGTPJ4904Fyni5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Buu2wo26;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=kNtdGh9h;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8317D60703E8
	for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 11:18:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8317D60703E8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Buu2wo26;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=kNtdGh9h
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AG7entg1109769
	for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 11:18:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/M4tNKxMt2fBsOXOhu84GGPzS40IEvP0EO6XY1dI84A=; b=Buu2wo26A87LNAvo
	vfTcVD3KrHkISdUrofq/hDwS6Osq6iV85QykFm9BSVpW8Rq0Z/eRsXRyG+4kUXox
	lPGhxqXjD/XP8J/jaKDoQ58k6XqCcrG59N6dk9azLoWq2tkW/BVVSswlim17ukVk
	Jp4KzFjKIFjJcFURryPkIswYZlXWqRP8MWsp57QTdrndTEwEYfMN2INHZko70NGb
	UDOUBwqV4A3OT/bXshTEz+PUmYKbUONTsAAtRUdAbZWRdV47o7H6LaPRUYquoiwC
	acZOMyVVqc6fDe/e9nRBZP3AmlfpGPkblE8ulj4FKri8SCmM1wF8g2wnjHKI2Jf1
	2XjvBA==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hyrmc1vnf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 11:18:54 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3ae72da2f57so5373632a91.1
        for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 03:18:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794827934; x=1795432734; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :from:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=/M4tNKxMt2fBsOXOhu84GGPzS40IEvP0EO6XY1dI84A=;
        b=kNtdGh9hQrKfSbzsMJV1U5ylLOTzp3nsf/pn2RkkuLv//oeyHPFCDsTzIVBfTc5QEa
         naVFRMp62qaRsL0Ca6gQpvjSSpOFFGgPGWEyOQ/yBmnlt+k3Zv8VN5CkD9EEXqCn60oK
         zmoaSB/pdzmGHS9BhuTxrraVCbw7OyDXVyQkpJO9rYkeD5aNYxsJVaNg2UZwJWFMKjiS
         Ml3WNsvPC+4WeP3CVEMkqOLoe6FTX65HCm9aTto0Iix3ezweKM7iIEC6KbWpcutGHn59
         2RJK+bsaqf3T7M8WsCwdNoLU9hqTyCIwlKdvEEGinjzipUuvUmen1JRZDzmr4y7kUSP2
         WzlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794827934; x=1795432734;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :from:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=/M4tNKxMt2fBsOXOhu84GGPzS40IEvP0EO6XY1dI84A=;
        b=STC+D+lJT7/s/dJsBs1ihRgVQFC0O7qQE1N9ir9DWyKRkRo7mj6QbatE8CrP0neLYy
         9eJ9mwyRrmuV/1l8J0piqviOdY/dyBTObIt9WVlyZXor95T2+qtuKv4Dsaskz12Czja+
         kMSx/k0g03WAFCUer2JRV+j/0gObBoyme3LEUl8wyBj2LKSXyQjJ5NrxnbT+bzQunBpy
         eQpnKFt6kM5yoN5g+HOuihd62KxSppFsV10BZOdGCyniyyXxsUX+pTa3QZX9yLUFeqse
         zBJlOUhpf3A6rOZHAENuaiCg8cRjI9jof0IpnSmi4HAbsVQynShbcWuoczARRfDOzW8f
         m0dw==
X-Forwarded-Encrypted: i=1; AL+hErEt1MsHu8n8G+tmu87/EaOk8uvSW/zP3aL9FjQR/ThNuCLN7XbYkYLxaEPhVooF/tlA6zWGELPmKp8qOuk=@vger.kernel.org
X-Gm-Message-State: APuU4Z+D+CtJrHgqSK0KuL+GrV5yeaGNvR5+8tNSybWpehL1MVf9EPvs
	4v855RqbCeJGPNOX2GgJ82kqfSqnhVsA8V6yUv27Kjyt+Egw4Omj8QwU9APVoLvG9IKpsS/Q3MM
	27xruU+4+ZTbvw3mHPNsPwDOEuNKFY7ZODJxluqZAs6Zl1F+2AK5PlUpdpFs6Z2a79TzmxXsgro
	U=
X-Gm-Gg: AZFdTZccUARRGBc7ooC3Sj/9Z3MGFJklD+FX4ppWwDPnBT/V2jjs4pUX6TJrRbZhoMC
	tDvhtYuuhcLDdExpNDAkBQEjffKVAy5bJ7N8QrkHLV9G5kAaG+G/iBoD2uC7hVf0qJqcZ3Rx29J
	2Yl+D2ax6adDHro/9oTX0FqNL0+kDFAd2cPUgNisprzCPRfiBmsg1mClMVsb0kgkcqN90W51W7p
	zvHO2mVF3+FlqlmHBSxiv4CZ5INcY+p/3gNx35/vfikb3TAnPnjEf7fqW0lAehpfSuTRAvrtgcv
	iVa9nAKMK9PYPcDIPtYIhqp3fTz0fxT9r2CIs57wI+zgnpt2yYQeKlG0sjD3Pp+6aZLltUfwwic
	MUMxiIVdTAHfPjM5ymV86IjjX/sAtjxUyksq2AbeObVn7CvpEHCeF67IdxGGT/57pnhqDRl6RPX
	o=
X-Received: by 2002:a17:90b:2d85:b0:3a8:bd51:205b with SMTP id 98e67ed59e1d1-3b1b0ca53bdmr10317945a91.37.1794827933757;
        Mon, 16 Nov 2026 03:18:53 -0800 (PST)
X-Received: by 2002:a17:90b:2d85:b0:3a8:bd51:205b with SMTP id 98e67ed59e1d1-3b1b0ca53bdmr10317925a91.37.1794827933363;
        Mon, 16 Nov 2026 03:18:53 -0800 (PST)
Received: from [10.218.26.96] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b197ce49d6sm22100109a91.4.2026.11.16.03.18.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 03:18:53 -0800 (PST)
Message-ID: <691c3ec9-b21a-4e66-8c4a-de14c8987705@oss.qualcomm.com>
Date: Mon, 16 Nov 2026 16:48:47 +0530
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
Subject: Re: [PATCH v2 2/6] firmware: qcom_scm: Transition to ICE TZ agnostic
 operations
To: Eric Biggers <ebiggers@kernel.org>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
        Sumit Garg <sumit.garg@oss.qualcomm.com>,
        Selvam Sathappan Periakaruppan <selvam.periakaruppan@oss.qualcomm.com>,
        Basant Kumar <basantk@qti.qualcomm.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20261111-ice-migrate-tee-svc-v2-0-29d19f6c92ab@oss.qualcomm.com>
 <20261111-ice-migrate-tee-svc-v2-2-29d19f6c92ab@oss.qualcomm.com>
 <20261113213403.GA35210@quark>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Organization: Qualcomm
In-Reply-To: <20261113213403.GA35210@quark>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDA0NCBTYWx0ZWRfXzNLDT67ptzlS
 dVjFZKW/cV9s4AkM099+an4EVz9A5X0uGvu6Qp+jmsUSaN6AkGE5TeqEzcQukHXw6ajajxOvvnS
 vy3M4D2tTiAOCGmUqfZKJ/U1gjrQsK4=
X-Authority-Analysis: v=2.4 cv=C9N8WgP+ c=1 sm=1 tr=0 ts=6afae69e cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=mWdmoYhiF-GBnKHWv5IA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-ORIG-GUID: -9lbLSsVMYRXRUW1PbaQY30QM3qTo3z_
X-Proofpoint-GUID: -9lbLSsVMYRXRUW1PbaQY30QM3qTo3z_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDA0NCBTYWx0ZWRfX7mc/LSc0tSnn
 tSrEMwfZbH2AN9VY+gkfmZWW1s0dWbvQQokVinnm9nCwY5applc3PLeECq8maAyyG+e/R39rFYJ
 rj01sbNACkIS8Z+rsSVHujgrGhKlbcOPPdw4RBtjt03kbtVEUGrJkjQ9hGYnFQPtBNI1K7nFphg
 ZIQLpuDzIbKDXjN3ZXFu0Q874B+5HeXXWWYm4ST0HvgS8DaRa5Pd5qbiakAzJ7VMpnnuYw9j6UH
 pk54KkT7KU4cqvtdNZ8b8etTnStoI/jaUa/CJsrIXCLrMV+y3zCSCc7D+Lp61he9oZKH4b+c6pD
 72Y5ArexOcVe79/IV/ATimq12Mh3ukR2HFEObVHhRy2AB/9QxPp9Nk8DPs/y9ciyc5nt9vC02HS
 SNRBma0NTCwXmsC41BFKFq/+68kheCwCRCRjWE9UldPKjrPJ4Ocoa4xLZjTOynHgUsrrqgTgGRZ
 V+C0CoxjDNRIPYHyH1g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-16_03,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611160044

Hi Eric,

On 14-11-2026 03:04 am, Eric Biggers wrote:
> On Wed, Nov 11, 2026 at 07:47:02PM +0530, Harshal Dev wrote:
>> Transition the ICE related SCM calls to the generic ICE TZ operations by
>> registering them with the ICE driver and wrapping them in exported APIs
>> with the same signature.
>>
>> This prepares the ICE driver for eventual migration to the TZ agnostic
>> secure programming interfaces once the TEE bus based back-end becomes
>> available.
>>
>> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
>> ---
>>  drivers/firmware/qcom/qcom_scm.c | 131 +++++++++++++++++++++++++++++++--------
>>  1 file changed, 106 insertions(+), 25 deletions(-)
> 
> Wouldn't it make more sense to leave qcom_scm alone, and have qcom_ice
> decide whether it should call qcom_scm_ice_*() or the OP-TEE backend?
> That would avoid the circular dependency between qcom_scm and qcom_ice
> which this patch introduces, and eliminate the need for patches 2 and 6.
>

I agree actually. The QCOM_SCM and QCOM_PAS already have a circular dependency
because of the function pointer registration approach. I guess it is much
easier the way you suggested. I'll try this approach.

Corresponding to qcom_scm_is_available() and qcom_scm_ice_is_available() we
should have corresponding APIs from the OPTEE back-end; qcom_tee_is_available()
and qcom_tee_ice_is_available(). The qcom_ice_tz_ops_(un)register() can be dropped.

Ack.

Regards,
Harshal
 
> - Eric

