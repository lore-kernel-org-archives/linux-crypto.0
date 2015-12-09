From: Rameshwar Sahu <rsahu@apm.com>
Subject: Re: [PATCH v2 0/3] dmaengine: Add supports for APM X-Gene SoC CRC32C
 accerlerator driver
Date: Wed, 9 Dec 2015 13:55:55 +0530
Message-ID: <CAFd313yzBgWhTD2+Lz+RsdziAuc2kdZPS1L2FExET5sLirs_DQ@mail.gmail.com>
References: <rsahu@apm.com>
	<1447665169-14003-1-git-send-email-rsahu@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: dmaengine@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, jcm@redhat.com,
	patches@apm.com, linux-crypto@vger.kernel.org,
	Rameshwar Prasad Sahu <rsahu@apm.com>,
	Kaustubh Gondkar <kgondkar@apm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
	Vinod Koul <vinod.koul@intel.com>, dan.j.williams@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:35628 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbbLIIZ4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Dec 2015 03:25:56 -0500
Received: by ioc74 with SMTP id 74so51316033ioc.2
        for <linux-crypto@vger.kernel.org>; Wed, 09 Dec 2015 00:25:56 -0800 (PST)
In-Reply-To: <1447665169-14003-1-git-send-email-rsahu@apm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

On Mon, Nov 16, 2015 at 2:42 PM,  <rsahu@apm.com> wrote:
> From: Rameshwar Prasad Sahu <rsahu@apm.com>
>
> This patch implements support for APM X-Gene SoC CRC32C h/w accelerator driver
> and adds CRC32C computations support in dmaengine framework. APM X-Gene SoC has
> DMA engine capable of performing CRC32C computations.
>
> v2 changes:
>         1. Added helper function in dmaengine framework
>         2. Documented CRC32C support in Documentations/dmaengine/provider.txt
>         3. Fixed algo name
>         4. Fixed coding style issues
>
> Signed-off-by: Rameshwar Prasad Sahu <rsahu@apm.com>
> ---
>
> Rameshwar Prasad Sahu (3):
>   dmaengine: Add support for new feature CRC32C computations
>   dmaengine: xgene-dma: Add support for CRC32C computations via DMA
>     engine
>   Crypto: Add support for APM X-Gene SoC CRC32C h/w accelerator driver
>
>  Documentation/dmaengine/provider.txt |    3 +
>  drivers/crypto/Kconfig               |    8 +
>  drivers/crypto/Makefile              |    1 +
>  drivers/crypto/xgene-crc32c.c        |  234 +++++++++++++++++++++++++
>  drivers/dma/dmaengine.c              |    2 +
>  drivers/dma/xgene-dma.c              |  314 ++++++++++++++++++++++++++++++++--
>  include/linux/dmaengine.h            |   13 ++
>  7 files changed, 560 insertions(+), 15 deletions(-)
>  create mode 100755 drivers/crypto/xgene-crc32c.c

Any comments on above patch ??
