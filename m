Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8BA2C7EE2E
	for <linux-crypto@archiver.kernel.org>; Tue, 23 May 2023 16:55:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237240AbjEWQzK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 May 2023 12:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237395AbjEWQzH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 May 2023 12:55:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC72119;
        Tue, 23 May 2023 09:55:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4C8960FE4;
        Tue, 23 May 2023 16:55:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03121C433A0;
        Tue, 23 May 2023 16:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684860905;
        bh=2LzcOiQLC5olbdkH1iNnRq1VU9n6cqrsWV+BKWk4NLM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hblGAen6ACc5znsH46OJeOvOTTKnoaGyl/L/5b9VASCmGoYHPc4CKnBI2AFekmZCz
         ZrDu44bpy9c01OheLjM07rLfRImBoj6ZNbjAYwWqTbIVjmZKh9L4CamU29ADsB46XQ
         YwX98pxdVWQtFqhCxMwUerZMU5FRVrW2Kf4WJQROuL3QLnqdXnbMZP5PACvY8dxj9w
         pZNkmyrCl6J2BkRvaxNMBklGII5j4NRwbS7r/4Yr1/JB4z4DMr/Dwa40CU4aWsRqgk
         gXBpGlPj4AnOSQdNXBzwcU7G9tNeHjhhEuODgAwBGFVhw7XHHN/eo/6+GBH3puTR9r
         uPdRTQAP/tC3w==
Date:   Tue, 23 May 2023 16:55:03 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     meenakshi.aggarwal@nxp.com
Cc:     horia.geanta@nxp.com, V.sethi@nxp.com, pankaj.gupta@nxp.com,
        gaurav.jain@nxp.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, iuliana.prodan@nxp.com
Subject: Re: [PATCH 0/5] Remove CRYPTO_ALG_ALLOCATES_MEMORY flag
Message-ID: <20230523165503.GA864814@google.com>
References: <20230523153421.1528359-1-meenakshi.aggarwal@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523153421.1528359-1-meenakshi.aggarwal@nxp.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 23, 2023 at 05:34:16PM +0200, meenakshi.aggarwal@nxp.com wrote:
> CRYPTO_ALG_ALLOCATES_MEMORY flag is limited only to dm-crypt use-cases,
> which seems to be 4 entries maximum.

This isn't mentioned in the documentation for CRYPTO_ALG_ALLOCATES_MEMORY.  So
it's not part of the contract of CRYPTO_ALG_ALLOCATES_MEMORY currently.

Please don't make this change without updating the documentation.

If you'd like to make this change, please update the documentation for
CRYPTO_ALG_ALLOCATES_MEMORY to mention this additional exception.

- Eric
