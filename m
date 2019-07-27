Return-Path: <SRS0=7d9E=VY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BB30C433FF
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Jul 2019 12:17:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 463E42085A
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Jul 2019 12:17:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="cG6Q289S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728838AbfG0MRv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 27 Jul 2019 08:17:51 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:41339 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728797AbfG0MRu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 27 Jul 2019 08:17:50 -0400
Received: by mail-oi1-f193.google.com with SMTP id g7so42149640oia.8;
        Sat, 27 Jul 2019 05:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CNhzHRz2iYbGXTP3IdkSPFEl3dlcBhQ0pu5ysWhbMII=;
        b=cG6Q289SNMExyqzT4BzCmFr+agW8QLE1G4qTS2lsKXwVxXNT3vnliR9NUCiJkWb4xa
         vv0mIgP2g9+350JqUUFYxCyArFuss1h1e6tua1+bGGeJIhxODu3Ca8AYeU1w9FP/v8iI
         MhZRHQjeTZU9ZhOSTQHw5+MavL3KVbpg3gYGy75V492PRmtmOQP1h0HsWUIrqQYsJEE6
         VGA92fXomnLb+NbLAV1HnkMtcWqbTipnp/jgiQRN2/fkFoHYEBEpHZX99vlLQQe95XU+
         zY7eAKlSeOxuKctyhesPANP5vpf2YzPuKkrEdLbrHf10PIAjG8cms8yoMCAMLto5iGBG
         3UHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CNhzHRz2iYbGXTP3IdkSPFEl3dlcBhQ0pu5ysWhbMII=;
        b=XurtJnElZr6EQ9oVtfq357hi7cGXNm6F+PzYj8QczJ1AGjHrFfWO/SV9DwdBrw/NPY
         vXHH6MMj0j/2ZX0hvN6xtjK8T+M/utgWJSFES5RDs4Mz9mnisOi59zhreO6N6Fwq7uar
         k6GVWyP/WuumGDYZXw7svprGUHoC6qM38Z3BN+Pjqdj6X0VLKoTMGfHAklwHbw6VA2Ws
         mkY++fhUvF7sggK+819SwOg1DpPBXgHMLchsQkNvVovsQJLBPdjrAQJAYxE+kL6r43lD
         rKTl3/gD+0Pv2artgkmxloXI56kSdfUmrDHBS7E48V/bXwwMXDG7sUB7F8E46LCNjPuS
         NG1A==
X-Gm-Message-State: APjAAAUlx8qCb+pO9jOKChq0Nsggo1kML90SXEXEFdWMIoaiNpvYT1i/
        fl840f6lfLmhp/IL4gKVu8uojdfkIVqorTYOQV7Xow==
X-Google-Smtp-Source: APXvYqwYmHppUXdfjPmHAHr52sRX654Hjj0LrUImUSO2z34wUj15h3dYIjxdcEN6XIljQQh4wx43Te/Ly0JritXHa9A=
X-Received: by 2002:aca:4ad2:: with SMTP id x201mr48673019oia.129.1564229869688;
 Sat, 27 Jul 2019 05:17:49 -0700 (PDT)
MIME-Version: 1.0
References: <1564083776-20540-1-git-send-email-clabbe@baylibre.com> <1564083776-20540-3-git-send-email-clabbe@baylibre.com>
In-Reply-To: <1564083776-20540-3-git-send-email-clabbe@baylibre.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sat, 27 Jul 2019 14:17:38 +0200
Message-ID: <CAFBinCD7pgUaBJgeGHTOu-uZRA9a6K2kxPsu+huKe23wcnKPoA@mail.gmail.com>
Subject: Re: [PATCH 2/4] crypto: amlogic: Add crypto accelerator for amlogic GXL
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        khilman@baylibre.com, mark.rutland@arm.com, robh+dt@kernel.org,
        devicetree@vger.kernel.org, baylibre-upstreaming@groups.io,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Corentin,

it's great to see you working on this :)

On Thu, Jul 25, 2019 at 9:45 PM Corentin Labbe <clabbe@baylibre.com> wrote:
>
> This patch adds support for the amlogic GXL cryptographic offloader present
> on GXL SoCs.
>
> This driver supports AES cipher in CBC/ECB mode.
>
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>  drivers/crypto/Kconfig                  |   2 +
>  drivers/crypto/Makefile                 |   1 +
>  drivers/crypto/amlogic/Kconfig          |  24 ++
>  drivers/crypto/amlogic/Makefile         |   2 +
>  drivers/crypto/amlogic/amlogic-cipher.c | 358 ++++++++++++++++++++++++
>  drivers/crypto/amlogic/amlogic-core.c   | 326 +++++++++++++++++++++
>  drivers/crypto/amlogic/amlogic.h        | 172 ++++++++++++
>  7 files changed, 885 insertions(+)
>  create mode 100644 drivers/crypto/amlogic/Kconfig
>  create mode 100644 drivers/crypto/amlogic/Makefile
>  create mode 100644 drivers/crypto/amlogic/amlogic-cipher.c
>  create mode 100644 drivers/crypto/amlogic/amlogic-core.c
>  create mode 100644 drivers/crypto/amlogic/amlogic.h
there are two different crypto IPs on Amlogic SoCs:
- GXL and newer use the "BLKMV" crypto IP
- GXBB, Meson8/Meson8b/Meson8m2 (and probably older SoCs) use the
"NDMA" crypto IP

personally I think it makes sense to either have the IP name (blkmv)
or SoC name (GXL) in the file or directory names as well as being
consistent with that in the Kconfig option names

(I have no experience with the crypto framework so I cannot comment on
the driver implementation itself)


Martin
