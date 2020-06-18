Return-Path: <SRS0=QxuD=77=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90876C433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jun 2020 07:58:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FC5B20899
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jun 2020 07:58:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbgFRH63 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Jun 2020 03:58:29 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:60506 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727964AbgFRH63 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jun 2020 03:58:29 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jlpRK-0002Cy-Ug; Thu, 18 Jun 2020 17:58:28 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 18 Jun 2020 17:58:26 +1000
Date:   Thu, 18 Jun 2020 17:58:26 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/3] crypto: qat - update admin interface
Message-ID: <20200618075826.GJ10091@gondor.apana.org.au>
References: <20200611211449.76144-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200611211449.76144-1-giovanni.cabiddu@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 11, 2020 at 10:14:46PM +0100, Giovanni Cabiddu wrote:
> Refactor and update the admin interface in the qat driver.
> 
> These changes are on top of "crypto: qat - remove packed attribute
> in etr structs" (https://patchwork.kernel.org/patch/11586063/)
> 
> Wojciech Ziemba (3):
>   crypto: qat - update fw init admin msg
>   crypto: qat - send admin messages to set of AEs
>   crypto: qat - update timeout logic in put admin msg
> 
>  drivers/crypto/qat/qat_common/adf_admin.c     | 96 ++++++++++++-------
>  .../qat/qat_common/icp_qat_fw_init_admin.h    | 75 ++++++++++-----
>  2 files changed, 114 insertions(+), 57 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
