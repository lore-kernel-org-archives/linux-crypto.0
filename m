Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7341D13C807;
	Tue, 12 Nov 2024 12:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731415865; cv=none; b=BNcAflZxv25lCck5pQTVoBiyjyZ1EurEkTpcfvYLiPTh4tls5Fj5mRBhucp+PrfXcfN9QZinS7qrk0mP6LQCfrWnDC2beKMIKDKzfRUxmTV9aj/phjrDmyJ5fynUETHNEdKHQUf5G0Jsh0JU7w3rcyV0+ctS9vs+SA+3gobkeEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731415865; c=relaxed/simple;
	bh=s+J+ZtAVFGBPp4PYl4uJJaaKEFIdZP7IoOXR2ZJoNYQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID:
	 Content-Type:MIME-Version; b=MvXpofJWEN4PjWh/MpS5bDoV55d6QyuWuPDsy4h6BjbiBbXTLMDj7GywF0PA3PLdQpZd73sWOS5im4QQoxYBbB+wpSqm3HLvVf7ecPkJuA4zFeZVzvD68IQSrXdqyTTgRkaPvqlS/w/1xZiY+x2OyE81x3Z+q0+x4WMBhwd078g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nuwCKTVQ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nuwCKTVQ"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACAe6ug032046;
	Tue, 12 Nov 2024 12:45:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=fAEOBTv6uWdbEuTKSlml6oqMaKfq8Cv/uRQx1ATbYjU=; b=nuwCKTVQ4op2
	6tiXLpb0bvWx6/HfmJHMwt+q/uVRwiROPfHGwvZhytGOQHZGJEnO0bnYOD//LjaO
	a+E75K0MH0PsjIvme7b/XcRY7nGZuDTcicStwEg7yy4F8JmrjEKYbIlBe3c7Qtft
	ezLwUehk3oPIw609+aPxeRC2hB+I3gZWZUNJRkFWQiuY5/ZTQug/gJwU10aI4hsy
	gScVX8XSdNWO9oqVI4h/IXwzBUSC+j3OiRduCCMLlc5Be5e93bHt8Xd/EC69TTtD
	+YZGqniPIcKhh4SwgomG+i2Bvy8oeWyqX4Xqzrs12LsniqFI0Igw6/Sqbxjnhmsb
	5XQW/Nl/Vw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42v5fc0fny-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Nov 2024 12:45:56 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACCPCFH029689;
	Tue, 12 Nov 2024 12:45:55 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42tkjkruuk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Nov 2024 12:45:55 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4ACCjr0014156428
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 12:45:54 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9954458051;
	Tue, 12 Nov 2024 12:45:53 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4E96D5805A;
	Tue, 12 Nov 2024 12:45:53 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 12 Nov 2024 12:45:53 +0000 (GMT)
Date: Tue, 12 Nov 2024 13:45:53 +0100
From: Harald Freudenberger <freude@linux.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: dengler@linux.ibm.com, davem@davemloft.net, hca@linux.ibm.com,
        linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3 3/3] s390/crypto: New s390 specific shash phmac
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <ZzKxrKpSFCdz8LPp@gondor.apana.org.au>
References: <20241107145521.424769-1-freude@linux.ibm.com>
 <20241107145521.424769-4-freude@linux.ibm.com>
 <ZzKxrKpSFCdz8LPp@gondor.apana.org.au>
Message-ID: <619dd7a11549a1b33827c5a8a680c371@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ArM6VkHj64aQ1IAryn210tD_ujJPnyfs
X-Proofpoint-ORIG-GUID: ArM6VkHj64aQ1IAryn210tD_ujJPnyfs
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 bulkscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 spamscore=0
 suspectscore=0 phishscore=0 mlxscore=0 malwarescore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411120102

On 2024-11-12 02:38, Herbert Xu wrote:
> On Thu, Nov 07, 2024 at 03:55:21PM +0100, Harald Freudenberger wrote:
>> 
>> +static int s390_phmac_sha2_init(struct shash_desc *desc)
>> +{
>> +	struct s390_phmac_ctx *tfm_ctx = crypto_shash_ctx(desc->tfm);
>> +	struct s390_kmac_sha2_ctx *ctx = shash_desc_ctx(desc);
>> +	unsigned int bs = crypto_shash_blocksize(desc->tfm);
>> +	int rc;
>> +
>> +	rc = phmac_convert_key(desc->tfm);
>> +	if (rc)
>> +		goto out;
>> +
>> +	spin_lock_bh(&tfm_ctx->pk_lock);
>> +	memcpy(ctx->param + SHA2_KEY_OFFSET(bs),
>> +	       tfm_ctx->pk.protkey, tfm_ctx->pk.len);
>> +	spin_unlock_bh(&tfm_ctx->pk_lock);
> 
> This appers to be completely broken.  Each tfm can be used by
> an unlimited number of descriptors in parallel.  So you cannot
> modify the tfm context.  I see that you have taken spinlocks
> around it, but it is still broken:
> 
> CPU1			CPU2
> lock(tfm)
> tfm->pk = pk1
> unlock(tfm)
> 			lock(tfm)
> 			tfm->pk = pk2
> 			unlock(tfm)
> lock(tfm)
> copy tfm->pk to desc
> 	pk2 is copied
> unlock(tfm)
> 
> Now this could all be harmless because pk1 and pk2 may be guaranteed
> to be the same, but if that's the case why go through all this in
> the first place? You could've just done it in setkey.
> 
> Cheers,

Well, we had a similar discussion once with paes (See
https://lore.kernel.org/linux-crypto/20191113105523.8007-1-freude@linux.ibm.com/)

The tfm holds the pkey which is a hardware wrapped version of the key 
value.
It is generated by a special invocation done via the PKEY kernel 
module(s) which
knows how to unpack the raw key material and re-wrap it so it can be 
used
with the CPACF instructions. The hardware wrapping key may change - in 
fact
it chances for example with a KVM guest relocated to another system and 
then
this unpack/rewrap cycle needs to be triggered again and thus the pkey 
may
change but the underlying "effective" or "real" key stays the same.
In that sense the tfm holding the pkey value is updated. To make the 
update
of the pkey atomic the spinlock is used as the tfm may be used by 
multiple
hash contexts.

Why not convert in the setkey() function? As of now this could be an 
option
as the invocation of convert_key() in the end within the PKEY pkey_pckmo
kernel module only calls PCKMO to generate the wrapped pkey. However, 
long
term we will have another path using a crypto card for this action and
then we are clearly in a sleeping context which must not be used from
setkey(). So make it correct now means to delay the conversion from 
setkey()
to later: the init of the hash context is the next chance to do this.

I see that calling the conversion each time a shash_init() is called
is total overkill and an avoidable action as the dm-integrity layer 
calls
this per sector. This may even get worse if we intent to go a hardware
path down to convert the key. So I am thinking of a better way which
avoids this overhead ... patch is under construction ...

Regards
Harald Freudenberger
