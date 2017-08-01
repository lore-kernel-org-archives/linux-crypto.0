From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 00/16] crypto: AF_ALG - consolidation
Date: Tue, 1 Aug 2017 17:08:33 +0800
Message-ID: <20170801090833.GA674@gondor.apana.org.au>
References: <4570630.RBIQc1aA22@positron.chronox.de>
 <20170801085858.GA32240@gondor.apana.org.au>
 <88356288.VicKj4yezc@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37350 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751722AbdHAJIm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Aug 2017 05:08:42 -0400
Content-Disposition: inline
In-Reply-To: <88356288.VicKj4yezc@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 01, 2017 at 11:01:54AM +0200, Stephan Müller wrote:
> Am Dienstag, 1. August 2017, 10:58:58 CEST schrieb Herbert Xu:
> 
> Hi Herbert,
> > 
> > This split makes no sense.  I don't see why you can't merge them
> > into a single patch if it's just rearranging the code.
> 
> If you want to merge all into one patch, I am fine.
> 
> I thought that separating all out makes the patch review easier, considering 
> that in two or three of the patches, small changes are implemented to allow a 
> common code base. These changes, however, should not have any functional 
> effect.

How about you separate into three patches? The first two make
changes to algif_skcipher/algif_aead so that they can be merged,
and the last one does the actual merging.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
