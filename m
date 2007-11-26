From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: IV copy strategy
Date: Mon, 26 Nov 2007 10:10:31 +0100
Message-ID: <20071126091031.GB18309@Chamillionaire.breakpoint.cc>
References: <20071113231132.GA10680@Chamillionaire.breakpoint.cc> <20071114142253.GA15201@gondor.apana.org.au> <20071115211005.GA21159@Chamillionaire.breakpoint.cc> <20071116020851.GC32509@gondor.apana.org.au>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org,
	Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60905 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753991AbXKZJKe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 Nov 2007 04:10:34 -0500
Content-Disposition: inline
In-Reply-To: <20071116020851.GC32509@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Herbert Xu | 2007-11-16 10:08:51 [+0800]:

>On Thu, Nov 15, 2007 at 10:10:05PM +0100, Sebastian Siewior wrote:
>>
>> In this case, the s390 has the same bug (they copy the IV back after
>> blkcipher_walk_done()). Howevere it will probably never get triggered
>> because they have an aligment of 0 (what gets pushed to 3 by the crypto
>> API if I remenber correcrtly). 
>
>It only gets pushed to 3 if you use the generic CBC template, they
>don't so they will stay at 0.  In their case I also see why they
>can't just use walk->iv directly.
It also gets pushed if they use lrw (3) or xts (7). They also use the
cbc template in case of a fallback :) 

Sebastian
