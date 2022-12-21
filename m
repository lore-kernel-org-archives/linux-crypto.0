Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D253C4332F
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Dec 2022 20:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiLUUqi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Dec 2022 15:46:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiLUUqg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Dec 2022 15:46:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9921AA39;
        Wed, 21 Dec 2022 12:46:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5652760CA0;
        Wed, 21 Dec 2022 20:46:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CA4C433EF;
        Wed, 21 Dec 2022 20:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671655594;
        bh=jumQiuvlAfVsWSIQS+NeFdUB1emvSHfWwp65TYKwHhw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LzegTgBr+lvkdn2adOq+BXPSnSV+yGBT/fUmfgxIk6ZU+7Cvji3BQ4LA+bil7EUm5
         9TInFT6VKnHT/idBCiFlqNr5wtQeNKEQeQzeYs1XMC4DW3bKoP1fa9nTprNGam4b+T
         moJqfDpDCmvXLTTYlSnKgQh2a+hMhzDxVvQSxvbf33x0yo766sfOQeQ8j/Ao+mm5Q0
         8FSQQW8wxKS4Bgu/3J18f10KO5ENRGsZuTj00iOZ3w/vzUATMxx7ZtQyHI6QxYbiJs
         aQPj8QwXb61nq/lEsRpPfjBz7h2Mr5jtTYmlYxk7xtvjyNVOt74nhabDCAgyP8Ldhj
         hPr9ib/D9sOiw==
Date:   Wed, 21 Dec 2022 12:46:32 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Vladis Dronov <vdronov@redhat.com>
Cc:     nstange@suse.de, davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        smueller@chronox.de
Subject: Re: [PATCH 0/4] Trivial set of FIPS 140-3 related changes
Message-ID: <Y6NwqFQqlszdheYZ@sol.localdomain>
References: <20221108142025.13461-1-nstange@suse.de>
 <20221221152400.8515-1-vdronov@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221221152400.8515-1-vdronov@redhat.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Dec 21, 2022 at 04:24:00PM +0100, Vladis Dronov wrote:
> Hi Nicolai, Robert, Herbert, all,
> 
> I would like to revive this older upstream email thread. I would like
> to address notes from reviewers (namely, Robert) by additional patches
> so the whole patchset can be accepted. This should ease our future
> kernel work re: FIPS.
> 
> The below 2 patches address (I hope) both notes Robert and Herbert have
> provided (thanks!). I hope the whole patchset can be accepted then.
> 
> Logically my 2 patches should follow [PATCH 1/4] and be patches 2 and 3.
> Herbert is it possible to reorder them when accepting?
> 
> Thank you! and
> 
> Best regards,
> Vladis

Please just resend the whole series, with the --base option to git format-patch
used, so that reviewers don't have to try to piece it together.

- Eric
