From: Jamie Iles <jamie@jamieiles.com>
Subject: Re: [PATCH 0/3] crypto: picoxcell - Clamp AEAD SG list by input
 length
Date: Wed, 17 Jun 2015 09:23:51 +0100
Message-ID: <20150617082351.GA29891@page>
References: <20150611032703.GA10416@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jamie Iles <jamie@jamieiles.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:33937 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbbFQIXy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Jun 2015 04:23:54 -0400
Received: by wgv5 with SMTP id 5so30274324wgv.1
        for <linux-crypto@vger.kernel.org>; Wed, 17 Jun 2015 01:23:53 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150611032703.GA10416@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 11, 2015 at 11:27:03AM +0800, Herbert Xu wrote:
> Hi:
> 
> This series of patches adds a couple of minor fixes to picoxcell,
> but most importantly allows it to be used with the new AEAD interface
> by ensuring that it clamps the AD SG list by the AD length.
> 
> This is compile-tested only.

Looks good, thanks Herbert!

Acked-by: Jamie Iles <jamie@jamieiles.com>
