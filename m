Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FB90C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Nov 2021 08:28:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1A5661265
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Nov 2021 08:28:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244532AbhKRIb4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Nov 2021 03:31:56 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:38791 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244585AbhKRIby (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Nov 2021 03:31:54 -0500
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id E872622175;
        Thu, 18 Nov 2021 09:28:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1637224132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MM/MKnr66FysbEVAl0Bh+I3iD5eucedIYKU365Tgjis=;
        b=Q01LVOEh3GP2wNlyCIdnPnIHsZC1Nvj4g8G5Mgc47CKK/ld8jamsSA8q7d1ZsBP7h0Nx2V
        1WHAxBQQzUTaA8WwcEUi+x+eLXT5zCbiLL6NKpO4U1c8cNfRxVvC7k68b2sNaPneMIK2wD
        Sf08K0R0hNuvAPZhT2Qnmr0ZqmeU+vE=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 18 Nov 2021 09:28:50 +0100
From:   Michael Walle <michael@walle.cc>
To:     =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     ZHIZHIKIN Andrey <andrey.zhizhikin@leica-geosystems.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v2 2/2] crypto: caam - check jr permissions before probing
In-Reply-To: <59c04d9d-7acf-5468-1382-ce22bff8292d@nxp.com>
References: <20211104162114.2019509-1-andrey.zhizhikin@leica-geosystems.com>
 <20211111164601.13135-1-andrey.zhizhikin@leica-geosystems.com>
 <20211111164601.13135-3-andrey.zhizhikin@leica-geosystems.com>
 <e8456cc0bb9e4fc306e8188c5bd666d0@walle.cc>
 <AM6PR06MB46914ECA12815ABFCE8C1A59A6989@AM6PR06MB4691.eurprd06.prod.outlook.com>
 <59c04d9d-7acf-5468-1382-ce22bff8292d@nxp.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <144f646753cb6e0c7818dfaf116b5d54@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Horia,

>>>> Job Rings can be set to be exclusively used by TrustZone which makes
>>>> the access to those rings only possible from Secure World. This 
>>>> access
>>>> separation is defined by setting bits in CAAM JRxDID_MS register. 
>>>> Once
>>>> reserved to be owned by TrustZone, this Job Ring becomes unavailable
>>>> for the Kernel. This reservation is performed early in the boot
>>>> process, even before the Kernel starts, which leads to 
>>>> unavailability
>>>> of the HW at the probing stage. Moreover, the reservation can be 
>>>> done
>>>> for any Job Ring and is not under control of the Kernel.
>>>> 
>>>> Current implementation lists Job Rings as child nodes of CAAM 
>>>> driver,
>>>> and tries to perform probing on those regardless of whether JR HW is
>>>> accessible or not.
>>>> 
>>>> This leads to the following error while probing:
>>>> [    1.509894] caam 30900000.crypto: job rings = 3, qi = 0
>>>> [    1.525201] caam_jr 30901000.jr: failed to flush job ring 0
>>>> [    1.525214] caam_jr: probe of 30901000.jr failed with error -5
>>>> 
>>>> Implement a dynamic mechanism to identify which Job Ring is actually
>>>> marked as owned by TrustZone, and fail the probing of those child
>>>> nodes with -ENODEV.
>>> 
>>> For other reviewers/maintainers: I'm still not sure this is the way 
>>> to go. Instead
>>> one can let u-boot fix up the device tree and remove or disable the 
>>> JR node if its
>>> not available.
>> 
>> Just as further clarification: this patch is intended to accommodate 
>> for cases where
>> JR is claimed in S world at the boot and not available for Kernel. It 
>> does not account
>> for fully dynamic cases, where JRs can be reclaimed between S <-> NS 
>> Worlds
>> during runtime. It rather accounts for situation when any arbitrary JR 
>> can be reserved
>> by any software entity before Kernel starts without a need to disable 
>> nodes at
>> compile time.
>> 
> I prefer f/w to fix the DT before passing it to the kernel,
> either by adding the "secure-status" property (set explicitly to 
> "disabled")
> or by removing the job ring node(s) that are reserved.
> OP-TEE already uses the first option. We should probably pick this up.

Ah, nice:
Documentation/devicetree/bindings/arm/secure.txt

If I understand this correctly, if optee reserves a JR it will set the
secure-status to okay and status to disabled. (There is still a missing
link, how u-boot will then be passed this modified device tree, I might
miss something here.)

But what about the HAB, if I understand Andrey correct, then JR0 will
already be marked as "S world only" (or at least no EL3 program will
release it again). To me it looks like then either JR0 should be
(1) hardcoded to secure-status = "okay", status = "disabled", or (2)
u-boot SPL (or TF-A) should return it to NS world (and optee might
take it over again).

> The reason I am supporting relying on DT and consequently avoiding 
> registers
> is that accessing page 0 in the caam register space from Non-secure 
> world
> should be avoided when caam is managed by Secure world (e.g. OP-TEE)
> or a Secure Enclave (e.g. SECO).
> 
> Unfortunately support for HW-enforced access control for caam register 
> space
> is not that great / fine-grained, with the exception of more recent 
> parts
> like i.MX8MP and i.MX8ULP.

-michael
