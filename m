Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0EEBC433E0
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Jan 2021 01:44:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F305212CC
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Jan 2021 01:44:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbhAPBoG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Jan 2021 20:44:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:35706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbhAPBoG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Jan 2021 20:44:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D35823120;
        Sat, 16 Jan 2021 01:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610761406;
        bh=F5udgBJ6Iub+SVPG8jhyLFZYdMP8H6k/zj+lJZG/UeQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g1Vcmc17LgRbX0P+ycXC1ovEJ5lpf4c/nlmjewMR7/VLLWuWiFyi0KJYrfJ00UoKo
         Nm4LDuuN20XE39yzrl8BSd6QP+GCc0t6D8cnh27+HOs5R7O4QTyvxaTMm8M1XGXZYr
         /EVvEfRBxIAS0ACSPLD24yYqdvBglETQub1N7DCrAC/Z8deDUDNs7iJtX8FTAW/dur
         4cgRDmp1HhHVybYsMgAt8G135bDHNgjGf2gCvT7VvmA8aqompQ7eV0MI6SX+DQEiAm
         WmE2FJMLqwcucW06Xz5T+5bSAsGld+XVtQbVKoSC9JcvcJxge75JohQbCW4JGFxYgo
         MV1wT/ZzCMjKg==
Date:   Fri, 15 Jan 2021 17:43:23 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Dey, Megha" <megha.dey@intel.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ravi.v.shankar@intel.com, tim.c.chen@intel.com,
        andi.kleen@intel.com, dave.hansen@intel.com,
        wajdi.k.feghali@intel.com, greg.b.tucker@intel.com,
        robert.a.kasten@intel.com, rajendrakumar.chinnaiyan@intel.com,
        tomasz.kantecki@intel.com, ryan.d.saffores@intel.com,
        ilya.albrekht@intel.com, kyung.min.park@intel.com,
        Tony Luck <tony.luck@intel.com>, ira.weiny@intel.com
Subject: Re: [RFC V1 3/7] crypto: ghash - Optimized GHASH computations
Message-ID: <YAJEu1esw0zPA7Qh@gmail.com>
References: <1608325864-4033-1-git-send-email-megha.dey@intel.com>
 <1608325864-4033-4-git-send-email-megha.dey@intel.com>
 <CAMj1kXGhGopfg19at5N_9q89-UA4irSgMULyDXg+dKhnbRrCZQ@mail.gmail.com>
 <dfb5f2e0-027d-2b9c-aec7-313ff0275381@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dfb5f2e0-027d-2b9c-aec7-313ff0275381@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jan 15, 2021 at 04:14:40PM -0800, Dey, Megha wrote:
> > Hello Megha,
> > 
> > What is the purpose of this separate GHASH module? GHASH is only used
> > in combination with AES-CTR to produce GCM, and this series already
> > contains a GCM driver.
> > 
> > Do cores exist that implement PCLMULQDQ but not AES-NI?
> > 
> > If not, I think we should be able to drop this patch (and remove the
> > existing PCLMULQDQ GHASH driver as well)
> 
> AFAIK, dm-verity (authenticated but not encrypted file system) is one use
> case for authentication only.
> 
> Although I am not sure if GHASH is specifically used for this or SHA?
> 
> Also, I do not know of any cores that implement PCLMULQDQ and not AES-NI.
> 

dm-verity only uses unkeyed hash algorithms.  So no, it doesn't use GHASH.

- Eric
