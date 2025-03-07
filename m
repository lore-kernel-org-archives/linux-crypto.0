Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06454186607;
	Fri,  7 Mar 2025 08:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741335977; cv=none; b=ualDib1Rvrrtdkif6gHd+dpdA9+Ufi44HcBsSNYGhEVS/tUsHbmaJJKNatJmVNod/KDp/wMZYTSChUXb1to+A9/697dnvJ38knjPOybqTK0k3RW8NeM1EQEPEpKuEzshXgWTP2/5uCg5+uwd+phv4UdulWRS6fvuplDdEPYApkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741335977; c=relaxed/simple;
	bh=NrFOjwGV52c/KilboCmh6A1iP3Un/LErRA/ElUUHfw0=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=SLcfOBXgJeKWuRdH6Q7kKWHJUfCMHWtcSYS4FzIFna5N98C4IhLxMR4qBCgW/oisxzbXdqKCBBTXyWDFe9QjTBvss98ttIEBtBsP58ki0f6bggQYhVef219ftYL6ZgQArvGnOCa2vGrByPZ2PMQNcaNKckLTETiF/AftmLh8GrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=X1UjU6xW; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="X1UjU6xW"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 526Kpewj011768;
	Fri, 7 Mar 2025 08:26:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=veTnTDmhgqZ/HZMqUPh9encFc5sxPFHXd1bL2+Fp+lE=; b=X1UjU6xWHLSe
	NaHriyvm6/4Qqptnj75S+Q/3/jLtUS0vN8fm9dHhVdzJthT1kVby7kVsZmkA6N6u
	6Wa1OaQTIV9Z9XEh7fMJyqK0N9LOtviO1S9afszQYK3zBlu3u7WNXQEiJxeDmLVD
	B4A7Vfqo8dXoIGt9L96Lqos3lPi28NBmqJuru03xNQpJm1GeO9L8H3+QsP1Ap+5e
	+Wahjho1pcSdw+n+hW7fOuWt/on2Z93weVnSnOZmoFJawsQTo6fPpzr684BKQxj9
	L2DXPETne40CaIkCfLqGGiKkw8IntU0JO+722hBY9u8Dnp4akSusOqmcoHuuufEI
	9sd70MlsIg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 457k45ak10-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 07 Mar 2025 08:26:12 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5278Ps5D008958;
	Fri, 7 Mar 2025 08:26:11 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 454cxywt6b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 07 Mar 2025 08:26:11 +0000
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5278QAev30212718
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 7 Mar 2025 08:26:10 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6776F58063;
	Fri,  7 Mar 2025 08:26:10 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EFB6F5804B;
	Fri,  7 Mar 2025 08:26:09 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  7 Mar 2025 08:26:09 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 07 Mar 2025 09:26:09 +0100
From: Harald Freudenberger <freude@linux.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: dengler@linux.ibm.com, ifranzki@linux.ibm.com, fcallies@linux.ibm.com,
        linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 1/1] s390/crypto: Rework protected key AES for true
 asynch support
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <Z8phn5Ddk5ZBvyzY@gondor.apana.org.au>
References: <20250306171201.17961-1-freude@linux.ibm.com>
 <20250306171201.17961-2-freude@linux.ibm.com>
 <Z8phn5Ddk5ZBvyzY@gondor.apana.org.au>
Message-ID: <fc80968c53f9fa824bd9d064f16086b5@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: iZKTp4wLbcCsSCbv4TR4W0NRIo9W-K20
X-Proofpoint-GUID: iZKTp4wLbcCsSCbv4TR4W0NRIo9W-K20
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-07_03,2025-03-06_04,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 suspectscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2503070057

On 2025-03-07 04:01, Herbert Xu wrote:
> On Thu, Mar 06, 2025 at 06:12:01PM +0100, Harald Freudenberger wrote:
>> 
>> +	/* fetch and check protected key state */
>>  	spin_lock_bh(&ctx->pk_lock);
>> +	pk_state = ctx->pk_state;
>>  	memcpy(param.key, ctx->pk.protkey, PAES_256_PROTKEY_SIZE);
>>  	spin_unlock_bh(&ctx->pk_lock);
>> +	switch (pk_state) {
>> +	case PK_STATE_NO_KEY:
>> +		rc = -ENOKEY;
>> +		goto out;
>> +	case PK_STATE_CONVERT_IN_PROGRESS:
>> +		rc = -EKEYEXPIRED;
>> +		goto out;
> 
> Shouldn't this go async rather than failing?
> 

The calling function is on this return code triggering the request 
asynch.

>> +	case PK_STATE_VALID:
>> +		break;
>> +	default:
>> +		rc = pk_state < 0 ? pk_state : -EIO;
>> +		goto out;
>> +	}
>> +
>> +	/* setkey() should have updated the function code */
>> +	if (!ctx->fc) {
> 
> The locking is wrong for this field.  It gets written to without
> any locks in cbc_paes_wq_setkey_fn, and here you're reading it
> without any locking.
> 

Well, yes. I should really cover all the fields from the context
with the spinlock - will do with v2.

> In fact the whole switch statement smells fishy.  One tfm could
> be used by any number of encryption requests in parallel.  So
> your pk_state could change from right under your nose as soon as
> you let go of the pk_lock.
> 
> Please describe the high-level picture of how pk_lock and its
> protected fields are meant to work in the face of requests being
> issued in parallel on one tfm.
> 

We had this discussion already. I am aware of the fact, that this
tfm context is used by multiple requests concurrently. However, I'll
describe why these updates in the tfm context are needed and are
conform to concurrent use of the ctx.

>> -static int cbc_paes_set_key(struct crypto_skcipher *tfm, const u8 
>> *in_key,
>> -			    unsigned int key_len)
>> +static int cbc_paes_setkey(struct crypto_skcipher *tfm, const u8 
>> *in_key,
>> +			   unsigned int key_len)
>>  {
>>  	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
>>  	int rc;
>> 
>> -	_free_kb_keybuf(&ctx->kb);
>> -	rc = _key_to_kb(&ctx->kb, in_key, key_len);
>> +	rc = key_to_ctx(ctx, in_key, key_len);
>>  	if (rc)
>>  		return rc;
>> 
>> -	return __cbc_paes_set_key(ctx);
>> +	/* Always trigger an asynch key convert */
>> +	spin_lock_bh(&ctx->pk_lock);
>> +	ctx->pk_state = PK_STATE_CONVERT_IN_PROGRESS;
>> +	spin_unlock_bh(&ctx->pk_lock);
>> +	queue_work(paes_wq, &ctx->work);
> 
> Why does this need to be async? The setkey function is the one
> part of the API that is competely synchronous.  It is not allowed
> to occur while any encryption is still incomplete.
> 
> By making it asynchronous, you risk creating new issues.  For example,
> what is supposed to happen when a second setkey occurs while the first
> setkey's scheduled work is yet to complete?

Ok, will change this for version 2

> 
> Cheers,

Thanks for you feedback. Have a nice day.
