From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH] AMCC Crypto4xx Device Driver v4]
Date: Mon, 8 Dec 2008 18:35:52 -0600
Message-ID: <20081208183552.744cb4ae.kim.phillips@freescale.com>
References: <1228256232.4770.47.camel@jhsiao-usb>
	<20081204193256.12dbc306.kim.phillips@freescale.com>
	<1228773307.4906.14.camel@jhsiao-usb>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, jwboyer@linux.vnet.ibm.com,
	linux-crypto@vger.kernel.org, linuxppc-dev@ozlabs.org
To: jhsiao@amcc.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from az33egw02.freescale.net ([192.88.158.103]:54693 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752AbYLIAka (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Dec 2008 19:40:30 -0500
In-Reply-To: <1228773307.4906.14.camel@jhsiao-usb>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 08 Dec 2008 13:55:07 -0800
James Hsiao <jhsiao@amcc.com> wrote:

> >> +     /* figure how many gd is needed */
> >> +     if (aad_len) {
> >> +             num_gd = get_sg_count(assoc, aad_len) +
> >> +                     get_sg_count(src, datalen);
> 
> > this is dead code - aad_len is never non-zero - is there some code
> > missing from crypto4xx_alg.c?  Also, IIRC, assoc is a superset of src,
> > so I believe something like num_gd = get_sg_count(assoc, aad_len +
> > datalen) would work better - this should also permit removal of the
> > nbytes reached check in [1] in get_sg_count.
> 
> For the get num_gd, assoc and src are two different scatter_lists. One
> for the packet and one for the aad, so, it makes more sense to me to
> count them seperately. Yes?

ok I looked it up - they are disjoint sg lists, so, yes, you're right.

> The way to driver pass aad and aad_len is from crypto4xx_build_pd. 
> This aad support will be used in the future. Do you want me to remover
> from the current release?  The reason I have it in, is to avoid too much
> code change for the future release.

removing it would definitely make both this and any forthcoming aead
patches more on topic and thus easier to review (plus I suspect adding
unused code to the kernel is generally frowned upon...)

Kim
