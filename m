Return-Path: <SRS0=VKJi=YH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 923B3C4CECE
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 18:08:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 775BF2067B
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 18:08:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731921AbfJNSIX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Oct 2019 14:08:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52702 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730192AbfJNSIX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Oct 2019 14:08:23 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:b5c5:ae11:3e54:6a07])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8B9641429F7E8;
        Mon, 14 Oct 2019 11:08:22 -0700 (PDT)
Date:   Mon, 14 Oct 2019 14:08:19 -0400 (EDT)
Message-Id: <20191014.140819.2180009161399855683.davem@davemloft.net>
To:     ard.biesheuvel@linaro.org
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        ebiggers@google.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 23/25] crypto: niagara2 - switch to skcipher API
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191014121910.7264-24-ard.biesheuvel@linaro.org>
References: <20191014121910.7264-1-ard.biesheuvel@linaro.org>
        <20191014121910.7264-24-ard.biesheuvel@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 14 Oct 2019 11:08:22 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 14 Oct 2019 14:19:08 +0200

> Commit 7a7ffe65c8c5 ("crypto: skcipher - Add top-level skcipher interface")
> dated 20 august 2015 introduced the new skcipher API which is supposed to
> replace both blkcipher and ablkcipher. While all consumers of the API have
> been converted long ago, some producers of the ablkcipher remain, forcing
> us to keep the ablkcipher support routines alive, along with the matching
> code to expose [a]blkciphers via the skcipher API.
> 
> So switch this driver to the skcipher API, allowing us to finally drop the
> blkcipher code in the near future.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Acked-by: David S. Miller <davem@davemloft.net>
