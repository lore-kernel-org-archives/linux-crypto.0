Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCE1FE9271C
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Oct 2023 17:30:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbjJERaF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Oct 2023 13:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjJER30 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Oct 2023 13:29:26 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3884E9;
        Thu,  5 Oct 2023 10:26:59 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qoLYx-003l8V-Mu; Thu, 05 Oct 2023 18:26:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 05 Oct 2023 18:26:39 +0800
Date:   Thu, 5 Oct 2023 18:26:39 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Weili Qian <qianweili@huawei.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        liulongfang@huawei.com
Subject: Re: [PATCH] crypto: hisilicon/qm - check function qp num before alg
 register
Message-ID: <ZR6PX4wazH9mjsSq@gondor.apana.org.au>
References: <20230928092147.49950-1-qianweili@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230928092147.49950-1-qianweili@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 28, 2023 at 05:21:47PM +0800, Weili Qian wrote:
> When the Kunpeng accelerator executes tasks such as encryption
> and decryption have minimum requirements on the number of device
> queues. If the number of queues does not meet the requirement,
> the process initialization will fail. Therefore, the driver checks
> the number of queues on the device before registering the algorithm.
> If the number does not meet the requirements, the driver does not register
> the algorithm to crypto subsystem, the device is still added to the
> qm_list.
> 
> Signed-off-by: Weili Qian <qianweili@huawei.com>
> ---
>  drivers/crypto/hisilicon/hpre/hpre_crypto.c | 25 ++++++++++-
>  drivers/crypto/hisilicon/hpre/hpre_main.c   | 14 +++---
>  drivers/crypto/hisilicon/qm.c               | 47 +++++++--------------
>  drivers/crypto/hisilicon/sec2/sec_crypto.c  | 31 ++++++++++++--
>  drivers/crypto/hisilicon/sec2/sec_main.c    | 24 +++++------
>  drivers/crypto/hisilicon/zip/zip_crypto.c   | 24 ++++++++++-
>  drivers/crypto/hisilicon/zip/zip_main.c     | 14 +++---
>  include/linux/hisi_acc_qm.h                 | 18 +++++++-
>  8 files changed, 134 insertions(+), 63 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
