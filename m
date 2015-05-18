From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v6 1/5] random: Blocking API for accessing nonblocking_pool
Date: Mon, 18 May 2015 15:07:10 +0200
Message-ID: <7743005.ngVOaoViLi@tauon>
References: <1921857.OvxEu6y28S@tachyon.chronox.de> <3672239.xqA2RrDaZY@tachyon.chronox.de> <20150518092131.GA18659@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: pebolle@tiscali.nl, andreas.steffen@strongswan.org, tytso@mit.edu,
	sandyinchina@gmail.com, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150518092131.GA18659@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Montag, 18. Mai 2015, 17:21:31 schrieb Herbert Xu:

Hi Herbert,

>> +/*
>> + * Equivalent function to get_random_bytes with the difference that this
>> + * function blocks the request until the nonblocking_pool is initialized.
>> + */
>> +int get_blocking_random_bytes_cb(void *buf, int nbytes, void *private,
>> +				 void (*cb)(void *buf, int buflen,
>> +					    void *private))
>
>You can simplify this further and get rid of buf/nbytes.  All
>we need to know is whether the pool is ready.  Everything else
>can come from private.
>
So, the async function is now just a notification of the caller. Sounds good 
with me.

>> +	struct random_work *rw = NULL;
>> +	int ret = 0;
>
>I think this function should return 0 if the pool is ready now,
>-EINPROGRESS if it's not (indicating that the callback will be
>called when it is ready) and otherwise an error.

Ok, will come in the next patch.

Ciao
Stephan
