From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto/caam: add backlogging support
Date: Fri, 18 Sep 2015 22:10:40 +0800
Message-ID: <20150918141040.GL9249@gondor.apana.org.au>
References: <1442434361-15123-1-git-send-email-alexandru.porosanu@freescale.com>
 <20150918132443.GG7638@gondor.apana.org.au>
 <BY1PR03MB1404D04ADBCBBFA586860EB280590@BY1PR03MB1404.namprd03.prod.outlook.com>
 <20150918135017.GA9152@gondor.apana.org.au>
 <BY1PR03MB14043FC6F0E0575E5A3841B880590@BY1PR03MB1404.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Geanta Neag Horia <Horia.Geanta@freescale.com>,
	Pop Mircea <mircea.pop@freescale.com>
To: Porosanu Alexandru <alexandru.porosanu@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43759 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbbIROKn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Sep 2015 10:10:43 -0400
Content-Disposition: inline
In-Reply-To: <BY1PR03MB14043FC6F0E0575E5A3841B880590@BY1PR03MB1404.namprd03.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Sep 18, 2015 at 02:07:38PM +0000, Porosanu Alexandru wrote:
> 
> MAY_BACKLOG requests will fail once you run out of memory (f.i. backlogging using crypto_queue)
> Now, for this patch requests will be dropped if there are no more "backlogging" slots available.
> Would limiting the # of tfms w/MAY_BACKLOG associated with the driver to the # of backlogging slots be OK?

Sure running out of memory is obviously a good reason to fail
a request.  But if you still have memory MAY_BACKLOG must not
fail.

Each tfm must be able to submit at least one MAY_BACKLOG request,
that's the whole point of this flag.  It's used for disk encryption
where failing is not an option.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
