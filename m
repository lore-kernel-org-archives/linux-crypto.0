Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64CB9CCA47B
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jul 2022 16:35:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiGEQfs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Jul 2022 12:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiGEQfr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Jul 2022 12:35:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05232B26;
        Tue,  5 Jul 2022 09:35:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B48F61BD9;
        Tue,  5 Jul 2022 16:35:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F18B1C341C7;
        Tue,  5 Jul 2022 16:35:44 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="L5fb/qCE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1657038943;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LxFVUUohYoI+YzKE4WruBWc0PMGA7Ua1ICVm9wDLh1s=;
        b=L5fb/qCEG+OhfafI7Kj/Q3/B4+6xROzqf4otMv4EjSRGVoOhlJx7KmHTJXJmSCpLlhfjgY
        tr6nMUhYdv9yUr8ccgFIoS1I+N8e6YwcKpi9iXH9EbRp5H/INB4za1RaLyBLjkPox9euYu
        CGaZypkgPJxyoTy08LIdBtGqQC/jN1I=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ef1ae2a8 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 5 Jul 2022 16:35:43 +0000 (UTC)
Date:   Tue, 5 Jul 2022 18:35:40 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Holger Dengler <dengler@linux.ibm.com>
Cc:     Harald Freudenberger <freude@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Juergen Christ <jchrist@linux.ibm.com>,
        linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 1/1] s390/arch_random: Buffer true random data
Message-ID: <YsRoXObdpCNbtpHS@zx2c4.com>
References: <20220705112712.4433-1-dengler@linux.ibm.com>
 <20220705112712.4433-2-dengler@linux.ibm.com>
 <YsQ6OOrOWPhdynoM@zx2c4.com>
 <9a0561c0-68f7-b630-4440-3ca32bf28dc2@linux.ibm.com>
 <YsRUowTs9n98p9EL@zx2c4.com>
 <aafbb400-d0cb-99de-8b10-3c39c7b9bae5@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aafbb400-d0cb-99de-8b10-3c39c7b9bae5@linux.ibm.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Holger,

On Tue, Jul 05, 2022 at 06:27:59PM +0200, Holger Dengler wrote:
> I saw a few calls in interrupt context during my tracing, but I didn't
> look to see which ones they were. Let me figure that out in the next
> few days and provide more information on that.

One thing to keep in mind is that it's used at boot time, when
technically IRQs are turned off, so it appears like interrupt context
depending on which way you squint. But boot time obviously isn't a
problem. So be sure that's not the usage you're seeing.

> For the moment, I would propose to drop the buffering but also return
> false, if arch_random_get_seed_long() is called in interrupt context.

As a last ditch, maybe that's best. Maybe... Do you know off hand how
many cycles each call takes?

> diff --git a/arch/s390/include/asm/archrandom.h b/arch/s390/include/asm/archrandom.h
> index 2c6e1c6ecbe7..711357bdc464 100644
> --- a/arch/s390/include/asm/archrandom.h
> +++ b/arch/s390/include/asm/archrandom.h
> @@ -32,7 +32,8 @@ static inline bool __must_check arch_get_random_int(unsigned int *v)
> 
>  static inline bool __must_check arch_get_random_seed_long(unsigned long *v)
>  {
> -       if (static_branch_likely(&s390_arch_random_available)) {
> +       if (static_branch_likely(&s390_arch_random_available) &&
> +           !in_interrupt()) {

in_interrupt() is deprecated. You want in_hardirq() here. You'll also
want to verify that this doesn't prevent random_init() from working.

Jason
