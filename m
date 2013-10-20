From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: n2_core: insert '!err' condition in else scope
Date: Sun, 20 Oct 2013 20:12:31 +0800
Message-ID: <20131020121231.GA20425@gondor.apana.org.au>
References: <1382188171-25595-1-git-send-email-geyslan@gmail.com>
 <20131019.183825.2015665991258674429.davem@davemloft.net>
 <CAGG-pUSMJTbGHEhCOy0PRLNN4+jyVB8oB3mca1O9sb2YbpQ-fg@mail.gmail.com>
 <20131019.184919.1292439830365652584.davem@davemloft.net>
 <CAGG-pUSfA7ynQM3OEFqHaac3vh3BooisGq2rKO5OmAE_cdKb9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: David Miller <davem@davemloft.net>,
	kernel-br <kernel-br@googlegroups.com>,
	"open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Geyslan =?iso-8859-1?Q?Greg=F3rio?= Bem <geyslan@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:36852 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751305Ab3JTMMj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 20 Oct 2013 08:12:39 -0400
Content-Disposition: inline
In-Reply-To: <CAGG-pUSfA7ynQM3OEFqHaac3vh3BooisGq2rKO5OmAE_cdKb9A@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Oct 19, 2013 at 08:13:25PM -0300, Geyslan Greg=F3rio Bem wrote:
>=20
> I can understand you. You don't want to break your git history
> (blame). But when a code is clearly more readable/understandable you
> must assume that it has a huge net-positive.
>=20
> The patch improves the code in three ways:
> - Only one if/else;
> - Not blame on static analysis tools.
> - And avoid more discussion about that in the future (nobody will sen=
d
> patches like this to disturb you about that part of code).
>=20
> The decision is yours.

=46WIW I totally agree with David so your patch isn't going in.
Sorry.
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
