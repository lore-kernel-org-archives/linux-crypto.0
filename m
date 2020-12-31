Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68BE4C433DB
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 18:58:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39B9C223E4
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 18:58:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgLaS57 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Dec 2020 13:57:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:36414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725968AbgLaS57 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Dec 2020 13:57:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5091223E8;
        Thu, 31 Dec 2020 18:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609441038;
        bh=xGbPnG0HkGEa5OdQPWcv5FeDYq3GfBX+8onSV5IVC38=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aEKPonZGgsLmHsdcI5P2Q4sioT+OLjhD5Lim9qgp0i/2Jof1UBK55FTtBMHOBeTRL
         5h2KNpcslCqFUb9lU8D3WL2UMU/pBjXxr4zAHrNjoBEcrAOU8AWIFt9XeUDI6lEC2y
         BrIBDvDdXsqKowv3bgRwplNe25o/mxzGdsSz6vZahoRpJpAsEqBK9bB5YwIq1DPlHR
         9/j/GjfBu3zhxQ9+kIyf4zrVwmubox1QzpR+eu7OtrOhVjYD23jtdWCZaicri1vMLi
         Lzl1Wfq+kVufbrKKXtpU6wERf1yN7J5cB5kUnEHNdW3cRB/+TGEgQJrdiclqMaBrEH
         8dAvFXcQj7HVQ==
Date:   Thu, 31 Dec 2020 10:57:17 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, Megha Dey <megha.dey@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 17/21] crypto: x86/cast5 - drop dependency on glue helper
Message-ID: <X+4fDaYH12RVwmeO@sol.localdomain>
References: <20201231172337.23073-1-ardb@kernel.org>
 <20201231172337.23073-18-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201231172337.23073-18-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 31, 2020 at 06:23:33PM +0100, Ard Biesheuvel wrote:
> Replace the glue helper dependency with implementations of ECB and CBC
> based on the new CPP macros, which avoid the need for indirect calls.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/x86/crypto/cast5_avx_glue.c | 184 ++------------------
>  1 file changed, 17 insertions(+), 167 deletions(-)

Acked-by: Eric Biggers <ebiggers@google.com>
