From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] padata cpu awareness fixes
Date: Sat, 7 Oct 2017 12:18:58 +0800
Message-ID: <20171007041858.GE29803@gondor.apana.org.au>
References: <1504897031-27523-1-git-send-email-minipli@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org
To: Mathias Krause <minipli@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:57392 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750713AbdJGETX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 7 Oct 2017 00:19:23 -0400
Content-Disposition: inline
In-Reply-To: <1504897031-27523-1-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Sep 08, 2017 at 08:57:08PM +0200, Mathias Krause wrote:
> Hi Steffen, Herbert,
> 
> this series solves multiple issues of padata I ran into while trying to
> make use of pcrypt for IPsec.
> 
> The first issue is that the reorder timer callback may run on a CPU that
> isn't part of the parallel set, as it runs on the CPU where the timer
> interrupt gets handled. As a result, padata_reorder() may run on a CPU
> with uninitialized per-cpu parallel queues, so the __this_cpu_read() in
> padata_get_next() refers to an uninitialized cpu_index. However, as
> per-cpu memory gets memset(0) on allocation time, it'll read 0. If the
> next CPU index we're waiting for is 0 too, the compare will succeed and
> we'll return with -ENODATA, making padata_reorder() think there's
> nothing to do, stop any pending timer and return immediately. This is
> wrong as the pending timer might have been the one to trigger the needed
> reordering, but, as it was canceled, will never happen -- if no other
> parallel requests arrive afterwards.
> 
> That issue is addressed with the first two patches, ensuring we're not
> using a bogus cpu_index value for the compare and thereby not wrongly
> cancel a pending timer. The second patch then ensures the reorder timer
> callback runs on the correct CPU or, at least, on a CPU from the
> parallel set to generate forward progress.
> 
> The third patch addresses a similar issues for the serialization
> callback. We implicitly require padata_do_serial() to be called on the
> very same CPU padata_do_parallel() was called on to ensure the correct
> ordering of requests -- and correct functioning of padata, even. If the
> algorithm we're parallelizing is asynchronous itself, that invariant
> might not be true, as, e.g. crypto hardware may execute the callback on
> the CPU its interrupt gets handled on which isn't necessarily the one
> the request got issued on.
> 
> To handle that issue we track the CPU we're supposed to handle the
> request on and ensure we'll call padata_reorder() on that CPU when
> padata_do_serial() gets called -- either by already running on the
> corect CPU or by deferring the call to a worker. 
> 
> Please apply!
> 
> Mathias Krause (3):
>   padata: set cpu_index of unused CPUs to -1
>   padata: ensure the reorder timer callback runs on the correct CPU
>   padata: ensure padata_do_serial() runs on the correct CPU

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
