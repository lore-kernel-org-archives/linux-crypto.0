From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] per-CPU cryptd thread implementation based on workqueue
Date: Thu, 22 Jan 2009 14:04:00 +1100
Message-ID: <20090122030400.GA10229@gondor.apana.org.au>
References: <1232075437.13948.12.camel@yhuang-dev.sh.intel.com> <20090116033105.GB10390@gondor.apana.org.au> <1232591537.6101.3.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757280AbZAVDEU@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1232591537.6101.3.camel@yhuang-dev.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jan 22, 2009 at 10:32:17AM +0800, Huang Ying wrote:
>
> This is the first attempt to use a dedicate workqueue for crypto. It is
> not intended to be merged. Please feedback your comments, especially on
> desgin.

Thanks for the patch!

> +		spin_lock_init(&cpu_queue->lock);

Since we're switching to per-cpu queues it would be good to just
kill the spin lock.  AFAICS the only place you really need it is
in cryptd_tfm_in_queue.  That's just used for debugging so we can
just kill it and lose this spin lock.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
