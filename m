Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=FAKE_REPLY_C,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9BCBC7618B
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 12:34:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F2A322ADA
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 12:34:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbfGZMep (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 08:34:45 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:46482 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbfGZMep (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 08:34:45 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hqzQg-0003wt-T7; Fri, 26 Jul 2019 22:34:35 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hqzQa-0002BM-72; Fri, 26 Jul 2019 22:34:28 +1000
Date:   Fri, 26 Jul 2019 22:34:28 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     thomas.lendacky@amd.com, gary.hook@amd.com, davem@davemloft.net,
        arnd@arndb.de, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH] crypto: ccp - Reduce maximum stack usage
Message-ID: <20190726123428.GA8381@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190712085937.4157934-1-arnd@arndb.de>
Organization: Core
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> wrote:
> Each of the operations in ccp_run_cmd() needs several hundred
> bytes of kernel stack. Depending on the inlining, these may
> need separate stack slots that add up to more than the warning
> limit, as shown in this clang based build:
> 
> drivers/crypto/ccp/ccp-ops.c:871:12: error: stack frame size of 1164 bytes in function 'ccp_run_aes_cmd' [-Werror,-Wframe-larger-than=]
> static int ccp_run_aes_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
> 
> The problem may also happen when there is no warning, e.g. in the
> ccp_run_cmd()->ccp_run_aes_cmd()->ccp_run_aes_gcm_cmd() call chain with
> over 2000 bytes.
> 
> Mark each individual function as 'noinline_for_stack' to prevent
> this from happening, and move the calls to the two special cases for aes
> into the top-level function. This will keep the actual combined stack
> usage to the mimimum: 828 bytes for ccp_run_aes_gcm_cmd() and
> at most 524 bytes for each of the other cases.
> 
> Fixes: 63b945091a07 ("crypto: ccp - CCP device driver and interface support")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> drivers/crypto/ccp/ccp-ops.c | 52 +++++++++++++++++++++---------------
> 1 file changed, 31 insertions(+), 21 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
