From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: Use PTR_ERR_ZERO
Date: Fri, 22 Sep 2017 18:15:42 +0800
Message-ID: <20170922101541.GO16270@gondor.apana.org.au>
References: <1503814968-8798-1-git-send-email-himanshujha199640@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, arno@natisbad.org,
        boris.brezillon@free-electrons.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Himanshu Jha <himanshujha199640@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:38816 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752334AbdIVKQF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Sep 2017 06:16:05 -0400
Content-Disposition: inline
In-Reply-To: <1503814968-8798-1-git-send-email-himanshujha199640@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Aug 27, 2017 at 11:52:48AM +0530, Himanshu Jha wrote:
> Use PTR_ERROR_ZERO rather than if(IS_ERR(...)) + PTR_ERR.
> Build successfully.
> 
> Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
