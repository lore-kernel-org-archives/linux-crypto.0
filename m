Return-Path: <SRS0=PFiu=AH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA620C433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jun 2020 06:06:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE17520775
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jun 2020 06:06:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgFZGG6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jun 2020 02:06:58 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:51910 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725801AbgFZGG5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jun 2020 02:06:57 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1johVO-0004UV-M5; Fri, 26 Jun 2020 16:06:31 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 26 Jun 2020 16:06:30 +1000
Date:   Fri, 26 Jun 2020 16:06:30 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Zhangfei Gao <zhangfei.gao@linaro.org>
Cc:     =?iso-8859-1?Q?=A0Greg_Kroah-Hartman=A0?= 
        <gregkh@linuxfoundation.org>,
        =?iso-8859-1?Q?=A0Eric?= Biggers <ebiggers@kernel.org>,
        Jonathan =?iso-8859-1?Q?Cameron=A0?= 
        <Jonathan.Cameron@huawei.com>,
        =?iso-8859-1?Q?=A0wangzhou1=A0?= <wangzhou1@hisilicon.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        kbuild-all@lists.01.org
Subject: Re: [PATCH v2] crypto: hisilicon - fix strncpy warning with strscpy
Message-ID: <20200626060630.GA20811@gondor.apana.org.au>
References: <1591241524-6452-1-git-send-email-zhangfei.gao@linaro.org>
 <1592192317-10566-1-git-send-email-zhangfei.gao@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1592192317-10566-1-git-send-email-zhangfei.gao@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 15, 2020 at 11:38:37AM +0800, Zhangfei Gao wrote:
> Use strscpy to fix the warning
> warning: 'strncpy' specified bound 64 equals destination size
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
> ---
> v2: Use strscpy instead of strlcpy since better truncation handling
>     suggested by Herbert
>     Rebase to 5.8-rc1
> 
>  drivers/crypto/hisilicon/qm.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
