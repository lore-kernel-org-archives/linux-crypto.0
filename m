Return-Path: <SRS0=XFsj=M6=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from shards.monkeyblade.net ([23.128.96.9]:42674 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbeJSHaL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Oct 2018 03:30:11 -0400
Date: Thu, 18 Oct 2018 16:26:53 -0700 (PDT)
Message-Id: <20181018.162653.523093752759551554.davem@davemloft.net>
To: ganeshgr@chelsio.com
Cc: netdev@vger.kernel.org, nirranjan@chelsio.com,
        indranil@chelsio.com, dt@chelsio.com, harsh@chelsio.com,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH net-next] cxgb4: fix the error path of
 cxgb4_uld_register()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1539871459-6921-1-git-send-email-ganeshgr@chelsio.com>
References: <1539871459-6921-1-git-send-email-ganeshgr@chelsio.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Ganesh Goudar <ganeshgr@chelsio.com>
Date: Thu, 18 Oct 2018 19:34:19 +0530

> On multi adapter setup if the uld registration fails even on
> one adapter, the allocated resources for the uld on all the
> adapters are freed, rendering the functioning adapters unusable.
> 
> This commit fixes the issue by freeing the allocated resources
> only for the failed adapter.
> 
> Signed-off-by: Ganesh Goudar <ganeshgr@chelsio.com>

Applied, thank you.
