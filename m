From: Rameshwar Sahu <rsahu@apm.com>
Subject: Re: [PATCH v2 0/3] dmaengine: Add supports for APM X-Gene SoC CRC32C
 accerlerator driver
Date: Mon, 30 Nov 2015 14:06:03 +0530
Message-ID: <CAFd313zqimQtG8epeo3U7gzxWRf0hqO4K8hOFy4UK-6pG5GcJg@mail.gmail.com>
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
Received: from mail-ig0-f177.google.com ([209.85.213.177]:37471 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbbK3IgF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 Nov 2015 03:36:05 -0500
Received: by igcto18 with SMTP id to18so65612046igc.0
        for <linux-crypto@vger.kernel.org>; Mon, 30 Nov 2015 00:36:03 -0800 (PST)
In-Reply-To: <1447665169-14003-1-git-send-email-rsahu@apm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

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

Any Comments on above patchset ??
