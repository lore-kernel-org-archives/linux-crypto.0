From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto/caam: add backlogging support
Date: Fri, 18 Sep 2015 21:50:17 +0800
Message-ID: <20150918135017.GA9152@gondor.apana.org.au>
References: <1442434361-15123-1-git-send-email-alexandru.porosanu@freescale.com>
 <20150918132443.GG7638@gondor.apana.org.au>
 <BY1PR03MB1404D04ADBCBBFA586860EB280590@BY1PR03MB1404.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Geanta Neag Horia <Horia.Geanta@freescale.com>,
	Pop Mircea <mircea.pop@freescale.com>
To: Porosanu Alexandru <alexandru.porosanu@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33293 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbbIRNuT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Sep 2015 09:50:19 -0400
Content-Disposition: inline
In-Reply-To: <BY1PR03MB1404D04ADBCBBFA586860EB280590@BY1PR03MB1404.namprd03.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Sep 18, 2015 at 01:46:50PM +0000, Porosanu Alexandru wrote:
>
> Before this patch, for CAAM driver, regardless if a tfm has MAY_BACKLOG set or not, if there are no more slots available in the HW JR, the API will return -EBUSY, but the
> request will _not_ be saved for future processing. That's wrong, and as a result, dm-crypt _hangs_ when using CAAM offloaded algorithms.

I understand that the current driver is buggy.  However your fix
is broken too.  MAY_BACKLOG must be reliable and that means not
dropping requests.

> Now, the proposed patch sets aside a # of HW slots that will be used for storing "backloggable" requests. The purpose of this is to ensure that never will the JR drop a "backloggable" request, but they will be stored for eventual processing (when the HW read pointer reaches the respective slot).
> More to the point this patch does the following: 1 enqueue is accepted (if MAY_BACKLOG is set on the tfm), but the API will return -EBUSY, iff there are less than <threshold> slots available in the HW JR. 
> For non-backloggable requests (or when the HW JR is sufficiently empty) are treated w/o any change. One observation would be that this change is completely transparent to the HW, which works in the same way as before.
> What I was trying to point out in the caveat above is that a rogue user which will keep on enqueing requests, will eventually be denied and the requests _will_ be dropped. 
> As a side-observation, for crypto_queues, the limit is the available memory, so a bad-behaved user will generate an OOM.

Yes there is a resource control issue but that should be handled
by limiting the number of tfms and not an arbitrary limit in the
driver.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
