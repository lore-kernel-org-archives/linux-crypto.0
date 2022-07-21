Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59A96C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jul 2022 06:50:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbiGUGuu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Jul 2022 02:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbiGUGuu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Jul 2022 02:50:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E39B42ADA
        for <linux-crypto@vger.kernel.org>; Wed, 20 Jul 2022 23:50:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DEF2761D9D
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jul 2022 06:50:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C695C3411E;
        Thu, 21 Jul 2022 06:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658386248;
        bh=UHUsl9CtsXcyKDgHf6BH2bn/4luWzcIbgh/lZOrmzyA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LHFz3E2NtB3HKKV5MRMM2Yj0kXCQgi/oe0Y8tYCPUwxyCs29M4E5on1aU2HYvYgco
         e97Nok9nfITPSvzZmpFamTDZ2miQibuirYmMja5n3uFtfDAbAPVbmmgUXrW/2WAMwJ
         kMeDLuoIOU0BXsRGTJrZ2m+005U19mssKn4JABAAULt74d5nnOuq2FI7CINWnKUSyK
         iE3z6EWtAlnLH5fQpJipr7VmnRadbjQk86PMS0tTleI06aAUw1xQVhVyvk4f9xF5ke
         p+uIGmXnSFhduxcyH+Lvuja9i48TXxAuavfoe3Vyd08MeVeYMfBE7ZhVhVfFLu2WKO
         YHS/EDe3uqqNw==
Date:   Wed, 20 Jul 2022 23:50:46 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Guozihua (Scott)" <guozihua@huawei.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-crypto@vger.kernel.org, luto@kernel.org, tytso@mit.edu
Subject: Re: Inquiry about the removal of flag O_NONBLOCK on /dev/random
Message-ID: <Ytj3RnGtWqg18bxO@sol.localdomain>
References: <13e1fa9d-4df8-1a99-ca22-d9d655f2d023@huawei.com>
 <YtaPJPkewin5uWdn@zx2c4.com>
 <b9cb514c-30ed-0b8b-5d54-75001e07bd36@huawei.com>
 <YtjREZMzuppTJHeR@sol.localdomain>
 <a93995db-a738-8e4f-68f2-42d7efd3c77d@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a93995db-a738-8e4f-68f2-42d7efd3c77d@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 21, 2022 at 02:44:54PM +0800, Guozihua (Scott) wrote:
> 
> Hi Eric
> 
> We have a userspace program that starts pretty early in the boot process and
> it tries to fetch random bits from /dev/random with O_NONBLOCK, if that
> returns -EAGAIN, it turns to /dev/urandom. Is this a correct handling of
> -EAGAIN? Or this is not one of the intended use case of O_NONBLOCK?

That doesn't make any sense; you should just use /dev/urandom unconditionally.

- Eric
