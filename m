Return-Path: <SRS0=hzfm=QI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7B28C282DA
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 06:51:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8297720870
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 06:51:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbfBAGvZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Feb 2019 01:51:25 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:57056 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbfBAGvZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Feb 2019 01:51:25 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gpSfc-0000Ey-2A; Fri, 01 Feb 2019 14:51:24 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gpSfb-0005oU-Ur; Fri, 01 Feb 2019 14:51:23 +0800
Date:   Fri, 1 Feb 2019 14:51:23 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Milan Broz <gmazyland@gmail.com>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: mark crc32 checksum as FIPS allowed
Message-ID: <20190201065123.4tnqazxq2h47aj2r@gondor.apana.org.au>
References: <20190125093147.10266-1-gmazyland@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190125093147.10266-1-gmazyland@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jan 25, 2019 at 09:31:47AM +0000, Milan Broz wrote:
> The CRC32 is not a cryptographic hash algorithm,
> so the FIPS restrictions should not apply to it.
> (The CRC32C variant is already allowed.)
> 
> This CRC32 variant is used for in dm-crypt legacy TrueCrypt
> IV implementation (tcw); detected by cryptsetup test suite
> failure in FIPS mode.
> 
> Signed-off-by: Milan Broz <gmazyland@gmail.com>
> ---
>  crypto/testmgr.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
