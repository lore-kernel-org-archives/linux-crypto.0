From: Andi Kleen <ak@suse.de>
Subject: Re: Trouble with non modular ciphers
Date: Thu, 31 Jan 2008 13:49:54 +0100
Message-ID: <200801311349.54179.ak@suse.de>
References: <200801311021.24240.ak@suse.de> <20080131124834.GA21310@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:33718 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761300AbYAaMt6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 31 Jan 2008 07:49:58 -0500
In-Reply-To: <20080131124834.GA21310@Chamillionaire.breakpoint.cc>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thursday 31 January 2008 13:48:34 Sebastian Siewior wrote:
> * Andi Kleen | 2008-01-31 10:21:24 [+0100]:
> 
> >FYI -- with a linus git kernel of yesterday or so I ran into a problem where 
> >one cipher module (CBC) was compiled in and the rest modular. dm_crypt 
> >could not resolve the cipher module until I turned it into a module.
> and dm_crypt itself was a module?

I don't remember to be honest. Is it important?

> >Also I found that cryptomanager is quite unhappy when CONFIG_KMOD
> >is not defined. Perhaps it should Kconfig select it?
> If you disable modules, than why should one module enable it?

CONFIG_KMOD is not modules (that is CONFIG_MODULES), but module
autoloading.

-Andi
