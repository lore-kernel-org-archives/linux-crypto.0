Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4BD2342506
	for <linux-crypto@vger.kernel.org>; Wed, 17 Dec 2025 12:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765973682; cv=none; b=WloBfUJyySJ3uhz8qErvoxktq2i4urKbjIPbaqn+lInFMeuC7ckdyWzM0i32O+pvYmzi7Bfl1WlyFyGMuAW6y+i+l7UoRDeAQkcsarfdwTIkSgRAbYOIksiKpGSFr66wzTvIoGZ1o1ONDYkjYIE73b5eiKk3FfWLLuCKBZXvV0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765973682; c=relaxed/simple;
	bh=FOhOqH7toKWDzEVlR9pUeDZO7isCrYW9YHhCfh7mb4I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aqcGmM6EhmkbpmsPeGdJqIGcNCHGOIStccrS5Eq36eH/Fjj3iIq8Bc6rZekpcV/2Cghhd27ahnSpdt5BZgYqbFTSX15mEPtz5i3XHx9MocnKtmElGS5PAsZ4XtFlrKtTwZmuMt7u5OpNrxSdRb8ISg9nlLob6hOF44m994T02aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ZFrSypy5; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=DzNcqd9w; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ZFrSypy5";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="DzNcqd9w"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BHCDTSV3031902
	for <linux-crypto@vger.kernel.org>; Wed, 17 Dec 2025 12:14:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	TiIbU7CAhhv+5oiifZDjVX1Qm9RbZdgxoYbJ4QOuiwo=; b=ZFrSypy5utuA2YbI
	hI8cL76CIrAck3oThQeoP95f1+GFPSx7sQFPCz3grsZ/eH91tuvM0GyS+Wk+ANJs
	74NsKs1oenO2QQtHFUvYJuEW3/gyAt00nQnwYoSKip3Hw/dCkREL2hs+CBFHh4+l
	Uv5oyCqzcWOB6rLSfOxpF0aI514PvPGy5QnZl62UJmumw8zZbPOLhAmVdQG6Vxx6
	GNa2JUE6llKuxKckHwVDRBUnimC+CNsD5HquA56ZqKzcz0sMFV4DTxs0bc3NKmJ1
	1rjtN/CyTXi+yIBveOlLhaCbiZJGReais+zPbBPh8nN72tIcExM1htXrOb5C5/yo
	XkcCjw==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4b3jgq9vgh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 17 Dec 2025 12:14:37 +0000 (GMT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4ed83a05863so17634541cf.2
        for <linux-crypto@vger.kernel.org>; Wed, 17 Dec 2025 04:14:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1765973677; x=1766578477; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TiIbU7CAhhv+5oiifZDjVX1Qm9RbZdgxoYbJ4QOuiwo=;
        b=DzNcqd9wdgg91+8wciqJ6aareK7wxNv10+40Afrcnrjou/bR6VvbcHEX2V4QivL/nY
         Azf4Sl/DcLhMIAkBMk9CMaL+UgvuQezeQfND+fGgId4S4X6j4XXsKNLhz+JGxyDr9N2Y
         V3fmoWG/AE/6bKp/YJ075YMLPVRmi9cggXDtoIkmSACeBHPF7L8UZd5GI68MaK5dyHEs
         ryBDIOVPoeswan38pxfwpRHadyRcdHvpKFs0SI/4vz9nGMwOBxjpSB0TDZ1cJEjUR9jE
         qbi9I0VwTwwjnEPQ4tPRhstU+gWNBh8kx/aTR65n9g9wGJmCO5fgNizoI6BHexlZXoRI
         fKsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765973677; x=1766578477;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TiIbU7CAhhv+5oiifZDjVX1Qm9RbZdgxoYbJ4QOuiwo=;
        b=lVyIgnEUDCrGaogbxuHRXfMu8TOF4xFNhPnR06HUR5ns/ng/98nH9tJLM9FSQVV2fi
         ZCiTRjxFs3FrdNnx/lhqeFwjcVUPLXo/68klAOji4Q9PriZx589N26nzZEb1PKncFGzj
         GQs6Emwl0Ahx5ks9lXF1UxwZK3QWs2/sZv3eqW6T0mgX+A7pRNeIl+F1JqXADWZkHReU
         ZiU969AZN7OmBZ4ibyENrOwcMNUuYOzlPvneSDqhzer0AZqU15ptYVxxcHjLHyUErj/k
         n/B/fJpG0vodkAGmEMwm65Uo+faL5KDoE0DytvA5pg1lsk+gA9gl9V7YjIYvHyw/3240
         feww==
X-Forwarded-Encrypted: i=1; AJvYcCXnn6g+B+0MuRI4L6ADiAa643q617BXeFo3tkfn2LRPE+HJtjDNPNxhSTgzZznTpxhiZvxKK/QOWG3re+4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7fqxENf8mRSddqUIaStMczZePHX2mdVZTLewILO4Z6v3DxIQ3
	AIOyRfO44yY5783StZKHQawaowQ8MzfaZo6oC33Zyqrr/LvLGVh18j2HLMugNHUaQlJ/L7wOr39
	dhSvpT8Ta8Y+pLmsEonFFJyfzB+h5gFXgcw2Sv0QQyNM+LzShtLKeSSByi9DFQWzM4Jk=
X-Gm-Gg: AY/fxX4yAy1ZSQ9NMxmoBb4QWfU7J8HYNoSCzSyA4gOWbtJjdpCvHUkYvG60fp6WJRX
	LSa8ZZktA1030TJveYdwU7X9wDtZSOh8NHU/HGb7qotBbWXmtasEqeffryCvO/9PzemTodjGnEV
	CPX/Xo1ZvjSjhmO5F511zD3C4MshUAMoszzGoNz7z8td/x7CZq4sLaiCCPuiWccwSJ9V7k3nleE
	sxKtJwdYDj2oT2VabZTZ8ojC6qDLVD3IBxlybHenvbZzduVu382K1fiEuGRq8FiYGv4g14ZUfcr
	Xy5YRqXqJb2I9O91ANy2hOUl92PF6C51PVhGmv/I+RGk25sOnkahQZgHnuqrB7WP7BbO+NAz9Ja
	zoX47JMG4rZuw3/bmxuA8mrPPkBUx1amAV3Ka6fYUeidjfMk7ELupHwuYkd8uwhGEzg==
X-Received: by 2002:a05:622a:610:b0:4ec:f9c2:c200 with SMTP id d75a77b69052e-4f1d0655504mr188695321cf.11.1765973677018;
        Wed, 17 Dec 2025 04:14:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEXVGpRhIxu3Mf8+ixHHNkLitg1sBzNFn+khIqfYf9Z5J9ROjGkK+V2r9lo/OeYRDeOI3YbBw==
X-Received: by 2002:a05:622a:610:b0:4ec:f9c2:c200 with SMTP id d75a77b69052e-4f1d0655504mr188695061cf.11.1765973676600;
        Wed, 17 Dec 2025 04:14:36 -0800 (PST)
Received: from [192.168.119.72] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7cfa2ed80dsm1945925566b.16.2025.12.17.04.14.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 04:14:36 -0800 (PST)
Message-ID: <8466d783-faf4-4b33-8822-1477cbdec288@oss.qualcomm.com>
Date: Wed, 17 Dec 2025 13:14:33 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 9/9] arm64: dts: qcom: Add The Fairphone (Gen. 6)
To: Luca Weiss <luca.weiss@fairphone.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Vinod Koul <vkoul@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Andersson
 <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org
References: <20251210-sm7635-fp6-initial-v4-0-b05fddd8b45c@fairphone.com>
 <20251210-sm7635-fp6-initial-v4-9-b05fddd8b45c@fairphone.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20251210-sm7635-fp6-initial-v4-9-b05fddd8b45c@fairphone.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=VLjQXtPX c=1 sm=1 tr=0 ts=69429ead cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=6H0WHjuAAAAA:8 a=EUspDBNiAAAA:8
 a=deFlHvtSqnmsrBg3ijIA:9 a=QEXdDO2ut3YA:10 a=zgiPjhLxNE0A:10
 a=a_PwQJl-kcHnX1M80qC6:22 a=Soq9LBFxuPC4vsCAQt-j:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE3MDA5NSBTYWx0ZWRfX12SzOb3LMyko
 dvu5DQMMR+BOAwAqENEYZbsRaS7wAwFL0bBnNS/0zvA6tIPHgIF0cIu358nny5KgyCS8nqeCeb7
 QF4yHBiiaKVMnY4dpoSePkeLjLGk+g66UhznJaFiZqT0zz37+AK9G59Qs9U8doEJTrjT/garu9/
 L1oya9tLkLs550GPxDfu3JvrYibB0wDinRiU9+U8PgQF0BW5AzVKqpNK22QFz1V0Fg7iEbucQV4
 Ni5L/hYtDYl+NqfaZ7U9CVQX7xBt28GviSTCI7B5x5erVnjUMi2RtwK1SCdnbzb5PwTVo6MQE+M
 QNT6iAX9lRdLRyj9mayTyb4v8ipq2JURxs+rgL/Q3CMZb9XO2MvThyTMJYfTJ5REm32UnGRghF0
 D8SZV24kXpvqcoSfh1RICNGJvDleUA==
X-Proofpoint-ORIG-GUID: 2KQfuJ1a_bStVUKQ9iDjXmSMc9oLzSGs
X-Proofpoint-GUID: 2KQfuJ1a_bStVUKQ9iDjXmSMc9oLzSGs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-17_01,2025-12-16_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 impostorscore=0 clxscore=1015 lowpriorityscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2510240001
 definitions=main-2512170095

On 12/10/25 2:43 AM, Luca Weiss wrote:
> Add a devicetree for The Fairphone (Gen. 6) smartphone, which is based
> on the Milos/SM7635 SoC.
> 
> Supported functionality as of this initial submission:
> * Debug UART
> * Regulators (PM7550, PM8550VS, PMR735B, PM8008)
> * Remoteprocs (ADSP, CDSP, MPSS, WPSS)
> * Power Button, Volume Keys, Switch
> * PMIC-GLINK (Charger, Fuel gauge, USB-C mode switching)
> * Camera flash/torch LED
> * SD card
> * USB
> 
> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
