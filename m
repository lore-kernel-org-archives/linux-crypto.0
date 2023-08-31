Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E81CC83F17
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Aug 2023 09:02:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbjHaJCs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Aug 2023 05:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbjHaJCs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Aug 2023 05:02:48 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59CEBCED;
        Thu, 31 Aug 2023 02:02:42 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qbdZW-009b2i-19; Thu, 31 Aug 2023 17:02:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 31 Aug 2023 17:02:39 +0800
Date:   Thu, 31 Aug 2023 17:02:39 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     thomas.lendacky@amd.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/5] Fixes for dynamic boost control for 6.6
Message-ID: <ZPBXL0OVXMpp/BUb@gondor.apana.org.au>
References: <20230829150759.156126-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230829150759.156126-1-mario.limonciello@amd.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Aug 29, 2023 at 10:07:54AM -0500, Mario Limonciello wrote:
>
> This series fixes all problems found. Ideally all patches should
> be submitted for a future 6.6-rc, but, the most important is
> "crypto: ccp: Get a free page to use while fetching initial nonce"
> if the rest must be pushed to 6.7.

As far as I can see it simply means that the new feature of DBC does
not work.  If that's all then I don't think it's an urgent issue and
this can wait until 6.7.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
