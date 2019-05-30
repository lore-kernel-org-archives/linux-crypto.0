Return-Path: <SRS0=uqbH=T6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42398C28CC0
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 13:41:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F2F3259CC
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 13:41:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbfE3NlI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 May 2019 09:41:08 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37960 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725913AbfE3NlI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 May 2019 09:41:08 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hWLIp-0005XC-9i; Thu, 30 May 2019 21:41:07 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hWLIp-0003dA-3H; Thu, 30 May 2019 21:41:07 +0800
Date:   Thu, 30 May 2019 21:41:07 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] crypto: testmgr - fix length truncation with large page
 size
Message-ID: <20190530134107.2p7uldj6ippr3wsa@gondor.apana.org.au>
References: <20190520164719.160956-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520164719.160956-1-ebiggers@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, May 20, 2019 at 09:47:19AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> On PowerPC with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y, there is sometimes
> a crash in generate_random_aead_testvec().  The problem is that the
> generated test vectors use data lengths of up to about 2 * PAGE_SIZE,
> which is 128 KiB on PowerPC; however, the data length fields in the test
> vectors are 'unsigned short', so the lengths get truncated.  Fix this by
> changing the relevant fields to 'unsigned int'.
> 
> Fixes: 40153b10d91c ("crypto: testmgr - fuzz AEADs against their generic implementation")
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  crypto/testmgr.h | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
