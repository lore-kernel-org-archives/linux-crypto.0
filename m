From: Sonic Zhang <sonic.adi@gmail.com>
Subject: Re: [PATCH 2/2] crypto: bfin_crc: avoid get physical address of
 coherence memory by dma_map_single
Date: Mon, 14 Apr 2014 12:41:31 +0800
Message-ID: <CAJxxZ0Ox0SJz0TYth2oUoo967Db-ZtfP1uhUatbWSiEaLXfA3A@mail.gmail.com>
References: <1397119259-20638-1-git-send-email-sonic.adi@gmail.com>
	<1397119259-20638-2-git-send-email-sonic.adi@gmail.com>
	<201404101102.51947.marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org,
	adi-buildroot-devel@lists.sourceforge.net,
	Sonic Zhang <sonic.zhang@analog.com>
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:54717 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbaDNElb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 14 Apr 2014 00:41:31 -0400
Received: by mail-ob0-f176.google.com with SMTP id wp18so8454726obc.21
        for <linux-crypto@vger.kernel.org>; Sun, 13 Apr 2014 21:41:31 -0700 (PDT)
In-Reply-To: <201404101102.51947.marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

Could you please review this patch?

Thanks

Sonic Zhang


On Thu, Apr 10, 2014 at 5:02 PM, Marek Vasut <marex@denx.de> wrote:
> On Thursday, April 10, 2014 at 10:40:59 AM, Sonic Zhang wrote:
>> From: Sonic Zhang <sonic.zhang@analog.com>
>>
>> - The 4-byte sg_mid_buf is located in the middle of the coherence memory
>> sg_cpu. Don't call dma_map_single to get its physical address. Get the its
>> base physical address from the physical address of sg_cpu instead.
>> - Should set up the dma descriptor data after the 4-byte sg_mid_buf is
>> filled in completely from next sg buffer.
>> - memory copy from sg buffer should be done via virtual address.
>> - Remove unused reference to blackfin header
>>
>> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
>
> I don't see any obvious problems,
>
> Reviewed-by: Marek Vasut <marex@denx.de>
>
> Best regards,
> Marek Vasut
