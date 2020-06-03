Return-Path: <SRS0=RCNv=7Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EDFFC433E4
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jun 2020 07:41:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DF1C2077D
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jun 2020 07:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591170066;
	bh=ASiJyN9vtoOKWIQVI9sRkrvMVRZLsH73CKMJEX/qka8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=18OI2AbRhcWpmY4ZFIEMDkngwIBVRxINIDwhdXtDO5Lwuz6WaBIc6LLCLhq6+SN4F
	 Oqdehab558yZbXQBUBNR7qyxYRSibd7xb3O3RECnLmKExzWCeSeVSIIewyjegCYjhh
	 JwzL0XDxyi1+sICK2CjLdkqXof2V7Y1MV4a8LfjU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbgFCHlB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jun 2020 03:41:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:41408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725275AbgFCHlB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jun 2020 03:41:01 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57CA12077D;
        Wed,  3 Jun 2020 07:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591170060;
        bh=ASiJyN9vtoOKWIQVI9sRkrvMVRZLsH73CKMJEX/qka8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hc1h9s4LbZy8hmvFTWK/zlCOn7hSVlKRz27xGeTt12B3JBMR28V/4L1nOZLJKgnnQ
         VxfYUAHUhtG2rHQ/PTOsl/4YTjQnUnh9og5RvTpYrv3nKjnVqj92/vVJ3aBZ87XxzD
         jCAxP/wLjitb6jqRTXIHTVqLVldSkYNOw6/XBdnM=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jgO1C-00HNfN-Oj; Wed, 03 Jun 2020 08:40:58 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 03 Jun 2020 08:40:58 +0100
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
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Re: Security Random Number Generator support
In-Reply-To: <1591169342.4878.9.camel@mtkswgap22>
References: <1591085678-22764-1-git-send-email-neal.liu@mediatek.com>
 <CAMj1kXHjAdk5=-uSh_=S9j5cz42zr3h6t+YYGy+obevuQDp0fg@mail.gmail.com>
 <85dfc0142d3879d50c0ba18bcc71e199@misterjones.org>
 <1591169342.4878.9.camel@mtkswgap22>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <fcbe37f6f9cbcde24f9c28bc504f1f0e@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: neal.liu@mediatek.com, jwerner@google.com, ardb@kernel.org, devicetree@vger.kernel.org, herbert@gondor.apana.org.au, arnd@arndb.de, gregkh@linuxfoundation.org, sean.wang@kernel.org, linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org, wsd_upstream@mediatek.com, robh+dt@kernel.org, linux-crypto@vger.kernel.org, mpm@selenic.com, matthias.bgg@gmail.com, Crystal.Guo@mediatek.com, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2020-06-03 08:29, Neal Liu wrote:
> On Tue, 2020-06-02 at 21:02 +0800, Marc Zyngier wrote:
>> On 2020-06-02 13:14, Ard Biesheuvel wrote:
>> > On Tue, 2 Jun 2020 at 10:15, Neal Liu <neal.liu@mediatek.com> wrote:
>> >>
>> >> These patch series introduce a security random number generator
>> >> which provides a generic interface to get hardware rnd from Secure
>> >> state. The Secure state can be Arm Trusted Firmware(ATF), Trusted
>> >> Execution Environment(TEE), or even EL2 hypervisor.
>> >>
>> >> Patch #1..2 adds sec-rng kernel driver for Trustzone based SoCs.
>> >> For security awareness SoCs on ARMv8 with TrustZone enabled,
>> >> peripherals like entropy sources is not accessible from normal world
>> >> (linux) and rather accessible from secure world (HYP/ATF/TEE) only.
>> >> This driver aims to provide a generic interface to Arm Trusted
>> >> Firmware or Hypervisor rng service.
>> >>
>> >>
>> >> changes since v1:
>> >> - rename mt67xx-rng to mtk-sec-rng since all MediaTek ARMv8 SoCs can
>> >> reuse
>> >>   this driver.
>> >>   - refine coding style and unnecessary check.
>> >>
>> >>   changes since v2:
>> >>   - remove unused comments.
>> >>   - remove redundant variable.
>> >>
>> >>   changes since v3:
>> >>   - add dt-bindings for MediaTek rng with TrustZone enabled.
>> >>   - revise HWRNG SMC call fid.
>> >>
>> >>   changes since v4:
>> >>   - move bindings to the arm/firmware directory.
>> >>   - revise driver init flow to check more property.
>> >>
>> >>   changes since v5:
>> >>   - refactor to more generic security rng driver which
>> >>     is not platform specific.
>> >>
>> >> *** BLURB HERE ***
>> >>
>> >> Neal Liu (2):
>> >>   dt-bindings: rng: add bindings for sec-rng
>> >>   hwrng: add sec-rng driver
>> >>
>> >
>> > There is no reason to model a SMC call as a driver, and represent it
>> > via a DT node like this.
>> 
>> +1.
>> 
>> > It would be much better if this SMC interface is made truly generic,
>> > and wired into the arch_get_random() interface, which can be used much
>> > earlier.
>> 
>> Wasn't there a plan to standardize a SMC call to rule them all?
>> 
>>          M.
> 
> Could you give us a hint how to make this SMC interface more generic in
> addition to my approach?
> There is no (easy) way to get platform-independent SMC function ID,
> which is why we encode it into device tree, and provide a generic
> driver. In this way, different devices can be mapped and then get
> different function ID internally.

The idea is simply to have *one* single ID that caters for all
implementations, just like we did for PSCI at the time. This
requires ARM to edict a standard, which is what I was referring
to above.

There is zero benefit in having a platform-dependent ID. It just
pointlessly increases complexity, and means we cannot use the RNG
before the firmware tables are available (yes, we need it that
early).

         M.
-- 
Jazz is not dead. It just smells funny...
