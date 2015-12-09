From: Rameshwar Sahu <rsahu@apm.com>
Subject: Re: [PATCH v2 0/3] dmaengine: Add supports for APM X-Gene SoC CRC32C
 accerlerator driver
Date: Wed, 9 Dec 2015 14:13:32 +0530
Message-ID: <CAFd313z3zaXMAgKWa9KwQw1QxU4LuW_uoAz5_=42viYk2zaaOA@mail.gmail.com>
References: <rsahu@apm.com>
	<1447665169-14003-1-git-send-email-rsahu@apm.com>
	<CAFd313yzBgWhTD2+Lz+RsdziAuc2kdZPS1L2FExET5sLirs_DQ@mail.gmail.com>
	<20151209082748.GA26696@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: davem@davemloft.net, Vinod Koul <vinod.koul@intel.com>,
	dan.j.williams@intel.com, dmaengine@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	jcm@redhat.com, patches@apm.com, linux-crypto@vger.kernel.org,
	Kaustubh Gondkar <kgondkar@apm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:35271 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbbLIInd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Dec 2015 03:43:33 -0500
Received: by ioc74 with SMTP id 74so51695962ioc.2
        for <linux-crypto@vger.kernel.org>; Wed, 09 Dec 2015 00:43:32 -0800 (PST)
In-Reply-To: <20151209082748.GA26696@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 9, 2015 at 1:57 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Wed, Dec 09, 2015 at 01:55:55PM +0530, Rameshwar Sahu wrote:
>>
>> Any comments on above patch ??
>
> My concern that there aren't going to be any in-kernel users remains.
Yes, we are not upstream in-kernel users right now, but later client
ma upstream there patches.

>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
