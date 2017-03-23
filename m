From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: Question - seeding the hw pseudo random number generator
Date: Thu, 23 Mar 2017 12:35:56 +0100
Message-ID: <32410262.FWdrND2fdY@positron.chronox.de>
References: <20170318092554.lggkhfg5eko23o3k@kozik-lap> <1509135.hmo2UhaKWe@tauon.atsec.com> <602a68ef-c57a-0092-ebe0-161ec602fad6@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Matt Mackall <mpm@selenic.com>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jan Glauber <jan.glauber@de.ibm.com>,
        Harald Freudenberger <freude@de.ibm.com>
To: Harald Freudenberger <freude@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58234 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753427AbdCWLgB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Mar 2017 07:36:01 -0400
In-Reply-To: <602a68ef-c57a-0092-ebe0-161ec602fad6@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 23. März 2017, 09:03:23 CET schrieb Harald Freudenberger:

Hi Harald,

> I'll have a look on it. Currently the s390/crypto/prng seeds itself with
> an algorithm based on the jitter of the very fine granular hardware
> clock of a s390 machine. There were some thoughts and measurements
> by an mathematician which let to this algorithm.

It takes a page and simply writes 512 times the high-res time stamp using 
get_tod_clock_fast into it. Effectively it uses the same fundamental noise 
source as the jitterentropy. (A couple of months ago I had to perform an 
SP800-90B assessment on exactly that code path. :-) )

> However, long-term
> the s390 platform will provide some kind of true hardware random number
> generator and the idea is to use this for seeding the prng.

The question is just that it provides a device file nobody else provides. And 
the question is whether to consolidate it. If it is a DRNG, the discussion is 
about consolidating it behind AF_ALG. If it is an RNG with its own noise 
source (i.e. it provides entropic data by itself), it should rather be placed 
into drivers/char/hw_random and use the hw-random framework. This framework 
will also ensure that it may seed the /dev/random device kernel-internally.

Ciao
Stephan
