Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E400A16E884
	for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2024 11:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718969519; cv=none; b=nK5hEf6NbAtnlOUSuteDSXYaOkUwFb6FUz9rTQCZCkuR+8qn8PAtDOF23+3Qj8HEgqrcUS5lRBZAdCMbDftGx9wS7jSXigs1prhHvEmBBjj/kMUZNu8C6lTAdnwRAhxZ7Bh0LgRqfdbdUb6gG9QxRTmmzR5T2+uwPsEoC+rCGjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718969519; c=relaxed/simple;
	bh=ems7BxqbRK0tBAX9Hd+6oaRigX02rKnnM3q6ewK8DUU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=scaYeu2zJ4oU2eYOx2xYURBkFW7FdxHv3X0ZRMiWRN9j+g6hoEuGSPtw42kLEdPJGva6wZUcDCs/ciGIR5j9tDq2+txf5zR8odH0JGn7/Ev6uFU8pyxolAyEhJfieERYPEpMCda5YwOs9byBU3IqrqootjBLnpxEwPcOv8froAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=swh5XgJA; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="swh5XgJA"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45LB34Rk015230;
	Fri, 21 Jun 2024 11:31:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=pp1; bh=3
	FDfT2cxjxoMxU8dIwKRgt4ueQ9jL6bJL2e19lFtT6A=; b=swh5XgJAyfFzeV9QD
	r2bWN6xvsHy98MPIeCMtrCWP5ImyZqMQ+2WdsiGF1bA/pBiLS4mWBKN8CFXild5g
	jF98GdeKqHokVxWq4YQs5/UtGd3mvokzZJ8Kp5+ia71rKD+BsZ05wkcgHUoQAVaM
	N9TSV4r2ii8VCvC1Tih3SMVIcXUwoNloToJ9jXsa0slo0R0NpPWexme5oPxeqB3l
	RA4uqtgE8+/k96mxcsu6y80sfyOMKD1ZhMVoaFb41yrlAz4VyyfQaiQHDjOC4eSo
	fK34Q+l3IqHka1fJCrMxsX2CySSac8ug85wpbtTv6amyytNLWKriYbXLuuiGD/NQ
	DS0Aw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yw6wtrank-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Jun 2024 11:31:53 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45L9Jwkb007675;
	Fri, 21 Jun 2024 11:31:52 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3yvrspeu4b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Jun 2024 11:31:52 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45LBVmri47645130
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Jun 2024 11:31:51 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D52E82004B;
	Fri, 21 Jun 2024 11:31:48 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9B30A20040;
	Fri, 21 Jun 2024 11:31:48 +0000 (GMT)
Received: from [9.171.27.206] (unknown [9.171.27.206])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 21 Jun 2024 11:31:48 +0000 (GMT)
Message-ID: <4b6820cd-82ee-410e-973f-29326f58ed8f@linux.ibm.com>
Date: Fri, 21 Jun 2024 13:31:48 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] hwrng: core - Fix wrong quality calculation at hw rng
 registration
To: Harald Freudenberger <freude@linux.ibm.com>, linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, Jason@zx2c4.com
References: <20240621095459.43622-1-freude@linux.ibm.com>
Content-Language: de-DE
From: Holger Dengler <dengler@linux.ibm.com>
In-Reply-To: <20240621095459.43622-1-freude@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gMpI5f1uiHKfAtaeXr547dcPui2DBfD0
X-Proofpoint-ORIG-GUID: gMpI5f1uiHKfAtaeXr547dcPui2DBfD0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-21_04,2024-06-21_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 clxscore=1011 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2406210084

On 21/06/2024 11:54, Harald Freudenberger wrote:
> When there are rng sources registering at the hwrng core via
> hwrng_register() a struct hwrng is delivered. There is a quality
> field in there which is used to decide which of the registered
> hw rng sources will be used by the hwrng core.
> 
> With commit 16bdbae39428 ("hwrng: core - treat default_quality as
> a maximum and default to 1024") there came in a new default of
> 1024 in case this field is empty and all the known hw rng sources
> at that time had been reworked to not fill this field and thus
> use the default of 1024.
> 
> The code choosing the 'better' hw rng source during registration
> of a new hw rng source has never been adapted to this and thus
> used 0 if the hw rng implementation does not fill the quality field.
> So when two rng sources register, one with 0 (meaning 1024) and
> the other one with 999, the 999 hw rng will be chosen.
> 
> This patch simple takes into account that a quality field value
> of 0 is to be treated as 1024 and then the decision about which
> hw rng to use works as expected.
> 
> Tested on s390 with two hardware rng sources: crypto cards and
> trng true random generator device driver.
> 
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
> 
> Reported-by: Christian Rund <Christian.Rund@de.ibm.com>
> Fixes: 16bdbae39428 ("hwrng: core - treat default_quality as a maximum and default to 1024")
> ---
>  drivers/char/hw_random/core.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> index 4084df65c9fa..993b8a1f1d19 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -525,6 +525,7 @@ static int hwrng_fillfn(void *unused)
>  
>  int hwrng_register(struct hwrng *rng)
>  {
> +	unsigned short rng_quality, cur_quality;

In my opinion, we no not need these variables.

>  	int err = -EINVAL;
>  	struct hwrng *tmp;
>  
> @@ -545,8 +546,14 @@ int hwrng_register(struct hwrng *rng)
>  	complete(&rng->cleanup_done);
>  	init_completion(&rng->dying);
>  
> +	/* Quality field not set in struct hwrng means 1024 */
> +	rng_quality = rng->quality ? rng->quality : 1024;

Please use the shortcut "(a) ?: (b)" for "(a) ? (a) : (b)", also remove non-necessary parenthesis.

	rng_quality = rng->quality ?: 1024;

Because this variable is only used once, you can also change it directly in the if statement below.

> +	cur_quality = current_rng ?
> +		(current_rng->quality ? current_rng->quality : 1024) :
> +		0;
> +

This one is not necessary. The quality field of current_rng is has been updated already by the hwrng_init() function. 

>  	if (!current_rng ||
> -	    (!cur_rng_set_by_user && rng->quality > current_rng->quality)) {
> +	    (!cur_rng_set_by_user && rng_quality > cur_quality)) {

Unfortunately, the quality field of rng is read here, before the quality field is updated by hwrng_init().
Maybe we can use the following:

  	if (!current_rng ||
	    (!cur_rng_set_by_user && (rng->quality ?: 1024) > current_rng->quality)) {

>  		/*
>  		 * Set new rng as current as the new rng source
>  		 * provides better entropy quality and was not

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler
--
IBM Systems, Linux on IBM Z Development
dengler@linux.ibm.com
