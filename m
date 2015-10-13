From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3b 5/5] crypto: marvell: factor out common import/export
 functions
Date: Tue, 13 Oct 2015 21:57:22 +0800
Message-ID: <20151013135722.GA7543@gondor.apana.org.au>
References: <E1Zkda6-0005Ix-2x@rmk-PC.arm.linux.org.uk>
 <E1Zke3a-00042e-Jx@rmk-PC.arm.linux.org.uk>
 <87oag78y8i.fsf@natisbad.org>
 <20151009235132.GE32532@n2100.arm.linux.org.uk>
 <87d1wn2ewu.fsf@natisbad.org>
 <20151010112925.GF32532@n2100.arm.linux.org.uk>
 <20151010161754.GG32532@n2100.arm.linux.org.uk>
 <20151011065505.GA17272@gondor.apana.org.au>
 <20151013130048.GA6820@gondor.apana.org.au>
 <20151013135518.GJ32532@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arnaud Ebalard <arno@natisbad.org>,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Marek Vasut <marex@denx.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42397 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932256AbbJMN5g (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Oct 2015 09:57:36 -0400
Content-Disposition: inline
In-Reply-To: <20151013135518.GJ32532@n2100.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 13, 2015 at 02:55:18PM +0100, Russell King - ARM Linux wrote:
>
> Given it's size so far, I'm not sure it makes much sense to backport
> any of these fixes to stable; I think maybe we should just say "okay,
> before these fixes, it's just broken."

OK as long as your first patch goes into stable it should be fine
as it'll essentially disable the marvell driver.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
