Return-Path: <SRS0=tM/H=BE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46C55C433E3
	for <linux-crypto@archiver.kernel.org>; Sat, 25 Jul 2020 03:15:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 264422067D
	for <linux-crypto@archiver.kernel.org>; Sat, 25 Jul 2020 03:15:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgGYDO7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Jul 2020 23:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbgGYDO7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Jul 2020 23:14:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA706C0619D3;
        Fri, 24 Jul 2020 20:14:58 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 141DE1277CC6E;
        Fri, 24 Jul 2020 19:58:13 -0700 (PDT)
Date:   Fri, 24 Jul 2020 20:14:57 -0700 (PDT)
Message-Id: <20200724.201457.2120372254880301593.davem@davemloft.net>
To:     schalla@marvell.com
Cc:     herbert@gondor.apana.org.au, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, schandran@marvell.com,
        pathreya@marvell.com, sgoutham@marvell.com
Subject: Re: [PATCH 2/4] drivers: crypto: add support for OCTEONTX2 CPT
 engine
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1595596084-29809-3-git-send-email-schalla@marvell.com>
References: <1595596084-29809-1-git-send-email-schalla@marvell.com>
        <1595596084-29809-3-git-send-email-schalla@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Jul 2020 19:58:13 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Srujana Challa <schalla@marvell.com>
Date: Fri, 24 Jul 2020 18:38:02 +0530

> diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
> new file mode 100644
> index 0000000..00cd534
> --- /dev/null
> +++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
> @@ -0,0 +1,53 @@
> +/* SPDX-License-Identifier: GPL-2.0-only
> + * Copyright (C) 2020 Marvell.
> + */
> +
> +#ifndef __OTX2_CPT_COMMON_H
> +#define __OTX2_CPT_COMMON_H
> +
> +#include <linux/pci.h>
> +#include <linux/types.h>
> +#include <linux/module.h>
> +#include <linux/delay.h>
> +#include <linux/crypto.h>
> +#include "otx2_cpt_hw_types.h"
> +#include "rvu.h"

How can this build?  "rvu.h" is in the "af/" subdirectory.
