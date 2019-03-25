Return-Path: <SRS0=1oRy=R4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19D95C43381
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Mar 2019 16:04:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4C1520830
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Mar 2019 16:04:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbfCYQEj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Mar 2019 12:04:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52954 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfCYQEj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Mar 2019 12:04:39 -0400
Received: from localhost (unknown [50.233.106.125])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B09B0149AF4CF;
        Mon, 25 Mar 2019 09:04:38 -0700 (PDT)
Date:   Mon, 25 Mar 2019 12:04:35 -0400 (EDT)
Message-Id: <20190325.120435.1237199226476451707.davem@davemloft.net>
To:     herbert@gondor.apana.org.au
Cc:     Jason@zx2c4.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        torvalds@linux-foundation.org, gregkh@linuxfoundation.org,
        ebiggers@kernel.org, ard.biesheuvel@linaro.org,
        samuel.c.p.neves@gmail.com
Subject: Re: [PATCH net-next v9 00/19] WireGuard: Secure Network Tunnel
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190325115156.wj4verbfdd2rspo5@gondor.apana.org.au>
References: <20190322071122.6677-1-Jason@zx2c4.com>
        <20190325115156.wj4verbfdd2rspo5@gondor.apana.org.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 25 Mar 2019 09:04:38 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Mon, 25 Mar 2019 19:51:56 +0800

> I really think we ought to separate the zinc interface from these
> new crypto implementations.  They have nothing to do with each
> other.

I completely agree.
