Return-Path: <SRS0=WdwO=YZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1775CA9EC9
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Nov 2019 06:14:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BA4020656
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Nov 2019 06:14:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725784AbfKAGOB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Nov 2019 02:14:01 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37808 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725280AbfKAGOB (ORCPT <rfc822;linux-crypto@vger.kernel.orG>);
        Fri, 1 Nov 2019 02:14:01 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iQQC7-000212-VO; Fri, 01 Nov 2019 14:14:00 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iQQC6-0004wA-Jk; Fri, 01 Nov 2019 14:13:58 +0800
Date:   Fri, 1 Nov 2019 14:13:58 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     linux-crypto@vger.kernel.org, ard.biesheuvel@linaro.org
Subject: Re: [PATCH] crypto: amcc - restore CRYPTO_AES dependency
Message-ID: <20191101061358.zhq2jtir7azv24l5@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191027154747.14844-1-chunkeey@gmail.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi
Organization: Core
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Christian Lamparter <chunkeey@gmail.com> wrote:
> This patch restores the CRYPTO_AES dependency. This is
> necessary since some of the crypto4xx driver provided
> modes need functioning software fallbacks for
> AES-CTR/CCM and GCM.
> 
> Fixes: da3e7a9715ea ("crypto: amcc - switch to AES library for GCM key derivation")
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
> ---
> drivers/crypto/Kconfig | 1 +
> 1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
