Return-Path: <SRS0=Q4nt=4B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23073C2BA83
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Feb 2020 09:25:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0043A21734
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Feb 2020 09:25:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729602AbgBMJZT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Feb 2020 04:25:19 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:42520 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729600AbgBMJZT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Feb 2020 04:25:19 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1j2AkI-0004Bi-AD; Thu, 13 Feb 2020 17:25:18 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1j2AkI-0006rR-4H; Thu, 13 Feb 2020 17:25:18 +0800
Date:   Thu, 13 Feb 2020 17:25:18 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Devulapally Shiva Krishna <shiva@chelsio.com>
Cc:     linux-crypto@vger.kernel.org, manojmalviya@chelsio.com
Subject: Re: [Crypto] chcr: Print the chcr driver information while module
 load.
Message-ID: <20200213092518.2pxkrpx6z6kpjqk4@gondor.apana.org.au>
References: <20200205103433.10490-1-shiva@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200205103433.10490-1-shiva@chelsio.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 05, 2020 at 04:04:33PM +0530, Devulapally Shiva Krishna wrote:
> No logs are recorded in dmesg during chcr module load, hence
> adding the print and also appending -ko to driver version.
> 
> Signed-off-by: Devulapally Shiva Krishna <shiva@chelsio.com>
> ---
>  drivers/crypto/chelsio/chcr_core.c | 1 +
>  drivers/crypto/chelsio/chcr_core.h | 3 ++-
>  2 files changed, 3 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
