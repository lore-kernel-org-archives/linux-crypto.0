From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH 1/4] crypto: talitos: dma_map_sg can handle chained SG
Date: Mon, 28 Sep 2015 11:43:34 +0200
Message-ID: <20150928094334.GA15502@Red>
References: <1443009328-12478-1-git-send-email-clabbe.montjoie@gmail.com>
 <1443009328-12478-2-git-send-email-clabbe.montjoie@gmail.com>
 <560295FA.7070005@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Christophe Leroy <christophe.leroy@c-s.fr>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:34842 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757058AbbI1Jnt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 28 Sep 2015 05:43:49 -0400
Content-Disposition: inline
In-Reply-To: <560295FA.7070005@c-s.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 23, 2015 at 02:07:22PM +0200, Christophe Leroy wrote:
>=20
> Le 23/09/2015 13:55, LABBE Corentin a =E9crit :
> > The talitos driver use two dma_map_sg path
> > according to SG are chained or not.
> > Since dma_map_sg can handle both case, clean the code with all
> > references to sg chained.
> >
> > Thus removing talitos_map_sg, talitos_unmap_sg_chain
> > and sg_count functions.
> >
> >
> Shouldn't the replacement of sg_count()  by sg_nents_for_len() be par=
t=20
> of second patch ?
>=20

No because I remove also the chained argument of sg_count, so splitting=
 this patch
with a dedicated patch for removing sg_count is not good.

Regards
