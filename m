Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FB32EB64DD
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Aug 2023 04:41:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbjHKEk7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Aug 2023 00:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjHKEk6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Aug 2023 00:40:58 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748F8270F
        for <linux-crypto@vger.kernel.org>; Thu, 10 Aug 2023 21:40:54 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qUJx1-001wBr-8G; Fri, 11 Aug 2023 12:40:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Aug 2023 12:40:39 +0800
Date:   Fri, 11 Aug 2023 12:40:39 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Guozihua (Scott)" <guozihua@huawei.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org
Subject: Re: [PATCH RFC v3 3/3] crypto: Introduce SM9 key exchange algorithm
Message-ID: <ZNW7xzDM+WttXeUT@gondor.apana.org.au>
References: <20230625014958.32631-1-guozihua@huawei.com>
 <20230625014958.32631-4-guozihua@huawei.com>
 <ZLD+9pRFQdSpfMog@gondor.apana.org.au>
 <1bcf580b-3a19-c0aa-b3cb-1f9f183b61e4@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1bcf580b-3a19-c0aa-b3cb-1f9f183b61e4@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 11, 2023 at 11:25:27AM +0800, Guozihua (Scott) wrote:
>
> Just while we are here, do you think it's a good idea to also introduce
> a new crypto algorithm type for IBCs to better support their
> functionality if there are usage within kernel and we are to port this
> algorithm in?

If there is a general need for a new type then it will be considered.
I cannot answer your question as I have no idea what you have in mind
and how generally applicable it is.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
