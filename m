Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BABDC07545
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Oct 2023 13:32:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235027AbjJYNcf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Oct 2023 09:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235021AbjJYNcV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Oct 2023 09:32:21 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 343F81BCB
        for <linux-crypto@vger.kernel.org>; Wed, 25 Oct 2023 06:31:44 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id 5614622812f47-3af609c4dfeso3694283b6e.1
        for <linux-crypto@vger.kernel.org>; Wed, 25 Oct 2023 06:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1698240703; x=1698845503; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZDeLJegtyrSMQs47LqN+x1DHWKzJbsn6ZNyTsWNzhD0=;
        b=poNHIo88GlChypeADbhU097d9YMRUhAnPbjgvnE0pGsjh/3EOZExa9cUNtqNkh74Re
         lzicw6lgi0zMEAVLLes+BairaaUKEL9pO5LM8OqVsOV6CyATcRCKfMHU3HvfKmyfMHjb
         ZDIJIOD6nvLC0HtFU/tYmiZT/+SCYqDOQVP4f078GMr5X94KUo7s9Di4tsQcMTTUAckc
         J6VfAAPDCJIvvzI0OzAaDhu3Hr8lkSjOJuQ1o3Cuvb7nlswXhpbFNkR9nWLQvV0ekQgs
         04dykbr7fGeESFkhwH7OupNg7jv9q2InCx5Gsei1iYyzxD03c4mNd8k/La7HczboVovX
         t0OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698240703; x=1698845503;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZDeLJegtyrSMQs47LqN+x1DHWKzJbsn6ZNyTsWNzhD0=;
        b=iP9TRZ71S2399Fw/lD1yXi/Zohr3hLbjY21ektjGPxNbqpTYqTom9NOGZhjTIHPxC5
         +fjqLxfUKRei9i8fgmk/uq9vDpX06TYbJh1ucacG6/eRE7nRDUTsYrIxHuVXlnag4xTG
         gfAYzN+A4tdvvN1AJJIR8VhUgM2JFfrDh9rWi3aoO5IMzBrctLhkKcn+XiNKUGDh664/
         5zX7o/8vW77t/6I57x/LjPoERDZ+cdybztzL6UANtctumJf1kL1S1qTHO6sZLbmD7MYY
         5GgCw/H+h+RHIXshj2dXEbF2VdAQFkSD1lZJi+n57bva9rsaMN1xjRhacTptiFK5GFeL
         lQEA==
X-Gm-Message-State: AOJu0Yz59Y8znEEozVPoXqpeQ4MnctHd6Q8VCEjAUo3XsOnO9ZOJej9R
        g3JqNkHIbviBUXiuvBziRLMBNyVy4hSZun3qkZ8hkQ==
X-Google-Smtp-Source: AGHT+IHvVVWmzAv/4OQ7DckVr1zNALKZ+0FxM3O1RwNGzG2CeTimbYZdVJ7078LCw5pcHLanhYVCEflo58qYF4oANWU=
X-Received: by 2002:a05:6808:aa3:b0:3ab:7f46:ecc5 with SMTP id
 r3-20020a0568080aa300b003ab7f46ecc5mr15434307oij.35.1698240703272; Wed, 25
 Oct 2023 06:31:43 -0700 (PDT)
MIME-Version: 1.0
References: <20231025065700.1556152-1-JESHWANTHKUMAR.NK@amd.com>
In-Reply-To: <20231025065700.1556152-1-JESHWANTHKUMAR.NK@amd.com>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Wed, 25 Oct 2023 19:01:31 +0530
Message-ID: <CAFA6WYPKXFftMzqJ4GnXT-zqu21_Jzn8aKti_wU-pQ4KpEVNrA@mail.gmail.com>
Subject: Re: [PATCH 0/3] Introduce DMA APIs to allocate and free TEE shared memory
To:     jeshwank <JESHWANTHKUMAR.NK@amd.com>
Cc:     thomas.lendacky@amd.com, john.allen@amd.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        jens.wiklander@linaro.org, jarkko.nikula@linux.intel.com,
        mario.limonciello@amd.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, op-tee@lists.trustedfirmware.org,
        Mythri.Pandeshwarakrishna@amd.com, Devaraj.Rangasamy@amd.com,
        Rijo-john.Thomas@amd.com, nimesh.easow@amd.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Jeshwank,

On Wed, 25 Oct 2023 at 12:27, jeshwank <JESHWANTHKUMAR.NK@amd.com> wrote:
>
> From: Jeshwanth Kumar N K <JESHWANTHKUMAR.NK@amd.com>
>
> At present, the shared memory for TEE ring buffer, command buffer and
> data buffer is allocated using get_free_pages(). The driver shares the
> physical address of these buffers with PSP so that it can be mapped by
> the Trusted OS.
>
> In this patch series we have replaced get_free_pages() with
> dma_alloc_coherent() to allocate shared memory to cleanup the existing
> allocation method.

Thanks for putting this together but I can't find the reasoning behind
this change neither in this commit message and nor in the patch
descriptions. Care to explain why?

-Sumit

>
> Rijo Thomas (3):
>   crypto: ccp - Add function to allocate and free memory using DMA APIs
>   crypto: ccp - Use psp_tee_alloc_buffer() and psp_tee_free_buffer()
>   tee: amdtee: Use psp_tee_alloc_buffer() and psp_tee_free_buffer()
>
>  drivers/crypto/ccp/psp-dev.c        |   3 +
>  drivers/crypto/ccp/tee-dev.c        | 119 ++++++++++++++++++----------
>  drivers/crypto/ccp/tee-dev.h        |  11 +--
>  drivers/tee/amdtee/amdtee_private.h |  18 ++---
>  drivers/tee/amdtee/call.c           |  74 ++++++++---------
>  drivers/tee/amdtee/core.c           |  72 ++++++++++-------
>  drivers/tee/amdtee/shm_pool.c       |  21 ++---
>  include/linux/psp-tee.h             |  47 +++++++++++
>  8 files changed, 221 insertions(+), 144 deletions(-)
>
> --
> 2.25.1
>
