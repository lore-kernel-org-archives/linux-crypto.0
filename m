Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53DDD285C99;
	Tue, 14 Oct 2025 09:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760433611; cv=none; b=n8sjbnusxV9oy2ECZyVe4IeXp6WTFP8MbQZLQLRwRSpPBbviSWLrZi/8NjW75iPcX11Nsk+ECYGwdXEfyS5z1nFOC0ceJ0QPpnQgw7QNkmUdi0MIWZSgoAhK0V0pUzKw2V89PUOoUipQD6+Kf4zMEsx4gmuXUDDCmFLEXYqs5o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760433611; c=relaxed/simple;
	bh=ptyW5blK82grlmb5T67VIktmmXhEh/yiK16AWjuKVA4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i306OVLQttmXb8UHf+xqMKViOppB3Ephcl1tNP5RKEhqrD0uqY4NnjgcfPA5m0K7KgpHU9DtrKTL0KVXXkYnMYD/LmKlkaOYjNMI4OsXD47MdpGH/SobDP2/cmSTyyjj0qbLNyowmxHFOwOZF+EuAOk8zO1kU1culVaH8SW2nR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dFrigBcO; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dFrigBcO"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59E3etUg017406;
	Tue, 14 Oct 2025 09:20:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ZdRWIM
	7VRcAXQkaKeAAVe5EqqaSVWOh+J4N1cRswrRM=; b=dFrigBcO17YEDgYkEQYqth
	TFzHtwRZolUI6u4IiWhF4w1PtHL9Ine8RiZ1kZqlAOqe0Vf1hBEysk9fqz5UVrV7
	HoGk/LmnI0RAStjEy+DsXhDHlykwZ1g7acCzcfW+W7hI6MKOYuRib5I45s9dWjRB
	DWsNeEk7ytxehteEEIuTaRhYG5+CqpzH3EYeSJLzwPswDa1Of8+ArSrNym1Mxi+h
	V0VuTWuxMwGh5Kf1yxvy/z3IEgr2XQ9Wtb1E/Ocbs5DqW0jw4XNH7j/4QPtPatFl
	mFm0cgvJXyugzQia59XLob9VTqogCIkD9BnfCBYrBzCmy3ChtWHK3YmXat1uy66w
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49qdnpddfa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Oct 2025 09:20:03 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59E8K8uL018336;
	Tue, 14 Oct 2025 09:20:02 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 49s3rf3rc1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Oct 2025 09:20:02 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59E9Jw1553150126
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 09:19:58 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 496EC200A8;
	Tue, 14 Oct 2025 09:19:58 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1E4B0200A6;
	Tue, 14 Oct 2025 09:19:58 +0000 (GMT)
Received: from [9.111.132.230] (unknown [9.111.132.230])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 14 Oct 2025 09:19:58 +0000 (GMT)
Message-ID: <c0daf049-3b57-40ed-b212-807fd76ed079@linux.ibm.com>
Date: Tue, 14 Oct 2025 11:19:47 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] crypto: s390/phmac - Do not modify the req->nbytes
 value
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        herbert@gondor.apana.org.au, mpatocka@redhat.com,
        ifranzki@linux.ibm.com
References: <20251009160110.12829-1-freude@linux.ibm.com>
From: Holger Dengler <dengler@linux.ibm.com>
Content-Language: en-US
In-Reply-To: <20251009160110.12829-1-freude@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAwNSBTYWx0ZWRfX4uvg3iA0MDen
 1SsCXFBXvrzlHFq5/XZWLJfNORuNxmYrLB+WO5edIV7S0V+MmWzZgOhLVKMxxucUk1v1rne3t4t
 hibweuCbqfZsBLY8I7OD6/xLXKCFQvFc/VYiq26hLgewbc29r3yfQzuOVdD+t+nIiGjBmoroc9X
 ozdlgIaR80JJaqRncEZVGdL78O7xhGHCPrL5UZh/Y/AUoc3IWDfXbFmPZiK11TI44kXvXm70zSJ
 SSXeADtJR6X4pdF3yG+sCIhU8MTdC8wPlnHeDdTFEaSIgEAtaIubkwFwm41DGUcU9ihGMvmWmFj
 e95c1cmzP/5n3C0emiP+3fBH+BF2sUEsxN+uqyc907ZeS4F4Pcva1VrW62L3P+QDa/RhTjH6fX+
 AUxwv1csPWA7DkjyAiAbrp/2jP0sjg==
X-Proofpoint-ORIG-GUID: nJiIiWiClDxny94sW4wnhTzW-JAEVoFb
X-Proofpoint-GUID: nJiIiWiClDxny94sW4wnhTzW-JAEVoFb
X-Authority-Analysis: v=2.4 cv=MoxfKmae c=1 sm=1 tr=0 ts=68ee15c3 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=NXHXh-P0mxtWDDeYG0gA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-14_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 bulkscore=0 priorityscore=1501 malwarescore=0 clxscore=1011 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510110005

On 09/10/2025 18:01, Harald Freudenberger wrote:
> There was a failure reported by the phmac only in combination
> with dm-crypt where the phmac is used as the integrity check
> mechanism. A pseudo phmac which was implemented just as an
> asynchronous wrapper around the synchronous hmac algorithm did
> not show this failure. After some debugging the reason is clear:

In my opinion, the information up to here should not be part of the commit message. If you want to keep it, I would suggest to move it to the cover letter.

> The crypto aead layer obvious uses the req->nbytes value after
> the verification algorithm is through and finished with the
> request. If the req->nbytes value has been modified the aead
> layer will react with -EBADMSG to the caller (dm-crypt).
> 
> Unfortunately the phmac implementation used the req->nbytes
> field on combined operations (finup, digest) to track the
> state: with req->nbytes > 0 the update needs to be processed,
> while req->nbytes == 0 means to do the final operation. For
> this purpose the req->nbytes field was set to 0 after successful
> update operation. This worked fine and all tests succeeded but
> only failed with aead use as dm-crypt with verify uses it.
> 
> Fixed by a slight rework on the phmac implementation. There is
> now a new field async_op in the request context which tracks
> the (asynch) operation to process. So the 'state' via req->nbytes
> is not needed any more and now this field is untouched and may
> be evaluated even after a request is processed by the phmac
> implementation.
> 
> Fixes: cbbc675506cc ("crypto: s390 - New s390 specific protected key hash phmac")
> Reported-by: Ingo Franzki <ifranzki@linux.ibm.com>
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>

See my comments below.

> ---
>  arch/s390/crypto/phmac_s390.c | 52 +++++++++++++++++++++++------------
>  1 file changed, 34 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/s390/crypto/phmac_s390.c b/arch/s390/crypto/phmac_s390.c
> index 7ecfdc4fba2d..5d38a48cc45d 100644
> --- a/arch/s390/crypto/phmac_s390.c
> +++ b/arch/s390/crypto/phmac_s390.c
> @@ -169,11 +169,18 @@ struct kmac_sha2_ctx {
>  	u64 buflen[2];
>  };
>  
> +enum async_op {
> +	OP_NOP = 0,

The async_op element in struct phmac_req_ctx is implicitly initialized with OP_NOP. Only the functions update, final and finup will set another (valid) operation.  Can it ever happen, that do_one_request() is called *before* any of update, final or finup is called? If this is a valid case, the OP_NOP should be handled correctly in do_one_request(), otherwise we get a -ENOTSUPP (see my comment to phmac_do_one_request()).

If do_one_request() is never called before update/finup/final(), no change is required.

> +	OP_UPDATE,
> +	OP_FINAL,
> +	OP_FINUP,
> +};
> +
>  /* phmac request context */
>  struct phmac_req_ctx {
>  	struct hash_walk_helper hwh;
>  	struct kmac_sha2_ctx kmac_ctx;
> -	bool final;
> +	int async_op;

I know, that the compiler is happy with an int. But I would prefer to use the enum for the element.

enum async_op async_op;

>  };
>  
>  /*
[...]> @@ -855,15 +865,16 @@ static int phmac_do_one_request(struct crypto_engine *engine, void *areq)
>  
>  	/*
>  	 * Three kinds of requests come in here:
> -	 * update when req->nbytes > 0 and req_ctx->final is false
> -	 * final when req->nbytes = 0 and req_ctx->final is true
> -	 * finup when req->nbytes > 0 and req_ctx->final is true
> -	 * For update and finup the hwh walk needs to be prepared and
> -	 * up to date but the actual nr of bytes in req->nbytes may be
> -	 * any non zero number. For final there is no hwh walk needed.
> +	 * 1. req->async_op == OP_UPDATE with req->nbytes > 0
> +	 * 2. req->async_op == OP_FINUP with req->nbytes > 0
> +	 * 3. req->async_op == OP_FINAL
> +	 * For update and finup the hwh walk has already been prepared
> +	 * by the caller. For final there is no hwh walk needed.
>  	 */
>  
> -	if (req->nbytes) {
> +	switch (req_ctx->async_op) {
> +	case OP_UPDATE:
> +	case OP_FINUP:
>  		rc = phmac_kmac_update(req, true);
>  		if (rc == -EKEYEXPIRED) {
>  			/*
> @@ -880,10 +891,11 @@ static int phmac_do_one_request(struct crypto_engine *engine, void *areq)
>  			hwh_advance(hwh, rc);
>  			goto out;
>  		}
> -		req->nbytes = 0;
> -	}
> -
> -	if (req_ctx->final) {
> +		if (req_ctx->async_op == OP_UPDATE)
> +			break;
> +		req_ctx->async_op = OP_FINAL;
> +		fallthrough;
> +	case OP_FINAL:
>  		rc = phmac_kmac_final(req, true);
>  		if (rc == -EKEYEXPIRED) {
>  			/*
> @@ -897,10 +909,14 @@ static int phmac_do_one_request(struct crypto_engine *engine, void *areq)
>  			cond_resched();
>  			return -ENOSPC;
>  		}
> +		break;
> +	default:
> +		/* unknown/unsupported/unimplemented asynch op */
> +		return -EOPNOTSUPP;

If it is a valid case, that do_one_request() is called before update(), final() or finup() is called, we should handle OP_NOP here and not return with an error.
If do_one_request() is never called before update/finup/final(), no change is required.

[...]

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler
--
IBM Systems, Linux on IBM Z Development
dengler@linux.ibm.com

