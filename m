From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: sahara - Remove leftover from previous used
 spinlock
Date: Thu, 17 Aug 2017 17:00:12 +0800
Message-ID: <20170817090012.GB25646@gondor.apana.org.au>
References: <20170803134635.14726-1-mlauridsen171@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Mogens Lauridsen <mlauridsen171@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:47600 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750775AbdHQJAV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Aug 2017 05:00:21 -0400
Content-Disposition: inline
In-Reply-To: <20170803134635.14726-1-mlauridsen171@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 03, 2017 at 03:46:35PM +0200, Mogens Lauridsen wrote:
> This driver previously used a spinlock. The spinlock is not
> used any more, but the spinlock variable was still there
> and also being initialized.
> 
> Signed-off-by: Mogens Lauridsen <mlauridsen171@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
