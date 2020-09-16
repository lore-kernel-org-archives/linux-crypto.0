Return-Path: <SRS0=gkSk=CZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58DC3C43461
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Sep 2020 09:28:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2521822210
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Sep 2020 09:28:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbgIPJ2e convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Sep 2020 05:28:34 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:49973 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgIPJ2d (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Sep 2020 05:28:33 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 1CECE1C0005;
        Wed, 16 Sep 2020 09:28:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1599545445-5716-1-git-send-email-pvanleeuwen@rambus.com>
References: <1599545445-5716-1-git-send-email-pvanleeuwen@rambus.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@rambus.com>
To:     Pascal van Leeuwen <pvanleeuwen@rambus.com>,
        linux-crypto@vger.kernel.org
From:   Antoine Tenart <antoine.tenart@bootlin.com>
Subject: Re: [PATCH] crypto: inside-secure - Prevent missing of processing errors
Message-ID: <160024850785.39497.13746876037464237291@kwain>
Date:   Wed, 16 Sep 2020 11:28:28 +0200
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Pascal,

Quoting Pascal van Leeuwen (2020-09-08 08:10:45)
> On systems with coherence issues, packet processed could succeed while
> it should have failed, e.g. because of an authentication fail.
> This is because the driver would read stale status information that had
> all error bits initialised to zero = no error.
> Since this is potential a security risk, we want to prevent it from being
> a possibility at all. So initialize all error bits to error state, so
> that reading stale status information will always result in errors.
> 
> Signed-off-by: Pascal van Leeuwen <pvanleeuwen@rambus.com>

Acked-by: Antoine Tenart <antoine.tenart@bootlin.com>

Thanks!
Antoine

> ---
>  drivers/crypto/inside-secure/safexcel_ring.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/inside-secure/safexcel_ring.c b/drivers/crypto/inside-secure/safexcel_ring.c
> index e454c3d..90f1503 100644
> --- a/drivers/crypto/inside-secure/safexcel_ring.c
> +++ b/drivers/crypto/inside-secure/safexcel_ring.c
> @@ -236,8 +236,8 @@ struct safexcel_result_desc *safexcel_add_rdesc(struct safexcel_crypto_priv *pri
>  
>         rdesc->particle_size = len;
>         rdesc->rsvd0 = 0;
> -       rdesc->descriptor_overflow = 0;
> -       rdesc->buffer_overflow = 0;
> +       rdesc->descriptor_overflow = 1; /* assume error */
> +       rdesc->buffer_overflow = 1;     /* assume error */
>         rdesc->last_seg = last;
>         rdesc->first_seg = first;
>         rdesc->result_size = EIP197_RD64_RESULT_SIZE;
> @@ -245,9 +245,10 @@ struct safexcel_result_desc *safexcel_add_rdesc(struct safexcel_crypto_priv *pri
>         rdesc->data_lo = lower_32_bits(data);
>         rdesc->data_hi = upper_32_bits(data);
>  
> -       /* Clear length & error code in result token */
> +       /* Clear length in result token */
>         rtoken->packet_length = 0;
> -       rtoken->error_code = 0;
> +       /* Assume errors - HW will clear if not the case */
> +       rtoken->error_code = 0x7fff;
>  
>         return rdesc;
>  }
> -- 
> 1.8.3.1
> 

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
