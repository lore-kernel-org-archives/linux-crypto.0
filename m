Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123B12E7F3A
	for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 14:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774881863; cv=none; b=WzGtIo6g4RyV44gp/1kPchupZlMxknOTglaoSg1dRfHwSNM8eZtbJ2YHgltLIiaEhA59kD0rj/4CDk3ZqobdJ9vWfTA9NR6QqPbYRpMbWVIu9/PYYr4JVkXvQFQpEP6gDqSnkyuh/a941CYQy50qBme32N4sxWNubfU/NnVW15M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774881863; c=relaxed/simple;
	bh=i9+BsmYWeNxA3vL77dGdjOl5/ZZThYuLjCOb2eFSiq8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z5hAxFoxeSy/i/pBbUu2lMfxARucubY9HeSda2Kq9Thq8xqF0taYtlCm8Lc7mJnOu6K1H+XF+Z0k0P1tNNHmIp8nU5wrD33u5EaGqBsCsEsUhIKDQ3ipV3bMHINRQfAPwe/lytpS+gfthEzhRTdK/J5kA6TH+/cLrSEzdzc2sus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=AR98qoHh; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Q8hVSEU/; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="AR98qoHh";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Q8hVSEU/"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62UEDEPA1090666
	for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 14:44:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	MIP639OlwUQY/ZYHd3dviSGKSjGruowG/Nrh+/9Vwls=; b=AR98qoHhGydB1Pyt
	HA/DDuxCd7/Mh9ERcNVlPKByNrzU9yE9+nybLX0nXxUJOy9JwaJW2itHmPeY2Xpj
	eN/evKkOSWsQF/JlFwHV7SV5oxmBNMiJTXJmZCBijI0ejAIcewGdJU6UsSlDhmkc
	8qV172DQ9JMisb7jLacuXYb5ciYxMjRlTdxUtwh6k4s3Z3SBUww/g/UB6CCy5Pb5
	a9grxw60sPjIpXOR9KqbiRXY7ACK5iCIrqdVy5Gc4bvkwPk/KuoJPhZMcA2rC9X0
	ZLHa5gU0e0m5ok5Mz7EYnYhM6ushGYPrHXLPz6wb33YO+RSORn2Nvz9UYhPjS/LR
	LfJ2hw==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d7trd04tw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 14:44:21 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-354bc535546so4886931a91.3
        for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 07:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774881861; x=1775486661; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MIP639OlwUQY/ZYHd3dviSGKSjGruowG/Nrh+/9Vwls=;
        b=Q8hVSEU/drnCtu8wIvcfX0D3IGiqjXmlkT80tP3g2dnfnBnv9Zk0rUzG0mDO+jRGS7
         vYGFBq6EZy4Rr495DeZ/otY4XJ0+uNStOuozf3RjyaUYSFvqcF34/jYyLxEK/8LHRgnB
         coSEsMQCP8MtLXFIST6eWLUed6CR8CKDR1WW+vfX0k72Kz7hY1svGim1INFmnxdvcx8A
         PJLiFfkXKIer/tMijsI42X9pEn5cxPO9hBGziNpjLcRsU1DNELxGBPqUrKx2ktjSMfzF
         xqc0T9T5Zai5ATjnz/N44j9tNRgJRKgSeccv+X3BTCSkWtuIiu9tW/AEGr0EcfuacP77
         zRWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774881861; x=1775486661;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MIP639OlwUQY/ZYHd3dviSGKSjGruowG/Nrh+/9Vwls=;
        b=AegUfjzrYtCafM2q+trxYd6Ek6NvMflFt1MCaDADWYBYgOh+s8Dqt0PZ7P45BwNxTe
         Ecwe8rQj6JoBl9iJWWsLn5ECwjMB37hGcVYdU0jj1y4rfHgB0liJ5H7jGY6EJDHuC6OB
         HNw961qosGHJ5lRFu4UjHwf6tgRQz9Ov6lyWIy4MKoGDg7mEIY7huoCuWaooBQCSHgAV
         WlSmA2zPQuZjnGVrcnn4WIjCDhwGlv+e1JBFKYqNSkwl8IGqriibAB39uSpG7HkSb91S
         sk9tJGf/e/Cg1AJGV29VRKtaAvDWcISZKCSqE8CmFJ3AJhACNcr/orsB9IbYM2wwkPLb
         EihQ==
X-Forwarded-Encrypted: i=1; AJvYcCU5h7lyf7epUzpn+ZI+leQnxrO37tyznEd6XreKuBDT4ruYEq98Tqir5iM3/d8vzWPLL8vbvEi63w4TvWA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyk/jW5Y0+w4kX9iWajaztO4YRrXHbrJf7s5xH4KNbEp4I9kzHD
	7Sdehh7pnwB768uwEFE/Lr/6nzkkGDMd4q0ZgQQ3rbXfGmCx4+zBCmmYaF+mhDQy0yjLMDBVnt1
	yeCzBP73arVnVZdQ81gSJk1BqSs5vdNNUypE8cUHZBueZieSyziH7Lim2kq1kSMuS8cU=
X-Gm-Gg: ATEYQzxbYNw+RTrnJZbdRDgfHV6VBYnAhwWamYk9lABWshgwhf5ndUpAKtYeyxzsfgB
	qG2HywxA/aXE1K5O9kXuxGay8E1yvAmYc3v2MMl9B7O8/ELYkUEyb0e5Umln7PK8OdxoYN4LCd9
	7+gpkiVPgnpPHtRvRYhgklhAS1DXLyuuSq9E63Yi0x+WK84sr5gMMziMtwi0l01NoJMNmBNPQ22
	foF/ELk6aNDgga9KN+tGpYNCew2H92XHA35mn/AVQRrk4l8ersEm1cPKwkW9glw0G4TKPzhagin
	6H3WJXo3QTEsYKJWfuZKETHJtvHfRt6hgu1CeF0KHAE1awWD2KfZD61k0C+rzNC1bgR3bC3y0WE
	qRPioEDT7T4ZLVo5EqXF0qwsIxhh5y5zq887IChXuuEigGDbg0e4=
X-Received: by 2002:a05:6a21:328a:b0:39c:4af6:4301 with SMTP id adf61e73a8af0-39c87821730mr13239972637.9.1774881860691;
        Mon, 30 Mar 2026 07:44:20 -0700 (PDT)
X-Received: by 2002:a05:6a21:328a:b0:39c:4af6:4301 with SMTP id adf61e73a8af0-39c87821730mr13239928637.9.1774881860101;
        Mon, 30 Mar 2026 07:44:20 -0700 (PDT)
Received: from [10.217.223.121] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76916baab6sm6527687a12.2.2026.03.30.07.44.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2026 07:44:19 -0700 (PDT)
Message-ID: <90375d37-0440-48d9-a3d3-b0b442839d89@oss.qualcomm.com>
Date: Mon, 30 Mar 2026 20:14:13 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 3/3] soc: qcom: ice: Set ICE clk to TURBO on probe
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
References: <20260302-enable-ufs-ice-clock-scaling-v7-0-669b96ecadd8@oss.qualcomm.com>
 <20260302-enable-ufs-ice-clock-scaling-v7-3-669b96ecadd8@oss.qualcomm.com>
 <acF0ggIIJFb7mUUR@hu-arakshit-hyd.qualcomm.com>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
In-Reply-To: <acF0ggIIJFb7mUUR@hu-arakshit-hyd.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: sRCFZpqFHH80HFrmKSlgfL66lxrdEPgn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzMwMDExNSBTYWx0ZWRfX4V7yISfIgGNn
 3+Tr0hIrOxn0X9A7WOkB/4IrBHdnh/t0DVvz/qE4YUuNsl2+Q+Q1hkWEvmG25IhZw5+hI/BGrRO
 XDFreWRKvWhnQhYnPdBOfr0M0ZfKF3moT0ELwvreJz9tbAfxma0b/70bDVJbbv9gK9ssexBuqSJ
 Q+mn81oz8Tk9ARIoTpreDaciwsn1QLVj5lZQxtWO5R3pQcPbppbGIKAeTHyZ41qLV5vLFOADPV8
 i390ReCipmWuKz1cvYNgk8iLPu5dZey6pWyjn3NmbFq2Iuwxf81ueuTEYo1qoHs1jlAmcE9QxrG
 yjp0PkZWg5IAHpCbqjruYp+qjmoybWW2qrx1KrVv75H8ifT4q0EqdJkSINQ5kqRUo03kcw7mkv0
 dHtpKaIohOza7BfPVTDZlVApeOfTsXuK6so5ExDMQWp302h1wiLPaDgXAtxtgcgiwLY4l0v6GYP
 PWOg6egrS9tIX9yY4ag==
X-Proofpoint-ORIG-GUID: sRCFZpqFHH80HFrmKSlgfL66lxrdEPgn
X-Authority-Analysis: v=2.4 cv=H8/WAuYi c=1 sm=1 tr=0 ts=69ca8c45 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=MkXX12_YoDuTWG391pEA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-29_05,2026-03-28_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 bulkscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603300115



On 3/23/2026 10:42 PM, Abhinaba Rakshit wrote:
> On Mon, Mar 02, 2026 at 04:19:15PM +0530, Abhinaba Rakshit wrote:
>> MMC controller lacks a clock scaling mechanism, unlike the UFS
>> controller. By default, the MMC controller is set to TURBO mode
>> during probe, but the ICE clock remains at XO frequency,
>> leading to read/write performance degradation on eMMC.
>>
>> To address this, set the ICE clock to TURBO during probe to
>> align it with the controller clock. This ensures consistent
>> performance and avoids mismatches between the controller
>> and ICE clock frequencies.
>>
>> For platforms where ICE is represented as a separate device,
>> use the OPP framework to vote for TURBO mode, maintaining
>> proper voltage and power domain constraints.
>>
>> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
>> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
>> ---
>>  drivers/soc/qcom/ice.c | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
>> index 7976a18d9a4cda1ad6b62b66ce011e244d0f6856..e8ee02a709574afa4ebb8e4395a8d899bf1d4976 100644
>> --- a/drivers/soc/qcom/ice.c
>> +++ b/drivers/soc/qcom/ice.c
>> @@ -659,6 +659,13 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
>>  			dev_info(dev, "ICE OPP table is not registered, please update your DT\n");
>>  	}
>>  
>> +	if (engine->has_opp) {
>> +		/* Vote for maximum clock rate for maximum performance */
>> +		err = dev_pm_opp_set_rate(dev, INT_MAX);
>> +		if (err)
>> +			dev_warn(dev, "Failed boosting the ICE clk to TURBO\n");
>> +	}
>> +
>>  	engine->core_clk_freq = clk_get_rate(engine->core_clk);
>>  	if (!qcom_ice_check_supported(engine))
>>  		return ERR_PTR(-EOPNOTSUPP);
> 
> Hi Konrad
> 
> Since you previously reviewed this change, I wanted to share an improved approach
> that I recently realized for handling ICE clock scaling in the MMC use‑case.
> 
> So far, we have been voting for the maximum frequency during the ICE device probe
> to align with MMC requirements.
> But because the ICE probe is common across different storage clients, applying
> the MAX vote at probe time may unintentionally impact other storage paths.
> 
> Now that we have a generic scaling API exposed, we can make this logic
> MMC‑specific instead. In particular, within sdhci_msm_ice_init().
> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/drivers/mmc/host/sdhci-msm.c#n1966,
> we can invoke: qcom_ice_scale_clk(ice, INT_MAX, false);
>

I agree, this is better instead of blindly turning the clk freq to maximum.

I was about to ask you to move this to qcom_ice_probe() as per comments in previous
commit. However, since you have mentioned this now, I suggest adding a call in
sdhci_msm_ice_init() to qcom_ice_clk_scale() immediately after it calls qcom_ice_create().

Regards,
Harshal

> This ensures the MAX clock vote is applied only in the MMC context,
> without altering behavior for other storage clients relying on the ICE driver.
> 
> I believe this results in a cleaner and correctly scoped design.
> Let me know your thoughts.
> 
> Abhinaba Rakshit
> 

