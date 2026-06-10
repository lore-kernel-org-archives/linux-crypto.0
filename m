Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3002175A6B
	for <linux-crypto@vger.kernel.org>; Wed, 10 Jun 2026 06:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781071531; cv=none; b=m/QY3gf4oDDaJi2O16t02xnbY3aphYnbweBcjrh3DG4IideGoq3fDlnDVC7E4GIsVK+q1kO5zzk8S15dFvTtowEsu/UZBPxVIjtdt3geuhf2cYghJhF3lYGeqwsPuGUnIIvaUpjLVPEeboKqpuqH3Bigq6P6T7gnLoiRfn7cWKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781071531; c=relaxed/simple;
	bh=3wbXNE/jKiGwtk/t/u5lJ6UhV/FA4ZIibVf+CObN92A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZreqW1KlI85T0xhYXZYnrlDWOCurKtc32LISzY/WNhAo6Zz6DYN77SOqhsftoVAyB5MQvMLXz3n2q68rxwfnhSjzR7lgesNZqBsJ7Ynb3NNxd9B5Z6bLN86XDkSiHr58si6SFqmotlOujjjDEWHeVHbjc30owaJxI91Azfd5iUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=CZOxfa/c; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PSA7egnv; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="CZOxfa/c";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PSA7egnv"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65A2eiH64061024
	for <linux-crypto@vger.kernel.org>; Wed, 10 Jun 2026 06:05:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	1r4emBkmGL9huta9i+cxa3n0uuqwoffvcDXFAAyEnQc=; b=CZOxfa/coOxnYYgt
	QGAC5WmT6NYP8bcSvy520TTcNC5eMRRKsefE+EdYO2WLrHycpZuB/rFIS7nJNkNp
	uNK511RiyAgETqVE8JnNcmAeT4XcsgYakA5mYGTdALeKe4qP4qUKQ2iAbAfVFIDH
	zJm6PAecz6bwEpQKAHFJsCyxiigZ7v64n/uP10RgWxVnu2QhZ4E6lqy74FBCyMwv
	wGU/Gd1j9I0ozidFVoKuisz3a+yQYNVEsGChIpEAO/4+Gm+xAQazBEXmaZRrzawV
	j+0/94l6IuPPOF1cvNZz0ww7ATAdtazNLXQtekHyAPXyJ/6y1fhOAwRfjfmbE64L
	q7roGg==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4epwnh109y-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 10 Jun 2026 06:05:29 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-36d8719bae6so5617400a91.3
        for <linux-crypto@vger.kernel.org>; Tue, 09 Jun 2026 23:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781071529; x=1781676329; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1r4emBkmGL9huta9i+cxa3n0uuqwoffvcDXFAAyEnQc=;
        b=PSA7egnv2+9dEC5awIifqPCxbPSsnqlfjS/6qqjBZRde4OE9ovjUSzzs7CEr+5rBz8
         sMCMuwH93JkBBkPAQZhDurJi6kZ6EFKA2xY1NceQkzzxjYmC2sKVRaVlrkOIdyaQrCC2
         lP/vZClsZqapjVvCnJ7FL0E01tEOmPzs2S/T1LT57JMJcH16eyKU7dNhP0gEQ/venZ3b
         22XmlkPFs1wB2owl/8Xrx9XTADPGfPjfJ2MkSCJPX6oV5RBSCrNDujAe/5zrPWgnwfrS
         +m7NoRk39rReATnMxRlA94ksiag1MMLqq6+LXMuVjOgHTilcAJZymuwjZyZEyDgvY8uo
         9THQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781071529; x=1781676329;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1r4emBkmGL9huta9i+cxa3n0uuqwoffvcDXFAAyEnQc=;
        b=ryIB4M34Qwh0/9AFLTLuPCBWO/JYBD2pFbcNxudzpOj8Si4x4VTALJc5S1xxLyXE3U
         yaw7vdnvLDr+zoCj/6onlgd5J7f6OGUV0kXhQQlg66Wk0DqYbmliKpfsaqbEJNXGi3WZ
         yMJcJkyQBELwF4m7VtwE31xyjBcPmTLNk88DgaAER3DxnVRldTgcjWjITNem0agcbd11
         aT1hvWK5Zgg6GwweED8M1fKgNhASaffVpndpIxBQcAsP+Ch8mbNVV0JkSA8S6fVLU+SA
         Fu+f/LkwxNS5KjVSytyd8TU3kgxSl5x4SCd1vFaLoh5y/sgQsKh90vdUVUCigm+7+/kc
         2crQ==
X-Forwarded-Encrypted: i=1; AFNElJ/ocuBD8bt4EaeTKT/K4E4vWaLPLGC7w9pffkBlH12Tqxfz9EmchA8IUB9y96CASroxsj7uXHLkcw+Uiqo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzi31pwXt0wZRIhh/fLQpru6IuORU/1ZkLWC1CF4PuQM10IRh+w
	Z8Q8/3DOLsH1Xy3Wwaq6q0eeMPmbkolqsyRBrP/6BeORsMB9psgc51mAojXvV5Gw/K6X7d+3PHk
	3c85JgtOaVwvWZ4XKXT7zjPSqz6Ty0VkN9uB1e4YPrHyRJGTyC1RnY+0shIhTxnLIGR4=
X-Gm-Gg: Acq92OFbhH+7v6LUKWF0Cx1YZRU1GDQw7whjXfCzSe+5c1T5i04eHzYSmZV/tbrGNUj
	lUWs4uS0QMFjnItjzvWttwarFeFdBkScNk1UD0+s/E9PPjxY+QtprGTw5P6PEaviNg5BriJZxnS
	SBaNJ8YaHUqH8L6yIY1Uks5Kn+/SD5a+nLDep5nPnhbFK8az4q0WpmUnM6i2wWvlnUeg0+nWuSS
	K70re3gGyoep/ELVYoYnFcZGFLFe1yR8n58YMQZD2dr6z+EZ90qXOusHt6W1PfebaOk3EE6b31y
	7njbxvI/ODEOpSUQLvN/aHl4yIuse7Dlf1RaMQVFNjGBb1Vmzw54XvkVKOCHq5RXaosbiiP0FsE
	/ewv5a7fUJ8ppSsn8cOrOEfIuYNKjGkafeV/CV5zZtrDCZfsx6LQKTxtTDvNHeSVf
X-Received: by 2002:a17:90b:280c:b0:36d:ae6a:22fe with SMTP id 98e67ed59e1d1-370f0480da0mr24854459a91.16.1781071529301;
        Tue, 09 Jun 2026 23:05:29 -0700 (PDT)
X-Received: by 2002:a17:90b:280c:b0:36d:ae6a:22fe with SMTP id 98e67ed59e1d1-370f0480da0mr24854418a91.16.1781071528869;
        Tue, 09 Jun 2026 23:05:28 -0700 (PDT)
Received: from [10.217.223.142] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f711e7b53sm21653462a91.14.2026.06.09.23.05.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jun 2026 23:05:28 -0700 (PDT)
Message-ID: <e83853fa-3bdb-4bef-9953-19e7ed96b000@oss.qualcomm.com>
Date: Wed, 10 Jun 2026 11:35:21 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] Add support for qcrypto on shikra
To: Bartosz Golaszewski <brgl@kernel.org>, Eric Biggers <ebiggers@kernel.org>
Cc: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Frank Li <Frank.Li@kernel.org>, Andy Gross <agross@kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>
References: <20260515-shikra_qcrypto-v1-0-80f07b345c29@oss.qualcomm.com>
 <20260514194735.GA1939213@google.com>
 <d4d35e17-84fa-4c95-9bfb-abfd25ea7f4a@oss.qualcomm.com>
 <20260522024912.GC5937@quark>
 <c1697372-54ec-4f57-85d9-ad375ff1a44d@oss.qualcomm.com>
 <20260525142843.GA2018@quark>
 <e49c4a45-6455-47f3-a91f-c32c1a0b99be@oss.qualcomm.com>
 <CAMRc=MfC6CEwOXYttsav3mwqyJ2F4sburBj+zNJ25qMoweyL-Q@mail.gmail.com>
 <lj7geczhthury476ilkjym2k5fblo5pqroefsbdfgh5jcf7zy2@qrss5xc7umn3>
 <CAMRc=Me6cqasdBknbAjUZ5BqcpERYwV+NvseRJp4P0aTSYAMUw@mail.gmail.com>
 <20260528175214.GA3936298@google.com>
 <CAMRc=MfY-tmMCdw9FVBgfkX-FvB5Nx2X06S023GhASenSCQSNA@mail.gmail.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <CAMRc=MfY-tmMCdw9FVBgfkX-FvB5Nx2X06S023GhASenSCQSNA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEwMDA1NSBTYWx0ZWRfX+i8Ram8bydyW
 8hIDz64HTGnYPc+CqH/fxyLMehOYA/0+unWckJGCmn3l35ynoSaIgLGTUSsbFxSCOcWWUtND2D+
 NIC6I7JWcL/LoeACzgvn+kQsDG5h16je2vATfHAUIcSZ53bwkzsBHZ/+EN/myIif44a04tdoqUy
 V9tkpOlzv78y0eX0p4UVC5Y/plp1ZG5Aok5Q2KXX1c6yGxcTZ7BYqfHHVrdfmZQumuZhfaht5s6
 TsKv0p4fUKj8uGbnV2iZY3OUNj8elOot4Zfhus3xXPOoqXn9wnKR52mQMw5/Hb7fkmp/7vH+/0w
 NxDVbkCl21oQXNHkcBoQBMBnwH41Y21LZDtqyvYn/IVCaXlByNU+pyvK9AEhz5hvJXcusnwX3eh
 s0ER/uRMyH8sN8lcnFFpEsaeStg1p4u5vo1Z4zxMDclRFwHJmTVXTl6izba5LoafVReVIfVzAT1
 1PeRuEATFbBHWRt5jcA==
X-Authority-Analysis: v=2.4 cv=Xce5Co55 c=1 sm=1 tr=0 ts=6a28feaa cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=Jq58CcIhlmqOa3VSBlkA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-ORIG-GUID: yvKRqxQWBEkV-gFLpC5B-TRpBC7nUcFu
X-Proofpoint-GUID: yvKRqxQWBEkV-gFLpC5B-TRpBC7nUcFu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-10_01,2026-06-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 malwarescore=0 impostorscore=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 bulkscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606100055

> On Thu, May 28, 2026 at 7:52 PM Eric Biggers <ebiggers@kernel.org> wrote:
>>
>> On Thu, May 28, 2026 at 11:13:47AM -0400, Bartosz Golaszewski wrote:
>>> On Thu, 28 May 2026 15:50:10 +0200, Dmitry Baryshkov
>>> <dmitry.baryshkov@oss.qualcomm.com> said:
>>>> On Thu, May 28, 2026 at 09:13:23AM -0400, Bartosz Golaszewski wrote:
>>>>> On Thu, 28 May 2026 13:54:51 +0200, Kuldeep Singh
>>>>> <kuldeep.singh@oss.qualcomm.com> said:
>>>>>>>> +Bartosz, Gaurav, Neeraj
>>>>>
>>>>> I know about the self-tests etc., I will address them next.

All, kindly help in reviewing selftests fixes for QCE.

https://lore.kernel.org/linux-arm-msm/20260610-qce_selftest_fix-v1-0-1b0504783a46@oss.qualcomm.com/

-- 
Regards
Kuldeep

