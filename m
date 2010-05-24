From: Alexander Shishkin <virtuoso@slind.org>
Subject: Re: [RFC][PATCH] crypto: disable tests when they are not enabled
Date: Mon, 24 May 2010 15:20:50 +0300
Message-ID: <20100524122050.GB27432@shisha.kicks-ass.net>
References: <1274693724-23831-1-git-send-email-virtuoso@slind.org>
 <20100524112726.GB29848@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100524112726.GB29848@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, May 24, 2010 at 09:27:26 +1000, Herbert Xu wrote:
> On Mon, May 24, 2010 at 12:35:24PM +0300, Alexander Shishkin wrote:
> > Don't compile in and don't schedule cryptomanager's tests when
> > CONFIG_CRYPTO_TESTS is not set. This saves quite some time during
> > kernel initialization.
> 
> You're disabling the self-testing infrastructure.  This is not
> the same thing as the tcrypt module.

It is my intention to disable these tests since in my running them at
every boot doesn't add any value. I thought about adding a separate
Kconfig option for that, too. I want to make sure it's a sensible thing
to do.

> Is this for fast booting?

Yes, it saves ~180 miliseconds for me at prng_mod_init(), for example.

Regards,
--
Alex
