Return-Path: <SRS0=Q4nt=4B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77A4CC2BA83
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Feb 2020 13:01:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47E1024650
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Feb 2020 13:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581598862;
	bh=twEumPvnyw2Pl8YhKty+VCE7JIjeaqEqyiFe8s6/Jiw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=j15nFA7YoVJtcw27nMSs+C7pvKTMGqivE72UWvYAYvcf8lS1LmmoD02hyvndlb7SX
	 VJs2LRsOKKCm/WY4kTZLUzVr3lI798tdvbULBeDU0BHPn/octVsc9pewt8PgQXO/I2
	 nK2Lpr/f6SPu1nqfBlliMStGgjoO+m+alwio9QYM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729674AbgBMNBB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Feb 2020 08:01:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:49224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729673AbgBMNBB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Feb 2020 08:01:01 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 756A22168B;
        Thu, 13 Feb 2020 13:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581598859;
        bh=twEumPvnyw2Pl8YhKty+VCE7JIjeaqEqyiFe8s6/Jiw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rdaYpEblbV5tf4L5crHu8c9hTW6RG99Pj+wh/ptP2xU3F5rsjtOaLgHAkzCOD3elZ
         wVOieW3iowVEUn4ShEkxHTU/BkwBokzRkVY8HJOvjcvmMm40xSUpiZVVBKck0Cupsi
         aOQpXMPk0690MiFckldJ7NjYe7UEVf7uLnYcNjRU=
Date:   Thu, 13 Feb 2020 05:00:59 -0800
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
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
Message-ID: <20200213130059.GA3361459@kroah.com>
References: <1579097568-17542-1-git-send-email-zhangfei.gao@linaro.org>
 <1579097568-17542-3-git-send-email-zhangfei.gao@linaro.org>
 <20200210233711.GA1787983@kroah.com>
 <20200213091509.v7ebvtot6rvlpfjt@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200213091509.v7ebvtot6rvlpfjt@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 13, 2020 at 05:15:10PM +0800, Herbert Xu wrote:
> On Mon, Feb 10, 2020 at 03:37:11PM -0800, Greg Kroah-Hartman wrote:
> >
> > Looks much saner now, thanks for all of the work on this:
> > 
> > Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > Or am I supposed to take this in my tree?  If so, I can, but I need an
> > ack for the crypto parts.
> 
> I can take this series through the crypto tree if that's fine with
> you.

Please do, thanks!

greg k-h
