Return-Path: <SRS0=+HSe=PS=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:39946 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725536AbfAJGaj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Jan 2019 01:30:39 -0500
Subject: Re: [PATCH 0/4] crypto: hisilicon: Add HiSilicon QM and ZIP
 controller driver
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
References: <1545465105-133138-1-git-send-email-wangzhou1@hisilicon.com>
CC: <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>
From: Zhou Wang <wangzhou1@hisilicon.com>
Message-ID: <5C36E682.9040701@hisilicon.com>
Date: Thu, 10 Jan 2019 14:30:26 +0800
MIME-Version: 1.0
In-Reply-To: <1545465105-133138-1-git-send-email-wangzhou1@hisilicon.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2018/12/22 15:51, Zhou Wang wrote:
> This series adds HiSilicon QM and ZIP controller driver in crypto subsystem.
> 
> A simple QM/ZIP driver which helps to provide an example for a general
> accelerator framework is under review in community[1]. Based on this simple
> driver, this series adds HW v2 support, PCI passthrough, reset, PCI/misc error
> handler, debug support. But unlike [1], driver in this patchset only registers
> to crypto subsystem.
> 
> There will be a long discussion about above accelerator framework in the
> process of upstreaming. So let's firstly review and upstream QM/ZIP crypto
> driver.
> 
> References:
> [1] https://lkml.org/lkml/2018/11/12/1951
> 
> Zhou Wang (4):
>   Documentation: Add debugfs doc for hisi_zip
>   crypto: hisilicon: Add queue management driver for HiSilicon QM module
>   crypto: hisilicon: Add HiSilicon ZIP accelerator support
>   MAINTAINERS: add maintainer for HiSilicon QM and ZIP controller driver
> 
>  Documentation/ABI/testing/debugfs-hisi-zip |   50 +
>  MAINTAINERS                                |    8 +
>  drivers/crypto/hisilicon/Kconfig           |   11 +
>  drivers/crypto/hisilicon/Makefile          |    2 +
>  drivers/crypto/hisilicon/qm.c              | 1823 ++++++++++++++++++++++++++++
>  drivers/crypto/hisilicon/qm.h              |  177 +++
>  drivers/crypto/hisilicon/zip/Makefile      |    2 +
>  drivers/crypto/hisilicon/zip/zip.h         |   60 +
>  drivers/crypto/hisilicon/zip/zip_crypto.c  |  410 +++++++
>  drivers/crypto/hisilicon/zip/zip_main.c    | 1161 ++++++++++++++++++
>  10 files changed, 3704 insertions(+)
>  create mode 100644 Documentation/ABI/testing/debugfs-hisi-zip
>  create mode 100644 drivers/crypto/hisilicon/qm.c
>  create mode 100644 drivers/crypto/hisilicon/qm.h
>  create mode 100644 drivers/crypto/hisilicon/zip/Makefile
>  create mode 100644 drivers/crypto/hisilicon/zip/zip.h
>  create mode 100644 drivers/crypto/hisilicon/zip/zip_crypto.c
>  create mode 100644 drivers/crypto/hisilicon/zip/zip_main.c
> 

Any comments about this series?

Best,
Zhou
