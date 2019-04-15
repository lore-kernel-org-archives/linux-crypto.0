Return-Path: <SRS0=EtZ3=SR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11895C10F0E
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Apr 2019 06:38:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBF6220825
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Apr 2019 06:38:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725816AbfDOGik (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Apr 2019 02:38:40 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:59630 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725796AbfDOGik (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Apr 2019 02:38:40 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hFvGD-0003eS-MR; Mon, 15 Apr 2019 14:38:33 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hFvGD-00044P-3B; Mon, 15 Apr 2019 14:38:33 +0800
Date:   Mon, 15 Apr 2019 14:38:33 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     syzbot <syzbot+6f72c20560060c98b566@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Ondrej Mosnacek <omosnace@redhat.com>
Subject: Re: crypto: xts - Fix atomic sleep when walking skcipher
Message-ID: <20190415063832.2qmhtek644nd2ywt@gondor.apana.org.au>
References: <0000000000002bb2b105867bcd11@google.com>
 <20190414120338.edioq25dkafp2m7h@gondor.apana.org.au>
 <20190414163512.GA644@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190414163512.GA644@sol.localdomain>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Apr 14, 2019 at 09:35:13AM -0700, Eric Biggers wrote:
>
> This isn't correct because skcipher_walk_virt() can still sleep when
> atomic=true, since it may need to copy the IV.  That's why I added might_sleep()
> to it in commit bb648291fc04, and that's what's triggering here.

Thanks for catching this Eric!

> This is the correct fix:
> 
> diff --git a/crypto/xts.c b/crypto/xts.c
> index aed11e63ca315..359ef15e1673e 100644
> --- a/crypto/xts.c
> +++ b/crypto/xts.c
> @@ -101,6 +101,7 @@ static int xor_tweak(struct skcipher_request *req, bool second_pass)
>  		req = &rctx->subreq;
>  		/* set to our TFM to enforce correct alignment: */
>  		skcipher_request_set_tfm(req, tfm);
> +		req->base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
>  	}

This is what I'm doing in v2, except I've moved it over to
crypt_done so that we don't affect the synchronous path.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
