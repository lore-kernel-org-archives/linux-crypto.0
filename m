From: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: VIA Padlock driver no longer loads automatically
Date: Tue, 21 Apr 2009 10:26:45 +0200
Message-ID: <20090421082645.GA22102@Chamillionaire.breakpoint.cc>
References: <20090420181402.2b0424f4@dhcp-100-2-144.bos.redhat.com> <20090421055331.GA14062@gondor.apana.org.au> <20090421055613.GA14319@gondor.apana.org.au>
Reply-To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:50267 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751056AbZDUI0u (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Apr 2009 04:26:50 -0400
Content-Disposition: inline
In-Reply-To: <20090421055613.GA14319@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Herbert Xu | 2009-04-21 13:56:13 [+0800]:

>On Tue, Apr 21, 2009 at 01:53:31PM +0800, Herbert Xu wrote:
>> 
>> Thanks for the report.  This patch should fix the problem.
>
>In fact, padlock-aes shouldn't have been aes-all in the first
>place so I'm going to add tihs patch too.
You changed all algos which need fallback to *-all to get them
probed/loaded after the generic algorithm. The same load/fallback/test
pattern exist for the s390 aes for instance. Should it be renamed as
well?

>commit acd246b7494c629aa617da49716409566cf52149
>Author: Herbert Xu <herbert@gondor.apana.org.au>
>Date:   Tue Apr 21 13:55:20 2009 +0800
>
>    crypto: padlock - Revert aes-all alias to aes
>    
>    Since the padlock-aes driver doesn't require a fallback (it's
>    only padlock-sha that does), it should use the aes alias rather
>    than aes-all so that ones that do need a fallback can use it.
>    
>    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
>diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
>index 3f0fdd1..856b3cc 100644
>--- a/drivers/crypto/padlock-aes.c
>+++ b/drivers/crypto/padlock-aes.c
>@@ -489,4 +489,4 @@ MODULE_DESCRIPTION("VIA PadLock AES algorithm support");
> MODULE_LICENSE("GPL");
> MODULE_AUTHOR("Michal Ludvig");
> 
>-MODULE_ALIAS("aes-all");
>+MODULE_ALIAS("aes");
>
>Thanks,
>-- 

Sebastian
