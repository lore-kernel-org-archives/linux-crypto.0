Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D4F37C119
	for <linux-crypto@vger.kernel.org>; Tue, 24 Feb 2026 11:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771932649; cv=none; b=dFv3hfPf/1+KFp0Jb2nHDzutRoGCPJodsEzX/QVc9TO8GKZkzKjEqjeUDp9cNqK625AKJaLDzLmEmYovLHRuJEMuhCv8lv0ofSS98DpXrBMjfpSgHFdAq868amHrhiHMITHh7QHwtH7393qGehXZ+G7hGRRTGVQ5B7IlnFd3gYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771932649; c=relaxed/simple;
	bh=NR5c2lqcGrUDgJqbWlOyrsK1Q8UFahTNzG362eLtZrk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X8MMSRQGSL1zdbunoR9tXB/U5DubwKIZhEzMkhdDJbe1iDweTAxnJcVaWsGz3pFFhhCn1iYWGZ6gd0Y0bonILmNTL+S3WnfP+dLRQxlMho5E/Aygr/dfJbmj7dtgP8vNoN5FMa2c3vb/a02OnbXUtbn6a3t+YCgjHuHDOZQsAto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=fk6ZFC3S; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=imNqSxHC; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="fk6ZFC3S";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="imNqSxHC"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61OAFYkT2512787
	for <linux-crypto@vger.kernel.org>; Tue, 24 Feb 2026 11:30:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	+EVLGgc9YOc/CuzuU/mzpF4YtsaatUWJt8Cqs4/tWyA=; b=fk6ZFC3Sc6sWMBRt
	6c+LK96hyMmHgRDxerexVfqJgOFyPEAmIj7oOKh5iEAcVSDaP+BNHdkdFeaxMe7n
	RhJohlZBVMoxxSYr1heZwef6ODOxNin91hEa1IXZ3k0gFvdQxCbDpffmPij1xNnc
	lwDYGAFFBE7OCd8SLA4d6HvHKekLMqPEc3gCWyDMST79MX0LyB9qAnPskAUtDjXo
	JqVIInoJvf8W5U0NoxhXOGz8bIREDautsZ2/H1XpJv/26AC+fD2xSYlY/l2BfmJu
	dDeHosorAdGLgJcNhrondD4OK1ZCQy9HygKj2TTK7yUkKlCqYZTNMa0nSpXXmDEw
	BcpR+g==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cgn81c248-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 24 Feb 2026 11:30:46 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8c70c91c8b0so528745785a.2
        for <linux-crypto@vger.kernel.org>; Tue, 24 Feb 2026 03:30:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1771932646; x=1772537446; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+EVLGgc9YOc/CuzuU/mzpF4YtsaatUWJt8Cqs4/tWyA=;
        b=imNqSxHClTlHTfZon8l6RxGWMH0mZup8etIvUiCI9KmiSRWr7jqr896ZDXT9uXyqe6
         lsEEOgJuX45SpIlO7LLZddlolBIBO7OqQdBZTC2luXiIWz/PfEcU0CkXi7dOOK9Kbwnh
         daDHOxsgZyJ4AVW4KyYyI31PpdeVfacWoZ5noTlZEEyL1qmk/tDSdr1sl5jJ4rrEHfHN
         YtOKVY/LnJ5EUx+Bl7g1qxqqBIbEE4YoVj/CGDc/IDU+8hGq2XhQhAZ/TFSeRxWbLG9o
         fJgJIRZ7tSk2bKNSBqXDoI+IcHx9C/MC70vr38Wa3+TVMjTGMIkp/tIFJZVopAhcfJUH
         jWXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771932646; x=1772537446;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+EVLGgc9YOc/CuzuU/mzpF4YtsaatUWJt8Cqs4/tWyA=;
        b=FOS87pilJiAZIu0PDNFjh9Pze+v6AYNvaJt8yYyC9RDuAwIyRBz9RafxSjJDpC/Huw
         bhg4N2dtr3MxdT0vuGopjQL8zQza31woHRHVnPBRaJnpXK9kZwqfFvSm9MrdNUWFq3eo
         ShJYfdf1ZqnOk2PAk81zobtuf4972MwqVuMdRcalOUJO0Aj2a9rMREktyumn1e6rO8jG
         v7xyqMmE3f3uxFSelERJn9zMveAuOFCwgJ1ecW55PXOfNbefNq8vPOeZUMMAbZgV4J1J
         rt44+YT6ppHCYaz7ZsL+yPEMN/YxAoocQdEOi1ZO5oZFAD3yFCu7Ei8X2j+HD3OKHVD8
         CDjQ==
X-Gm-Message-State: AOJu0YwyqDf1v5ZmUaK7HzqUTCQBOwiMkKDGxrh6fm6cu33caAIX+ve7
	VObHh3Z+pbW/vfVixM/S+qMNg3EwK9qMp+Y7nCmbMZXOmG56vxgdJl1UoF1oy5jwABZ6+u+sk/2
	N2sZSPECJhynGhpPU8b0Wd+jaxdZtt1w19sLgox8YMamoD/w2bPjDQt8DB8YENRkyvWc=
X-Gm-Gg: AZuq6aIPwdF68TX60VwoHlGaHYFKLc3SHP9Jel7+mF+yCWif6k2Ycz+7HCH1QCKvTZs
	VUBkgP+eisg6lB34WAFBw9/ancPjk/GFlgRqIA6AmWs1jEqJ6SlotLzdLHRII7tKaMMKzLpMiHj
	Ek8jJiuYBbR725XTXRcZWI0C+lzfQvQiO/5FtTPkr/vwwcRSShKbrl7GYGyOAk/tMbPIkxY4Oxl
	sLN/iFE8iNnv71UJ3/8hTEOvX9Weik8vjrOmCO6utzPBTc8wqh9puEdwj9qJXXQQVgL7zawk9xm
	sUOrlGEsmY0boFGpc4mkA1U2T4kRK0L0rSjbGDz3J0v1NDunj60umv4xJ5669yxZ5eI26Q7WAdo
	Hy9AvFFdR+FK3eN9ToFvv+MKSqPlfToaVhqmK+bMykoDaCw0lL3JdLjzlx99+74NvdSsxdDQrP2
	tzHr0=
X-Received: by 2002:a05:620a:1a25:b0:8c7:1aea:53b7 with SMTP id af79cd13be357-8cb8caa40f8mr1146305585a.9.1771932645787;
        Tue, 24 Feb 2026 03:30:45 -0800 (PST)
X-Received: by 2002:a05:620a:1a25:b0:8c7:1aea:53b7 with SMTP id af79cd13be357-8cb8caa40f8mr1146302585a.9.1771932645173;
        Tue, 24 Feb 2026 03:30:45 -0800 (PST)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-65f73b56602sm124824a12.9.2026.02.24.03.30.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Feb 2026 03:30:43 -0800 (PST)
Message-ID: <35288ab6-bc18-44d6-94b5-756c76992067@oss.qualcomm.com>
Date: Tue, 24 Feb 2026 12:30:41 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: qce - Replace snprintf("%s") with strscpy
To: Thorsten Blum <thorsten.blum@linux.dev>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260223155756.340931-1-thorsten.blum@linux.dev>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260223155756.340931-1-thorsten.blum@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: u-ILUsWCopSsDtTh3X2umD26logpx0cG
X-Proofpoint-ORIG-GUID: u-ILUsWCopSsDtTh3X2umD26logpx0cG
X-Authority-Analysis: v=2.4 cv=CbsFJbrl c=1 sm=1 tr=0 ts=699d8be6 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=PzOCrqrjzUU8T3-Ey24A:9 a=QEXdDO2ut3YA:10 a=vyftHvtinYYA:10
 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI0MDA5MiBTYWx0ZWRfX+9Mm717MhO2W
 HCbWgd93fWEYQA5zUrA/pyxHZdvRSOPe8KVwjA810HgaKbB0JlG0WIkTfjs1t2NIWxdqc1QZBoS
 gCdAq8IOUc1WlQUeCAY72tlBJepan3SC/g9TT6CZxkyNo1LkHtDeTCWEAmjD/JqggYo3SgTSfgF
 zeVoFNePCQaUwKoJ4EKo5X75fsYlEP6Lee75C6Hd8D+ZQqKexigE9UuFLWztYAmpqnoWGQJOjiY
 Ucu9ymMqnsI7nA4WzxdkxjwEL9Y2TbzeTNbMC28JTpgpxfazYWN7KzoQwGjdnYJq/t22Egr5LRI
 EaNsxBWk0v7CuLto0cBMhb2l/B7kS7JnN74LsRDzMXXrP8hoOLiWoyZo5Mi6sfLGCQjwa9xHWFf
 l7eyVSB/Yds6/wZD19Xh3utEX9Oz2bC0jbrRVPoCQCRRQlDJqwDuK6bwSziKJSNuQ6IMudz5bWn
 kBW44YHYF6hZ3AuMpHQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_01,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 impostorscore=0 priorityscore=1501
 suspectscore=0 phishscore=0 spamscore=0 malwarescore=0 clxscore=1015
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2602240092

On 2/23/26 4:57 PM, Thorsten Blum wrote:
> Replace snprintf("%s", ...) with the faster and more direct strscpy().
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
