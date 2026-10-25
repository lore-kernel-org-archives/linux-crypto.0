Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792946824;
	b=XDUDPx1QEosvQEF9mJn4ULgSsMKdRV6DNeXsTVXOqcs5L9OWSrZtgJeO4IUeQYTDUWix
	 qHmIWy09+ljneWgUwjbGL/3dkP2pvqyjpuJLMoSoK+EK7/uRbOO78bBqVbl2l4cfMNX5W
	 kW2tAtosfJlVPzX+Sp6Mb6s6rVt26IARcK9YtIZsrz++woOLALHwSf2MSrB9CvnraEB3A
	 s85yo8q9FkKCAvWwbtb4t25Nm4pLbVhicPL77FbN2pf8Q4qjUQeUD3hL/ACNvX7jdqcSA
	 Zct++wY34wm4VEZPuCmg3ytV0pewlBf6eU+ZWsR4FLYMWiagQD6K2yj8EeHPwAEkesA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792946824;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Organization:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=Xp8FtUY4IDV5E4b4db6+noYAQseHMiy5uxXtnclLFYw=;
	b=KYPCv+o2UfNgqNYgNNE/byal8Deii0G6+i+hjTBcGKyqhYWOABsFvprnm3jFf374nx0+
	 Sky4GxiOVueNpNmab/RecdExpwM8QwrB1fF1eNi5dEEKKmaU4T2MRLhApXpNYsR5+TvHU
	 C+bz9DHLy5G2QozKlntM+U+XuzMCvMQ+JZEdZWJsToatKc3OAVZWyhukSVMCqzl3pfN4a
	 RZ2JJTp+AoqGnlkKyqoq6KWTXPOZeuQ6hFu2cALVsAvVsMMjqzToeqL8BDKdyQCzl2upe
	 cKyRCS0gHqyZCU9+TNFzrjB3vFpgEQFwAJmfDrgwTOd6CpUfpruht97DaOaEe1JEyuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=temperror header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=UGO8N2bE;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="Q/dOC/vP";
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970EC606A31A
	for <linux-crypto@vger.kernel.org>; Sun, 25 Oct 2026 16:46:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 970EC606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=temperror header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=UGO8N2bE;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Q/dOC/vP
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69PFkNDP660498
	for <linux-crypto@vger.kernel.org>; Sun, 25 Oct 2026 16:46:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Xp8FtUY4IDV5E4b4db6+noYAQseHMiy5uxXtnclLFYw=; b=UGO8N2bEPA/9WR8c
	pmMe02dkH2DV9moeXtM7rl+9ZfqhhixfOs7tUecHgQnEk5IdKQ6NTyxCwbZlX/qr
	xWN2nWbbEKp/HZhKIwGBsbQghnCCpf47jgWi4LvuhTEjyCk9fhdnBzIupfxeDZJB
	mXAxe/z0md1NQqf7eSVjc8bd4CHmQxbO83roBX4fGcVlQb+q//C+8bL4tcPtqgwE
	Oifl1cu/P7zcUJZURPT+Se390nt40wskyGlLRP71yD3e6GtI4gXfvXzfrLkfaHv/
	hTBPvN4AYXrxrGCy+IxewNXr9o+/xxyV7sD4zmIo5vm3rKvr5QZVn0lbEtuUoO0h
	44x2mg==
Received: from mail-dl1-f72.google.com (mail-dl1-f72.google.com [74.125.82.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hgj1pbt9s-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Sun, 25 Oct 2026 16:46:57 +0000 (GMT)
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-186c1aae818so8288681c88.0
        for <linux-crypto@vger.kernel.org>; Sun, 25 Oct 2026 09:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792946816; x=1793551616; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :from:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Xp8FtUY4IDV5E4b4db6+noYAQseHMiy5uxXtnclLFYw=;
        b=Q/dOC/vPOVDlRbtbD9f41Ahngu3aGU53HTSB2uTiD4/0WCtTSqmoe0FhXlp/bDG6Ud
         t0Oii/Nh/PGTftpKGCFdO7zIY9z2uOA0csx/qUeIctOgXOXOLl1WYDiazfD6JjWaijDz
         QP/nivL99wGJ/rx6WLRDGf+1WeLzWIAVIAE0ExbWoc4WyZKsbw/AeLYwIS4f36kxT2bq
         k1PpB6zRGffrkuT1wN9pzwr/uB20+mBnoqLNnchFvntuSDhWdeJ3ExRVX0FhIV9IJePG
         q9Gd7iL2Babp8BSbuWlmnNeOWSRxBaT8pk89/hSfqYbbyR9TBgxsJJv9QAZPVzhrLjDo
         hBUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792946816; x=1793551616;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :from:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Xp8FtUY4IDV5E4b4db6+noYAQseHMiy5uxXtnclLFYw=;
        b=bEPcVEUQ7JOdu/vC5nRwdxCe8UEfJwb+Ry1SUWnTVqz4wSDTnbSd6jvyALRM8wSS4y
         8VGBAKjDVDqG4NPeEuDjyLVfNizH/x5fS42dQYdHJYi/+A8UN1tu6IS944shnG1lrTQa
         FtiA4csIG20rJ1IVbCICahXpvORfPUTSUNjKB4HY8ScoX8F+yV7PkumZzNB08q7yRqHB
         qG1XBTEyTgHj7BuUpwzhzGbxsRuXXhVAEyelAbRhc/gyoTSDO16kF7E+HKntKT+CkNQT
         o/atLBUo56WeI/r6pZr1f+tQRuX70rrsAfJkhEbDFkuzP5XHoXNibQLsjXGxq9sJJsXX
         qwyQ==
X-Forwarded-Encrypted: i=1; AKwUvBxwKcb+P7YXdoO3f8Md2pm3DoaHbv8Zx/F5TN6VOETg9R2U+Rs/1B7+5mTRXTMrHKit/pC7C8QQx60GtKo=@vger.kernel.org
X-Gm-Message-State: AFq9FYJ3YDkAsIIYKGCEy1HqqkcGXYtBpHfi6z+FXGZdFM1t5SxoHM1H
	syAGC1LSVRoKRILskHgrkR9UrzpyY+PAjNtxAdJ5VCc5nO9zOLx16LdTZ1dBHbEEAczL9SaQQRS
	wn4nfotPssG511MG0jG/9s36iZAFuhIY9OKUitGEe71qdRZ2g4uBC92EUNxVWjszpyio=
X-Gm-Gg: AYBFou1Cy7ElnK8rEzklw/q7gsetRaLstdpRhxBPq57Z+bpWYjkXiXFWoL5tLiJq3vX
	A/RqzGFSRK4Jsr+qetrM41lYq71ynw+wsquSaGdh8bkxjJDquhyJKh1P0FQCK+6w9VrSgXwfH4q
	N4Eg3aOPy8VYBn7IsUexPoUOYRLa06ZW9ytBmvZDpqG43pWrIkWtsu7Gyn+Ht8LzXLeIyXkheIr
	w/sceZYuzr+VxI3PjkTcU0gMyjDXB4t6x246ugzvImlqDsMpKt0jmBUTHm3EC/YORWBNqljqUU/
	KQ6S8UGRWcXGc43yCeLTjLSi7TNOjZi9NVKYoa7Okg/EDR0yJIm0ALhOpNUCqMv4ai3AmJ6DBY9
	cubPWuh7YwDFLmgvpXA4ui9bOD2f9DA==
X-Received: by 2002:a05:7022:5f14:b0:144:de98:eec1 with SMTP id a92af1059eb24-1993571a23bmr6612001c88.11.1792946816241;
        Sun, 25 Oct 2026 09:46:56 -0700 (PDT)
X-Received: by 2002:a05:7022:5f14:b0:144:de98:eec1 with SMTP id a92af1059eb24-1993571a23bmr6611976c88.11.1792946815627;
        Sun, 25 Oct 2026 09:46:55 -0700 (PDT)
Received: from [192.168.29.10] ([49.37.153.119])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-198a249c331sm37712917c88.17.2026.10.25.09.46.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Oct 2026 09:46:55 -0700 (PDT)
Message-ID: <b5cc804e-0f73-4ec9-88bf-ef6dd04eea83@oss.qualcomm.com>
Date: Sun, 25 Oct 2026 22:16:49 +0530
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
Subject: Re: [PATCH 0/5] Add support for a TEE agnostic Inline Crypto Engine
 service
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
References: <20261021-ice-migrate-tee-svc-v1-0-b035be7aab0a@oss.qualcomm.com>
 <20261024185602.GF2553@quark>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Organization: Qualcomm
In-Reply-To: <20261024185602.GF2553@quark>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI1MDA2NiBTYWx0ZWRfX4cYwjhA3ohXh
 U1rVdRKULnja4Jxt0OEQyeSIUDH2ftcapeTTXKJZGSMb6ep3nwgOG3+2Jv2O97+BVI+EjBF6/gi
 qOybBjJKmFK36H8dD2JMUDiYJJmUoRM=
X-Proofpoint-GUID: VVZr12OD2OzvfQIN_XOTEqOwBxUVqxYY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI1MDA2NiBTYWx0ZWRfX5+y4eX35nB61
 CQmRpA/8l2VBzS/Gamm5S0E4C6b/hLgE6Nsj0k3PZiJjJiZX0nTs0VHo2oo1DzubIbIVDB+YvQz
 dXahywel/Ymd44wPSgStekPnpiOV0lncvCVHh0nYmrx+XmBxjfWwBx+MrfNGCvGGTRg5JDSH7bO
 d4j08RWE19jOUILjMJAOZK/uxFkktaP2tcgWXDGAGfte5phSOGEU0XSeydwmzC/l706WjlJ8hIW
 5VDLtybx3buVeqh/Juqa3aBU3yqn2sJsyX6GBsRMnNehGmAGtB3eteyXAetcHWkHD/rQsyf4DPg
 5d2IaEb7LoLfug6w68yDv68umUjf/51HjRZY0I0eMtzzZj2abee34tQEcmOUFSzqaqpRUtRG77j
 L4vM94NTpjcOU6nlPM06NLnj82+vsLq5krZQf7EYMOWCJfTJfJ7y0LeD6bcemhjruPL4pcesGtE
 6am7xTR6hHDSLukbVsw==
X-Proofpoint-ORIG-GUID: VVZr12OD2OzvfQIN_XOTEqOwBxUVqxYY
X-Authority-Analysis: v=2.4 cv=D5vSufRj c=1 sm=1 tr=0 ts=6ade3281 cx=c_pps
 a=bS7HVuBVfinNPG3f6cIo3Q==:117 a=hZ1hWxSZf3UX9FuxeSnJ0A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=P-IC7800AAAA:8 a=2OcuuN4x_lZ4hByzxpEA:9 a=QEXdDO2ut3YA:10
 a=vBUdepa8ALXHeOFLBtFW:22 a=d3PnA9EDa4IxuAV0gXij:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-25_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 impostorscore=0 phishscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610250066

Hi Eric,

On 25-10-2026 12:26 am, Eric Biggers wrote:
> On Wed, Oct 21, 2026 at 09:13:06PM +0530, Harshal Dev wrote:
>> This patch series adds a generic ICE service which provides TEE agnostic
>> APIs
> 
> There is already an ICE driver: drivers/soc/qcom/ice.c.  If it needs to
> do different things on different platforms, then it should be updated to
> do so.

Agreed, however this series does not intend to replace the ICE driver. It is
only meant to make the driver's calls into the ARM TEE firmware OS agnostic
of whether the platform boots with QTEE or OP-TEE. The ICE driver should not
do different things on different platforms, it should do exactly the same
things, however the TEE firmware calls should not be tied to QTEE as they
have been until now. 

> Adding a separate middleware module underneath it, with the ICE
> driver as its sole user, is unnecessary complexity that will just cause
> problems.
>

By moving the TEE call re-direction to a separate middleware we are ensuring
that we only touch the 9-10 lines in the driver which depend on the TEE firmware.
Merging this functionality in the ICE driver would substantially increases
the total file size.

> In fact the middleware module is called qcom_ice.ko, which is the exact
> same name as the ICE driver.  That's broken, as it's a name collision.

I agree with this point, I will re-name it to qcom_ice_tee_svc.ko, Hopefully
that will help with the name collision.

> I think the fact they have the same name hints pretty strongly that the
> functionality should just be incorporated into the existing qcom_ice.ko.
>

I beg to differ here. The ICE driver programs the non-secure hardware
interfaces of the ICE hardware. The ICE service this series introduces
re-directs ICE driver's calls into the TEE firmware to the correct firmware
booted on the platform. I believe these two are very orthogonal functionalities.
> AFAICT, this series also breaks boot on platforms without ICE firmware
> support, due to indefinite EPROBE_DEFER.  Choosing a simpler design
> would help avoid issues like that.

As per my understanding, all versions of the Qualcomm ICE hardware depend
on the TEE firmware to program certain aspects of the hardware. In-fact
a portion of the hardware interfaces of ICE are secure-software only
programmable. So we don't have any platform where ICE works without TEE
firmware support. This is why probe always defers if this check fails:
https://elixir.bootlin.com/linux/v7.3/source/drivers/soc/qcom/ice.c#L568

Appreciate your valuable time and suggestions here Eric. Do let me know if
any further thoughts.

Regards,
Harshal
> 
> - Eric

