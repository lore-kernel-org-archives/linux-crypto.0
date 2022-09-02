Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66A83C54EE9
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Sep 2022 11:01:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235648AbiIBLBR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Sep 2022 07:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235653AbiIBLBO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Sep 2022 07:01:14 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D895872B74;
        Fri,  2 Sep 2022 04:01:13 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oU4QA-000LNs-QS; Fri, 02 Sep 2022 21:01:11 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Sep 2022 19:01:10 +0800
Date:   Fri, 2 Sep 2022 19:01:10 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     wangjianli <wangjianli@cdjrlc.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, wangjianli@cdjrlc.com
Subject: Re: [PATCH] crypto/bcm: fix repeated words in comments
Message-ID: <YxHidoYML6W8hn4p@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823135730.697-1-wangjianli@cdjrlc.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

wangjianli <wangjianli@cdjrlc.com> wrote:
> Delete the redundant word 'in'.
> 
> Signed-off-by: wangjianli <wangjianli@cdjrlc.com>
> ---
> drivers/crypto/bcm/cipher.h | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
