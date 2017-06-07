From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: Re: [PATCH v3 04/13] crypto/rng: ensure that
 the RNG is ready before using
Date: Wed, 7 Jun 2017 11:42:28 -0300
Message-ID: <20170607144228.GB5705@khazad-dum.debian.net>
References: <20170606005108.5646-1-Jason@zx2c4.com>
 <20170606170319.5eva2yoxxeru5p74@thunk.org>
 <20170606221910.GB9057@khazad-dum.debian.net>
 <1691714.1h4IbvMDSf@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Theodore Ts'o <tytso@mit.edu>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers3@gmail.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-hardening@lists.openwall.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	David Miller <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <kernel-hardening-return-8409-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
Content-Disposition: inline
In-Reply-To: <1691714.1h4IbvMDSf@tauon.chronox.de>
List-Id: linux-crypto.vger.kernel.org

On Wed, 07 Jun 2017, Stephan Müller wrote:
> Am Mittwoch, 7. Juni 2017, 00:19:10 CEST schrieb Henrique de Moraes Holschuh:
> > On that same idea, one could add an early_initramfs handler for entropy
> > data.
> 
> Any data that comes from outside during the boot process, be it some NVRAM 
> location, the /var/lib...seed file for /dev/random or other approaches are 
> viewed by a number of folks to have zero bits of entropy.
> 
> I.e. this data is nice for stirring the pool, but is not considered to help 
> our entropy problem.

Stirring the pool is actually the objective, not entropy accounting.
Let's not lose sight of what is really important.

But yes, you are quite correct in that it won't help anything that would
like to block due to entropy accouting, or which needs to be certain
about the amount of randomness in the pools.

-- 
  Henrique Holschuh
