Return-Path: <SRS0=MdlN=AN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC4F6C433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Jul 2020 08:58:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A02D32088E
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Jul 2020 08:58:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbgGBI6d (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jul 2020 04:58:33 -0400
Received: from mout.kundenserver.de ([217.72.192.74]:56067 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgGBI6d (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jul 2020 04:58:33 -0400
Received: from mail-qt1-f177.google.com ([209.85.160.177]) by
 mrelayeu.kundenserver.de (mreue108 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1Mo73N-1j2S442p8F-00pe9z; Thu, 02 Jul 2020 10:58:31 +0200
Received: by mail-qt1-f177.google.com with SMTP id g13so20623334qtv.8;
        Thu, 02 Jul 2020 01:58:31 -0700 (PDT)
X-Gm-Message-State: AOAM533Eg/P25auzgSikOYE2N0afRG5pz/O32/U4HxvA6kzoqNr4uMDD
        MEeb3YsRMnjVXJMJcb8hIHgz84qFUUx4buh4P1c=
X-Google-Smtp-Source: ABdhPJwmVhcWIjW9naHQ+EtJIo8qem6eHT7ix06ZnfalWEEgAsXZpi1xlLnmHrPnhvrb+Fee92Gc5bSzX/y8gl2q00Y=
X-Received: by 2002:ac8:33d7:: with SMTP id d23mr30244902qtb.204.1593680310449;
 Thu, 02 Jul 2020 01:58:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200701200950.30314-1-rikard.falkeborn@gmail.com>
In-Reply-To: <20200701200950.30314-1-rikard.falkeborn@gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 2 Jul 2020 10:58:14 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0iVY54EMWYDLdn3QoqmO0CkZMJk-P2G19epm8FCTX8bg@mail.gmail.com>
Message-ID: <CAK8P3a0iVY54EMWYDLdn3QoqmO0CkZMJk-P2G19epm8FCTX8bg@mail.gmail.com>
Subject: Re: [PATCH 0/5] drivers/char: Constify static variables
To:     Rikard Falkeborn <rikard.falkeborn@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Shah <amit@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Corey Minyard <minyard@acm.org>,
        virtualization@lists.linux-foundation.org,
        openipmi-developer@lists.sourceforge.net,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "moderated list:BROADCOM BCM2835 ARM ARCHITECTURE" 
        <linux-rpi-kernel@lists.infradead.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:X4WDxqLnMY//GuO5GkWcxG5AuR2KIVPWcsP0LiXl1LEXCZ8EhPQ
 ESfjxRT0AnrKWXL28Gu3ZH2M8e4Jwq/I8Rb5sesX1IWHBAmmJvrSlcoEsFbD+F/fZX7/qsC
 eQb/aAz0jQtrFR5gOSa2RRlhPNkvSI7Gk8ABDh/75Sv1FR8fzsHDNza9aHmbd1GKodowVGr
 gm+446HngpPd00YZjpKlw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:SzJyyVuymJs=:J+e7cacCsvkyKcF8v1hwuW
 VThheARzn/clwjOffSCydjROhCKUm2b6s8Pbs98ciwSatCWlTVxPvwBJ0esdhKyrZAXOYEbgV
 0hy/sHaxCVZaJ0q+YZc4C5ShJyR+E5rWr6D4OH4Zce7a+76PVHm6cMPKAXhSuH+PTqSlLL/sY
 oOfX5FhYgLhpYugRtRTJ3jwKENrKPLzRhLpXD6u4JKBVYaUtrcRbefC7zA/GS5y1ngkYmUrR3
 SodB2QCxqyrGqcD5ANuwQ8nSvSiyA/icR6AWJgkaTqcrpnnwH5zMJiG9Or9+OM6VkCxw/j2Mj
 /3qnSDQjugLk9ishsWCV9MBzljKJDF8uL9craFwvxtjhfbYWw6TkNJOJrenj0mepNuM+MMm5P
 unfgWbpfduAXruzJhHpI/4IG0vL8/0Ehms178iMS/HyL9Da/mkXOxv5JseiLxseUG4xnpczDU
 I7JKQuhOXFzz3rvLCmAKUbH7xw/mt3cCP6kf1QZ9wH1PFhdVgg8vuKSyF8V4z2CW9Rx2wA+AD
 KayNXRQNLCS/UPZbx2I8kcairQukkyfAvQXkAkx0Iaz31XJ3+CcHKH2o1hyVRwRcpiNI2Qxq6
 mcp3PjAjBz2xfhsFB+/cpFKetn7w0fO4n1FA8naWQbF5FBwaWISKUooGosxe8ICms6RUOithb
 6xssVY1ZAt9cWYPmmGaDfQBmCNreOXUVAY9bqym7zvujbrFS1/1K/6vAX+dCNSrmU2SZRh3p5
 Rj+wPLQ4ptsDN+FMAe58N3HRxqXZXckDaAytpxzbmxRtWoZhn34pCdWLMYI0eP+BMx5L3IIhr
 zzP+7p+I8pDxZQlfunLVQ4O+SUYtazgNul6lMnqezcpXzsUH5w=
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 1, 2020 at 11:48 PM Rikard Falkeborn
<rikard.falkeborn@gmail.com> wrote:
>
> Constify some static variables (mostly structs) that are not modified.
>
> Rikard Falkeborn (5):
>   hwrng: bcm2835 - Constify bcm2835_rng_devtype[]
>   hwrng: nomadik - Constify nmk_rng_ids[]
>   hwrng: virtio - Constify id_table[]
>   ipmi: watchdog: Constify ident
>   virtio_console: Constify some static variables

I just realized it was a series rather than a single patch I received. They
all look correct, so

Acked-by: Arnd Bergmann <arnd@arndb.de>

but if you do more of those, I would suggest not including the 'size'
output for the small variables as that is not the main point here.
