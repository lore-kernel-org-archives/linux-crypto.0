Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72358C4167B
	for <linux-crypto@archiver.kernel.org>; Sun, 11 Dec 2022 06:17:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiLKGQw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 11 Dec 2022 01:16:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiLKGQv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 11 Dec 2022 01:16:51 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F85212D2E;
        Sat, 10 Dec 2022 22:16:49 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1p4Fdl-006AVM-Lk; Sun, 11 Dec 2022 14:16:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 11 Dec 2022 14:16:45 +0800
Date:   Sun, 11 Dec 2022 14:16:45 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Kai Ye <yekai13@huawei.com>
Cc:     gregkh@linuxfoundation.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, wangzhou1@hisilicon.com,
        liulongfang@huawei.com
Subject: Re: [PATCH v10 3/3] crypto: hisilicon/qm - define the device
 isolation strategy
Message-ID: <Y5V1zaurC8TuuA6l@gondor.apana.org.au>
References: <20221119074817.12063-1-yekai13@huawei.com>
 <20221119074817.12063-4-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221119074817.12063-4-yekai13@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Nov 19, 2022 at 07:48:17AM +0000, Kai Ye wrote:
> Define the device isolation strategy by the device driver. The
> user configures a hardware error threshold value by uacce interface.
> If the number of hardware errors exceeds the value of setting error
> threshold in one hour. The device will not be available in user space.
> The VF device use the PF device isolation strategy. All the hardware
> errors are processed by PF driver.
> 
> Signed-off-by: Kai Ye <yekai13@huawei.com>
> ---
>  drivers/crypto/hisilicon/qm.c | 169 +++++++++++++++++++++++++++++++---
>  include/linux/hisi_acc_qm.h   |  15 +++
>  2 files changed, 169 insertions(+), 15 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
