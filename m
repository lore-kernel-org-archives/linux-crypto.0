Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AAD7C63777
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Nov 2020 06:26:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C596621D46
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Nov 2020 06:26:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392591AbgK0G0c (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Nov 2020 01:26:32 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:33440 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732040AbgK0G0b (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Nov 2020 01:26:31 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kiXDB-0000yK-49; Fri, 27 Nov 2020 17:26:30 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Nov 2020 17:26:28 +1100
Date:   Fri, 27 Nov 2020 17:26:28 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, ebiggers@google.com
Subject: Re: [PATCH v2 0/3] crypto: tcrypt enhancements
Message-ID: <20201127062628.GE11448@gondor.apana.org.au>
References: <20201120110433.31090-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201120110433.31090-1-ardb@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 20, 2020 at 12:04:30PM +0100, Ard Biesheuvel wrote:
> Some tcrypt enhancements that I have been using locally to test and
> benchmark crypto algorithms on the command line using KVM:
> - allow tcrypt.ko to be builtin and defer its initialization to late_initcall
> - add 1420 byte blocks to the list of benchmarked block sizes for AEADs and
>   skciphers, to get an estimate of the performance in the context of a VPN
> 
> Changes since v1:
> - use CONFIG_EXPERT not CONFIG_CRYPTO_MANAGER_EXTRA_TESTS to decide whether
>   tcrypt.ko may be built in
> - add Eric's ack to #1
> 
> Ard Biesheuvel (3):
>   crypto: tcrypt - don't initialize at subsys_initcall time
>   crypto: tcrypt - permit tcrypt.ko to be builtin
>   crypto: tcrypt - include 1420 byte blocks in aead and skcipher
>     benchmarks
> 
>  crypto/Kconfig  |  2 +-
>  crypto/tcrypt.c | 83 +++++++++++---------
>  2 files changed, 46 insertions(+), 39 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
