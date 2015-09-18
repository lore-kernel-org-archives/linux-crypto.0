From: Porosanu Alexandru <alexandru.porosanu@freescale.com>
Subject: RE: [PATCH v2] crypto/caam: add backlogging support
Date: Fri, 18 Sep 2015 13:46:50 +0000
Message-ID: <BY1PR03MB1404D04ADBCBBFA586860EB280590@BY1PR03MB1404.namprd03.prod.outlook.com>
References: <1442434361-15123-1-git-send-email-alexandru.porosanu@freescale.com>
 <20150918132443.GG7638@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Geanta Neag Horia" <Horia.Geanta@freescale.com>,
	Pop Mircea <mircea.pop@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0103.outbound.protection.outlook.com ([207.46.100.103]:17952
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751979AbbIRNq7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Sep 2015 09:46:59 -0400
In-Reply-To: <20150918132443.GG7638@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

> -----Original Message-----
> From: Herbert Xu [mailto:herbert@gondor.apana.org.au]
> Sent: Friday, September 18, 2015 4:25 PM
> To: Porosanu Alexandru-B06830 <alexandru.porosanu@freescale.com>
> Cc: linux-crypto@vger.kernel.org; Geanta Neag Horia Ioan-B05471
> <Horia.Geanta@freescale.com>; Pop Mircea-R19439
> <mircea.pop@freescale.com>
> Subject: Re: [PATCH v2] crypto/caam: add backlogging support
> 
> On Wed, Sep 16, 2015 at 11:12:41PM +0300, Alex Porosanu wrote:
> > caam_jr_enqueue() function returns -EBUSY once there are no more slots
> > available in the JR, but it doesn't actually save the current request.
> > This breaks the functionality of users that expect that even if there
> > is no more space for the request, it is at least queued for later
> > execution. In other words, all crypto transformations that request
> > backlogging (i.e. have CRYPTO_TFM_REQ_MAY_BACKLOG set), will hang.
> > Such an example is dm-crypt.
> > The current patch solves this issue by setting a threshold after which
> > caam_jr_enqueue() returns -EBUSY, but since the HW job ring isn't
> > actually full, the job is enqueued.
> > Caveat: if the users of the driver don't obey the API contract which
> > states that once -EBUSY is received, no more requests are to be sent,
> > eventually the driver will reject the enqueues.
> 
> This isn't what MAY_BACKLOG is supposed to do.  For a given tfm at least one
> MAY_BACKLOG request must be accepted.  So you can't just start dropping
> requests after your queue fills up.

Before this patch, for CAAM driver, regardless if a tfm has MAY_BACKLOG set or not, if there are no more slots available in the HW JR, the API will return -EBUSY, but the
request will _not_ be saved for future processing. That's wrong, and as a result, dm-crypt _hangs_ when using CAAM offloaded algorithms.

Now, the proposed patch sets aside a # of HW slots that will be used for storing "backloggable" requests. The purpose of this is to ensure that never will the JR drop a "backloggable" request, but they will be stored for eventual processing (when the HW read pointer reaches the respective slot).
More to the point this patch does the following: 1 enqueue is accepted (if MAY_BACKLOG is set on the tfm), but the API will return -EBUSY, iff there are less than <threshold> slots available in the HW JR. 
For non-backloggable requests (or when the HW JR is sufficiently empty) are treated w/o any change. One observation would be that this change is completely transparent to the HW, which works in the same way as before.
What I was trying to point out in the caveat above is that a rogue user which will keep on enqueing requests, will eventually be denied and the requests _will_ be dropped. 
As a side-observation, for crypto_queues, the limit is the available memory, so a bad-behaved user will generate an OOM.

Let me know if I understand your concern properly...


> 
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page:
> http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Thanks,

Alex P.
