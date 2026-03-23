Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB5F390CA0
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 10:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774262873; cv=none; b=nTZ68Z11+AsmDNbr4/qVSxylUAI4JvWUgGFKIBOUe1BWUXaFF19tJNEt1O/6cmfNbYhsKNYetfslaF3qwbe2vUYCzmM+a3mZkaW4V1yoKtNgdVQZA8nLrVAh437EepTwGZPvsRFacqXcMn3jlKJuAUbtz3NlNpWMJt0c9JGeyzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774262873; c=relaxed/simple;
	bh=Fw85m0v6Mph9KZA5cy+74jSLm3vBvqqJoAfIxKRwDG8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hPQ1FiofuqiIr2q49vOg6YyaAleQFRYuYW7ApR4YQiW4Hw3dQSp9I7PY0+PAJIPxeB7zo98vITQJmV/8RQkyTeFhC2aBqEjFNV6MzESYUjdn4UyEoPXszzitPed2GQRiDWiCCF1rnOrcKgWDezBitCzja2AvIbNkYFgntgvQ4oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=fmI1fSy5; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ErNTddbN; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="fmI1fSy5";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ErNTddbN"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62N7tEwC2291313
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 10:47:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	jBS5kZecRx7sToL0JGFpxeH5VhmJZeSLtK5muQXggYQ=; b=fmI1fSy526bTBKzl
	VOi4K/WIBstfPV986+lm4kKJcBAHr6oG+Fo4P5jOab8rk9GonY9kXr81zt5qXXrt
	stiwtAguJYbV1v6z1hAYEBkcTmOvsTojAepY9VoIvg/WYqyv5YsR8dfhx5CUPmGc
	yClfyRN0kZdyOn2FRnf9DO4RaLXisoJ60JXEhuwy/8I37ssaOFtZa2CnIH0ijUCr
	sAceRnvSF7Evj5YTAXA9XA3ZrEQBhOEsL8dAys1o/quDyBWSOE/kdtqZ8PwNJ/4m
	1sCPNixmls7c5lJ08Ovu/CDY+HYlhj7IGADK/pgt6z1OqEFhzY9GCPS74/6e1XKR
	bFHi7g==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d31j70kpg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 10:47:51 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-50b68af943eso1304081cf.0
        for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 03:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774262870; x=1774867670; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jBS5kZecRx7sToL0JGFpxeH5VhmJZeSLtK5muQXggYQ=;
        b=ErNTddbNyL4VFd6YptN22GoP7ZxydHBWG3aAMDsLmSLx4Ipldk1unjtKVFWxpbRSsk
         qPo5/Ios+aZZSCoekBrBAJh0SeQZBphlrEj1N+eNZY3rtYPd8seuA1PPl6D+mBmktKGp
         3lvdcMEVkoaLEsShOIEXcumVpP/ai78Arm/jGn2z1BhNFiwVll5AxGozXT1SHBNw1M9F
         7qnqLjF1Ol9eYm1eXpR4DsnT2sqKufkcdeuEE5TDAgk2S56lT07lF4iYz2Uu4aE2hYEn
         ARFAWsmVxJh+U4ihbMmf2eoISSLCZqGX/ODYTzTnVfzYavwGPoPJ8FJuGwyQGi3CqXtg
         YJlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774262870; x=1774867670;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jBS5kZecRx7sToL0JGFpxeH5VhmJZeSLtK5muQXggYQ=;
        b=JTVC7Y0tGn/GnbPyqpZIJVzVto4rh7yBoQRg2/ag4Ncu1oTqLr8lU8qTK3e7pCzi2g
         EPo3hynii1VHLYP075li52SY6ze4P7P8jNMQfCmZZkcUJ+3dZs0yGEOwNCUUL2fqOfMu
         XorDoTtWkFMPjhtFpnDNOTn8tH/mH+JM+jh/Ufo+ADL5WDLk9vBVSQEM6KQDksSuhYT9
         IO1Hmy+mFN0Gx/vSFskePRRWTzpDsxTBUFh+vdEcZkyIshwn9igi5fw+6Y/SjiHsSx9y
         okpG82i1yvme6pgt8XXRrlja584EMUhozLC/lvWLth2DsSiGLxraYkCVj3CeGaH/rg1I
         2aOw==
X-Gm-Message-State: AOJu0Yzf6HhXut9xxTlGgdmPKn+O/vmVAieC9vvm4XHrBPfHQDV4uUTd
	Z9R9SRLL6QMl0xKDwm6L6NMUjr8UiO9F+5r3Uc+8im1WAWJ/bINvzsHxCdBMSgUZYr2KYYc5yed
	OjLZW1O7j6dUYidn8+/CuPOF0UqdMB4rTbkcjs5yB2TWMTtGrsF0D7J5YOEKf2nRFJnQ=
X-Gm-Gg: ATEYQzyiSwvY/FvABUz3x14BkIukoFHaYCpQsfBRO4W+WdjXCyi4ei5aqv614aL4qVu
	5e6uVA9w9nv13nUufKufZPx/gA7CNl1DyG+hocUiGu/w8U7QguDXa/Bs8+weiqB41lbtUWSdIo/
	jv+kUDCk7NP4EvhO8wQKGQgt0JpsIPd//wyCIUsBsxpGrv7fh2G8sjaQsZ6x5YLzhbHgBAPRDFe
	jbdl+/jIX8Zb7F5hcxE/0CxQ6RFQVafM0wvqILkrx6wcnv9VRhhiul/U1I3Lb8rBHNP0Ef/SI+s
	LcY30pMTjEl6SqmjSuKurbxi1vwzT3gMDR331kouCoKFGU3DkGwlA9hatYwtMPe9JKpNSeQqtUk
	EKCwwSCeXEZq9tN8wh/siC8pSUFMWVVZ1ZYd6C7gDYQykzXElUUoFZl9mKOY4mn+fikPAWLARVB
	nJN40=
X-Received: by 2002:a05:622a:46:b0:509:2a92:8088 with SMTP id d75a77b69052e-50b373d0bfbmr148346081cf.1.1774262870231;
        Mon, 23 Mar 2026 03:47:50 -0700 (PDT)
X-Received: by 2002:a05:622a:46:b0:509:2a92:8088 with SMTP id d75a77b69052e-50b373d0bfbmr148345921cf.1.1774262869832;
        Mon, 23 Mar 2026 03:47:49 -0700 (PDT)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-486ff1b4491sm79083225e9.24.2026.03.23.03.47.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 03:47:49 -0700 (PDT)
Message-ID: <29f85af4-624e-4610-a93a-b77483cf4ce8@oss.qualcomm.com>
Date: Mon, 23 Mar 2026 11:47:47 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: qce - use memcpy_and_pad in qce_aead_setkey
To: Thorsten Blum <thorsten.blum@linux.dev>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260321131439.40149-2-thorsten.blum@linux.dev>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260321131439.40149-2-thorsten.blum@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=ArXjHe9P c=1 sm=1 tr=0 ts=69c11a57 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=PzOCrqrjzUU8T3-Ey24A:9 a=QEXdDO2ut3YA:10 a=vyftHvtinYYA:10
 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-ORIG-GUID: khc_ADQqmaaWA6TZCoj4KLO9txeMHC90
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIzMDA4MyBTYWx0ZWRfXzy9cyEBzVPeK
 xGrtXQcXfD/cUcnpex+Wk2WCoeKCT8SLRrzArogL5fE2zC0Tmlm7zOdnyBWBD6cl6R6NqVMv9yj
 0ZTmObjqu3d/Wf5UDsOZKKqtYHqFdFD3FcBzr94n8RgFuUBr1infQamYuUjvARA0tBxsioUZxOo
 Gaapf6Nge0XhEgLbBfGNON3B3J3aUn5UxCDmW3PWmKYUcXjCR1gi4kIERbLguL4s+WKIK1G7clr
 NjNdXH7jssSHs/PXq2FsYGixRV6igTGytX3nRNjJtksSoFdzOsSvrwpCEp+yLpbYGCL6zF2B1s3
 aPHdViM1Nnc0O7q3pIQA0zR6OnSrD+Huw/oSTIDyROA9yRl6gTG4ofKlWniAR49Obus5WYzK6Do
 M3sxmnBJRNLVeiihwcIcro2EZSPIZTo9Mw4gmFokltIYBMwSdVKU6UkKkzYCjViUHrUAs3qv5SK
 KfZxBb4xFege/WeIk/g==
X-Proofpoint-GUID: khc_ADQqmaaWA6TZCoj4KLO9txeMHC90
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-23_03,2026-03-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 suspectscore=0 adultscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603230083

On 3/21/26 2:14 PM, Thorsten Blum wrote:
> Replace memset() followed by memcpy() with memcpy_and_pad() to simplify
> the code and to write to ->auth_key only once.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
