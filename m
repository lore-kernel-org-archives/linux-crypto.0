From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH 01/26] staging: ccree: SPDXify driver
Date: Mon, 1 Jan 2018 16:11:44 +0200
Message-ID: <CAOtvUMdGadirO-HSJfmXPPPssd5EZWKjUpL=eGK-+qFCe5OeFQ@mail.gmail.com>
References: <1514808421-21993-1-git-send-email-gilad@benyossef.com>
 <1514808421-21993-2-git-send-email-gilad@benyossef.com> <CAOFm3uG6CGxPt4u=vk5DxM-hLmyvaiwhz4wxK2SzJfzyr6K4ig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ofir Drang <ofir.drang@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Philippe Ombredanne <pombredanne@nexb.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ot0-f182.google.com ([74.125.82.182]:38200 "EHLO
        mail-ot0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751200AbeAAOLp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Jan 2018 09:11:45 -0500
Received: by mail-ot0-f182.google.com with SMTP id a42so19654547otj.5
        for <linux-crypto@vger.kernel.org>; Mon, 01 Jan 2018 06:11:45 -0800 (PST)
In-Reply-To: <CAOFm3uG6CGxPt4u=vk5DxM-hLmyvaiwhz4wxK2SzJfzyr6K4ig@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 1, 2018 at 3:53 PM, Philippe Ombredanne
<pombredanne@nexb.com> wrote:
> Gilad,
>
> On Mon, Jan 1, 2018 at 1:06 PM, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
>> Replace verbatim GPL v2 copy with SPDX tag.
>>
>> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
>
> <snip>
>
>> --- a/drivers/staging/ccree/cc_crypto_ctx.h
>> +++ b/drivers/staging/ccree/cc_crypto_ctx.h
>> @@ -1,18 +1,5 @@
>> -/*
>> - * Copyright (C) 2012-2017 ARM Limited or its affiliates.
>> - *
>> - * This program is free software; you can redistribute it and/or modify
>> - * it under the terms of the GNU General Public License version 2 as
>> - * published by the Free Software Foundation.
>> - *
>> - * This program is distributed in the hope that it will be useful,
>> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> - * GNU General Public License for more details.
>> - *
>> - * You should have received a copy of the GNU General Public License
>> - * along with this program; if not, see <http://www.gnu.org/licenses/>.
>> - */
>> +// SPDX-License-Identifier: GPL-2.0
>> +// Copyright (C) 2012-2017 ARM Limited or its affiliates.
>>
>
> For a .h file the style should be C comments as explained in Thomas
> doc patches. .e.g.
>
>> +/* SPDX-License-Identifier: GPL-2.0 */
>
> And then it might makes sense there too:
>
>> +/* Copyright (C) 2012-2017 ARM Limited or its affiliates. */

OK, missed that. I'll wait to see if there are any other review
comments and will send
a fixed patch set.

Thanks,
GIlad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
