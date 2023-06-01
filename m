Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D30D9C77B7A
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Jun 2023 10:38:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233067AbjFAKi4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Jun 2023 06:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232964AbjFAKin (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Jun 2023 06:38:43 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF35188;
        Thu,  1 Jun 2023 03:38:40 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1q4fO9-00FdBE-GN; Thu, 01 Jun 2023 18:18:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 01 Jun 2023 18:18:37 +0800
Date:   Thu, 1 Jun 2023 18:18:37 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Kees Cook <keescook@chromium.org>
Cc:     arno@natisbad.org, arnd@kernel.org, schalla@marvell.com,
        bbrezillon@kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: marvell/cesa - Fix type mismatch warning
Message-ID: <ZHhwfVH3pldZohHC@gondor.apana.org.au>
References: <20230523083313.899332-1-arnd@kernel.org>
 <168548692863.1302890.6789778742527600870.b4-ty@chromium.org>
 <ZHcoQvWnzO0c1Cp9@gondor.apana.org.au>
 <202305310930.844EBEA21C@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202305310930.844EBEA21C@keescook>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 31, 2023 at 09:31:18AM -0700, Kees Cook wrote:
.
> I snagged it since a week had gone by with no additional discussion and
> it fixed an issue exposed by work in the hardening tree. Let me know if
> you'd prefer I drop it for you to carry instead.

Yes because these sort of changes cause unnecessary conflicts.
It's not as if the patch depends on something in the hardening
tree.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
