From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH v6 06/14] crypto: marvell/CESA: add DES support
Date: Thu, 18 Jun 2015 08:57:09 +0200
Message-ID: <20150618085709.2180759d@bbrezillon>
References: <1434527142-3609-1-git-send-email-boris.brezillon@free-electrons.com>
	<1434527142-3609-7-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Arnaud Ebalard <arno@natisbad.org>,
	Tawfik Bayouk <tawfik@marvell.com>,
	Lior Amsalem <alior@marvell.com>,
	Nadav Haklai <nadavh@marvell.com>,
	Eran Ben-Avi <benavi@marvell.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
	"Imre Kaloz" <kaloz@ope
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:53038 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752424AbbFRG5N (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Jun 2015 02:57:13 -0400
In-Reply-To: <1434527142-3609-7-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

On Wed, 17 Jun 2015 09:45:34 +0200
Boris Brezillon <boris.brezillon@free-electrons.com> wrote:

> Add support for DES operations.

The addition of DES support seems controversial. At first I thought it
would be good to support all the algorithms supported by the CESA
engine, but I think I'll drop it in the next iteration.

Do you think Triple-DES should be dropped too ?

Best Regards,

Boris 



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
