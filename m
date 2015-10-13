From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v3b 5/5] crypto: marvell: factor out common import/export
 functions
Date: Tue, 13 Oct 2015 14:59:47 +0100
Message-ID: <20151013135947.GK32532@n2100.arm.linux.org.uk>
References: <E1Zke3a-00042e-Jx@rmk-PC.arm.linux.org.uk>
 <87oag78y8i.fsf@natisbad.org>
 <20151009235132.GE32532@n2100.arm.linux.org.uk>
 <87d1wn2ewu.fsf@natisbad.org>
 <20151010112925.GF32532@n2100.arm.linux.org.uk>
 <20151010161754.GG32532@n2100.arm.linux.org.uk>
 <20151011065505.GA17272@gondor.apana.org.au>
 <20151013130048.GA6820@gondor.apana.org.au>
 <20151013135518.GJ32532@n2100.arm.linux.org.uk>
 <20151013135722.GA7543@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arnaud Ebalard <arno@natisbad.org>,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Marek Vasut <marex@denx.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:60419 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932405AbbJMN7z (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Oct 2015 09:59:55 -0400
Content-Disposition: inline
In-Reply-To: <20151013135722.GA7543@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 13, 2015 at 09:57:22PM +0800, Herbert Xu wrote:
> On Tue, Oct 13, 2015 at 02:55:18PM +0100, Russell King - ARM Linux wrote:
> >
> > Given it's size so far, I'm not sure it makes much sense to backport
> > any of these fixes to stable; I think maybe we should just say "okay,
> > before these fixes, it's just broken."
> 
> OK as long as your first patch goes into stable it should be fine
> as it'll essentially disable the marvell driver.

It will disable the Marvell driver, along with the SW implementations in
arch/arm/crypto/ which don't set .statesize, .import and .export.  I
would not be surprised if it also affects others too.

-- 
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
