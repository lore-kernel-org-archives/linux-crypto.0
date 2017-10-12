From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto API - async semantics
Date: Thu, 12 Oct 2017 14:43:34 +0800
Message-ID: <20171012064334.GA26737@gondor.apana.org.au>
References: <VI1PR0402MB3342DCCE076721CFD172C5FC984A0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:36134 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751034AbdJLGn6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Oct 2017 02:43:58 -0400
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB3342DCCE076721CFD172C5FC984A0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 11, 2017 at 12:36:11PM +0000, Horia Geantă wrote:
> Hi Herbert,
> 
> I am evaluating whether ahash implementation in caam crypto driver
> behaves correctly.
> One thing I've noticed is that for each ahash tfm there is support for
> at most two in-flight requests, and I would like to know whether this is
> an issue or not.

What do you mean by in-flight requests? If you're talking about
requests that have not been completed (i.e., in progress) then
that's fine.  Any new requests coming in can just be queued.

If you're talking about requests that have not been finalised
then that would be broken.  The API allows an arbitrary number
of requests to ben present in an non-finalised state.  For example,
given an IPsec SA, we may be processing any number of packets for
it at once, with each coming from a different CPU.

> In this context, could you please clarify whether your previous answer:
> https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg04029.html
> > If any async operation returns EINPROGRESS, the client must not
> > proceed until that operation has completed.
> refers only to ahash operations OR to any crypto API async operation?
> IIUC this would be equivalent to saying that crypto API allows only for
> one in-flight request per tfm, correct?

No that comment is referring to the request object.  The whole point
of having a request object is to allow arbitrary number of hash
operations in parallel given a single tfm.  The tfm is simply a
representation of the key.  All hash state must be stored in the
request.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
