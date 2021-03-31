Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB781C433DB
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Mar 2021 07:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B16386199A
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Mar 2021 07:50:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234075AbhCaHuD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 31 Mar 2021 03:50:03 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.84]:9535 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233925AbhCaHtn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Mar 2021 03:49:43 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1617176960; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=gYKNjO/ORcmHwWCxfy1iSH5rzOZowIEg1vND5o3nteP/0xcY2bbtNjLQRHBS49H0Ql
    PX3Z9ygxqPzR0IDguvXgfI0caC4DOjmI5aGUJw4H7XYWcaV1s89bxuAcUQMVzKoAIxJw
    fKIqomqnSCoW2pCEbqysu3xs3ruXkZeP0ZQL9HBRH3vKeKkTAvc0nkiVDH4qpYtWhwdW
    t4ya+UnpXdniTlMXi4x4piEVcI8O4/UYlcWrovR7nVLYU4qH1ZvE3vQBKBZvOMGnG0PL
    GxctCijiOZH3M3LBqa2wS7SmXsv6Ep9lCAMlVIfezjVKDONBGgc/KzI7lHOxssI+Lmp/
    BulA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1617176960;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=EhDiI8LlssXTOZMDfWRXYfD7vpJtf/F0owt41R4vWGA=;
    b=WL28eenaB7tON1lo3+h7zGVTuf03iwvCO1qNc9GH2E4P7fCcTodE4w/eFeRc1GI35s
    WftnNdGJCDUwnXDflmCcRMgrfScxZrCZtlsELes9VDwh78FGlzHEdCPVNlfxKdBYvvgm
    2LsLDcWOk7JY2kdr9A7L9yQoBDYVM50+67lIwgTtu9OA+xlh6luY1FP30y7zxqeqhUY7
    mqoWwjiAYBT+fBeHx6dE0hYHrwD0LBz3vuo46W7qhdzxWiVLKXb8lPkCxAyPGm1j+/DB
    DF8jL1kaoYfJX9shx3rI08lo5QTKW7PaB+uFOZ1a/9+WZlP/TtUc1wYFHsUsQKxEM4wK
    3sfA==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1617176960;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=EhDiI8LlssXTOZMDfWRXYfD7vpJtf/F0owt41R4vWGA=;
    b=QS0j83F7Gxm74YOhrLNmvf8sfQhMUMT8lQiGkiTt2rqbnKzfD0wcarBEQjOdisoE/I
    QEqmUcqoJrmDbVJO0r6Wk4BByIRXwYVpUmuA7yzPr3yz5ADsnJOohJ/4pbExxMhUIHCG
    swaXWG4WdPPzBgL27sjM8YwhInG4kWBlp6IPKlYlO91DP1Yyx2ygtT7se6pMz5883LMu
    EP98ebCC6L3JPZ+E6JkVpGQmQDxpykE4C4rE5/LQYs1KGXmsNjs7DPmct+1zC+a8dQx0
    iJVJT2PDDp9jWi7lw4wdgtwW6l+ZWgt8PAp5q7OyyCW1WkHJqkbY9pOg/dhQQ4dS5Bnc
    Z6hw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNzyCzy1Sfr67uExK884EC0GFGHavJShEkMReN0E="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
    by smtp.strato.de (RZmta 47.23.1 DYNA|AUTH)
    with ESMTPSA id e03072x2V7nJLPL
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 31 Mar 2021 09:49:19 +0200 (CEST)
Message-ID: <62aed524d217359363ab1c589bbfe62745b83eda.camel@chronox.de>
Subject: Re: [PATCH v2] Documentation: crypto: add info about "fips=" boot
 option
From:   Stephan Mueller <smueller@chronox.de>
To:     Eric Biggers <ebiggers@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Date:   Wed, 31 Mar 2021 09:49:18 +0200
In-Reply-To: <YGOpssfbqaGSlCl1@gmail.com>
References: <20210330050651.13344-1-rdunlap@infradead.org>
         <YGK3OlT3+6WdXbux@sol.localdomain>
         <f86bb75f-e593-5b2f-943a-db2129256eab@infradead.org>
         <YGOpssfbqaGSlCl1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Dienstag, dem 30.03.2021 um 15:44 -0700 schrieb Eric Biggers:
> On Tue, Mar 30, 2021 at 09:38:55AM -0700, Randy Dunlap wrote:
> > On 3/29/21 10:29 PM, Eric Biggers wrote:
> > > On Mon, Mar 29, 2021 at 10:06:51PM -0700, Randy Dunlap wrote:
> > > > Having just seen a report of using "fips=1" on the kernel command
> > > > line,
> > > > I could not find it documented anywhere, so add some help for it.
> > > > 
> > > > Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> > > > Cc: Dexuan Cui <decui@microsoft.com>
> > > > Cc: linux-crypto@vger.kernel.org
> > > > Cc: Eric Biggers <ebiggers@kernel.org>
> > > > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > > > Cc: "David S. Miller" <davem@davemloft.net>
> > > > Cc: Jonathan Corbet <corbet@lwn.net>
> > > > Cc: linux-doc@vger.kernel.org
> > > > ---
> > > > Updates/corrections welcome.
> > > > 
> > > > v2: drop comment that "fips_enabled can cause some tests to be
> > > > skipped".
> > > > 
> > > >  Documentation/admin-guide/kernel-parameters.txt |   14 ++++++++++++++
> > > >  1 file changed, 14 insertions(+)
> > > > 
> > > > --- linux-next-20210329.orig/Documentation/admin-guide/kernel-
> > > > parameters.txt
> > > > +++ linux-next-20210329/Documentation/admin-guide/kernel-
> > > > parameters.txt
> > > > @@ -1370,6 +1370,20 @@
> > > >                         See Documentation/admin-guide/sysctl/net.rst
> > > > for
> > > >                         fb_tunnels_only_for_init_ns
> > > >  
> > > > +       fips=           Format: { 0 | 1}
> > > > +                       Use to disable (0) or enable (1) FIPS mode.
> > > > +                       If enabled, any process that is waiting on the
> > > > +                       'fips_fail_notif_chain' will be notified of
> > > > fips
> > > > +                       failures.
> > > > +                       This setting can also be modified via sysctl
> > > > at
> > > > +                       /proc/sysctl/crypto/fips_enabled, i.e.,
> > > > +                       crypto.fips_enabled.
> > > > +                       If fips_enabled = 1 and a test fails, it will
> > > > cause a
> > > > +                       kernel panic.
> > > > +                       If fips_enabled = 1, RSA test requires a key
> > > > size of
> > > > +                       2K or larger.
> > > > +                       It can also effect which ECC curve is used.
> > > 
> > > This doesn't really explain why anyone would want to give this option.
> > > What high-level thing is this option meant to be accomplishing?
> > > That's what the documentation should explain.
> > 
> > Yes, clearly, even to me.
> > 
> > But I could not find anything in the kernel source tree that would help me
> > explain that.  So to repeat:
> > 
> > > > Updates/corrections welcome.
> > 
> > thanks.
> > -- 
> 
> I'm by no means an expert on this, but the main thing I have in mind is that
> (IIUC) the "fips" option is only useful if your whole kernel binary is
> certified
> as a "FIPS cryptographic module", *and* you actually need the FIPS
> compliance.
> And the upstream kernel doesn't have a FIPS certification out of the box;
> that's
> a task for specific Linux distributors like Red Hat, SUSE, Ubuntu, who get
> specific kernel binaries certified.
> 
> So, compiling a kernel and using the "fips" option is useless by itself, as
> your
> kernel image won't actually have a FIPS certification in that case anyway.
> 
> So, I would expect an explanation like that about under what circumstances
> the
> "fips" option is actually useful and intended for.
> 
> The people who actually use this option should be able to explain it
> properly
> though; the above is just my understanding...


The fips=1 flag serves the following purposes:

In-kernel:

- it restricts crypto algos to those which are marked as .fips_allowed in the
testmgr.c

- it causes the panic() if the signature verification of a KO providing a
crypto algo implementation fails

- it causes a specific behavior in driver/char/random.c (which was correct
till 4.8 but then got modified - patches to correct it in current kernels were
ignored)

- elevates the priority of crypto/drbg.c to ensure that when using stdrng the
DRBG is invoked

- ensures that the Jitter RNG is allocated as one seed source for
crypto/drbg.c

In user space:

- Various crypto libraries (OpenSSL, GnuTLS, libgcrypt, NSS) use the flag as
the trigger point to enable their FIPS-compliance with the goal to have one
central "knob" that enables the FIPS mode system-wide

- The boot system (e.g. dracut) starts its FIPS work (see dracut-fips).

Ciao
Stephan
> 
> - Eric


