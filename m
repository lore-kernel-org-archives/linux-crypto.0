From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: tcrypt: hmac test with keys > blocksize fail
Date: Sat, 3 May 2008 08:21:13 +0200
Message-ID: <20080503062113.GB30328@Chamillionaire.breakpoint.cc>
References: <481BAD7A.3010003@swiss-it.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Adrian-Ken R?egsegger <rueegsegger@swiss-it.ch>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:58932 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754511AbYECGVP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 3 May 2008 02:21:15 -0400
Content-Disposition: inline
In-Reply-To: <481BAD7A.3010003@swiss-it.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Adrian-Ken R?egsegger | 2008-05-03 02:10:34 [+0200]:

>Hi,
Hi Adrian-Ken,

>using the cryptodev-2.6 tree I noticed that the hmac tests that have
>keys larger than blocksize for md5 and the various sha algorithms all
>fail (tcrypt mode=10[0-5]). The other tests seem to pass just fine.
>
>The issue seems to have come from commit
>de224c309b5631bdaae3fcd6880cfb93b52f5a53.
Is this a bisect result?

>
>I have tested 48c8949ea8460216783dd33640121187b9531b60 which does not
>contain this bug.  It's just before the various tcrypt-changes from
>Sebastian Siewior.
I tested it with tcrypt mode=0 what covers 100-105 but it may slip
through. I will look into this later.

>
>-Adrian

Sebastian
