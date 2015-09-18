From: Porosanu Alexandru <alexandru.porosanu@freescale.com>
Subject: RE: [PATCH v2] crypto/caam: add backlogging support
Date: Fri, 18 Sep 2015 14:27:12 +0000
Message-ID: <BY1PR03MB1404D7BD44164F6E91FFBAD680590@BY1PR03MB1404.namprd03.prod.outlook.com>
References: <1442434361-15123-1-git-send-email-alexandru.porosanu@freescale.com>
 <20150918132443.GG7638@gondor.apana.org.au>
 <BY1PR03MB1404D04ADBCBBFA586860EB280590@BY1PR03MB1404.namprd03.prod.outlook.com>
 <20150918135017.GA9152@gondor.apana.org.au>
 <BY1PR03MB14043FC6F0E0575E5A3841B880590@BY1PR03MB1404.namprd03.prod.outlook.com>
 <20150918141040.GL9249@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Geanta Neag Horia" <Horia.Geanta@freescale.com>,
	Pop Mircea <mircea.pop@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0138.outbound.protection.outlook.com ([207.46.100.138]:37568
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751984AbbIRO1P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Sep 2015 10:27:15 -0400
In-Reply-To: <20150918141040.GL9249@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-
> owner@vger.kernel.org] On Behalf Of Herbert Xu
> Sent: Friday, September 18, 2015 5:11 PM
> To: Porosanu Alexandru-B06830 <alexandru.porosanu@freescale.com>
> Cc: linux-crypto@vger.kernel.org; Geanta Neag Horia Ioan-B05471
> <Horia.Geanta@freescale.com>; Pop Mircea-R19439
> <mircea.pop@freescale.com>
> Subject: Re: [PATCH v2] crypto/caam: add backlogging support
> 
> On Fri, Sep 18, 2015 at 02:07:38PM +0000, Porosanu Alexandru wrote:
> >
> > MAY_BACKLOG requests will fail once you run out of memory (f.i.
> > backlogging using crypto_queue) Now, for this patch requests will be
> dropped if there are no more "backlogging" slots available.
> > Would limiting the # of tfms w/MAY_BACKLOG associated with the driver
> to the # of backlogging slots be OK?
> 
> Sure running out of memory is obviously a good reason to fail a request.  But
> if you still have memory MAY_BACKLOG must not fail.

Well, the HW has less than the whole RAM for backlogging requests, it has the # of available backlogging requests slots.
Then it will start dropping, just like in the out-of-mem case.

> 
> Each tfm must be able to submit at least one MAY_BACKLOG request, that's
> the whole point of this flag.  It's used for disk encryption where failing is not
> an option.

But dm-crypt is behaving properly: once -EBUSY is returned, it will sleep. And CAAM will wake it up once it has processed
the backlog request. dm-crypt was the driving factor for fixing this long-standing issue....

> 
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page:
> http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html

Thanks,

Alex P.
