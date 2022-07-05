Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3DAFC433EF
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Jul 2022 13:43:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233237AbiGENnO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Jul 2022 09:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233621AbiGENmo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Jul 2022 09:42:44 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58ED32C116
        for <linux-crypto@vger.kernel.org>; Tue,  5 Jul 2022 06:06:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 83AC0CE1B92
        for <linux-crypto@vger.kernel.org>; Tue,  5 Jul 2022 13:06:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37185C341C8;
        Tue,  5 Jul 2022 13:06:47 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="EyC6s5sp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1657026404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qfBOrk6H3L87iQzuyrhsJEiTywiuWw5KtAGXlAWi3/I=;
        b=EyC6s5spVROStXuvsX5a1Vn4v2I3hZI3D5uvaad23jjN7Lw4TWZvaI2iJRJtc/zd3kiAHa
        ecqF6MDSUbjU6+0aB9+HEZMrlvHNIlxpBOOCB+2/A2h8Ia8H3CfxeNFGcrI9YjQtjxhyki
        4/q6BzigBIp0kpkYnrSlFfUT/4FD318=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 984a2170 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 5 Jul 2022 13:06:44 +0000 (UTC)
Date:   Tue, 5 Jul 2022 15:06:38 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org,
        Harald Freudenberger <freude@linux.ibm.com>
Subject: Re: [PATCH crypto 5.19] crypto: s390 - do not depend on CRYPTO_HW
 for SIMD implementations
Message-ID: <YsQ3XtPUdzeURzx0@zx2c4.com>
References: <20220705014653.111335-1-Jason@zx2c4.com>
 <YsOkZ1EdIkodYVBG@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YsOkZ1EdIkodYVBG@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 05, 2022 at 10:39:35AM +0800, Herbert Xu wrote:
> On Tue, Jul 05, 2022 at 03:46:53AM +0200, Jason A. Donenfeld wrote:
> > Various accelerated software implementation Kconfig values for S390 were
> > mistakenly placed into drivers/crypto/Kconfig, even though they're
> > mainly just SIMD code and live in arch/s390/crypto/ like usual. This
> > gives them the very unusual dependency on CRYPTO_HW, which leads to
> > problems elsewhere.
> > 
> > This patch fixes the issue by moving the Kconfig values for non-hardware
> > drivers into the usual place in crypto/Kconfig.
> > 
> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> > ---
> >  crypto/Kconfig         | 114 ++++++++++++++++++++++++++++++++++++++++
> >  drivers/crypto/Kconfig | 115 -----------------------------------------
> >  2 files changed, 114 insertions(+), 115 deletions(-)
> 
> This is caused by the s390 patch for wireguard, right?

Right, but is a fix to some linker/kconfig errors related to selecting
chacha20poly1305 directly, and I'm happy to take that patch anyway, so
I'm quasi-content with the situation.

> you take this into your tree along with the wireguard patch
> where it would make more sense.
> 
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Alright, I'll do that.

Jason
