From: =?ISO-8859-1?Q?Adrian-Ken_R=FCegsegger?= <rueegsegger@swiss-it.ch>
Subject: Re: tcrypt: hmac test with keys > blocksize fail
Date: Tue, 06 May 2008 22:53:45 +0200
Message-ID: <4820C559.2000801@swiss-it.ch>
References: <E1JtKP9-0004NE-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-crypto@ml.breakpoint.cc
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zux006-004-203.adsl.green.ch ([81.6.4.203]:2492 "EHLO
	mailx.swiss-it.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757527AbYEFUxw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 6 May 2008 16:53:52 -0400
In-Reply-To: <E1JtKP9-0004NE-00@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu wrote:
  > Actually this just exposed an ancient bug in hmac.  It relied
> on the key to be in identity-mapped memory which has never been
> guaranteed.
> 
> This patch fixes the problem for me.

I have tested the patch and it resolves the issue indeed. It also let's 
the same RIPEMD hmac tests (see my submitted patches) run correctly.

Thanks alot!

-Adrian
