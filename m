From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: Question - seeding the hw pseudo random number generator
Date: Thu, 23 Mar 2017 12:44:57 +0100
Message-ID: <6726036.ieol9yEJdI@positron.chronox.de>
References: <20170318092554.lggkhfg5eko23o3k@kozik-lap> <20170323082307.GB16625@Red> <20170323094406.GA6848@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Matt Mackall <mpm@selenic.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58252 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932855AbdCWLpN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Mar 2017 07:45:13 -0400
In-Reply-To: <20170323094406.GA6848@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 23. März 2017, 10:44:06 CET schrieb Herbert Xu:

Hi Herbert,

> On Thu, Mar 23, 2017 at 09:23:07AM +0100, Corentin Labbe wrote:
> > Problem with this conversion, a huge regression for user space.
> > Using hwrng is simple as cat /dev/hwrng.
> > Using algif_rng via AF_ALG is ... unusable for the moment.
> > Perhaps creating an user space tool (prng-tool which provide a cat
> > /dev/hwrng replacement) is mandatory before any convertion.
> Stephan may have a tool to do this.  Stephan?

Creating such tool is more or less trivial. It simply requires the invocation 
of kcapi_rng_init, kcapi_rng_seed, kcapi_rng_generate and eventually 
kcapi_rng_destroy from [1]. I can write such a tool if requested.

I see one change we need to add to algif_rng.c: currently the caller must 
provide the specific name of the DRNG to be used. With such a tool, the caller 
does not care about the type of DRNG. Thus, rng_bind should be changed such 
that if name is NULL, it should use crypto_get_default_rng(). This would 
alleviate the caller from selecting "the right" DRNG.

[1] http://www.chronox.de/libkcapi.html

Ciao
Stephan
