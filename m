Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10D14C4361B
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Dec 2020 16:04:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE6E923B27
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Dec 2020 16:04:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729983AbgLRQDd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Dec 2020 11:03:33 -0500
Received: from mail.zx2c4.com ([192.95.5.64]:49105 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727047AbgLRQDd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Dec 2020 11:03:33 -0500
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 973b2e7e
        for <linux-crypto@vger.kernel.org>;
        Fri, 18 Dec 2020 15:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=JXMnS86VzFzPZAKb+5arauMQwt4=; b=JMxpne
        jFtsKKcnN6ijsFNliRWOv2WWPu6Uf4QWETY9OShxijVaVUgfem9Vg1Suadjv6PEu
        54COtZ+0ozUudkTFo6mzzSDpAJXA1LfShrkFgm1batwhSV97PFEBetOyKXp0G3RX
        Y83eo5zQJ1AfTGUScMUNmsWNDdG6d23qRlbbREUZBRXnlbpwW63BL+MBT4Yjv7Qh
        5yG1a+fUypPDbo6UfPmGsCZtOU2IwzhT0GauDNA75n6yazDUD9q52KpM9DeiA9Wu
        BkGu36QHOahmGLzGkHtCex0jjRHansZkmHgSoPWT4+sqs23zqVYA7NWM9/lIz77n
        KgLKyVPyH0Y6rosA==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 88520796 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Fri, 18 Dec 2020 15:54:57 +0000 (UTC)
Received: by mail-yb1-f171.google.com with SMTP id d37so2344826ybi.4
        for <linux-crypto@vger.kernel.org>; Fri, 18 Dec 2020 08:02:50 -0800 (PST)
X-Gm-Message-State: AOAM532CQBv+8ZxPbA+GRsUUkExg2R/5kGfD4Lb5ICUczkAQnQ4Pdsuv
        wFQdIviM7p21Y1bQKAreg2nfT+LKD/Tjb1GZS/M=
X-Google-Smtp-Source: ABdhPJzmld84cvT/JnFrgKsnAUpSV343snfgSxq1Aibym5Xo7/IpvwnBSsrqKlPNdJeGFq7mPDwfoCTcDzjF1fAmTpg=
X-Received: by 2002:a25:4845:: with SMTP id v66mr3237420yba.178.1608307370256;
 Fri, 18 Dec 2020 08:02:50 -0800 (PST)
MIME-Version: 1.0
References: <20201217222138.170526-1-ebiggers@kernel.org> <20201217222138.170526-12-ebiggers@kernel.org>
In-Reply-To: <20201217222138.170526-12-ebiggers@kernel.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 18 Dec 2020 17:02:39 +0100
X-Gmail-Original-Message-ID: <CAHmME9o=8D=dAd36cKq+qGq7C=MP-3-_PPtx5Dtid7T-w=wxBQ@mail.gmail.com>
Message-ID: <CAHmME9o=8D=dAd36cKq+qGq7C=MP-3-_PPtx5Dtid7T-w=wxBQ@mail.gmail.com>
Subject: Re: [PATCH v2 11/11] wireguard: Kconfig: select CRYPTO_BLAKE2S_ARM
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Sterba <dsterba@suse.com>,
        Paul Crowley <paulcrowley@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 17, 2020 at 11:25 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> When available, select the new implementation of BLAKE2s for 32-bit ARM.
> This is faster than the generic C implementation.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>

When this series is ready, feel free to pull this commit in via
Herbert's tree, rather than my usual wireguard-linux.git->net-next.git
route. That will ensure the blake2s stuff lands all at once and we
won't have to synchronize anything.
