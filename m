Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.180.131
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793283451;
	b=C2ErJxLXIxF2u304gHEbT7oTLg8Yv0d0dB2U47i3hsARAQfpwAyCl5i39nFCRMkug813
	 ZcSdJ1ejjMqUi6BJS3pjLSVvqLke6Zk7HC0zNgxQDiOxZ7JWpe110bw6IPCtrD34VG/u9
	 FWh4xmA8dpTOTJrbswBItwEsdUUHDy2jFzzj/v+fj/HoJz73nqc1nbR+7IonTuNQ6VfM7
	 FRTIVHfdI4LAF2APYjmhspCZQo+HYOMb7pceMxdmz6JiXNsZu0VWJreAaML5VlzM4APR9
	 vv1Jrl1f37UEnqRG6IDo/l75wh442XGzXpB8wC9vrbAAB6wRQevZ0rYQ5CUOIiy130A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793283451;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:MIME-Version:
	 References:In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:
	 Cc:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=XePhe4mIyzoHuWMx1ZSPHH7Ab0CP3siwIwYmV+A8biQ=;
	b=dFkap2nweeGYXcu7pg1il4B6SL+gXByy9UQE96nQNsuC+OrHTpgvVOPXPRrimtd2up8U
	 qw9wYmxzI9xs1kmvZCY6AQd85yQt3xWvb08lY7GII/FDY14SdzcInpWgAizFCoIRM65BM
	 zuN/6TrqYKEMSWmMnJx9vyVM/+meBnQBw/wEMpGodhi7kuLOnMXsLI3h9dq1S3yURzMWh
	 KwFVZXi3uHtnDS3rIDIAIfNtpXVSqlpTeJ4HEo4OdB6BczbzfuWwqche6XVF+svmEKZ97
	 yWGWsEghpK38dG4nHbquii5CKo1jo4MX4VL8RDl8G248kpnIHsekXfT2bMlst1fV/Sw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=MQtlFtN3;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="Sw/b8bTs";
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3C6606A31D
	for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 14:17:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC3C6606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=MQtlFtN3;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Sw/b8bTs
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69TCe2XX3943866
	for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 14:17:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	XePhe4mIyzoHuWMx1ZSPHH7Ab0CP3siwIwYmV+A8biQ=; b=MQtlFtN3Sm1zrKcl
	CXdHmjk1+4i2GVB87eTjCAk2iZ8XgI1ju1LAU9fXlFhNV3lr/9IrVHRJwAFbmdkm
	Yz7HoDbI3x23yjz2RH8Y3Buc3UnPlD7fF/Ua3OZYZE3Q6G3I1mAxGmbI3ZOnuBy3
	eia7RL+aIosfPaxgTMXhqvIFStyY4pkAGFJOMM+U+SSBGWn6HtliMKf4PNqmhyFe
	fnPaDJzPbHlf5JWHqENY1GquhwD1AiQPuMErzzn7/YMg0dl8MXa+Cy/mnjFjGFeV
	QKy32Fe913pIGO8sJQKEwvtopj3vAplKqWNOyhSRzxFOIwTfa+59EEnBiURPWoSJ
	S55T+A==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hm42fgwwu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 14:17:29 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cd3b9e70f88so2520021a12.0
        for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 07:17:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793283449; cv=none;
        d=google.com; s=arc-20260327;
        b=Yx52q2dtiv+ag3ewpkqHdWOI7qbmW8YIUv4YChKrhNb6Dmic9lHbMzh90JvA84uH26
         QL5BX3qI/uYSfMdTh87B9jLYCRcXA8VXR0GvKMh/FiL/ARpfSzgfC2a/pCr7ZYdImCok
         84VejhmFHsbRdVJ4wVJkYKFDoXmkSPeiAopLOA99UnaNMbPJkb9APBTvfPTs+aWcDESj
         FTGf2H/oORuXkkBgVCcZO5aEYVp5MxK0ADLsMbA+Ws/Hy9L7Ga6JDT2UY8oCCp2A3Ixk
         m31XiMRLs5oReanhIrZiQzg1XtwII26vNI1DUxMRaxeVbON3UIJDYWhXQQCfcyB1tpWl
         NnHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XePhe4mIyzoHuWMx1ZSPHH7Ab0CP3siwIwYmV+A8biQ=;
        fh=+PBNJMk9O4/eAv2ad39GO6w2Vja9cnJ2g0wkmJsukiE=;
        b=oEDMqR25SlYFyri2Ug+RY6bb/sW/AOFdAmZeeiNLRseJVsMl0jUueBe/0A5cI+GOAe
         f/Rl65LD3pyGdP6PbVDxsOOkBdHNlFZgEZt+2Q481oBXCBhReMrlQrdObFrFPsvbzhNB
         /Xwnydf3r2FrX2MoRBiwIlASyvfLqfTrSgNe/qVcNGXvGJlyN1PzVxzIU594/smW9Ov6
         5yybNfZ3B8L9sHpdCXpF5Ynkx88Z7X5f5dCSvdOnNX2DjVVSAfZHHKJhsIRz49Ck0C6a
         ivHdpHmGGCAgckc7yw1yp6PtlX1EEC60KRNJtWfRQs8IspYQtYt627tOpqZCFXSuIJNT
         dtyQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793283449; x=1793888249; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XePhe4mIyzoHuWMx1ZSPHH7Ab0CP3siwIwYmV+A8biQ=;
        b=Sw/b8bTsQfxu/z+k24fBLGT07MMd7ACMJvRejrPM90Mr1uFqvVz16CsrSostXfY+eU
         iQZoq1Al076DAAb7Sv2WGFUUs5Sb+06UlXNNplNwuSV0RZ+avbRAKFBf0wZtrGaJPcuF
         jOL0yqyzDsgIkuQE3RuZMnpg5D3gWVYOxC4DelV3Fw9VbzUNdiKUSTi3pCxPAhau1IYg
         8COh687ecHXdvwQjXKfcfydzNMOJacKDJUV77XStTrqUobbXTaTjmAt9KHshYCIOFr/M
         kp99KYBINixmPgc+5RcfQ07HADZYh2J/S+fN/rATga7TVck/wS0LMmtXsUsxUJft4KM9
         V1cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793283449; x=1793888249;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XePhe4mIyzoHuWMx1ZSPHH7Ab0CP3siwIwYmV+A8biQ=;
        b=XytHg5G1bsn9znyAqFpD0fZYvcHuAHxFATJwPrF+iPqFu4nJ1ZayCMe6BjBrWIT4sw
         0RR4JIRJ6VdBoB37BngcjbO0su2SLtb3u1IsIGbw2YJw1TYqJwv0h60S8GmxJ5hkw/io
         b14Wy8I2oA9J6m1cqkPuZFc+F6QpM/zjikypiwiB53CCJ74w+3PTdhvTRRRs0NfIjJmQ
         DeP9zphlAeYrJJMnX6bHvjzKOGWpZ2m9M67PqDnlPCUsbltRsnDHKHXsemvs7M2SWIQy
         Itruc7Ph9purs/Y8TdNy/MmT6RVgy64QmmQw7F5zdu41OPCD6KvrcnDowmvbvBFxEltK
         5XHw==
X-Forwarded-Encrypted: i=1; AKwUvBwgL/u60gTcVkBGpEK45x9OlQysrGm7Lqn2+sUWP6xSuMRz1XafHgL9t2oalIPI+epaJCqmuyPrtaS78Ks=@vger.kernel.org
X-Gm-Message-State: AFq9FYJW625Qc9Tyf4LiNZdz/eEcPLfIzb25aXlhKf5Yc8/RIXcqC7sG
	rkP78nWTKjY6IpF7HTmNtpxpVem/c1g59mjnCNmB8TwB7kDkTl9EOao1Yd7L4B8WjyIeWfwkw4T
	3P6PBpa5pxE7a5fUflyC5pLAOibb7IuJOL54OAICyzcSsFNkR008hwCPl4ztdTPyct6qGAxcofr
	yQogW1QSpTZRIkiNdOwG8H3T40HheAN7husYZbZGyOzQ==
X-Gm-Gg: AYBFou32MX2hme7HcSShCcfoo1/k9A3wjxn/kn5oDXx0CpXluXo8PaOr2uYPgamoQhb
	vTyXPioZRFtcj36jSLphZ9iIpuGAckbZRP6VKmZiV5SIBT73DHPcGw4QF07079WsTcxSY5ch5Ch
	NY4iSrKgQRX3zgCQKCY53nY/JkEdoad5no7PBcj8H6LmTBCS1QFdMO//nY4A==
X-Received: by 2002:a05:6a20:6a0d:b0:3e3:1013:4665 with SMTP id adf61e73a8af0-3e90234d9cfmr5486419637.48.1793283448648;
        Thu, 29 Oct 2026 07:17:28 -0700 (PDT)
X-Received: by 2002:a05:6a20:6a0d:b0:3e3:1013:4665 with SMTP id
 adf61e73a8af0-3e90234d9cfmr5486382637.48.1793283448152; Thu, 29 Oct 2026
 07:17:28 -0700 (PDT)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261022-qcom_ice_pm_enable-v1-0-f7a84086c651@oss.qualcomm.com>
In-Reply-To: <20261022-qcom_ice_pm_enable-v1-0-f7a84086c651@oss.qualcomm.com>
From: Ulf Hansson <ulf.hansson@oss.qualcomm.com>
Date: Thu, 29 Oct 2026 15:17:15 +0100
X-Gm-Features: AclHuK-yG8GjI7p3wdC6k_i_FEVr3l0Mml-BhNjxuIZOPYfSt36zwQfp3z00yhg
Message-ID: <CAPx+jO_ywfJUAGs6Zo8yJyTpqui=qN-T9qqWN2hKCyeegAeF=A@mail.gmail.com>
Subject: Re: [PATCH 0/3] ICE: Enable runtime PM support
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <mkp@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, linux-mmc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI5MDA1NSBTYWx0ZWRfXy+RH/VYpH9bq
 cqMzUH65OiRUN/PHtnFlv4rz5MMkBLpRVT0+cnChNT91R/eMbjKbf8m3bg3UlCVcdQUvGRf1bjY
 hDvK9nbevB4IG9U0FGF8tlyFlfB1gmJ0iYsTJkAgvBUmV60tKULwKg5H4zHl0IJIuG77/Oxk4YC
 pAYmjKIpgSrfcHLYtI8j/KeURxRIQHTZ7dtwe+2cbk/v7Ti4yAtj5WA94vG/WElchU5S6Vi5ASl
 WycySuO6j9AcILn7aULZxsSTSYwNbEcozTcjpn8r0oNu3Q3wKm96Uy8DJJgB2RexDsllPPEzP2P
 XMBbd68SDMW/zKC3ETm/0c2nsbcXyMPxtltLGML63hlZIcjSk3iHtUXrniaxy5yYj/JqluGbATq
 eS2kOFQ0/DcHscszclgrbyjVhkk8uH3N4aBO76t9fBCiy1nmy41PhrY3NLD8506tKC2flele1e+
 +FjOw6GEVV3yWz+tg0w==
X-Proofpoint-GUID: yu4Csceq4Z9vWFOD9Btj5UgR49hPA9MD
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI5MDA1NSBTYWx0ZWRfX/cSxpT0dnLUR
 xr0U8Og9CO8fAXw/LOiLREugMB91R2ckVzJEwCOL2UODFE4NyPB8FoHq3QVHsPZXOKeJl5WeJYG
 Je7slA24wxorNmRLO5CzeFGkYgX2Wlo=
X-Authority-Analysis: v=2.4 cv=UN9Ijyfy c=1 sm=1 tr=0 ts=6ae35579 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=ZpdpYltYx_vBUK5n70dp:22 a=EUspDBNiAAAA:8 a=MNM1_axOnic6cDGTpHIA:9
 a=QEXdDO2ut3YA:10 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-ORIG-GUID: yu4Csceq4Z9vWFOD9Btj5UgR49hPA9MD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-29_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 spamscore=0 suspectscore=0 clxscore=1011
 adultscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610290055

On Thu, Oct 22, 2026 at 11:52=E2=80=AFAM Kuldeep Singh
<kuldeep.singh@oss.qualcomm.com> wrote:
>
> This series fixes ICE clock lifetime handling when ICE is modeled as a
> standalone device and referenced by storage controllers through
> qcom,ice.
>
> Currently, ICE driver enables clocks during probe and keeps them
> prepared after probe completes. This keeps the ICE clock voted even when
> the storage controller is idle. Add runtime PM support to the ICE driver
> so the standalone ICE device can enable clocks for probe-time register
> access, then disable them and remain suspended while idle.
>
> While enabling runtime PM in ice exposed couple of sequence bugs in
> storage drivers(ufs and sdhci-msm) as any key programming call used to
> go ice and never complaint as ice-clocks were always on.
> Example, unclocked register access happened from ufs/mmc in
> qcom_ice_program_key().
>
> qcom_ice_writel(ice, 0x0, QCOM_ICE_REG_CRYPTOCFG(slot));
>
> Fixing this issue require ice instance at early ufs/emmc probe so that
> correct sequence is established and ice is ready to accept key program
> calls from blk-crypto or any explicit storage operation.
>
> Merge strategy:
> Patch 1/3 and 2/3 are storage driver fixes and should be available
> before patch 3/3 lands otherwise will result in bootup crash.

Then it's perhaps better to send patch1 and patch2 first to get them
landed as fixes and for stable kernels, then when that is done, please
resubmit patch3 separately.

Kind regards
Uffe

>
> Validation:
> Tested on shikra-evk, kodiak rb3-gen2 and sm8750-mtp.
>
> Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
> ---
> Kuldeep Singh (3):
>       mmc: sdhci-msm: Enable ICE before enabling crypto support
>       ufs: ufs-qcom: Enable ICE before enabling crypto support
>       soc: qcom: ice: Add runtime PM support
>
>  drivers/mmc/host/sdhci-msm.c |  21 ++-----
>  drivers/soc/qcom/ice.c       | 139 ++++++++++++++++++++++++++++++++++++-=
------
>  drivers/ufs/host/ufs-qcom.c  |  29 ++++++---
>  3 files changed, 142 insertions(+), 47 deletions(-)
> ---
> base-commit: 9a482184d910775cf648863148944945b74e2815
> change-id: 20261022-qcom_ice_pm_enable-3c5d21b99e42
>
> Best regards,
> --
> Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
>
