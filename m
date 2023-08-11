Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B1F0C001DB
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Aug 2023 11:30:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbjHKLak (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Aug 2023 07:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjHKLak (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Aug 2023 07:30:40 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72DA6E62;
        Fri, 11 Aug 2023 04:30:39 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qUQLi-0024D2-Co; Fri, 11 Aug 2023 19:30:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Aug 2023 19:30:34 +0800
Date:   Fri, 11 Aug 2023 19:30:34 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Mark O'Donovan <shiftee@posteo.net>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        ebiggers@google.com
Subject: Re: [PATCH RESEND] lib/mpi: avoid null pointer deref in mpi_cmp_ui()
Message-ID: <ZNYb2p2hWH1aUyKO@gondor.apana.org.au>
References: <20230804093218.418276-1-shiftee@posteo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230804093218.418276-1-shiftee@posteo.net>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 04, 2023 at 09:32:18AM +0000, Mark O'Donovan wrote:
> During NVMeTCP Authentication a controller can trigger a kernel
> oops by specifying the 8192 bit Diffie Hellman group and passing
> a correctly sized, but zeroed Diffie Hellamn value.
> mpi_cmp_ui() was detecting this if the second parameter was 0,
> but 1 is passed from dh_is_pubkey_valid(). This causes the null
> pointer u->d to be dereferenced towards the end of mpi_cmp_ui()
> 
> Signed-off-by: Mark O'Donovan <shiftee@posteo.net>
> ---
>  lib/mpi/mpi-cmp.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
