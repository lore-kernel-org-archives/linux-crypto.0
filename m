Return-Path: <SRS0=uqbH=T6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4535FC28CC0
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 22:50:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A6DC262AF
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 22:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559256655;
	bh=hjWqKFlJP4/yUgQMwqUdhZkErpO8lhwWKHylFyTK9uA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=Le/Jg1fpK6pF3sW+9GsNmURmHg25RDgcJc1+eNxgYvXOrfspyWJXONic77zGBC+TK
	 S7F2B4j8Vn0vfs0fSiDqYHY14u0wZaoRav8+kJGZYDN6yygBom36Mg1nlIRljlL+go
	 3sCIGBEzO6B1spjmFIpT2inS7ZDzNn+x8+HprxBc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbfE3Wut (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 May 2019 18:50:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbfE3Wut (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 May 2019 18:50:49 -0400
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6638B262B7;
        Thu, 30 May 2019 22:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559256647;
        bh=hjWqKFlJP4/yUgQMwqUdhZkErpO8lhwWKHylFyTK9uA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=1M9ZC5ANvJgXHP4foCQorjUJ/I07kCeNHrXMQm5rWFcbagVU/aeM244UAXe+MxPuK
         fjXDzTxT7RK7oEIZeiMY95zZfE+HiIZ28GB1/Lvg2sqlrwv17x8NjVM18bvSbDV21c
         wSahg+yB57xeRoyJEUxQWmJxsI9JHrbxJUP0+6Mc=
Received: by mail-wm1-f53.google.com with SMTP id y3so4879919wmm.2;
        Thu, 30 May 2019 15:50:47 -0700 (PDT)
X-Gm-Message-State: APjAAAUoQ8gRf8cMdv/D6dzPAelgs6Mff+UNTthW8Xv/HIyzhh8HmXcL
        CTnIJzDcOiPKcJ4qIYmI0EhAAc+OtE23Pup5iUs=
X-Google-Smtp-Source: APXvYqzcn6C73pVcqdKVZsxUqEXkCfOCjxE1QAYlQcPsoykEW/jt3tkTj4k3F9uoyu3sRjkb0vm04eM9ByDOVS/ZKbI=
X-Received: by 2002:a1c:c2d5:: with SMTP id s204mr3672258wmf.174.1559256645963;
 Thu, 30 May 2019 15:50:45 -0700 (PDT)
MIME-Version: 1.0
References: <1558946326-13630-1-git-send-email-neal.liu@mediatek.com> <1558946326-13630-2-git-send-email-neal.liu@mediatek.com>
In-Reply-To: <1558946326-13630-2-git-send-email-neal.liu@mediatek.com>
From:   Sean Wang <sean.wang@kernel.org>
Date:   Thu, 30 May 2019 15:50:35 -0700
X-Gmail-Original-Message-ID: <CAGp9LzpkhDhSHL=go3fvzn2Oh8DrsW8F=1YKP4ne9TDvWQVq6Q@mail.gmail.com>
Message-ID: <CAGp9LzpkhDhSHL=go3fvzn2Oh8DrsW8F=1YKP4ne9TDvWQVq6Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] soc: mediatek: add SMC fid table for SIP interface
To:     Neal Liu <neal.liu@mediatek.com>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, wsd_upstream@mediatek.com,
        Crystal Guo <Crystal.Guo@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Neal,

On Mon, May 27, 2019 at 1:39 AM Neal Liu <neal.liu@mediatek.com> wrote:
>
> 1. Add a header file to provide SIP interface to ARM Trusted
> Firmware(ATF)
> 2. Add hwrng SMC fid
>
> Signed-off-by: Neal Liu <neal.liu@mediatek.com>
> ---
>  include/linux/soc/mediatek/mtk_sip_svc.h |   51 ++++++++++++++++++++++++++++++
>  1 file changed, 51 insertions(+)
>  create mode 100644 include/linux/soc/mediatek/mtk_sip_svc.h
>
> diff --git a/include/linux/soc/mediatek/mtk_sip_svc.h b/include/linux/soc/mediatek/mtk_sip_svc.h
> new file mode 100644
> index 0000000..f65d403
> --- /dev/null
> +++ b/include/linux/soc/mediatek/mtk_sip_svc.h
> @@ -0,0 +1,51 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (c) 2019 MediaTek Inc.
> + */
> +
> +#ifndef _MTK_SECURE_API_H_
> +#define _MTK_SECURE_API_H_
> +
> +#include <linux/kernel.h>
> +
> +/* Error Code */
> +#define SIP_SVC_E_SUCCESS                      0
> +#define SIP_SVC_E_NOT_SUPPORTED                        -1
> +#define SIP_SVC_E_INVALID_PARAMS               -2
> +#define SIP_SVC_E_INVALID_RANGE                        -3
> +#define SIP_SVC_E_PERMISSION_DENY              -4
> +
> +#ifdef CONFIG_ARM64
> +#define MTK_SIP_SMC_AARCH_BIT                  0x40000000

#define MTK_SIP_SMC_AARCH_BIT                  BIT(30)

> +#else
> +#define MTK_SIP_SMC_AARCH_BIT                  0x00000000

#define MTK_SIP_SMC_AARCH_BIT                  0

> +#endif
> +
> +/*******************************************************************************
> + * Defines for Mediatek runtime services func ids
> + ******************************************************************************/

It would be good if remove the trivial and below all unused comments.

> +
> +/* Debug feature and ATF related SMC call */
> +
> +/* CPU operations related SMC call */
> +
> +/* SPM related SMC call */
> +
> +/* Low power related SMC call */
> +
> +/* AMMS related SMC call */
> +
> +/* Security related SMC call */
> +/* HWRNG */
> +#define MTK_SIP_KERNEL_GET_RND \
> +       (0x82000206 | MTK_SIP_SMC_AARCH_BIT)
> +
> +/* Storage Encryption related SMC call */
> +
> +/* Platform related SMC call */
> +
> +/* Pheripheral related SMC call */
> +
> +/* MM related SMC call */
> +
> +#endif /* _MTK_SECURE_API_H_ */
> --
> 1.7.9.5
>
