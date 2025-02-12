Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70871B21AD;
	Wed, 12 Feb 2025 11:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739359074; cv=none; b=AkyA8AmUgHGCI6tnzIZhCtpwp9KqVf6rBcxcjFXWn6ocF3IN04kqEZA0u5spoLMcseBMSyEmudSYVDgGvRiKIgCbiq9tV/AxDPk8QIygZhKiSXQgb4rohTazrmB7rx61b7Q7WE8k1z4BLNmCqfmwNQfk1KCq/TLGnFlyi5I86cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739359074; c=relaxed/simple;
	bh=Ct+Y3V6sGCImxKdsVOVD9E79C31dRTDro58JbyTCRbM=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=E1dNsMb3XqL2W8m9E1ex7oD7OQEjI+6RujY9LHTyrph+ljfBtwANVKXHkfCTGTOxpajRgTRTP8UNDYMiN7USgoc2asm5+WcScXVqgkLGJmTHAKw+b81XBGOQleVllF4isuiscl5UKU8sEoNwnRY84lHV+dHQHEr9qmSds/yBe5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=UHkxE9S/; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UHkxE9S/"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51CAw8mb012394;
	Wed, 12 Feb 2025 11:17:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=mH/Qz7qyhZHfxaXOnJINOl8KCVBi5QHP23TdWsWlsTA=; b=UHkxE9S/MvPP
	rWFSo9Yfw87LYUUJ4hfxV1PB6fRugMVyi8ku1ZOpngFbsokzESLaLbP6nYokhcKX
	ksmeTAuHXqMxRbZtqAKfq8kndTblCb0EDyD9vMrgi6W4lr/72H5XAoZ1P4i3FkyD
	Y0LqmMt9akV73p9bCNZ7cjYRW9rsr798rcEKHP5WsUBzTINjOuMDIL1piQ7yAiBJ
	ze58O6B4LXgTMgL4KyqlCJrOBR72t9sjzmu+NldyE87Sospj+sKKKqx1hX78g+N0
	XdGG7I51xZ/Lj1+Buab1xqyfPV6j2LLJKPTpj647FzOgsW5gUuX3sjZ5o84/LdCj
	jEKaM5O4Pg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44rfpa2w7f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Feb 2025 11:17:47 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51CAp2oB011677;
	Wed, 12 Feb 2025 11:17:47 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 44pktjyyx1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Feb 2025 11:17:46 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51CBHkHw29164126
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Feb 2025 11:17:46 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8823158056;
	Wed, 12 Feb 2025 11:17:46 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3E2B75805A;
	Wed, 12 Feb 2025 11:17:46 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 12 Feb 2025 11:17:46 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 12 Feb 2025 12:17:46 +0100
From: Harald Freudenberger <freude@linux.ibm.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
        dengler@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v10 2/5] s390/crypto: New s390 specific protected key hash
 phmac
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <20250209163430.GB1230@sol.localdomain>
References: <20250115162231.83516-1-freude@linux.ibm.com>
 <20250115162231.83516-3-freude@linux.ibm.com>
 <Z6hrvQzb5G_wqlni@gondor.apana.org.au>
 <20250209163430.GB1230@sol.localdomain>
Message-ID: <9971160da17b1d18d4bdc87fc1297fda@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wSQcxiz3E78mNy8hR7ZZ9jcdDc_zPPRo
X-Proofpoint-ORIG-GUID: wSQcxiz3E78mNy8hR7ZZ9jcdDc_zPPRo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-12_03,2025-02-11_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 mlxscore=0 lowpriorityscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 mlxlogscore=873 clxscore=1015 phishscore=0 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2501170000
 definitions=main-2502120085

On 2025-02-09 17:34, Eric Biggers wrote:
> On Sun, Feb 09, 2025 at 04:47:57PM +0800, Herbert Xu wrote:
>> On Wed, Jan 15, 2025 at 05:22:28PM +0100, Harald Freudenberger wrote:
>> >
>> > +static int s390_phmac_init(struct ahash_request *req)
>> > +{
>> > +	struct s390_phmac_req_ctx *req_ctx = ahash_request_ctx(req);
>> > +	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
>> > +	struct s390_kmac_sha2_ctx *ctx = &req_ctx->sha2_ctx;
>> > +	int rc;
>> > +
>> > +	/*
>> > +	 * First try synchronous. If this fails for any reason
>> > +	 * schedule this request asynchronous via workqueue.
>> > +	 */
>> > +
>> > +	rc = phmac_init(tfm, ctx, false);
>> > +	if (!rc)
>> > +		goto out;
>> > +
>> > +	req_ctx->req = req;
>> > +	INIT_DELAYED_WORK(&req_ctx->work, phmac_wq_init_fn);
>> > +	schedule_delayed_work(&req_ctx->work, 0);
>> > +	rc = -EINPROGRESS;
>> 
>> This creates a resource problem because there is no limit on how
>> many requests that can be delayed in this manner for a given tfm.
>> 
>> When we hit this case, I presume this is a system-wide issue and
>> all requests would go pending? If that is the case, I suggest
>> allocating a system-wide queue through crypto_engine and using
>> that to limit how many requests that can become EINPROGRESS.
> 
> Or just make it synchronous which would be way easier, and the calling 
> code uses
> it synchronously anyway.
> 
> - Eric

A word about synchronous vs asynchronous...

As a synchronous hash (or chipher or whatever) MUST NOT sleep I can't
really implement the pkey stuff in a synchronous way:

The issue with pkey (We call it "protected key") is that it is some kind
of hardware based key. As such it needs some special preparation action
to be done upfront in the hardware/firmware to use such a pkey.
Now think about KVM live guest migration where a guest suddenly awakes
(Well the guest is not even aware of this) on a new machine with another
hardware. So out of the sudden a hardware based crypto operation fails
with an indication that the hardware/firmware can't deal with this
key object and needs re-preparation. Usually this preparation step is
some kind of asynchronous operation (write some pci registers or run
some DMA sequences or refresh the working key material via an HSM
communication...) and as such may take some time and involve even
sleeping on a mutex or completion until another kernel thread is done.
Please note this is not unique to pkey on system z but may apply
to all kinds of hardware/firmware based keys in situations like
KVM live guest migration or suspend/resume.

So for the pkey algorithms I can't guarantee that all the crypto
operations do never sleep and thus an asynchronous implementation
is the only way and makes sense to me.

There are other downsides with the asynch implementations:
They are much more complex and thus expensive and - how the hell can a
test cover all the code branches?
Next is the thing with the CRYPTO_ALG_ALLOCATES_MEMORY flag. If I
want to have a hash implementation usable for dm-integrity the alg
implementation must NOT set this flag and must not allocate any memory
during crypto operations (includung setkey()). As of now I am still not
through with the phmac code for this. And I only have a faint idea on
how to implement this on the pkey and maybe zcrypt code...

kind regards
Harald Freudenberger

