From: Stephan Mueller <smueller@chronox.de>
Subject: Re: RFC: Crypto: Race in updating available writable socket memory.
Date: Mon, 18 Dec 2017 16:55:14 +0100
Message-ID: <1625178.SpPjtrN1ag@tauon.chronox.de>
References: <20171218142600.0000549d@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linuxarm@huawei.com,
        davem@davemloft.net, herbert@gondor.apana.org.au
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:44392 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933782AbdLRPzS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Dec 2017 10:55:18 -0500
In-Reply-To: <20171218142600.0000549d@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 18. Dezember 2017, 15:26:00 CET schrieb Jonathan Cameron:

Hi Jonathan,

> Hi All,
> 
> I came across this one but am not sure how heavy weight a fix we want to
> apply.
> 
> I was getting failures on af_alg_readable in af_alg_get_rsgl which made
> little sense as I had wmem set to a very large value.  This was caused by a
> race between ctx->rcvused += err in af_alg_get_rsgl and
> ctx->rcvused -= rsgl->sg_num_bytes in af_alg_free_areq_sgls which was being
> called from an interrupt thread.  It was wrapping in a downwards direction
> once in a large number of cycles.
> 
> Testing was using the AIO interface and libkcapi on the userspace side and a
> (hopefully) soon to be posted new Hisilicon 161x crypto accelerator driver.
> 
> So it seems that this field needs some protection.
> 1. Could make it an atomic_t (works fine, but feels rather inelegant!)
> 2. Leverage the complexity seen in sock.c if it is needed...
> 
> So the question is whether making it an atomic_t is the right way to go.

Considering that there is only one location for an increment, one location for 
a dercrement and one location for using that counter (where the use of the 
counter interprets it as int), I would feel that using an atomic_t would fully 
suffice here.

Would you care to send a patch?

Ciao
Stephan
