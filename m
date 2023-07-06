Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CF2DEB64D9
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jul 2023 20:10:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232362AbjGFUKN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Jul 2023 16:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232265AbjGFUKM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Jul 2023 16:10:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537F710F3;
        Thu,  6 Jul 2023 13:10:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1D16612D1;
        Thu,  6 Jul 2023 20:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2D925C433C9;
        Thu,  6 Jul 2023 20:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688674210;
        bh=3QVb4qQu1Gml6yi2ur2ya9vRyI9CNA7dgTC9agqVbqo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JZENVqmYt4PYgsQ2ojnng9w8cNrg0gzQJB3ZvAt5tHH5JY4zjLUWC1/iXeM7s/WpO
         VjgAuTHdS+kx/G44i3qnzZ2A0wxz3FVXGuF8PVW9H/lwi7y4UiO0v12cTV9EadwR2Z
         w4R3QmncGYh3LPfSRJ0yTutiJwUKlmswWJ38BNQtmZa9nxmButPceuIELS8J6KiVi7
         9ix4wbkxybWazdztusMdr/19IzJbwx9hZwcZHd28Z0qMgmbBDFN5OEYI6qTNjc7fle
         wUlSAQEYQEQ2n13GRPj+6QKF2vXA0vSmxf3+0DXrZVS7N/v7GqyMVaSclVfpK6lUpc
         3lO3WrPFwyqVw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 10A98C59A4C;
        Thu,  6 Jul 2023 20:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/3] fixup potential cpu stall
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <168867421006.27620.2867140526566551543.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Jul 2023 20:10:10 +0000
References: <20230609131817.712867-1-xianting.tian@linux.alibaba.com>
In-Reply-To: <20230609131817.712867-1-xianting.tian@linux.alibaba.com>
To:     Xianting Tian <xianting.tian@linux.alibaba.com>
Cc:     arei.gonglei@huawei.com, mst@redhat.com, jasowang@redhat.com,
        xuanzhuo@linux.alibaba.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, amit@kernel.org, arnd@arndb.de,
        gregkh@linuxfoundation.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        linux-bluetooth@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello:

This series was applied to bluetooth/bluetooth-next.git (master)
by Michael S. Tsirkin <mst@redhat.com>:

On Fri,  9 Jun 2023 21:18:14 +0800 you wrote:
> Cpu stall issue may happen if device is configured with multi queues
> and large queue depth, so fix it.
> 
> Xianting Tian (3):
>   virtio-crypto: fixup potential cpu stall when free unused bufs
>   virtio_console: fixup potential cpu stall when free unused bufs
>   virtio_bt: fixup potential cpu stall when free unused bufs
> 
> [...]

Here is the summary with links:
  - [1/3] virtio-crypto: fixup potential cpu stall when free unused bufs
    https://git.kernel.org/bluetooth/bluetooth-next/c/7a5103b81a96
  - [2/3] virtio_console: fixup potential cpu stall when free unused bufs
    https://git.kernel.org/bluetooth/bluetooth-next/c/56b5e65efe00
  - [3/3] virtio_bt: fixup potential cpu stall when free unused bufs
    https://git.kernel.org/bluetooth/bluetooth-next/c/3845308fc8b0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


