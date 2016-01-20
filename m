From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: aesni-intel - avoid IPsec re-ordering
Date: Wed, 20 Jan 2016 11:25:37 +0800
Message-ID: <20160120032537.GA18992@gondor.apana.org.au>
References: <CAMFBXfk=u_QYTdz0+P1WoNwuGN1xBaw0Ff2Y_XvLdQnKTasOcw@mail.gmail.com>
 <20160119074343.GA7753@gondor.apana.org.au>
 <CAMFBXfkgjTtBX4sePTr30WenzDgw=h0yp8fp17de=ao+8AT=Mg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Raj Ammanur <rammanur@arista.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51528 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935000AbcATDZn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Jan 2016 22:25:43 -0500
Content-Disposition: inline
In-Reply-To: <CAMFBXfkgjTtBX4sePTr30WenzDgw=h0yp8fp17de=ao+8AT=Mg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 19, 2016 at 09:39:51AM -0800, Raj Ammanur wrote:
> Thanks a bunch Herbert. I will try out the patch when you make it available.
> 
> 
> Are there any thoughts for these other questions from you or anyone
> else on the list, more
> importantly regarding backlog handling in ESP ?
> 
> 
> 2. When the pkts are put on the async work queue, the queue size is initialized
> as 100 in cryptd_init_queue() in crypto/cryptd.c. Does anyone know how/why
> 100 was picked ?

This should probably be increased to match NAPI queue lengths.

> 3. In cryptd_queue_worker(), the backlog->complete() callback is invoked with
> -EINPROGRESS. In net/ipv4/esp4.c, there is no handling for EINPROGRESS
> in esp_input_done()/esp_input_done2(). Am I reading the code correctly and
> is there any expectation that ESP should support backlog and have backlog
> handling ? Currently, the pkt just gets dropped as the EINPROGRESS is treated
> as nexthdr and hence is invalid.

IPsec does not use crypto backlogging so complete should never be
called with EINPROGRESS.  If the queue length is exceeded the
packet will be dropped.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
