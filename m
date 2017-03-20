From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: Question - seeding the hw pseudo random number generator
Date: Mon, 20 Mar 2017 14:39:47 +0100
Message-ID: <1509135.hmo2UhaKWe@tauon.atsec.com>
References: <20170318092554.lggkhfg5eko23o3k@kozik-lap> <CANc+2y5gv2ygSM4HF69XCW7Bb8UUHN+qJKq0os-mOvYknH+SeQ@mail.gmail.com> <20170320132858.GA27044@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Matt Mackall <mpm@selenic.com>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jan Glauber <jan.glauber@de.ibm.com>,
        Harald Freudenberger <freude@de.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58150 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753124AbdCTNj6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Mar 2017 09:39:58 -0400
In-Reply-To: <20170320132858.GA27044@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 20. März 2017, 14:28:58 CET schrieb Herbert Xu:

Hi Herbert,

> On Mon, Mar 20, 2017 at 12:19:32PM +0530, PrasannaKumar Muralidharan wrote:
> > AF_ALG interface for rng does have seeding support. I think hw_random
> > does not provide seeding support intentionally as I understand that
> > True RNG need not require seeding (please correct me if I am wrong).
> 
> Yes.  We should be converting PRNGs in hwrng over to algif_rng.

IMHO this not only applies to the PRNGs in drivers/crypto (which should simply 
register with crypto_register_rngs) but also to ~/hacking/sources/linux/arch/
s390/crypto/prng.c which exports a /dev/prandom file.

For the seeding, it may make sense to follow the example given with crypto/
drbg.c using the add_random_ready_callback function.

Ciao
Stephan
