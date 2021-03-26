Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A60D8C433DB
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Mar 2021 09:32:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B0E961A38
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Mar 2021 09:32:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbhCZJcX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Mar 2021 05:32:23 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:35422 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230226AbhCZJcD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Mar 2021 05:32:03 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1lPiox-0003Wg-Bz; Fri, 26 Mar 2021 20:32:00 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 26 Mar 2021 20:31:59 +1100
Date:   Fri, 26 Mar 2021 20:31:59 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tong Zhang <ztong0001@gmail.com>
Cc:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Tadeusz Struk <tadeusz.struk@intel.com>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/2] crypto: qat - fix couple crashes duing error
 handling
Message-ID: <20210326093159.GI12658@gondor.apana.org.au>
References: <YFOLPn31KF7bW6T/@silpixa00400314>
 <20210319034001.435117-1-ztong0001@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319034001.435117-1-ztong0001@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Mar 18, 2021 at 11:39:58PM -0400, Tong Zhang wrote:
> There are a couple of issues in qat error handling. Those drivers tries to
> release resources that is not initialized. This patch series tries to fix
> crashes caused by incorrect error handling.
> 
> v2: removed excessive dump in commit log as suggested by Andy Shevchenko <andy.shevchenko@gmail.com>
> v3: collect tags as suggested by Andy Shevchenko <andy.shevchenko@gmail.com>
> v4: fix commit log typos
> v5: fix headline
> 
> Tong Zhang (2):
>   crypto: qat - don't release uninitialized resources
>   crypto: qat - ADF_STATUS_PF_RUNNING should be set after adf_dev_init
> 
>  drivers/crypto/qat/qat_c3xxxvf/adf_drv.c    |  4 ++--
>  drivers/crypto/qat/qat_c62xvf/adf_drv.c     |  4 ++--
>  drivers/crypto/qat/qat_common/adf_vf_isr.c  | 17 +++++++++++++----
>  drivers/crypto/qat/qat_dh895xccvf/adf_drv.c |  4 ++--
>  4 files changed, 19 insertions(+), 10 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
