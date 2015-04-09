From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 0/2] crypto: add new driver for Marvell CESA
Date: Thu, 09 Apr 2015 17:34:29 +0200
Message-ID: <55269C05.2060401@gmail.com>
References: <1428591523-1780-1-git-send-email-boris.brezillon@free-electrons.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
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
	Andrew Lunn <andrew@lunn.ch>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Arnaud Ebalard <arno@natisbad.org>
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:38906 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603AbbDIPei (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Apr 2015 11:34:38 -0400
In-Reply-To: <1428591523-1780-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09.04.2015 16:58, Boris Brezillon wrote:
> This is an attempt to replace the mv_cesa driver by a new one to address
> some limitations of the existing driver.
>  From a performance and CPU load point of view the most important
> limitation is the lack of DMA support, thus preventing us from chaining
> crypto operations.
>
> I know we usually try to adapt existing drivers instead of replacing them
> by new ones, but after trying to refactor the mv_cesa driver I realized it
> would take longer than writing an new one from scratch.

Boris,

if you include a bunch of performance measurements, I guess it will help
you to get an agreement of replacing the driver instead of reworking it.

> Here are the main features brought by this new driver:
> - support for armada SoCs (up to 38x) while keeping support for older ones
>    (Orion and Kirkwood)

Unfortunately, the list above is missing Dove SoCs which also have a
CESA engine with TDMA support. I checked the registers _very_ quickly
but it seems that they are compatible with Kirkwood's CESA.

> - DMA mode to offload the CPU in case of intensive crypto usage
> - new algorithms: SHA256, DES and 3DES
>
[...]
> Boris Brezillon (2):
>    crypto: add new driver for Marvell CESA
>    crypto: marvell/CESA: update DT bindings documentation

IMHO, the patch set should be split up in:
- new core driver
- add support for TDMA on platforms that support it
- new cipher algorithms
- removal of old mv_cesa

I'd love to test on Dove, but time still is very limited. I guess the
patches will receive another round anyway, maybe I find some until the
final version.

Sebastian

>   .../devicetree/bindings/crypto/mv_cesa.txt         |   50 +-
>   drivers/crypto/Kconfig                             |    2 +
>   drivers/crypto/Makefile                            |    2 +-
>   drivers/crypto/marvell/Makefile                    |    1 +
>   drivers/crypto/marvell/cesa.c                      |  539 ++++++++
>   drivers/crypto/marvell/cesa.h                      |  802 ++++++++++++
>   drivers/crypto/marvell/cipher.c                    |  761 +++++++++++
>   drivers/crypto/marvell/hash.c                      | 1349 ++++++++++++++++++++
>   drivers/crypto/marvell/tdma.c                      |  223 ++++
>   drivers/crypto/mv_cesa.c                           | 1193 -----------------
>   drivers/crypto/mv_cesa.h                           |  150 ---
>   11 files changed, 3716 insertions(+), 1356 deletions(-)
>   create mode 100644 drivers/crypto/marvell/Makefile
>   create mode 100644 drivers/crypto/marvell/cesa.c
>   create mode 100644 drivers/crypto/marvell/cesa.h
>   create mode 100644 drivers/crypto/marvell/cipher.c
>   create mode 100644 drivers/crypto/marvell/hash.c
>   create mode 100644 drivers/crypto/marvell/tdma.c
>   delete mode 100644 drivers/crypto/mv_cesa.c
>   delete mode 100644 drivers/crypto/mv_cesa.h
>
