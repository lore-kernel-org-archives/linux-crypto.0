From: Philippe Ombredanne <pombredanne@nexb.com>
Subject: Re: [PATCH v2 01/27] staging: ccree: SPDXify driver
Date: Wed, 3 Jan 2018 16:01:20 +0100
Message-ID: <CAOFm3uGDz+ZXfST=dHO3H-WqeudxWEovc=jngvBfX_KHPV9e_w@mail.gmail.com>
References: <1514986544-5888-1-git-send-email-gilad@benyossef.com> <1514986544-5888-2-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ofir Drang <ofir.drang@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        Thomas Gleixner <tglx@linutronix.de>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1514986544-5888-2-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Gilad,

On Wed, Jan 3, 2018 at 2:35 PM, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
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
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */

Thank you for using the SPDX tags!

Now, while I appreciate your attempt to use the latest and greatest
SPDX license id definitions (published by SPDX a few days agao), THIS
IS NOT a welcomed initiative. Please stick instead to use ONLY the
SPDX license ids that are defined in Thomas doc patches [1]: e.g. use
instead:  SPDX-License-Identifier: GPL-2.0 and please DO NOT USE
GPL-2.0-only for now.

The rationale is simple: from a kernel standpoint we cannot depend on
the latest changes of an external spec such as SPDX (and I am involved
with SPDX alright but I am wearing a kernel hat here). This is why
things have been carefully documented for the kernel proper by Thomas.
It is perfectly fine at some times in the future to adopt the newest
license ids, but this will have to happen in an orderly fashion with a
proper doc update and the eventual tree-wide changes to update every
occurrence. This cannot happen any other way or this would defeat the
whole purpose to have clear licensing kernel-wide: using the latest
and greatest introduces variations and creates a mess that we want to
avoid in the first place.

CC: Thomas Gleixner <tglx@linutronix.de>

[1] https://lkml.org/lkml/2017/12/28/323

-- 
Cordially
Philippe Ombredanne
