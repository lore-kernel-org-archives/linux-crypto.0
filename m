From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH] crypto: marvell - Switch cipher algs to the skcipher
 interface
Date: Fri, 13 Oct 2017 15:39:25 +0200
Message-ID: <20171013153925.30ff5095@bbrezillon>
References: <20171013133032.6025-1-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Antoine Tenart <antoine.tenart@free-electrons.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:52857 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758060AbdJMNj1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Oct 2017 09:39:27 -0400
In-Reply-To: <20171013133032.6025-1-boris.brezillon@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 13 Oct 2017 15:30:32 +0200
Boris Brezillon <boris.brezillon@free-electrons.com> wrote:

> crypto_alg is not supposed to be directly implemented by crypto engine
> driver. Drivers should instead implement specialized interfaces like

*drivers.

> ahash_alg or skcipher_alg.
> 
> Migrate to all cipher algorithms to the skcipher_alg interface. While at

s/Migrate to all/Migrate all/

> it, get rid of all references to ablkcipher including in internal struct
> or function names.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
