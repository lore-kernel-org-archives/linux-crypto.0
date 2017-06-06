From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH v2 2/2] crypto: engine - Permit to enqueue skcipher
 request
Date: Tue, 6 Jun 2017 16:24:22 +0200
Message-ID: <20170606142422.GA24141@Red>
References: <20170606134417.18850-1-clabbe.montjoie@gmail.com>
 <20170606134417.18850-3-clabbe.montjoie@gmail.com>
 <1595132.gd3LNaoxir@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:37762 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751418AbdFFOY2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Jun 2017 10:24:28 -0400
Content-Disposition: inline
In-Reply-To: <1595132.gd3LNaoxir@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 06, 2017 at 04:07:25PM +0200, Stephan Müller wrote:
> Am Dienstag, 6. Juni 2017, 15:44:17 CEST schrieb Corentin Labbe:
> 
> Hi Corentin,
> 
> > The crypto engine could actually only enqueue hash and ablkcipher request.
> > This patch permit it to enqueue skcipher requets by adding all necessary
> > functions.
> > The only problem is that ablkcipher and skcipher id are the same, so
> > only one cipher type is usable on the same crypto engine.
> 
> Why do you think this is needed? I thought that skcipher is the successor to 
> ablkcipher AND blkcipher. I.e. ablkcipher and blkcipher should be phased out. 
> Thus, I would infer that any ablkcipher support should or could be dropped.
> 

There are two user of it, crypto/omap and crypto/virtio.
And for crypto/omap, I have no way of testing any convertion to skcipher (no hardware).

Regards
Corentin Labbe
