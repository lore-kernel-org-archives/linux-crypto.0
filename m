From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH v2] crypto: rmd128: make it work on my prefered
	architecture
Date: Sat, 17 May 2008 10:47:35 +0200
Message-ID: <20080517084735.GD19540@Chamillionaire.breakpoint.cc>
References: <20080515200706.GA3081@Chamillionaire.breakpoint.cc> <20080517081003.GA19540@Chamillionaire.breakpoint.cc> <20080517.012235.82078077.davem@davemloft.net> <20080517082754.GC19540@Chamillionaire.breakpoint.cc> <20080517083738.GA17452@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	rueegsegger@swiss-it.ch
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:54170 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751176AbYEQIrl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 17 May 2008 04:47:41 -0400
Content-Disposition: inline
In-Reply-To: <20080517083738.GA17452@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Herbert Xu | 2008-05-17 16:37:38 [+0800]:

>On Sat, May 17, 2008 at 10:27:54AM +0200, Sebastian Siewior wrote:
>>
>> I know that. Please see my follow up mail with some tiny numbers.
>> gcc-4.1.1 was used on a mpc8544.
>
>But what do the numbers look like on other architectures?  In
>particular, x86-* and sparc64?
Since x86-* is little endian it should not change much except that final
uses not four single copy instructions instead of memcpy (and this is
not the hot path). 
The endian conversian is done exactly the same way in sha1 (which is
very simlar to this algorithm).

David: would you please be so kind to run a test on sparc machine?

>Cheers,

Sebastian
