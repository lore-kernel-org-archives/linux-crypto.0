Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FDDBC74A44
	for <linux-crypto@archiver.kernel.org>; Sat, 11 Mar 2023 08:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjCKIEQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 11 Mar 2023 03:04:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbjCKIEO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 11 Mar 2023 03:04:14 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 718FF116BBD
        for <linux-crypto@vger.kernel.org>; Sat, 11 Mar 2023 00:04:06 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pauCn-002wiP-3X; Sat, 11 Mar 2023 16:03:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 11 Mar 2023 16:03:53 +0800
Date:   Sat, 11 Mar 2023 16:03:53 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        Mathew McBride <matt@traverse.com.au>,
        linux-crypto@vger.kernel.org
Subject: Re: Hitting BUG_ON in crypto_unregister_alg() on reboot with
 caamalg_qi2 driver
Message-ID: <ZAw16S7OQyYCAK90@gondor.apana.org.au>
References: <87r0tyq8ph.fsf@toke.dk>
 <ZAqwTqw3lR+dnImO@gondor.apana.org.au>
 <87ilf8rakq.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87ilf8rakq.fsf@toke.dk>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 10, 2023 at 02:37:57PM +0100, Toke Høiland-Jørgensen wrote:
>
> Also, absent of a fixed driver (which doesn't sound like it's a trivial
> fix?), how do I prevent the system from crashing on shutdown? The
> BUG_ON() seems a bit heavy-handed, could it be replaced with a WARN_ON?

Yes I think that's probably OK.  Could you please send a patch?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
