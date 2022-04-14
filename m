Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0DDAC433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Apr 2022 09:46:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241493AbiDNJsn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Apr 2022 05:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241972AbiDNJqn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Apr 2022 05:46:43 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D897716CE;
        Thu, 14 Apr 2022 02:44:01 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1new0p-002mNt-5C; Thu, 14 Apr 2022 19:43:40 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 14 Apr 2022 17:43:39 +0800
Date:   Thu, 14 Apr 2022 17:43:39 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Will Deacon <will@kernel.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: arm64/sm4 - Fix wrong dependency of NEON/CE
 implementation
Message-ID: <Ylfsy5VoJx9ACg3f@gondor.apana.org.au>
References: <20220411031313.35449-1-tianjia.zhang@linux.alibaba.com>
 <20220413102209.GB1229@willie-the-truck>
 <Yla4pSKW+6I5jIfS@zx2c4.com>
 <20220414093445.GA2006@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220414093445.GA2006@willie-the-truck>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 14, 2022 at 10:34:45AM +0100, Will Deacon wrote:
>
> Cheers, then I'll leave this fix for Herbert to pick up.

Sorry, I think it was my merge error that created this bug
in the first place.  I'll pick up the fix.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
