From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Subject: Re: Duplicated module names
Date: Fri, 29 Jan 2016 17:08:22 -0200
Message-ID: <CAKi4VAJ8S8HxoVgonmAKiCkWstvHpBVCx4jFtuqCkPvOEHk-nw@mail.gmail.com>
References: <56A91B6A.2060205@oracle.com> <CAKi4VA+MC=hXMQ2kHi4_Xv2w7qQcG443zj9+rKo_JKoSzgDvYQ@mail.gmail.com>
 <56AA98D6.7020305@oracle.com> <CAKi4VAKF-Ywm=VK4wzDdr-O0Fi8Gv8X--CQcJ4FFia0Gu1Xaeg@mail.gmail.com>
 <87h9hxrkvs.fsf@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Samson Yeung <samson.yeung@oracle.com>,
	linux-modules <linux-modules@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, David Airlie <airlied@linux.ie>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yk0-f177.google.com ([209.85.160.177]:33350 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbcA2TIm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Jan 2016 14:08:42 -0500
In-Reply-To: <87h9hxrkvs.fsf@rustcorp.com.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi!

On Fri, Jan 29, 2016 at 3:54 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Lucas De Marchi <lucas.de.marchi@gmail.com> writes:
>> Hi!
>>
>> CC'ing Rusty and mailing lists
>
> Thanks.
>
>> Rusty and ohers: it looks like both CONFIG_CRC32 and
>> CONFIG_CRYPTO_CRC32 can be compiled as module, and they generate
>> modules with the same name, crc32.  Could that be fixed?
>
> Gah.  Looks like it's been that way since at least 2014, too.
>
> I think we could rename it to crypto_crc32, but I don't think it's the
> only one.  Marco, I think depmod should probably FAIL if two modules
> have the same name, which would at least find such problems.

Yes, I'll do that on kmod, but we need to pay attention to 2 things:

  - It's possible 2 modules with the same names if they come from
different locations (with different priorities)
  - It doesn't fix the case in which one is a module and the other is
builtin. We could still have problem with such a scenario, like was
pointed out in this bug report to kmod.


Lucas De Marchi
