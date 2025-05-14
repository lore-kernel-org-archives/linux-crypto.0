Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB541F4C8D;
	Wed, 14 May 2025 08:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747211607; cv=none; b=DsDEX09nBCR5ouL34ju35IsLW5jaZb4CJ1/NT3rbNstpoX08Sd53TRmtN1kSYrUsOd4fU75+vaGm3xHQHRue9Wze+i5d3q7LFLnbkecDYTgz4IRBJK5/jqLQPP4SvxaEakfqkN2pkl53GDIva+W+qCG5bJ4P+0dywx3T/7+bRQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747211607; c=relaxed/simple;
	bh=fBfnQs4QLgdU5EyJXmISBqSJTZPma+17L6bPOzNcPOE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GxI1DWrvzFzjIfJyqHoIFxzrDSzMZQKpzgwkuggSFsA+dGdWESSqHCj5PJ2e5TrzrWcJhcPRwYqOjoSA+QGG0A1R3RIR7YFGLtgRFVvdMjJ8lbTwfZ7vT6+u81HHTIuNa6OK0qORKQEqbEzWjJE93DiestYunfo3jfHGKyqeFyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gMBSdfaH; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gMBSdfaH"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54E6nnL3025334;
	Wed, 14 May 2025 08:33:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=M9FQzP
	D+DSEcVIkH7Fje1viokcXhnfoGqrBm3APaNYs=; b=gMBSdfaHwQxTj/SthNsfUn
	8CRlUvAZGAuW/+YWwEiF6zyPLsPBZ1ZVnw8eVWyv/U+859/zrV8j0134u9nZuF+B
	tZAIAHaWQwmK5FQw4hKpFpS8+Z+uBd+ZjmGzUWyrr63DFc6rLYAzehWO2H2WzsVb
	tOLKO0a8LH5qz/XZ9X0i7LWi6F3IM8GGloK8ua3vHPGcu9/EiTvMAY6O5tsw9h6N
	OEF+thaYvJ5hXXqKtGpP8Qv7md/nHG0Ez0C/4pawoQ6n0ufRWOQPcnz/XM1RoaU9
	JmwqAxY2MLD/mPTW6HECQm9Cj29T3YTaT2iAdtj9g1xYzKnwSOPWhV9x07j8TtvQ
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46mbs6k127-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 May 2025 08:33:20 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54E67eBT021414;
	Wed, 14 May 2025 08:33:20 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46mbfrk7b1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 May 2025 08:33:20 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54E8XG9i35193582
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 08:33:16 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0B0A7200EB;
	Wed, 14 May 2025 08:33:16 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A2BA0200E9;
	Wed, 14 May 2025 08:33:15 +0000 (GMT)
Received: from [9.111.42.183] (unknown [9.111.42.183])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 14 May 2025 08:33:15 +0000 (GMT)
Message-ID: <cffdc85b-ca01-41da-9cb8-390322f20253@linux.ibm.com>
Date: Wed, 14 May 2025 10:33:13 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] s390/crypto: Rework protected key AES for true
 asynch support
To: Harald Freudenberger <freude@linux.ibm.com>, herbert@gondor.apana.org.au,
        ifranzki@linux.ibm.com, fcallies@linux.ibm.com
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
References: <20250509102402.27287-1-freude@linux.ibm.com>
 <20250509102402.27287-3-freude@linux.ibm.com>
Content-Language: en-US
From: Holger Dengler <dengler@linux.ibm.com>
In-Reply-To: <20250509102402.27287-3-freude@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDA3MCBTYWx0ZWRfXySB1mGC8j2X0 kO69W6GtFilDbi4s1aj5T7D0k2rC3xUsyuNI/UTuGgAw7QqGe0hVLymAwamPHIU/vvPymZAtCfB bew9X3culUh2hpQEuntERxJ38/4D03RBRmQqCRHimSfqinA06ph5U0q6I75UPJbLP+KOEW4KiAh
 4YFdJ60R1hI+X8rj9E1tIXqphwg4oEk4x9sy5zuzoIWw1yDQ16MbaiVwMShniZ1R077QjXySi9G KBiijOcrgV+RcHL7f0nS4xmp17dXa9Y7hV+XP/HGboPtvDpePX4ddw4mfk63onbWD5+dAkkRw12 aOSfAgczPHM0JbMhBXYb2vFKMx0YVvdG8kwSAamxxPcYkJObuD86C0DvtEQRiOz0AHwANNcsjlB
 nbO3Fl7apdL/EkBlWv6MIs/V3SQ6FWTzIwfsCJLcNHCQ4X6NlTxCXqaj7yXBtlaBMDatbvyG
X-Proofpoint-ORIG-GUID: C8RkTzqwsGgtzoEsXA0Cjc7qKGlBlQki
X-Authority-Analysis: v=2.4 cv=d5f1yQjE c=1 sm=1 tr=0 ts=68245550 cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=yu5_2oTmPGPoRl_nzRAA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: C8RkTzqwsGgtzoEsXA0Cjc7qKGlBlQki
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_02,2025-05-14_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 spamscore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 mlxlogscore=999 impostorscore=0 adultscore=0 phishscore=0
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505140070

On 09/05/2025 12:24, Harald Freudenberger wrote:
> This is a complete rework of the protected key AES (PAES) implementation.
> The goal of this rework is to implement the 4 modes (ecb, cbc, ctr, xts)
> in a real asynchronous fashion:
> - init(), exit() and setkey() are synchronous and don't allocate any memory.

Please wrap this line (checkpatch complains, it's too long).

> - the encrypt/decrypt functions first try to do the job in a synchronous
>   manner. If this fails, for example the protected key got invalid caused
>   by a guest suspend/resume or guest migration action, the encrypt/decrypt
>   is transferred to an instance of the crypto engine (see below) for
>   asynchronous processing.
>   These postponed requests are then handled by the crypto engine by
>   invoking the do_one_request() callback but may of course again run into
>   a still not converted key or the key is getting invalid. If the key is
>   still not converted, the first thread does the conversion and updates
>   the key status in the transformation context. The conversion is
>   invoked via pkey API with a new flag PKEY_XFLAG_NOMEMALLOC.
>   Note that once there is an active requests enqueued to get async
>   processed via crypto engine, further requests also need to go via
>   crypto engine to keep the request sequence.
> 
> This patch together with the pkey/zcrypt/AP extensions to support
> the new PKEY_XFLAG_NOMEMMALOC should toughen the paes crypto algorithms
> to truly meet the requirements for in-kernel skcipher implementations
> and the usage patterns for the dm-crypt and dm-integrity layers.
> 
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>

With the line wrap and the typos fixed
Reviewed-by: Holger Dengler <dengler@linux.ibm.com>

> ---
>  arch/s390/crypto/paes_s390.c | 1812 ++++++++++++++++++++++++----------
>  1 file changed, 1270 insertions(+), 542 deletions(-)
> 
> diff --git a/arch/s390/crypto/paes_s390.c b/arch/s390/crypto/paes_s390.c
> index 1f62a9460405..596698ce7084 100644
> --- a/arch/s390/crypto/paes_s390.c
> +++ b/arch/s390/crypto/paes_s390.c
[...]
> @@ -89,214 +129,367 @@ static inline u32 make_clrkey_token(const u8 *ck, size_t cklen, u8 *dest)
>  	return sizeof(*token) + cklen;
>  }
>  
> -static inline int _key_to_kb(struct key_blob *kb,
> -			     const u8 *key,
> -			     unsigned int keylen)
> +/*
> + * paes_ctx_setkey() - Set key value into context, maybe construct
> + * a clear key token digestable by pkey from a clear key value.

typo: digestible

> + */
> +static inline int paes_ctx_setkey(struct s390_paes_ctx *ctx,
> +				  const u8 *key, unsigned int keylen)
[...]
> +/*
> + * pxts_ctx_setkey() - Set key value into context, maybe construct
> + * a clear key token digestable by pkey from a clear key value.

typo: digestible

> + */
> +static inline int pxts_ctx_setkey(struct s390_pxts_ctx *ctx,
> +				  const u8 *key, unsigned int keylen)
[...]
>  {
>  	size_t cklen = keylen / 2;
>  

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler
--
IBM Systems, Linux on IBM Z Development
dengler@linux.ibm.com

