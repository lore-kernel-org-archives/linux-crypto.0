Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22478EB64D9
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Jul 2023 23:26:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjGJX0j (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Jul 2023 19:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbjGJX0j (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Jul 2023 19:26:39 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D110898;
        Mon, 10 Jul 2023 16:26:37 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qJ0H4-0015aF-7o; Tue, 11 Jul 2023 09:26:35 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 11 Jul 2023 09:26:27 +1000
Date:   Tue, 11 Jul 2023 09:26:27 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Limonciello, Mario" <mario.limonciello@amd.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        John Allen <john.allen@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v5 00/11] Add dynamic boost control support
Message-ID: <ZKyTo0izAmDVYW3C@gondor.apana.org.au>
References: <20230623135001.18672-1-mario.limonciello@amd.com>
 <580858e8-27c8-ca3c-cb3d-61041298eb44@amd.com>
 <ZKyRUB7dGzQ/FaIG@gondor.apana.org.au>
 <12148445-cc19-28a2-2a36-7511d5c57e9f@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12148445-cc19-28a2-2a36-7511d5c57e9f@amd.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 10, 2023 at 06:25:21PM -0500, Limonciello, Mario wrote:
>
> Right; this is why I was offering to re-base it on 6.5-rc1 if necessary.

If there are no major conflicts a rebase is not necessary.  It will
only delay your patches further.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
