Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45598EE0203
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Sep 2023 01:10:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233219AbjINBLB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Sep 2023 21:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232821AbjINBLB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Sep 2023 21:11:01 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 439F91713
        for <linux-crypto@vger.kernel.org>; Wed, 13 Sep 2023 18:10:57 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1c364fb8a4cso3663855ad.1
        for <linux-crypto@vger.kernel.org>; Wed, 13 Sep 2023 18:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1694653857; x=1695258657; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=14DxahOjQVITg89U+rNjNpjXPaY0eKHfBvvG2rNIDbQ=;
        b=FqFeWH7meXXVtdKOUvdQ0QCa4o4gdQyoklXwOBMoCSJMa+yY1gHhLHU0xCVPOwamVb
         BEJfaFBHdGqL8Qo4f8m9Jcc2Uo13AwtomtztMszabxIeO6914KdTNrFakAdX1mPFiTAu
         xP932guEhuTzL9mjqEELwclK/N7gVa0s2jY1N4ep3/6qNYa9upwOi2jVBr+6MVSjsv4V
         LDKtVs03UfcipJYL1Rzm8JXW9s2YgvTsDfrSteBQRY9xhEc0Uco2/FaYs5JYnAnB/r2z
         cLP84Q67L7lbnaVJeLbQLqoy/etprYT8JqmSHxAbhvTUxNBG2SuxmaNaCcvYkDwilaMT
         5TIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694653857; x=1695258657;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=14DxahOjQVITg89U+rNjNpjXPaY0eKHfBvvG2rNIDbQ=;
        b=DUkCcOiAb//Zre+rGxbzTsl4Fd5qhdPGZHir2N1KX5Cm0DXSGXDQd3z2i5Gxf5lRpD
         PSQ7lYXmrKISF7UW+0EoP/NtpwskEiDvKKiJEhbI+W4kmrGHt5bEoTyO9z9i76CA1sVy
         hB1hmhrkrq3ygr66ccJ5hu0kXk6oZySDojXV3uORUvhqPAxMP9CIteUmVDvvB/BHRu4v
         0sNhX6y/zi8IqeTvfdjg2VfF4KcEfhm6wAeX0jZTcoZFQqyRKYsSe5UyUeOiZU+xqZJw
         NDsyrcuELoJqjc8ZntDA+4MCNoDHB/tlqjJaJvBU1OZvUVY+x0q3jgc3BKDWDMTbrVVr
         qLxA==
X-Gm-Message-State: AOJu0YxLR2ZmOIUEspdeNMMFbpxPEWjtbXvFt0rg4kwTbFG6k9icrexK
        oTyA7lM+FXjIidV+WVVc9eCAPELlNEiceZFnkhM=
X-Google-Smtp-Source: AGHT+IEY+/BKNCHPHuaKMXDV/8l1HaolfYgSVJTHDIJZEnBg1zJunOBNTfLVDJIkmH+IRBGj/Nwl5Q==
X-Received: by 2002:a17:902:bf03:b0:1b6:6e3a:77fb with SMTP id bi3-20020a170902bf0300b001b66e3a77fbmr3944820plb.2.1694653856720;
        Wed, 13 Sep 2023 18:10:56 -0700 (PDT)
Received: from ghost ([50.168.177.73])
        by smtp.gmail.com with ESMTPSA id a11-20020a170903100b00b001bdc664ecd3sm228824plb.307.2023.09.13.18.10.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Sep 2023 18:10:56 -0700 (PDT)
Date:   Wed, 13 Sep 2023 21:10:52 -0400
From:   Charlie Jenkins <charlie@rivosinc.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Heiko Stuebner <heiko@sntech.de>, palmer@dabbelt.com,
        paul.walmsley@sifive.com, aou@eecs.berkeley.edu,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        conor.dooley@microchip.com, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        christoph.muellner@vrull.eu,
        Heiko Stuebner <heiko.stuebner@vrull.eu>
Subject: Re: [PATCH v4 00/12] RISC-V: support some cryptography accelerations
Message-ID: <ZQJdnCwf99Glggin@ghost>
References: <20230711153743.1970625-1-heiko@sntech.de>
 <20230914001144.GA924@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230914001144.GA924@sol.localdomain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 13, 2023 at 05:11:44PM -0700, Eric Biggers wrote:
> On Tue, Jul 11, 2023 at 05:37:31PM +0200, Heiko Stuebner wrote:
> > From: Heiko Stuebner <heiko.stuebner@vrull.eu>
> > 
> > This series provides cryptographic implementations using the vector
> > crypto extensions.
> > 
> > v13 of the vector patchset dropped the patches for in-kernel usage of
> > vector instructions, I picked the ones from v12 over into this series
> > for now.
> > 
> > My basic goal was to not re-invent cryptographic code, so the heavy
> > lifting is done by those perl-asm scripts used in openssl and the perl
> > code used here-in stems from code that is targetted at openssl [0] and is
> > unmodified from there to limit needed review effort.
> > 
> > With a matching qemu (there are patches for vector-crypto flying around)
> > the in-kernel crypto-selftests (also the extended ones) are very happy
> > so far.
> 
> Hi Heiko!  Are you still working on this patchset?  And which of its
> prerequisites still haven't been merged upstream?
> 
> - Eric
> 
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv
It is my understanding that Heiko is taking a break from development, I
don't think he will be working on this soon.

- Charlie
