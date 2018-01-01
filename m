From: Philippe Ombredanne <pombredanne@nexb.com>
Subject: Re: [PATCH 01/26] staging: ccree: SPDXify driver
Date: Mon, 1 Jan 2018 14:53:08 +0100
Message-ID: <CAOFm3uG6CGxPt4u=vk5DxM-hLmyvaiwhz4wxK2SzJfzyr6K4ig@mail.gmail.com>
References: <1514808421-21993-1-git-send-email-gilad@benyossef.com> <1514808421-21993-2-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ofir Drang <ofir.drang@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f170.google.com ([209.85.128.170]:36165 "EHLO
        mail-wr0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751111AbeAANxt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Jan 2018 08:53:49 -0500
Received: by mail-wr0-f170.google.com with SMTP id u19so40147158wrc.3
        for <linux-crypto@vger.kernel.org>; Mon, 01 Jan 2018 05:53:49 -0800 (PST)
In-Reply-To: <1514808421-21993-2-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Gilad,

On Mon, Jan 1, 2018 at 1:06 PM, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> Replace verbatim GPL v2 copy with SPDX tag.
>
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>

<snip>

> --- a/drivers/staging/ccree/cc_crypto_ctx.h
> +++ b/drivers/staging/ccree/cc_crypto_ctx.h
> @@ -1,18 +1,5 @@
> -/*
> - * Copyright (C) 2012-2017 ARM Limited or its affiliates.
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, see <http://www.gnu.org/licenses/>.
> - */
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (C) 2012-2017 ARM Limited or its affiliates.
>

For a .h file the style should be C comments as explained in Thomas
doc patches. .e.g.

> +/* SPDX-License-Identifier: GPL-2.0 */

And then it might makes sense there too:

> +/* Copyright (C) 2012-2017 ARM Limited or its affiliates. */

-- 
Cordially
Philippe Ombredanne
