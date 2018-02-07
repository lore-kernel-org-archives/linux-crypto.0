From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v2 2/4] crypto: AF_ALG - inline IV support
Date: Wed, 07 Feb 2018 15:01:16 +0100
Message-ID: <2143323.ez0I2IImEf@positron.chronox.de>
References: <2118226.LQArbCsRu5@tauon.chronox.de> <1783794.5OL5zxrSA7@positron.chronox.de> <20180207135408.00000119@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Harsh Jain <harsh@chelsio.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linuxarm@huawei.com
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59402 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753884AbeBGOBS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Feb 2018 09:01:18 -0500
In-Reply-To: <20180207135408.00000119@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 7. Februar 2018, 14:54:08 CET schrieb Jonathan Cameron:

Hi Jonathan,

> 
> It's not a 'bug' as such, but this does currently break the crypto-perf
> test for aio and iiv in the libkcapi branch.  We can perhaps make it
> more forgiving...

I just pushed an update for the IIV branch of libkcapi that handles it 
appropriately.
> 
> I suggest we let noop cases where we set IIV on when it is already on
> to not result in an error but to just be ignored.

I do not like the kernel to behave differently on one and the same flag. 
Though, the check could be more forgiving indeed: if the flag from user space 
is set again and identical to what we already have, we would not report an 
error. Only if it is different from what was already set, we report the error.

> > 
> > +
> > +		/*
> > +		 * IIV can only be enabled once with the first sendmsg call.
> > +		 * This prevents a race in locking and unlocking the
> > +		 * ctx->ivlock mutex.
> > +		 */
> > +		if (ctx->iiv == ALG_IIV_UNSET) {
> > +			ctx->iiv = iiv;
> > +		} else if (iiv == ALG_IIV_USE) {
> 
> So the issue in kcapi is that we are running a tight loop around a test case
> that does a certain number of aio messages.  At the start of each run of
> that performance loop we reinitialize.
> 
> There is an optmisation in there though which avoids an accept call (which
> would have given a new context) if we have one available already.
> 
> The result is that we are reusing the context which already has this
> set.
> 
> So, can we be a little less restrictive and let things through
> if and only iff iiv = ctx->iiv - i.e. the set is a noop?

Precisely, will do in the next version of the patch set.

Ciao
Stephan
