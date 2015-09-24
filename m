From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto/caam: add backlogging support
Date: Thu, 24 Sep 2015 10:47:18 +0800
Message-ID: <20150924024718.GA27355@gondor.apana.org.au>
References: <1442434361-15123-1-git-send-email-alexandru.porosanu@freescale.com>
 <20150918132443.GG7638@gondor.apana.org.au>
 <BY1PR03MB1404D04ADBCBBFA586860EB280590@BY1PR03MB1404.namprd03.prod.outlook.com>
 <20150918135017.GA9152@gondor.apana.org.au>
 <BY1PR03MB14043FC6F0E0575E5A3841B880590@BY1PR03MB1404.namprd03.prod.outlook.com>
 <20150918141040.GL9249@gondor.apana.org.au>
 <BY1PR03MB1404D7BD44164F6E91FFBAD680590@BY1PR03MB1404.namprd03.prod.outlook.com>
 <20150923120200.GA21368@gondor.apana.org.au>
 <BY1PR03MB1404567DB10A5990A864FD8580440@BY1PR03MB1404.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Geanta Neag Horia <Horia.Geanta@freescale.com>,
	Pop Mircea <mircea.pop@freescale.com>
To: Porosanu Alexandru <alexandru.porosanu@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55239 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756427AbbIXCrV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Sep 2015 22:47:21 -0400
Content-Disposition: inline
In-Reply-To: <BY1PR03MB1404567DB10A5990A864FD8580440@BY1PR03MB1404.namprd03.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 23, 2015 at 02:40:32PM +0000, Porosanu Alexandru wrote:
> 
> Yes, you are absolutely right. In this case, I have some reasons why I wouldn't like to use a crypto_queue based approach:
> 
> 1) we've prototyped a crypto_queue implementation which did not reach the performance expectations due to CPU overhead;

I'm not saying that you should always use a software queue.  The
queue is only needed when your hardware queue is full.  You can
make it zero-length for requests that are not MAY_BACKLOG, i.e.,
only MAY_BACKLOG requests need to be queued, everything else can
just be dropped when the hw queue is full.

If you do that I don't see why the performance should be any
different.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
