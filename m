Return-Path: <SRS0=Quof=CU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6E9FC43461
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Sep 2020 06:57:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F66222205
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Sep 2020 06:57:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725770AbgIKG5k (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Sep 2020 02:57:40 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:58936 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbgIKG5i (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Sep 2020 02:57:38 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kGd00-0007tS-QS; Fri, 11 Sep 2020 16:57:34 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Sep 2020 16:57:32 +1000
Date:   Fri, 11 Sep 2020 16:57:32 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Dominik Przychodni <dominik.przychodni@intel.com>
Subject: Re: [PATCH v2] crypto: qat - check cipher length for aead
 AES-CBC-HMAC-SHA
Message-ID: <20200911065732.GD32150@gondor.apana.org.au>
References: <20200831105959.107261-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200831105959.107261-1-giovanni.cabiddu@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Aug 31, 2020 at 11:59:59AM +0100, Giovanni Cabiddu wrote:
> From: Dominik Przychodni <dominik.przychodni@intel.com>
> 
> Return -EINVAL for authenc(hmac(sha1),cbc(aes)),
> authenc(hmac(sha256),cbc(aes)) and authenc(hmac(sha512),cbc(aes))
> if the cipher length is not multiple of the AES block.
> This is to prevent an undefined device behaviour.
> 
> Fixes: d370cec32194 ("crypto: qat - Intel(R) QAT crypto interface")
> Signed-off-by: Dominik Przychodni <dominik.przychodni@intel.com>
> [giovanni.cabiddu@intel.com: reworded commit message]
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/crypto/qat/qat_common/qat_algs.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
