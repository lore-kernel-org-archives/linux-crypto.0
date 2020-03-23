Return-Path: <SRS0=HSjb=5I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20822C3F2CD
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 04:08:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E341D20732
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 04:08:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="MnsNQtMa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725776AbgCWEIG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Mar 2020 00:08:06 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:56335 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725208AbgCWEIG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Mar 2020 00:08:06 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 56bf3ff2;
        Mon, 23 Mar 2020 04:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=l8iAyJ+K01K7Ry6hfLApfgsmmCk=; b=MnsNQt
        Ma0aqGANqQPdmI6JpO51x/MhbXk40VIzVt9efr07y+nzih8urCCcGTnoOafMhaTW
        DmVyky6HL/ME43qa7sds3VfllcAXsEzGcvC0aPyWzoCXTJ17XUEOE2wkvpwN+FCN
        jVw9EcYq96X/RxeEyjb2552akQqCsPK16XiPS4mdeJDn8rJlyivDpjt7PY3oCYPr
        pJn19ae+qcqGdWGehZuJEY7dzZRF57pakkzHIqZBEmZila+282Uy/lPxTCi0L4YS
        PlplI2XV4nhuAa8AFU+1iYTmvH2gf0V5YhuA3helY7UxAR1PTNJGf3o15Gznxfcx
        DY7ftlEo+EoRDS8g==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 05493092 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Mon, 23 Mar 2020 04:01:06 +0000 (UTC)
Received: by mail-io1-f50.google.com with SMTP id n21so12692659ioo.10;
        Sun, 22 Mar 2020 21:08:02 -0700 (PDT)
X-Gm-Message-State: ANhLgQ27C2aW47PEJYmMm3vmfVQGc/YiqtrnhWPqBOV36s8RawzJRduG
        VX05UE08CvUjLhe4lrm8t5tcyL8/57dbAY5eoko=
X-Google-Smtp-Source: ADFU+vve1M8meLuonUdW1BMBX+ggaNqG5j94K+EgtJtEvjoWd9qbODtfHBZwqVNOuzYNm0X1q9NY2r9Nt12yu/iFdEM=
X-Received: by 2002:a05:6602:b:: with SMTP id b11mr15291684ioa.79.1584936481619;
 Sun, 22 Mar 2020 21:08:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200323020844.17064-1-masahiroy@kernel.org>
In-Reply-To: <20200323020844.17064-1-masahiroy@kernel.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sun, 22 Mar 2020 22:07:50 -0600
X-Gmail-Original-Message-ID: <CAHmME9p=ECJ15uyPH79bF0tuzEksdxoUsjGQSyz74FfdEJxTpQ@mail.gmail.com>
Message-ID: <CAHmME9p=ECJ15uyPH79bF0tuzEksdxoUsjGQSyz74FfdEJxTpQ@mail.gmail.com>
Subject: Re: [PATCH 0/7] x86: remove always-defined CONFIG_AS_* options
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     X86 ML <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Allison Randal <allison@lohutok.net>,
        Armijn Hemel <armijn@tjaldur.nl>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ingo Molnar <mingo@redhat.com>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Song Liu <songliubraving@fb.com>,
        Zhengyuan Liu <liuzhengyuan@kylinos.cn>,
        clang-built-linux@googlegroups.com,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hey Masahrio,

Thanks for this series. I'll rebase my recent RFC on top of these
changes, which makes the work I was doing slightly easier, as there
are now fewer flags to deal with.

Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>

Jason
