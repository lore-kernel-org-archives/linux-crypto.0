Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED11EEB64DA
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Jul 2023 07:59:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235503AbjGNH7P (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Jul 2023 03:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235647AbjGNH5t (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Jul 2023 03:57:49 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4BBB46A8
        for <linux-crypto@vger.kernel.org>; Fri, 14 Jul 2023 00:55:49 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qKDcL-001ROL-P1; Fri, 14 Jul 2023 17:53:34 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 14 Jul 2023 17:53:26 +1000
Date:   Fri, 14 Jul 2023 17:53:26 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     GUO Zihua <guozihua@huawei.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org
Subject: Re: [PATCH RFC v3 3/3] crypto: Introduce SM9 key exchange algorithm
Message-ID: <ZLD+9pRFQdSpfMog@gondor.apana.org.au>
References: <20230625014958.32631-1-guozihua@huawei.com>
 <20230625014958.32631-4-guozihua@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230625014958.32631-4-guozihua@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Jun 25, 2023 at 09:49:58AM +0800, GUO Zihua wrote:
> This patch introduces a generic implementation of SM9 (ShangMi 9) key
> exchange algorithm.
> 
> SM9 is an ID-based cryptography algorithm within the ShangMi family whose
> key exchange algorithm was accepted in ISO/IEC 11770-3 as an
> international standard.

For each new algorithm we require an in-kernel user.  Where is the
in-kernel user for this?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
