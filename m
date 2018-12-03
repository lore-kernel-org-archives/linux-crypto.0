Return-Path: <SRS0=o+Is=OM=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42117 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbeLCCk2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 2 Dec 2018 21:40:28 -0500
Date: Mon, 3 Dec 2018 11:40:19 +0900
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To: Dave Rodgman <dave.rodgman@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, nd <nd@arm.com>
Subject: Re: [PATCH 7/7] lib/lzo: separate lzo-rle from lzo
Message-ID: <20181203024019.GB427@jagdpanzerIV>
References: <20181127161913.23863-1-dave.rodgman@arm.com>
 <20181127161913.23863-8-dave.rodgman@arm.com>
 <20181129044333.GH6379@jagdpanzerIV>
 <5b504430-fb4b-340b-66c2-1300c816cc3a@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b504430-fb4b-340b-66c2-1300c816cc3a@arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On (11/30/18 10:45), Dave Rodgman wrote:
> Looking a bit more closely, these structs are formatted fairly 
> inconsistently in the crypto directory. So, lzo-rle is consistent with 
> what lzo does... but various other files do it differently.
> 
> I'm happy to submit a whitespace cleanup patch if people would like, and 
> get everything in that directory consistent (i.e. adopt a style similar 
> to the example below)?

I'm not in any position to ask you to do this; white-space clean ups
are not very popular (it's OK for staging tree; not so much otherwise).
So we better ask David and Herbert.

> static struct scomp_alg scomp = {
>          .alloc_ctx              = lzorle_alloc_ctx,
>          .free_ctx               = lzorle_free_ctx,
>          .compress               = lzorle_scompress,
>          .decompress             = lzorle_sdecompress,
>          .base                   = {
>                  .cra_name               = "lzo-rle",
>                  .cra_driver_name        = "lzo-rle-scomp",
>                  .cra_module             = THIS_MODULE,
>          }
> };

Looks nice.

	-ss
