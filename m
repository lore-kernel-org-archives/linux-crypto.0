From: Sonic Zhang <sonic.adi@gmail.com>
Subject: Re: [PATCH v2] crypt: bfin_crc: access crc registers by readl and
 writel functions
Date: Mon, 14 Apr 2014 12:21:41 +0800
Message-ID: <CAJxxZ0PW-WerKp1XuEpU5PEBSsG1qwX5zMW83ZzyxoK8VC1e1w@mail.gmail.com>
References: <1397111456-17371-1-git-send-email-sonic.adi@gmail.com>
	<201404101001.34907.marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org,
	adi-buildroot-devel@lists.sourceforge.net,
	Sonic Zhang <sonic.zhang@analog.com>
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oa0-f48.google.com ([209.85.219.48]:40837 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbaDNEVl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 14 Apr 2014 00:21:41 -0400
Received: by mail-oa0-f48.google.com with SMTP id m1so8671441oag.35
        for <linux-crypto@vger.kernel.org>; Sun, 13 Apr 2014 21:21:41 -0700 (PDT)
In-Reply-To: <201404101001.34907.marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

Could you please review this patch?

Thanks

Sonic Zhang

On Thu, Apr 10, 2014 at 4:01 PM, Marek Vasut <marex@denx.de> wrote:
> On Thursday, April 10, 2014 at 08:30:56 AM, Sonic Zhang wrote:
>> From: Sonic Zhang <sonic.zhang@analog.com>
>>
>> Move architecture independant crc header file out of the blackfin folder.
>>
>>
>> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
>> ---
>> v2-changes:
>> - avoid combine the IO accessors into each other
>> - use readl/writel other than ioread32/iowrite32
>
> Reviewed-by: Marek Vasut <marex@denx.de>
>
> Best regards,
> Marek Vasut
