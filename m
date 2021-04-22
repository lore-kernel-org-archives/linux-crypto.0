Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F3F6C433B4
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Apr 2021 07:45:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13C2461452
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Apr 2021 07:45:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbhDVHpv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Apr 2021 03:45:51 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:48680 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229629AbhDVHpu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Apr 2021 03:45:50 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1lZU1M-0002y3-Ic; Thu, 22 Apr 2021 17:45:09 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 22 Apr 2021 17:45:08 +1000
Date:   Thu, 22 Apr 2021 17:45:08 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: fix kernel-doc notation in chacha.c and af_alg.c
Message-ID: <20210422074508.GA14354@gondor.apana.org.au>
References: <20210412000556.32051-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412000556.32051-1-rdunlap@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Apr 11, 2021 at 05:05:56PM -0700, Randy Dunlap wrote:
> Fix function name in chacha.c kernel-doc comment to remove a warning.
> 
> Convert af_alg.c to kernel-doc notation to eliminate many kernel-doc
> warnings.
> 
> ../lib/crypto/chacha.c:77: warning: expecting prototype for chacha_block(). Prototype was for chacha_block_generic() instead
> chacha.c:104: warning: Excess function parameter 'out' description in 'hchacha_block_generic'
> 
> af_alg.c:498: warning: Function parameter or member 'sk' not described in 'af_alg_alloc_tsgl'
> ../crypto/af_alg.c:539: warning: expecting prototype for aead_count_tsgl(). Prototype was for af_alg_count_tsgl() instead
> ../crypto/af_alg.c:596: warning: expecting prototype for aead_pull_tsgl(). Prototype was for af_alg_pull_tsgl() instead
> af_alg.c:663: warning: Function parameter or member 'areq' not described in 'af_alg_free_areq_sgls'
> af_alg.c:700: warning: Function parameter or member 'sk' not described in 'af_alg_wait_for_wmem'
> af_alg.c:700: warning: Function parameter or member 'flags' not described in 'af_alg_wait_for_wmem'
> af_alg.c:731: warning: Function parameter or member 'sk' not described in 'af_alg_wmem_wakeup'
> af_alg.c:757: warning: Function parameter or member 'sk' not described in 'af_alg_wait_for_data'
> af_alg.c:757: warning: Function parameter or member 'flags' not described in 'af_alg_wait_for_data'
> af_alg.c:757: warning: Function parameter or member 'min' not described in 'af_alg_wait_for_data'
> af_alg.c:796: warning: Function parameter or member 'sk' not described in 'af_alg_data_wakeup'
> af_alg.c:832: warning: Function parameter or member 'sock' not described in 'af_alg_sendmsg'
> af_alg.c:832: warning: Function parameter or member 'msg' not described in 'af_alg_sendmsg'
> af_alg.c:832: warning: Function parameter or member 'size' not described in 'af_alg_sendmsg'
> af_alg.c:832: warning: Function parameter or member 'ivsize' not described in 'af_alg_sendmsg'
> af_alg.c:985: warning: Function parameter or member 'sock' not described in 'af_alg_sendpage'
> af_alg.c:985: warning: Function parameter or member 'page' not described in 'af_alg_sendpage'
> af_alg.c:985: warning: Function parameter or member 'offset' not described in 'af_alg_sendpage'
> af_alg.c:985: warning: Function parameter or member 'size' not described in 'af_alg_sendpage'
> af_alg.c:985: warning: Function parameter or member 'flags' not described in 'af_alg_sendpage'
> af_alg.c:1040: warning: Function parameter or member 'areq' not described in 'af_alg_free_resources'
> af_alg.c:1059: warning: Function parameter or member '_req' not described in 'af_alg_async_cb'
> af_alg.c:1059: warning: Function parameter or member 'err' not described in 'af_alg_async_cb'
> af_alg.c:1083: warning: Function parameter or member 'file' not described in 'af_alg_poll'
> af_alg.c:1083: warning: Function parameter or member 'sock' not described in 'af_alg_poll'
> af_alg.c:1083: warning: Function parameter or member 'wait' not described in 'af_alg_poll'
> af_alg.c:1114: warning: Function parameter or member 'sk' not described in 'af_alg_alloc_areq'
> af_alg.c:1114: warning: Function parameter or member 'areqlen' not described in 'af_alg_alloc_areq'
> af_alg.c:1146: warning: Function parameter or member 'sk' not described in 'af_alg_get_rsgl'
> af_alg.c:1146: warning: Function parameter or member 'msg' not described in 'af_alg_get_rsgl'
> af_alg.c:1146: warning: Function parameter or member 'flags' not described in 'af_alg_get_rsgl'
> af_alg.c:1146: warning: Function parameter or member 'areq' not described in 'af_alg_get_rsgl'
> af_alg.c:1146: warning: Function parameter or member 'maxsize' not described in 'af_alg_get_rsgl'
> af_alg.c:1146: warning: Function parameter or member 'outlen' not described in 'af_alg_get_rsgl'
> 
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-crypto@vger.kernel.org
> ---
>  crypto/af_alg.c     |   94 +++++++++++++++++++++++-------------------
>  lib/crypto/chacha.c |    4 -
>  2 files changed, 55 insertions(+), 43 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
