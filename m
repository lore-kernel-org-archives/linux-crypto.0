From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [kernel-hardening] Re: [PATCH v3 04/13] crypto/rng: ensure that the RNG is ready before using
Date: Wed, 07 Jun 2017 07:00:17 +0200
Message-ID: <1691714.1h4IbvMDSf@tauon.chronox.de>
References: <20170606005108.5646-1-Jason@zx2c4.com> <20170606170319.5eva2yoxxeru5p74@thunk.org> <20170606221910.GB9057@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Theodore Ts'o <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Eric Biggers <ebiggers3@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-hardening@lists.openwall.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170606221910.GB9057@khazad-dum.debian.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Mittwoch, 7. Juni 2017, 00:19:10 CEST schrieb Henrique de Moraes Holschuh:

Hi Henrique,

> On that same idea, one could add an early_initramfs handler for entropy
> data.

Any data that comes from outside during the boot process, be it some NVRAM 
location, the /var/lib...seed file for /dev/random or other approaches are 
viewed by a number of folks to have zero bits of entropy.

I.e. this data is nice for stirring the pool, but is not considered to help 
our entropy problem.

Ciao
Stephan
