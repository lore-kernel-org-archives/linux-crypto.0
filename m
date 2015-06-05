From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v6 1/5] random: Blocking API for accessing nonblocking_pool
Date: Fri, 05 Jun 2015 11:50:05 +0200
Message-ID: <1484426.MOdRD4dreK@tachyon.chronox.de>
References: <1921857.OvxEu6y28S@tachyon.chronox.de> <20150519141805.GA32663@gondor.apana.org.au> <20150605052805.GA2298@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Theodore Ts'o <tytso@mit.edu>, pebolle@tiscali.nl,
	andreas.steffen@strongswan.org, sandyinchina@gmail.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150605052805.GA2298@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Freitag, 5. Juni 2015, 13:28:06 schrieb Herbert Xu:

Hi Herbert,
> 
> Steffen, I think we need to revisit the idea of having a list
> of callbacks.

Ok, I will reactivate my patch with the list.
> 
> Cheers,


-- 
Ciao
Stephan
