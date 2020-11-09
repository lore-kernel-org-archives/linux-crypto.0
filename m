Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DD86C388F7
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Nov 2020 17:59:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAA212068D
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Nov 2020 17:59:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="YHy6aR6t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730393AbgKIR7t (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Nov 2020 12:59:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:47468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730372AbgKIR7t (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Nov 2020 12:59:49 -0500
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9556920665;
        Mon,  9 Nov 2020 17:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604944788;
        bh=D86N+xJJTD4G6fYVyFklBBftNjmt5YvqPjyuyjoPGHQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YHy6aR6tnp/fS0OgBUeVdQka2Pik1idrDYAGOPYgFxqI4t0bzPcsY32DHRyfjGG/5
         XO+3uBHMevOMytTKjH94fXSUHPZY6X3kkLkNib5awHGgkQQilPnRTcsSUAbl3r/qTf
         /AxeBAeIp6xAPXgynqtyBBHrXj8TJ9AAL5TnoElM=
Date:   Mon, 9 Nov 2020 09:59:47 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Subject: Re: [PATCH 1/3] crypto: tcrypt - don't initialize at subsys_initcall
 time
Message-ID: <20201109175947.GA853@sol.localdomain>
References: <20201109083143.2884-1-ardb@kernel.org>
 <20201109083143.2884-2-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201109083143.2884-2-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Nov 09, 2020 at 09:31:41AM +0100, Ard Biesheuvel wrote:
> Commit c4741b2305979 ("crypto: run initcalls for generic implementations
> earlier") converted tcrypt.ko's module_init() to subsys_initcall(), but
> this was unintentional: tcrypt.ko currently cannot be built into the core
> kernel, and so the subsys_initcall() gets converted into module_init()
> under the hood. Given that tcrypt.ko does not implement a generic version
> of a crypto algorithm that has to be available early during boot, there
> is no point in running the tcrypt init code earlier than implied by
> module_init().
> 
> However, for crypto development purposes, we will lift the restriction
> that tcrypt.ko must be built as a module, and when builtin, it makes sense
> for tcrypt.ko (which does its work inside the module init function) to run
> as late as possible. So let's switch to late_initcall() instead.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  crypto/tcrypt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
> index eea0f453cfb6..fc1f3e516694 100644
> --- a/crypto/tcrypt.c
> +++ b/crypto/tcrypt.c
> @@ -3066,7 +3066,7 @@ static int __init tcrypt_mod_init(void)
>   */
>  static void __exit tcrypt_mod_fini(void) { }
>  
> -subsys_initcall(tcrypt_mod_init);
> +late_initcall(tcrypt_mod_init);
>  module_exit(tcrypt_mod_fini);
>  
>  module_param(alg, charp, 0);
> -- 

Reviewed-by: Eric Biggers <ebiggers@google.com>
