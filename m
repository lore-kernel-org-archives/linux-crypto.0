Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 649EEC433FE
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Sep 2021 06:04:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43CAE61090
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Sep 2021 06:04:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232392AbhIVGGP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Sep 2021 02:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231908AbhIVGGO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Sep 2021 02:06:14 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 616FFC061574;
        Tue, 21 Sep 2021 23:04:45 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id w17so3273128wrv.10;
        Tue, 21 Sep 2021 23:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=E8PWpzGE4nXx9yLcpibeowYfrua7uZ6eTJJKaxClepM=;
        b=S1fWqCKTc+U3XKV5MShwR46eahJQSdbw+NMA8XAWaqVGE4gxmVvz/ieJJpTPvygGB+
         NNN5aTQCiy5LkLq8A9yKOgrmXJlT3dt1rY51hmAS9BwwbIGAmyUshJArA5LNHHbEqGG6
         vpMogiWPbwy7kMJ/XJta/8xaIXkqvkd5SlmkQmn852FfcsPb1bj9sfRgfVakG8YEmd28
         OhxgMrpK7MglhTkJqlaS3vCa5Vn4cXfJ2pmqYfjihzGZEeYcM92zU/EhXXMCPetBA/kc
         9yQ+S8F6dX/34PidSe5ZanAPHXbo5xw4HI+KcwnVlFAYllBy+RA01+pglKkhtXw0Ejzm
         ssMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=E8PWpzGE4nXx9yLcpibeowYfrua7uZ6eTJJKaxClepM=;
        b=uX8MH3NvH6BKFjlNF7jVnzAIW86aq0+Qhwds7asLOaEd0knm1TlZ5uk2kOsPSdvaVB
         HiOPy/QHduUmDeyt+4xWLvF5ahfpXYnF7nphozPj4mh+VUsxtaccVq6PsHjYOYuiDD53
         3WsknmnP6eJAmj3dNJa0lRyeDXlNJBn7dhkXjV3bR+vz8QXmdNL5a5YP+zM9Ymo7/6iA
         vRVesDix/xk5Lazee1Vt3/gaIMvV7eKPzvH/yUb4tnFBeSk5dEIezQEvtd2cC9te0Ao2
         SB/9mF9EPPmXFvtal1InKGW8qFEP9DZjRHYm8nUiESakq6/heRmjD438Sxdlt1VXb6pa
         m2OA==
X-Gm-Message-State: AOAM531viWYQCs6zI5S/LJX86Za4hYxFjppWckv5IAEeIB1GoV3XBfDb
        aKB9Uv3UjD3Y7I5XfDBlGQY=
X-Google-Smtp-Source: ABdhPJy/Oa9kivCqfNjj4Wo8JUjtuGYaGVP7hcDPKnWoCziHCeeoiDjTZzPckMOtTD3xk6YWepI41Q==
X-Received: by 2002:adf:a745:: with SMTP id e5mr28523356wrd.406.1632290683592;
        Tue, 21 Sep 2021 23:04:43 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id o1sm1071032wru.91.2021.09.21.23.04.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 23:04:43 -0700 (PDT)
Date:   Wed, 22 Sep 2021 08:04:39 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Emmanuel Gil Peyrot <linkmauve@linkmauve.fr>
Cc:     linux-crypto@vger.kernel.org, Ash Logan <ash@heyquark.com>,
        Jonathan =?iso-8859-1?Q?Neusch=E4fer?= <j.ne@posteo.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 1/4] crypto: nintendo-aes - add a new AES driver
Message-ID: <YUrHdxY4EyanC9KR@Red>
References: <20210921213930.10366-1-linkmauve@linkmauve.fr>
 <20210921213930.10366-2-linkmauve@linkmauve.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210921213930.10366-2-linkmauve@linkmauve.fr>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Tue, Sep 21, 2021 at 11:39:27PM +0200, Emmanuel Gil Peyrot a écrit :
> This engine implements AES in CBC mode, using 128-bit keys only.  It is
> present on both the Wii and the Wii U, and is apparently identical in
> both consoles.
> 
> The hardware is capable of firing an interrupt when the operation is
> done, but this driver currently uses a busy loop, I’m not too sure
> whether it would be preferable to switch, nor how to achieve that.
> 
> It also supports a mode where no operation is done, and thus could be
> used as a DMA copy engine, but I don’t know how to expose that to the
> kernel or whether it would even be useful.
> 
> In my testing, on a Wii U, this driver reaches 80.7 MiB/s, while the
> aes-generic driver only reaches 30.9 MiB/s, so it is a quite welcome
> speedup.
> 
> This driver was written based on reversed documentation, see:
> https://wiibrew.org/wiki/Hardware/AES
> 
> Signed-off-by: Emmanuel Gil Peyrot <linkmauve@linkmauve.fr>
> Tested-by: Emmanuel Gil Peyrot <linkmauve@linkmauve.fr>  # on Wii U

[...]

> +static int
> +do_crypt(const void *src, void *dst, u32 len, u32 flags)
> +{
> +	u32 blocks = ((len >> 4) - 1) & AES_CTRL_BLOCK;
> +	u32 status;
> +	u32 counter = OP_TIMEOUT;
> +	u32 i;
> +
> +	/* Flush out all of src, we can’t know whether any of it is in cache */
> +	for (i = 0; i < len; i += 32)
> +		__asm__("dcbf 0, %0" : : "r" (src + i));
> +	__asm__("sync" : : : "memory");
> +
> +	/* Set the addresses for DMA */
> +	iowrite32be(virt_to_phys((void *)src), base + AES_SRC);
> +	iowrite32be(virt_to_phys(dst), base + AES_DEST);

Hello

Since you do DMA operation, I think you should use the DMA-API and call dma_map_xxx()
This will prevent the use of __asm__ and virt_to_phys().

Regards
