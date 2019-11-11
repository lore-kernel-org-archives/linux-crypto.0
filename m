Return-Path: <SRS0=rtXS=ZD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A158DC43331
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Nov 2019 17:18:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 739142190F
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Nov 2019 17:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573492701;
	bh=f9l2HbZ3OcGFP12zNrw5cfXRvIpUn8xJk4t/VMJUFJo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=RrxuFJiGXKODWIwyDPl3fkHqVJ6P6Le1fleFPIeGOtJWXEwSVlk2wcpBqkB/e/r79
	 4CKLctznTMVLzpEoEneKOAwlqb8ya4vtEGUEO64B9iBtfmU+xgjtnpCNGkyQI8gEvY
	 4Rsghp2JDoILkrqGghIecch1ZojQ/cbg1s85jSco=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbfKKRSU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Nov 2019 12:18:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:59900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726871AbfKKRSU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Nov 2019 12:18:20 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 542A320656;
        Mon, 11 Nov 2019 17:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573492699;
        bh=f9l2HbZ3OcGFP12zNrw5cfXRvIpUn8xJk4t/VMJUFJo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zqyyiPmeXMg5GzJrLPu9gN8t1fmN8YKFX+2XQ+ILpO5Pfmhf298tGW0j7OUPWVPk4
         2o/qyfXVYdJOm84b8MP3cQaSz/Cz0j6Wx13/F9YI6vR1YqowgxQf8+4BdGflawKxmq
         l2GN5IT6c8GX7DEKTcRH7GmPK70f/CQqSRDHUDIA=
Date:   Mon, 11 Nov 2019 09:18:17 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Xu Zaibo <xuzaibo@huawei.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, jonathan.cameron@huawei.com,
        wangzhou1@hisilicon.com, linuxarm@huawei.com, fanghao11@huawei.com,
        yekai13@huawei.com, zhangwei375@huawei.com,
        forest.zhouchang@huawei.com
Subject: Re: [PATCH v2 0/5] crypto: hisilicon - add HiSilicon SEC V2 support
Message-ID: <20191111171816.GA56300@gmail.com>
Mail-Followup-To: Xu Zaibo <xuzaibo@huawei.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, jonathan.cameron@huawei.com,
        wangzhou1@hisilicon.com, linuxarm@huawei.com, fanghao11@huawei.com,
        yekai13@huawei.com, zhangwei375@huawei.com,
        forest.zhouchang@huawei.com
References: <1573264917-14588-1-git-send-email-xuzaibo@huawei.com>
 <20191109021650.GA9739@sol.localdomain>
 <d75fc607-524c-a68a-bafe-28e793bced93@huawei.com>
 <20191111053720.GA18665@sol.localdomain>
 <5f822228-0323-928a-30f9-dea4af210a4c@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f822228-0323-928a-30f9-dea4af210a4c@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Nov 11, 2019 at 08:26:20PM +0800, Xu Zaibo wrote:
> Hi,
> 
> On 2019/11/11 13:37, Eric Biggers wrote:
> > On Mon, Nov 11, 2019 at 10:21:39AM +0800, Xu Zaibo wrote:
> > > Hi,
> > > 
> > > On 2019/11/9 10:16, Eric Biggers wrote:
> > > > On Sat, Nov 09, 2019 at 10:01:52AM +0800, Zaibo Xu wrote:
> > > > > This series adds HiSilicon Security Engine (SEC) version 2 controller
> > > > > driver in Crypto subsystem. It includes PCIe enabling, Skcipher, DebugFS
> > > > > and SRIOV support of SEC.
> > > > > 
> > > > > This patchset rebases on:
> > > > > git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
> > > > > 
> > > > > This patchset is based on:
> > > > > https://www.spinics.net/lists/linux-crypto/msg43520.html
> > > > > 
> > > > > Changes:
> > > > >    - delete checking return value of debugfs_create_xxx functions.
> > > > > 
> > > > > Change log:
> > > > > v2:    - remove checking return value of debugfs_create_xxx functions.
> > > > > 
> > > > Does this driver pass all the crypto self-tests, including with
> > > > CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y?
> > > > 
> > > Not including extra testing now, only CONFIG_CRYPTO_TEST is passed.
> > > 
> > Can you please ensure that all the extra tests are passing too?  I.e., boot a
> > kernel with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y and check dmesg for failures.
> > 
> Ok, I will try to do this. BTW, why we need this test? Thanks.
> 

It will test the correctness of your driver.

- Eric
