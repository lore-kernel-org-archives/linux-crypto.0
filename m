Return-Path: <SRS0=RCNv=7Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57BA1C433DF
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jun 2020 11:12:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3692E2067B
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jun 2020 11:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591182729;
	bh=YzOMemc162MmX21grMM2woz3galEvoPugqrE5a3TFD8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=rOVDDNuZs7RKpaRRizEOMkchtuxm2V3AIC1CMFxjw9SopajzJf3iLzEFQdJ1A3Az3
	 KA5/EvWu2PoXEXP2/0RINpS0iHXYm2PuA7XzkVSqRXmTw1Y1bweSH3vO6vL94fEsA6
	 IJxw/JBVxrJ8JeGNcxiEhVOv81W0VSwzT7xwsY+g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbgFCLMI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jun 2020 07:12:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:57514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725833AbgFCLMI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jun 2020 07:12:08 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57EA8206C3;
        Wed,  3 Jun 2020 11:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591182727;
        bh=YzOMemc162MmX21grMM2woz3galEvoPugqrE5a3TFD8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VCecdmeYHrqT5gcinE0svjjnWovDvj6uzuTznngJAf93O0LV5n1J9DoWLJtEk9vv6
         0JAbXLvW79Wb3/N+75QFT30BcC7kfKT3VMjSG/UnSS7QAUN3pVQpc6LlZXKzk03LyZ
         ZetdVU8f9I1Kxws4imoEVWR93RtBzxSkFBKnQEO4=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jgRJV-00HQNN-OT; Wed, 03 Jun 2020 12:12:05 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 03 Jun 2020 12:12:05 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Neal Liu <neal.liu@mediatek.com>
Cc:     Julius Werner <jwerner@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sean Wang <sean.wang@kernel.org>,
        linux-mediatek@lists.infradead.org,
        lkml <linux-kernel@vger.kernel.org>,
        wsd_upstream <wsd_upstream@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        =?UTF-8?Q?Crystal_Guo_=28=E9=83=AD?= =?UTF-8?Q?=E6=99=B6=29?= 
        <Crystal.Guo@mediatek.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        mark.rutland@arm.com, Jose.Marinho@arm.com
Subject: Re: Security Random Number Generator support
In-Reply-To: <1591170857.19414.5.camel@mtkswgap22>
References: <1591085678-22764-1-git-send-email-neal.liu@mediatek.com>
 <CAMj1kXHjAdk5=-uSh_=S9j5cz42zr3h6t+YYGy+obevuQDp0fg@mail.gmail.com>
 <85dfc0142d3879d50c0ba18bcc71e199@misterjones.org>
 <1591169342.4878.9.camel@mtkswgap22>
 <fcbe37f6f9cbcde24f9c28bc504f1f0e@kernel.org>
 <1591170857.19414.5.camel@mtkswgap22>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <e56f0f8da7fdc836e073a37c9baeda77@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: neal.liu@mediatek.com, jwerner@google.com, ardb@kernel.org, devicetree@vger.kernel.org, herbert@gondor.apana.org.au, arnd@arndb.de, gregkh@linuxfoundation.org, sean.wang@kernel.org, linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org, wsd_upstream@mediatek.com, robh+dt@kernel.org, linux-crypto@vger.kernel.org, mpm@selenic.com, matthias.bgg@gmail.com, Crystal.Guo@mediatek.com, linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, Jose.Marinho@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2020-06-03 08:54, Neal Liu wrote:
> On Wed, 2020-06-03 at 08:40 +0100, Marc Zyngier wrote:
>> On 2020-06-03 08:29, Neal Liu wrote:

[...]

>> > Could you give us a hint how to make this SMC interface more generic in
>> > addition to my approach?
>> > There is no (easy) way to get platform-independent SMC function ID,
>> > which is why we encode it into device tree, and provide a generic
>> > driver. In this way, different devices can be mapped and then get
>> > different function ID internally.
>> 
>> The idea is simply to have *one* single ID that caters for all
>> implementations, just like we did for PSCI at the time. This
>> requires ARM to edict a standard, which is what I was referring
>> to above.
>> 
>> There is zero benefit in having a platform-dependent ID. It just
>> pointlessly increases complexity, and means we cannot use the RNG
>> before the firmware tables are available (yes, we need it that
>> early).
>> 
>>          M.
> 
> Do you know which ARM expert could edict this standard?
> Or is there any chance that we can make one? And be reviewed by
> maintainers?

Sudeep already mentioned Jose's effort to offer a standard.
Hopefully he will *soon* be able to give us something that can be
implemented everywhere (firmware, kernel, but also hypervisors),
as the need exists across the whole stack.

         M.
-- 
Jazz is not dead. It just smells funny...
