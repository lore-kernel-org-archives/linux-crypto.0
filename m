From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH] [crypto] geode: do not copy the IV too often
Date: Mon, 26 Nov 2007 10:42:26 +0100
Message-ID: <20071126094226.GA18532@Chamillionaire.breakpoint.cc>
References: <20071113231132.GA10680@Chamillionaire.breakpoint.cc> <20071114142253.GA15201@gondor.apana.org.au> <20071115212335.GB21159@Chamillionaire.breakpoint.cc> <20071126092521.GC18309@Chamillionaire.breakpoint.cc> <20071126092832.GA25693@gondor.apana.org.au>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:49350 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751441AbXKZJm1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 Nov 2007 04:42:27 -0500
Content-Disposition: inline
In-Reply-To: <20071126092832.GA25693@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Herbert Xu | 2007-11-26 17:28:32 [+0800]:

>On Mon, Nov 26, 2007 at 10:25:21AM +0100, Sebastian Siewior wrote:
>>
>> I saw that you rebased your cryptodev tree but you did not include
>> this patch. Should I resend it?
>
>I had to check my archives to refresh my memory :)
>
>OK I dropped it because:
>
>: How about just change op->iv to a pointer and assigning walk->iv
>: to it? That should make a smaller patch.

Sorry, I've overlooked it somehow. 
Since extra four bytes don't hurt that much I will change it.

>Thanks,
Sebastian
