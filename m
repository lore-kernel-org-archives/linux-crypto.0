Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3E115C13C;
	Fri,  2 Aug 2024 16:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722615229; cv=none; b=QpNMhkHREivYI/YRPUSqpnavJeyVKhtiY5ImU1doU9fJpgA8OJ446fBiGvqa3KZErXcVr/1kwqz6Be2xhUnVRD9LhQI6kZXmM9znNtZxGEc3jkdK9vi0T+LhoBwrgJ3oA9QrE5pb+PMyoAU1k6BWKVnTB5G3VFMnmWB8NVy1KCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722615229; c=relaxed/simple;
	bh=/7CaU8cFVRs8SSowdcAlAKQN0I6TZSX6MZ/rIFbdsVM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=gCrUZHzxb9DvnV7kgwletHpOfO6ESeyyjKjUhzBCbPV4tvW4TpNcne8BAd0hqQkb7fYwVnlfq0czaiu3eSqHhANQx2b4ZUImJuHlVpo7Elyu79kOic47NTGUdOb7EWQpnXPXTzUzmNRp4EY9M+zsRwghLX/nhR+s5v0CAA5Ox0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=VeegD1JZ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="VeegD1JZ"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 472EACwD023760;
	Fri, 2 Aug 2024 16:13:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	zb60TfBYM+a5pMbLi9F+/DtgtdfZ9SS0BcxUtqLgWHM=; b=VeegD1JZrmp5xGu2
	I6K4rap5+mpYCizUf66qphl7uzgasKA2evx1ZVijI31PvM6K4L2uNJp5iaWNvv0E
	ihfb6aF9NNNWzRQS4e37SIvBTOh36P/o1QrVD4/xCOTeR+IaXTAxbmhwyXq1vkw3
	ejCtGJ8YP8E93Nl1WYY5yC/L+COeUddgqXM6p1OhXNmk7V6xHZGvPis3pOOkDmlt
	tCZaMvW+c74MGt+fSRc2s8Hih1cM4kVsplxqE5ILOM5Ox2aGfOMsV8veOScUhVZk
	JvFiytj9obrxQP0UusWF5Lg9jjhlI8w4LQe2nIVAg344S463ZGPjyi9T8rd8XcoO
	lKYKyA==
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 40rje6t3ag-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Aug 2024 16:13:28 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA05.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 472GDSRO002242
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 2 Aug 2024 16:13:28 GMT
Received: from [10.111.177.74] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Fri, 2 Aug 2024
 09:13:27 -0700
Message-ID: <2a1f5b08-5c5e-4c16-89a9-69eb920d1f44@quicinc.com>
Date: Fri, 2 Aug 2024 09:13:26 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: ppc/curve25519 - add missing MODULE_DESCRIPTION()
 macro
Content-Language: en-US
To: Arnd Bergmann <arnd@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>
CC: <kernel-janitors@vger.kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
        <linux-kernel@vger.kernel.org>, Danny Tsen <dtsen@linux.ibm.com>,
        Christophe
 Leroy <christophe.leroy@csgroup.eu>,
        Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linuxppc-dev@lists.ozlabs.org>,
        "David S . Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
References: <20240718-md-powerpc-arch-powerpc-crypto-v1-1-b23a1989248e@quicinc.com>
 <ZqzcApbJomFTnc30@gondor.apana.org.au>
 <75a526e3-3101-4319-b42f-4482ba188abc@quicinc.com>
 <6fdd8f30-4df1-447d-9156-5d2314239e99@app.fastmail.com>
From: Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <6fdd8f30-4df1-447d-9156-5d2314239e99@app.fastmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nalasex01b.na.qualcomm.com (10.47.209.197) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: Y7YufICC5Uy0q04j5zhcN7WAQ60I3hz8
X-Proofpoint-GUID: Y7YufICC5Uy0q04j5zhcN7WAQ60I3hz8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-02_12,2024-08-02_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 spamscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0
 priorityscore=1501 suspectscore=0 mlxlogscore=999 clxscore=1015
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2408020112

On 8/2/2024 8:16 AM, Arnd Bergmann wrote:
> On Fri, Aug 2, 2024, at 16:27, Jeff Johnson wrote:
>> On 8/2/2024 6:15 AM, Herbert Xu wrote:
>>> On Thu, Jul 18, 2024 at 06:14:18PM -0700, Jeff Johnson wrote:
>>>> Since commit 1fffe7a34c89 ("script: modpost: emit a warning when the
>>>> description is missing"), a module without a MODULE_DESCRIPTION() will
>>>> result in a warning with make W=1. The following warning is being
>>>> observed when building ppc64le with CRYPTO_CURVE25519_PPC64=m:
>>>>
>>>> WARNING: modpost: missing MODULE_DESCRIPTION() in arch/powerpc/crypto/curve25519-ppc64le.o
>>>>
>>>> Add the missing invocation of the MODULE_DESCRIPTION() macro.
>>>>
>>>> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
>>>> ---
>>>>  arch/powerpc/crypto/curve25519-ppc64le-core.c | 1 +
>>>>  1 file changed, 1 insertion(+)
>>>
>>> Patch applied.  Thanks.
>>
>> Great, that was the last of my MODULE_DESCRIPTION patches!!!
>>
>> There are a few more instances of the warning that Arnd has patches for,
>> covering issues that appear in randconfigs that I didn't test.
> 
> Are all of your patches in linux-next now, or is there a another
> git tree that has them all?
> 
> I can send the ones I have left, but I want to avoid duplication.
> 
>     Arnd

When this one lands they'll all be in linux-next
