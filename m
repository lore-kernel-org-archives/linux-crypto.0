Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1289AC433E3
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 22:44:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE2F2619CF
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 22:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbhC3WoI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Mar 2021 18:44:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:57378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232952AbhC3WoE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Mar 2021 18:44:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADAEF6024A;
        Tue, 30 Mar 2021 22:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617144244;
        bh=RcuXmNfF81Rze1zkENzJlhvPm4Tsn8Z1PvkmCDDnInI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=so502Er6WQx5dCh7b8ocWIkm7HIfeROPeeOkAemjKFTGL7QjWofQpoYZfyOrIkb+X
         LSMrj3W6sULmdY7pdtOE9+7Jifd6iLpIag2pFBOeSu1T4VBPX0A6LtMtd895QLGGYP
         fUUwHAxlvLNjI40NULfBagz5wqtSniYQ8YBbGRKhzZqR/qVqZa/q48mWZJPiTojP9x
         zMtAHM5w2yb/RRBDY2PhbgE/1EoYB3x9EmtdwdeRYwIsJQyAhIhY+7QNxnbWORq8qx
         JvqEXgq3Mz6dvUtJ+j67qyx60M3jkwfBwDjXjIrrHe4ArBzyKjKvsfbjzGkeKIlBoF
         flm5sLjLr4Wvg==
Date:   Tue, 30 Mar 2021 15:44:02 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2] Documentation: crypto: add info about "fips=" boot
 option
Message-ID: <YGOpssfbqaGSlCl1@gmail.com>
References: <20210330050651.13344-1-rdunlap@infradead.org>
 <YGK3OlT3+6WdXbux@sol.localdomain>
 <f86bb75f-e593-5b2f-943a-db2129256eab@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f86bb75f-e593-5b2f-943a-db2129256eab@infradead.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 30, 2021 at 09:38:55AM -0700, Randy Dunlap wrote:
> On 3/29/21 10:29 PM, Eric Biggers wrote:
> > On Mon, Mar 29, 2021 at 10:06:51PM -0700, Randy Dunlap wrote:
> >> Having just seen a report of using "fips=1" on the kernel command line,
> >> I could not find it documented anywhere, so add some help for it.
> >>
> >> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> >> Cc: Dexuan Cui <decui@microsoft.com>
> >> Cc: linux-crypto@vger.kernel.org
> >> Cc: Eric Biggers <ebiggers@kernel.org>
> >> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> >> Cc: "David S. Miller" <davem@davemloft.net>
> >> Cc: Jonathan Corbet <corbet@lwn.net>
> >> Cc: linux-doc@vger.kernel.org
> >> ---
> >> Updates/corrections welcome.
> >>
> >> v2: drop comment that "fips_enabled can cause some tests to be skipped".
> >>
> >>  Documentation/admin-guide/kernel-parameters.txt |   14 ++++++++++++++
> >>  1 file changed, 14 insertions(+)
> >>
> >> --- linux-next-20210329.orig/Documentation/admin-guide/kernel-parameters.txt
> >> +++ linux-next-20210329/Documentation/admin-guide/kernel-parameters.txt
> >> @@ -1370,6 +1370,20 @@
> >>  			See Documentation/admin-guide/sysctl/net.rst for
> >>  			fb_tunnels_only_for_init_ns
> >>  
> >> +	fips=		Format: { 0 | 1}
> >> +			Use to disable (0) or enable (1) FIPS mode.
> >> +			If enabled, any process that is waiting on the
> >> +			'fips_fail_notif_chain' will be notified of fips
> >> +			failures.
> >> +			This setting can also be modified via sysctl at
> >> +			/proc/sysctl/crypto/fips_enabled, i.e.,
> >> +			crypto.fips_enabled.
> >> +			If fips_enabled = 1 and a test fails, it will cause a
> >> +			kernel panic.
> >> +			If fips_enabled = 1, RSA test requires a key size of
> >> +			2K or larger.
> >> +			It can also effect which ECC curve is used.
> > 
> > This doesn't really explain why anyone would want to give this option.
> > What high-level thing is this option meant to be accomplishing?
> > That's what the documentation should explain.
> 
> Yes, clearly, even to me.
> 
> But I could not find anything in the kernel source tree that would help me
> explain that.  So to repeat:
> 
> >> Updates/corrections welcome.
> 
> thanks.
> -- 

I'm by no means an expert on this, but the main thing I have in mind is that
(IIUC) the "fips" option is only useful if your whole kernel binary is certified
as a "FIPS cryptographic module", *and* you actually need the FIPS compliance.
And the upstream kernel doesn't have a FIPS certification out of the box; that's
a task for specific Linux distributors like Red Hat, SUSE, Ubuntu, who get
specific kernel binaries certified.

So, compiling a kernel and using the "fips" option is useless by itself, as your
kernel image won't actually have a FIPS certification in that case anyway.

So, I would expect an explanation like that about under what circumstances the
"fips" option is actually useful and intended for.

The people who actually use this option should be able to explain it properly
though; the above is just my understanding...

- Eric
