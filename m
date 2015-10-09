From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH 0/3] crypto: fixes for Marvell hash
Date: Fri, 9 Oct 2015 14:12:43 +0200
Message-ID: <20151009141243.329dd60d@free-electrons.com>
References: <20151009102904.GL32532@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:57425 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752625AbbJIMMp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Oct 2015 08:12:45 -0400
In-Reply-To: <20151009102904.GL32532@n2100.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Russell,

On Fri, 9 Oct 2015 11:29:05 +0100, Russell King - ARM Linux wrote:
> This small series of patches addresses oopses seen when trying to use
> the AF_ALG interface via openssl with openssh.  This series does not
> address all problems, but merely stops the kernel from smashing its
> kernel stack and oopsing.

Thanks for debugging this and for the patches. However, could you Cc
the main authors of the driver:

Boris Brezillon <boris.brezillon@free-electrons.com>
Arnaud Ebalard <arno@natisbad.org>

> I'm not sure who the maintainer for drivers/crypto/marvell is, so I've
> picked Thomas.  It would be nice if there was an entry in MAINTAINERS
> for this driver.

Indeed. However get_maintainer.pl gets this right:

$ ./scripts/get_maintainer.pl -f drivers/crypto/marvell/cesa.c 
Herbert Xu <herbert@gondor.apana.org.au> (maintainer:CRYPTO API,commit_signer:11/12=92%)
"David S. Miller" <davem@davemloft.net> (maintainer:CRYPTO API)
Boris BREZILLON <boris.brezillon@free-electrons.com> (commit_signer:11/12=92%,authored:6/12=50%,added_lines:538/558=96%,removed_lines:7/12=58%)
Arnaud Ebalard <arno@natisbad.org> (commit_signer:7/12=58%,authored:4/12=33%,removed_lines:1/12=8%)
Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com> (commit_signer:1/12=8%,authored:1/12=8%,removed_lines:3/12=25%)
Krzysztof Kozlowski <k.kozlowski@samsung.com> (commit_signer:1/12=8%,authored:1/12=8%,removed_lines:1/12=8%)

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
