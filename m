From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH -next] crypto: api: Do not access module name directly
 from module structure
Date: Fri, 24 Apr 2015 16:27:52 -0700
Message-ID: <20150424232752.GA6732@roeck-us.net>
References: <1429891083-525-1-git-send-email-linux@roeck-us.net>
 <20150424223803.GB3690@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Rusty Russell <rusty@rustcorp.com.au>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bh-25.webhostbox.net ([208.91.199.152]:37707 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbbDYJuz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 25 Apr 2015 05:50:55 -0400
Received: from mailnull by bh-25.webhostbox.net with sa-checked (Exim 4.85)
	(envelope-from <linux@roeck-us.net>)
	id 1Yln0m-001JzU-JC
	for linux-crypto@vger.kernel.org; Fri, 24 Apr 2015 23:27:56 +0000
Content-Disposition: inline
In-Reply-To: <20150424223803.GB3690@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Apr 25, 2015 at 06:38:03AM +0800, Herbert Xu wrote:
> On Fri, Apr 24, 2015 at 08:58:03AM -0700, Guenter Roeck wrote:
> > 'struct module' is only fully declared if CONFIG_MODULES is configured.
> > If not, the build fails with
> > 
> > crypto/algapi.c: In function 'crypto_check_module_sig':
> > crypto/algapi.c:49:12: error: dereferencing pointer to incomplete type
> > 
> > Fixes: 59afdc7b3214 ("crypto: api - Move module sig ifdef into accessor
> > 	function")
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: Rusty Russell <rusty@rustcorp.com.au>
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > ---
> > Seen in next-20150424.
> 
> Thanks but a similar patch has already been queued.

Excellent.

Thanks,
Guenter
