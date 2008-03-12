From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: small patch queue
Date: Wed, 12 Mar 2008 18:18:13 +0100
Message-ID: <20080312171813.GA7255@Chamillionaire.breakpoint.cc>
References: <1200700935-3844-1-git-send-email-sebastian@breakpoint.cc> <20080311133238.GA19847@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:47925 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750973AbYCLRSQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 12 Mar 2008 13:18:16 -0400
Content-Disposition: inline
In-Reply-To: <20080311133238.GA19847@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Herbert Xu | 2008-03-11 21:32:38 [+0800]:

>> The error recovery could get quite complex here, so maybe a BUG() statement
>> isn't that bad at all or?
>
>OK it seems that the only one that can really fail here is Geode.
>At this point I don't think we want to make such an intrusive change
>just for the Geode.
That's what I though :)

>Perhaps a better solution for it would be to convert it to the
>async interface and use polling from a kernel thread? How fast
>is it anyway?
Something like 1.7 MB/sec on dm-crypt if I remember correctly. It was
faster than software.
I thing there is no need for polling because the geode has an interrupt. 

>Cheers,

Sebastian
