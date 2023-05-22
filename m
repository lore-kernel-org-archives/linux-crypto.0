Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8276EC7EE2D
	for <linux-crypto@archiver.kernel.org>; Mon, 22 May 2023 17:51:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233434AbjEVRvv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 May 2023 13:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233298AbjEVRvv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 May 2023 13:51:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A64102;
        Mon, 22 May 2023 10:51:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03EFE622B0;
        Mon, 22 May 2023 17:51:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41CBAC433EF;
        Mon, 22 May 2023 17:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684777909;
        bh=vNnPOWke6lgIDP9BJRuduaGtTz3A2TJkE1uAy0zNEtU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b+l7I0OpRds2V84dDBVDjidVF9z0+KHOEV1Q5Bvlslq+SUQ+GfYUbfL5e4xtwdGro
         hq/E0m9OrhrLaxD5oG3D6WlxklmgOOh3JYEOV5eQS1Au4Ij/Dnud2h3SDe/ar0eFXg
         SJTXHr4vdiiApcwitIIpk7gWoH9Nq7CQSRwBwEJ57KiBlNqvjfZ8yLoKkeXktosEwq
         /U+0KGvOa0N3WQ0HdRqY507EbRBR/vD3fuu5sK2woyZUELNPwdnXpb00H2AM6NKMMY
         PnxMpZszzTLExDp8dmdnK/J/VUv7pBPiRC8xIPJBoWPlA9Bu2LwJyUnhyDEkKwkoON
         7yn8aXSTydngg==
Date:   Mon, 22 May 2023 13:51:48 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 6.1] crypto: testmgr - fix RNG performance in fuzz tests
Message-ID: <ZGurtNEsFJahQpSx@sashalap>
References: <20230516050850.59514-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230516050850.59514-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, May 15, 2023 at 10:08:50PM -0700, Eric Biggers wrote:
>From: Eric Biggers <ebiggers@google.com>
>
>commit f900fde28883602b6c5e1027a6c912b673382aaf upstream.

Thanks for the backport!

-- 
Thanks,
Sasha
