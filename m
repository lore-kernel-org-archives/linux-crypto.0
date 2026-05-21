Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61042367B8A
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2026 08:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779353155; cv=none; b=C6pxfJ/yRn+klyPAeIfDzBL0aecVC4A9EnRi3w71+1LGm1tKE2+pDZQeDMoZgy4T42wkV+LwOgwTRWbcpwikxARrn3W40qx5yveV50/g+w0JFXNnam1c5FwM35vql98WLuvGcT1NCygE9zB7CBCYV1vdgvV6ulfSW6YzKnBusjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779353155; c=relaxed/simple;
	bh=LI1P7U0gaKVb0FmucV8auUmJuUJiOS5F8FS12dF2UIM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sxsIv4xtEefJr7fehsiTCLrfxcYHiP8zSlhiFrdGuBGHd3dzzFIYDS0niKfTOfy7ZZzJnt6ondsXtYhhKBVtvjtkrq8c476CiBukR6dOLuL6WlLUE/e0OlMbRmY+9NtA2Ch1/KeT6FoNG5FWtPQGIuX2EF7olWfQtC6rV6gshAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=KpoblIp4; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Dfk8qgv5; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="KpoblIp4";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Dfk8qgv5"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64L72jc43050028
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2026 08:45:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	wJVdsUyX98YGeW/ulFXwxng+OTO4Vq5zgb/1dD/SbDM=; b=KpoblIp4FrCA7WaY
	V0aY174JYcUU4bEHOb41Z1Bp0vTX6wVHCNGVSD6LkHlJOKSlEM6pMyCchKMWcI+L
	/FNSpJpvJrPYTW2QcASurlNney0kg8k3i4HM1a1ehtm/ckxjrfjUZ/mbYitG93PW
	kTikwmzGWt0vQk0lL5Iq2AfhfxwguQDqEW8AwlkY7H8eBD54eQeleAGYZ6Oajzp7
	fyfzICeTNV+SCEiVwa+7W66AbpOAarA+WaB8kVMgt+Gk9mFFDoZl75iHWCWO4oid
	dva7CrlwIQtw7Q9S3DmKdpxHHYzFeXEni4Cv/aP+L0g+zR5bblIqcxaYUFqGvfx/
	g+VS4w==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e9wahrdh6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2026 08:45:53 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-36641fe4aedso11331414a91.1
        for <linux-crypto@vger.kernel.org>; Thu, 21 May 2026 01:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779353152; x=1779957952; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wJVdsUyX98YGeW/ulFXwxng+OTO4Vq5zgb/1dD/SbDM=;
        b=Dfk8qgv5hpROW86sINUAEQxJgcT+F4cvcIbOhO2ceBzhMK419m283sHyNIGASV3mqp
         1R1GOTm+OkDvS/an8UYLT4WLvLoDMbJeYn+Z/ncpSX5KenDGG+2TzUT0FqCMRcR3LsiS
         mKiAx0t/ybQkaGawAZryW/Aanwt390ElyMWdoa/DYEy94jZ+qBKIef3Met1QXy5L3EQ0
         97fySqxRl5ETCyUkwDUdprqhNRj0m7xzavUmIxCMM1bTwvIjA8uNnqRR1U4ZQBANrDpe
         ND79gjiVUzEibOX0pLHvUUtNs7WhcdAQmVx3Dzht4cI6DjFZMP5wbSrXXfjAaDFOJ7Fx
         z1ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779353152; x=1779957952;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wJVdsUyX98YGeW/ulFXwxng+OTO4Vq5zgb/1dD/SbDM=;
        b=X0cd0W/5x0c4ZckY23Tku5OU/u0X+a0ud5OyLAC5dTBd3CSlTobEc9Bvxw+xPuYO7o
         ZPv1NIDX0nxe5Tcg0TRp2j8oq36bXgij4UyvH5iWYhg2DPO+o4prryWcAKpn9SwqrDvz
         j7CJgmT6Ye/3Dpslhkirf5n/qe7Bx6sD9b7RV1uePcAmM60nSk0own5NHrwtBW3nOgLu
         FK4Ym4eEthCiESKuUusoaejZsTw9EfmGeguwZdNQBDaFbO1ecIsBfwMtTEqyBtNSv05t
         /JyOPgNxQhAxBmX0ieT21oWkMgDWgtkvfuuWjIzGt0f5Klg2Vii++y0+loE1lGjuwUyE
         +/NQ==
X-Forwarded-Encrypted: i=1; AFNElJ9PW1+0yGE1UtQHie5LbHt44ovrqZHRin8mn1aNxPp1VorKyPLcT4swjty5a+5ym5Ju5b5SPIFi1C4JGEE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0Wuj4iaunR6Vs1jyu3b5afwAcbnAwWGixb4XoXwTBiy7K02Qe
	YchDlYp+n/luVaO9Gf24Sr8HzArfiK8b1Ah1bremFDal9MxdJ/V8FH7qmWK1/9f4xLFOxkokO7S
	P912oVYJ/GTyjET76MHFgPwy1jZkMmR1++wmRFBnkqSXbpZ/jlEwsG8ltg6BO+AynTDw=
X-Gm-Gg: Acq92OHBF74PWTNlif7dREn/fshDUKRJPi2n1tjSKsdkBzP2gnuL1pV6CnhPY7PEEBt
	l/rGeOBmtZo+5vVwjb7dPncI9yxrmXVgAgfi3bkKTanIw4IxsU/ZD2227iI4ManmUbHw2xp1BdM
	ivcw3id8kw813LyjZLmyJcCWNR/k9yelqn5JpzC3hbs6wC+zVPIq/qh3i3k+wxJUIfLOAkbAQDu
	KKu+Us6SNd/+mQIVg1X8o1n5VW2Q8cyRwA19ALbG+fkHqveExmWGpZ3t1aAYUcEZATxlPMZ+HyN
	At9Sai8FA1xsk/bAZ5tfoXV+K/pPER9oMRbSyM0aEECbe96juKaohubwpJt0f29AZiQYJ6PWGuX
	I0ZhuGkpTBKnIfyAhodgROauOpT3wgzwYlfLSlNgPBjU4t/c6NR4Q
X-Received: by 2002:a17:90b:2708:b0:35c:30a8:330 with SMTP id 98e67ed59e1d1-36a43887a55mr2172288a91.0.1779353152318;
        Thu, 21 May 2026 01:45:52 -0700 (PDT)
X-Received: by 2002:a17:90b:2708:b0:35c:30a8:330 with SMTP id 98e67ed59e1d1-36a43887a55mr2172239a91.0.1779353151814;
        Thu, 21 May 2026 01:45:51 -0700 (PDT)
Received: from [10.217.222.91] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36a46d53ea1sm723782a91.4.2026.05.21.01.45.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2026 01:45:51 -0700 (PDT)
Message-ID: <57c26520-42dd-4159-bd2a-69874945cbbe@oss.qualcomm.com>
Date: Thu, 21 May 2026 14:15:45 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] arm64: dts: qcom: shikra: Add qcrypto node support
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Frank Li <Frank.Li@kernel.org>, Andy Gross <agross@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
References: <20260515-shikra_qcrypto-v1-0-80f07b345c29@oss.qualcomm.com>
 <20260515-shikra_qcrypto-v1-3-80f07b345c29@oss.qualcomm.com>
 <8dfa0670-7605-497b-9d53-db9b4a8a3d8d@oss.qualcomm.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <8dfa0670-7605-497b-9d53-db9b4a8a3d8d@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDA4NSBTYWx0ZWRfX9rOI0TgYhNZJ
 sZbtYWKCAet6f1YrQfqhZYD1fyVEkybf5fBVeG0F38qyQ19GX1xbsOkHbxzo0gTibSSQJo4opQQ
 Ymd6nGF+MKTppo3w2Kz1WsUffus1cHAcsw/rqGgartRNtg0imIlUlZBZk8OnSTjyivxi20YO5h/
 jqbkikVthBAiQchaLZKPqGT0oVNw6wrKqqgbBbfOlwQtGAS/OjGAAa7FV8NR66EO4Xgq+b9QkOI
 t4EzcsnDg8xeyItrrDWun8/6MLbUc/o+y/zUlhPd4wxkxEHCYaGg99B7I9x/bH9PcjSju5+YJ9H
 PgrpPRslGm4/IfIpHWqQe4sigCYAJykwex7eHrEBUZ+ZlBfnSj+4v+kG3wOqxLVhlhza8klG+Yt
 mDuhzDBjIMm+2gSWMU/dsl8Eb57cjKaqz46mb/UwTN0jMzB5AO84s6cliZobntASnCTUK4rxqFq
 ujPW2NqCaRwCiB9/NIA==
X-Proofpoint-ORIG-GUID: j0Fk1lO8q566rkD3zXMHGlC7p1PJPLB-
X-Proofpoint-GUID: j0Fk1lO8q566rkD3zXMHGlC7p1PJPLB-
X-Authority-Analysis: v=2.4 cv=H8LrBeYi c=1 sm=1 tr=0 ts=6a0ec641 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=FZn51bsQql4VyS6HqkQA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-21_01,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 adultscore=0 suspectscore=0
 lowpriorityscore=0 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605210085

On 15-05-2026 15:58, Konrad Dybcio wrote:
> On 5/14/26 9:23 PM, Kuldeep Singh wrote:
>> Add qcrypto and cryptobam support for shikra target.
>>
>> Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
>> ---
>>  arch/arm64/boot/dts/qcom/shikra.dtsi | 35 +++++++++++++++++++++++++++++++++++
>>  1 file changed, 35 insertions(+)
>>
>> diff --git a/arch/arm64/boot/dts/qcom/shikra.dtsi b/arch/arm64/boot/dts/qcom/shikra.dtsi
>> index 262c488add1e..dbac0e901d6e 100644
>> --- a/arch/arm64/boot/dts/qcom/shikra.dtsi
>> +++ b/arch/arm64/boot/dts/qcom/shikra.dtsi
>> @@ -541,6 +541,41 @@ config_noc: interconnect@1900000 {
>>  			#interconnect-cells = <2>;
>>  		};
>>  
>> +		cryptobam: dma-controller@1b04000 {
>> +			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
>> +			reg = <0x0 0x01b04000 0x0 0x24000>;
>> +			interrupts = <GIC_SPI 247 IRQ_TYPE_LEVEL_HIGH>;
>> +			#dma-cells = <1>;
>> +			iommus = <&apps_smmu 0x84 0x0011>,
>> +				 <&apps_smmu 0x86 0x0011>,
>> +				 <&apps_smmu 0x92 0x0>,
> 
>> +				 <&apps_smmu 0x94 0x0011>,
>> +				 <&apps_smmu 0x96 0x0011>,
> 
> These two entries are logically the same (SID & ~mask) as the first two,
> does it still work if you remove them?

Yes, resulting sid is same for 84/94 and 86/92.
Basically, the resulting sid could be same, it's an optimization which
smmu is doing which can result in same SMR(Stream matching register)
routing 2 different sid to same context bank.
So, 2 sid can be used even though resulting sid remains same.

Also, DT usually dictates what hw capabilities are supported and hence,
captured all apps entries here to match the hardware description.

I hope this answers your query.
> 
> 
>> +				 <&apps_smmu 0x98 0x0001>,
>> +				 <&apps_smmu 0x9F 0x0>;
> 
> Let's keep lowercase hex
Sure, will update in next rev.
Please note, I'll be clubbing patches together in one series as
suggested by krzysztof and fix this too that time.

-- 
Regards
Kuldeep

