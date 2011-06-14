From: Kent Borg <kentborg@borg.org>
Subject: Re: HW Accelerated IPSEC?
Date: Tue, 14 Jun 2011 16:51:19 -0400
Message-ID: <4DF7C9C7.1000801@borg.org>
References: <20110611011842.GA5222@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from borg.org ([64.105.205.123]:42387 "EHLO borg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074Ab1FNUvY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jun 2011 16:51:24 -0400
In-Reply-To: <20110611011842.GA5222@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu wrote:
 > If that works then it's probably a bug in your driver, otherwise
 > we may have an issue in IPsec itself.

I think I found my bug. I discovered DMA_API_DEBUG, and it complains 
when my sha1 module loads. Looking it over it seems I can't do DMA from 
an shash, I will have to figure out how to make an ahash. (Any pointers 
on what code to crib from to best understand how an ahash works? Any 
other documentation??)

So, my sha1 module passes the self-test...just not safely.


Thanks,

- kb, the Kent who doesn't just opine about entropy.
