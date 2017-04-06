From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/4] crypto: CRYPTO_MAX_ALG_NAME is too low
Date: Thu, 06 Apr 2017 13:58:32 -0700 (PDT)
Message-ID: <20170406.135832.1914702009261438916.davem@davemloft.net>
References: <e96825bd-4e1d-c6c1-160e-0dc10f7f3981@nokia.com>
        <367298c5-aa5d-3708-72d0-8a44702d0caa@nokia.com>
        <20170406081509.GB30557@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: alexander.sverdlin@nokia.com, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:38468 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932227AbdDFU6i (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Apr 2017 16:58:38 -0400
In-Reply-To: <20170406081509.GB30557@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Thu, 6 Apr 2017 16:15:09 +0800

> As the final patch depends on all three it would be easiest if
> we pushed the xfrm patch through the crypto tree.  Steffen/David?

No objections from me for this going through the crypto tree.
