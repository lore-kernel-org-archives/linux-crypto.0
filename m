Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D467DC4332F
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Nov 2023 03:22:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbjKADWH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 31 Oct 2023 23:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbjKADWG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Oct 2023 23:22:06 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B504B4
        for <linux-crypto@vger.kernel.org>; Tue, 31 Oct 2023 20:22:04 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95AF4C433C8;
        Wed,  1 Nov 2023 03:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698808923;
        bh=wkjH40ySEh0ASsRlzj3fbA4t4h1zRFcVUvMt06fXibk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M4SIwKo7I9dMCFDRpozaNJF11+tziJ3GT5UKWqBJi/XSEAoFkfKAV+dqPlJCSqjlv
         2PbOhgYbkqGQlhSDljKuFwi9XMnm0uqUzfvnfLjh8FpPeiIlzbdvegx8X3nYKXlKcA
         bZtbF2ap9QCuIQlnpNsHSaK5KLfY7nPRLzfBEOwti+p2RJtNmn/jbL9Aeygec9Ce9a
         bQHzFVDipovy/n8Xyet596cScgbM5dFeKsAPQgxi8NB6jquukj2sL8svYSQBvaJoGL
         IeMaZ+YrNmGT985jwYERB4iINkEfHv2Iq27Is9H7ZYyVyYGaLInxV9ezoSMid3mjv7
         m2pxU3Xkuk5IQ==
Date:   Tue, 31 Oct 2023 20:22:02 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Elliott, Robert (Servers)" <elliott@hpe.com>
Cc:     Roxana Nicolescu <roxana.nicolescu@canonical.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: x86/sha256 - autoload if SHA-NI detected
Message-ID: <20231101032202.GA1830@sol.localdomain>
References: <20231029051555.157720-1-ebiggers@kernel.org>
 <34843a86-6516-47d2-88dd-5ca0aa86a052@canonical.com>
 <MW5PR84MB1842C4652CCCB7738AE7FA4BABA0A@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW5PR84MB1842C4652CCCB7738AE7FA4BABA0A@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Oct 31, 2023 at 02:52:53PM +0000, Elliott, Robert (Servers) wrote:
> > -----Original Message-----
> > From: Roxana Nicolescu <roxana.nicolescu@canonical.com>
> > Sent: Tuesday, October 31, 2023 8:19 AM
> > To: Eric Biggers <ebiggers@kernel.org>; linux-crypto@vger.kernel.org
> > Subject: Re: [PATCH] crypto: x86/sha256 - autoload if SHA-NI detected
> > 
> > On 29/10/2023 06:15, Eric Biggers wrote:
> > > From: Eric Biggers <ebiggers@google.com>
> > >
> > > The x86 SHA-256 module contains four implementations: SSSE3, AVX, AVX2,
> > > and SHA-NI.  Commit 1c43c0f1f84a ("crypto: x86/sha - load modules based
> > > on CPU features") made the module be autoloaded when SSSE3, AVX, or AVX2
> > > is detected.  The omission of SHA-NI appears to be an oversight, perhaps
> > > because of the outdated file-level comment.  This patch fixes this,
> > > though in practice this makes no difference because SSSE3 is a subset of
> > > the other three features anyway.  Indeed, sha256_ni_transform() executes
> > > SSSE3 instructions such as pshufb.
> > >
> > > Cc: Roxana Nicolescu <roxana.nicolescu@canonical.com>
> > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > 
> > Indeed, it was an oversight.
> > 
> > Reviewed-by: Roxana Nicolescu <roxana.nicolescu@canonical.com>
> > > ---
> > >   arch/x86/crypto/sha256_ssse3_glue.c | 5 +++--
> > >   1 file changed, 3 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/arch/x86/crypto/sha256_ssse3_glue.c
> > b/arch/x86/crypto/sha256_ssse3_glue.c
> > > index 4c0383a90e11..a135cf9baca3 100644
> > > --- a/arch/x86/crypto/sha256_ssse3_glue.c
> ...
> > >
> > >   static const struct x86_cpu_id module_cpu_ids[] = {
> > > +	X86_MATCH_FEATURE(X86_FEATURE_SHA_NI, NULL),
> 
> Unless something else has changed, this needs to be inside ifdefs, as discovered
> in the proposed patch series last year:
> 
> for sha1_sse3_glue.c:
> #ifdef CONFIG_AS_SHA1_NI
>         X86_MATCH_FEATURE(X86_FEATURE_SHA_NI, NULL),
> #endif
> 
> for sha256_sse3_glue.c:
> +#ifdef CONFIG_AS_SHA256_NI
> +       X86_MATCH_FEATURE(X86_FEATURE_SHA_NI, NULL),
> +#endif

Right, thanks for pointing that out.  It compiles either way, but we shouldn't
autoload on SHA-NI when the code using SHA-NI isn't being built.  Sent out v2
with this fixed.

- Eric
