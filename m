From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH v1 0/1] *** crypto: AF_ALG: add compression support
 ***
Date: Thu, 20 Apr 2017 16:00:38 +0800
Message-ID: <20170420080038.GB6780@gondor.apana.org.au>
References: <1492108494-10694-1-git-send-email-akamaluddin@cavium.com>
 <20170414083240.GA26625@gondor.apana.org.au>
 <CACVarEQ9kW=zF+Zse17LA2KjM-dg7mb6d5XWCvSbg5nCT3=Y6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        "akamaluddin@cavium.com" <akamaluddin@cavium.com>,
        pathreya@cavium.com, mchalla@cavium.com
To: abed mohammad kamaluddin <abedamu@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [198.176.57.175] ([198.176.57.175]:56966 "EHLO
        deadmen.hmeau.com" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1764735AbdDTIBn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Apr 2017 04:01:43 -0400
Content-Disposition: inline
In-Reply-To: <CACVarEQ9kW=zF+Zse17LA2KjM-dg7mb6d5XWCvSbg5nCT3=Y6A@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 20, 2017 at 12:39:58PM +0530, abed mohammad kamaluddin wrote:
> Hi Herbert,
> 
> > I think we should convert ipcomp over to the new interface first
> > in order to make sure that we don't need to change the interface
> > which would be hard to do once we export it to user-space.
> 
> Would it be acceptable if we export an algif interface using alg_type_compress,
> which is being used by ipcomp currently? We would like to use our zip
> device from
> userspace through this interface.

No we're not going to export an obsolete interface.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
