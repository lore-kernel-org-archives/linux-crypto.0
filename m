Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84817C83F01
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Aug 2023 11:56:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239773AbjHaL40 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Aug 2023 07:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234377AbjHaL40 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Aug 2023 07:56:26 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46B3CC5;
        Thu, 31 Aug 2023 04:56:19 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qbgHW-009eAk-Sn; Thu, 31 Aug 2023 19:56:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 31 Aug 2023 19:56:16 +0800
Date:   Thu, 31 Aug 2023 19:56:16 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     thomas.lendacky@amd.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/5] Fixes for dynamic boost control for 6.6
Message-ID: <ZPB/4FAL4DKrS9vw@gondor.apana.org.au>
References: <20230829150759.156126-1-mario.limonciello@amd.com>
 <ZPBXL0OVXMpp/BUb@gondor.apana.org.au>
 <2e7637b9-0f84-41e3-bc6e-d22a74b53c74@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e7637b9-0f84-41e3-bc6e-d22a74b53c74@amd.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 31, 2023 at 06:27:59AM -0500, Mario Limonciello wrote:
>
> So some boots you see the character device and can interact with it, others
> you can't.  If you start with 'ccp' loaded and it working, then
> unload/reload it might not come back.

Is it just the new functionality that's broken or does it cause
existing functionality to fail as well?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
