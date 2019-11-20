Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5F01C43215
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 16:17:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCAB7206F4
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 16:17:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="JZhc2sET"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729436AbfKTQRP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 11:17:15 -0500
Received: from mout.gmx.net ([212.227.15.19]:56695 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729397AbfKTQRP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 11:17:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1574266609;
        bh=RI4Q4Ucrk+rlZ3lrnsF6lENBGO63UxXhYlY8pNz55u0=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=JZhc2sETppPeNxuagIr8jg0GNhX5QOvzodBK8qzSBAqsY3hSGqGHqp5zfmSfhQYfM
         QOtSuRtkxMtXYQeWvs6d6GUxAiBWh3A+khv2Pj0fLVvByrtiBGZNg9/L2FrkbepjGB
         /HR8jwsH1mJCnhFPJKHxm+axfWGnIPS2rVhrIOcU=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.1.176] ([37.4.249.139]) by mail.gmx.com (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MDhlV-1ifObe2TmZ-00Anrf; Wed, 20
 Nov 2019 17:16:49 +0100
Subject: Re: [PATCH v3 0/4] Raspberry Pi 4 HWRNG Support
To:     Stephen Brennan <stephen@brennan.io>
Cc:     Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Scott Branden <sbranden@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, Ray Jui <rjui@broadcom.com>,
        linux-kernel@vger.kernel.org, Eric Anholt <eric@anholt.net>,
        Rob Herring <robh+dt@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com,
        Stefan Wahren <wahrenst@gmx.net>,
        Matt Mackall <mpm@selenic.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-crypto@vger.kernel.org
References: <20191120031622.88949-1-stephen@brennan.io>
From:   Stefan Wahren <wahrenst@gmx.net>
Message-ID: <99554159-6abb-6ea5-aebb-57a148a59b78@gmx.net>
Date:   Wed, 20 Nov 2019 17:16:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191120031622.88949-1-stephen@brennan.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Provags-ID: V03:K1:Z9dBjSZwZ2+O3WL2mwvh7agX4F2+npux6rP0HzJz7C0nP+tDAMC
 KQzPq0eTXEAk9jVgOlqT8vP2wmxww6+SUCR9j1HBLAIgFW3b28LVkdn2TThDIbufs4MFABI
 PMatIzczHcXblJkesfLPKedLAo8DOnWNpg9EkujbzNGC3T5LEsVijcyJMCB6r7amPqxqaRG
 uLGpUk3EeLHzdfwOP9now==
X-UI-Out-Filterresults: notjunk:1;V03:K0:5jm9EYJO6bY=:myZF3slHJKl7WcF+aZXrdv
 MgzqvkteRURkYoUDmr+zhXM8Cfd8ghxg9jmh9hyLzE9+8Q9KavSc1UG0QJ8hxjle5WGnUKVHK
 fKWCm6Ka4PZUDypiw3/YmkJUWhwRsbigBECPDSQuzqJMXNoGMRU62rju/vmAlfCg6Y1KiGzH4
 es3vDusm6E59LFb05pmgjzDxRujv2M7xhtluZL4YX0DlslM95u8ZYRE7OsiGrM2UCL0RqNzlT
 M8ifb2Ol9A8emo7KVEsOUUc8b9Uqm0+JsveriLwGxachpE8h9nNB7UgMFwKiUmcrwhDFscfXs
 GmmC/VpQwr3a5pTX96NLWmuMXs94/vv19fcYsYSoy6BnWTf4ltERN7trSWpv27SlICn5jdVXJ
 k2bBlP8AJ3VITdGXEU2avbDAo23Cj7Gq4OUI3nsoN8XyIrdMSd08eQq/SnknmfI70QaPeKvLH
 rb2bA/tyy/SEy5UFTtkdXwcn8Rpw5kHbiiKiHPSbGvvedGZNomEVvUX/huJva/BdjY/tHSp0H
 EYERBhEXtg7rJIwpho2iba2QK6/+yjQJtm9oeMs2pBYBoYxME8weJrkeluI6LEYzRXdnG+qAM
 Zs2i+kBP3soYllo1WO3rnAywiD4+rLV8f+Oee5tAGOVprH7VURS4EluS6RBXPRzY2mmEcUUDH
 6vYBbBPu+ImtteiqKFs8rnvDnLVCba4X3PWLw7yjPc4RYEPkekKrvNuPinzW7vZFTlP0TSTZ1
 2urMBcgpk3RMiMAfXCIv1xVZYqiNF+cXCxEeUDR+LHCBsxBJRej0sYGt38L3ag3h1CSfPiuku
 gFzNGnoRfmOF8ktdn9KttnqLOqdDWUEYic/zmq3KGBVbgSm4AQgbDIky94lLUHuOIb3yo62Di
 lQnZievyT6r8Ku917SF3uaIL+70xnPlDNHV3if6OU8pFGDRqDWO5idKbvk280eEzuSDt+suQC
 g8i52ah/wHqPLXN6PDOFzI3ibwPDNPw7Oi/OLEWQ30KzmOpLzCIIQ5qPm0RojztSaYL2tePij
 GpF2lpg/RoNv+Ye83qNHQ557QuhEdCSsQ0XoQ5gTcrQXVtIhscclS989HwsnPkIiTxri0kxGs
 aXSc/f8jrfXCSkO5yq0iRJuOuLMIJSinfmQwjBZ7+LL+QcSx8VK8TH2pK34W9jBeIOou/q912
 UqALb5FoZBqGP6VAUMg6Hj+hPa8vXI3cs9XDTc5aOO5/ZKpfEganNQjC3hYdE/XkpGgWBsKOK
 VyKzPak831kNwWM8s/4oVjFofoAopFNktmQv9KHR4qWWwFAJBNPC+6Yltf6g=
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Stephen,

Am 20.11.19 um 04:16 schrieb Stephen Brennan:
> This patch series enables support for the HWRNG included on the Raspberry
> Pi 4.  It is simply a rebase of Stefan's branch [1]. I went ahead and
> tested this out on a Pi 4.  Prior to this patch series, attempting to use
> the hwrng gives:
>
>     $ head -c 2 /dev/hwrng
>     head: /dev/hwrng: Input/output error
>
> After this series, the same command gives two random bytes.

just a note: a more expressive test would be running rngtest (package
rng-tools) on this device.

Regards
Stefan


