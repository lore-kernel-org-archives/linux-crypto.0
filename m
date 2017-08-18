From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH 2/3] crypto: engine - find request type with cra_type
Date: Fri, 18 Aug 2017 13:40:08 +0200
Message-ID: <20170818114008.GB7425@Red>
References: <20170814131725.9402-1-clabbe.montjoie@gmail.com>
 <20170814131725.9402-3-clabbe.montjoie@gmail.com>
 <20170818082836.GA29641@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:34618 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750808AbdHRLkR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Aug 2017 07:40:17 -0400
Content-Disposition: inline
In-Reply-To: <20170818082836.GA29641@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Aug 18, 2017 at 04:28:37PM +0800, Herbert Xu wrote:
> On Mon, Aug 14, 2017 at 03:17:24PM +0200, Corentin Labbe wrote:
> > The current method for finding request type is based on crypto_tfm_alg_type.
> > 
> > But in case of skcipher, it is the same than ablkcipher.
> > Using cra_type for this work permits to make the distinction between the two.
> > 
> > Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> 
> I think you misunderstood my suggestion.  I'm not saying that
> you should use cra_type to distinguish all crypto types, it should
> only be used to distinguish ablkcipher from skcipher.
> 

Will change that in v4

Thanks
