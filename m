Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E0415CD74;
	Wed,  8 Jan 2025 15:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736348793; cv=none; b=TmhhF2qFdiX40zTHCU2BzbUY1fivNyjNfK45TZ2PIC7R/7dmZWacQ1jFrWidCqs1o2CExXJLN/B5mLGO3AmSb7h4qywAMN6dAOTt9WEG4VOa9+ZbrfR9gZmA7X7IqQQCIx/0QHSEAJGPeFW2LzFx0IOVfmThXLqqiOAYAMUXWzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736348793; c=relaxed/simple;
	bh=GtKrfmly8HIpzFeTR9Cb3QfKE0/JX9V1zAGx74FqQJk=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=EozTy5nRmuae0VvU8I3hK3hBZGhoepCdXnDCns4K/Ym7+x7Qc8A7zrTHK0TTyY2CaPb/hEFiPRcw/ADoewRgEKq0hxmVBnHXElps8KnN32erZR4HXBKhOxlqc6KSHMNLuQAmUfOri8p7Ae1DA94YitLg+zlqmX2ZzIS3jSuOb+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fPW+UUnI; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fPW+UUnI"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 508D6Ht3026793;
	Wed, 8 Jan 2025 15:06:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=AailQYGz8niMcO0+l3sgqJtd9jI7kG6enCwLr0ojggA=; b=fPW+UUnILC9E
	iVzO0tviLHwew+3F+EyZ+XGLZjRqruaE6loVcg+19MQFRu37++mqKI2LmuqdmCxq
	fxL/4W9S8V4QgiCoY0WTi01O3zRSnNvdDgzEIi3mhyeuTw5OFQPjNTHsJ7xryTrr
	T9UxKfjjOM/3jMxlMqqdjqaaBUe9eVsK+ysGC77ZuE7Dw9l0771gFyW2qdDRrR0n
	jEfa4kGNoy63311JMKscyrlwShu+b3oihRSSB8++i9Wkn/I9CdXDdVGdB7YZxo5T
	D6YXxW99mkPsW5Tx4/m/g3d1jDobBimVPJSRheMo1+0EcAtYmrPh0Kt/KgzgB57g
	cLf0rAbpjw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 441e3b3hyy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 15:06:22 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 508E3iGr028054;
	Wed, 8 Jan 2025 15:06:21 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 43yhhk820n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 15:06:21 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 508F6LUk17301854
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Jan 2025 15:06:21 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E1AF15805C;
	Wed,  8 Jan 2025 15:06:20 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 619A158054;
	Wed,  8 Jan 2025 15:06:20 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Jan 2025 15:06:20 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 08 Jan 2025 16:06:20 +0100
From: Harald Freudenberger <freude@linux.ibm.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Holger Dengler <dengler@linux.ibm.com>,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v2 21/29] crypto: s390/aes-gcm - use the new scatterwalk
 functions
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <20241230001418.74739-22-ebiggers@kernel.org>
References: <20241230001418.74739-1-ebiggers@kernel.org>
 <20241230001418.74739-22-ebiggers@kernel.org>
Message-ID: <cdcf7da3766aa6f6336f590bd64c12cf@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: AUii3IdAVIGaSKXZb90h53cdOhQMPtMU
X-Proofpoint-GUID: AUii3IdAVIGaSKXZb90h53cdOhQMPtMU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 phishscore=0 impostorscore=0 clxscore=1011 bulkscore=0
 lowpriorityscore=0 mlxlogscore=558 adultscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501080125

On 2024-12-30 01:14, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Use scatterwalk_next() which consolidates scatterwalk_clamp() and
> scatterwalk_map().  Use scatterwalk_done_src() and
> scatterwalk_done_dst() which consolidate scatterwalk_unmap(),
> scatterwalk_advance(), and scatterwalk_done().
> 
> Besides the new functions being a bit easier to use, this is necessary
> because scatterwalk_done() is planned to be removed.
> 
> Cc: Harald Freudenberger <freude@linux.ibm.com>
> Cc: Holger Dengler <dengler@linux.ibm.com>
> Cc: linux-s390@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> 
> This patch is part of a long series touching many files, so I have
> limited the Cc list on the full series.  If you want the full series 
> and
> did not receive it, please retrieve it from lore.kernel.org.
> 
>  arch/s390/crypto/aes_s390.c | 33 +++++++++++++--------------------
>  1 file changed, 13 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
> index 9c46b1b630b1..7fd303df05ab 100644
> --- a/arch/s390/crypto/aes_s390.c
> +++ b/arch/s390/crypto/aes_s390.c
> @@ -785,32 +785,25 @@ static void gcm_walk_start(struct gcm_sg_walk
> *gw, struct scatterlist *sg,
>  	scatterwalk_start(&gw->walk, sg);
>  }
> 
>  static inline unsigned int _gcm_sg_clamp_and_map(struct gcm_sg_walk 
> *gw)
>  {
> -	struct scatterlist *nextsg;
> -
> -	gw->walk_bytes = scatterwalk_clamp(&gw->walk, gw->walk_bytes_remain);
> -	while (!gw->walk_bytes) {
> -		nextsg = sg_next(gw->walk.sg);
> -		if (!nextsg)
> -			return 0;
> -		scatterwalk_start(&gw->walk, nextsg);
> -		gw->walk_bytes = scatterwalk_clamp(&gw->walk,
> -						   gw->walk_bytes_remain);
> -	}
> -	gw->walk_ptr = scatterwalk_map(&gw->walk);
> +	if (gw->walk_bytes_remain == 0)
> +		return 0;
> +	gw->walk_ptr = scatterwalk_next(&gw->walk, gw->walk_bytes_remain,
> +					&gw->walk_bytes);
>  	return gw->walk_bytes;
>  }
> 
>  static inline void _gcm_sg_unmap_and_advance(struct gcm_sg_walk *gw,
> -					     unsigned int nbytes)
> +					     unsigned int nbytes, bool out)
>  {
>  	gw->walk_bytes_remain -= nbytes;
> -	scatterwalk_unmap(gw->walk_ptr);
> -	scatterwalk_advance(&gw->walk, nbytes);
> -	scatterwalk_done(&gw->walk, 0, gw->walk_bytes_remain);
> +	if (out)
> +		scatterwalk_done_dst(&gw->walk, gw->walk_ptr, nbytes);
> +	else
> +		scatterwalk_done_src(&gw->walk, gw->walk_ptr, nbytes);
>  	gw->walk_ptr = NULL;
>  }
> 
>  static int gcm_in_walk_go(struct gcm_sg_walk *gw, unsigned int 
> minbytesneeded)
>  {
> @@ -842,11 +835,11 @@ static int gcm_in_walk_go(struct gcm_sg_walk
> *gw, unsigned int minbytesneeded)
> 
>  	while (1) {
>  		n = min(gw->walk_bytes, AES_BLOCK_SIZE - gw->buf_bytes);
>  		memcpy(gw->buf + gw->buf_bytes, gw->walk_ptr, n);
>  		gw->buf_bytes += n;
> -		_gcm_sg_unmap_and_advance(gw, n);
> +		_gcm_sg_unmap_and_advance(gw, n, false);
>  		if (gw->buf_bytes >= minbytesneeded) {
>  			gw->ptr = gw->buf;
>  			gw->nbytes = gw->buf_bytes;
>  			goto out;
>  		}
> @@ -902,11 +895,11 @@ static int gcm_in_walk_done(struct gcm_sg_walk
> *gw, unsigned int bytesdone)
>  			memmove(gw->buf, gw->buf + bytesdone, n);
>  			gw->buf_bytes = n;
>  		} else
>  			gw->buf_bytes = 0;
>  	} else
> -		_gcm_sg_unmap_and_advance(gw, bytesdone);
> +		_gcm_sg_unmap_and_advance(gw, bytesdone, false);
> 
>  	return bytesdone;
>  }
> 
>  static int gcm_out_walk_done(struct gcm_sg_walk *gw, unsigned int 
> bytesdone)
> @@ -920,14 +913,14 @@ static int gcm_out_walk_done(struct gcm_sg_walk
> *gw, unsigned int bytesdone)
>  		for (i = 0; i < bytesdone; i += n) {
>  			if (!_gcm_sg_clamp_and_map(gw))
>  				return i;
>  			n = min(gw->walk_bytes, bytesdone - i);
>  			memcpy(gw->walk_ptr, gw->buf + i, n);
> -			_gcm_sg_unmap_and_advance(gw, n);
> +			_gcm_sg_unmap_and_advance(gw, n, true);
>  		}
>  	} else
> -		_gcm_sg_unmap_and_advance(gw, bytesdone);
> +		_gcm_sg_unmap_and_advance(gw, bytesdone, true);
> 
>  	return bytesdone;
>  }
> 
>  static int gcm_aes_crypt(struct aead_request *req, unsigned int flags)

Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
Tested-by:  Harald Freudenberger <freude@linux.ibm.com>
