Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACB92C433F5
	for <linux-crypto@archiver.kernel.org>; Sun,  9 Oct 2022 03:41:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbiJIDlq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 8 Oct 2022 23:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbiJIDlU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 8 Oct 2022 23:41:20 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E73356C7
        for <linux-crypto@vger.kernel.org>; Sat,  8 Oct 2022 20:41:16 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id 204so8117368pfx.10
        for <linux-crypto@vger.kernel.org>; Sat, 08 Oct 2022 20:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Jc9wqi9hH7sDAuXmZMPHByefEvgO0MbR3+ZEqDB7Wuk=;
        b=ZhbF7aukJSn3TNMRwCJkZSqm1r+X38mJ2RxvPJW6Z+9mn1TOlxypOyituNx8mz1HVC
         FGqxSiHSDomVzpOPFi9kka3+6Rdn9v0XaNwqyXLdtOhmQI0POv0z39c8Rsj4C7/d+KIP
         fJKzHg6Na0ETg2nVHR+d6vQT/rsL3lGZwlInw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jc9wqi9hH7sDAuXmZMPHByefEvgO0MbR3+ZEqDB7Wuk=;
        b=gLoo5J0H7XRP8iYsn8mbN60H8D9c0ue+TBuCITQNpAkO+k7b6DRY01DN9WZCdS1fXq
         FG62M+w4EFVCjk8pWLeyJiW1h6L8gyHvN5QXIGZgv/DOnmumTyahveci2X55+8l1eamY
         ObZOn1mfxD7HRGJxfZtJnGemXrmT44VAR/MS6X29YtGJmBo7rL2p5PCRH9lZRSQ2PsnV
         3YI1HGA6KTbgeO9cPllB5qWMfklrK9gm4glL9vy4TdA9hpczpQb3x450ihCSeGYfinqB
         GAtuGjHeUBbfZfIgAdek+Yj+eu8YRNf3zTTlwgiWdT0Zp7Ul9334oMXVos1eUTvRX15c
         2v3g==
X-Gm-Message-State: ACrzQf1EDIMe0gWFUVPeXuvQjMpLY2FEB667X6fxs3E3R6WPPCaoaPUB
        OjstD7JUSAmnsLgiFfGGl9wPcg==
X-Google-Smtp-Source: AMsMyM7YoBLGpPreiN9760Jo2f1/EfVU3YsZS0ZZ4a+XLEChtkH8ZIzixkyyCKOXZUBZ1uN6dxOluQ==
X-Received: by 2002:a63:5a44:0:b0:431:fa3a:f92c with SMTP id k4-20020a635a44000000b00431fa3af92cmr11522888pgm.471.1665286876368;
        Sat, 08 Oct 2022 20:41:16 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id w2-20020a626202000000b0053e8f4a10c1sm4198763pfb.217.2022.10.08.20.41.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Oct 2022 20:41:15 -0700 (PDT)
Date:   Sat, 8 Oct 2022 20:41:14 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        Andreas Noever <andreas.noever@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoph =?iso-8859-1?Q?B=F6hmwalder?= 
        <christoph.boehmwalder@linbit.com>, Christoph Hellwig <hch@lst.de>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dave Airlie <airlied@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Helge Deller <deller@gmx.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Huacai Chen <chenhuacai@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Jan Kara <jack@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        KP Singh <kpsingh@kernel.org>, Marco Elver <elver@google.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Weinberger <richard@nod.at>,
        Russell King <linux@armlinux.org.uk>,
        Theodore Ts'o <tytso@mit.edu>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thomas Graf <tgraf@suug.ch>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        WANG Xuerui <kernel@xen0n.name>, Will Deacon <will@kernel.org>,
        Yury Norov <yury.norov@gmail.com>,
        dri-devel@lists.freedesktop.org, kasan-dev@googlegroups.com,
        kernel-janitors@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-mm@kvack.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-nvme@lists.infradead.org, linux-parisc@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-um@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        loongarch@lists.linux.dev, netdev@vger.kernel.org,
        sparclinux@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v5 0/7] treewide cleanup of random integer usage
Message-ID: <202210082028.692DFA21@keescook>
References: <20221008055359.286426-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221008055359.286426-1-Jason@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 07, 2022 at 11:53:52PM -0600, Jason A. Donenfeld wrote:
> This is a five part treewide cleanup of random integer handling. The
> rules for random integers are:

Reviewing the delta between of my .cocci rules and your v5, everything
matches, except for get_random_int() conversions for files not in
your tree:

diff --git a/drivers/gpu/drm/tests/drm_buddy_test.c b/drivers/gpu/drm/tests/drm_buddy_test.c
index 7a2b2d6bc3fe..62f69589a72d 100644
--- a/drivers/gpu/drm/tests/drm_buddy_test.c
+++ b/drivers/gpu/drm/tests/drm_buddy_test.c
@@ -729,7 +729,7 @@ static void drm_test_buddy_alloc_limit(struct kunit *test)
 static int drm_buddy_init_test(struct kunit *test)
 {
 	while (!random_seed)
-		random_seed = get_random_int();
+		random_seed = get_random_u32();
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/tests/drm_mm_test.c b/drivers/gpu/drm/tests/drm_mm_test.c
index 659d1af4dca7..c4b66eeae203 100644
--- a/drivers/gpu/drm/tests/drm_mm_test.c
+++ b/drivers/gpu/drm/tests/drm_mm_test.c
@@ -2212,7 +2212,7 @@ static void drm_test_mm_color_evict_range(struct kunit *test)
 static int drm_mm_init_test(struct kunit *test)
 {
 	while (!random_seed)
-		random_seed = get_random_int();
+		random_seed = get_random_u32();
 
 	return 0;
 }

So, I guess I mean to say that "prandom: remove unused functions" is
going to cause some pain. :) Perhaps don't push that to -next, and do a
final pass next merge window to catch any new stuff, and then send those
updates and the removal before -rc1 closes?

-- 
Kees Cook
