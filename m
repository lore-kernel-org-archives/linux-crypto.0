From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH] [CRYPTO] rmd128: Fix endian problems
Date: Mon, 19 May 2008 22:59:44 +0200
Message-ID: <20080519205944.GC16813@Chamillionaire.breakpoint.cc>
References: <20080517081003.GA19540@Chamillionaire.breakpoint.cc> <12111465553916-git-send-email-rueegsegger@swiss-it.ch> <20080519200145.GB16813@Chamillionaire.breakpoint.cc> <4831E50B.4060101@swiss-it.ch>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Adrian-Ken R?egsegger <rueegsegger@swiss-it.ch>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:47616 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759735AbYESU7q (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 May 2008 16:59:46 -0400
Content-Disposition: inline
In-Reply-To: <4831E50B.4060101@swiss-it.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Adrian-Ken R?egsegger | 2008-05-19 22:37:31 [+0200]:

>Sebastian Siewior wrote:
>> * Adrian-Ken Rueegsegger | 2008-05-18 23:35:55 [+0200]:
>> 
>>> Sebastian, would you be so kind to test this patch on PowerPC?
>> Acked-by: Sebastian Siewior <sebastian@breakpoint.cc>
>
>Sebastian, thanks for testing :)
You welcome.
Any particular reason why named it rmd... instead of ripemd...?

>If there are no objections I will prepare patches for the other RIPEMD modules and submit all of them in one patch set.
Any objections on moving ripemd.h from include/crypto into crypto?
Herbert?
Since you only use it within crypto/ and you don't need it in userspace
or arch/ I would prefer to have it in crypto.

>-Adrian
Sebastian
