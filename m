Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7F94119E1
	for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2026 11:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785410142; cv=none; b=mBJF0iMji3XWsV6a2pngS/Y1pqxci1d58Bom56rnFhH7jJ3ZegRCr+PV0l4AYnGgncl/U75D+Gdkp24uszSrTnVy2mDm1YT59zi/24RBjRw3ui8iE17saKy5rapcBMgZ3gktTY0midpis3JSAkx7WnNh+aApBDi/F3B4zOFPPHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785410142; c=relaxed/simple;
	bh=HxygEP3KyT2jE3JWmEc9bGZAJMJ1SLMYbbZEa4ZA9Kc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oLZm9TFZWxGlk0huJSGIelI1MUzwX8vR4PHg74YF9+YH5DmV6MuhH6N9BHt3wg0IHG0gsMVIQqKHWfjqMihVUD+6/ygp5pOU3da9Ee0pSceUTVcgt28JnmnktOZxhtOhoUwmQbuGMU+TO7kxmdraTBk3rYFgjApxFQW7HDYzalk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=h5zzTE5I; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=kY1av34a; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="h5zzTE5I";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="kY1av34a"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UA2dM14191524
	for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2026 11:15:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	yayerd7KpbuNuMSIUfVtN3koai+QfjdPNE9Mq1gz39k=; b=h5zzTE5I4I2O3mTA
	cbLmYykTp9Ku6e5Fmm8L7Oreu3ps+EkVp0of7zbay/LtewzAuOJeyOTBuK3J/VaH
	4PF/8croEJX0C9JSR9E2ABdtJMpxTnDBdFnSZKtVPgJ0qMZ4z4s62g7VT5dH3GYx
	ydjefX3IspqV7JB5vom+Bii+4Xa0bltRUBWGEMRQLDLrj7BVbx2ZMwbXXgeK2wU+
	Yf7FEFmp429hm+NKst29fg+kv2ZhC0KOJcVqY64ITSZfiNhCP9034EiBAOAb+QIV
	IqyFlu2NQuXAWfyhJGt+CF33sXmv/9VfFyWAo1ap3Z1rlCyAyPDJhWRXagNkqS9l
	6wFUvQ==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fr3tygg37-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2026 11:15:40 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-930a312222dso19986685a.2
        for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2026 04:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785410139; x=1786014939; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yayerd7KpbuNuMSIUfVtN3koai+QfjdPNE9Mq1gz39k=;
        b=kY1av34aBIaFMqzmwEmHsD/jdjDHAJJClT3po3dIwjQltQLf4FK1IES1OY1CFleEPH
         no5wkqgSu2ACDxCfGPtfT2cKH1dv43Fwy2U/62+VvKo7pIpQiHmjTnh/E1TLmrbzFuAg
         f/deu3MZ2Qs0nkC57E4V27zvLFIoDuJpPs+EbceYK1XWdsvC8Nq56sAtf4Zwa6spAcSu
         sLzU3H+qFzMMO4Su5oVY/J6lpLOefKWuqgnXsautjKMDMK4IWRY3IgyVJCrpRJarRR3H
         HAhFVCBILOaKwFWqNSzRk9oQNAGhUvWfkvusu9P+sAwTQ3Di6MQRYnmqJ+11JVC0Zms1
         zG9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785410139; x=1786014939;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yayerd7KpbuNuMSIUfVtN3koai+QfjdPNE9Mq1gz39k=;
        b=kjtNuxi12cqKTDzJYiStbFJHNMherr+m2F6vgOA5+450NBjc4O+TjA/V9Y4UQ9SQbr
         nx6MrN6sX6Bqp6bEX7zPuLC7uO7iXjQ4MhLlDURjSZX5QRJEXwiNLHqdp0M3aY4dMAac
         6xNB35mEz6JnKH7Fs2UlEjNHE9YiGyVIOWp7ctcysSpN80aUM+033Quo2Zc+caNYtH/A
         kjRfagBY+JVfcerg97yul45EjtEajRlPSev/RWyQt4D693bSalAgp1IgzN8+8UZBsnz+
         aovOYnlbgSV8QWwVGypzOfxENEYJ4S5C0mITRc3VhuswTYeBODwa/7hbnhpXlhb1eGOc
         egng==
X-Forwarded-Encrypted: i=1; AHgh+RrGYv2OoXCtMRwc+A8/1NdtfGMY6N+uHALkvIRs0lcjlpbdFEjxGLe+Uv5ZcpYPgxsASDfGkeloKaO4luk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxd+IPvV4Q5epPrJhWJsLo5PvR0uphB0DzoBfakKjz40a1LMwDr
	fmpwRDhdyEB/O/dFfeXMp53Aa4QHd8J2gx2wcHOBLsTZTN7ZVx7mQdhVBTSxKTV1qpN6KmyaVJe
	9Ru4plGsbfVYQvSUbf9bbPdKpiqIRkBsCgbLRLhqNlPuT8w+XON/qZOKXsg4XpvPKpxo=
X-Gm-Gg: AR+sD12cGEaV6XxCt72kIBWv+u2xyzQCuk6iXPA+IC1AeP/uv/ip3VFcZfPSODSba0c
	Y6nI8zGvSLBh8PUM8ASi++go63jR+rXxT1RdwlN6j307PL2Q438nf8GK8VmXEYKxh+pAFUCxfPk
	73fA0fU2cY/qHxRvIikFn1Pn0i2Q6QlB+8sYWN3/A9VpJGPm09WFO+PkpaDvaipyQNhcNVlIaVH
	4lOoiqw0n5qBONVX2Q/mGswPVB03SAVC92XX7EFbEeIMIIC9/fdIvtzgcjTGhbHrSPdYR/HeF/M
	b07xDe70Jn/wPwab/z4hYvdn4DAb4MTZXAEVdYDxySugJTfXLF+wnCUGhL9sX84HRmPmnb99iPx
	zIxG342dL/GzLjA0MLv9WPB23
X-Received: by 2002:a05:6214:248d:b0:8ef:4749:b1c9 with SMTP id 6a1803df08f44-908348e1e80mr33531376d6.5.1785410139525;
        Thu, 30 Jul 2026 04:15:39 -0700 (PDT)
X-Received: by 2002:a05:6214:248d:b0:8ef:4749:b1c9 with SMTP id 6a1803df08f44-908348e1e80mr33530766d6.5.1785410138930;
        Thu, 30 Jul 2026 04:15:38 -0700 (PDT)
Received: from [192.168.120.193] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1fa85dbe43sm57334066b.27.2026.07.30.04.15.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2026 04:15:38 -0700 (PDT)
Message-ID: <a5e953b8-89fb-4f65-a299-37352d9f6fa8@oss.qualcomm.com>
Date: Thu, 30 Jul 2026 13:15:35 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: qce - Remove driver
To: Eric Biggers <ebiggers@kernel.org>
Cc: Konrad Dybcio <konradybcio@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bartosz Golaszewski <brgl@kernel.org>, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Demi Marie Obenour <demiobenour@gmail.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
References: <20260724141414.GB1876@sol>
 <CAMRc=MfU1egvJwmgPEN-GXPbz8_JL2XnP-LV0T2+jG-drfXYwg@mail.gmail.com>
 <2026072455-subtly-prayer-0a8a@gregkh> <20260724150932.GA6763@sol>
 <2026072428-ungodly-outsource-b20c@gregkh> <20260724155144.GA2032@sol>
 <20260728152241.GA4281@quark>
 <15904301-fd03-45e5-b909-dfce52449726@kernel.org> <20260729145520.GA1702@sol>
 <50d9d0e4-28c9-42b6-8b71-e75682b4959c@oss.qualcomm.com>
 <20260729171850.GA4454@quark>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260729171850.GA4454@quark>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: vGqzp1QyXpuNmoH9YIeCbr7BzU7ASam4
X-Authority-Analysis: v=2.4 cv=JZOMa0KV c=1 sm=1 tr=0 ts=6a6b325c cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=_TOfc9kH6lse8ksE744A:9 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDA4MyBTYWx0ZWRfX59jkydGdWoQh
 kyNyB9AuPcnlHvhTlq2835Ni/qntUMHEtFGaASsjpZxmvPBBen9Nw68F/ePLluqUlNMVRydgIPB
 Cp0YH8UvjFiVuSCkNsILGLXFr0nFj+DbOfqsKsCwW88uo6rugTMDbOCAxfqDN7pkgj48nXE/PHH
 zSvO4tuT0Xxn8IlJodCulczkMKNL0KxDWH/ey0YyJgMDpQThgw7Bb40hv1Ho+CsEn2cZSwF1FLU
 psfaK84OZYzovVCfnICgRMUHPNLxpYkIFSCeG1rIYE0ZroeMocu3WvoVZUwvmKNEObD7+3E5IhO
 NNu4Xrwnek8zq0zqrLnIq04eSCoreuY+8uGPzGTbskQEAFeXKxSYYsIu194Hr5S75GLQXXcT2pG
 /PsbofWbuW2W1C2hoseExgeFfimbFrI9WUfBCFVpUoRoIWzl3TxrTV4epZLn2+S2bRxhL0HJ/gX
 EdInheq8KczSItl5JyA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDA4MyBTYWx0ZWRfX3bcUk1+MZdFM
 TKVZo2AhVr01ecOglzwtd4soZUTs9RIKGKw4I5Q9sYXOzhk02m6xndUjlZRTHrqP4kZa49HclPd
 rNV4nmUVTOQhi0wlzoiiG0n/Fds7Zx4=
X-Proofpoint-ORIG-GUID: vGqzp1QyXpuNmoH9YIeCbr7BzU7ASam4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_03,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0
 phishscore=0 clxscore=1015 malwarescore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300083

On 7/29/26 7:18 PM, Eric Biggers wrote:
> On Wed, Jul 29, 2026 at 06:55:20PM +0200, Konrad Dybcio wrote:
>>>> Unfortunately removing it drains way more battery, because the buses
>>>> never hit sync_state and are kept at their maximum frequencies:
>>>>
>>>> [   18.021823] qnoc-glymur interconnect-1: sync_state() pending due to 1dfa000.crypto
>>>> [   18.029605] qnoc-glymur 16e0000.interconnect: sync_state() pending due to 1dfa000.crypto
>>>>
>>>> (it transiently also pins DRAM and friends to max-freq which absolutely
>>>> kills battery life)
>>>
>>> Isn't that easily fixable by marking the node as "disabled" in the
>>> device tree, or even just deleting it entirely?
>>
>> Avoided? Yes. Fixed? No. The DT is valid but Linux can't deal with it
>> [since the driver is gone]
> 
> If needed we can keep a stub driver that just disables power and doesn't
> register anything with the crypto API.  I can send a patch that does
> that.

I believe we (are going to) need something like that in the kernel
for similar cases, however I'd rather see this driver kept/reinstated
for the reasons Bartosz is arguing

> This is an interesting twist though, because it means the claim that
> people can just disable this driver in their kconfig to avoid the
> problems in it (which is being used as justification for keeping it) is
> actually false as well.  As well as the claim that adding the node to
> the DT file is "just describing the hardware" and has no impact.
> 
> This would also imply that no driver using this sync_state mechanism can
> ever be completely removed from Linux, ever, which seems odd.

Linux has always worked around various firmware peculiarities, so
I guess we're just continuing the tradition! :P

Konrad
