From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH v2 5/5] crypto: talitos: Add software backlog queue
 handling
Date: Thu, 5 Mar 2015 18:34:58 -0600
Message-ID: <20150305183458.a7ce24358ba2b8cc92f261d9@freescale.com>
References: <1425388897-5434-1-git-send-email-mort@bork.org>
	<1425388897-5434-6-git-send-email-mort@bork.org>
	<20150303182332.546523088b5891a776880c0f@freescale.com>
	<54F8235B.5080301@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Martin Hicks <mort@bork.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Scott Wood <scottwood@freescale.com>,
	Kumar Gala <galak@kernel.crashing.org>,
	<linuxppc-dev@lists.ozlabs.org>, <linux-crypto@vger.kernel.org>
To: Horia =?UTF-8?B?R2VhbnTEgw==?= <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bbn0109.outbound.protection.outlook.com ([157.56.111.109]:32470
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751628AbbCFAkW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Mar 2015 19:40:22 -0500
In-Reply-To: <54F8235B.5080301@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 5 Mar 2015 11:35:23 +0200
Horia Geant=C4=83 <horia.geanta@freescale.com> wrote:

> On 3/4/2015 2:23 AM, Kim Phillips wrote:
> > On Tue,  3 Mar 2015 08:21:37 -0500
> > Martin Hicks <mort@bork.org> wrote:
> >=20
> >> @@ -1170,6 +1237,8 @@ static struct talitos_edesc *talitos_edesc_a=
lloc(struct device *dev,
> >>  						     edesc->dma_len,
> >>  						     DMA_BIDIRECTIONAL);
> >>  	edesc->req.desc =3D &edesc->desc;
> >> +	/* A copy of the crypto_async_request to use the crypto_queue ba=
cklog */
> >> +	memcpy(&edesc->req.base, areq, sizeof(struct crypto_async_reques=
t));
> >=20
> > this seems backward, or, at least can be done more efficiently IMO:
> > talitos_cra_init should set the tfm's reqsize so the rest of
> > the driver can wholly embed its talitos_edesc (which should also
> > wholly encapsulate its talitos_request (i.e., not via a pointer))
> > into the crypto API's request handle allocation.  This
> > would absorb and eliminate the talitos_edesc kmalloc and frees, the
> > above memcpy, and replace the container_of after the
> > crypto_dequeue_request with an offset_of, right?
> >=20
> > When scatter-gather buffers are needed, we can assume a slower-path
> > and make them do their own allocations, since their sizes vary
> > depending on each request.  Of course, a pointer to those
> > allocations would need to be retained somewhere in the request
> > handle.
>=20
> Unfortunately talitos_edesc structure size is most of the times
> variable. Its exact size can only be established at "request time", a=
nd
> not at "tfm init time".

yes, I was suggesting a common minimum should be set in cra_init.

> Fixed size would be sizeof(talitos_edesc).
> Below are factors that influence the variable part, i.e. link_tbl in
> talitos_edesc:
> - whether any assoc / src / dst data is scattered
> - icv_stashing (case when ICV checking is done in SW)

both being slow(er) paths, IMO.

> Still we'd be better with:
> -crypto API allocates request + request context (i.e.
> sizeof(talitos_edesc) + any alignment required)
> -talitos driver allocates variable part of talitos_edesc (if needed)
>=20
> instead of:
> -crypto API allocates request
> -talitos driver allocates talitos_edesc (fixed + variable)
> -memcopy of the req.base (crypto_async_request) into talitos_edesc
>=20
> both in terms of performance and readability.

indeed.

> At first look, the driver wouldn't change that much:
> -talitos_cra_init() callback would have to set tfm.reqsize to
> sizeof(talitos_edesc) + padding and also add the CRYPTO_TFM_REQ_DMA
> indication in tfm.crt_flags
> -talitos_edesc_alloc() logic would be pretty much the same, but would
> allocate memory only for the link_tbl
>=20
> I'm willing to do these changes if needed.

Please coordinate with Martin.

fwiw, caam could use this, too.

Kim
