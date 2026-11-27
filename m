Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795789995;
	b=19EqcHPlB+bAwDo4tY00DOq7KJp2Qf6ysCr+8WPcR7xSXWW4IDXM0rErJVq1m2qyR34U
	 vZIhYJy2nzeaYXzvSSYkdlHFUeiWmjtlBPdhZjC0CVubxJgXPHty997Njs4pZ44/NS/TP
	 yy2kUoC4TFku9lmGmwbtRV3ekU5WbfNEq2dsz61G2BRxGpmgUrf4me8Wwl6YM3/SFpXWj
	 76Erzp0GEjI01pRXjykTlFhEOiSF0B+HBKrL0gy+gdn+SuLrUa4cmHOqFt11T7ud73Cj+
	 cnO/M4wPdQpcVH+v2v6qQmPn9aNx9Aqs1+oEVAMegO1emrhRfOOWCfewJmxxQnvLUWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795789995;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=iWP69hNRNmZLA6SelaeZpNejkx3pRxxJb7FKwEEnVIE=;
	b=LTen75ZZoiuLbQPpQ5CkYofL1XAjSnHEN9qwOFZbHQzEQp70+enpBWPxOicAg4B0QuXY
	 tcVAwT4pm37OTdG0B5O/+vxUYLo3h3c0Ee8EiX8dGmK7/FJkh0EcZeb8KXYw/LgYYOwIE
	 H31vvRAVfGndLTrjrTLWZWtTIygyvN+iHuqSv8Pw2Pc0I3baYVuKOZEyVxGdBSKJYIkqj
	 mrDTbVOp5thJyJKvyjhTsMSimUQLmndD7yRW8RdBb1xxqA1wzXIFnRMjMwzisVtQBf9CI
	 AE55ZseMSkszDlWhTbLWDjOD1mGDTs/osfBPCN1BUWkBAL8emITCYJ+5g9N7q1gT6bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=HMNucjW+;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=guoj5dBg;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626D8606A330
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 14:33:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 626D8606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=HMNucjW+;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=guoj5dBg
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARE1HN92683919
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 14:33:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	iWP69hNRNmZLA6SelaeZpNejkx3pRxxJb7FKwEEnVIE=; b=HMNucjW+xDb1S/AB
	Y9ZczFPd/ZYrE3A2AJ/8Fu/KLc9r8wkpQ1maqb/nTeWTQiKpURMtVpjzAmorngu6
	1Gss6J+nqHdibemuvtvF7+5yVSYZoz1stcwgOksirfcySiNYRSKBfk4YdrhcaUqK
	+e7BAN6YQJWNwj3xOsAWgTmFh0hIk4MUr9EgGsIueX8bVMxB8pIUTr3AIsABPdQU
	zlFaj0b/earxKA9LL5j1Av/ZZetrhd2da4RxjAKFbbECl8+1UJQt6psQZfwiFxF6
	VbBySedEHFpslbxpY1ZwC4SYyw3c6dkVRYA17OKHF35JFZQjzL7g/HOvXUPfO0fI
	fzEMLw==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4j73uhj24r-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 14:33:13 +0000 (GMT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-92137a593c3so10537586d6.3
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 06:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1795789992; x=1796394792; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iWP69hNRNmZLA6SelaeZpNejkx3pRxxJb7FKwEEnVIE=;
        b=guoj5dBgrHSsIJp+Jmu2CpwoKGM19tObEGPQNiXAjRHv9AcBilHEdSi2H3vnVyP2cm
         U4hFV1QmBrQOgPe7XmAY25FybKyWvai+1g3olEqaF/vD320CgcvBXDvHPeLZllJsx4G3
         Ih7buufim0uFZ/ENj/wwVr6Ydg2/icNt0FUy2WRpBVZmh1NGoRF8858bHg0AIRzyGXVA
         +cKU1R9tzhe7EFmzhcMJEukQNurm3fq2G3UoBlKlALDKpN7atJsRs0OAsHLqFibKQ0/n
         cFFiXp39OYXcXuKiarANk2J618+WHMK4k40P2ctihrjXGmpZWJuo3+XwcD4VugVKWNAw
         70gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795789992; x=1796394792;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iWP69hNRNmZLA6SelaeZpNejkx3pRxxJb7FKwEEnVIE=;
        b=sK8k6bmYkQUj29Nlz7PE/HpN+2sFM9nVTWEQLapohkF4ezf2Mj0KCbhA/e8wUxyShJ
         yjggbpJBKEkHi57GIVeU4L5Lly1l5qCImOzdiBmKGJ1iWBmuurotfG862zRrQ/1/N4dt
         OZ7ZFtEJk9/Inb2Mk2VyDrWjXVdbNc5eAaCO22lPWZSpnacMYFUflED2Tk68Pn8FqgPW
         xijy998ZqUQbdfCXXd1PoY90iI/2BzMPvxuciu7I9QdhwFEXYvtwsEiFCgnlHyvsUHkY
         rWNHYmHsb0nGghGiuKI78twCX46SfTHEGj4N5RwKZe2S79BotyN182R+HgZvzbhNnC46
         pW3g==
X-Forwarded-Encrypted: i=1; AL+hErFukJNTNlgqb3O9g5pS0l+tVC6frfnKzME4kz0R5qngvPrsYLcbbgJw0jpX+0TQFxZe3PcLhQlsSxxyt5w=@vger.kernel.org
X-Gm-Message-State: APuU4Z8TCXY5OQQf4yJWY8PdKZtRl+owA6BfLJDUaFxKiqHcQ/imnnhU
	b/i4HqK9ZD0d9hXkHHJWflPuPDn9zmV4Zd/4W98n6IME6jl/No2xcRW+ylBu27C3wTM3UgyGKbI
	L3N+f7xFu1OXFccroFzLvpsgqb1XLFkU0lkn3SWsHr7slF2avrgLoejJg4UoihwmOg1s=
X-Gm-Gg: AZFdTZfpoU2YRM5PExV2/NjFDjUqXHhO2Ux3VwHYun4wu6nCA1Ehl2X+3dBFivYHN8J
	Jhj2oey05Ausjl0qAFc3JZ1eZixYRTWqyKuUlB1bVmPTRPZZ+TqtnP7Nw+p6DCoLuYppIJdkBwU
	p5voeeV0QFsdWwlE6r2KP5A/0T7hdyJqFtcZ0QBg4Joj4Txxp+v79qtu3dDRgTyWC+E5sIV9DFa
	Bpf3l4G1oYYrBck3Q1kVxW5pCO0NFsn4jT0P8+MpPtQzoOMuKtr0VahZzfmTDODIPVVVqtRhoHy
	XrZj/elDctVVs1N/S+QvjGxYt/DDhXMGERLFzoIr+IOrDO09oFgnzrTqTuAcT7fcnqJ1pPpm4kM
	OdUgm9PMz0hmAglxvqSIi5vAmAkwO1nnZgTX68/z3JpSpECTLztMoX0c3HT5vMytSXrR/gHc=
X-Received: by 2002:a05:620a:6e93:10b0:949:7fd2:6758 with SMTP id af79cd13be357-949ba68c353mr4128044485a.0.1795789992458;
        Fri, 27 Nov 2026 06:33:12 -0800 (PST)
X-Received: by 2002:a05:620a:6e93:10b0:949:7fd2:6758 with SMTP id af79cd13be357-949ba68c353mr4128039685a.0.1795789991996;
        Fri, 27 Nov 2026 06:33:11 -0800 (PST)
Received: from [192.168.226.72] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c513ae88143sm859572666b.32.2026.11.27.06.33.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Nov 2026 06:33:11 -0800 (PST)
Message-ID: <1ef797ee-131f-417a-b473-52e4dd965470@oss.qualcomm.com>
Date: Fri, 27 Nov 2026 15:33:07 +0100
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
Subject: Re: [PATCH v2 2/2] arm64: dts: qcom: sm8350: Add the inline crypto
 engine
To: me@fromdisposition.org, Abel Vesa <abelvesa@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261109-b4-sm8350-ice-v2-0-fd5e84985e90@fromdisposition.org>
 <20261109-b4-sm8350-ice-v2-2-fd5e84985e90@fromdisposition.org>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20261109-b4-sm8350-ice-v2-2-fd5e84985e90@fromdisposition.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI3MDA1NyBTYWx0ZWRfX78QOZRKTViJX
 mUzNmt//V1mKVtDmsbhVbAQM2lFJ8n9dk5U4S87KtWrJoicm6Ur3/D8aluL2BNZnqOGjIBrIG+w
 JnpUN1C0qw8GKFN9QCrT/GI0CJ1lh5w=
X-Proofpoint-ORIG-GUID: 5k1Rr7sh9SiFTuTBNjfcNzyCewOzRChU
X-Proofpoint-GUID: 5k1Rr7sh9SiFTuTBNjfcNzyCewOzRChU
X-Authority-Analysis: v=2.4 cv=BbBNQbt2 c=1 sm=1 tr=0 ts=6b0994a9 cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=Tt5JBQAfAAAA:8 a=R_l6ZAkWQ6Pq_YTnY14A:9 a=QEXdDO2ut3YA:10
 a=pJ04lnu7RYOZP9TFuWaZ:22 a=kpHMOrJS8sLNr5ru0mYA:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI3MDA1NyBTYWx0ZWRfX7pBB7mR8yE4z
 9TYUfQrNWg3JCAUfGC3oNLmyu/HpvvsbTjUqpJJvGFWtONOFBrLL0E7yoV1YC0EFocwNn9XiN/E
 KjujWZsfLXHHCIJhMQC6nuY5YsETTW7DJpIKUup5g6RcOYqDLWAudokyZKiCzOP7LmJjAYwT/H0
 GrQWDjaC8SDNBlE5+X+YHhO2/1qEsSBytCQL3IvCrrAJyVhwtlrJbFxcay2Bt1Qi7B4GCKToDIi
 f1AYn0F5m7tvDPMOeJRA4OgW8id6Li1lUBLH/+HwnllEqwQBlvcGzIa+oF+Bd7WmUBOAAxc6qGy
 hUPTqGKSWhfbOwnaIggBc791olY3MXacIu3wLNa6RlOZLFFQLYwHTyR6Ym36qvIKfS4SkQ1BJR4
 6oV1EckSYqPrXnITQ/EJuBQprgK2LHC4FJOL0+A3KHm8BEjr3zLDYo5ftpBNJqwIa67pusCkElO
 i4/TNpaztI36hyhbyYg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-27_02,2026-11-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 phishscore=0 spamscore=0 impostorscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611270057

On 11/9/26 2:55 PM, Demeter Barna via B4 Relay wrote:
> From: Demeter Barna <me@fromdisposition.org>
> 
> Describe the UFS inline crypto engine at 0x1d88000 and hand it to the
> UFS host controller with qcom,ice. The region covers the engine and its
> hardware key manager (0x8000 + 0x9000), as in Qualcomm's SM8350 device
> tree; it is clocked by the UFS ICE core and AHB clocks and powered by
> the UFS PHY GDSC, as on SM8450. Without it the UFS driver logs
> "Disabling inline encryption support" and fscrypt has no hardware path.
> 
> Signed-off-by: Demeter Barna <me@fromdisposition.org>
> ---
>  arch/arm64/boot/dts/qcom/sm8350.dtsi | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
> index 55b32050c..2b258c4b4 100644
> --- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
> @@ -1782,6 +1782,8 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
>  				<0 0>,
>  				<0 0>,
>  				<0 0>;
> +			qcom,ice = <&ice>;
> +
>  			status = "disabled";
>  		};
>  
> @@ -1807,6 +1809,17 @@ ufs_mem_phy: phy@1d87000 {
>  			status = "disabled";
>  		};
>  
> +		ice: crypto@1d88000 {
> +			compatible = "qcom,sm8350-inline-crypto-engine",
> +				     "qcom,inline-crypto-engine";
> +			reg = <0 0x01d88000 0 0x11000>;

sz=0x18_000, please

Konrad
