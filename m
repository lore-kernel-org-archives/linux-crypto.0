Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7FA8C54EAA
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Jan 2023 09:01:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235655AbjA3JBa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Jan 2023 04:01:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235609AbjA3JB3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Jan 2023 04:01:29 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 735191E1FB;
        Mon, 30 Jan 2023 01:01:28 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pMQ2P-005WQh-HO; Mon, 30 Jan 2023 17:01:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 30 Jan 2023 17:01:17 +0800
Date:   Mon, 30 Jan 2023 17:01:17 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH] crypto: arm64/sm4 - Fix possible crash in GCM cryption
Message-ID: <Y9eHXVyiSk0b+ovp@gondor.apana.org.au>
References: <20230118141928.48136-1-tianjia.zhang@linux.alibaba.com>
 <Y8gIC8Yn/E8Kwtf0@gondor.apana.org.au>
 <c7dbadbf-dade-fb1e-bda3-d23d567c620f@linux.alibaba.com>
 <Y9d8pfRQADxIhLIB@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9d8pfRQADxIhLIB@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 30, 2023 at 04:15:33PM +0800, Herbert Xu wrote:
>
> Actually I think there is a serious bug here.  If you're doing an
> empty message, you must not call skcipher_walk_done as that may
> then free random uninitialised stack memory.

Hah, I had forgotten that this thread started with your patch
to fix this exact bug :)

Could you confirm that you did copy this from ccm?

It would be nice if you could rewrite your loop in a form similar
to my patch to ccm.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
