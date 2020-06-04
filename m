Return-Path: <SRS0=fFzG=7R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42A36C433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jun 2020 06:50:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 250B2206C3
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jun 2020 06:50:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbgFDGuf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Jun 2020 02:50:35 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:36620 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726248AbgFDGuf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Jun 2020 02:50:35 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jgjhZ-0002fD-DI; Thu, 04 Jun 2020 16:50:10 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 04 Jun 2020 16:50:09 +1000
Date:   Thu, 4 Jun 2020 16:50:09 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Zhangfei Gao <zhangfei.gao@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        wangzhou1 <wangzhou1@hisilicon.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        kbuild-all@lists.01.org
Subject: Re: [PATCH] crypto: hisilicon - fix strncpy warning with strlcpy
Message-ID: <20200604065009.GA29822@gondor.apana.org.au>
References: <202006032110.BEbKqovX%lkp@intel.com>
 <1591241524-6452-1-git-send-email-zhangfei.gao@linaro.org>
 <20200604033918.GA2286@gondor.apana.org.au>
 <b6ad8af2-1cb7-faac-0446-5e09e97f3616@linaro.org>
 <20200604061811.GA28759@gondor.apana.org.au>
 <b23433f8-d95d-8142-c830-fb92e5ccd4a1@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b23433f8-d95d-8142-c830-fb92e5ccd4a1@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 04, 2020 at 02:44:16PM +0800, Zhangfei Gao wrote:
>
> I think it is fine.
> 1. Currently the name size is 64, bigger enough.
> Simply grep in driver name, 64 should be enough.
> We can make it larger when there is a request.
> 2. it does not matter what the name is, since it is just an interface.
> cat /sys/class/uacce/hisi_zip-0/flags
> cat /sys/class/uacce/his-0/flags
> should be both fine to app only they can be distinguished.
> 3. It maybe a hard restriction to fail just because of a long name.

I think we should err on the side of caution.  IOW, unless you
know that you need it to succeed when it exceeds the limit, then
you should just make it fail.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
