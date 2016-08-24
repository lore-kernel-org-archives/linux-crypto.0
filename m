From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: mxc-scc - check clk_prepare_enable() error
Date: Wed, 24 Aug 2016 21:18:08 +0800
Message-ID: <20160824131808.GB4039@gondor.apana.org.au>
References: <1471833447-11446-1-git-send-email-festevam@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: s.trumtrar@pengutronix.de, linux-crypto@vger.kernel.org,
        Fabio Estevam <fabio.estevam@nxp.com>
To: Fabio Estevam <festevam@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46721 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754144AbcHXNSS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Aug 2016 09:18:18 -0400
Content-Disposition: inline
In-Reply-To: <1471833447-11446-1-git-send-email-festevam@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Aug 21, 2016 at 11:37:27PM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@nxp.com>
> 
> clk_prepare_enable() may fail, so we should better check its return
> value and propagate it in the case of failure.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
