Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABA17C6FD1F
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Mar 2023 01:09:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjCMBI7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 12 Mar 2023 21:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbjCMBI6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 12 Mar 2023 21:08:58 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2161330B11;
        Sun, 12 Mar 2023 18:08:56 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pbWg0-003Qr4-9P; Mon, 13 Mar 2023 09:08:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 13 Mar 2023 09:08:36 +0800
Date:   Mon, 13 Mar 2023 09:08:36 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        Mathew McBride <matt@traverse.com.au>, stable@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: Demote BUG_ON() in crypto_unregister_alg() to a
 WARN_ON()
Message-ID: <ZA53lHkyWcTTCWXF@gondor.apana.org.au>
References: <20230311162513.6746-1-toke@redhat.com>
 <ZA1+zr0NapJlsKk9@gondor.apana.org.au>
 <ZA2zLtqrI4aeLSTj@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZA2zLtqrI4aeLSTj@kroah.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Mar 12, 2023 at 12:10:38PM +0100, Greg KH wrote:
>
> Also, this still panics a box with panic-on-warn enabled, so if this can
> be handled, returning an error is good.

Well it can't really be handled because the driver is trying
to unregister an in-use algorithm so it's going to die one way
or another.

But returning here at least means that if this is happening
through shutdown then the system at least gets a chance to
reboot.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
