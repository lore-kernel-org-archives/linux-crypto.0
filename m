Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E338DC6FA99
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Mar 2023 11:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbjCJL3h (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Mar 2023 06:29:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbjCJL3J (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Mar 2023 06:29:09 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ADE0F222B;
        Fri, 10 Mar 2023 03:29:06 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1paavf-002Xzx-Mn; Fri, 10 Mar 2023 19:28:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 10 Mar 2023 19:28:55 +0800
Date:   Fri, 10 Mar 2023 19:28:55 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Anthony Yznaga <anthony.yznaga@oracle.com>
Cc:     daniel.m.jordan@oracle.com, steffen.klassert@secunet.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] padata: use alignment when calculating the number of
 worker threads
Message-ID: <ZAsUd3Fg3A6pImbd@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1677112392-17332-1-git-send-email-anthony.yznaga@oracle.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Anthony Yznaga <anthony.yznaga@oracle.com> wrote:
> For multithreaded jobs the computed chunk size is rounded up by the
> caller-specified alignment. However, the number of worker threads to
> use is computed using the minimum chunk size without taking alignment
> into account. A sufficiently large alignment value can result in too
> many worker threads being allocated for the job.
> 
> Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
> ---
> kernel/padata.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
