Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCB33E63A3
	for <linux-crypto@vger.kernel.org>; Thu, 28 May 2026 11:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779969304; cv=none; b=CssZFo3tnM82Yf6dVoZxl6CuTo61970D+MexLOEI4cM1ggAqAWMqRz95WcDkQHRuRQyIqy3d8PoNo0ijbZRONg63GAS3dGnhDq/rU/J0X19bXwjVQoK26Zp2dpvvCZs6JkQEvwkR6OMf7eRWBgRSHm7jyElFonNfeoF0vaP5Q8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779969304; c=relaxed/simple;
	bh=ESZdAJkvYN+GKJn/c6N2sSmBuX0qgNWKfn+CcPsIkuo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=geCzcwJQlAiCBGktgoMGi3S9leXbIat6xnPPfhdf56daDqCnQ71S9QIzKBQeVwYEmDXGWDQGOMEPCUJCcXTEQuyg4mZChJCBYJbVURqb/TwVe3PeE8B6MRXBVDfqavBT/rBVa4MPOTVHnEvBYXl2nDg1yyV1+nRWzEvOxRSTpe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=C0PebDQ2; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RSaRxZ0a; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="C0PebDQ2";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RSaRxZ0a"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64S8vU043203254
	for <linux-crypto@vger.kernel.org>; Thu, 28 May 2026 11:55:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	xwgyWXl/wbAR1I0i1THed+XapjmeMAOQHW+lUWk4Flo=; b=C0PebDQ2V5/4638E
	JTnPHae4r49IccWGKPrq7STAqtJjbTaOeVJZHcUp7VzeHsjY5NEJIILjJl7XtsD5
	yCL3+680nVwJsI8EZHXOK9O7QfcJcfszTmBmQ8ko2oMpnzQLGc7mpaOZ9C55NEzG
	cyzKnLCwPdBIE5VrPP/mVXajQk6/NxC0Q2VG8X92YCAMTrhy1O0XpwMbHmj5aetj
	5Hz0IrJ4vEJky7+4AzenSgLUj2K9fq8SO7tlconxL2CMB+V5rxefRbkf5eMWN+Fn
	ymbYOAmTO6qLPMfqNWjnbOaY/u7UBb3IRDlf2KJdtX9d2wC5EYdNm9Py3icEQzA3
	f5JWlA==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ee7ynjkun-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 28 May 2026 11:55:00 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ba718173d1so83750745ad.0
        for <linux-crypto@vger.kernel.org>; Thu, 28 May 2026 04:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779969300; x=1780574100; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xwgyWXl/wbAR1I0i1THed+XapjmeMAOQHW+lUWk4Flo=;
        b=RSaRxZ0arTI+iAsesq9XUhByNm12dpuTrotCiqq1zSfdJD59ypBI4/XlZ9RwP2HSJO
         5JSuMgNCmSFZ1B+RP9we2smMw+dsYxWmlnJ2X7WAy0Dbfl4a7z2IHd1XZzytob/i6T0m
         Jyr2rpLkkfy5IUQWayRH4npy1nmF0kfCVS5xuH+BZvktMP4UQ9Fwp6ecOHq1yRWjZo00
         QSSVm71wK8XStyuNotAL0JuKs52di82bVbMDezw/tF60LrWqO+Oua7QOUauxaX76UWkS
         ZafiwEdfTfNwmg/o6To2thBRmkOeeVXO3IvpJa1VM4Hk6ZvVNY8otbnaxFIux+l9VqQz
         SZtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779969300; x=1780574100;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xwgyWXl/wbAR1I0i1THed+XapjmeMAOQHW+lUWk4Flo=;
        b=rhwhGFCFraIXFy4fa3sfGZmGC9XqYrHvjvStWeb+pm3WOwO6Fnvb11b3hi/H1ORcpz
         IIKTbPY4CVeWDKLPv7TlKSdZP9fY8zhxYW0O3j/KHiEFptqbAxrc7TFuTpcsjjyCjhe3
         lu9b4nn710vmPOBcXIgyduMgjEQJwDE9PXEmyzXmfl1GDuA/Es7gsV725KIfLCNYvfsx
         kDXX/xTa784Y8LZwsHKrM2d+XSXECszi/QEvoyMWbdOnNg3HlXj1GZyUdj3vws/iQ3VW
         W+clgGpBVr/wHtfuG57xXpTZfDh5rCwxwOy9TcIXrE/hNcKWh5cgT7XkVC4I/SWnB8M4
         B3dg==
X-Forwarded-Encrypted: i=1; AFNElJ8zLoEYlKwIpxx7KBKSmz0RUbBrqe9+dsVznExx1oIn9yzlYFGKVOj4p9OVhKzKrFMdKj4Chp8rAj/++uA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyyJyPI44/mKvYlA48LTtWxRX/BL8mkmvVTW9+NeACcSEqgLWR7
	0lK5D5oIakWyCJZLZuYixuwV5RmR1qo8JHVVJ5ljUP2wZHxdTzj+9z2uKmHNHtIMgqTzdDsJncu
	h/+bZzdWuO4Oi9lNqhAXOXfW7lZtkRJPOyDZqPvla2IW6cerO3NdGFi+AIxe0zfzCnHA=
X-Gm-Gg: Acq92OESzmerBVcESZN533Ra8+xjSJYub4qpwvIUGhlvpuyyOWJFd4rU/BlUr2ZH/MW
	eCCvGY5Z93eXA751wBzz0JQ0KtQjY/A17MVerKNJ1lIowanYu9nWRz9tnVsBHcO0aOicdiazPOI
	rpZLhofwR1i6PEoyhZfiRCY5nfDxYtpvSy2doeF4/2AVs+C28ESesPElrUwX8lwrZg2BHWEqTrs
	vo8ppE2FUnl4U5PPK4uElZ0sk6d9wqdLpw3hrkE854KDS0T+bdyrI/aVFzTbdh7UlRC2OyjUuGE
	tzdebFrRKnO+dHyKRBL+SBbNm3UNK7PemJrQTtuOU75hfZ3V+r8N2FCvZicbDIgPMDffZeZRHeS
	rji2GjmrnB3pZ29f3OuI1UT1nBZih4ilf1pTMCr8F5iwKSzzL6+9InQgiexuG
X-Received: by 2002:a17:903:1c9:b0:2bf:b17:ae3c with SMTP id d9443c01a7336-2bf0b17b382mr25105475ad.25.1779969300017;
        Thu, 28 May 2026 04:55:00 -0700 (PDT)
X-Received: by 2002:a17:903:1c9:b0:2bf:b17:ae3c with SMTP id d9443c01a7336-2bf0b17b382mr25105155ad.25.1779969299521;
        Thu, 28 May 2026 04:54:59 -0700 (PDT)
Received: from [192.168.1.8] ([223.190.84.8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bf0534e4c2sm21854595ad.5.2026.05.28.04.54.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2026 04:54:59 -0700 (PDT)
Message-ID: <e49c4a45-6455-47f3-a91f-c32c1a0b99be@oss.qualcomm.com>
Date: Thu, 28 May 2026 17:24:51 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] Add support for qcrypto on shikra
To: Eric Biggers <ebiggers@kernel.org>
Cc: Thara Gopinath <thara.gopinath@gmail.com>,
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
        Bartosz Golaszewski <brgl@kernel.org>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>
References: <20260515-shikra_qcrypto-v1-0-80f07b345c29@oss.qualcomm.com>
 <20260514194735.GA1939213@google.com>
 <d4d35e17-84fa-4c95-9bfb-abfd25ea7f4a@oss.qualcomm.com>
 <20260522024912.GC5937@quark>
 <c1697372-54ec-4f57-85d9-ad375ff1a44d@oss.qualcomm.com>
 <20260525142843.GA2018@quark>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20260525142843.GA2018@quark>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI4MDExOSBTYWx0ZWRfX/CAm//iLTL2Q
 pQIPugMwkrBKrgZhjKz9rGnDbMxsGfJTjMqVJVaRqPR89jtba8wO+H+FX/CUduSBigZKmY8klAm
 gDy46yCeUvhypYnxDDuffuaGdFGKKctAUiQpXGWYyhj5NQAulsGvRdqgUUgKVyOnTK8C0jwXxSz
 OU8QszuilPc4pZUV5Ja9+ZDUj8V3VvA8Iu3RdCH9Q+xTB3MeO/w+mKhzJljg6ZXcyeowvdh4pwN
 xAQL1KcMFBcORuHFwqlQnXbKF2afDlogr3tpWT1kXQxFPmIpSLAnQKg4nPRC2twCkL6AqjxsQps
 4iH21zJXic7pHR0c2zEcv26TzkMi2+iL5QoBNzxD+0HGK7nWiiKO34FEsmeSkqMVJl5ESxUIFPP
 HRXMOSgwNs1C3zesjK3LOfpMrmK/6v+0HOBP/HyKxukPicEPsfqjWs4IokNHV+uRLEcj/V5mb83
 qrkhs8hQvQJBb3kVTpw==
X-Proofpoint-ORIG-GUID: tTik8avaqlglEDRwlIwkZvh3ngjC590u
X-Proofpoint-GUID: tTik8avaqlglEDRwlIwkZvh3ngjC590u
X-Authority-Analysis: v=2.4 cv=EdL4hvmC c=1 sm=1 tr=0 ts=6a182d14 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=PgCQwUeJFwcsjcK5ROf6Ag==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=hyd54oqyHhkzJM2O_60A:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-28_03,2026-05-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 phishscore=0 clxscore=1015 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 impostorscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2605280119

>> +Bartosz, Gaurav, Neeraj
>>
>> Hi Eric,
>>
>> GPCE is relevant in terms of providing hardware security.
>> There are multiple usecases coming up for example to handle DRM/secure
>> buffer usecases to improve overall throughput for secure content.
>>
>> Regarding performance, it's currently slower compared to arm CE but
>> provides an edge by giving hardware security which is considered more
>> secure.
>>
>> Btw, there's been performance improvement with new targets and we are
>> expecting to achieve far more better performance with new SoCs family.
>> Pakala:    GPCE - 550MBps, ARMv8 - 8GBps
>> Kaanapali: GPCE - 3GBps,   ARMv8 - 10GBps
>>
>> Please note, there's almost 5x improvement in kaanapali compared to
>> pakala. Though overall is still slower compared to arm but as mentioned,
>> expecting better performance with hardware improvements as we progress.
>>
>> Also, currently qce driver exhibit stability issues and that's what we
>> are putting effort in stabilizing the software on immediate basis.
>>
>> There's parallel effort ongoing by Bartosz to introduce baseline for
>> secure buffer usecases.
>> https://lore.kernel.org/lkml/20260522-qcom-qce-cmd-descr-v18-0-99103926bafc@oss.qualcomm.com/
>> There's active development ongoing and i believe lowering cra_priority
>> for qce is fine as of now and can scale values once qce becomes
>> performance efficient.
>>
>> Please share your thoughts. Thanks!
> 
> ARMv8 Crypto Extensions are "hardware" as well, just in the CPU.  They
> provide constant-time execution, for example.
> 
> Granted, they don't protect from power analysis and electromagnetic
> emanation attacks.  Does QCE actually provide those protections, though?

QCE doesn't provide these protections currently.
What i wanted to highlight was there are certain security usecases which
are possible via dedicated crypto engine only and not via arm cpu.
> Either way, it doesn't really matter in this case.  There are multiple
> aspects to security, and before even considering these advanced
> protections, the basics of security need to be absolutely solid.  That
> is, the driver needs to always compute the crypto algorithms correctly,
> and it needs to be completely robust when fuzzed by unprivileged
> userspace (because it can accessed in that way).
 > Yet, this driver "exhibits stability issues", fails the self-tests, and
> doesn't even have exclusive access to the hardware!  These are all
> security bugs.  That very much defeats the claimed point.  (Plus, due to
> the performance issues no one wants to use it in Linux anyway.)

Sure, we are analyzing self-tests failures and are committed to fix any
hung/stability issue in any aspect but i do feel it should not be a
blocker to add new soc id support.

Also, could you please elaborate more on "exclusive access to hardware"?
Do you mean the hardware can be accessed by multiple execution
environment like TEE and Linux?
-- 
Regards
Kuldeep

