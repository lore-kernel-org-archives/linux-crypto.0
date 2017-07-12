From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: cavium: make several functions static
Date: Wed, 12 Jul 2017 18:52:21 +0800
Message-ID: <20170712105221.GE22109@gondor.apana.org.au>
References: <20170620103550.7660-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: George Cherian <george.cherian@cavium.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:45626 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756481AbdGLKwy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jul 2017 06:52:54 -0400
Content-Disposition: inline
In-Reply-To: <20170620103550.7660-1-colin.king@canonical.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 20, 2017 at 11:35:50AM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The functions cvm_encrypt, cvm_decrypt, cvm_xts_setkey and
> cvm_enc_dec_init does not need to be in global scope, so make
> them static.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
