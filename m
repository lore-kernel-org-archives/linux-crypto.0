From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: Add ECB dependency for XTS mode
Date: Thu, 23 Feb 2017 20:17:13 +0800
Message-ID: <20170223121713.GB14764@gondor.apana.org.au>
References: <20170221231717.GA7186@nicolas-laptop>
 <20170223073826.19066-1-gmazyland@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, nicolasporcel06@gmail.com
To: Milan Broz <gmazyland@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38847 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751169AbdBWMRT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Feb 2017 07:17:19 -0500
Content-Disposition: inline
In-Reply-To: <20170223073826.19066-1-gmazyland@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 23, 2017 at 08:38:26AM +0100, Milan Broz wrote:
> Since the
>    commit f1c131b45410a202eb45cc55980a7a9e4e4b4f40
>    crypto: xts - Convert to skcipher
> the XTS mode is based on ECB, so the mode must select
> ECB otherwise it can fail to initialize.
> 
> Signed-off-by: Milan Broz <gmazyland@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
