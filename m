Return-Path: <SRS0=BTb3=TX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B1F3C04AAC
	for <linux-crypto@archiver.kernel.org>; Thu, 23 May 2019 06:52:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DE9A2133D
	for <linux-crypto@archiver.kernel.org>; Thu, 23 May 2019 06:52:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbfEWGwg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 May 2019 02:52:36 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:47810 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725806AbfEWGwf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 May 2019 02:52:35 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hThac-0001qM-Hz; Thu, 23 May 2019 14:52:34 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hThac-0006Cj-Ed; Thu, 23 May 2019 14:52:34 +0800
Date:   Thu, 23 May 2019 14:52:34 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: crypto4xx - fix AES CTR blocksize value
Message-ID: <20190523065234.4ogebqc7ds526cft@gondor.apana.org.au>
References: <20190517211557.25815-1-chunkeey@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517211557.25815-1-chunkeey@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 17, 2019 at 11:15:57PM +0200, Christian Lamparter wrote:
> This patch fixes a issue with crypto4xx's ctr(aes) that was
> discovered by libcapi's kcapi-enc-test.sh test.
> 
> The some of the ctr(aes) encryptions test were failing on the
> non-power-of-two test:
> 
> kcapi-enc - Error: encryption failed with error 0
> kcapi-enc - Error: decryption failed with error 0
> [FAILED: 32-bit - 5.1.0-rc1+] 15 bytes: STDIN / STDOUT enc test (128 bits):
> original file (1d100e..cc96184c) and generated file (e3b0c442..1b7852b855)
> [FAILED: 32-bit - 5.1.0-rc1+] 15 bytes: STDIN / STDOUT enc test (128 bits)
> (openssl generated CT): original file (e3b0..5) and generated file (3..8e)
> [PASSED: 32-bit - 5.1.0-rc1+] 15 bytes: STDIN / STDOUT enc test (128 bits)
> (openssl generated PT)
> [FAILED: 32-bit - 5.1.0-rc1+] 15 bytes: STDIN / STDOUT enc test (password):
> original file (1d1..84c) and generated file (e3b..852b855)
> 
> But the 16, 32, 512, 65536 tests always worked.
> 
> Thankfully, this isn't a hidden hardware problem like previously,
> instead this turned out to be a copy and paste issue.
> 
> With this patch, all the tests are passing with and
> kcapi-enc-test.sh gives crypto4xx's a clean bill of health:
>  "Number of failures: 0" :).
> 
> Cc: stable@vger.kernel.org
> Fixes: 98e87e3d933b ("crypto: crypto4xx - add aes-ctr support")
> Fixes: f2a13e7cba9e ("crypto: crypto4xx - enable AES RFC3686, ECB, CFB and OFB offloads")
> Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
> ---
>  drivers/crypto/amcc/crypto4xx_core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
