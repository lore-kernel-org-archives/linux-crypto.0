From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto/caam: add backlogging support
Date: Wed, 23 Sep 2015 20:02:00 +0800
Message-ID: <20150923120200.GA21368@gondor.apana.org.au>
References: <1442434361-15123-1-git-send-email-alexandru.porosanu@freescale.com>
 <20150918132443.GG7638@gondor.apana.org.au>
 <BY1PR03MB1404D04ADBCBBFA586860EB280590@BY1PR03MB1404.namprd03.prod.outlook.com>
 <20150918135017.GA9152@gondor.apana.org.au>
 <BY1PR03MB14043FC6F0E0575E5A3841B880590@BY1PR03MB1404.namprd03.prod.outlook.com>
 <20150918141040.GL9249@gondor.apana.org.au>
 <BY1PR03MB1404D7BD44164F6E91FFBAD680590@BY1PR03MB1404.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Geanta Neag Horia <Horia.Geanta@freescale.com>,
	Pop Mircea <mircea.pop@freescale.com>
To: Porosanu Alexandru <alexandru.porosanu@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:58601 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447AbbIWMCI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Sep 2015 08:02:08 -0400
Content-Disposition: inline
In-Reply-To: <BY1PR03MB1404D7BD44164F6E91FFBAD680590@BY1PR03MB1404.namprd03.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Sep 18, 2015 at 02:27:12PM +0000, Porosanu Alexandru wrote:
> 
> Well, the HW has less than the whole RAM for backlogging requests, it has the # of available backlogging requests slots.
> Then it will start dropping, just like in the out-of-mem case.

OK I think that's where our misunderstanding is.  For a backlogged
request you do not give it to the hardware immediately.  In fact
a request should only be backlogged when the hardware queue is
completely full.  It should stay in a software queue until the
hardware has space for it.  When that happens you move it onto
the hardware queue and invoke the completion function with err
set to -EINPROGRESS.  This tells the caller to enqueue that it
may enqueue more requests.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
