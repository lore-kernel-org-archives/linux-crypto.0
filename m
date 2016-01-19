From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: aesni-intel - avoid IPsec re-ordering
Date: Tue, 19 Jan 2016 15:43:43 +0800
Message-ID: <20160119074343.GA7753@gondor.apana.org.au>
References: <CAMFBXfk=u_QYTdz0+P1WoNwuGN1xBaw0Ff2Y_XvLdQnKTasOcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Raj Ammanur <rammanur@arista.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57441 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbcASHns (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Jan 2016 02:43:48 -0500
Content-Disposition: inline
In-Reply-To: <CAMFBXfk=u_QYTdz0+P1WoNwuGN1xBaw0Ff2Y_XvLdQnKTasOcw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Raj Ammanur <rammanur@arista.com> wrote:
>
> First, I would like to report that we are also seeing problem where IPSec
> packets are getting queued up to the workqueue for async processing because
> of the FPU not being available. Since there are also a lot of input pkts, by the
> time xfrm_input() is invoked again after the async operation is completed, the
> IPsec pkts are either out of sequence or out of the replay window, since the
> replay window has advanced. We are using IPSec tunnel between two
> switches connected over a Long Fat Network and have sender and receiver
> servers connected to the two ends of the tunnel. Because of  the TCP
> receiver receiving  pkts either out of order or not receiving pkts because of
> dropped pkts, this is causing significant drop in TCP throughtput on Long Fat
> Networks, where  the network latency is high.

Thanks for the reminder.  I will try to post a patch for this soon.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
