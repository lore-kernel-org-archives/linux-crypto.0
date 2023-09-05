Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 013C5CA0FF3
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Sep 2023 16:20:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245214AbjIEQUd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353795AbjIEISF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Sep 2023 04:18:05 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C3E1AE;
        Tue,  5 Sep 2023 01:17:59 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qdRFi-00AtI6-RA; Tue, 05 Sep 2023 16:17:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 05 Sep 2023 16:17:40 +0800
Date:   Tue, 5 Sep 2023 16:17:40 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Marion & Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Longfang Liu <liulongfang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Zaibo Xu <xuzaibo@huawei.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: hisilicon/hpre - Fix a erroneous check after
 snprintf()
Message-ID: <ZPbkJOPsx4as96D/@gondor.apana.org.au>
References: <73534cb1713f58228d54ea53a8a137f4ef939bad.1693858632.git.christophe.jaillet@wanadoo.fr>
 <ZPaSCOX1F9b36rxV@gondor.apana.org.au>
 <00bdcfec-6cc1-e521-ceaa-d16d6341ca16@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00bdcfec-6cc1-e521-ceaa-d16d6341ca16@wanadoo.fr>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Sep 05, 2023 at 07:27:47AM +0200, Marion & Christophe JAILLET wrote:
>
> Some debugfs dir of file way be left around. Is it what your are talking
> about?

Yes all allocated resources should be freed on the error path.

> > The other snprintf in the same file also looks suspect.
> 
> It looks correct to me.
> 
> And HPRE_DBGFS_VAL_MAX_LEN being 20, it doesn't really matter. The string
> can't be truncated with just a "%u\n".

Well if you're going to go with that line of reasoning then this
case ("cluster%d") can't overflow either, no?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
