From: Andreas WESTIN <andreas.westin@stericsson.com>
Subject: Re: [PATCH 2/3 v5] crypto: ux500: Add driver for HASH hardware
Date: Wed, 18 Apr 2012 15:59:03 +0200
Message-ID: <4F8EC8A7.10300@stericsson.com>
References: <1334059426-6806-1-git-send-email-andreas.westin@stericsson.com> <1334059426-6806-3-git-send-email-andreas.westin@stericsson.com> <20120418074945.GA20681@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"kim.phillips@freescale.com" <kim.phillips@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:41107 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753697Ab2DROWP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Apr 2012 10:22:15 -0400
In-Reply-To: <20120418074945.GA20681@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 2012-04-18 09:49, Herbert Xu wrote:
>
> Hmm, if this buffer is written to by the update function, then
> this doesn't work because the buffer resides in the tfm which
> can be used by multiple entities simultaneously.
>
> All writable data must reside in the request, not the tfm.

I'm looking into it, I assume you mean "req->base.data" ?

Cheers
Andreas
