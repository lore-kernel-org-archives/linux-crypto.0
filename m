Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C94B0C433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 18:57:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95F7F2246B
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Dec 2020 18:57:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgLaS5q (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Dec 2020 13:57:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:36392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725968AbgLaS5p (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Dec 2020 13:57:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44B13223E4;
        Thu, 31 Dec 2020 18:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609441025;
        bh=AfOy0RASxasj3RT+Ma6IdIMXrTP+m2M5LO3CjHzgPWU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BqDHgGFQZAJRs3YwdZakAS1YD4AXckPBSgnGHrkftz0mpp/XZ2aezhSsx9ZRHfn7w
         BdYtTtMtbh+URpIJDXhSo42fS1CCplqfo44sIa3ilk8uGnkDKhd7jT5z2snz1lACP8
         syj/8V+DROa9Lb53NZ7HwKbxew61kj9DDhiN4tA7m5dUdztg+SCX4ydz/GnEaWUVaC
         ccoggqKfvcIS4uV5Vk0m0nWd/j7KB8XklU4pt/lTyyM8xePNsjIGVBWz4Wm3xwxKWq
         iaSohq/qKXkI4MWH8cE+imTBLSQ6118QCx1S8tExtd296ETFtyXhSsiShMNfRcuE30
         3+51MvZoor7+w==
Date:   Thu, 31 Dec 2020 10:57:03 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, Megha Dey <megha.dey@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 16/21] crypto: x86/serpent - drop dependency on glue
 helper
Message-ID: <X+4e/9tjuPoODSrY@sol.localdomain>
References: <20201231172337.23073-1-ardb@kernel.org>
 <20201231172337.23073-17-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201231172337.23073-17-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 31, 2020 at 06:23:32PM +0100, Ard Biesheuvel wrote:
> Replace the glue helper dependency with implementations of ECB and CBC
> based on the new CPP macros, which avoid the need for indirect calls.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/x86/crypto/serpent_avx2_glue.c | 73 +++++-------------
>  arch/x86/crypto/serpent_avx_glue.c  | 61 ++++-----------
>  arch/x86/crypto/serpent_sse2_glue.c | 81 ++++++--------------
>  crypto/Kconfig                      |  3 -
>  4 files changed, 61 insertions(+), 157 deletions(-)

Acked-by: Eric Biggers <ebiggers@google.com>
