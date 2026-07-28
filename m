Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A22A13B7760
	for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2026 06:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785219094; cv=none; b=nuEZq0oXosDuvhnVYJPf4LoHbROHjPAOt/+JpbHKrnNqAhLcfMnnighGC7I1wun684piiKFCYW61UcAFNfjVFwlOUO8djEtPCqt+TcZBArKIMy2Y4yhPH4JFCCZYs8uGOCSyHTXPVXckWky1kkU380IyOxvtGJ42Q8zXVoA99FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785219094; c=relaxed/simple;
	bh=6aHFOOKtboNgSiogTyncNEXqvun0rKOBVzzZnSx0/WA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B/4wx3Qsr63/nnfD7VFZAF2dDnmqgu2lZ1mC00ZrtaU2iswzQQWwB6YR46rixRIRE4xtbzMr12qH1UxvuOLAxfUAi0b2oXVK0lEWpyl+x3FeKYIbQNhBchYHdaCx+zcz/iy177ARViNIj0wtxHrCewbXmYbWMaCCn1/0MtqKOZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=edEt4A6r; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=bXQQ+09k; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="edEt4A6r";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="bXQQ+09k"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66S3abZ51527466
	for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2026 06:11:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	kyPUS7iDR3msB32DZY8rgImGvlDT2BnU4ZtxfBhBAfw=; b=edEt4A6r4exiUnnb
	b1+gRL/vNoxkem5PRI26EMyv3idsbNLpo8PDexU/opmYtT3NljNAS9PGIvfbFcKS
	nEwQzzdxLAuPxjkfGiiSKMdWWaqkDJ7c/rv7F1e7hMJKv98BNRrQt4WOXdJ9Hvef
	8lDyI6ocGgqzjB73T63JrSHtZMCr/yjh5RvwL9AbnevJpsdpxnoYnGkpxx0nUVyS
	3ZM/JIbSkNy7ouFpm6dEr+zi10GVSfSf7UOy4vj7X2o19gFin6zd0MWmS6bDGOp1
	AgzX5Itz7h+P57+5AF8lnQB2S5d+ACTtJqUzvBYcEvrvRWupIoJAhD+ZGzMcA8Vy
	sJIFkA==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fpbn8ap7x-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2026 06:11:31 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38dbf293831so8683910a91.3
        for <linux-crypto@vger.kernel.org>; Mon, 27 Jul 2026 23:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785219090; x=1785823890; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kyPUS7iDR3msB32DZY8rgImGvlDT2BnU4ZtxfBhBAfw=;
        b=bXQQ+09k+FSzoKbSdG4aW6NrQ/G6W/TVUKHwl6oMGbWlk7u+GTGJzNkvMSJVoAkXEE
         j3VRZsSuZqy5B2gvHriJ9NfFa3jmCbQFqrG9XA3qlygqklGJ57AGa/yH2uKUcbOmLfnw
         DnjndmZ0TJlBx4YBi3tMoSxziD6xI48hzDcVDXaDkcAqG9X+fOWWcbXjmz0nAM8RoLuU
         wY61W5jrgnQBywt4fWe4+2g9WbeT5bJflaG4/Iy+X0dPhsl3coaA6WmKROIJNt40VQDG
         jrHmzTjpityy++g3oQKyKoqpopT1zUaCl9Pc/FsQ//MpTfAJLlZSgSQV3I/vqDL6EW2I
         PY7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785219090; x=1785823890;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kyPUS7iDR3msB32DZY8rgImGvlDT2BnU4ZtxfBhBAfw=;
        b=meDR6M3ehhKco00yvzXGXRWhrdUsxAgnZFUGPKqtvoLbkWt89ns8a8cN0XGaKGbptz
         yGSHUkQmz/m4qezQt4QjMIGKl7n4Yf91d/dQ0QdowZJRmAMsOL7TswirLyaRL5uVd5/b
         dCkQxWIgwJYxv4VlGJcqG6Jlir8+A4vxxebd3VwoGHZguU6+BO8vM468CrEZAbU9w7Mt
         0bLga6NuGJ4Hz9w6o/H/vTYatP+/fEVXNPpIivj+m2KA0hDL2xe0jpFx5Gu58zyyY9eQ
         hX40UNWYDt/pnn1v7JA9vfOEyTF4UHxo6B9THj50Ox4zReYXoEZx76vfFvDygTPAHYbr
         1+uw==
X-Gm-Message-State: AOJu0YygeBAGuQGv1I3Xsojnz448xM1QfnUvv79zJsZTcKOcieBstq9x
	doz4kfOc2fXW5RGq3qC2/BSszW4SZvaNfe4k0nPvsl1cqAjSjeLHJ/w+weJAogN97CmZelboIOF
	6RLlcrs0tWKj6aXkZyS96XEIBVsPxhnc/agYYeDk7meUD0txFATWTKI4gX+WiCS8iaXw=
X-Gm-Gg: AR+sD11ksbrj2DidPf5FTN4L9poIcQuzUYEZ9DRoD9zKregHJsE8rAqMts9Gooq3qjA
	eCWIPpfVec5S1otpaHgoZf+RFsCvHZyCbZJ2yT1Sah2BTB72wxqa/JPZHw9YifHMrkfSeRYz6B4
	oCN8cs9MmnY1yf3Wv/2AyNMzhLAUntVSeS0/5AGHkzHKFE27cMywIit2vLBRxysx4Mbv83GGBLc
	FELgWMQi1NNVsjLnJWHehtgJZS0cOEhTliTo/mwAeRYtqi9tbb8Eu/5HbGqAoYbx9vAak4XcWbI
	Qsso+NPJ+Vhv/bU+OglTYQn1whsicG3+9UxOV1MrVKFQv/E/8TUHoPXimfLFRVDC5viIrQe8j9x
	S8Y1sOisdkFlhjXSVA2nScZEpmBMGiTc=
X-Received: by 2002:a17:90b:390d:b0:38d:ef48:b04 with SMTP id 98e67ed59e1d1-38f6a40bd5bmr1149428a91.10.1785219090487;
        Mon, 27 Jul 2026 23:11:30 -0700 (PDT)
X-Received: by 2002:a17:90b:390d:b0:38d:ef48:b04 with SMTP id 98e67ed59e1d1-38f6a40bd5bmr1149405a91.10.1785219090089;
        Mon, 27 Jul 2026 23:11:30 -0700 (PDT)
Received: from [10.218.31.125] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f642e34e5sm744240a91.16.2026.07.27.23.11.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jul 2026 23:11:29 -0700 (PDT)
Message-ID: <d5de5a55-eb35-4ad5-8d53-12e188e156cb@oss.qualcomm.com>
Date: Tue, 28 Jul 2026 11:41:23 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8] crypto: qce - Add runtime PM and interconnect
 bandwidth scaling support
To: Udit Tiwari <udit.tiwari@oss.qualcomm.com>, konrad.dybcio@oss.qualcomm.com,
        herbert@gondor.apana.org.au, thara.gopinath@gmail.com,
        davem@davemloft.net, Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, quic_neersoni@quicinc.com
References: <20260517105233.807935-1-udit.tiwari@oss.qualcomm.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20260517105233.807935-1-udit.tiwari@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI4MDA1NSBTYWx0ZWRfX4pMj96f3j6MB
 03QdBoO8XwUrq3+VFfS63vezy8DS7DdehysO3V5zbAy/nktQ+bxC/Ey4WXClYijVdGL4v5kJutX
 oI+iq+kDeH5x0aoTojSAUYzfqBmGRwoFwtJD0CwElFrNpoqnP5/JDzrzzVAZy0ZgmzrQFvvcDug
 yx56so/RNSGBbwZxhSBv3pDNW7Ufwv55+R1vm3JlWlS6d+vTJPhvjgb7Jq92UkJfmnV1e0wohOn
 choK57Nf31B7RH5nhAtIs8CJM4BYVQwUxUfYxlW9XOItfK67+JgQaBv/K/pXDpNAFolXYS+bcYa
 eN2bM3B0OL4bqX76J5rDZiRKniTwvINssEQMvuV2x/ZWQ0f6ud0uJ1UskOMNsO2qyMYHwkiAN7g
 OlM+M0sSxZY+KtMNumiGkshRyXZ430FlU5HPUHxS4yoBMUl6ZMsr/8lNahhgsS44ItJpYzSLZ7y
 GDAHfRrI+0IwILflnCw==
X-Authority-Analysis: v=2.4 cv=RO+D2Yi+ c=1 sm=1 tr=0 ts=6a684813 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=HDohle4KqOvtihE_74YA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-ORIG-GUID: XFYQw9nmV2TlZ7cJjURJJtNGduPPM_Vt
X-Proofpoint-GUID: XFYQw9nmV2TlZ7cJjURJJtNGduPPM_Vt
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI4MDA1NSBTYWx0ZWRfX0QzXrBH0ZaOV
 5UihSPSMO06iC34vOr8HOXFNUqFw3XOlm+xedlnVyCeWQ3xT3mogKoiYGgTyx0WjejZlrvHd6x3
 MPTEyxtZKzbjRe1iy01cpf92H4qmYTI=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-28_01,2026-07-27_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 phishscore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607280055

> The Qualcomm Crypto Engine (QCE) driver currently lacks support for
> runtime power management (PM) and interconnect bandwidth control.
> As a result, the hardware remains fully powered and clocks stay
> enabled even when the device is idle. Additionally, static
> interconnect bandwidth votes are held indefinitely, preventing the
> system from reclaiming unused bandwidth.
> 
> Address this by enabling runtime PM and dynamic interconnect
> bandwidth scaling to allow the system to suspend the device when idle
> and scale interconnect usage based on actual demand. Improve overall
> system efficiency by reducing power usage and optimizing interconnect
> resource allocation.
> 
> Signed-off-by: Udit Tiwari <udit.tiwari@oss.qualcomm.com>

Herbert, can you please review and pick the patch if no further comments.
This is required to fix interconnect votes summary for qce driver.

-- 
Regards
Kuldeep

