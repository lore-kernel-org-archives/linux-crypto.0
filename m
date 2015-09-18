From: Porosanu Alexandru <alexandru.porosanu@freescale.com>
Subject: RE: [PATCH v2] crypto/caam: add backlogging support
Date: Fri, 18 Sep 2015 14:07:38 +0000
Message-ID: <BY1PR03MB14043FC6F0E0575E5A3841B880590@BY1PR03MB1404.namprd03.prod.outlook.com>
References: <1442434361-15123-1-git-send-email-alexandru.porosanu@freescale.com>
 <20150918132443.GG7638@gondor.apana.org.au>
 <BY1PR03MB1404D04ADBCBBFA586860EB280590@BY1PR03MB1404.namprd03.prod.outlook.com>
 <20150918135017.GA9152@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Geanta Neag Horia" <Horia.Geanta@freescale.com>,
	Pop Mircea <mircea.pop@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0139.outbound.protection.outlook.com ([65.55.169.139]:50160
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753328AbbIROHm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Sep 2015 10:07:42 -0400
In-Reply-To: <20150918135017.GA9152@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

> -----Original Message-----
> From: Herbert Xu [mailto:herbert@gondor.apana.org.au]
> Sent: Friday, September 18, 2015 4:50 PM
> To: Porosanu Alexandru-B06830 <alexandru.porosanu@freescale.com>
> Cc: linux-crypto@vger.kernel.org; Geanta Neag Horia Ioan-B05471
> <Horia.Geanta@freescale.com>; Pop Mircea-R19439
> <mircea.pop@freescale.com>
> Subject: Re: [PATCH v2] crypto/caam: add backlogging support
> 
> On Fri, Sep 18, 2015 at 01:46:50PM +0000, Porosanu Alexandru wrote:
> >
> > Before this patch, for CAAM driver, regardless if a tfm has
> > MAY_BACKLOG set or not, if there are no more slots available in the HW JR,
> the API will return -EBUSY, but the request will _not_ be saved for future
> processing. That's wrong, and as a result, dm-crypt _hangs_ when using
> CAAM offloaded algorithms.
> 
> I understand that the current driver is buggy.  However your fix is broken
> too.  MAY_BACKLOG must be reliable and that means not dropping requests.

MAY_BACKLOG requests will fail once you run out of memory (f.i. backlogging using crypto_queue)
Now, for this patch requests will be dropped if there are no more "backlogging" slots available.
Would limiting the # of tfms w/MAY_BACKLOG associated with the driver to the # of backlogging slots be OK?


> 
> > Now, the proposed patch sets aside a # of HW slots that will be used for
> storing "backloggable" requests. The purpose of this is to ensure that never
> will the JR drop a "backloggable" request, but they will be stored for eventual
> processing (when the HW read pointer reaches the respective slot).
> > More to the point this patch does the following: 1 enqueue is accepted (if
> MAY_BACKLOG is set on the tfm), but the API will return -EBUSY, iff there
> are less than <threshold> slots available in the HW JR.
> > For non-backloggable requests (or when the HW JR is sufficiently empty)
> are treated w/o any change. One observation would be that this change is
> completely transparent to the HW, which works in the same way as before.
> > What I was trying to point out in the caveat above is that a rogue user
> which will keep on enqueing requests, will eventually be denied and the
> requests _will_ be dropped.
> > As a side-observation, for crypto_queues, the limit is the available
> memory, so a bad-behaved user will generate an OOM.
> 
> Yes there is a resource control issue but that should be handled by limiting
> the number of tfms and not an arbitrary limit in the driver.

Let me try and put it another way: for each tfm w/MAY_BACKLOG, the driver will accept a request and will return -EBUSY.
Once there are really no more slots available, yes, requests will get dropped (i.e. -EIO will be returned)

> 
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page:
> http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Thanks,

Alex P.
