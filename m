From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: Trouble with non modular ciphers
Date: Thu, 31 Jan 2008 13:48:34 +0100
Message-ID: <20080131124834.GA21310@Chamillionaire.breakpoint.cc>
References: <200801311021.24240.ak@suse.de>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Andi Kleen <ak@suse.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:52636 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764090AbYAaMsi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 31 Jan 2008 07:48:38 -0500
Content-Disposition: inline
In-Reply-To: <200801311021.24240.ak@suse.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Andi Kleen | 2008-01-31 10:21:24 [+0100]:

>FYI -- with a linus git kernel of yesterday or so I ran into a problem where 
>one cipher module (CBC) was compiled in and the rest modular. dm_crypt 
>could not resolve the cipher module until I turned it into a module.
and dm_crypt itself was a module?

>I don't remember if cryptomanager was modular or not.
>From what I see, if CBC is in kernel than cryptomanager is also compiled
in.

>Also I found that cryptomanager is quite unhappy when CONFIG_KMOD
>is not defined. Perhaps it should Kconfig select it?
If you disable modules, than why should one module enable it?

>-Andi

Sebastian
