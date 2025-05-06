Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F43827F19E;
	Tue,  6 May 2025 14:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746540172; cv=none; b=o3CLtGK8P2nXhfsFSrZC4emNaLylo+a4xPjfGGEYChJzVZLcGspbpJpGADVV31UHqXQn5vRo6c1sXQ7QNV0K72VfRY3tmugh5e55OpD+QIf/F+ObHETEGMyqRZrY+fvC+awB9wa8huZeD9uchvrpDr8FfNOTinV9mg616kj+fGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746540172; c=relaxed/simple;
	bh=+G2qkNKTUhDrIZKr/W75bELY7DzvB3g0pKfTn/szvsI=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=tUgx3CTDz8Q5q3iyfWT66VqhuLLzjqsx5HbCTwbUDOMebRkP5M5fQTqF8j6khpzhuXPX4nx9g5W0v58GCzoFPLcWDtSkr/WJFYoJbKn2lqIMt3RXpQxgsw+XRW4yYS5E2GScXQjWB5+dSYtvIhLlPWOinxuxA0c4Mk0HVt6iCj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pfdhf/eE; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pfdhf/eE"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 546BKcRc014059;
	Tue, 6 May 2025 14:02:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=W/+4Z+9f6Y4VZRO0D9ToqRz8wkR8WFIXQeOWFnvww4U=; b=pfdhf/eEY9Zd
	gnrDQR7bJnJIzT2/xgUH781Qk2//0isVJilr2wTui/ZBMMbLfidrZFS1x7vzikRB
	ZrUIxZesDIW42nEQ10DZNXn4K5132Dazh1tjSt6aYEO8mFywD+mgyYkqu5Yfetiz
	FcHEFFLp//co03J8uSJU6Ad60Q76NSItIk+bolN/TkxmFGuwmIHrJ1hw2WOsDHd5
	efwZnmUTdgMxiWBElpsoLrFKnPZSa0GNF19WDDw3B+HSthEVfmjMr3do9r+Z41RT
	XjOS71dvaIaSNwQjDFEaraQOcstv3InLAHi4cdgbzFtV1Eh2Ft75Mdplunr0fM1n
	S2nkbI6lpQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46f5fw3jwt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 May 2025 14:02:45 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 546Ded0M014583;
	Tue, 6 May 2025 14:02:43 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 46dypkkhp7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 May 2025 14:02:43 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 546E2ggO28050096
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 6 May 2025 14:02:43 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9B2C65805C;
	Tue,  6 May 2025 14:02:42 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0DB8658061;
	Tue,  6 May 2025 14:02:42 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  6 May 2025 14:02:41 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 06 May 2025 16:02:41 +0200
From: Harald Freudenberger <freude@linux.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: dengler@linux.ibm.com, ifranzki@linux.ibm.com, fcallies@linux.ibm.com,
        linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 2/3] s390/crypto: Rework protected key AES for true
 asynch support
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <Z-y3W4o5nz9qfijs@gondor.apana.org.au>
References: <20250401145048.52564-1-freude@linux.ibm.com>
 <20250401145048.52564-3-freude@linux.ibm.com>
 <Z-y3W4o5nz9qfijs@gondor.apana.org.au>
Message-ID: <26acddbb918cda48c948e7f07172ce3b@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA2MDEzMSBTYWx0ZWRfX7owFnVzG+19g 6q78YYOPQj2oOPQUb5ZipmSwSnX6mySytR3TN4sbUM+Eby+grd+7xFuY1PQyilvhQMIelr6LqYg 9gW6dteG5AZVSd9+sBYaggRhgbx+HQm1vrIyTLlGw44r2pY3DNRjfV8B/ORmcwhNe2k0Bk7bZG1
 PT3/w2DkDI2SXXTvc9Q2LTfXQEhioh6K4F7U1e4mpAz/Gj7TectAa37h/UqawtxLpBK2AAae7Pr 50fKSbyV2FHRyrSQedC5ajrpnx91bj4OgfNO1XQB9psjQYPyz7+Ii52cvBkshqNrFmbfqusfLZ4 +pbf2ENgJ8/KpaUcrXma8rmCsUUrYsyG4l0hMnVkVejtQIALiHUJj71Xr+P2ZnIoz/JtTH1wfgX
 En9QZyMRF1XDnupe5thiZlA6qjCAkEKgT3zgQh3E6YTz7Q3F6OIoDaotXnNkguNUxNqYNX95
X-Proofpoint-ORIG-GUID: gM7t1P1LHarAYdW1Dka6K2AZYACk5u4G
X-Proofpoint-GUID: gM7t1P1LHarAYdW1Dka6K2AZYACk5u4G
X-Authority-Analysis: v=2.4 cv=IaaHWXqa c=1 sm=1 tr=0 ts=681a1685 cx=c_pps a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=9Z4Rn5OClx3nBGVvnmoA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-06_06,2025-05-05_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 bulkscore=0 malwarescore=0 lowpriorityscore=0 mlxscore=0 clxscore=1015
 suspectscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 mlxlogscore=620 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2505060131

On 2025-04-02 06:04, Herbert Xu wrote:
> On Tue, Apr 01, 2025 at 04:50:47PM +0200, Harald Freudenberger wrote:
>> 
>> +static int ecb_paes_do_crypt(struct s390_paes_ctx *ctx,
>> +			     struct s390_pecb_req_ctx *req_ctx,
>> +			     bool maysleep)
> 
> ...
> 
>> +	/* always walk on the ... */
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
> 
> So this leaves the skcipher walk in a mapped state, to be resumed in
> a work queue later.  Now I don't believe you guys have the horror of
> HIGHMEM so it's not fatal, but it's still a bit of a hack and worthy
> of a comment to at least stop people from other architectures copying
> this.
> 

v4 will have this clearly documented.

>> +			rc = paes_convert_key(ctx);
> 
> At first I thought this was racy, but then I realised that it is not
> because only the crypto_engine thread gets called with maysleep ==
> true.  Since there is only one crypto_engine thread this is safe.
> 
> I think this is not really obvious though and worthy of a comment to
> explain the reliance on the single crypto engine thread.
> 

This is racy but the code can handle that. The cpacf instruction
refuses to do any operations if the converted key material (the 
"protected" key)
is invalid. So it is in fact thinkable and possible to replace an fresh
protected key with an older (in the meantime invalid) protected key. As 
the
cpacf instruction detects this, refuses to operate with an invalid key 
and
the calling code triggers a (re-)conversion this does no harm. So it
is racy but may only lead to additional conversions but never to invalid
data on en- or decrypted.

> There is one more subtle issue to do with request ordering.  Because
> networking requires packets to not be reordered, we enforce this in
> the Crypto API.  An algorithm must not reorder the requests sent to
> the same tfm.
> 
> To do that here, once a ctx goes into the crypto_engine, all future
> requests to the same ctx must also go through the crypto_engine, as
> long as at the time of the request being submitted prior work is still
> outstanding.
> 
> The easiest way would be to have a counter in the ctx that keeps
> track of how many requests are currently outstanding in the engine.
> Then in paes_do_crypt you'd simply check the counter, and if it is
> non-zero you always put the request into the engine.
> 

I am struggling with that. The thing is how to keep this information.
I extended the request context with a bool field telling me that there
is/was a request pushed to the engine and thus all following crypto
operations on this request need to go via engine.
BUT ... the request context is not initial zeroized and there is no
init() for a request and thus one does not know on invocation of the
skcipher encrypt or decrypt function if the value of the bool field
is taken for serious or needs initialization. Same would happen if
there is a counter instead - how to initially set the counter value
to 0? Any hints on this are welcome.

> Cheers,
