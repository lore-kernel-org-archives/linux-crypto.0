Return-Path: <SRS0=vjnc=7P=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51FF1C433E0
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jun 2020 13:33:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38AE1206E2
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jun 2020 13:33:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbgFBNdf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jun 2020 09:33:35 -0400
Received: from disco-boy.misterjones.org ([51.254.78.96]:54436 "EHLO
        disco-boy.misterjones.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgFBNdf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jun 2020 09:33:35 -0400
X-Greylist: delayed 1835 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Jun 2020 09:33:34 EDT
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@misterjones.org>)
        id 1jg6Z5-00HBxM-LQ; Tue, 02 Jun 2020 14:02:47 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 02 Jun 2020 14:02:47 +0100
From:   Marc Zyngier <maz@misterjones.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Neal Liu <neal.liu@mediatek.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sean Wang <sean.wang@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, wsd_upstream@mediatek.com,
        Rob Herring <robh+dt@kernel.org>,
        linux-mediatek@lists.infradead.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Crystal Guo <Crystal.Guo@mediatek.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Re: Security Random Number Generator support
In-Reply-To: <CAMj1kXHjAdk5=-uSh_=S9j5cz42zr3h6t+YYGy+obevuQDp0fg@mail.gmail.com>
References: <1591085678-22764-1-git-send-email-neal.liu@mediatek.com>
 <CAMj1kXHjAdk5=-uSh_=S9j5cz42zr3h6t+YYGy+obevuQDp0fg@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <85dfc0142d3879d50c0ba18bcc71e199@misterjones.org>
X-Sender: maz@misterjones.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: ardb@kernel.org, neal.liu@mediatek.com, devicetree@vger.kernel.org, herbert@gondor.apana.org.au, arnd@arndb.de, gregkh@linuxfoundation.org, sean.wang@kernel.org, linux-kernel@vger.kernel.org, wsd_upstream@mediatek.com, robh+dt@kernel.org, linux-mediatek@lists.infradead.org, linux-crypto@vger.kernel.org, mpm@selenic.com, matthias.bgg@gmail.com, Crystal.Guo@mediatek.com, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2020-06-02 13:14, Ard Biesheuvel wrote:
> On Tue, 2 Jun 2020 at 10:15, Neal Liu <neal.liu@mediatek.com> wrote:
>> 
>> These patch series introduce a security random number generator
>> which provides a generic interface to get hardware rnd from Secure
>> state. The Secure state can be Arm Trusted Firmware(ATF), Trusted
>> Execution Environment(TEE), or even EL2 hypervisor.
>> 
>> Patch #1..2 adds sec-rng kernel driver for Trustzone based SoCs.
>> For security awareness SoCs on ARMv8 with TrustZone enabled,
>> peripherals like entropy sources is not accessible from normal world
>> (linux) and rather accessible from secure world (HYP/ATF/TEE) only.
>> This driver aims to provide a generic interface to Arm Trusted
>> Firmware or Hypervisor rng service.
>> 
>> 
>> changes since v1:
>> - rename mt67xx-rng to mtk-sec-rng since all MediaTek ARMv8 SoCs can 
>> reuse
>>   this driver.
>>   - refine coding style and unnecessary check.
>> 
>>   changes since v2:
>>   - remove unused comments.
>>   - remove redundant variable.
>> 
>>   changes since v3:
>>   - add dt-bindings for MediaTek rng with TrustZone enabled.
>>   - revise HWRNG SMC call fid.
>> 
>>   changes since v4:
>>   - move bindings to the arm/firmware directory.
>>   - revise driver init flow to check more property.
>> 
>>   changes since v5:
>>   - refactor to more generic security rng driver which
>>     is not platform specific.
>> 
>> *** BLURB HERE ***
>> 
>> Neal Liu (2):
>>   dt-bindings: rng: add bindings for sec-rng
>>   hwrng: add sec-rng driver
>> 
> 
> There is no reason to model a SMC call as a driver, and represent it
> via a DT node like this.

+1.

> It would be much better if this SMC interface is made truly generic,
> and wired into the arch_get_random() interface, which can be used much
> earlier.

Wasn't there a plan to standardize a SMC call to rule them all?

         M.
-- 
Who you jivin' with that Cosmik Debris?
