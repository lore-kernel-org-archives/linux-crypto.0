Return-Path: <SRS0=TFX5=DJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA5DCC4363D
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Oct 2020 06:49:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77DEA206DD
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Oct 2020 06:49:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KDDxxvWM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbgJBGtK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Oct 2020 02:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725968AbgJBGtK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Oct 2020 02:49:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F2BC0613D0;
        Thu,  1 Oct 2020 23:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=F0HxCM48zlkqvSK9HVb3prVdbtr0XoJkMcMZ8q5cNvA=; b=KDDxxvWM+qd+VQy/Z9mnWYLcrp
        VPcBmyOR0oC8nWvEYSkDW2MLWZ7ZsnvBDbhUPxXsUP7NiB3KZEPdJgXdtfJQI/d+tF5UbJR4W+SIq
        clptew4ZQQo8cacoEUinGzP4g4x4Y5oaz9/JtjccY5fesqA8GDnOOx377W0WwIuqUD4sSbYNkEnBe
        h+O5gx9IDFJvsVPyX7/3QEnZXiuHEYlaH+8SgPbpOY5B+vftVpHvQkm6k78TG54crxU4xHqQgdpCt
        yg6HpDXyGGYupQltDce++CaqvL7dchYJ/fsCUegBIg3GpqScn3s3Ff069AXOZ+ragf9ss4ZcGko/X
        vuD2YdAw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kOEsL-0007XM-Ky; Fri, 02 Oct 2020 06:49:05 +0000
Date:   Fri, 2 Oct 2020 07:49:05 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Palmer Dabbelt <palmerdabbelt@google.com>
Cc:     linux-riscv@lists.infradead.org, kernel-team@android.com,
        kernel test robot <lkp@intel.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        smueller@chronox.de
Subject: get_cycles from modular code in jitterentropy, was Re: [PATCH]
 clocksource: clint: Export clint_time_val for modules
Message-ID: <20201002064905.GA27115@infradead.org>
References: <20200930065617.934638-1-palmerdabbelt@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930065617.934638-1-palmerdabbelt@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Sep 29, 2020 at 11:56:18PM -0700, Palmer Dabbelt wrote:
> clint_time_val will soon be used by the RISC-V implementation of
> random_get_entropy(), which is a static inline function that may be used by
> modules (at least CRYPTO_JITTERENTROPY=m).

At very least this needs to be an EXPORT_SYMBOL_GPL.  But I really don't
think modules have any business using get_cycles, so I'd much rather
fix CRYPTO_JITTERENTROPY to be required to be build in.

> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
> ---
>  drivers/clocksource/timer-clint.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/clocksource/timer-clint.c b/drivers/clocksource/timer-clint.c
> index d17367dee02c..6cfe2ab73eb0 100644
> --- a/drivers/clocksource/timer-clint.c
> +++ b/drivers/clocksource/timer-clint.c
> @@ -38,6 +38,7 @@ static unsigned int clint_timer_irq;
>  
>  #ifdef CONFIG_RISCV_M_MODE
>  u64 __iomem *clint_time_val;
> +EXPORT_SYMBOL(clint_time_val);
>  #endif
>  
>  static void clint_send_ipi(const struct cpumask *target)
> -- 
> 2.28.0.709.gb0816b6eb0-goog
> 
> 
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv
---end quoted text---
