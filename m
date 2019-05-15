Return-Path: <SRS0=YWhG=TP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A3B6C04E53
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 14:08:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3481C2084E
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 14:08:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbfEOOIC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 May 2019 10:08:02 -0400
Received: from orcrist.hmeau.com ([5.180.42.13]:37002 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726646AbfEOOIC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 May 2019 10:08:02 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hQu9A-0004bO-Py; Wed, 15 May 2019 21:40:40 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hQu95-00054E-FJ; Wed, 15 May 2019 21:40:35 +0800
Date:   Wed, 15 May 2019 21:40:35 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
Cc:     Christophe Leroy <christophe.leroy@c-s.fr>,
        Eric Biggers <ebiggers@google.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: Can scatterlist elements cross page boundary ?
Message-ID: <20190515134035.uu3gpmruq5fijnh5@gondor.apana.org.au>
References: <798a42c9-bcda-6612-088c-cb90c35a578f@c-s.fr>
 <AM6PR09MB35234E6A537053A542A65E4AD2090@AM6PR09MB3523.eurprd09.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM6PR09MB35234E6A537053A542A65E4AD2090@AM6PR09MB3523.eurprd09.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 15, 2019 at 12:08:45PM +0000, Pascal Van Leeuwen wrote:
> Hi Christophe,
> 
> I ran into a similar issue with the Inside Secure driver.
> 
> If I understood correctly, scatter buffers do not need to be enclosed in a single page as long as the scatter buffer as a whole is contiguous in memory. So it can be multiple pages, but then they have to be back-to-back in physical/device memory.
> 
> The latter should be guaranteed by the kernel allocator.

Yes this is correct.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
