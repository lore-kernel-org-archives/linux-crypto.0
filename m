Return-Path: <SRS0=AT0s=ZU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 335E4C432C0
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Nov 2019 00:25:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A8BB21555
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Nov 2019 00:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574900714;
	bh=TSWGxtFnEBAUSbjy6y1UJSnL0fiDiivQOod45cwNQDU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=UBKUyA+r3M3+ffB5qgkTqVgS/8kU+h2zTmn5m/rD6mSkciw/W43z+qtduIWd+kVAl
	 +cHSyXae57hUouwlaNbykkzWKDVdGLH83Urg9llAur6KBHd/W8kzBQPmiPZFsxwkyC
	 NDX2uTEWStpOUQMKiZRDg6Kbi7Iju8X8tzEvgjKE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbfK1AZK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Nov 2019 19:25:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:52904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727031AbfK1AZK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Nov 2019 19:25:10 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 960D821555;
        Thu, 28 Nov 2019 00:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574900709;
        bh=TSWGxtFnEBAUSbjy6y1UJSnL0fiDiivQOod45cwNQDU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vv91YfHS3njFVAarOYfXa3zub5sETwPlq7s4BybuhtyRAR5aNWos1ybejuP240QIG
         asmaFXBMvgE9NPHgA4Ma1d5MtnKY7cWbb3dn4wXRccG0/CA8X69w+K3edHA4rJPGMh
         QDYa7Q6oTPzyEPr5q9RTx7UGze5B91vNlMyq3XGE=
Date:   Wed, 27 Nov 2019 16:25:08 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sami Tolvanen <samitolvanen@google.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v4] crypto: arm64/sha: fix function types
Message-ID: <20191128002508.GB303989@sol.localdomain>
References: <20191112223046.176097-1-samitolvanen@google.com>
 <20191127235503.93635-1-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191127235503.93635-1-samitolvanen@google.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Nov 27, 2019 at 03:55:03PM -0800, Sami Tolvanen wrote:
> Instead of casting pointers to callback functions, add C wrappers
> to avoid type mismatch failures with Control-Flow Integrity (CFI)
> checking.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
> ---
> Changes in v4:
>   - Removed unnecessary returns.
> 
> Changes in v3:
>   - Removed unnecessary inline attributes.
> 
> Changes in v2:
>   - Added wrapper functions instead of changing parameter types
>     for the assembly functions.
> 

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

- Eric
