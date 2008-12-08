From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: [PATCH 1/2 v4] crypto: sha512 - Move message schedule W[80] to static percpu area
Date: Mon, 8 Dec 2008 03:33:28 +0300
Message-ID: <20081208003328.GA15386@ioremap.net>
References: <20081207113302.GB13736@gondor.apana.org.au> <1228688249887-git-send-email-ken@codelabs.ch> <12286882501412-git-send-email-ken@codelabs.ch> <20081208000919.GA14357@ioremap.net> <20081208002435.GA17916@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Adrian-Ken Rueegsegger <ken@codelabs.ch>,
	linux-crypto@vger.kernel.org, steffen.klassert@secunet.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from corega.com.ru ([195.178.208.66]:39744 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbYLHAd3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2008 19:33:29 -0500
Content-Disposition: inline
In-Reply-To: <20081208002435.GA17916@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 08, 2008 at 08:24:35AM +0800, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> > > +	u64 *W = get_cpu_var(msg_schedule);
> > 
> > This should be protected by preempt_disable(), shouldn't it?
> 
> get_cpu_var does it implicitly.

Yeah, that simple!

-- 
	Evgeniy Polyakov
