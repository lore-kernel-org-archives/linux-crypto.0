Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E488C7EE24
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Jun 2023 10:20:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235081AbjFBKUM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Jun 2023 06:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235334AbjFBKUA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Jun 2023 06:20:00 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42782E48;
        Fri,  2 Jun 2023 03:19:52 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1q51si-00G2mo-82; Fri, 02 Jun 2023 18:19:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Jun 2023 18:19:40 +0800
Date:   Fri, 2 Jun 2023 18:19:40 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     yangmengfei1394 <yangmengfei1394@phytium.com.cn>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Crypto module : rearrange the default functions of
 akcipher
Message-ID: <ZHnCPBjPROACJpDd@gondor.apana.org.au>
References: <20230510075142.1638-1-yangmengfei1394@phytium.com.cn>
 <20230522033027.989-1-yangmengfei1394@phytium.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230522033027.989-1-yangmengfei1394@phytium.com.cn>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, May 22, 2023 at 11:30:27AM +0800, yangmengfei1394 wrote:
> According to your last email, we rearrange the default functions,
> move the code that sets the default functions from
> crypto_register_akcipher into akcipher_prepare_alg,
> add the set_pub_key function check at the same time.

Why are you adding set_pub_key? Every implementation should
provide this function.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
