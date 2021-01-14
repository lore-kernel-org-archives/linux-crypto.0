Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5FD8C433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Jan 2021 06:47:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F82023976
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Jan 2021 06:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbhANGrW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Jan 2021 01:47:22 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:42174 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbhANGrW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Jan 2021 01:47:22 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kzwP2-00087i-E1; Thu, 14 Jan 2021 17:46:41 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 14 Jan 2021 17:46:40 +1100
Date:   Thu, 14 Jan 2021 17:46:40 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH 0/3] crypto: qat - fix issues reported by smatch
Message-ID: <20210114064640.GD12584@gondor.apana.org.au>
References: <20210104172159.15489-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104172159.15489-1-giovanni.cabiddu@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 04, 2021 at 05:21:56PM +0000, Giovanni Cabiddu wrote:
> Fix warnings and errors reported by the static analysis tool smatch in
> the QAT driver.
> 
> Adam Guerin (3):
>   crypto: qat - fix potential spectre issue
>   crypto: qat - change format string and cast ring size
>   crypto: qat - reduce size of mapped region
> 
>  drivers/crypto/qat/qat_common/adf_transport.c       |  2 ++
>  drivers/crypto/qat/qat_common/adf_transport_debug.c |  4 ++--
>  drivers/crypto/qat/qat_common/qat_asym_algs.c       | 12 ++++++------
>  3 files changed, 10 insertions(+), 8 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
