From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 0/2] crypto: add new driver for Marvell CESA
Date: Thu, 09 Apr 2015 17:52:42 +0200
Message-ID: <13353890.ylqfTNBYXC@tauon>
References: <1428591523-1780-1-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
	Tawfik Bayouk <tawfik@marvell.com>,
	Lior Amsalem <alior@marvell.com>,
	Nadav Haklai <nadavh@marvell.com>,
	Eran Ben-Avi <benavi@marvell.com>,
	Thomas Petazzoni <info@free-electrons.com>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Arnaud Ebalard <arno@natisbad.org>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34058 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479AbbDIPwp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Apr 2015 11:52:45 -0400
In-Reply-To: <1428591523-1780-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 9. April 2015, 16:58:41 schrieb Boris Brezillon:

Hi Boris,

>Hello,
>
>This is an attempt to replace the mv_cesa driver by a new one to address
>some limitations of the existing driver.
>From a performance and CPU load point of view the most important
>limitation is the lack of DMA support, thus preventing us from chaining
>crypto operations.
>
>I know we usually try to adapt existing drivers instead of replacing them
>by new ones, but after trying to refactor the mv_cesa driver I realized it
>would take longer than writing an new one from scratch.
>
>Here are the main features brought by this new driver:
>- support for armada SoCs (up to 38x) while keeping support for older ones
>  (Orion and Kirkwood)
>- DMA mode to offload the CPU in case of intensive crypto usage
>- new algorithms: SHA256, DES and 3DES
>
>I'd like to thank Arnaud, who has carefully reviewed several iterations of
>this driver, helped me improved my implementation, provided support for
>several crypto algorithms, provided support for armada-370 and tested
>the driver on different platforms, hence the SoB and dual MODULE_AUTHOR
>in the driver code.

Your patch 1/2 did not make it to the crypto list. To big? It is on the lkml 
list though.
>
>Best Regards,
>
>Boris
>
>Boris Brezillon (2):
>  crypto: add new driver for Marvell CESA
>  crypto: marvell/CESA: update DT bindings documentation
>
> .../devicetree/bindings/crypto/mv_cesa.txt         |   50 +-
> drivers/crypto/Kconfig                             |    2 +
> drivers/crypto/Makefile                            |    2 +-
> drivers/crypto/marvell/Makefile                    |    1 +
> drivers/crypto/marvell/cesa.c                      |  539 ++++++++
> drivers/crypto/marvell/cesa.h                      |  802 ++++++++++++
> drivers/crypto/marvell/cipher.c                    |  761 +++++++++++
> drivers/crypto/marvell/hash.c                      | 1349
>++++++++++++++++++++ drivers/crypto/marvell/tdma.c                      | 
>223 ++++
> drivers/crypto/mv_cesa.c                           | 1193 -----------------
> drivers/crypto/mv_cesa.h                           |  150 ---
> 11 files changed, 3716 insertions(+), 1356 deletions(-)
> create mode 100644 drivers/crypto/marvell/Makefile
> create mode 100644 drivers/crypto/marvell/cesa.c
> create mode 100644 drivers/crypto/marvell/cesa.h
> create mode 100644 drivers/crypto/marvell/cipher.c
> create mode 100644 drivers/crypto/marvell/hash.c
> create mode 100644 drivers/crypto/marvell/tdma.c
> delete mode 100644 drivers/crypto/mv_cesa.c
> delete mode 100644 drivers/crypto/mv_cesa.h


Ciao
Stephan
