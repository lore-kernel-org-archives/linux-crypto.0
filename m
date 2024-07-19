Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0A4184D;
	Fri, 19 Jul 2024 00:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721348760; cv=none; b=hfRoRKyk93ZZMXUWcN6tlGT15tUbMKM/mCcK7kK5Z/1hJ5KlfbXkD2R7U5YDpEpOCJi12rtr7Uz3lbjxAxBGcU6AKj8OCV3hJ43E+nexUlgc+ZwrzTF8MKs1G/w7+CHe5fAaw6VT6okvPf4FDijlTfgFJPD2J0pPqzOYokaf5eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721348760; c=relaxed/simple;
	bh=e8PUX7viv6AulBYL8Xf1z1M3XjL8jac6ifIkyd2O2wM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=HMAX/b4DV/6Vl2aWsyNus7iyMTtNeA0vfEs3K/JkB5O0RC8KXUXAiC+tv463r1CcqSa9uCVdcF+tVAigaueMcBFy4ZBBkOHJZ5kCOSRdTSAr/tEDFzuiWVrK0dpYI/fA8OkmmwwSWwiOwAG4Smq1wjpJnMQ1PB6xWLT/Or6H4wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=FiT9Uhzc; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="FiT9Uhzc"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46ICLeXP026945;
	Fri, 19 Jul 2024 00:25:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	vVe8gBu1FHvCbBfTE5T+pB0LJssvC9dbvIOsjYOJ9ag=; b=FiT9UhzcIy4pewo/
	1I6yJaStfAUunFNzL1VZVovEsfo1n0tIcgaAJQkTznJYr3CwCKyq0PhYYibAs/n2
	a4N/T4/ob7GvBM8jRtEeJGAd0++bTwzAO2tn+IJpkKrBqZ4sQZ2CqIhvz/TGJ3vh
	RpqFrIlT40eL8ofAkTA1eNsVs7MbBIjQL/f4QYDEpzLAN398fZsKH/88IU+6jHc/
	fiD8dEf1bAgPvYLVRnHSwoi+DMGx8uljvMwjrcv4q317Ct2TKMO72aJTdF4D/ihZ
	19JiAlklb8C3stRfAKzy2fFhfCt3ejPZ0L1CtR0N4/NrR/XKCJkcKNPw5tMUt7fE
	Yaio0g==
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 40dwfs7392-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 19 Jul 2024 00:25:25 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA01.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 46J0P9SB020987
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 19 Jul 2024 00:25:09 GMT
Received: from [10.81.24.74] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Thu, 18 Jul
 2024 17:25:09 -0700
Message-ID: <e27ccb59-0a3b-4845-bec4-f64830b2492e@quicinc.com>
Date: Thu, 18 Jul 2024 17:25:08 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] crypto: X25519 core functions for ppc64le
To: Danny Tsen <dtsen@linux.ibm.com>, <linux-crypto@vger.kernel.org>
CC: <herbert@gondor.apana.org.au>, <leitao@debian.org>, <nayna@linux.ibm.com>,
        <appro@cryptogams.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <mpe@ellerman.id.au>,
        <ltcgcw@linux.vnet.ibm.com>, <dtsen@us.ibm.com>
References: <20240516151957.2215-1-dtsen@linux.ibm.com>
 <20240516151957.2215-3-dtsen@linux.ibm.com>
Content-Language: en-US
From: Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <20240516151957.2215-3-dtsen@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: 4SaSaKnBK17EHCcP3C8wigKZvVER_YJQ
X-Proofpoint-GUID: 4SaSaKnBK17EHCcP3C8wigKZvVER_YJQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-18_17,2024-07-18_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 impostorscore=0 mlxscore=0 phishscore=0 suspectscore=0 clxscore=1011
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2407190002

On 5/16/24 08:19, Danny Tsen wrote:
> X25519 core functions to handle scalar multiplication for ppc64le.
> 
> Signed-off-by: Danny Tsen <dtsen@linux.ibm.com>
> ---
>   arch/powerpc/crypto/curve25519-ppc64le-core.c | 299 ++++++++++++++++++
>   1 file changed, 299 insertions(+)
>   create mode 100644 arch/powerpc/crypto/curve25519-ppc64le-core.c
...

> +MODULE_ALIAS_CRYPTO("curve25519");
> +MODULE_ALIAS_CRYPTO("curve25519-ppc64le");
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR("Danny Tsen <dtsen@us.ibm.com>");

Since commit 1fffe7a34c89 ("script: modpost: emit a warning when the
description is missing"), a module without a MODULE_DESCRIPTION() will
result in a warning with make W=1. I'm in the process of building 
ppc64le with CRYPTO_CURVE25519_PPC64=m to validate my suspicion, but I 
expect this to generate a warning.

Can you submit a follow-up patch that adds a MODULE_DESCRIPTION()?
And since I'm trying to fix all of the existing issues in 6.11, Herbert 
can you push this to Linus when it lands?

Thanks,
/jeff
