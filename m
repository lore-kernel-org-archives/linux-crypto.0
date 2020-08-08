Return-Path: <SRS0=gV+R=BS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D7BFC433DF
	for <linux-crypto@archiver.kernel.org>; Sat,  8 Aug 2020 00:17:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0709D20866
	for <linux-crypto@archiver.kernel.org>; Sat,  8 Aug 2020 00:17:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726159AbgHHARe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Aug 2020 20:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbgHHARd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Aug 2020 20:17:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68ADCC061A2E;
        Fri,  7 Aug 2020 17:17:32 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9DC981276B344;
        Fri,  7 Aug 2020 17:00:41 -0700 (PDT)
Date:   Fri, 07 Aug 2020 17:17:24 -0700 (PDT)
Message-Id: <20200807.171724.13170278259787114.davem@davemloft.net>
To:     schalla@marvell.com
Cc:     herbert@gondor.apana.org.au, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, schandran@marvell.com,
        pathreya@marvell.com, sgoutham@marvell.com, lcherian@marvell.com,
        gakula@marvell.com, jerinj@marvell.com
Subject: Re: [PATCH v2 0/3] Add Support for Marvell OcteonTX2 Cryptographic
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1596809360-12597-1-git-send-email-schalla@marvell.com>
References: <1596809360-12597-1-git-send-email-schalla@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 07 Aug 2020 17:00:42 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Srujana Challa <schalla@marvell.com>
Date: Fri, 7 Aug 2020 19:39:17 +0530

> The following series adds support for Marvell Cryptographic Acceleration
> Unit(CPT) on OcteonTX2 CN96XX SoC.
> This series is tested with CRYPTO_EXTRA_TESTS enabled and
> CRYPTO_DISABLE_TESTS disabled.

net-next is closed, please do not submit these feature addition changes
until the net-next tree is open again.

Thank you.
