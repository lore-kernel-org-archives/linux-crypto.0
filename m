Return-Path: <SRS0=0IUk=SK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5385DC282CE
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Apr 2019 06:40:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B5D52084F
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Apr 2019 06:40:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbfDHGku (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Apr 2019 02:40:50 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:45876 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725983AbfDHGku (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Apr 2019 02:40:50 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hDNxY-00089Z-JW; Mon, 08 Apr 2019 14:40:48 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hDNxT-0005pn-4p; Mon, 08 Apr 2019 14:40:43 +0800
Date:   Mon, 8 Apr 2019 14:40:43 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Andi Kleen <andi@firstfloor.org>
Cc:     linux-crypto@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH] crypto: Use ___cacheline_aligned for aes data
Message-ID: <20190408064043.icilagktch3dxo3j@gondor.apana.org.au>
References: <20190330004629.29394-1-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190330004629.29394-1-andi@firstfloor.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 29, 2019 at 05:46:29PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> cacheline_aligned is a special section. It cannot be const at the same
> time because it's not read-only. It doesn't give any MMU protection.
> 
> Mark it ____cacheline_aligned to not place it in a special section,
> but just align it in .rodata
> 
> Cc: herbert@gondor.apana.org.au
> Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  crypto/aes_generic.c | 8 ++++----
>  include/crypto/aes.h | 8 ++++----
>  2 files changed, 8 insertions(+), 8 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
