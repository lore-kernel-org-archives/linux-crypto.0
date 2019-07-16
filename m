Return-Path: <SRS0=wawN=VN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 993DAC76191
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Jul 2019 01:47:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A06D20659
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Jul 2019 01:47:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h8L1ji8E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729674AbfGPBqF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Jul 2019 21:46:05 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:46777 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729788AbfGPBqF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jul 2019 21:46:05 -0400
Received: by mail-io1-f66.google.com with SMTP id i10so37274599iol.13;
        Mon, 15 Jul 2019 18:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lcOqLDcreMJidT6TxGStHd1/we7cB4At6iFEHiI9lyU=;
        b=h8L1ji8ERTvM0ecYo9wKBJYy19r3QW5Vt8oL13Vdmp5dSOfRERQpwvUr14+QSE2F9B
         XilvFUTc/Teu/fSLt5PKOpVGXdLhvIPXg+RoWc5FF46tIp9J0uNL+6Biq5lix3RAIEwO
         OkK4E74fYuaFqZLg6hse57VhPW02EE3x7CIcBdCXAEk9sk7t+AO5eUc2SdqYxZNsM4Kj
         HsWlew1Y/ZlCcW55iYWamqaZyASFws1vVIZhZ2oxMtVJPWqdpN8r9Ti1zfkQYpN/RLAz
         7G7qVDjdYin8lcRrJi26VR47RL3qBNH0TUntLI5W2fAA2rOsQPcpZWfEQtxj/UHkiG2h
         ONeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lcOqLDcreMJidT6TxGStHd1/we7cB4At6iFEHiI9lyU=;
        b=K1g6R1Z5D9+B94kCPBaV7J/R9ctKUr5ubu3vqI20EwzmCcYsI+WIqX+RuIUX1tDK22
         JLENi1rz+vgahHh8pOgdoU+NVMyxyozAgscN1ZoJqtNpO4zW+6i6G0OE+ah+f3h40P9t
         wl1MnU4xL3iQ8HUM86xiL/0k8ka7HKmxDVcBT8pHR3YO3+7C6hcK/hskLWgVqr1titGx
         N+zz/G0NSoK0hPaC6A+q6MT7k0yPCpsg5ENYtii1AJUX56JisH7wM9XsEW5tNECTcndK
         BgJ/kK4rAXn4PgFb3C+aeQBSk/0TOygofHXXvslfVIPboz+BWXyb3f/dUI7WzNI2g0YB
         595w==
X-Gm-Message-State: APjAAAVjyMQrsMUAh+GhmW0BBi5D/QqLfhLEq5HECyvgnmkGOq6kLuGn
        aOKYitpd/gOK+6oXiJV6s+Ml/PTgEIOZ8xDHkPOATPpm
X-Google-Smtp-Source: APXvYqwBnTxZeOOVjOODVf3Rf8Yov2AZ4zW3vCMAjXaV3yD3yOzm/jatrHPW53rV4h6hL9C7ezBSS7I7/Tntraj8/FY=
X-Received: by 2002:a02:13c3:: with SMTP id 186mr30704830jaz.30.1563241564064;
 Mon, 15 Jul 2019 18:46:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190715201942.17309-1-andrew.smirnov@gmail.com> <20190715201942.17309-12-andrew.smirnov@gmail.com>
In-Reply-To: <20190715201942.17309-12-andrew.smirnov@gmail.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Mon, 15 Jul 2019 18:45:51 -0700
Message-ID: <CAHQ1cqGKbr_4vTWA=mKvZAZ+ejSj6W8Lp8C6yEvMLAHcQCtq7w@mail.gmail.com>
Subject: Re: [PATCH v5 11/14] crypto: caam - don't hardcode inpentry size
To:     linux-crypto@vger.kernel.org
Cc:     Chris Spencer <christopher.spencer@sea.co.uk>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 15, 2019 at 1:20 PM Andrey Smirnov <andrew.smirnov@gmail.com> w=
rote:
>
> Using dma_addr_t for elements of JobR input ring is not appropriate on
> all 64-bit SoCs, some of which, like i.MX8MQ, use only 32-bit wide
> pointers there. Convert all of the code to use explicit helper
> function that can be later extended to support i.MX8MQ. No functional
> change intended.
>
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> Cc: Chris Spencer <christopher.spencer@sea.co.uk>
> Cc: Cory Tusar <cory.tusar@zii.aero>
> Cc: Chris Healy <cphealy@gmail.com>
> Cc: Lucas Stach <l.stach@pengutronix.de>
> Cc: Horia Geant=C4=83 <horia.geanta@nxp.com>
> Cc: Aymen Sghaier <aymen.sghaier@nxp.com>
> Cc: Leonard Crestez <leonard.crestez@nxp.com>
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/crypto/caam/intern.h | 3 ++-
>  drivers/crypto/caam/jr.c     | 2 +-
>  drivers/crypto/caam/regs.h   | 9 +++++++++
>  3 files changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
> index 081805c0f88b..c00c7c84ec84 100644
> --- a/drivers/crypto/caam/intern.h
> +++ b/drivers/crypto/caam/intern.h
> @@ -55,7 +55,8 @@ struct caam_drv_private_jr {
>         spinlock_t inplock ____cacheline_aligned; /* Input ring index loc=
k */
>         u32 inpring_avail;      /* Number of free entries in input ring *=
/
>         int head;                       /* entinfo (s/w ring) head index =
*/
> -       dma_addr_t *inpring;    /* Base of input ring, alloc DMA-safe */
> +       void *inpring;                  /* Base of input ring, alloc
> +                                        * DMA-safe */
>         int out_ring_read_index;        /* Output index "tail" */
>         int tail;                       /* entinfo (s/w ring) tail index =
*/
>         void *outring;                  /* Base of output ring, DMA-safe =
*/
> diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
> index 138f71adb7e6..4f06cc7eb6a4 100644
> --- a/drivers/crypto/caam/jr.c
> +++ b/drivers/crypto/caam/jr.c
> @@ -388,7 +388,7 @@ int caam_jr_enqueue(struct device *dev, u32 *desc,
>         head_entry->cbkarg =3D areq;
>         head_entry->desc_addr_dma =3D desc_dma;
>
> -       jrp->inpring[head] =3D cpu_to_caam_dma(desc_dma);
> +       jr_inpentry_set(jrp->inpring, head, cpu_to_caam_dma(desc_dma));
>
>         /*
>          * Guarantee that the descriptor's DMA address has been written t=
o
> diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
> index 0cc4a48dfc30..ec49f5ba9689 100644
> --- a/drivers/crypto/caam/regs.h
> +++ b/drivers/crypto/caam/regs.h
> @@ -244,6 +244,15 @@ static inline u32 jr_outentry_jrstatus(void *outring=
, int hw_idx)
>         return jrstatus;
>  }
>
> +static inline void jr_inpentry_set(void *inpring, int hw_idx, dma_addr_t=
 val)
> +{
> +       dma_addr_t *inpentry =3D inpring;
> +
> +       inpentry[hw_idx] =3D val;
> +}
> +
> +#define SIZEOF_JR_INPENTRY     caam_ptr_sz
> +

Looks like I've lost the hunk actually using SIZEOF_JR_INPENTRY in v5.
Sorry about that. Will fix and resubmit v6 shortly.

Thanks,
Andrey Smirnov
