Return-Path: <SRS0=TeaG=RS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A60EC43381
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 01:27:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D15802186A
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 01:27:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axtens.net header.i=@axtens.net header.b="F+732QtM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbfCOB1F (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Mar 2019 21:27:05 -0400
Received: from mail-pf1-f182.google.com ([209.85.210.182]:37617 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727284AbfCOB1E (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Mar 2019 21:27:04 -0400
Received: by mail-pf1-f182.google.com with SMTP id 8so1671470pfr.4
        for <linux-crypto@vger.kernel.org>; Thu, 14 Mar 2019 18:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=0Wlef7QlJVRBWt94bY3O0T0yq0oH1GDzoCO3EpkQNTQ=;
        b=F+732QtMoBzCT63zkmlyoqY9YGDTFXA/U8bWwR3haWtl5BaqGeEO/a/sw2BvAp2Hwp
         DBMHb/W4SQ/6Ykg6/DBbfp6PiGfbgZpU0O3t3lWZJAgzdvgRtdfQtIGw+hqoTyIkzQsq
         n7wJnYbtUmTHxgtGycZIK3BUd5mcjCofK/Wdc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=0Wlef7QlJVRBWt94bY3O0T0yq0oH1GDzoCO3EpkQNTQ=;
        b=pMLdLBsVvfHmi7m0TCMuS3o8tG2YdizFjXNTMV9aFK6HIMraFgznr+QBEnh4AkvMBT
         d6BCdtdk0BKQit9O+ti7O15GaAve43B1aQrA3WA1LJw6+MCGibx3MhuX8Tv/G6dV1ytN
         nOXY6jV9ECMPDWf9BNsvM1o5aUBsIlkyDtFUlEP7+hUgsAobr082Q9lEIA2kCuHHMpD3
         TF0EpkdsIYIjKLNSAHU3qB/cfK4FlTgqeCX0wB350/ipp+X5ooYoY6lVqbNZOCppnMkq
         SgnHPzSfM0xRZWP+urJj9ePs1hVlokp2/jNLKQlVVBKt0vgu1ZfJOovzxoV+wqYV/f2K
         LpNw==
X-Gm-Message-State: APjAAAXT49HoTnn5qM9ayhRY0qnIz0pq5mgfU940P1cg0lLSx1eWVJug
        AzSrMb59cYiGj1SzChsQ3Tub9w==
X-Google-Smtp-Source: APXvYqwZY3/PkTVn1luNO/pBnSC/DG7EX+foGnzMJsvwOjZca2d88oNOrgHhxkB76IW3GbmUGhVxJw==
X-Received: by 2002:a62:54c5:: with SMTP id i188mr1292962pfb.188.1552613223946;
        Thu, 14 Mar 2019 18:27:03 -0700 (PDT)
Received: from localhost (124-171-209-25.dyn.iinet.net.au. [124.171.209.25])
        by smtp.gmail.com with ESMTPSA id v9sm440373pfg.130.2019.03.14.18.27.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 14 Mar 2019 18:27:02 -0700 (PDT)
From:   Daniel Axtens <dja@axtens.net>
To:     Ondrej =?utf-8?B?TW9zbsOhxI1law==?= <omosnacek@gmail.com>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     marcelo.cerri@canonical.com, Stephan Mueller <smueller@chronox.de>,
        leo.barbosa@canonical.com, linuxppc-dev@lists.ozlabs.org,
        Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
Subject: Re: BUG: p8_aes_ctr randomly returns wrong results
In-Reply-To: <CAAUqJDtsx6Sdv=6xAb1VWWjDF08y8wh2nsAypR8_x_e99a1Uwg@mail.gmail.com>
References: <CAAUqJDtsx6Sdv=6xAb1VWWjDF08y8wh2nsAypR8_x_e99a1Uwg@mail.gmail.com>
Date:   Fri, 15 Mar 2019 12:26:59 +1100
Message-ID: <878sxhsza4.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Ondrej,

> When I run 'rmmod vmx_crypto' before running the reproducer, I get
> only one (correct) checksum, so this is definitely a bug in the
> driver. Other ciphers (cbc(aes), xts(aes)) are not affected, even
> though the glue code is very similar. That leads me to believe the
> problem is somewhere in the assembly code.

It appears that under certain circumstances, aes_p8_ctr32_encrypt_blocks
changes walk.iv. If this is done when
  while ((nbytes = walk.nbytes) >= AES_BLOCK_SIZE) {
is not in its final iteration, it will corrupt the future blocks.

I am not yet sure why this is. Clearly it's pretty late in the assembly
because it doesn't seem to affect the blocks being processed in that
call, only future calls.

Saving and restoring the IV makes the test case pass.

I'll have a look at the asm.

Regards,
Daniel


>
> [1] http://github.com/smuellerDD/libkcapi
>
> Cheers,
> Ondrej
