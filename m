From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto API - async semantics
Date: Thu, 12 Oct 2017 17:48:36 +0800
Message-ID: <20171012094836.GA29179@gondor.apana.org.au>
References: <VI1PR0402MB3342DCCE076721CFD172C5FC984A0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
 <20171012064334.GA26737@gondor.apana.org.au>
 <VI1PR0402MB33421AE04D3D1115400CDD83984B0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:36762 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752250AbdJLJs6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Oct 2017 05:48:58 -0400
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB33421AE04D3D1115400CDD83984B0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 12, 2017 at 09:39:34AM +0000, Horia Geantă wrote:
>
> Taking ascii art from crypto API docs:
> 
> DATA -----------.
>                 v
>  .init() -> .update() -> .final()      ! .update() might not be called
>              ^    |         |            at all in this scenario.
>              '----'         '---> HASH
> 
> My question was referring to the case where multiple update() operations
> are issued in parallel for the same request object.
> For e.g. let's say a crypto API client wants to hash a 4GB file, and
> does this by issuing update() repeatedly and performing
> wait_for_completion() at the very end.

That is most certainly not legal.  Is dm-crypt doing that?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
