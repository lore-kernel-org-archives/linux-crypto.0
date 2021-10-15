Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06445C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Oct 2021 11:19:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC64460EFF
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Oct 2021 11:19:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238415AbhJOLVM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Oct 2021 07:21:12 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:56094 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230386AbhJOLVM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Oct 2021 07:21:12 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mbLEn-00089L-GY; Fri, 15 Oct 2021 19:18:57 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mbLEj-0006m3-0b; Fri, 15 Oct 2021 19:18:53 +0800
Date:   Fri, 15 Oct 2021 19:18:53 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Peter Gonda <pgonda@google.com>
Cc:     thomas.lendacky@amd.com, Brijesh Singh <brijesh.singh@amd.com>,
        Marc Orr <marcorr@google.com>, Joerg Roedel <jroedel@suse.de>,
        David Rientjes <rientjes@google.com>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ccp - Fix whitespace in sev_cmd_buffer_len()
Message-ID: <20211015111852.GA26012@gondor.apana.org.au>
References: <20211005195131.2904331-1-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211005195131.2904331-1-pgonda@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Oct 05, 2021 at 12:51:31PM -0700, Peter Gonda wrote:
> Extra tab in sev_cmd_buffer_len().
> 
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Marc Orr <marcorr@google.com>
> Cc: Joerg Roedel <jroedel@suse.de>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David Rientjes <rientjes@google.com>
> Cc: John Allen <john.allen@amd.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/crypto/ccp/sev-dev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
