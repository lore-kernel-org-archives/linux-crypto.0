From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: testmgr: add test vectors for skein
Date: Wed, 20 Jun 2018 20:26:34 +0200
Message-ID: <1602937.V4TYxMrJ9m@tauon.chronox.de>
References: <20180620105714.18359-1-j.m.torrespalma@gmail.com> <20180620175638.GB76265@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Juan Manuel Torres Palma <j.m.torrespalma@gmail.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.apana.org.au
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180620175638.GB76265@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Mittwoch, 20. Juni 2018, 19:56:38 CEST schrieb Eric Biggers:

Hi Eric,

> > +		.alg = "skein1024",
> > +		.test = alg_test_hash,
> > +		.fips_allowed = 1,
> 
> Are you sure Skein should be on the "FIPS allowed" list?  I'm not
> particularly familiar with FIPS, but my understanding is that the
> fips_allowed flag is only supposed to be set on specific "approved"
> algorithms.  So if you're unsure, it shouldn't be set.

Skein is definitely not allowed in FIPS mode. Please drop that flag.
> 
> Eric



Ciao
Stephan
