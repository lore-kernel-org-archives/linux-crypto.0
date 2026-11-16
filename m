Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794812233;
	b=EaMvSB4KHqwhNSoc5dnMw/qZssPInT9EHUgTaDML2xJ77n4HLH7QVAUQZfU4+7NHPV45
	 U1aPFldz4BhnF9WvkoXT9TjHaEjPRgY/Bw6zgSeYV8q/mLrNC5SkZIx3vg+Y28Kd09sgR
	 c1udNC9e5FtSuoLXiQopzowAMPJ2PUG2UTl3QpLYoqGZn9L4iwxupSJa1h3oTz5t0oulQ
	 6ZHA+PLzDSzkqtm5YwrUawUIHesw/XWb+9g4mL+Mrt/T/3QJ2h5cmq8LydNG80MIcwYZl
	 ynEUIZMA0B8GIwHz3KeuusbhbiXXEs1rSJjdCKWyF7weT46KHAqhwv09fSu9H3J5mRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794812233;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:From:Subject:To:Cc:References:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=8kVbLa2hYPiQsN9qOzj3DO2zSgYLfY1noEtwJGDEPiM=;
	b=RuVZ1BGkt3JrGRn2D9Lcapxj5nwfhObudjNNuHhhj8SvVfG6jR7fvxTFWqecsgtFgiPS
	 Se5sznGz6MklEkAoH6OMcILIt9FfzjO9Y95GeAcBEIv2OWjmMUgquyJigHUs/nmk1A6EM
	 Au3W6RlodA5pZkDySCa/CUkmsGLnpRYUfniNs7RoH9ysoDVjVyQ+YMWS5yf3tGq/Hxh4R
	 IdYR8jfiv1osBnQimlVJunl+WOOUco3AscYHRBFlWv6L8Kw9Yr4b6mXay80eQcZppp8BD
	 PsBxrGT/6MCivo94cPbYcrE70cm50UqGbdWVRioM1A2jNt5jw5OY2tGVs9J8KDyC6Iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=FLCw5W7Q;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=BDG8ylHP;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7502B606A32A
	for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 06:57:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7502B606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=FLCw5W7Q;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=BDG8ylHP
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AG5LaRd214136
	for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 06:57:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	8kVbLa2hYPiQsN9qOzj3DO2zSgYLfY1noEtwJGDEPiM=; b=FLCw5W7Q7NkeVCGU
	yuUOnerr82EOmNUhiSOX2nGjnVGRAMsexFpHYCIfr3Ha51qinHKBh8x323+XYXve
	L9f67DnSziCuEMlxEr34fazeYbkYBDMGw9F4qZooZatHME8M02cujI/l4Wvt+hHM
	KD7wzIusA3EAA6SAAaQoMBDlWpxp4Xnf1nmTxGtagzqsvuniB4fb57OCA3fE1LN/
	HgpLtkLNQZBsO95/Fqedn6PPuyi2nfNUOcbg+Vem5TdgG3HJxaLB8b33/bHwisCg
	j1v6fIC6QPjQTiUQrx/pBdPjV3J+kRNcmXAY2s/873c+QJZZBMv9dwCNLF8UjlO5
	L6NKfQ==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hxhjqnbg4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 06:57:12 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-8b32efd7ec4so2920418b3a.3
        for <linux-crypto@vger.kernel.org>; Sun, 15 Nov 2026 22:57:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794812231; x=1795417031; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8kVbLa2hYPiQsN9qOzj3DO2zSgYLfY1noEtwJGDEPiM=;
        b=BDG8ylHP85zP3NraEzlVsFnSt/VhVC2pTmVrULFYefJUmRT4S2rHMjovPPgJ2XuY4F
         JJKlfhpDp+906ZcAbOQm7U/TS6CqfRjMyAUxsyMXdhc7F//V5tWP/GIOT9laFoQt42r+
         jPAwusWs1aG5w8Fc3L+yaQSI/wHl9pDG7Mfzt4CO7VrAZbA3+p7F3fcTl/OUgRlpUt3U
         /+XeownhoeAaFfvBY1nRVUJRYxC1Vv83oRnNNQNSzGZCTWV+xFSYqsght28QmfgwmGxe
         dEVgnyluBOUwYJJJbOrxmc1YbOdPyz0mVyLyD6/jupwTCwMaYm8By8nQf8ZAmNeCJom+
         tWrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794812231; x=1795417031;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8kVbLa2hYPiQsN9qOzj3DO2zSgYLfY1noEtwJGDEPiM=;
        b=cVi1hhiYKKxRtdkP7Ta+jfsj0jna3siMeuGIj5njbfzcc+Cycs/2tvXLLUz9jLL/Xq
         Dtqg0qZDWWEBs0xy1PC9TPV8dVJz+akl9Sb+4cW2LmohcnxeWBTTg6F/+3r+B4JSybUf
         nXgHhfOxxWgkPDbiPHKcE88ztwr2143toVMsj2/t3EsXKwRRhibpTYeI6Glbq9l+ZTCX
         MSJWmVyq8e/k2F/7Yx+07nGbHuQ+jZPPQ15XUnl98c9tllmiCEn7X6AJOG0jcyR3Rm/8
         z12jnyFBF3ML6SKyXcBiU+96wPIwvnpEbd3XN+OVCFe4RZ+B40s7qgO6dYApqo7cEXoK
         qwHQ==
X-Forwarded-Encrypted: i=1; AL+hErF7UlEW8cYvWNW+Dt6k3178SwlWBjrHhkw9hIa4JhQP/sTSG3jRPg1bXJj+pdCsrfGFDQlySrpnmHj0/60=@vger.kernel.org
X-Gm-Message-State: APuU4Z/ZCJp9sVhExhDSWy5EX7USXt1Sdd9jPnvWpycnSV2kvPhqZOre
	xGfljVeLCfTlRw4uKjxpm0RAeE547B5RaRgp5JqZq1RpmWYZN7AbWiRiua7O8OVILkOwbLfY8u2
	4njFYdOUvVbwXlxg/hQFMuDv8Ynb4ByH71zWJS0+L5eCKJi7xbiKqNPeHlY8RFSxQSCg=
X-Gm-Gg: AYBFou29QciX+zrm0zUosUuFt8zQnapTcC2a9UqV2fBPTQLOEaG9yUcHtQ22p5IBqyT
	4RgtphxCGjSJA3y5lpOL3g0mDOM6HCGY8ln6n9ekNFVrucErnYMn+Zf+dzlz+wxvo8YRT8DehPP
	m+cPasskI3qmHYneTG8RRsXwb1c2RQfjT6K7+mPnBZJAHgUY1Mi2/2ElvHKFMvFF6RDBT0Uzqa8
	Eyt2eP409D6NEabk2draLLjyHhFSy07mJiX6fO84pjNc5Tvuh587gClqWPZcdLPiRhDW/w67+YV
	yFzELEi+GjEAfddqBL4/cPfiuCVevZD2i2vIhfA782JwTXjovMo5zOKG6x7napGEBkfatmD5OV6
	0KDCdB1b7xkcbf4JsanB3hnQqpUSkt6Z5L1UgPAnFCYwzr6wQHV5ppfNUp4xtbaFLQ6mRmMftJq
	WTr3zD
X-Received: by 2002:a05:6a21:3405:b0:3e2:b15d:56a8 with SMTP id adf61e73a8af0-3f7a95f156cmr9720585637.50.1794812231417;
        Sun, 15 Nov 2026 22:57:11 -0800 (PST)
X-Received: by 2002:a05:6a21:3405:b0:3e2:b15d:56a8 with SMTP id adf61e73a8af0-3f7a95f156cmr9720565637.50.1794812230960;
        Sun, 15 Nov 2026 22:57:10 -0800 (PST)
Received: from [10.218.31.125] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cddc18c09fesm3754506a12.26.2026.11.15.22.57.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Nov 2026 22:57:10 -0800 (PST)
Message-ID: <304e72a9-2def-40c0-9314-0b7413e45e17@oss.qualcomm.com>
Date: Mon, 16 Nov 2026 12:27:03 +0530
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
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Subject: Re: [PATCH 1/3] mmc: sdhci-msm: Enable ICE before enabling crypto
 support
To: Eric Biggers <ebiggers@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <mkp@kernel.org>,
        Bjorn Andersson
 <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, linux-mmc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20261022-qcom_ice_pm_enable-v1-0-f7a84086c651@oss.qualcomm.com>
 <20261022-qcom_ice_pm_enable-v1-1-f7a84086c651@oss.qualcomm.com>
 <20261024182904.GD2553@quark>
 <172229a8-a4c5-4103-a38b-e4cce3f18718@oss.qualcomm.com>
 <20261113035858.GD1742@sol>
Content-Language: en-US
In-Reply-To: <20261113035858.GD1742@sol>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=KelHIgYD c=1 sm=1 tr=0 ts=6afaa948 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=VwQbUJbxAAAA:8 a=AalTVwZ0bjgfRv4LwVwA:9 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDAyNyBTYWx0ZWRfX/s7hEZoiFwPN
 dtc3D7ISfD6hf4QQSB1dTRnpZpcVAFwBwDphVT88PtvtXXrRc1A4Kq4f9Xt9I3f9d6bgFDutS9g
 KDzOlb4rVnaFvMcSUTwcT38CpGA26rg=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDAyNyBTYWx0ZWRfXxvJusPJAO5cl
 8c0j11RMW+ELrW3vfXr3UWhEgTPqlDZpVJgdstMluKLdQXcabrhDYlluekX2RknmSMRZ/YPlfD7
 /Lkq7p4hVhfZE2nF5++pAf44QsBx2bCSa0yFCzlw8f1RZWhUGEvPzra9lo4ZtHlUIKkzdTO/lXb
 rHETPaCnsqnd597METQnNwP4xwwVKTiLRxvCYpRei0R58ztb6ON480YqKRZesH3k9UhflRObZ0x
 AuW1V3WrpHtu00sAIriRFMAR1Z+lDhe8MXNqQWchw+nPvzPoy2KoKoYpj7r9mPc1Q0fbdRo/Gq1
 q5ursIR4x8E/SKxUH4FWEKlU211EPRIca8ZyUdDGN+of6Co3PqN9T6fOdz+l62e8+xo/1703XsF
 S8UL+ZBiC4A3DVaUDqyzlhxqu88QEozeqknpruSR+WAZEv1jSD8Z9s7R/72pa9W2S5vBf5Wf0IR
 e7YZb0upgw0OWNa6omQ==
X-Proofpoint-GUID: YX_IEDZ4k_m6SXlDhe9sAsZT1mzFIMGY
X-Proofpoint-ORIG-GUID: YX_IEDZ4k_m6SXlDhe9sAsZT1mzFIMGY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-16_02,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0 phishscore=0
 clxscore=1015 spamscore=0 adultscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611160027

On 13-11-2026 09:28, Eric Biggers wrote:
> On Thu, Nov 12, 2026 at 05:00:56PM +0530, Kuldeep Singh wrote:
>> On 24-10-2026 23:59, Eric Biggers wrote:
>>> On Thu, Oct 22, 2026 at 03:21:50PM +0530, Kuldeep Singh wrote:
>>>> Remove ICE enable call from CQE path, since ICE is now enabled
>>>> during SDHCI crypto initialization only.
>>
>> Sorry for delayed response as I was away on vacation for more than
>> 2weeks and hence couldn't catchup on the thread!!
>>
>>>
>>> This change makes the low-power and "optimization" settings in
>>> QCOM_ICE_REG_ADVANCED_CONTROL be set only once, during probe.  Is that
>>> correct?  Those settings never get lost at runtime?
>>
>> Yes, the low-power and optimization settings are set once and are
>> retained over suspend/resume cycle.
> 
> What about hibernation?  We recently went through this for keyslot
> reprogramming, and it was established that keyslots need to be
> reprogrammed after a hibernation image is restored.  See the commit
> https://git.kernel.org/linus/8b190e9c0b36aac5
> Doesn't the same apply to qcom_ice_enable()?  If so, this commit breaks
> ICE upon restoring a hibernation image.

Ok, I didn't verify hibernation with this change.
Let me verify and get back with results.

-- 
Regards
Kuldeep

