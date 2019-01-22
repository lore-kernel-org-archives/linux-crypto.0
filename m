Return-Path: <SRS0=98p2=P6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C41E2C282C3
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jan 2019 19:37:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0C952085A
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Jan 2019 19:37:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbfAVThk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Jan 2019 14:37:40 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:35228 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbfAVThk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Jan 2019 14:37:40 -0500
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::bf5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A144D14CFAC00;
        Tue, 22 Jan 2019 11:37:39 -0800 (PST)
Date:   Tue, 22 Jan 2019 11:37:39 -0800 (PST)
Message-Id: <20190122.113739.280084775471618201.davem@davemloft.net>
To:     atul.gupta@chelsio.com
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, dt@chelsio.com
Subject: Re: [net-next 1/3] net/tls: build_protos moved to common routine
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190118045553.2774-1-atul.gupta@chelsio.com>
References: <20190118045553.2774-1-atul.gupta@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 22 Jan 2019 11:37:39 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Atul Gupta <atul.gupta@chelsio.com>
Date: Thu, 17 Jan 2019 20:55:53 -0800

> build protos is required for tls_hw_prot also hence moved to
> 'tls_build_proto' and called as required from tls_init
> and tls_hw_proto. This is required since build_protos
> for v4 is moved from tls_register to tls_init in
> commit <28cb6f1eaffdc5a6a9707cac55f4a43aa3fd7895>
> 
> Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>

Applied.
