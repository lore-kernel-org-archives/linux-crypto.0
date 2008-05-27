From: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: [PATCH] CRYPTO:  Simplify code using ARRAY_SIZE() macro.
Date: Tue, 27 May 2008 04:50:02 -0400 (EDT)
Message-ID: <alpine.LFD.1.10.0805270449390.6239@localhost.localdomain>
References: <alpine.LFD.1.10.0805250731530.23219@localhost.localdomain> <20080526112058.GA16525@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:43404 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756729AbYE0IuL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 May 2008 04:50:11 -0400
In-Reply-To: <20080526112058.GA16525@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 26 May 2008, Herbert Xu wrote:

> On Sun, May 25, 2008 at 11:32:45AM +0000, Robert P. J. Day wrote:
> >
> > Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
> >
> > ---
> >
> > diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
> > index 81f3f95..c4c018d 100644
> > --- a/drivers/crypto/hifn_795x.c
> > +++ b/drivers/crypto/hifn_795x.c
> > @@ -894,7 +894,7 @@ static int hifn_enable_crypto(struct hifn_device *dev)
> >  	char *offtbl = NULL;
> >  	int i;
> >
> > -	for (i = 0; i < sizeof(pci2id)/sizeof(pci2id[0]); i++) {
> > +	for (i = 0; i < ARRAY_SIZE(pci2id)); i++) {
>
> You've got an extra parenthesis here.  You should be building the
> patches that you send, no matter how trivial they might look!
>
> I've fixed it for you this time.

yes, my apologies.  thanks.

rday
--
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
