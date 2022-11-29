Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28D4BC4167B
	for <linux-crypto@archiver.kernel.org>; Tue, 29 Nov 2022 17:03:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236573AbiK2RDI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 29 Nov 2022 12:03:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236576AbiK2RCl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 29 Nov 2022 12:02:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C8946D4BE;
        Tue, 29 Nov 2022 09:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDF0361846;
        Tue, 29 Nov 2022 17:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5998DC43144;
        Tue, 29 Nov 2022 17:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669741218;
        bh=kOW9LOGBIyQcUgfD83JFpvN4RkPk9pFSYbCqG5y+nhE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OGkbZef7abEC6UKBNXoumbmFJceB1zilMKpF1sEvILaqUr5yyr6LGdiiSnFPVf9m4
         yMRTLOfTDGmki5L1kkotkEjMnBOP2AvKohYcc7bH6Er17qAgb4yOZ8A7xvJMoO7WwQ
         XEysf5ouzp6QColvLZYqxBCC6nDN0msEJ1z79P9uKsWLq1pNfzIHiOJ020xMgUY9Eb
         TEDr79Qwr/P6Q/+gwWaNq9aU3ipu7WcHOMWeYMQKt9QWMnXvIn1OewU5WHQTfCz98w
         +mhHv9zcSEVbWBdM95nrUvM6MUStgu1ZlVz1FrjWIoT02oNYEsFn1uDcdPWjCQGAJf
         rwwlD+0YIHegQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 39053E21EF7;
        Tue, 29 Nov 2022 17:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] MAINTAINERS: Update maintainer list for chelsio drivers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166974121822.7750.12335478384657809124.git-patchwork-notify@kernel.org>
Date:   Tue, 29 Nov 2022 17:00:18 +0000
References: <20221128231348.8225-1-ayush.sawal@chelsio.com>
In-Reply-To: <20221128231348.8225-1-ayush.sawal@chelsio.com>
To:     Ayush Sawal <ayush.sawal@chelsio.com>
Cc:     kuba@kernel.org, davem@davemloft.net, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        fmdefrancesco@gmail.com, anirudh.venkataramanan@intel.com
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 29 Nov 2022 04:43:48 +0530 you wrote:
> This updates the maintainers for chelsio inline crypto drivers and
> chelsio crypto drivers.
> 
> Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>
> ---
>  MAINTAINERS | 4 ----
>  1 file changed, 4 deletions(-)

Here is the summary with links:
  - MAINTAINERS: Update maintainer list for chelsio drivers
    https://git.kernel.org/netdev/net/c/178833f99f58

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


