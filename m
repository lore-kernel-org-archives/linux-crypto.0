From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 01/13] crypto: crypto4xx: wire up hmac_mc to hmac_muting
Date: Thu, 12 Oct 2017 23:19:33 +0800
Message-ID: <20171012151933.GH31122@gondor.apana.org.au>
References: <8c9b4bc7e3a88970fe0fc308034627b8ae972600.1507070985.git.chunkeey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Christian Lamparter <chunkeey@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37360 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751370AbdJLPTy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Oct 2017 11:19:54 -0400
Content-Disposition: inline
In-Reply-To: <8c9b4bc7e3a88970fe0fc308034627b8ae972600.1507070985.git.chunkeey@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 04, 2017 at 01:00:05AM +0200, Christian Lamparter wrote:
> The hmac_mc parameter of set_dynamic_sa_command_1()
> was defined but not used. On closer inspection it
> turns out, it was never wired up.
> 
> Signed-off-by: Christian Lamparter <chunkeey@gmail.com>

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
