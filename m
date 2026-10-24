Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792849597;
	b=GTNzWFOHGKJstOC2LAQB8A5wVGW73Q8/CrQ/RO2Or6M+LHlADaPtCKSkqZByT0HZZduP
	 Cr8X44drvFkx7mbrfukEPtX8tE8k+TYS4vLEfrKOoXrMncCH0ZUltKD0J+3x/KeBJgPLD
	 1Ggm051KXk0DxrqNyyoqnYmLPDXig+7/b4SWgwUr5lI3O187Zt2Q9GP/MI7mNH/2vkU9X
	 3F05OUUr7e18bhFy215kSPcrFSlVj/S2DUUiobSLnXK5hHFGEe3RY2LETDwZirdYHccDk
	 tG90OK44ZUQokW+c32bRaQySyAhNj+5v/7hzSMaG6rg/gQtOmfDXU4jTHEj0/uW1a3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792849597;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Organization:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=cedsDiWxiMJHd1Vt3zDocFzdubCPdae8+FNLHOPg2Hk=;
	b=LkqzpYRTd/f6SWG+7Cl2RlKoOUmlRboLwuquC0MORqIOlCN9POIy0jCvP5LSl+lsv6oT
	 s4SbBHwWYpKHb8PcCTnLpJyxZ4Jb+q9bVXbgOIoI0yxaY2xR4/RJ+NoZF81iFFkp0PS60
	 /Cm4nqQBQQVv0cg1Hzl1e1A3vOM12/S+Gb0WGe53wuCuWY0e31FU6QJX+scpW8Qge3s3O
	 2eS8JFpUBSm4QHDHRjWystoFQhSWjf6rUShciDtWIm62/aqXHYbAckBctgR0G95nK6+m+
	 12rjltnN9+nZsRKpPAa/AuYuwMOmTvpTHf7RrA8eAq9osniBZrXsSDU0DQJPqqxJG1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=eDc450pX;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=UrmoVkMk;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCED4606A31A
	for <linux-crypto@vger.kernel.org>; Sat, 24 Oct 2026 13:46:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DCED4606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=eDc450pX;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=UrmoVkMk
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69O8o0FL2209143
	for <linux-crypto@vger.kernel.org>; Sat, 24 Oct 2026 13:46:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	cedsDiWxiMJHd1Vt3zDocFzdubCPdae8+FNLHOPg2Hk=; b=eDc450pXfMSNd+pr
	DofrK6ft8ed0rfhwc75PeXNkL3Wo+T81k6aQgArTIqqASIbC8LQktGHa9P1f8BYK
	Dfsbkmz4lw6NGKR5AtSFAMMbnxvUAbBDb1EAZig7rwQbqYcnIwq+QZKpX1iBBY83
	NIpdHovQzjlb8k9ttQDfBdsSwzj9o3THVDeLGn3sCTLgfjPiTi5AdtaohmuWqHBk
	uOAphmfCitfLJlIdWCI0aB8o2dnXiDNL/cgwIcVCQPPYCWFCOgDrG9nL3WmyXQ1j
	ORjK2xmlrPX8uIpwHTFgfT3MCauw+C3LO/4pQtRHMXVvSaJj0tZD04UQSS2D+2vi
	qxxKgA==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hgkms96c1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Sat, 24 Oct 2026 13:46:36 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-35c3c370b17so2846985eec.0
        for <linux-crypto@vger.kernel.org>; Sat, 24 Oct 2026 06:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792849595; x=1793454395; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :from:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=cedsDiWxiMJHd1Vt3zDocFzdubCPdae8+FNLHOPg2Hk=;
        b=UrmoVkMkWDMUQvk7+D/6RiPjE/nLnIjpT9/9F2dpCvpccUS/YMS/yBDIyn7l25+8TJ
         3doW69QKm0FH1JEfHvExLfwmq1A8YRlRt0+JFYyc1XexuU52buCr4KW0c6jE2NPLMF91
         AySrJdPwWSl3yzackF11/rr9P+aptP9vt6xZTt3AgIZLVgnWL8XHpIiGGcryPUE1ilOo
         /B5nS2ZJwcsj8TWcKSBKLRsldP8mDVthySBSuBRlDt7mvIXzx4ZfbZNpi6TcDXosl8PL
         S3BjvYBdaAOvbo5/uxgm5+u2MaXxJ1syIzzZ5LaqAgOlw7g0jHHwi/UdFCJ+d3504gXN
         qOOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792849595; x=1793454395;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :from:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=cedsDiWxiMJHd1Vt3zDocFzdubCPdae8+FNLHOPg2Hk=;
        b=wLwQS7sw3M9GMDag1AslZJnyQkxkihoSxiVilNJtp31Qf4953ofMxM1SSRHhAdU3W0
         c+p78qfsQczNU5hBTldONjvGt80RSS6h1M7ULky4aJaVLa0B3hZGfWylRfUZ6JNamf0l
         Evkx5wd3m41r/4zq7226TTP8IEO07wNbAPPWXspJwl4Iln9wxV5aATJKqjoOUa/FWrJZ
         gw9VoVgtjInxBH7RLHaRy/EZj+UQJ4kUMfjcdTMUH3hWbO9NV7/kVFwaMKus3LvBUo5O
         rwk3xACDNP2wA+laE2ORSaiMjKgNFy1rDdAHHlTIYsAFrD0ZThzEn/1GPGG525kcu5se
         usCA==
X-Forwarded-Encrypted: i=1; AKwUvBzUIOAlsUTINqdtarHotoaUVXjq4d8lki4OKIO6oQ1IuiMTcB8gD36I4ztkOuU7J/qKp0EP9LVtUg4XM4o=@vger.kernel.org
X-Gm-Message-State: AFq9FYKlEracvaLiUGgfNHK8cY1qvp4zG2qxbpkptydUBmGm2vRVKT3l
	yZO9vnUawTWz3RmzElowjVvLdxJbDJX6f1KaqwIgLAxzE9hBXZxcqoVLB77s49Js1s/j8iCQrDp
	NCjkamQ4vyG0+G7w+NhNufmhSKAwMZTID1SKpG64KmIbs53twss9nrc5uNeLzajE5+zA=
X-Gm-Gg: AYBFou2kS1y+UJ3TXaQLgw4MqZK+eg6bALGP3IGooCJEspKnGorWVR1Ot3u6nGY3IWP
	XI3XJlGHVgYEd/C6z3fRqyFih+Fb4P9bbHsotSKtFVoGy0zIxgKJ5DWjQsCGaQgIuwCikRPM7Wy
	iovgDKdYNwnpnp+rLOl8ij1CQ/chn5QEwiPd1tNsUX8exjTCSUnjtJK76iO4BANX0Zp4CPt8NVG
	0fRElPc3YfcbNa+ChH1reL1xp5AGbRSeJBDwskS+daqBJGnXt1PkYMLh+n+WLHecgNPDfyULxk+
	ZXdzLzDHDFJgZ8NO3+Fu7nigygJ3aJuGICwcOcQa7YwOMMGL4++KODGZ+u9S8mtZ+/+Oy9kMhun
	pMkp4y5sV/XmzYcFeID7npqycVFsAEw==
X-Received: by 2002:a05:7022:108c:b0:144:f096:4dda with SMTP id a92af1059eb24-19939c2b3f3mr2567006c88.43.1792849595290;
        Sat, 24 Oct 2026 06:46:35 -0700 (PDT)
X-Received: by 2002:a05:7022:108c:b0:144:f096:4dda with SMTP id a92af1059eb24-19939c2b3f3mr2566979c88.43.1792849594676;
        Sat, 24 Oct 2026 06:46:34 -0700 (PDT)
Received: from [192.168.29.10] ([49.37.153.119])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-19894d5a10csm7566869c88.1.2026.10.24.06.46.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Oct 2026 06:46:34 -0700 (PDT)
Message-ID: <035464d4-852e-4a19-b030-a1d97e818979@oss.qualcomm.com>
Date: Sat, 24 Oct 2026 19:16:24 +0530
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
Subject: Re: [PATCH 3/5] firmware: qcom: Add an TEE bus based ICE back-end
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
        Sumit Garg <sumit.garg@oss.qualcomm.com>,
        Selvam Sathappan Periakaruppan <selvam.periakaruppan@oss.qualcomm.com>
Cc: Basant Kumar <basantk@qti.qualcomm.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20261021-ice-migrate-tee-svc-v1-0-b035be7aab0a@oss.qualcomm.com>
 <20261021-ice-migrate-tee-svc-v1-3-b035be7aab0a@oss.qualcomm.com>
 <601fa952-3639-4154-96de-aa09cf5f692e@oss.qualcomm.com>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Organization: Qualcomm
In-Reply-To: <601fa952-3639-4154-96de-aa09cf5f692e@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: p2zvTTButlvPA8lKMrgYK29mpF8ObJDj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI0MDA1NCBTYWx0ZWRfX15WnHZyKN5gA
 qJ+glR/VTWr04ySnzPkTcZDZeHQkIDYkphX/pNNF1fCh73GY1cW1uqabEs5bV+uTfAl6mfPyK/W
 qPOgua3P3moILws5urj0Jlo3KG8nMJ1Zfts2Nqtd6xuDWW92V/20P8rjyLdSV94XveFISXUR1e7
 f0MTdMb4vw3oRIv+GFXhJ4KJCNGAYAzP4UBrpmXvJ7X5mVGYxazyo39DaFsMCF0Dc9P8zFij1vN
 0XnQAOH20uxElGcScuPw3f3/CPO+IvAZVA0QPwC12RYf5CEYiTkMGp9iN6D1BhgzXQ1kkgv3p7R
 q0wdgqwYRTX55qdImQg/wXdKhRkZHZGPG3ik0xYUtfVojE479lR91pp3itp4sZdVrDXhKKXq/En
 WfEscCPZ+RD80DKerA56uTpZw+OLrWpG38AbZ90PgJuiZmB0EFXD3NGSFtnHgN7Zsi/GgeXY/y7
 fsP08nmnaSLUzrec1bQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI0MDA1NCBTYWx0ZWRfXwzMDwWNuiYcY
 DeML8DJYUkKSTDeKcS+gOPYZylYvCqRSaBtWHofwg4D4MZ94t0o4q05lKxoo0KvoSHGfQukhsMF
 k6deWNqdLu6Q+2/DKU2eXIACJdkARzI=
X-Authority-Analysis: v=2.4 cv=UqX2pOwB c=1 sm=1 tr=0 ts=6adcb6bc cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=hZ1hWxSZf3UX9FuxeSnJ0A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=cmTAmlLTp9sgBaqDkbgA:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-GUID: p2zvTTButlvPA8lKMrgYK29mpF8ObJDj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-24_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610240054

Hi Konrad,

On 22-10-2026 01:17 pm, Konrad Dybcio wrote:
> On 10/21/26 5:43 PM, Harshal Dev wrote:
>> Add support for a TEE client driver which forwards calls from the Inline
>> Crypto Engine (ICE) service (invoked by the ICE driver) to the OPTEE ICE
>> Psuedo-TA.
> 
> LLM says: typo: "Psuedo"; s/an TEE bus/a TEE bus
>

Ack. 
>> The ICE PTA supports both ICE Legacy and Standard modes. In Standard mode
>> Hardware Key Manager v1 is supported.
>>
>> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
>> ---
> 
> [...]
> 
>> +config QCOM_ICE_TEE
>> +       tristate
>> +       select QCOM_ICE_SERVICE
>> +       depends on TEE
>> +       depends on !CPU_BIG_ENDIAN
>> +       default m if ARCH_QCOM
>> +       help
>> +         Enable the generic Inline Crypto Engine (ICE) firmware service TEE
>> +         implementation as a backend.
> 
> LLM says: please use tabs here
>

Ack.

Regards,
Harshal 
> Konrad

