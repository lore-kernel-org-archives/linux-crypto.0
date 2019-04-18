Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 800EFC10F0E
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 04:08:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 562902184B
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 04:08:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725785AbfDREIA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 00:08:00 -0400
Received: from [128.1.224.119] ([128.1.224.119]:34742 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725710AbfDREH7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 00:07:59 -0400
X-Greylist: delayed 1884 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Apr 2019 00:07:59 EDT
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hGxqd-0000T9-Ne; Thu, 18 Apr 2019 11:36:27 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hGxqX-0007Wg-6Y; Thu, 18 Apr 2019 11:36:21 +0800
Date:   Thu, 18 Apr 2019 11:36:21 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: Question regarding crypto scatterlists / testmgr
Message-ID: <20190418033621.fnj72tffc3exfh3b@gondor.apana.org.au>
References: <AM6PR09MB352386B26E3F632D6FE2FDDDD2250@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190417202407.GA96242@gmail.com>
 <AM6PR09MB3523FD88FE64E10B78B555F4D2250@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu9AztOdP2GfR-DBTfTcgjJrjMJ7HbApWG-EpPjpSfn16A@mail.gmail.com>
 <AM6PR09MB3523EFFDD4FF6910B4AA12C3D2260@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu9_8DgmNhzVqXbkrv7y-7++a-yYxXkaYNzV-yDArDtyZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9_8DgmNhzVqXbkrv7y-7++a-yYxXkaYNzV-yDArDtyZQ@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Apr 17, 2019 at 08:29:59PM -0700, Ard Biesheuvel wrote:
>
> Seems like I was misreading the code: we have the following code in
> skcipher_walk_next
> 
> if (!err && (walk->flags & SKCIPHER_WALK_PHYS)) {
>     walk->src.phys.page = virt_to_page(walk->src.virt.addr);
>     walk->dst.phys.page = virt_to_page(walk->dst.virt.addr);
>     walk->src.phys.offset &= PAGE_SIZE - 1;
>     walk->dst.phys.offset &= PAGE_SIZE - 1;
> }
> 
> but all that does is normalize the offset. In fact, this code looks
> slightly dodgy to me, given that, if the offset /does/ exceed
> PAGE_SIZE, it normalizes the offset but does not advance the page
> pointers accordingly.

I wouldn't be surprised if the async walk code is buggy.  Hardly
anybody uses this.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
