Return-Path: <SRS0=Y60y=ZE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE207C43331
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Nov 2019 01:28:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A397D2196E
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Nov 2019 01:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573522129;
	bh=ssjXnjKucqSJq8Pr9Yw0/p1cHbQUl5JbsdVk9owA3D0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=NDXN2He6SkOeY4FMZL5p1tNnBStUtk8veO4SJHAnbuST+ZOzRHrHyrrJoSsu1hw+e
	 qr+tdiur+/GCxaqHGgzCDSJzGsuKFWi79sZVKIqy5uWpyrVbfdFjGJw6mCrCWq65yJ
	 WRj2rz13fs7YXNJmw8G1mKOl7Z8DUCku9gKYTtSU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbfKLB2r (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Nov 2019 20:28:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:41098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727605AbfKLB2q (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Nov 2019 20:28:46 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6249521D7F;
        Tue, 12 Nov 2019 01:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573522125;
        bh=ssjXnjKucqSJq8Pr9Yw0/p1cHbQUl5JbsdVk9owA3D0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wXgm4c1PLrBPDUkwdGgOJ1YkSj1XQNtqGo47Wv6RbVBKXJytLSkrVhoKXhao6rZb+
         vKshJDwEaH1mvIJzt3veKNECbRA+2nBzW/eGTCDBjUYAI+xopeNAJMVKU7hmgKVCyT
         a/nFy8bVpHhhM6tuFeGaMukSZVzxohYZhEDK+N7Q=
Date:   Mon, 11 Nov 2019 17:28:43 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Xu Zaibo <xuzaibo@huawei.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, jonathan.cameron@huawei.com,
        wangzhou1@hisilicon.com, linuxarm@huawei.com, fanghao11@huawei.com,
        yekai13@huawei.com, zhangwei375@huawei.com,
        forest.zhouchang@huawei.com
Subject: Re: [PATCH v2 0/5] crypto: hisilicon - add HiSilicon SEC V2 support
Message-ID: <20191112012843.GA695@sol.localdomain>
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
 <20191111171816.GA56300@gmail.com>
 <6cecf2de-9aa0-f6ea-0c2d-8e974a1a820b@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6cecf2de-9aa0-f6ea-0c2d-8e974a1a820b@huawei.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 12, 2019 at 09:04:33AM +0800, Xu Zaibo wrote:
> On 2019/11/12 1:18, Eric Biggers wrote:
> > On Mon, Nov 11, 2019 at 08:26:20PM +0800, Xu Zaibo wrote:
> > > Hi,
> > > 
> > > On 2019/11/11 13:37, Eric Biggers wrote:
> > > > On Mon, Nov 11, 2019 at 10:21:39AM +0800, Xu Zaibo wrote:
> > > > > Hi,
> > > > > 
> > > > > On 2019/11/9 10:16, Eric Biggers wrote:
> > > > > > On Sat, Nov 09, 2019 at 10:01:52AM +0800, Zaibo Xu wrote:
> > > > > > > This series adds HiSilicon Security Engine (SEC) version 2 controller
> > > > > > > driver in Crypto subsystem. It includes PCIe enabling, Skcipher, DebugFS
> > > > > > > and SRIOV support of SEC.
> > > > > > > 
> > > > > > > This patchset rebases on:
> > > > > > > git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
> > > > > > > 
> > > > > > > This patchset is based on:
> > > > > > > https://www.spinics.net/lists/linux-crypto/msg43520.html
> > > > > > > 
> > > > > > > Changes:
> > > > > > >     - delete checking return value of debugfs_create_xxx functions.
> > > > > > > 
> > > > > > > Change log:
> > > > > > > v2:    - remove checking return value of debugfs_create_xxx functions.
> > > > > > > 
> > > > > > Does this driver pass all the crypto self-tests, including with
> > > > > > CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y?
> > > > > > 
> > > > > Not including extra testing now, only CONFIG_CRYPTO_TEST is passed.
> > > > > 
> > > > Can you please ensure that all the extra tests are passing too?  I.e., boot a
> > > > kernel with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y and check dmesg for failures.
> > > > 
> > > Ok, I will try to do this. BTW, why we need this test? Thanks.
> > > 
> > It will test the correctness of your driver.
> > 
> So, it is a basic test not an extra test ? :)
> 

The options are separate because the "extra tests" include fuzz tests which take
much longer to run than the regular tests, and some people who enable the
regular tests wouldn't want them to get 100x slower.  But as someone actually
developing a crypto driver you're expected to run the extra tests.  They've
found lots of bugs in other drivers, so please run them and fix any bugs found.

- Eric
