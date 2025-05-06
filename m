Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85672820BD;
	Tue,  6 May 2025 14:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746540802; cv=none; b=mpJ097gR1ilT/wiIa9ic/dYedZK2aLc2hBEkhBG0JgZyT1EIaA/EP+2Ujev4C5njT1AX1YGoy/VEQHjJ+LQugfzIQiSCRsJSWeteuqyW038J8GVysmhQUiDKQeCHN0jhGXJktjelQDHiQ1+7BYaWFXKG1bxenTgZg6zRTRR3pGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746540802; c=relaxed/simple;
	bh=BNk/+mWCQUCAfY3XNaX14z5c8YNk+0RbsHHDSRqP4qs=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=Dna9uMre+gMQJt9dv0G4KamDHkWqpBOc8/6fYjMlZSnSRBYSMcpQM5GvgzNNGPb6khRiFHUYERonuDXfnsdrQ761Bquehm5UxgDCrNyL71t6IJZ3p4gzyBLT6+yYUjE+1NoblN4Bq7+pJG7dTn42lXz1jkxSZOIVGeU/xe5HWPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Q8fqHnIg; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Q8fqHnIg"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 546A46Cs010427;
	Tue, 6 May 2025 14:13:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=UgTAnE2VFRuoenrV0plh+mnfqoSwgfZV0MAOgoAmgSk=; b=Q8fqHnIgyAap
	yPQ2It1IuxYrFrB8zDaK+8HSLDk7/+aFdJjCPCEspUn9v/lDHQKBZpHGhSCUY6dM
	u4cADbbhKyJD+UqSIk5MGuElVKPK865Pi0VhXivk5DngGMigN99bub74er8NYqc7
	p3Fo3GaTNe9c1Ze1C1sNZt6ZRVi04csraC4o55c0lksj0GGl5KKUFYaGYWdtaeSS
	CE6woB0L6yIt3D1mYAjVv9hlkeb6VXvmGDwgReI/6KSGc/CIKjl8S5ion8jWpMG3
	hRJqC8/IiHYGi4gC74CCZyyCZkcsupxGqgA+3jp3oQsgXIQ91iLDs7KjEcJKs4xG
	KAuRt7YCXw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46fgbj973d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 May 2025 14:13:17 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 546Ct7rB002729;
	Tue, 6 May 2025 14:13:16 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46dxfnutb8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 May 2025 14:13:16 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 546EDFTa21824022
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 6 May 2025 14:13:15 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1BC0E5805F;
	Tue,  6 May 2025 14:13:15 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B4AC658051;
	Tue,  6 May 2025 14:13:14 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  6 May 2025 14:13:14 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 06 May 2025 16:13:14 +0200
From: Harald Freudenberger <freude@linux.ibm.com>
To: Holger Dengler <dengler@linux.ibm.com>
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        herbert@gondor.apana.org.au, fcallies@linux.ibm.com,
        ifranzki@linux.ibm.com
Subject: Re: [PATCH v3 2/3] s390/crypto: Rework protected key AES for true
 asynch support
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <9ddc9bc9-ad88-4ba5-aebf-2fcdd01db064@linux.ibm.com>
References: <20250401145048.52564-1-freude@linux.ibm.com>
 <20250401145048.52564-3-freude@linux.ibm.com>
 <9ddc9bc9-ad88-4ba5-aebf-2fcdd01db064@linux.ibm.com>
Message-ID: <6d91b8776191126385925d5af5f165bc@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -htPgYXSeY6YxL6vspu-q7FPdNbKoJWr
X-Proofpoint-GUID: -htPgYXSeY6YxL6vspu-q7FPdNbKoJWr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA2MDEzNiBTYWx0ZWRfX1fEnqOq1QYmF ex04Idpg6/xjLD/TJrMdDP6U7ad7xnWvtAm4XrBW/eX2QrNTxL4KnUkFNb4+ol6chX+3ieoSSDP MkJRxOg+PswKsXYGmALtDKBfnDOtbhXEQBaegjkyCZB5dX+nhh+6fB5/CbI7JneizbgchPKNAgY
 mejmoQYdH0J4ROBsinLRIiBgT1BK3kSvadD7/ri5rTlRy7gtWtj1NllvIu3RkztflbtuJFMHtuM P1A5okiHAtqC3ipdSSvo1K1ckG1c9IIy0eG4Yt2posB2y83f9u+t9dnkzEwy849xSV52Jr1X8ha Yz7TzlECggubEyhGMbGGMryLOd3bapzsl27b3hUzIlGiVvoDQUNTJRQP28nxcvEF2jmSwhEtgxM
 DDWCLIvoJkzpJ0vqt3lc9af7oQ8+gAsQRYt1pMBWzXVWbT4UQzn7xx8sg6GUxTOEVr4cDN93
X-Authority-Analysis: v=2.4 cv=FJcbx/os c=1 sm=1 tr=0 ts=681a18fd cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=Yl2rw_hg2ZBHYNZ8udoA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-06_06,2025-05-05_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 phishscore=0 impostorscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0 adultscore=0
 spamscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2505060136

On 2025-04-25 16:56, Holger Dengler wrote:
> On 01/04/2025 16:50, Harald Freudenberger wrote:
>> This is a complete rework of the protected key AES (PAES) 
>> implementation.
>> The goal of this rework is to implement the 4 modes (ecb, cbc, ctr, 
>> xts)
>> in a real asynchronous fashion:
>> - init(), exit() and setkey() are synchronous and don't allocate any 
>> memory.
>> - the encrypt/decrypt functions first try to do the job in a 
>> synchronous
>>   manner. If this fails, for example the protected key got invalid 
>> caused
>>   by for example a guest suspend/resume or guest migration action, the
> 
> reword: please drop one of the "for example".
> 

done

>>   encrypt/decrypt is transfered to an instance of the crypto engine 
>> (see
> 
> typo: transferred
> 

done

>>   below) for asynchronous processing.
>>   These via crypto engine postponed requests are then handled via the
>>   do_one_request() callback but may of course again run into a still
> 
> reword: please drop at least one "via". Proposal (if I got it
> correctly): "These postponed requests are then handled by the crypto
> engine by calling the do_one_request() callback ..."
> 

done

>>   not converted key or the key is getting invalid. If the key is
>>   still not converted, the first thread does the conversion and 
>> updates
>>   the key status in the transformation context. The conversion is
>>   invoked via pkey API with a new flag PKEY_XFLAG_NOMEMALLOC.
>> 
>> The pkey API used here - the function pkey_key2protkey() - uses
>> a new version of this in-kernel-API. A new flag PKEY_XFLAG_NOMEMALLOC
>> tells the PKEY layer (and subsidiary layers) that it must not allocate
>> any memory causing IO operations. Note that the patches for this
>> pkey/zcrypt/AP extensions are currently under review and yet not
>> upstream available. SO THIS PATCH DOES NOT COMPILE YET.
> 
> As the ap-rework series is now on its way, you can remove parts of
> this paragraph.
> 

done

>> This patch together with the pkey/zcrypt/AP extensions should
>> toughen the paes crypto algorithms to truly meet the requirements
>> for in-kernel skcipher implementations and the usage patterns for
>> the dm-crypt and dm-integrity layers.
>> 
>> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
> 
> It is very hard to review this patch. If there is any chance to split
> this up into smaller pieces, please do it.
> This is the first part of the review, covering mainly common parts and
> ecb. The other modes will follow later.
> See my comments below.
> 

Sorry but I don't see how I could split this rework into digestible 
units.

>> ---
>>  arch/s390/crypto/paes_s390.c | 1725 
>> +++++++++++++++++++++++-----------
>>  1 file changed, 1183 insertions(+), 542 deletions(-)
>> 
>> diff --git a/arch/s390/crypto/paes_s390.c 
>> b/arch/s390/crypto/paes_s390.c
>> index 646cbbf0678d..1d1f1a98ec4d 100644
>> --- a/arch/s390/crypto/paes_s390.c
>> +++ b/arch/s390/crypto/paes_s390.c
...
>> +#define PK_STATE_NO_KEY		     0
>> +#define PK_STATE_CONVERT_IN_PROGRESS 1
>> +#define PK_STATE_VALID		     2
> 
> Please use an enum here.
> 

I'd like to keep the one variable pk_state with either a negative errno
value if the key conversion failed, or a >= value with one of the listed
states.

>> +
>> +struct s390_paes_ctx {
>> +	/* source key material used to derive a protected key from */
>> +	u8 keybuf[PAES_MAX_KEYSIZE];
>> +	unsigned int keylen;
>> +
>> +	/* cpacf function code to use with this protected key type */
>> +	long fc;
>> +
>> +	/* spinlock to atomic read/update all the following fields */
>> +	spinlock_t pk_lock;
>> +
>> +	/* see PK_STATE* defines above, < 0 holds convert failure rc  */
>> +	int pk_state;
> 
> I see no advantage to split the value range. On the contrary, it makes
> the status handling more complex.
> I would prefer to use an enum for pk_state and use another element for
> the conversion rc.
> 
>> +	/* if state is valid, pk holds the protected key */
>> +	struct paes_protkey pk;
>> +};
>> +
>> +struct s390_pxts_ctx {
>> +	/* source key material used to derive a protected key from */
>> +	u8 keybuf[2 * PAES_MAX_KEYSIZE];
>>  	unsigned int keylen;
>> +
>> +	/* cpacf function code to use with this protected key type */
>> +	long fc;
>> +
>> +	/* spinlock to atomic read/update all the following fields */
>> +	spinlock_t pk_lock;
>> +
>> +	/* see PK_STATE* defines above, < 0 holds convert failure rc  */
>> +	int pk_state;
> 
> Same here.
> 
>> +	/* if state is valid, pk[] hold(s) the protected key(s) */
>> +	struct paes_protkey pk[2];
>>  };
>> 
>>  /*
>> @@ -89,214 +122,344 @@ static inline u32 make_clrkey_token(const u8 
>> *ck, size_t cklen, u8 *dest)
>>  	return sizeof(*token) + cklen;
>>  }
>> 
>> -static inline int _key_to_kb(struct key_blob *kb,
>> -			     const u8 *key,
>> -			     unsigned int keylen)
>> +/*
>> + * key_to_ctx() - Set key value into context, maybe construct
>> + * a clear key token digestable by pkey from a clear key value.
>> + */
>> +static inline int key_to_ctx(struct s390_paes_ctx *ctx,
>> +			     const u8 *key, unsigned int keylen)
> 
> The function name implies a transformation of a key into a context,
> not just a set of a context element. What about paes_ctx_setkey()?
> 

done, this is now paes_ctx_setkey()

>>  {
>> +	if (keylen > sizeof(ctx->keybuf))
>> +		return -EINVAL;
>> +
>>  	switch (keylen) {
>>  	case 16:
>>  	case 24:
>>  	case 32:
>>  		/* clear key value, prepare pkey clear key token in keybuf */
>> -		memset(kb->keybuf, 0, sizeof(kb->keybuf));
>> -		kb->keylen = make_clrkey_token(key, keylen, kb->keybuf);
>> -		kb->key = kb->keybuf;
>> +		memset(ctx->keybuf, 0, sizeof(ctx->keybuf));
>> +		ctx->keylen = make_clrkey_token(key, keylen, ctx->keybuf);
>>  		break;
>>  	default:
>>  		/* other key material, let pkey handle this */
>> -		if (keylen <= sizeof(kb->keybuf))
>> -			kb->key = kb->keybuf;
>> -		else {
>> -			kb->key = kmalloc(keylen, GFP_KERNEL);
>> -			if (!kb->key)
>> -				return -ENOMEM;
>> -		}
>> -		memcpy(kb->key, key, keylen);
>> -		kb->keylen = keylen;
>> +		memcpy(ctx->keybuf, key, keylen);
>> +		ctx->keylen = keylen;
>>  		break;
>>  	}
>> 
>>  	return 0;
>>  }
>> 
>> -static inline int _xts_key_to_kb(struct key_blob *kb,
>> -				 const u8 *key,
>> -				 unsigned int keylen)
>> +/*
>> + * xts_key_to_ctx() - Set key value into context, maybe construct
>> + * a clear key token digestable by pkey from a clear key value.
>> + */
>> +static inline int xts_key_to_ctx(struct s390_pxts_ctx *ctx,
>> +				 const u8 *key, unsigned int keylen)
> 
> Same here, the function name implies a transformation of a key into a
> context, not just a set of a context element. What about
> pxts_ctx_setkey()?

done

> 
>>  {
>>  	size_t cklen = keylen / 2;
>> 
> [...]
>> +static int ecb_paes_do_crypt(struct s390_paes_ctx *ctx,
>> +			     struct s390_pecb_req_ctx *req_ctx,
>> +			     bool maysleep)
>>  {
>> -	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
>> -	int rc;
>> +	struct ecb_param *param = &req_ctx->param;
>> +	struct skcipher_walk *walk = &req_ctx->walk;
>> +	unsigned int nbytes, n, k;
>> +	int pk_state, rc;
>> +
>> +	if (!req_ctx->param_init_done) {
>> +		/* fetch and check protected key state */
>> +		spin_lock_bh(&ctx->pk_lock);
>> +		pk_state = ctx->pk_state;
>> +		memcpy(param->key, ctx->pk.protkey, PAES_256_PROTKEY_SIZE);
> 
> I would prefer to use the size of param->key instead of a constant
> value as length.
> 

I checked all these occurrences and rewrote where possible to use 
sizeof().

>> +		spin_unlock_bh(&ctx->pk_lock);
>> +		switch (pk_state) {
>> +		case PK_STATE_NO_KEY:
>> +			rc = -ENOKEY;
>> +			goto out;
>> +		case PK_STATE_CONVERT_IN_PROGRESS:
>> +			rc = -EKEYEXPIRED;
>> +			goto out;
>> +		case PK_STATE_VALID:
>> +			req_ctx->param_init_done = true;
>> +			break;
>> +		default:
>> +			rc = pk_state < 0 ? pk_state : -EIO;
>> +			goto out;
>> +		}
>> +	}
>> 
>> -	_free_kb_keybuf(&ctx->kb);
>> -	rc = _key_to_kb(&ctx->kb, in_key, key_len);
>> -	if (rc)
>> -		return rc;
>> +	rc = 0;
> 
> Modify the param block in req_ctx only if the protected key is valid.
> 
> int rc = 0;
> 
> if (!req_ctx->param_init_done) {
> 	/* fetch and check protected key state */
> 	spin_lock_bh(&ctx->pk_lock);
> 	switch (ctx->pk_state) {
> 	case PK_STATE_NO_KEY:
> 		rc = -ENOKEY;
> 		break;
> 	case PK_STATE_CONVERT_IN_PROGRESS:
> 		rc = -EKEYEXPIRED;
> 		break;
> 	case PK_STATE_VALID:
> 		memcpy(param->key, ctx->pk.protkey, sizeof(param->key));
> 		req_ctx->param_init_done = true;
> 		break;
> 	default:
> 		rc = pk_state < 0 ? pk_state : -EIO;
> 		break;
> 	}
> 	spin_unlock_bh(&ctx->pk_lock);
> 	if (rc)
> 		goto out;
> }
> 

done (for all 4 algs)

>> +
>> +	/* always walk on the ... */
> 
> What does this comment mean? I'm afraid, I don't get it.
> 

removed, but added a comment about the walk instead as suggested by 
Herbert Xu

>> +	while ((nbytes = walk->nbytes) != 0) {
>> +		/* only use complete blocks */
>> +		n = nbytes & ~(AES_BLOCK_SIZE - 1);
>> +		k = cpacf_km(ctx->fc | req_ctx->modifier, param,
>> +			     walk->dst.virt.addr, walk->src.virt.addr, n);
>> +		if (k)
>> +			rc = skcipher_walk_done(walk, nbytes - k);
>> +		if (k < n) {
>> +			if (!maysleep) {
>> +				rc = -EKEYEXPIRED;
>> +				goto out;
>> +			}
>> +			rc = paes_convert_key(ctx);
>> +			if (rc)
>> +				goto out;
>> +			spin_lock_bh(&ctx->pk_lock);
>> +			memcpy(param->key, ctx->pk.protkey, PAES_256_PROTKEY_SIZE);
>> +			spin_unlock_bh(&ctx->pk_lock);
>> +		}
>> +	}
>> 
>> -	return __ecb_paes_set_key(ctx);
>> +out:
>> +	pr_debug("rc=%d\n", rc);
>> +	return rc;
>>  }
>> 
>>  static int ecb_paes_crypt(struct skcipher_request *req, unsigned long 
>> modifier)
>>  {
>> +	struct s390_pecb_req_ctx *req_ctx = skcipher_request_ctx(req);
>>  	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
>>  	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
>> -	struct {
>> -		u8 key[PAES_256_PROTKEY_SIZE];
>> -	} param;
>> -	struct skcipher_walk walk;
>> -	unsigned int nbytes, n, k;
>> +	struct skcipher_walk *walk = &req_ctx->walk;
>>  	int rc;
>> 
>> -	rc = skcipher_walk_virt(&walk, req, false);
>> +	/*
>> +	 * First try synchronous. If this fails for any reason
>> +	 * schedule this request asynchronous via crypto engine.
>> +	 */
>> +
>> +	rc = skcipher_walk_virt(walk, req, false);
>>  	if (rc)
>> -		return rc;
>> +		goto out;
>> 
>> -	spin_lock_bh(&ctx->pk_lock);
>> -	memcpy(param.key, ctx->pk.protkey, PAES_256_PROTKEY_SIZE);
>> -	spin_unlock_bh(&ctx->pk_lock);
>> +	req_ctx->modifier = modifier;
>> +	req_ctx->param_init_done = false;
>> 
>> -	while ((nbytes = walk.nbytes) != 0) {
>> -		/* only use complete blocks */
>> -		n = nbytes & ~(AES_BLOCK_SIZE - 1);
>> -		k = cpacf_km(ctx->fc | modifier, &param,
>> -			     walk.dst.virt.addr, walk.src.virt.addr, n);
>> -		if (k)
>> -			rc = skcipher_walk_done(&walk, nbytes - k);
>> -		if (k < n) {
>> -			if (__paes_convert_key(ctx))
>> -				return skcipher_walk_done(&walk, -EIO);
>> -			spin_lock_bh(&ctx->pk_lock);
>> -			memcpy(param.key, ctx->pk.protkey, PAES_256_PROTKEY_SIZE);
>> -			spin_unlock_bh(&ctx->pk_lock);
>> -		}
>> +	rc = ecb_paes_do_crypt(ctx, req_ctx, false);
>> +	if (rc != -EKEYEXPIRED) {
>> +		if (rc)
>> +			skcipher_walk_done(walk, rc);
>> +		goto out;
>>  	}
>> +
>> +	rc = crypto_transfer_skcipher_request_to_engine(paes_crypto_engine, 
>> req);
>> +	if (rc)
>> +		goto out;
>> +
>> +	rc = -EINPROGRESS;
>> +
>> +out:
>> +	if (rc != -EINPROGRESS)
>> +		memzero_explicit(&req_ctx->param, sizeof(req_ctx->param));
>> +	pr_debug("rc=%d\n", rc);
>>  	return rc;
> 
> If took me a while to find the synchronous good case code path. I
> would prefer to handle the various cases separately, either with a
> switch/case or by explicit checks in the main path.
> 
> rc = ecb_paes_do_crypt(ctx, req_ctx, false);
> if (rc == -EKEYEXPIRED) {
> 	rc = crypto_transfer_skcipher_request_to_engine(paes_crypto_engine, 
> req);
> 	rc = rc ?: -EINPROGRESS;
> } else if (rc) {
> 	skcipher_walk_done(walk, rc);
> }
> 
> if (rc != -EINPROGRESS)
> 	memzero_explicit(&req_ctx->param, sizeof(req_ctx->param));
> pr_debug("rc=%d\n", rc);
> return rc;
> 

reworked this and 7 other places.

>>  }
>> 
>> @@ -310,112 +473,242 @@ static int ecb_paes_decrypt(struct 
>> skcipher_request *req)
>>  	return ecb_paes_crypt(req, CPACF_DECRYPT);
>>  }
>> 
>> -static struct skcipher_alg ecb_paes_alg = {
>> -	.base.cra_name		=	"ecb(paes)",
>> -	.base.cra_driver_name	=	"ecb-paes-s390",
>> -	.base.cra_priority	=	401,	/* combo: aes + ecb + 1 */
>> -	.base.cra_blocksize	=	AES_BLOCK_SIZE,
>> -	.base.cra_ctxsize	=	sizeof(struct s390_paes_ctx),
>> -	.base.cra_module	=	THIS_MODULE,
>> -	.base.cra_list		=	LIST_HEAD_INIT(ecb_paes_alg.base.cra_list),
>> -	.init			=	ecb_paes_init,
>> -	.exit			=	ecb_paes_exit,
>> -	.min_keysize		=	PAES_MIN_KEYSIZE,
>> -	.max_keysize		=	PAES_MAX_KEYSIZE,
>> -	.setkey			=	ecb_paes_set_key,
>> -	.encrypt		=	ecb_paes_encrypt,
>> -	.decrypt		=	ecb_paes_decrypt,
>> -};
>> -
>> -static int cbc_paes_init(struct crypto_skcipher *tfm)
>> +static int ecb_paes_init(struct crypto_skcipher *tfm)
>>  {
>>  	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
>> 
>> -	ctx->kb.key = NULL;
>> +	memset(ctx, 0, sizeof(*ctx));
>>  	spin_lock_init(&ctx->pk_lock);
>> 
>> +	crypto_skcipher_set_reqsize(tfm, sizeof(struct s390_pecb_req_ctx));
>> +
>>  	return 0;
>>  }
>> 
>> -static void cbc_paes_exit(struct crypto_skcipher *tfm)
>> +static void ecb_paes_exit(struct crypto_skcipher *tfm)
>>  {
>>  	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
>> 
>> -	_free_kb_keybuf(&ctx->kb);
>> +	memzero_explicit(ctx, sizeof(*ctx));
>>  }
>> 
>> -static inline int __cbc_paes_set_key(struct s390_paes_ctx *ctx)
>> +static int ecb_paes_do_one_request(struct crypto_engine *engine, void 
>> *areq)
>>  {
>> -	unsigned long fc;
>> +	struct skcipher_request *req = skcipher_request_cast(areq);
>> +	struct s390_pecb_req_ctx *req_ctx = skcipher_request_ctx(req);
>> +	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
>> +	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
>> +	struct skcipher_walk *walk = &req_ctx->walk;
>>  	int rc;
>> 
>> -	rc = __paes_convert_key(ctx);
>> -	if (rc)
>> -		return rc;
>> -
>> -	/* Pick the correct function code based on the protected key type */
>> -	fc = (ctx->pk.type == PKEY_KEYTYPE_AES_128) ? CPACF_KMC_PAES_128 :
>> -		(ctx->pk.type == PKEY_KEYTYPE_AES_192) ? CPACF_KMC_PAES_192 :
>> -		(ctx->pk.type == PKEY_KEYTYPE_AES_256) ? CPACF_KMC_PAES_256 : 0;
>> +	/* walk has already been prepared */
>> 
>> -	/* Check if the function code is available */
>> -	ctx->fc = (fc && cpacf_test_func(&kmc_functions, fc)) ? fc : 0;
>> +	rc = ecb_paes_do_crypt(ctx, req_ctx, true);
>> +	if (rc != -EKEYEXPIRED) {
>> +		if (rc)
>> +			skcipher_walk_done(walk, rc);
>> +		goto complete;
>> +	}
> 
> Same here, I would prefer to reverse the logic of the error handling.
> 
>> 
>> -	return ctx->fc ? 0 : -EINVAL;
>> +	/*
>> +	 * Protected key expired, conversion is in process.
>> +	 * Trigger a re-schedule of this request by returning
>> +	 * -ENOSPC ("hardware queue is full") to the crypto engine.
>> +	 * To avoid immediately re-invocation of this callback,
>> +	 * tell the scheduler to voluntarily give up the CPU here.
>> +	 */
>> +	yield();
> 
> As mentioned by checkpatch.pl, the use of yield() should be avoided.
> Please use alternatives (e.g. cond_reschedule()).
> 

done - replaced with cond_resched()

>> +	pr_debug("rescheduling request\n");
>> +	return -ENOSPC;
>> +
>> +complete:
>> +	memzero_explicit(&req_ctx->param, sizeof(req_ctx->param));
>> +	pr_debug("request complete with rc=%d\n", rc);
>> +	local_bh_disable();
>> +	crypto_finalize_skcipher_request(engine, req, rc);
>> +	local_bh_enable();
>> +	return rc;
>>  }
> 
> [...]

Thanks, see v4 for the changes.
