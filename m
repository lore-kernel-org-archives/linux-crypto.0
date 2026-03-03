Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8469C3EFD29
	for <linux-crypto@vger.kernel.org>; Tue,  3 Mar 2026 11:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772536442; cv=none; b=Hmcn+9sMZJl8bgWFyXfklI1dXwkPgq9iRXwxRl3MfSmEY0+YKTCq5Al1QCFMeYB2bL9bcDq292INxy/8z5vIQijqfoeQy9S8INlJ+ARwvbgmAKwR3zcxchVpWGe7wy35tOpF4+rKX9FO+xEvU8VBYtKTyqjowgY/mNx7CIfShac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772536442; c=relaxed/simple;
	bh=wWFLYkNKMAA4PxdeoBoHTzoSaqj1Bb+Ww97iGeWOKh4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nQejKIoFVrdeINb9vW5uqEhMgvZXIg7kaK6EjRaGEm5ang7Ha7oGefaVAYwr+cumhax7smgqJBRmv6mmiGd7buZ8N8mqwXBaVT/XGnfdhA193rW/5GnqpSV79Z6kf0U03tNSnSmMgv400OFL73fD6BMhIskj4bkyN6RpNdg2rQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=gilUZE2+; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=UKNAK7fQ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="gilUZE2+";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="UKNAK7fQ"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6239n7u42630006
	for <linux-crypto@vger.kernel.org>; Tue, 3 Mar 2026 11:14:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	zCgwoQ4wtLHPObZpj50Yrfw2f8i6XdlQ8XsLRNXHaTc=; b=gilUZE2+duyHownw
	JYPEeG1A8x5kEVnGJjBpl5ohdDY+16BBqtKsQzWSFqBxnGqQ5AO7Qs0CMYTysmmh
	BugKL+AQ91C7vp5ubgiOwknA17PQODgFcmntaSVd1usCIKyBQEwBZ6CYmLD1Ivmm
	LCUmHcEjdq02xwkeJzmG7vvtVojMTWf6qz3XiHXizOdOMfOJVyxrqNDl9S3ovDCT
	3/x4JtZ9DLEmj0kZ/A9dRkM6eZS53dAsfR6opcI4HRlWufLyes+Xm4uNuuYHn5sA
	2tDivoh+Q2y2EewZxxA5HyyZ1ljmzb4nRRLyFnUPRjLiqZiDDBbdPkuffntia9xO
	LvezLQ==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cnhx5ak3x-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 03 Mar 2026 11:14:00 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-35845fcf0f5so6142373a91.0
        for <linux-crypto@vger.kernel.org>; Tue, 03 Mar 2026 03:14:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772536439; x=1773141239; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zCgwoQ4wtLHPObZpj50Yrfw2f8i6XdlQ8XsLRNXHaTc=;
        b=UKNAK7fQi2qFfG/EuHo/U2V/7HwFoaCTktKD0KA3X+naC10L2FZqwaOiP4g014kp41
         oKjWatiJNNB/ULUx7mAt2NEjDQIUr0P5sEq0XUUqST2Pwb0xl4C6XhUpmcs99wbsOusf
         MtXCBpphfQDgoYahUup7ZTcLN5R/HEgpF4OcygFEFgk484xtEWIqTbuuJ7ZbQRePktoY
         qzlPBgMeuGXKelp1jKEinV8ssUJ2AR0jmsuknM+8cNooQOH8Tu1zL23IMpi8vigSr3x7
         S2xx/0moFtKPvoN/BFqbF7YPYEAywK/garUuImpceyu38ZY4AWY/FH8utZ7TQQBjcy3E
         3OHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772536439; x=1773141239;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zCgwoQ4wtLHPObZpj50Yrfw2f8i6XdlQ8XsLRNXHaTc=;
        b=gAJty3spdP8u1tEB/IC1FXpvduknA7P0nUZk/1t8mdQpICvrfeHB2Vd8IKs52Cg9+r
         /yokiuyZAfNq6AVQu3xpKxUWZMdWbY0JjyvsdDbUXPORjScObecrHRp+RKE5QhOZ0ND5
         vddqqd3ahKcz+A1LXKLsDh0aIDZmJh+JbbFwLAmqSnIchzfD8OxCGmV6Z2O5wv6m2m64
         zBqOJfYJuJuY4MdNF5twrZzV0RuZtdpVALCa8VIzP9p2Y7b3/BdKhqsRptAI6P1mGBMJ
         T5nxNTbrZR5DvTbjw4I6KOZaQdND3ZaQylbP4+WG3T6pa4gcK79lwfF1CwnmUBMvJyiW
         fiMw==
X-Forwarded-Encrypted: i=1; AJvYcCXShm6mtMfFALFtOqdOLW0uXcXgi5swIqo0lbSDBJrOM0Z8gm6rAxWchmyVxY6tizTddKZHOMLWdA/GDsI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBfirphkDoCCwpcX+O0M7zOkfURkg8CsXEYyRolTpqVCuZdQZ5
	bbVJbqPtBXu+FgGk+A1uWrtjyaNRLldYP+SeT4NzI0EJ/MKzGdFs0CmlfTjsph+o0Ymw108ZFe0
	mmzQy7Bicm41Fjh+9sZMyNvAm9h9q9mkQek2XVZ/dnildpuZ1g7iZlpUeJmHIjvJhQP4=
X-Gm-Gg: ATEYQzxxfgo7fp6dQAqA/0YWw0eh1OlDmP7wK/actSU/t9KUFXV3yBQGx+2WqevUYlE
	pAFlJo3OpTaD7VYEfNLuIMbjgIlg+76wpRD6Y+HitYSMT+oUSNg09gl66FWDwH9Z7ySf3OosTIU
	SEQsc7By0om2j7lwyddaVIPz+ER3YZOIHkEgq6uoSkQVbmczT5yqVqLzdnjLl0K85tZ5af/zJdF
	lGmj1Ze1fmq2N0deTbysuM5KDWa+FSa422whWveN/JcXOR7YdqOVnPxBeboaDEmcrEVR1WTFCTe
	Pf3ONTegFqqliwtczyFbc0RurbekXL2TACbBNo1Ly1cVf/27HgecbI4h5PcogTHbwyd8oWK4jFi
	DlvLfB82aBAyzocjtGbd/mh2/X59E55uK79UCuRPzEE4aHtzQeCZyksdqeiw+aLVC1QiYTiM6o2
	YwNjiYlVGuCqBJ
X-Received: by 2002:a17:90b:288c:b0:359:8c3e:b0d7 with SMTP id 98e67ed59e1d1-3599ceb51f3mr1539487a91.11.1772536439535;
        Tue, 03 Mar 2026 03:13:59 -0800 (PST)
X-Received: by 2002:a17:90b:288c:b0:359:8c3e:b0d7 with SMTP id 98e67ed59e1d1-3599ceb51f3mr1539454a91.11.1772536439030;
        Tue, 03 Mar 2026 03:13:59 -0800 (PST)
Received: from ?IPV6:2401:4900:1c66:bc62:9072:7b6b:889e:887d? ([2401:4900:1c66:bc62:9072:7b6b:889e:887d])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae541358d4sm51477085ad.75.2026.03.03.03.13.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2026 03:13:58 -0800 (PST)
Message-ID: <841f2e1a-f542-4ffa-97d0-e3f02791d8ff@oss.qualcomm.com>
Date: Tue, 3 Mar 2026 16:43:52 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/11] soc: qcom: ice: Add explicit power-domain and clock
 voting calls for ICE
To: Abel Vesa <abel.vesa@oss.qualcomm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        cros-qcom-dts-watchers@chromium.org, Brian Masney <bmasney@redhat.com>,
        Neeraj Soni
 <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260123-qcom_ice_power_and_clk_vote-v1-0-e9059776f85c@qti.qualcomm.com>
 <20260123-qcom_ice_power_and_clk_vote-v1-11-e9059776f85c@qti.qualcomm.com>
 <ayk53t4tjes6gq2m32e73tll5umb3fvot4keqxnfi275xeglvq@cis7h2n6j5jy>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
In-Reply-To: <ayk53t4tjes6gq2m32e73tll5umb3fvot4keqxnfi275xeglvq@cis7h2n6j5jy>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDA4NiBTYWx0ZWRfX7sLEm5Vz8i22
 LbJu2N9JQz51sVzWu3gqCkEBmdEF8evU3M0V5fjZBY21kiTfMc6/KPW90C6vyU8KKWs/YWXoNSG
 ZpLp7yGybyWO7896YmHyjwPmOuN5Lawgpoico+dGHbJrkhrLhLhUQMLx0HWfNL/Elg32g81HW98
 dbcYde8cpi2DC8iMhicnI9i5Vpc4rhkX1kTEZpDm8EFtKpR/O2L6/QdogsZtTmnLqzbpO3tXZ+X
 xF5NVlHSrtFaDr9eBnv+FF1fNk11ql6lR13RcRO2y7C5lgXA99vllm/BMcNBJy4hqWbHd5oqCj3
 niEeguRDs7gLEoVh3jA3iRBHc1gaz7IPSulxKnEk9R9YESLKgNhj4S1cHf7iL8NkVG3zh6rgUa8
 7pTCdjUEdP0N1HCQOxRlceNYq7xkaWDl4BKXWlW3InRxwRGc85ilf7ldO2lhVEe9ObGTU2UZb0G
 mxvFyy1qt0pZln75uOA==
X-Authority-Analysis: v=2.4 cv=T9CBjvKQ c=1 sm=1 tr=0 ts=69a6c278 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22 a=YR3WsahE5DL5jeN3REYA:9
 a=QEXdDO2ut3YA:10 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-GUID: 4ZQgQPywoAEjsJU09NgEGY4o0CHwOgeb
X-Proofpoint-ORIG-GUID: 4ZQgQPywoAEjsJU09NgEGY4o0CHwOgeb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 clxscore=1015 suspectscore=0 malwarescore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603030086

Hi Abel,

On 2/21/2026 5:15 PM, Abel Vesa wrote:
> On 26-01-23 12:41:35, Harshal Dev wrote:
>> Since Qualcomm inline-crypto engine (ICE) is now a dedicated driver
>> de-coupled from the QCOM UFS driver, it should explicitly vote for it's
>> needed resources during probe, specifically the UFS_PHY_GDSC power-domain
>> and the 'core' and 'iface' clocks.
>> Also updated the suspend and resume callbacks to handle votes on these
>> resources.
> 
> Your intention here is to fix the patch that introduced the ICE driver,
> so I suggest you add Fixes tag. Same for all other patches.
> They will have to be backported all the way.

Ack, I will add the Fixes tag and ensure back-porting.

Regards,
Harshal
