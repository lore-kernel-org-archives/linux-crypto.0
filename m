From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 05/19] crypto: proc - Fix checkpatch errors
Date: Sat, 20 Feb 2010 21:12:05 +0800
Message-ID: <20100220131205.GA4948@gondor.apana.org.au>
References: <1266538925-3245-1-git-send-email-richih.mailinglist@gmail.com> <m1d402t2qp.fsf@fess.ebiederm.org> <2d460de71002190210qb9d5685n2fca0e7eff011b04@mail.gmail.com> <20100219121752.GA21682@gondor.apana.org.au> <2d460de71002190835t29c6bd6bjbee8e2f787d9ab49@mail.gmail.com> <20100220004615.GB30844@gondor.apana.org.au> <2d460de71002191759w5241431an92f48de21c9af7af@mail.gmail.com> <20100220024814.GA32053@gondor.apana.org.au> <2d460de71002200226w5fa27d85maa3fa75e1dca8fdd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
	linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Benjamin Gilbert <bgilbert@cs.cmu.edu>,
	linux-kernel@vger.kernel.org
To: Richard Hartmann <richih.mailinglist@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:46768 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754857Ab0BTNMW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 20 Feb 2010 08:12:22 -0500
Content-Disposition: inline
In-Reply-To: <2d460de71002200226w5fa27d85maa3fa75e1dca8fdd@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Feb 20, 2010 at 11:26:46AM +0100, Richard Hartmann wrote:
> 
> Another workflow question:
> Does LKML as a whole prefer rebased patches, patches on top of the
> old one or does not one care as long as it's clear what to apply in what
> order?
> Or does everyone have a different opionion, in which case: What is
> yours?

It depends on what you're working on.  For this case in particular,
sending the missing bits instead of the whole thing is my preferred
solution.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
