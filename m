Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A834D84E1C;
	Fri, 25 Apr 2025 14:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745592992; cv=none; b=B5D4eMKdmHei+KDXWXD4bE4t4D0lq+DJPwpP60k8qidrT0iiFfPanbzXHcuWfDTKBHPL32HjQAYWbsbFg3NUQi9r6qETUQn/gGckI2qchYimquzaGF4XrJCR+fKomB8UG9KwxyiqIrbpjfGrtYa/9ZZnzGKxMC31pZK+R/XDopE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745592992; c=relaxed/simple;
	bh=wghhY3bvldc/nr3VDv3bupNy+aBtSCnIaqDBOPDzbF4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u4mTNoGqmQd0oHT3/jCUSQg2wq1sWbiuffJHNmSde7HLqQGSnWjCfMp23/AjVyHI8L79zyCrk4nfIK1kyf8dEtyUaEj9fkTWQCWSEev8a3ZLDM0Wz4FHNLyD68U+daqH9qSAkud7nd2cmKwth5uD9tDpMql2eiyZhemH4ScTU5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=CP4n3Qr/; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="CP4n3Qr/"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53PA4AHb026633;
	Fri, 25 Apr 2025 14:56:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=XcZ3TX
	PO/BQr4rMpY2IdBWWD56qQyeHXrFI4/T/9SXI=; b=CP4n3Qr/5ifEE7aml2CXVj
	vuAkA0XShHH9rRPDiZcLcUS43sOMFpuzm4+zdCZ+lCnukDQJb+Za3+6+VkgnQPAI
	wvvc9u18r3zhrNUv0IEdjhvhCv2HkfBF3RrX88HQZz1XnmlySFuldaRChtnQgO4f
	JDCp99GF3iQn6Y0gGXB9I5DBFP9otPMHiV0MnA+YdNR0pKD9ExTGZOvp078AXVgp
	3dofhxwH1ijGpAkIORS8UjBZ8PwQbsZP7PmYV5mPnwfiv5WjwCgPq95G7Fh666fT
	VDAJMJpkS4qEFXkB9V8+WCMNHxA6VRtnslY89z8uX+yvA+/yxHQEnF6GkDTWndyQ
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4688ajs9ny-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 25 Apr 2025 14:56:27 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 53PCprw0004061;
	Fri, 25 Apr 2025 14:56:26 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 466jg05q9d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 25 Apr 2025 14:56:26 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 53PEuN1360555536
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Apr 2025 14:56:23 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0A7B420040;
	Fri, 25 Apr 2025 14:56:23 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8A7DC20043;
	Fri, 25 Apr 2025 14:56:22 +0000 (GMT)
Received: from [9.111.80.221] (unknown [9.111.80.221])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 25 Apr 2025 14:56:22 +0000 (GMT)
Message-ID: <9ddc9bc9-ad88-4ba5-aebf-2fcdd01db064@linux.ibm.com>
Date: Fri, 25 Apr 2025 16:56:22 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] s390/crypto: Rework protected key AES for true
 asynch support
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        herbert@gondor.apana.org.au, fcallies@linux.ibm.com,
        ifranzki@linux.ibm.com
References: <20250401145048.52564-1-freude@linux.ibm.com>
 <20250401145048.52564-3-freude@linux.ibm.com>
Content-Language: en-US
From: Holger Dengler <dengler@linux.ibm.com>
In-Reply-To: <20250401145048.52564-3-freude@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI1MDEwNCBTYWx0ZWRfX2u0f1we7ofVK dAv9Q1ES4F+JyK5bKSUpw14a00hMAGvsAvrKCOU4uWJB5GV4hDpKki3eJh1j81E6p038ppiRj6s zP6C5ODimRWFVh1Hw/AkPhuNcQxOnEvfsfCg5XypX52c4TLQxIwp9ygXiYR4LuiQH8XVomcEgRZ
 qRmn3W9psZtZgS5NGiL/2GYD+JZIRMR/XSTJFK1hAXGz5ps3kJze3oUfl6Zl7ECm4vA+rK9fKMr yKnxVJPyFnSf7WXLpK8TxJxNvNd6qP9XwtARcqS5vOoi40/rQInm258+VdPCwcPc1cVgRWbIzXL Pp5ICg8P84FA0KlGt4GdfitG/HZqLGkqdI+Q9PiLIoE9k7Wy7GhYpc3c3KOTfSDtC0f/PBvWZLT
 W9s7lswNil6xN6Jgy+5UcHXv7znBm5c7afYs3Vk83SCsYgnCOhFVd1xhyAAPbbx4sxsEw2D8
X-Authority-Analysis: v=2.4 cv=F8xXdrhN c=1 sm=1 tr=0 ts=680ba29b cx=c_pps a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=VnNF1IyMAAAA:8 a=xme88AklhaXFG-sfokcA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: WMj0DYeIjC_XoUpbR4aW716L3zK_kd7i
X-Proofpoint-ORIG-GUID: WMj0DYeIjC_XoUpbR4aW716L3zK_kd7i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-25_04,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 mlxscore=0 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 bulkscore=0 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2504250104

On 01/04/2025 16:50, Harald Freudenberger wrote:
> This is a complete rework of the protected key AES (PAES) implementation.
> The goal of this rework is to implement the 4 modes (ecb, cbc, ctr, xts)
> in a real asynchronous fashion:
> - init(), exit() and setkey() are synchronous and don't allocate any memory.
> - the encrypt/decrypt functions first try to do the job in a synchronous
>   manner. If this fails, for example the protected key got invalid caused
>   by for example a guest suspend/resume or guest migration action, the

reword: please drop one of the "for example".

>   encrypt/decrypt is transfered to an instance of the crypto engine (see

typo: transferred 

>   below) for asynchronous processing.
>   These via crypto engine postponed requests are then handled via the
>   do_one_request() callback but may of course again run into a still

reword: please drop at least one "via". Proposal (if I got it correctly): "These postponed requests are then handled by the crypto engine by calling the do_one_request() callback ..."

>   not converted key or the key is getting invalid. If the key is
>   still not converted, the first thread does the conversion and updates
>   the key status in the transformation context. The conversion is
>   invoked via pkey API with a new flag PKEY_XFLAG_NOMEMALLOC.
> 
> The pkey API used here - the function pkey_key2protkey() - uses
> a new version of this in-kernel-API. A new flag PKEY_XFLAG_NOMEMALLOC
> tells the PKEY layer (and subsidiary layers) that it must not allocate
> any memory causing IO operations. Note that the patches for this
> pkey/zcrypt/AP extensions are currently under review and yet not
> upstream available. SO THIS PATCH DOES NOT COMPILE YET.

As the ap-rework series is now on its way, you can remove parts of this paragraph.

> This patch together with the pkey/zcrypt/AP extensions should
> toughen the paes crypto algorithms to truly meet the requirements
> for in-kernel skcipher implementations and the usage patterns for
> the dm-crypt and dm-integrity layers.
> 
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>

It is very hard to review this patch. If there is any chance to split this up into smaller pieces, please do it.
This is the first part of the review, covering mainly common parts and ecb. The other modes will follow later.
See my comments below.

> ---
>  arch/s390/crypto/paes_s390.c | 1725 +++++++++++++++++++++++-----------
>  1 file changed, 1183 insertions(+), 542 deletions(-)
> 
> diff --git a/arch/s390/crypto/paes_s390.c b/arch/s390/crypto/paes_s390.c
> index 646cbbf0678d..1d1f1a98ec4d 100644
> --- a/arch/s390/crypto/paes_s390.c
> +++ b/arch/s390/crypto/paes_s390.c
> @@ -5,7 +5,7 @@
>   * s390 implementation of the AES Cipher Algorithm with protected keys.
>   *
>   * s390 Version:
> - *   Copyright IBM Corp. 2017, 2023
> + *   Copyright IBM Corp. 2017, 2025
>   *   Author(s): Martin Schwidefsky <schwidefsky@de.ibm.com>
>   *		Harald Freudenberger <freude@de.ibm.com>
>   */
> @@ -13,16 +13,17 @@
>  #define KMSG_COMPONENT "paes_s390"
>  #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
>  
> -#include <crypto/aes.h>
> -#include <crypto/algapi.h>
> -#include <linux/bug.h>
> -#include <linux/err.h>
> -#include <linux/module.h>
>  #include <linux/cpufeature.h>
> +#include <linux/delay.h>
> +#include <linux/err.h>
>  #include <linux/init.h>
> +#include <linux/miscdevice.h>
> +#include <linux/module.h>
>  #include <linux/mutex.h>
>  #include <linux/spinlock.h>
> -#include <linux/delay.h>
> +#include <crypto/aes.h>
> +#include <crypto/algapi.h>
> +#include <crypto/engine.h>
>  #include <crypto/internal/skcipher.h>
>  #include <crypto/xts.h>
>  #include <asm/cpacf.h>
> @@ -44,23 +45,55 @@ static DEFINE_MUTEX(ctrblk_lock);
>  
>  static cpacf_mask_t km_functions, kmc_functions, kmctr_functions;
>  
> +static struct crypto_engine *paes_crypto_engine;
> +#define MAX_QLEN 10
> +
> +/*
> + * protected key specific stuff
> + */
> +
>  struct paes_protkey {
>  	u32 type;
>  	u32 len;
>  	u8 protkey[PXTS_256_PROTKEY_SIZE];
>  };
>  
> -struct key_blob {
> -	/*
> -	 * Small keys will be stored in the keybuf. Larger keys are
> -	 * stored in extra allocated memory. In both cases does
> -	 * key point to the memory where the key is stored.
> -	 * The code distinguishes by checking keylen against
> -	 * sizeof(keybuf). See the two following helper functions.
> -	 */
> -	u8 *key;
> -	u8 keybuf[128];
> +#define PK_STATE_NO_KEY		     0
> +#define PK_STATE_CONVERT_IN_PROGRESS 1
> +#define PK_STATE_VALID		     2

Please use an enum here.

> +
> +struct s390_paes_ctx {
> +	/* source key material used to derive a protected key from */
> +	u8 keybuf[PAES_MAX_KEYSIZE];
> +	unsigned int keylen;
> +
> +	/* cpacf function code to use with this protected key type */
> +	long fc;
> +
> +	/* spinlock to atomic read/update all the following fields */
> +	spinlock_t pk_lock;
> +
> +	/* see PK_STATE* defines above, < 0 holds convert failure rc  */
> +	int pk_state;

I see no advantage to split the value range. On the contrary, it makes the status handling more complex.
I would prefer to use an enum for pk_state and use another element for the conversion rc.

> +	/* if state is valid, pk holds the protected key */
> +	struct paes_protkey pk;
> +};
> +
> +struct s390_pxts_ctx {
> +	/* source key material used to derive a protected key from */
> +	u8 keybuf[2 * PAES_MAX_KEYSIZE];
>  	unsigned int keylen;
> +
> +	/* cpacf function code to use with this protected key type */
> +	long fc;
> +
> +	/* spinlock to atomic read/update all the following fields */
> +	spinlock_t pk_lock;
> +
> +	/* see PK_STATE* defines above, < 0 holds convert failure rc  */
> +	int pk_state;

Same here.

> +	/* if state is valid, pk[] hold(s) the protected key(s) */
> +	struct paes_protkey pk[2];
>  };
>  
>  /*
> @@ -89,214 +122,344 @@ static inline u32 make_clrkey_token(const u8 *ck, size_t cklen, u8 *dest)
>  	return sizeof(*token) + cklen;
>  }
>  
> -static inline int _key_to_kb(struct key_blob *kb,
> -			     const u8 *key,
> -			     unsigned int keylen)
> +/*
> + * key_to_ctx() - Set key value into context, maybe construct
> + * a clear key token digestable by pkey from a clear key value.
> + */
> +static inline int key_to_ctx(struct s390_paes_ctx *ctx,
> +			     const u8 *key, unsigned int keylen)

The function name implies a transformation of a key into a context, not just a set of a context element. What about paes_ctx_setkey()?

>  {
> +	if (keylen > sizeof(ctx->keybuf))
> +		return -EINVAL;
> +
>  	switch (keylen) {
>  	case 16:
>  	case 24:
>  	case 32:
>  		/* clear key value, prepare pkey clear key token in keybuf */
> -		memset(kb->keybuf, 0, sizeof(kb->keybuf));
> -		kb->keylen = make_clrkey_token(key, keylen, kb->keybuf);
> -		kb->key = kb->keybuf;
> +		memset(ctx->keybuf, 0, sizeof(ctx->keybuf));
> +		ctx->keylen = make_clrkey_token(key, keylen, ctx->keybuf);
>  		break;
>  	default:
>  		/* other key material, let pkey handle this */
> -		if (keylen <= sizeof(kb->keybuf))
> -			kb->key = kb->keybuf;
> -		else {
> -			kb->key = kmalloc(keylen, GFP_KERNEL);
> -			if (!kb->key)
> -				return -ENOMEM;
> -		}
> -		memcpy(kb->key, key, keylen);
> -		kb->keylen = keylen;
> +		memcpy(ctx->keybuf, key, keylen);
> +		ctx->keylen = keylen;
>  		break;
>  	}
>  
>  	return 0;
>  }
>  
> -static inline int _xts_key_to_kb(struct key_blob *kb,
> -				 const u8 *key,
> -				 unsigned int keylen)
> +/*
> + * xts_key_to_ctx() - Set key value into context, maybe construct
> + * a clear key token digestable by pkey from a clear key value.
> + */
> +static inline int xts_key_to_ctx(struct s390_pxts_ctx *ctx,
> +				 const u8 *key, unsigned int keylen)

Same here, the function name implies a transformation of a key into a context, not just a set of a context element. What about pxts_ctx_setkey()?

>  {
>  	size_t cklen = keylen / 2;
>  
[...]
> +static int ecb_paes_do_crypt(struct s390_paes_ctx *ctx,
> +			     struct s390_pecb_req_ctx *req_ctx,
> +			     bool maysleep)
>  {
> -	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
> -	int rc;
> +	struct ecb_param *param = &req_ctx->param;
> +	struct skcipher_walk *walk = &req_ctx->walk;
> +	unsigned int nbytes, n, k;
> +	int pk_state, rc;
> +
> +	if (!req_ctx->param_init_done) {
> +		/* fetch and check protected key state */
> +		spin_lock_bh(&ctx->pk_lock);
> +		pk_state = ctx->pk_state;
> +		memcpy(param->key, ctx->pk.protkey, PAES_256_PROTKEY_SIZE);

I would prefer to use the size of param->key instead of a constant value as length.

> +		spin_unlock_bh(&ctx->pk_lock);
> +		switch (pk_state) {
> +		case PK_STATE_NO_KEY:
> +			rc = -ENOKEY;
> +			goto out;
> +		case PK_STATE_CONVERT_IN_PROGRESS:
> +			rc = -EKEYEXPIRED;
> +			goto out;
> +		case PK_STATE_VALID:
> +			req_ctx->param_init_done = true;
> +			break;
> +		default:
> +			rc = pk_state < 0 ? pk_state : -EIO;
> +			goto out;
> +		}
> +	}
>  
> -	_free_kb_keybuf(&ctx->kb);
> -	rc = _key_to_kb(&ctx->kb, in_key, key_len);
> -	if (rc)
> -		return rc;
> +	rc = 0;

Modify the param block in req_ctx only if the protected key is valid.

int rc = 0;

if (!req_ctx->param_init_done) {
	/* fetch and check protected key state */
	spin_lock_bh(&ctx->pk_lock);
	switch (ctx->pk_state) {
	case PK_STATE_NO_KEY:
		rc = -ENOKEY;
		break;
	case PK_STATE_CONVERT_IN_PROGRESS:
		rc = -EKEYEXPIRED;
		break;
	case PK_STATE_VALID:
		memcpy(param->key, ctx->pk.protkey, sizeof(param->key));
		req_ctx->param_init_done = true;
		break;
	default:
		rc = pk_state < 0 ? pk_state : -EIO;
		break;
	}
	spin_unlock_bh(&ctx->pk_lock);
	if (rc)
		goto out;
}

> +
> +	/* always walk on the ... */

What does this comment mean? I'm afraid, I don't get it.

> +	while ((nbytes = walk->nbytes) != 0) {
> +		/* only use complete blocks */
> +		n = nbytes & ~(AES_BLOCK_SIZE - 1);
> +		k = cpacf_km(ctx->fc | req_ctx->modifier, param,
> +			     walk->dst.virt.addr, walk->src.virt.addr, n);
> +		if (k)
> +			rc = skcipher_walk_done(walk, nbytes - k);
> +		if (k < n) {
> +			if (!maysleep) {
> +				rc = -EKEYEXPIRED;
> +				goto out;
> +			}
> +			rc = paes_convert_key(ctx);
> +			if (rc)
> +				goto out;
> +			spin_lock_bh(&ctx->pk_lock);
> +			memcpy(param->key, ctx->pk.protkey, PAES_256_PROTKEY_SIZE);
> +			spin_unlock_bh(&ctx->pk_lock);
> +		}
> +	}
>  
> -	return __ecb_paes_set_key(ctx);
> +out:
> +	pr_debug("rc=%d\n", rc);
> +	return rc;
>  }
>  
>  static int ecb_paes_crypt(struct skcipher_request *req, unsigned long modifier)
>  {
> +	struct s390_pecb_req_ctx *req_ctx = skcipher_request_ctx(req);
>  	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
>  	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
> -	struct {
> -		u8 key[PAES_256_PROTKEY_SIZE];
> -	} param;
> -	struct skcipher_walk walk;
> -	unsigned int nbytes, n, k;
> +	struct skcipher_walk *walk = &req_ctx->walk;
>  	int rc;
>  
> -	rc = skcipher_walk_virt(&walk, req, false);
> +	/*
> +	 * First try synchronous. If this fails for any reason
> +	 * schedule this request asynchronous via crypto engine.
> +	 */
> +
> +	rc = skcipher_walk_virt(walk, req, false);
>  	if (rc)
> -		return rc;
> +		goto out;
>  
> -	spin_lock_bh(&ctx->pk_lock);
> -	memcpy(param.key, ctx->pk.protkey, PAES_256_PROTKEY_SIZE);
> -	spin_unlock_bh(&ctx->pk_lock);
> +	req_ctx->modifier = modifier;
> +	req_ctx->param_init_done = false;
>  
> -	while ((nbytes = walk.nbytes) != 0) {
> -		/* only use complete blocks */
> -		n = nbytes & ~(AES_BLOCK_SIZE - 1);
> -		k = cpacf_km(ctx->fc | modifier, &param,
> -			     walk.dst.virt.addr, walk.src.virt.addr, n);
> -		if (k)
> -			rc = skcipher_walk_done(&walk, nbytes - k);
> -		if (k < n) {
> -			if (__paes_convert_key(ctx))
> -				return skcipher_walk_done(&walk, -EIO);
> -			spin_lock_bh(&ctx->pk_lock);
> -			memcpy(param.key, ctx->pk.protkey, PAES_256_PROTKEY_SIZE);
> -			spin_unlock_bh(&ctx->pk_lock);
> -		}
> +	rc = ecb_paes_do_crypt(ctx, req_ctx, false);
> +	if (rc != -EKEYEXPIRED) {
> +		if (rc)
> +			skcipher_walk_done(walk, rc);
> +		goto out;
>  	}
> +
> +	rc = crypto_transfer_skcipher_request_to_engine(paes_crypto_engine, req);
> +	if (rc)
> +		goto out;
> +
> +	rc = -EINPROGRESS;
> +
> +out:
> +	if (rc != -EINPROGRESS)
> +		memzero_explicit(&req_ctx->param, sizeof(req_ctx->param));
> +	pr_debug("rc=%d\n", rc);
>  	return rc;

If took me a while to find the synchronous good case code path. I would prefer to handle the various cases separately, either with a switch/case or by explicit checks in the main path.

rc = ecb_paes_do_crypt(ctx, req_ctx, false);
if (rc == -EKEYEXPIRED) {
	rc = crypto_transfer_skcipher_request_to_engine(paes_crypto_engine, req);
	rc = rc ?: -EINPROGRESS;
} else if (rc) {
	skcipher_walk_done(walk, rc);
}

if (rc != -EINPROGRESS)
	memzero_explicit(&req_ctx->param, sizeof(req_ctx->param));
pr_debug("rc=%d\n", rc);
return rc;

>  }
>  
> @@ -310,112 +473,242 @@ static int ecb_paes_decrypt(struct skcipher_request *req)
>  	return ecb_paes_crypt(req, CPACF_DECRYPT);
>  }
>  
> -static struct skcipher_alg ecb_paes_alg = {
> -	.base.cra_name		=	"ecb(paes)",
> -	.base.cra_driver_name	=	"ecb-paes-s390",
> -	.base.cra_priority	=	401,	/* combo: aes + ecb + 1 */
> -	.base.cra_blocksize	=	AES_BLOCK_SIZE,
> -	.base.cra_ctxsize	=	sizeof(struct s390_paes_ctx),
> -	.base.cra_module	=	THIS_MODULE,
> -	.base.cra_list		=	LIST_HEAD_INIT(ecb_paes_alg.base.cra_list),
> -	.init			=	ecb_paes_init,
> -	.exit			=	ecb_paes_exit,
> -	.min_keysize		=	PAES_MIN_KEYSIZE,
> -	.max_keysize		=	PAES_MAX_KEYSIZE,
> -	.setkey			=	ecb_paes_set_key,
> -	.encrypt		=	ecb_paes_encrypt,
> -	.decrypt		=	ecb_paes_decrypt,
> -};
> -
> -static int cbc_paes_init(struct crypto_skcipher *tfm)
> +static int ecb_paes_init(struct crypto_skcipher *tfm)
>  {
>  	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
>  
> -	ctx->kb.key = NULL;
> +	memset(ctx, 0, sizeof(*ctx));
>  	spin_lock_init(&ctx->pk_lock);
>  
> +	crypto_skcipher_set_reqsize(tfm, sizeof(struct s390_pecb_req_ctx));
> +
>  	return 0;
>  }
>  
> -static void cbc_paes_exit(struct crypto_skcipher *tfm)
> +static void ecb_paes_exit(struct crypto_skcipher *tfm)
>  {
>  	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
>  
> -	_free_kb_keybuf(&ctx->kb);
> +	memzero_explicit(ctx, sizeof(*ctx));
>  }
>  
> -static inline int __cbc_paes_set_key(struct s390_paes_ctx *ctx)
> +static int ecb_paes_do_one_request(struct crypto_engine *engine, void *areq)
>  {
> -	unsigned long fc;
> +	struct skcipher_request *req = skcipher_request_cast(areq);
> +	struct s390_pecb_req_ctx *req_ctx = skcipher_request_ctx(req);
> +	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> +	struct s390_paes_ctx *ctx = crypto_skcipher_ctx(tfm);
> +	struct skcipher_walk *walk = &req_ctx->walk;
>  	int rc;
>  
> -	rc = __paes_convert_key(ctx);
> -	if (rc)
> -		return rc;
> -
> -	/* Pick the correct function code based on the protected key type */
> -	fc = (ctx->pk.type == PKEY_KEYTYPE_AES_128) ? CPACF_KMC_PAES_128 :
> -		(ctx->pk.type == PKEY_KEYTYPE_AES_192) ? CPACF_KMC_PAES_192 :
> -		(ctx->pk.type == PKEY_KEYTYPE_AES_256) ? CPACF_KMC_PAES_256 : 0;
> +	/* walk has already been prepared */
>  
> -	/* Check if the function code is available */
> -	ctx->fc = (fc && cpacf_test_func(&kmc_functions, fc)) ? fc : 0;
> +	rc = ecb_paes_do_crypt(ctx, req_ctx, true);
> +	if (rc != -EKEYEXPIRED) {
> +		if (rc)
> +			skcipher_walk_done(walk, rc);
> +		goto complete;
> +	}

Same here, I would prefer to reverse the logic of the error handling.

>  
> -	return ctx->fc ? 0 : -EINVAL;
> +	/*
> +	 * Protected key expired, conversion is in process.
> +	 * Trigger a re-schedule of this request by returning
> +	 * -ENOSPC ("hardware queue is full") to the crypto engine.
> +	 * To avoid immediately re-invocation of this callback,
> +	 * tell the scheduler to voluntarily give up the CPU here.
> +	 */
> +	yield();

As mentioned by checkpatch.pl, the use of yield() should be avoided. Please use alternatives (e.g. cond_reschedule()).

> +	pr_debug("rescheduling request\n");
> +	return -ENOSPC;
> +
> +complete:
> +	memzero_explicit(&req_ctx->param, sizeof(req_ctx->param));
> +	pr_debug("request complete with rc=%d\n", rc);
> +	local_bh_disable();
> +	crypto_finalize_skcipher_request(engine, req, rc);
> +	local_bh_enable();
> +	return rc;
>  }

[...]

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler
--
IBM Systems, Linux on IBM Z Development
dengler@linux.ibm.com

