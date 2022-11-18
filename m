Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE3A5C433FE
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Nov 2022 00:58:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234404AbiKSA6v (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 19:58:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234686AbiKSA4h (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 19:56:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C1213B33E;
        Fri, 18 Nov 2022 15:55:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D61F614FB;
        Fri, 18 Nov 2022 23:55:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FDF0C433D6;
        Fri, 18 Nov 2022 23:55:09 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="BUBW6s5H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1668815706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R01k3COoUWqwZPp44f3ibDLlpDtWB8ifsqMAbjnVS7w=;
        b=BUBW6s5H2iPdiVuOv32UIdmPGYE9iLtyMIjzmgUjx1IG+b8OqGccu1v5s/5K5426Jv8Q5U
        DH85hHqOPyT/htMIliRmk72NFgbThjAj5B2NNyuFB070P7FZNo6mQvLkgIRi9Mgug3HTAy
        V/8hwbP2IdJER09B+N4I1FZL6K2db0k=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a537b333 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Fri, 18 Nov 2022 23:55:05 +0000 (UTC)
Date:   Sat, 19 Nov 2022 00:55:02 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
        Carlos O'Donell <carlos@redhat.com>
Subject: Re: [PATCH v4 2/3] random: introduce generic vDSO getrandom()
 implementation
Message-ID: <Y3gbVorxZyb4SBJa@zx2c4.com>
References: <20221118172839.2653829-1-Jason@zx2c4.com>
 <20221118172839.2653829-3-Jason@zx2c4.com>
 <ecfd265b-49e7-79b2-1818-e08a2c652db0@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ecfd265b-49e7-79b2-1818-e08a2c652db0@csgroup.eu>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Christophe,

On Fri, Nov 18, 2022 at 07:34:26PM +0000, Christophe Leroy wrote:
> > +static __always_inline ssize_t
> > +__cvdso_getrandom(void *buffer, size_t len, unsigned int flags, void *opaque_state)
> > +{
> > +	struct vgetrandom_state *state = opaque_state;
> > +	const struct vdso_rng_data *rng_info = __arch_get_vdso_rng_data();
> 
> In order to ease wiring up to powerpc, can it be done the same way as 
> commit e876f0b69dc9 ("lib/vdso: Allow architectures to provide the vdso 
> data pointer")

It is already. At least I think it is, unless I'm missing a subtle
distinction? The call to __arch_get_vdso_rng_data() goes to
arch-specific code, implemented in the 3/3 of this patch set for x86
inside of arch/x86/include/asm/vdso/getrandom.h. On powerpc, you'd make
a powerpc-specific __arch_get_vdso_rng_data() instead of
arch/powerpc/include/asm/vdso/getrandom.h.

Or maybe I'm not reading that commit right? The commit message says
something about __arch_get_vdso_rng_data() being problematic because of
clobbering a register, but then the same commit still seems to call
__arch_get_vdso_rng_data()? Is this one of those things where what you'd
prefer is that I define an inline function, __cvdso_get_vdso_rng_data(),
that by default calls __arch_get_vdso_rng_data(), but can be overridden
on powerpc to do some other type of magic? But
__arch_get_vdso_rng_data() is already an overiddable inline, so what
would the difference be?

Sorry if I'm a bit slow here to grok what's up.

Jason
