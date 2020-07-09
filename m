Return-Path: <SRS0=b7AZ=AU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56762C433DF
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 12:14:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39EFE2074B
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 12:14:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbgGIMOL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Jul 2020 08:14:11 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:36004 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726767AbgGIMOL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Jul 2020 08:14:11 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jtVRJ-0003Fy-82; Thu, 09 Jul 2020 22:14:10 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 09 Jul 2020 22:14:09 +1000
Date:   Thu, 9 Jul 2020 22:14:09 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH 3/5] crypto: arm64/gcm - use variably sized key struct
Message-ID: <20200709121409.GA16808@gondor.apana.org.au>
References: <20200629073925.127538-1-ardb@kernel.org>
 <20200629073925.127538-4-ardb@kernel.org>
 <20200709082258.GB1892@gondor.apana.org.au>
 <20200709121231.GA15770@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709121231.GA15770@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 09, 2020 at 10:12:31PM +1000, Herbert Xu wrote:
> On Thu, Jul 09, 2020 at 06:22:58PM +1000, Herbert Xu wrote:
> > On Mon, Jun 29, 2020 at 09:39:23AM +0200, Ard Biesheuvel wrote:
> > > Now that the ghash and gcm drivers are split, we no longer need to allocate
> > > a key struct for the former that carries powers of H that are only used by
> > > the latter. Also, take this opportunity to clean up the code a little bit.
> > > 
> > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > > ---
> > >  arch/arm64/crypto/ghash-ce-glue.c | 49 +++++++++-----------
> > >  1 file changed, 21 insertions(+), 28 deletions(-)
> > 
> > sparse doesn't like this patch either.
> 
> And some of these warnings appear to be genuine.

Nevermind these appear to be preexisting warnings.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
