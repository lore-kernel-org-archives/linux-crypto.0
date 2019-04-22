Return-Path: <SRS0=cKin=SY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 230A1C10F11
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Apr 2019 12:47:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1D6A2077C
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Apr 2019 12:47:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbfDVMrk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Apr 2019 08:47:40 -0400
Received: from [5.180.42.13] ([5.180.42.13]:59130 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726057AbfDVMrk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Apr 2019 08:47:40 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hIYM7-00045H-M6; Mon, 22 Apr 2019 20:47:31 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hIYLv-00037j-TT; Mon, 22 Apr 2019 20:47:19 +0800
Date:   Mon, 22 Apr 2019 20:47:19 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: Crypto API AEAD question
Message-ID: <20190422124719.q5n7n3dionn3v6uc@gondor.apana.org.au>
References: <AM6PR09MB352327ADDE2D1CA8B8E7C99CD2220@AM6PR09MB3523.eurprd09.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM6PR09MB352327ADDE2D1CA8B8E7C99CD2220@AM6PR09MB3523.eurprd09.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Apr 22, 2019 at 11:29:55AM +0000, Pascal Van Leeuwen wrote:
>
> Even so, for the in-place case, checking the AAD data would ensure the crypto
> implementation didn't *accidentally* corrupt it ...

Yes we probably should check it just in case some driver does
something weird with it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
