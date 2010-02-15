From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [PATCH] crypto/arc4: convert this stream cipher into a block
 cipher
Date: Mon, 15 Feb 2010 09:49:31 +0100
Message-ID: <20100215084931.GA22637@Chamillionaire.breakpoint.cc>
References: <Pine.LNX.4.64.1001260722080.20780@hs20-bc2-1.build.redhat.com>
 <20100209073718.GA17612@gondor.apana.org.au>
 <20100209145705.GA20421@Chamillionaire.breakpoint.cc>
 <20100209204519.GC26258@gondor.apana.org.au>
 <20100209211238.GC21548@Chamillionaire.breakpoint.cc>
 <20100209214522.GA27002@gondor.apana.org.au>
 <20100212084228.GA1535@Chamillionaire.breakpoint.cc>
 <20100214204253.GA19275@Chamillionaire.breakpoint.cc>
 <20100215001008.GA15437@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Mikulas Patocka <mpatocka@redhat.com>, mbroz@redhat.com,
	dm-devel@redhat.com, agk@redhat.com, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:38310 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752917Ab0BOItf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Feb 2010 03:49:35 -0500
Content-Disposition: inline
In-Reply-To: <20100215001008.GA15437@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Herbert Xu | 2010-02-15 08:10:08 [+0800]:

>How about we just remove it? It's not on a hot path anyway.
Sure.

>I can do this when integrating the patch so you don't have to
>resend.
Okay, thanks.

>Thanks,

Sebastian
