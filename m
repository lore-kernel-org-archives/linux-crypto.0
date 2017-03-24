From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ixp4xx - Use sg_virt()
Date: Fri, 24 Mar 2017 22:17:58 +0800
Message-ID: <20170324141758.GL14780@gondor.apana.org.au>
References: <a41fae798473b657f09859ae113403655b1717f9.1490258141.git.geliangtang@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Geliang Tang <geliangtang@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:42766 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936035AbdCXOSN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Mar 2017 10:18:13 -0400
Content-Disposition: inline
In-Reply-To: <a41fae798473b657f09859ae113403655b1717f9.1490258141.git.geliangtang@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 23, 2017 at 09:16:30PM +0800, Geliang Tang wrote:
> Use sg_virt() instead of open-coding it.
> 
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
