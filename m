Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFDA7C432BE
	for <linux-crypto@archiver.kernel.org>; Sat, 28 Aug 2021 06:47:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86789608FB
	for <linux-crypto@archiver.kernel.org>; Sat, 28 Aug 2021 06:47:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233317AbhH1GsZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 28 Aug 2021 02:48:25 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:54472 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233088AbhH1GsZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 28 Aug 2021 02:48:25 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mJs7i-0008E9-EV; Sat, 28 Aug 2021 14:47:26 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mJs7Y-0006ig-53; Sat, 28 Aug 2021 14:47:16 +0800
Date:   Sat, 28 Aug 2021 14:47:16 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "yekai(A)" <yekai13@huawei.com>
Cc:     wangzhou1@hisilicon.com, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 2/5] crypto: hisilicon/sec - add ahash alg features for
 Kunpeng920
Message-ID: <20210828064716.GA25697@gondor.apana.org.au>
References: <1628847626-24383-1-git-send-email-yekai13@huawei.com>
 <1628847626-24383-3-git-send-email-yekai13@huawei.com>
 <20210821072557.GA31491@gondor.apana.org.au>
 <bac4d0b8-0dd1-ddeb-8d78-0c20a2d5ecdc@huawei.com>
 <20210827083652.GD21571@gondor.apana.org.au>
 <337a3bac-86d4-c66e-9d6a-d4aa6685f83d@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <337a3bac-86d4-c66e-9d6a-d4aa6685f83d@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Aug 28, 2021 at 11:16:47AM +0800, yekai(A) wrote:
>
> I refered to other people's plans. Modify the value of halg.statesize
> is sizeof(struct sec_req) + sizeof(u32), So user can allocate an extra
> sizeof(u32) memory. The driver will write a tag number to the addr in the
> export process, then the driver will check the pointers by the tag number
> through the import path.
> I think this plan can avoid random pointers.

I don't see what that's going to achieve.  The whole point of
export/import is to serialise the entire hash state.  You can
not store any pointers in there.  After all, I can export the
hash state, reboot, and then reimport the hash state and it
should still work.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
