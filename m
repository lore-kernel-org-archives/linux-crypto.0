Return-Path: <SRS0=W3IF=ZO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77C41C43215
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 08:16:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FE3920672
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 08:16:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfKVIQM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Nov 2019 03:16:12 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:43546 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726018AbfKVIQM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Nov 2019 03:16:12 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iY46t-0007jR-Gi; Fri, 22 Nov 2019 16:16:11 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iY46t-0004vb-BY; Fri, 22 Nov 2019 16:16:11 +0800
Date:   Fri, 22 Nov 2019 16:16:11 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Harald Freudenberger <freude@linux.ibm.com>
Cc:     linux-crypto@vger.kernel.org, ebiggers@kernel.org,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH 3/3] crypto/testmgr: add selftests for paes-s390
Message-ID: <20191122081611.vznhvhouim6hnehc@gondor.apana.org.au>
References: <20191113105523.8007-1-freude@linux.ibm.com>
 <20191113105523.8007-4-freude@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113105523.8007-4-freude@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Nov 13, 2019 at 11:55:23AM +0100, Harald Freudenberger wrote:
> This patch adds selftests for the s390 specific protected key
> AES (PAES) cipher implementations:
>   * cbc-paes-s390
>   * ctr-paes-s390
>   * ecb-paes-s390
>   * xts-paes-s390
> PAES is an AES cipher but with encrypted ('protected') key
> material. So here come ordinary AES enciphered data values
> but with a special key format understood by the PAES
> implementation.
> 
> The testdata definitons and testlist entries are surrounded
> by #if IS_ENABLED(CONFIG_CRYPTO_PAES_S390) because they don't
> make any sense on non s390 platforms or without the PAES
> cipher implementation.
> 
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
> ---
>  crypto/testmgr.c |  36 +++++
>  crypto/testmgr.h | 334 +++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 370 insertions(+)

So with your cleartext work, I gather that you can now supply
arbitrary keys to paes? If so my preferred method of testing it
would be to add a paes-specific tester function that massaged the
existing aes vectors into the format required by paes so you
get exactly the same testing coverage as plain aes.

Is this possible?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
