From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v3 4/6] crypto: drbg - add async seeding operation
Date: Fri, 01 May 2015 06:15:58 +0200
Message-ID: <1920079.qHlzZPHHdY@tauon>
References: <11175802.HG0pHJfshY@myon.chronox.de> <26987163.Lvcqt6Smju@myon.chronox.de> <20150501031331.GA32741@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: pebolle@tiscali.nl, andreas.steffen@strongswan.org, tytso@mit.edu,
	sandyinchina@gmail.com, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34628 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbbEAHEZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 1 May 2015 03:04:25 -0400
In-Reply-To: <20150501031331.GA32741@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 1. Mai 2015, 11:13:31 schrieb Herbert Xu:

Hi Herbert,

>On Tue, Apr 28, 2015 at 05:00:03AM +0200, Stephan Mueller wrote:
>> @@ -1081,6 +1115,11 @@ static int drbg_seed(struct drbg_state *drbg, struct
>> drbg_string *pers,> 
>>  		return -EINVAL;
>>  	
>>  	}
>> 
>> +	/* cancel any previously invoked seeding */
>> +	mutex_unlock(&drbg->drbg_mutex);
>> +	drbg_async_work_cancel(&drbg->seed_work);
>> +	mutex_lock(&drbg->drbg_mutex);
>
>This seems dangerous and unnecessary.  Releasing and reacquiring
>the locks may invalidate previous checks.  Even if it doesn't
>matter today if somebody modifies the callers later on this could
>explode.

Agreed.
>
>You can easily remove this by making get_blocking_random_bytes_cb
>idempotent, i.e., do nothing if the work is already queued, which
>is what it would do anyway if you simply move the INIT_WORK out of
>it.

As the get_blocking_random_bytes_cb fully sets up the random_work data 
structure, I think INIT_WORK should be left in there to have a nice and easy 
API. Otherwise either a new call would need to be added to random.c. The 
caller is not able to invoke INIT_WORK himself as the worker function is 
static.

However, what about simply checking if rw->work is NULL and only then 
performing the INIT_WORK? In that case then, I guess that all the members of 
random_walk in get_blocking_random_bytes_cb should only be filled in if 
INIT_WORK is to be called as otherwise a race may occur: 
get_blocking_random_bytes_work already performs its operation on the data in 
the supplied random_work and in the middle of that work, and then we would 
change it with a new call to get_blocking_random_bytes_cb.

Ciao
Stephan
