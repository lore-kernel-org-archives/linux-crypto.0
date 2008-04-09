From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] [crypto] padlock-aes loadkey ondemand
Date: Wed, 9 Apr 2008 11:38:30 -0500
Message-ID: <20080409163830.GA5738@gondor.apana.org.au>
References: <20080328223333.GB24018@Chamillionaire.breakpoint.cc> <47EFE3F6.4060704@the2masters.de> <20080330210152.GA25597@Chamillionaire.breakpoint.cc> <47F28136.3080502@the2masters.de> <20080402064419.GC32234@Chamillionaire.breakpoint.cc> <20080402065015.GA7421@gondor.apana.org.au> <47F3AAD1.90406@the2masters.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
	linux-crypto@vger.kernel.org
To: Stefan Hellermann <stefan@the2masters.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:59528 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752490AbYDIQik (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Apr 2008 12:38:40 -0400
Content-Disposition: inline
In-Reply-To: <47F3AAD1.90406@the2masters.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 02, 2008 at 05:48:33PM +0200, Stefan Hellermann wrote:
> 
> Till now VIA has no SMP and nothing planed (as far as I know, I'm not a VIA guy). There
> next gen processors will be called isaiah, without smp but with 64bit and lots of other
> features ( http://www.via.com.tw/en/products/processors/isaiah-arch/ )

Apparently they're planning a multi-core version in future so
we should definitely plan for that.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
