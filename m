Return-Path: <SRS0=Q4nt=4B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC889C2BA83
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Feb 2020 08:39:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9E1C217F4
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Feb 2020 08:39:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729586AbgBMIjt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Feb 2020 03:39:49 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:41264 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729485AbgBMIjs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Feb 2020 03:39:48 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1j2A2F-0003qG-Nq; Thu, 13 Feb 2020 16:39:47 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1j2A2E-0001Sg-6E; Thu, 13 Feb 2020 16:39:46 +0800
Date:   Thu, 13 Feb 2020 16:39:46 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Harald Freudenberger <freude@linux.ibm.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH] crypto/testmgr: add selftests for paes-s390
Message-ID: <20200213083946.zicarnnt3wizl5ty@gondor.apana.org.au>
References: <20191113105523.8007-4-freude@linux.ibm.com>
 <2391ff22-97be-bc6a-3650-3cade8a78393@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2391ff22-97be-bc6a-3650-3cade8a78393@linux.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 13, 2020 at 08:40:06AM +0100, Harald Freudenberger wrote:
> This patch enables the selftests for the s390 specific protected key
> AES (PAES) cipher implementations:
>   * cbc-paes-s390
>   * ctr-paes-s390
>   * ecb-paes-s390
>   * xts-paes-s390
> PAES is an AES cipher but with encrypted ('protected') key
> material. However, the paes ciphers are able to derive an protected
> key from clear key material with the help of the pkey kernel module.
> 
> So this patch now enables the generic AES tests for the paes
> ciphers. Under the hood the setkey() functions rearrange the clear key
> values as clear key token and so the pkey kernel module is able to
> provide protected key blobs from the given clear key values. The
> derived protected key blobs are then used within the paes cipers and
> should produce the very same results as the generic AES implementation
> with the clear key values.
> 
> The s390-paes cipher testlist entries are surrounded
> by #if IS_ENABLED(CONFIG_CRYPTO_PAES_S390) because they don't
> make any sense on non s390 platforms or without the PAES
> cipher implementation.
> 
> Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
> ---
>  crypto/testmgr.c | 36 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
