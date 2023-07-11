Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47CD9C001DC
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jul 2023 23:28:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbjGKX2N (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Jul 2023 19:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbjGKX2M (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jul 2023 19:28:12 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B791110CF;
        Tue, 11 Jul 2023 16:28:10 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qJMlp-001BwJ-5w; Wed, 12 Jul 2023 09:27:50 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 12 Jul 2023 09:27:42 +1000
Date:   Wed, 12 Jul 2023 09:27:42 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Dan Carpenter <dan.carpenter@linaro.org>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] KEYS: asymmetric: Fix error codes
Message-ID: <ZK3lbns1A/kEOrcM@gondor.apana.org.au>
References: <c5e34c6a-da1e-4585-98c4-14701b0e093e@moroto.mountain>
 <CTYVE0G0D53P.Y8A7V3C9BW9O@suppilovahvero>
 <CTYVFFFI0SE9.2QXXQPRJW3AA3@suppilovahvero>
 <15340a35-2400-43dd-9f50-fcbcb3c4986d@kadam.mountain>
 <93959358dc48d45b98aa598feae7307fa32c00d0.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93959358dc48d45b98aa598feae7307fa32c00d0.camel@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 12, 2023 at 12:51:45AM +0300, Jarkko Sakkinen wrote:
> On Tue, 2023-07-11 at 11:40 +0300, Dan Carpenter wrote:
> > On Tue, Jul 11, 2023 at 02:12:22AM +0300, Jarkko Sakkinen wrote:
> > > > > Fixes: 63ba4d67594a ("KEYS: asymmetric: Use new crypto interface without scatterlists")
> > 
> > [ snip ]
> > 
> > > > 
> > > > I'll pick this as I'm late with 6.5 PR.
> > > > 
> > > > Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> > > 
> > > Causes merge conflicts with my tree:
> > > 
> > > https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git/
> > 
> > Your master branch doesn't include the "Use new crypto interface" commit
> > so it doesn't have the bug.
> > 
> > (I'm just testing against linux-next and I don't know how the crypto
> > trees work).
> > 
> > regards,
> > dan carpenter
> 
> It is unfortunately based on Linus' tree :-/

Both this fix and the pathces it depends on have gone through
the crypto tree and is now merged upstream.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
