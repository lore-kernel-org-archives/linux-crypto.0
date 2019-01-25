Return-Path: <SRS0=/CTJ=QB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48E08C282C0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 10:46:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2216D218D2
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 10:46:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbfAYKqW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Jan 2019 05:46:22 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:44416 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbfAYKqW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Jan 2019 05:46:22 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gmz06-0005d4-9D; Fri, 25 Jan 2019 18:46:18 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gmz04-00024F-PO; Fri, 25 Jan 2019 18:46:16 +0800
Date:   Fri, 25 Jan 2019 18:46:16 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] bug fixes and cleanups
Message-ID: <20190125104616.siliqra75iskpadu@gondor.apana.org.au>
References: <20190115134318.28712-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190115134318.28712-1-gilad@benyossef.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 15, 2019 at 03:43:10PM +0200, Gilad Ben-Yossef wrote:
> Assorted bug fixes and cleanups
> 
> Gilad Ben-Yossef (3):
>   crypto: ccree: unmap buffer before copying IV
>   crypto: ccree: shared irq lines are not a bug
>   crypto: ccree: don't copy zero size ciphertext
> 
> Hadar Gat (4):
>   crypto: ccree: improve error handling
>   crypto: ccree: add error message
>   crypto: ccree: fix free of unallocated mlli buffer
>   crypto: ccree: remove legacy leftover
> 
>  drivers/crypto/ccree/cc_buffer_mgr.c | 87 ++++++++++++++--------------
>  drivers/crypto/ccree/cc_cipher.c     |  6 +-
>  drivers/crypto/ccree/cc_driver.c     |  6 +-
>  drivers/crypto/ccree/cc_driver.h     |  2 -
>  4 files changed, 50 insertions(+), 51 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
