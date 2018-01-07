From: Philippe Ombredanne <pombredanne@nexb.com>
Subject: Re: [PATCH v2 01/27] staging: ccree: SPDXify driver
Date: Sun, 7 Jan 2018 17:16:21 +0100
Message-ID: <CAOFm3uEfLqvLtvLdj3Fq___EDhQnZn_d-W69Uv3GOKQu8AA51Q@mail.gmail.com>
References: <1514986544-5888-1-git-send-email-gilad@benyossef.com>
 <1514986544-5888-2-git-send-email-gilad@benyossef.com>
 <CAOFm3uGDz+ZXfST=dHO3H-WqeudxWEovc=jngvBfX_KHPV9e_w@mail.gmail.com>
 <CAOtvUMf94rqwtTAXqc8Xd3YwvRiinc4jA8wOQmg95QJ0L=BxAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 driverdev-devel@linuxdriverproject.org, LKML <linux-kernel@vger.kernel.org>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <CAOtvUMf94rqwtTAXqc8Xd3YwvRiinc4jA8wOQmg95QJ0L=BxAA@mail.gmail.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

Gilad,

On Sun, Jan 7, 2018 at 11:13 AM, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> On Wed, Jan 3, 2018 at 5:01 PM, Philippe Ombredanne
> <pombredanne@nexb.com> wrote:
>> Gilad,
>>
>> On Wed, Jan 3, 2018 at 2:35 PM, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
>>> Replace verbatim GPL v2 copy with SPDX tag.
>>>
>>> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
>>
>> <snip>
>>
>>> --- a/drivers/staging/ccree/cc_crypto_ctx.h
>>> +++ b/drivers/staging/ccree/cc_crypto_ctx.h
>>> @@ -1,18 +1,5 @@
>>> -/*
>>> - * Copyright (C) 2012-2017 ARM Limited or its affiliates.
>>> - *
>>> - * This program is free software; you can redistribute it and/or modify
>>> - * it under the terms of the GNU General Public License version 2 as
>>> - * published by the Free Software Foundation.
>>> - *
>>> - * This program is distributed in the hope that it will be useful,
>>> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>> - * GNU General Public License for more details.
>>> - *
>>> - * You should have received a copy of the GNU General Public License
>>> - * along with this program; if not, see <http://www.gnu.org/licenses/>.
>>> - */
>>> +/* SPDX-License-Identifier: GPL-2.0-only */
>>> +/* Copyright (C) 2012-2018 ARM Limited or its affiliates. */
>>
>> Thank you for using the SPDX tags!
>>
>> Now, while I appreciate your attempt to use the latest and greatest
>> SPDX license id definitions (published by SPDX a few days agao), THIS
>> IS NOT a welcomed initiative. Please stick instead to use ONLY the
>> SPDX license ids that are defined in Thomas doc patches [1]: e.g. use
>> instead:  SPDX-License-Identifier: GPL-2.0 and please DO NOT USE
>> GPL-2.0-only for now.
>
> Oh dear. It seems I have been over enthusiastic with this.
> I shall post a revised  patch set. Sorry for the noise.
>
>>
>> The rationale is simple: from a kernel standpoint we cannot depend on
>> the latest changes of an external spec such as SPDX (and I am involved
>> with SPDX alright but I am wearing a kernel hat here). This is why
>> things have been carefully documented for the kernel proper by Thomas.
>> It is perfectly fine at some times in the future to adopt the newest
>> license ids, but this will have to happen in an orderly fashion with a
>> proper doc update and the eventual tree-wide changes to update every
>> occurrence. This cannot happen any other way or this would defeat the
>> whole purpose to have clear licensing kernel-wide: using the latest
>> and greatest introduces variations and creates a mess that we want to
>> avoid in the first place.
>>
>> CC: Thomas Gleixner <tglx@linutronix.de>
>>
>> [1] https://lkml.org/lkml/2017/12/28/323
>>
>
> Just a thought - it might be useful to have an SPDX revision as part of the tag,
> e.g.
>
> SPDX-3.0-License-Identifier: GPL-2.0-only
>
> It seems it will make transitions such as this easier, me thinks.
>
> Maybe something to consider for SPDX 3.1 :-)

That would make things a tad more complicated on the contributor side
IMHO. Instead and since the reference is the kernel doc and nothing
else (and not the latest and greatest SPDX updates of last week),
there is no need to version things at all, we just need to rev up the
doc and tools when and if we update things with newer SPDX versions.

Consider this analogy:
When you use zlib in the kernel you can only use exactly the subset of
the zlib API that is vendored in the kernel. You cannot use a new zlib
function in the latest and greatest release of zlib without updating
the vendored version first.
Here Thomas's doc is exactly this: a subset of the SPDX and license
ids as used exactly in the kernel as of now and "vendored" in the
kernel through this doc. You cannot use anything outside of this short
of updating the doc, tools like checkpatch and _every_ place that
could be impacted by this doc update.

-- 
Cordially
Philippe Ombredanne
