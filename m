Return-Path: <SRS0=Q4nt=4B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB7EEC2BA83
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Feb 2020 09:15:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7958B20848
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Feb 2020 09:15:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729588AbgBMJPq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Feb 2020 04:15:46 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:42122 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729532AbgBMJPp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Feb 2020 04:15:45 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1j2Aaf-00046T-1G; Thu, 13 Feb 2020 17:15:21 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1j2AaU-0006jI-0i; Thu, 13 Feb 2020 17:15:10 +0800
Date:   Thu, 13 Feb 2020 17:15:10 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Zhangfei Gao <zhangfei.gao@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, jonathan.cameron@huawei.com,
        dave.jiang@intel.com, grant.likely@arm.com,
        jean-philippe <jean-philippe@linaro.org>,
        Jerome Glisse <jglisse@redhat.com>,
        ilias.apalodimas@linaro.org, francois.ozog@linaro.org,
        kenneth-lee-2012@foxmail.com, Wangzhou <wangzhou1@hisilicon.com>,
        "haojian . zhuang" <haojian.zhuang@linaro.org>,
        guodong.xu@linaro.org, linux-accelerators@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        Kenneth Lee <liguozhu@hisilicon.com>,
        Zaibo Xu <xuzaibo@huawei.com>
Subject: Re: [PATCH v12 2/4] uacce: add uacce driver
Message-ID: <20200213091509.v7ebvtot6rvlpfjt@gondor.apana.org.au>
References: <1579097568-17542-1-git-send-email-zhangfei.gao@linaro.org>
 <1579097568-17542-3-git-send-email-zhangfei.gao@linaro.org>
 <20200210233711.GA1787983@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200210233711.GA1787983@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Feb 10, 2020 at 03:37:11PM -0800, Greg Kroah-Hartman wrote:
>
> Looks much saner now, thanks for all of the work on this:
> 
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Or am I supposed to take this in my tree?  If so, I can, but I need an
> ack for the crypto parts.

I can take this series through the crypto tree if that's fine with
you.

Thank,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
