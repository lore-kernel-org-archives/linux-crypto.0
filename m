Return-Path: <SRS0=BTb3=TX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 682D7C04AAC
	for <linux-crypto@archiver.kernel.org>; Thu, 23 May 2019 06:51:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33F6A20879
	for <linux-crypto@archiver.kernel.org>; Thu, 23 May 2019 06:51:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728427AbfEWGv1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 May 2019 02:51:27 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:47780 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725814AbfEWGv1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 May 2019 02:51:27 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hThZW-0001o0-8J; Thu, 23 May 2019 14:51:26 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hThZV-0006B0-7v; Thu, 23 May 2019 14:51:25 +0800
Date:   Thu, 23 May 2019 14:51:25 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Hook, Gary" <Gary.Hook@amd.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 1/3] crypto: ccp - AES CFB mode is a stream cipher
Message-ID: <20190523065125.s5jdz3cjuoxsxc7p@gondor.apana.org.au>
References: <155787079494.29723.7921582980150013941.stgit@taos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155787079494.29723.7921582980150013941.stgit@taos>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 14, 2019 at 09:53:16PM +0000, Hook, Gary wrote:
> CFB mode should be treated as a stream cipher, not block.
> 
> Fixes: 63b945091a07 ('crypto: ccp - CCP device driver and interface support')
> 
> Signed-off-by: Gary R Hook <gary.hook@amd.com>
> ---
>  drivers/crypto/ccp/ccp-ops.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
