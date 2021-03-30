Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66D15C433C1
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 05:30:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2604D61921
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 05:30:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhC3F3y (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Mar 2021 01:29:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:36520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229675AbhC3F3c (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Mar 2021 01:29:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81EE461921;
        Tue, 30 Mar 2021 05:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617082171;
        bh=8I7DqHNKkHoQuqnMHUExWNfnew54U0aGIlJ/JSc4DuQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gNsS5Hq1zZvyXLoIKggM0Laqwgx9GQDCRSubWKvHBkg68by1ByQgXrhO1EH6VqwAt
         c78FnjAquP16SnS+YSKL5QBAyiEHUuerQYmXDAyU2LGlWbTt/+t4IqaZ+qYXm2sHgR
         fQWa/iSoc5AAmbZgSMKQmU9JspMq+U9HytOZl5zgZCgBvrROzhz7S2DWmJIUzgRMUg
         OvU754rBTvWwmVvjzHG076rh/Bjdfl9pbb1kFvQc8k3GdSO17R66il3OT0zHQ0j8qD
         obkz2HwOrnFWBuO7vf05Pji0CpA8rinGGxQu8sf6hZfGcEQ5OmhjZt4zdXg8Pe/p07
         raaeW+F2bErmw==
Date:   Mon, 29 Mar 2021 22:29:30 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2] Documentation: crypto: add info about "fips=" boot
 option
Message-ID: <YGK3OlT3+6WdXbux@sol.localdomain>
References: <20210330050651.13344-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330050651.13344-1-rdunlap@infradead.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Mar 29, 2021 at 10:06:51PM -0700, Randy Dunlap wrote:
> Having just seen a report of using "fips=1" on the kernel command line,
> I could not find it documented anywhere, so add some help for it.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Dexuan Cui <decui@microsoft.com>
> Cc: linux-crypto@vger.kernel.org
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: linux-doc@vger.kernel.org
> ---
> Updates/corrections welcome.
> 
> v2: drop comment that "fips_enabled can cause some tests to be skipped".
> 
>  Documentation/admin-guide/kernel-parameters.txt |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> --- linux-next-20210329.orig/Documentation/admin-guide/kernel-parameters.txt
> +++ linux-next-20210329/Documentation/admin-guide/kernel-parameters.txt
> @@ -1370,6 +1370,20 @@
>  			See Documentation/admin-guide/sysctl/net.rst for
>  			fb_tunnels_only_for_init_ns
>  
> +	fips=		Format: { 0 | 1}
> +			Use to disable (0) or enable (1) FIPS mode.
> +			If enabled, any process that is waiting on the
> +			'fips_fail_notif_chain' will be notified of fips
> +			failures.
> +			This setting can also be modified via sysctl at
> +			/proc/sysctl/crypto/fips_enabled, i.e.,
> +			crypto.fips_enabled.
> +			If fips_enabled = 1 and a test fails, it will cause a
> +			kernel panic.
> +			If fips_enabled = 1, RSA test requires a key size of
> +			2K or larger.
> +			It can also effect which ECC curve is used.

This doesn't really explain why anyone would want to give this option.
What high-level thing is this option meant to be accomplishing?
That's what the documentation should explain.

- Eric
