Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696B02F7468;
	Tue, 14 Oct 2025 10:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760437922; cv=none; b=Eyi6Eo+FuoQI0QbrP6laBB+F7JbzPdUTxwBD/XbnVeXL1M0V4hQt1qClEubhJDlgoZ3vStos+qdbJbYJnE2wJkaKgBMHY/mj8oBt5xqCY8G3XHtTKcfiVGq7tSR3nllRenPjkuhJx7DQvLoZo+wqe/35BtN677xIhUpZUWO/ghs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760437922; c=relaxed/simple;
	bh=DxDS9jLf3Ca4XmPgWOLRDDGIA/iiD/0xuOQCAlcWL84=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=Ow9gK4oT2anag9mXAD2JiioptypJBmJAeVEso/htYrahq3JX7E2BrZsyvx6hO0KUANa8HtdkBUT1FkeczPxy65eQLwNI3/xbhoxlNa29Kk970uFMr+vVm7qfPKhtzpVmAuNXlrfNMhP/v2bAJVT8K482QmjQ9CTsKsH8WpYrB3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MLm+2gWF; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MLm+2gWF"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59E0HRS2018487;
	Tue, 14 Oct 2025 10:31:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=n39w6rJ9eVbBLKs0y5y68n/51Fy8S8J41NvrLSlaN+o=; b=MLm+2gWF+KyZ
	EQUWZ7Tw6QetpC5/mTfc/s9phaIFfPM1aXimcmAJVk+eejcIx1xSUMU2tTFpHer/
	lPDlpbZ0yHjHi4JM/GAde87cE5gq1bUj3aUXEMopdxeGex+ZC/gCznhFbVlsqk+i
	U2hizxE+kWIHFz04qUOHqfIRHEviqCF1Ox/481LmRiFwzyDSGgOqcZbOfUNS3ymY
	Pb/ECNoL1aIt98Z2nJPiyem6j09UjME2p5UDL9O4vJ9DDvEzh1w4h9vlLMCD6pMp
	sLDVN++f30LR3OOE/3qAL+WiJRH2wtYnyeg6spy5AqBfSoPw0SBHdER8tZ1RhZ4I
	vpHGer5V3w==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49qdnpdpb4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Oct 2025 10:31:56 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59E77f2D003618;
	Tue, 14 Oct 2025 10:31:55 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49r1xxth7t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Oct 2025 10:31:55 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59EAVrk829295190
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 10:31:54 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DD52858064;
	Tue, 14 Oct 2025 10:31:53 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4EF4D58055;
	Tue, 14 Oct 2025 10:31:53 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 14 Oct 2025 10:31:53 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 14 Oct 2025 12:31:52 +0200
From: Harald Freudenberger <freude@linux.ibm.com>
To: Holger Dengler <dengler@linux.ibm.com>
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        herbert@gondor.apana.org.au, mpatocka@redhat.com,
        ifranzki@linux.ibm.com
Subject: Re: [PATCH v1] crypto: s390/phmac - Do not modify the req->nbytes
 value
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <c0daf049-3b57-40ed-b212-807fd76ed079@linux.ibm.com>
References: <20251009160110.12829-1-freude@linux.ibm.com>
 <c0daf049-3b57-40ed-b212-807fd76ed079@linux.ibm.com>
Message-ID: <f72fb028d4d1ddf5d1e5fae5b362ce3a@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAwNSBTYWx0ZWRfX4CnRFc8altFp
 1xgZxg9nI0/SeQqoIJEseEMCD4fe5BD3MIpbgjiHapqDOC2ZcSkHWgs6ukUbuBa6wHG3R+TD0c0
 s7pdSAT+Ep9oVeH95dH792ZfsT5/ntE9eYG+tiq3LPuRLTpDvZOFwDWgwA1tWa0i7dIbNu1HMPx
 sGwgYIsp5JPOdEjlwAD2MyVK6wTRRJWt6WHXTLUgGS+BRFFQkYOYKgqwFQm3ZrPi1aE5at3A5/d
 StvscCBXnqV9zafM8PJ5CRrHGm8bHKDqD0Kga830FRnBOor+hQtzB2GWfJ5+XtzaFA8Chbi4JYT
 aS4a40Sdg6yGm0UYEuDRrlftpeppMGSsR2YuY/Nuq0ZlvbemAbgNs+74NqT/OgrJmPD6f5JJSHE
 6X9IzR/In56JNq0svhHcg9YgA9qeEQ==
X-Proofpoint-ORIG-GUID: wDc6abDPPSRrVSYGmkk7WxGFNrd_u0ih
X-Proofpoint-GUID: wDc6abDPPSRrVSYGmkk7WxGFNrd_u0ih
X-Authority-Analysis: v=2.4 cv=MoxfKmae c=1 sm=1 tr=0 ts=68ee269c cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=4ilpujzdisWUX8ivVjsA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-14_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 bulkscore=0 priorityscore=1501 malwarescore=0 clxscore=1015 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510110005

On 2025-10-14 11:19, Holger Dengler wrote:
> On 09/10/2025 18:01, Harald Freudenberger wrote:
>> There was a failure reported by the phmac only in combination
>> with dm-crypt where the phmac is used as the integrity check
>> mechanism. A pseudo phmac which was implemented just as an
>> asynchronous wrapper around the synchronous hmac algorithm did
>> not show this failure. After some debugging the reason is clear:
> 
> In my opinion, the information up to here should not be part of the
> commit message. If you want to keep it, I would suggest to move it to
> the cover letter.
> 

Ok, will remove this.

>> The crypto aead layer obvious uses the req->nbytes value after
>> the verification algorithm is through and finished with the
>> request. If the req->nbytes value has been modified the aead
>> layer will react with -EBADMSG to the caller (dm-crypt).
>> 
>> Unfortunately the phmac implementation used the req->nbytes
>> field on combined operations (finup, digest) to track the
>> state: with req->nbytes > 0 the update needs to be processed,
>> while req->nbytes == 0 means to do the final operation. For
>> this purpose the req->nbytes field was set to 0 after successful
>> update operation. This worked fine and all tests succeeded but
>> only failed with aead use as dm-crypt with verify uses it.
>> 
>> Fixed by a slight rework on the phmac implementation. There is
>> now a new field async_op in the request context which tracks
>> the (asynch) operation to process. So the 'state' via req->nbytes
>> is not needed any more and now this field is untouched and may
>> be evaluated even after a request is processed by the phmac
>> implementation.
>> 
>> Fixes: cbbc675506cc ("crypto: s390 - New s390 specific protected key 
>> hash phmac")
>> Reported-by: Ingo Franzki <ifranzki@linux.ibm.com>
>> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
> 
> See my comments below.
> 
>> ---
>>  arch/s390/crypto/phmac_s390.c | 52 
>> +++++++++++++++++++++++------------
>>  1 file changed, 34 insertions(+), 18 deletions(-)
>> 
>> diff --git a/arch/s390/crypto/phmac_s390.c 
>> b/arch/s390/crypto/phmac_s390.c
>> index 7ecfdc4fba2d..5d38a48cc45d 100644
>> --- a/arch/s390/crypto/phmac_s390.c
>> +++ b/arch/s390/crypto/phmac_s390.c
>> @@ -169,11 +169,18 @@ struct kmac_sha2_ctx {
>>  	u64 buflen[2];
>>  };
>> 
>> +enum async_op {
>> +	OP_NOP = 0,
> 
> The async_op element in struct phmac_req_ctx is implicitly initialized
> with OP_NOP. Only the functions update, final and finup will set
> another (valid) operation.  Can it ever happen, that do_one_request()
> is called *before* any of update, final or finup is called? If this is
> a valid case, the OP_NOP should be handled correctly in
> do_one_request(), otherwise we get a -ENOTSUPP (see my comment to
> phmac_do_one_request()).
> 
> If do_one_request() is never called before update/finup/final(), no
> change is required.
> 

Well, do_one_request() is only called via a postponed request pushed
from one of the "front" functions (init/update/final/finup/digest) to
the engine instance. So a request is always first seen by these
functions and these have a chance to update the async_op field.

>> +	OP_UPDATE,
>> +	OP_FINAL,
>> +	OP_FINUP,
>> +};
>> +
>>  /* phmac request context */
>>  struct phmac_req_ctx {
>>  	struct hash_walk_helper hwh;
>>  	struct kmac_sha2_ctx kmac_ctx;
>> -	bool final;
>> +	int async_op;
> 
> I know, that the compiler is happy with an int. But I would prefer to
> use the enum for the element.
> 
> enum async_op async_op;
> 

Catched - my first experiences with C where at a time where enums where
not supported. So I am still not familiar with this kind of stuff :-)

>>  };
>> 
>>  /*
> [...]> @@ -855,15 +865,16 @@ static int phmac_do_one_request(struct
> crypto_engine *engine, void *areq)
>> 
>>  	/*
>>  	 * Three kinds of requests come in here:
>> -	 * update when req->nbytes > 0 and req_ctx->final is false
>> -	 * final when req->nbytes = 0 and req_ctx->final is true
>> -	 * finup when req->nbytes > 0 and req_ctx->final is true
>> -	 * For update and finup the hwh walk needs to be prepared and
>> -	 * up to date but the actual nr of bytes in req->nbytes may be
>> -	 * any non zero number. For final there is no hwh walk needed.
>> +	 * 1. req->async_op == OP_UPDATE with req->nbytes > 0
>> +	 * 2. req->async_op == OP_FINUP with req->nbytes > 0
>> +	 * 3. req->async_op == OP_FINAL
>> +	 * For update and finup the hwh walk has already been prepared
>> +	 * by the caller. For final there is no hwh walk needed.
>>  	 */
>> 
>> -	if (req->nbytes) {
>> +	switch (req_ctx->async_op) {
>> +	case OP_UPDATE:
>> +	case OP_FINUP:
>>  		rc = phmac_kmac_update(req, true);
>>  		if (rc == -EKEYEXPIRED) {
>>  			/*
>> @@ -880,10 +891,11 @@ static int phmac_do_one_request(struct 
>> crypto_engine *engine, void *areq)
>>  			hwh_advance(hwh, rc);
>>  			goto out;
>>  		}
>> -		req->nbytes = 0;
>> -	}
>> -
>> -	if (req_ctx->final) {
>> +		if (req_ctx->async_op == OP_UPDATE)
>> +			break;
>> +		req_ctx->async_op = OP_FINAL;
>> +		fallthrough;
>> +	case OP_FINAL:
>>  		rc = phmac_kmac_final(req, true);
>>  		if (rc == -EKEYEXPIRED) {
>>  			/*
>> @@ -897,10 +909,14 @@ static int phmac_do_one_request(struct 
>> crypto_engine *engine, void *areq)
>>  			cond_resched();
>>  			return -ENOSPC;
>>  		}
>> +		break;
>> +	default:
>> +		/* unknown/unsupported/unimplemented asynch op */
>> +		return -EOPNOTSUPP;
> 
> If it is a valid case, that do_one_request() is called before
> update(), final() or finup() is called, we should handle OP_NOP here
> and not return with an error.
> If do_one_request() is never called before update/finup/final(), no
> change is required.
> 

As wrote above the "front" functions always see a request first before
it is postponed to the engine and appears here. So the OP_NOP case
must not happen here and thus is only covered with the default arm.

> [...]
