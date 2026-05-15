Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E053CD8C2
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 10:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778840691; cv=none; b=tARLMRx7c3rVzAfTO4MUIuHvhbVE3g9Fuw+TNNd/hb4/yHOQywvZYGkLdkykkJ7hM9Sn58Um5TPH0oTlkYmnUbP7R1uuyHnShdGlUPTAQeFgTk9A/yv0awrIOPn3xd7zXTbpPq790w7ys4GSypeKUURBlCsmOSi5IawvVRXWC6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778840691; c=relaxed/simple;
	bh=unPGu6uS7YezciIq5jZHbFweXvFH7W8eGLAwSyl9WIs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gox9KESy97orjnK33nX1DQhEupuJQPlWIsWV7d0Rha67jVEGB4sFflVtoFSB1etbdapSAaik63fymFMHVKA/VMpQzdhjM+A3IVYVLvll2o2UW7gL+xk4Z1WpE7/5NFdq2afAX09wL/683k+ihZbzKh8Bj4dI2yHv6bUYGn90hPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=MlXQuR6o; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=I89QUfBj; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="MlXQuR6o";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="I89QUfBj"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64F8kZCA1714932
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 10:24:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	fnHqlOBnwCvxABsvz6RGyziXmPIuF99UYE4ADmlewwY=; b=MlXQuR6oOnVSOxk+
	VMWL0RjEW2SX3bYM9mKD9YjAPdmACEfJFzVePALzdOWDMXfulaGE2t4bwa0y6bQW
	ivSz8jZnRvNeNywYYL0XLj56jZIuObITLbi/4DwnbMnyvI3pQ1TYkunG2S9+TxQ/
	hZ6emTJJe63LjgRoPzX8oMa+e508I6W8GgHQcTPJL9uHirg+dnZqkb9KozBQYweA
	ScQ1/D9Ranevdw4coQuBVng5Pu1FaSItCha9UPZbTXSDafM7lRr+TjT8ZehsDrox
	gK1BHR1MQfWTKGmY1oGay8G2eJQWQlzrqRKqz+MlVHPS3HUpczvT7LV72NHuZHpl
	fqruFg==
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com [209.85.222.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e5tyxsky0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 10:24:49 +0000 (GMT)
Received: by mail-ua1-f69.google.com with SMTP id a1e0cc1a2514c-9568c79b893so392740241.1
        for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 03:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1778840688; x=1779445488; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fnHqlOBnwCvxABsvz6RGyziXmPIuF99UYE4ADmlewwY=;
        b=I89QUfBjPCa5/VoZ4vTSzMGZnA178CnUY3jaU9a211W8D4og1P3FBQN/SF/QVKFYo/
         fRfYVdXmHdZEEoMy68WkYCoI2vTMUnbDpZwnorx8mcmb9WOyJTcZjsYkwWNLq+Qk1Qsj
         8G7Aa33YA3s8dqN3sPs93h4Fc9FExtn/sH9URtsnZKCFnS5Q3LqIptI5ovMHIVqPuhe+
         XFMon8OQ0TsfbPz0dqyG84ZF5DtROL3sye6/bquE5uW7RGesjA2934SjLl/s56Qyem66
         5MaBzNuZ9xUArGEBvYzAqazqO3/PcTMfH6Bb7ScKoM1g5fq+C2eXcYAjnmTEJRRNBvwO
         ZTmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778840688; x=1779445488;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fnHqlOBnwCvxABsvz6RGyziXmPIuF99UYE4ADmlewwY=;
        b=WQJwWhcp/4AWHiapXC7r/7fq0a1URb6WgSqD9lTK4n8GpvRldXG3Pxar9m8ssOMAVT
         CuE0Wae39zhxsJ9MwZ/YyzsLjfpHFmKZoYllQTeXkfDg0F2SDhefX8OQpFanTWE5fnSP
         IEKk/xSDpOg2NIIIaeeHMK6Ywpg/VsUZsjYiZXwozxExyrHUiQVLmtVizi2QOrosPAU5
         cd/k/clwfb169coT1VvzWhRl2J990HV8QkCZ5LO6tGTbevNWQ+CRWRHOfhM/dFWJDi+f
         lA+4eGE1D0paczUfxIQaQtNnmx5vUlj2vN11BvvvMAddP0gI262gFV8egjlh7eJiw+AC
         LkkQ==
X-Forwarded-Encrypted: i=1; AFNElJ9dDvVBFBAFYG8Snl/CX0vvPWHMORNkOq2ZyvzGid4+56NN63dlusdLPmD2pz8HGFZDpqxbTnsLu5qYfU4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxlRsnHBv6E5I6Z2aFWVW2fi8GJprP+A3yxnhA2HtwGguzVSpR2
	Z6g5SufRrBtWQR7UHTsKq5E9jDbJnRGLH/+WWUKNUkfcII78e50eXbNRzBszueQRHv2UrX5/nkT
	FHP4yDRNMxrBdzeFfr+yAk2BFKljwFBl0Q3oFfFv4o0C6aJqS0QTOdjOL014r/smFTZs=
X-Gm-Gg: Acq92OHGrUWv5mKveadaqqy88cnSmNPf8nlFUvL1qzmdeHnhjIoC7VvpLahagFI6+XQ
	jEGXZ2pJKlBarfYr8idzwiU3OLa3mTrTZuJjUhFk68hlNs7XG/kMNRYadHWoCzgd53Fp2RjaJmI
	55zkkoEJQQ83uQ3FnwaWae6NpMGoenMNRjTEUDDoM/34kui5lb2Pfp3ciKdnlR8c3+8omAOfA3d
	lccT8YsFv/u1fAwhEPQCZjbrmwN84jlsiIYL8677DotWIRKEllSNopLeS8/Bz9HakaKSJDj74YD
	CcScqpotbXN2Eh/rZ7jg63vQb2dvbIORJ0C/B1PHRWL9ZqtrKobASbkA7hiTzT2Vtm1L/uD5hvH
	SPbrne5MWOcuTXkX1C+mb3JHhWSe3F2tyURVn8jwjd6szlFAdZHZOau/3UmonCedO/lBFMuEgSf
	JVn1X+pDyZxcijBw==
X-Received: by 2002:a05:6102:669:b0:634:8685:d331 with SMTP id ada2fe7eead31-63a3f59319dmr398414137.6.1778840688124;
        Fri, 15 May 2026 03:24:48 -0700 (PDT)
X-Received: by 2002:a05:6102:669:b0:634:8685:d331 with SMTP id ada2fe7eead31-63a3f59319dmr398403137.6.1778840687727;
        Fri, 15 May 2026 03:24:47 -0700 (PDT)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bd4f4c24178sm208202666b.15.2026.05.15.03.24.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2026 03:24:44 -0700 (PDT)
Message-ID: <e942c86a-d56b-48cd-a344-d154322bcd70@oss.qualcomm.com>
Date: Fri, 15 May 2026 12:24:42 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] arm64: dts: qcom: shikra: Enable ice support
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260515-shikra_ice_ufs-v1-0-b1b6ced70559@oss.qualcomm.com>
 <20260515-shikra_ice_ufs-v1-2-b1b6ced70559@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260515-shikra_ice_ufs-v1-2-b1b6ced70559@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=dMWWXuZb c=1 sm=1 tr=0 ts=6a06f471 cx=c_pps
 a=UbhLPJ621ZpgOD2l3yZY1w==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=kIEpkeg7eEVi8S8yTT8A:9 a=QEXdDO2ut3YA:10
 a=TOPH6uDL9cOC6tEoww4z:22
X-Proofpoint-ORIG-GUID: 5eHVhzZ6spxfV4Sv6b94eBUXZic36KgR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE1MDEwNCBTYWx0ZWRfX4AkOWOErXnxH
 W6B3HjdxXaaP+3p1/IzUt3sNVMH3AZzbyVJdJe1T4lqdjoI9I1wc2OVR5fPAHnRceKOrP3oQAgu
 w4ZrbyqUoUIi3ZLZK3EcZETK/LrKB9B/+jvM+XFo4PwstWND1B0iCwSMez5h6Sv1gMueSBIXNF0
 peN0wpzbK/MQlZO+eXckg/YNxD8dQRHjmYL2Yo+qL2zkyioJn0r7IKVaXgh2sJtxemgkrth4PIB
 6NO48X1W3xOsEsVbEEyEKrITJUj/LCG+h+HZdo5FtZkGnOQ9rIpVCJqK97q6J9q0WFcLf3SMLQq
 KAYakVVj9jqI+vyyoDtzSbtY2/XHwkVZGmNR0QKSZSTipclSrvnZO7isthaqRRZA9bLpX0iSsyw
 Shr2QVuL7z+vRUneaISUfVy1rN3GJRAolkC2XjyKDaHJNhi61rS2xquSBPwGM9ZO8Tq//xDfeRf
 q5nuLIu0opMAB4Co+Nw==
X-Proofpoint-GUID: 5eHVhzZ6spxfV4Sv6b94eBUXZic36KgR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-15_02,2026-05-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 clxscore=1015 impostorscore=0 phishscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605150104

On 5/14/26 10:30 PM, Kuldeep Singh wrote:
> Add UFS inline crypto engine(ICE) support for shikra.
> 
> Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
