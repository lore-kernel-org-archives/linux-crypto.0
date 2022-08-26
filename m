Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E63AECAAD4
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Aug 2022 11:05:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343625AbiHZLE5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Aug 2022 07:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343592AbiHZLEd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Aug 2022 07:04:33 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 287A41CB0E;
        Fri, 26 Aug 2022 04:04:11 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oRX87-00FQ0f-3T; Fri, 26 Aug 2022 21:04:04 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 26 Aug 2022 19:04:02 +0800
Date:   Fri, 26 Aug 2022 19:04:02 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jacky Li <jackyli@google.com>
Cc:     Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Marc Orr <marcorr@google.com>, Alper Gun <alpergun@google.com>,
        Peter Gonda <pgonda@google.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] Improve error handling during INIT_EX file
 initialization
Message-ID: <YwioonMtzoQ5tNGR@gondor.apana.org.au>
References: <20220816193209.4057566-1-jackyli@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816193209.4057566-1-jackyli@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Aug 16, 2022 at 07:32:07PM +0000, Jacky Li wrote:
> Currently the PSP initialization fails when the INIT_EX file is missing
> or invalid, while the initialization continues when the OS fails to
> write the INIT_EX file. This series handles both cases in a more robust
> way by resolving the file read error as well as throwing the write error
> to the caller.
> ---
> Changelog since v1:
> - refactor around __sev_init_ex_locked() and fix format.
> 
> Jacky Li (2):
>   crypto: ccp - Initialize PSP when reading psp data file failed
>   crypto: ccp - Fail the PSP initialization when writing psp data file
>     failed
> 
>  .../virt/kvm/x86/amd-memory-encryption.rst    |  5 +-
>  drivers/crypto/ccp/sev-dev.c                  | 62 +++++++++++--------
>  2 files changed, 39 insertions(+), 28 deletions(-)
> 
> -- 
> 2.37.1.595.g718a3a8f04-goog

All applied.  Thanks. 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
