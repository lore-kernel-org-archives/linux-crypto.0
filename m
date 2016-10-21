From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1] crypto: atmel-aes: fix compiler error when
 VERBOSE_DEBUG is defined
Date: Fri, 21 Oct 2016 11:09:45 +0800
Message-ID: <20161021030945.GB22979@gondor.apana.org.au>
References: <605a4f64ee501aeaffbd43b7b45fd9b3d997bd7b.1475167206.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, nicolas.ferre@atmel.com,
        levent.demir@inria.fr, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36820 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751010AbcJUDJ6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Oct 2016 23:09:58 -0400
Content-Disposition: inline
In-Reply-To: <605a4f64ee501aeaffbd43b7b45fd9b3d997bd7b.1475167206.git.cyrille.pitchen@atmel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 29, 2016 at 06:46:57PM +0200, Cyrille Pitchen wrote:
> This patch fixes a compiler error when VERBOSE_DEBUG is defined. Indeed,
> in atmel_aes_write(), the 3rd argument of atmel_aes_reg_name() was
> missing.
> 
> Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
> Reported-by: Levent Demir <levent.demir@inria.fr>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
