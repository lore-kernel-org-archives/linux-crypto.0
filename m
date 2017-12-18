From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: RFC: Crypto: Race in updating available writable socket memory.
Date: Mon, 18 Dec 2017 14:26:00 +0000
Message-ID: <20171218142600.0000549d@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
To: <linux-crypto@vger.kernel.org>, <linuxarm@huawei.com>,
        Stephan Mueller <smueller@chronox.de>, <davem@davemloft.net>,
        <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:2692 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752954AbdLRO0g (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Dec 2017 09:26:36 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi All,

I came across this one but am not sure how heavy weight a fix we want to apply.

I was getting failures on af_alg_readable in af_alg_get_rsgl which made little
sense as I had wmem set to a very large value.  This was caused by a race between
ctx->rcvused += err in af_alg_get_rsgl and
ctx->rcvused -= rsgl->sg_num_bytes in af_alg_free_areq_sgls which was being
called from an interrupt thread.  It was wrapping in a downwards direction once
in a large number of cycles.

Testing was using the AIO interface and libkcapi on the userspace side and a
(hopefully) soon to be posted new Hisilicon 161x crypto accelerator driver.

So it seems that this field needs some protection.
1. Could make it an atomic_t (works fine, but feels rather inelegant!)
2. Leverage the complexity seen in sock.c if it is needed...

So the question is whether making it an atomic_t is the right way to go.

Thanks,

Jonathan  
