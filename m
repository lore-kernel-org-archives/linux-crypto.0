Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ACAEC433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 11 May 2022 10:32:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbiEKKcc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 May 2022 06:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbiEKKca (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 May 2022 06:32:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EBE8674EE;
        Wed, 11 May 2022 03:32:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C505BB821F3;
        Wed, 11 May 2022 10:32:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC887C34100;
        Wed, 11 May 2022 10:32:23 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="aNYd6eyx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1652265142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AhkZlwTy/MnKDtOLsAWyM89APgPUgwf5SHvRiUZyhNc=;
        b=aNYd6eyxNtktNXHjt7ia5FDXT0/rc6aXw+YlMjeFOrbAIYxYfMrl1q+oLd1ABrntBc7Hb6
        9MJqofXd+inWXrLcedZgDomPe8v/fLyRIZCDC9Ld7hw2dCbQZP5238YajkiUiVNkCpkAX9
        1bNrsbSG9GA4G3egi2drtLt9pi3LNBs=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id bdfa1396 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 11 May 2022 10:32:21 +0000 (UTC)
Date:   Wed, 11 May 2022 12:32:19 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] random: do not pretend to handle premature next security
 model
Message-ID: <YnuQlIOuOy7nHvSr@zx2c4.com>
References: <20220504113025.285784-1-Jason@zx2c4.com>
 <YntvKcp5PYDUKoFE@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YntvKcp5PYDUKoFE@sol.localdomain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric,

On Wed, May 11, 2022 at 01:09:13AM -0700, Eric Biggers wrote:
> A couple very minor comments:

Thanks, will fix these.

Jason
