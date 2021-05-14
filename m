Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C6E5C433ED
	for <linux-crypto@archiver.kernel.org>; Fri, 14 May 2021 11:36:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63B176145A
	for <linux-crypto@archiver.kernel.org>; Fri, 14 May 2021 11:36:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbhENLh3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 May 2021 07:37:29 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37302 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232381AbhENLh1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 May 2021 07:37:27 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.89 #2 (Debian))
        id 1lhW72-00031h-8r; Fri, 14 May 2021 19:36:12 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1lhW72-0002Z4-4o; Fri, 14 May 2021 19:36:12 +0800
Date:   Fri, 14 May 2021 19:36:12 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     davem@davemloft.net, nathan@kernel.org, ndesaulniers@google.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH] crypto: cavium/nitrox - Fix kernel-doc
Message-ID: <20210514113612.5wn2twytc4uwdxko@gondor.apana.org.au>
References: <1620381487-45311-1-git-send-email-yang.lee@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1620381487-45311-1-git-send-email-yang.lee@linux.alibaba.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 07, 2021 at 05:58:07PM +0800, Yang Li wrote:
> Fix function name in nitrox_reqmgr.c kernel-doc comment
> to remove a warning.
> 
> drivers/crypto/cavium/nitrox/nitrox_reqmgr.c:382: warning: expecting
> prototype for nitrox_se_request(). Prototype was for
> nitrox_process_se_request() instead
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>  drivers/crypto/cavium/nitrox/nitrox_reqmgr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
