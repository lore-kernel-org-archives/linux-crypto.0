From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: [PATCH v5 06/14] crypto: marvell/CESA: add DES support
Date: Wed, 17 Jun 2015 14:07:48 -0400
Message-ID: <CACXcFmmBoePgVRWkrvc_JcMDOcq8ecqUuUntkBH6BWKYe0R3Bg@mail.gmail.com>
References: <1434448748-10828-1-git-send-email-boris.brezillon@free-electrons.com>
	<1434448748-10828-7-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
	linux-arm-kernel@lists.infradead.org,
	LKML <linux-kernel@vger.kernel.org>,
	Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
	Imre Kaloz <kal
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:34608 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755685AbbFQSHt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Jun 2015 14:07:49 -0400
In-Reply-To: <1434448748-10828-7-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 16, 2015 at 5:59 AM, Boris Brezillon
<boris.brezillon@free-electrons.com> wrote:

> Add support for DES operations.

Why on Earth should we do that? DES is demonstrably insecure. The only
possible excuse for allowing it anywhere in a modern code base is that
you need it to implement triple DES, and even that should by now be
deprecated in favour of more modern ciphers which are much faster and
thought to be  more secure.

Here's documentation from around the turn of the century
http://www.freeswan.org/freeswan_trees/freeswan-1.5/doc/DES.html

Moore's Law applies, so the $200,000 FPGA machine that broke DES in
days in 1998 might be dirt cheap today. Certainly breaking DES on one
of today's clusters would be fast and cheap as well, given that it
took only a few months in 1998 using the Internet as the Conectio
fabric.
http://www.interhack.net/pubs/des-key-crack/
