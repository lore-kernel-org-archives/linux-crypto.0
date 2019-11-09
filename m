Return-Path: <SRS0=z9QW=ZB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B8FEC17441
	for <linux-crypto@archiver.kernel.org>; Sat,  9 Nov 2019 02:16:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2852C214DA
	for <linux-crypto@archiver.kernel.org>; Sat,  9 Nov 2019 02:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573265814;
	bh=LjiZWDP36iVg8k+OisaE7STGvGbXWk4byvRRQdHEia4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=wo34HtPyuhXfLW888kDffVzekFJuh5WFjNFo9ISeCQQcfEub4ufvWxa4oQTUvqTAz
	 z0ya3gN7UYGQeZ+ugFSCkgwXJc9/YUM1udxi0rrMOcTTRiDPEwSs6Gt9UJPZIjk8Q/
	 q+JqKeEH2xXhrVwb59SUDzsqs5O2RE2/scrfbkmQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbfKICQx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 21:16:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:55402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725817AbfKICQx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 21:16:53 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3736B206B6;
        Sat,  9 Nov 2019 02:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573265812;
        bh=LjiZWDP36iVg8k+OisaE7STGvGbXWk4byvRRQdHEia4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d2vEb2o6wQTE0Xk3oZJCzxYWbhIK86IPnct4rsuWHASi/D835IC9FDTElNE8uvMmC
         +lL5MLHn7pyo/AN2r634t6bmCCkNfGmWBq9/+fAAd40cpxjtdDo18AZibdkINF30Oj
         W6ZWyJf25LobMW3oRRNrKWRFqwOIIaJDLs7CHkG4=
Date:   Fri, 8 Nov 2019 18:16:50 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Zaibo Xu <xuzaibo@huawei.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, jonathan.cameron@huawei.com,
        wangzhou1@hisilicon.com, linuxarm@huawei.com, fanghao11@huawei.com,
        yekai13@huawei.com, zhangwei375@huawei.com,
        forest.zhouchang@huawei.com
Subject: Re: [PATCH v2 0/5] crypto: hisilicon - add HiSilicon SEC V2 support
Message-ID: <20191109021650.GA9739@sol.localdomain>
Mail-Followup-To: Zaibo Xu <xuzaibo@huawei.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, jonathan.cameron@huawei.com,
        wangzhou1@hisilicon.com, linuxarm@huawei.com, fanghao11@huawei.com,
        yekai13@huawei.com, zhangwei375@huawei.com,
        forest.zhouchang@huawei.com
References: <1573264917-14588-1-git-send-email-xuzaibo@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1573264917-14588-1-git-send-email-xuzaibo@huawei.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Nov 09, 2019 at 10:01:52AM +0800, Zaibo Xu wrote:
> This series adds HiSilicon Security Engine (SEC) version 2 controller
> driver in Crypto subsystem. It includes PCIe enabling, Skcipher, DebugFS
> and SRIOV support of SEC.
> 
> This patchset rebases on:
> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
> 
> This patchset is based on:
> https://www.spinics.net/lists/linux-crypto/msg43520.html
> 
> Changes:
>  - delete checking return value of debugfs_create_xxx functions.
> 
> Change log:
> v2:    - remove checking return value of debugfs_create_xxx functions.
> 

Does this driver pass all the crypto self-tests, including with
CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y?

- Eric
