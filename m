Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30BA0C433DB
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Mar 2021 16:46:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04CA3619C8
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Mar 2021 16:46:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233300AbhCWQpe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Mar 2021 12:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233299AbhCWQpM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Mar 2021 12:45:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C94C0C061574;
        Tue, 23 Mar 2021 09:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=zzu/xcn7sghWXmeoDI7Yw3IsP/Ljt8YacCwRazpIVIs=; b=FDBnzXOE4hpdcNK/uHISdHlTJL
        pE5bGCV+YPuJzn5Q0N336UFsRNRyt04ZEaeH4nomMbZFpqNXuYglGSmQmrqkd6siRDQEvi8oaKZOq
        OOk1zHPQoVuNA/AFJe6vzHkPxT21pKEzqX7IT8G559O61wUlqjGsil9VzzylhjwS2+nCogn/GrdUW
        NBM+rylskcYIC4aw80702/sRWJL4p/r9DdHJpZZ82V7+/uTAG442ynAPZJLyEz6edmTfEiv89QPVp
        Uotuxnt4XDlGObVV5DCbJ07ZRRVD0yCaOxAM1x4KoGBjrMr0GMBhv403zWmEXs4/3ZDFi3FGebj1f
        uT9HE14A==;
Received: from [2601:1c0:6280:3f0::3ba4]
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lOk87-00AIWN-H4; Tue, 23 Mar 2021 16:44:04 +0000
Subject: Re: [PATCH] init/Kconfig: Support sign module with SM3 hash algorithm
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Nick Terrell <terrelln@fb.com>, KP Singh <kpsingh@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vlastimil Babka <vbabka@suse.cz>, keyrings@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Jia Zhang <zhang.jia@linux.alibaba.com>
References: <20210323083528.25678-1-tianjia.zhang@linux.alibaba.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <28d3a339-6210-ffd2-950f-ea5340ac23b7@infradead.org>
Date:   Tue, 23 Mar 2021 09:43:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210323083528.25678-1-tianjia.zhang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/23/21 1:35 AM, Tianjia Zhang wrote:
> The kernel module signature supports the option to use the SM3
> secure hash (OSCCA GM/T 0004-2012 SM3).
> 
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> ---
>  Documentation/admin-guide/module-signing.rst | 5 +++--
>  crypto/asymmetric_keys/pkcs7_parser.c        | 7 +++++++
>  init/Kconfig                                 | 5 +++++
>  3 files changed, 15 insertions(+), 2 deletions(-)
> 

> diff --git a/init/Kconfig b/init/Kconfig
> index 5f5c776ef192..fed9236078e4 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -2202,6 +2202,10 @@ config MODULE_SIG_SHA512
>  	bool "Sign modules with SHA-512"
>  	select CRYPTO_SHA512
>  
> +config MODULE_SIG_SM3
> +	bool "Sign modules with SM3"
> +	select CRYPTO_SM3
> +
>  endchoice
>  
>  config MODULE_SIG_HASH
> @@ -2212,6 +2216,7 @@ config MODULE_SIG_HASH
>  	default "sha256" if MODULE_SIG_SHA256
>  	default "sha384" if MODULE_SIG_SHA384
>  	default "sha512" if MODULE_SIG_SHA512
> +	default "sm3" if MODULE_SIG_SM3
>  
>  config MODULE_COMPRESS
>  	bool "Compress modules on installation"
> 

checkpatch tells me:

WARNING: please write a paragraph that describes the config symbol fully
#74: FILE: init/Kconfig:2205:
+config MODULE_SIG_SM3


so yes, it should have some help text there.

thanks.
-- 
~Randy

