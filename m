Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794237134;
	b=g5zVXR44K8Pe+igi6TkNb6wwY+9MMUV7MlxOTe258d0pODndN+r4W/6v0V1aV5t1FzoL
	 gMGv3IJq0xI4vxbe/gjCa+tQUDxsp+nptXwLH0WTqZ72B+WnJvKL6USm1jO90B0b8og8g
	 rrtTqlK2Wug/sTiQloDbHoBj+8vKrZ/aelbx79PmtsSvepKnSr4kf0n6oa+dTeLz64pB8
	 XsiWO+ZDdlVDLi49d+kU2iFX2AQFn0iRpl+7SLIx3nZ6gBY2T7lT0loBiOLX/utv/SH7O
	 p2U6AOkE/Qn8jJt1GVFLeQALSZHtZLm5s7TYbUvapYtrcYpibturNMb4uVz26BnCSbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794237134;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=PUsDu0OkTgaKjQcZBPcirXMHnRarKrGJneMxp5gNekI=;
	b=DbAH57ra3adb88/hl2nQCDOa3h5VVNzS3rFzTWTx8Bn2KIPMm47FMOt643lv0BZvLEQ4
	 OO4YkovGGiiAHrUXhLwjA89/ZR2WYppTJneiIRS0kDJT3dNdZSA7oau2LzZk+zwHO/DMh
	 1gwh4MEj6AZBvaWiA6jyJ77JUPhF8glX8WL4duMIbNB4omrA7IWSkOGw4oH0X1lLYvDrs
	 ci3JEz8C9ocn7yd/ITCMaMG65cAJNmfGykAyXGCFuNbbpzlZXE/XeTbIrG7FLVI0ihwpf
	 Ayt8bQiPMgRsG7qhci9mUIT/Jx3oE4SAhEVOtm5GvM22qXXVsjPdrrYfiSWuZtpPAQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=JVHA+WmS;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=WUYYhGsP;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F662606A330
	for <linux-crypto@vger.kernel.org>; Mon,  9 Nov 2026 15:12:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6F662606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=JVHA+WmS;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=WUYYhGsP
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A9DFISl359375
	for <linux-crypto@vger.kernel.org>; Mon, 9 Nov 2026 15:12:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	PUsDu0OkTgaKjQcZBPcirXMHnRarKrGJneMxp5gNekI=; b=JVHA+WmS28WTu51A
	alo4QMvr0WoiXI1XjKsBEXyVuK1q94o60sR1tEhkiY2tviOamIxSXbW2e4SvWI0B
	FTkucu81+2EXGVGJ5suaNaLkGLtqVzxKWtq5ruWvOOwNBDZI8/88FOsPRUA5JBHv
	JACpPjvZIITH3FJcqZnm9Bm/J0R+cyiE6IYGLJFK8oO7l309Hp1OjCX0HhYMm7Po
	btMjZ1ALCHvtYmQq86wiBt9nEtv5ydZzL5OQA1dARTOb2/BpGIxuc2TxWsSA0U8s
	SRIa4+tiSHSiIPRLKDBLsxrgw25FmtzCpVrDJlCpin4RqaRpkTqQZu+KTy5h/1ec
	MSZ0kw==
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com [209.85.217.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hu6x2j7fx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 09 Nov 2026 15:12:13 +0000 (GMT)
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-7d2ec12d9e6so18362137.1
        for <linux-crypto@vger.kernel.org>; Mon, 09 Nov 2026 07:12:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794237132; x=1794841932; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PUsDu0OkTgaKjQcZBPcirXMHnRarKrGJneMxp5gNekI=;
        b=WUYYhGsPiA/ayVa+my4xpBcBT9NANsS1eISAtEueGkqTfcjCrTD8rmcAZfa+h48tbK
         p/wUYPkbYxzWr6VDd49f05ohvvWg1ZNjD9cP1RgSsuT7xCpJZIUHgsdim4MfS8Fu60sD
         GkfNO77FmzLrkjdbUhjsllFjsIC/goZV0UM5ML/HoP/UHeD5vHLJ7fWeNTj03CUwK082
         ZIlQKx6+OXVMo1RJcJP01fE66S9iroo8AXF4WrGhxpqHuNkiIDzmutVi8Cv7y0oBcXk7
         EL0mOsmk2bJsVR5RLbAnCcTM8L71lTeLNXIymIT5mxUthh42EUKtSBsZ6+N4qAcNWtkp
         XVOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794237132; x=1794841932;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PUsDu0OkTgaKjQcZBPcirXMHnRarKrGJneMxp5gNekI=;
        b=yHfY8lpGbifzf7GqwpgIWi7E0Kxh2GHUaDHDqhuYCMq0b8ZMxIUKsPQtcODrClt6P5
         EiGxwmi/5LBWzxOfzKuqcYKpZKcHYbneyTs3TI7IKXSsU6qyoVL+ykFA26oDM9RCH6gF
         XDpnb9H5XUDangrKN7XF8Er2d4waotdA/le7b6My4Z34pUb81ifx7w9HwJ4Gd/PwKm1N
         sI+YM+Pu4TisyO9FUqE8VQpFQWvHYstsAY1C9jtsaCLX0mQ8bfDIAO78Oa087ukXPxYg
         WS8ci/Q5J/oZ6wp+IEwV8sj2YJGbfC/YP/NJmnhjvhLGaUDV7YSHcMLA3zCEsmURSwpl
         13wQ==
X-Forwarded-Encrypted: i=1; AL+hErEefw/aOhcN5+XrgzoDqvpfZLfncIufKjOaOFLNjtTP8lHpiX2KVt9u79rypGnYC0i1S20RP1g+GK5BmzU=@vger.kernel.org
X-Gm-Message-State: APuU4Z+iu3Ch1S3BKVGBbyKaRhEB7Y8/Ny5HRNhLDB1RD1LXM6jQBFsG
	Zy/bZXJnJPmA0FqV0lQDhkq2uSfGP2MhJLDeF9nkaJL8HsFkUIt3E2Jwu0bNlQyx9vb+hgWp+PO
	wcJP6No7BO6t4UR+BrUTqAh+qtbOIiN6LkPBz5beu5w9jl8JnuXvM+Aly4XIOqc1FlsM=
X-Gm-Gg: AYBFou360XNm6PVmurJdMIZnQlR6RnQi/J8RSv4DROY2NQlqgKbUeKv0Xg4xaaNbkST
	hgbBY7IvIny2lHmaf669SftXdwqM1e3VTgSk2Ff58L/BKnUPPTpJH5GdfI5b3WKDS8M7Mz4BxZY
	wCfWdkBikn07LHS1GzTUPClWp5Cu3aTxT5V9+mM9klCQ2pIoj7ohqkKdm24jBL6ZsC3fg0U8Ig5
	S5qFdbqw21ygf1BFZV47WoBVkNt/BFOd0hx1ghOj9KWaPMCr2M8wVLi8P4Au2W6zEZfxhjpZKnp
	fialeBo9hrmDXLjiV0OMBuiGJbrD9FiU+9AgS3aW3MsTX0FT/RUXuIuHVC1LcSJjqcyVb5fpLOE
	dLekQZIUemml3uZA9zhapJrnS5BT05NDsfWo27LVY5qjq4KpXT5NktsOEofc9Uthzd9YzfA==
X-Received: by 2002:a05:6102:301a:b0:7cc:1137:9d98 with SMTP id ada2fe7eead31-7d2da6343d3mr1229115137.0.1794237132503;
        Mon, 09 Nov 2026 07:12:12 -0800 (PST)
X-Received: by 2002:a05:6102:301a:b0:7cc:1137:9d98 with SMTP id ada2fe7eead31-7d2da6343d3mr1229073137.0.1794237131982;
        Mon, 09 Nov 2026 07:12:11 -0800 (PST)
Received: from [192.168.226.72] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b721ed95desm1765456a12.26.2026.11.09.07.12.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 07:12:11 -0800 (PST)
Message-ID: <3ddaacfd-59c0-4d87-9b8c-2caa85143393@oss.qualcomm.com>
Date: Mon, 9 Nov 2026 16:12:05 +0100
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
Subject: Re: [PATCH 17/17] arm64: dts: qcom: Add Samsung Galaxy XR
To: Stanislav Aleksandrov <lightofmysoul@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Robert Marko <robimarko@gmail.com>,
        Guru Das Srinagesh <linux@gurudas.dev>,
        Thomas Gleixner <tglx@kernel.org>, Radu Rendec <radu@rendec.net>,
        Lee Jones <lee@kernel.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Joerg Roedel (AMD)" <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wesley Cheng <wesley.cheng@oss.qualcomm.com>,
        Vinod Koul <vkoul@kernel.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Jhu <stanleyjhu@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Daniel Lezcano <daniel.lezcano@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Lukasz Luba <lukasz.luba@arm.com>,
        Georgi Djakov <djakov@kernel.org>,
        Sibi Sankar <sibi.sankar@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, mfd@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
        linux-usb@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-pm@vger.kernel.org
References: <20261109-halliday-dts-v1-0-289114ab8197@gmail.com>
 <20261109-halliday-dts-v1-17-289114ab8197@gmail.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20261109-halliday-dts-v1-17-289114ab8197@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=TMjQ2Fla c=1 sm=1 tr=0 ts=6af1e2cd cx=c_pps
 a=P2rfLEam3zuxRRdjJWA2cw==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=pGLkceISAAAA:8 a=Xzw-RmQiYhs1fFvV6_MA:9 a=QEXdDO2ut3YA:10
 a=ODZdjJIeia2B_SHc_B0f:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA5MDA2MCBTYWx0ZWRfXy9MhTDnsQHy/
 RLp/pYPVIBg90gyJp7A9sQEGkQxrt7QlnFohibLgQ/8/lvniD0pX1xIofG9SEp6g/u2sukZiLXx
 MEKfenDYxOVliPO38kCYBTEXgn9KELsHW8UEdaEaw/RAzxIuf6lKRKeN0oWpxCzlOJ6nhPCemPm
 AC61cdVn0UswVP8aHBbXbmmX8w56zgSb4axvFZvrDTJE4oPWqXAHXp55AmEOTAO/P8GilHcTu/R
 o30C6xsObbi8VgoPw3sfsF75xdHp/eEBgOm9QIwg5bEOpvofAgzzCs1X1JP42dDt/RQbzSWF4eR
 X6ry/DR9AzYu5C73XPIlyPR3EJTGDh5OyjwpZWusV/rHRsXBCfVW/1bqcNAiIXAN23gfxJ0SyA3
 jk9ibntkNOdcytd3h0xfOyaFgLuZZS6RMIyrWMQQGEGzrrLUvP/BZtFX7ytETWLApUcOFSz0/dn
 29lIQz/IVHChKXuChpw==
X-Proofpoint-GUID: Bgr_tlWYOQagHowOzrGFqQR8ACagIxEA
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA5MDA2MCBTYWx0ZWRfX0BQsbOX+mZMt
 IC/3UQAtLmok5qLoBe4aqxgBEJJJ3MqiAGGj5W8nsyyRdLyOc6Wl9fm6JLkjk+s5kbJjxhJBN76
 uy2mPf43YEb2vuJHNpTGxKriO0Fv+dQ=
X-Proofpoint-ORIG-GUID: Bgr_tlWYOQagHowOzrGFqQR8ACagIxEA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-09_05,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 lowpriorityscore=0 clxscore=1015 malwarescore=0
 phishscore=0 priorityscore=1501 spamscore=0 bulkscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611090060

On 11/9/26 1:33 AM, Stanislav Aleksandrov wrote:
> Add the device tree for the Samsung Galaxy XR headset, which is based on
> the Qualcomm Halliday SoC (SXR2250P).
> 
> Supported so far: the PMICs and their regulators, the power and volume
> down keys, USB in high-speed peripheral mode and UFS storage.
> 
> Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
> ---

[...]


> +&usb_1 {
> +	dr_mode = "peripheral";
> +	maximum-speed = "high-speed";
> +	qcom,select-utmi-as-pipe-clk;

Is there no superspeed / dp altmode in hardware?

Konrad
