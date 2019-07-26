Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=FAKE_REPLY_C,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CD8CC7618B
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 12:33:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6305822ADA
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 12:33:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbfGZMdW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 08:33:22 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:46446 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726366AbfGZMdV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 08:33:21 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hqzPT-0003rw-Qf; Fri, 26 Jul 2019 22:33:19 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hqzPS-00029x-3X; Fri, 26 Jul 2019 22:33:18 +1000
Date:   Fri, 26 Jul 2019 22:33:18 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Hook, Gary" <Gary.Hook@amd.com>
Cc:     linux-crypto@vger.kernel.org, Thomas.Lendacky@amd.com,
        davem@davemloft.net
Subject: Re: [PATCH v2 0/4] Add module parameters to control CCP activation
Message-ID: <20190726123317.GA8294@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156268468861.18577.13211913750250195885.stgit@sosrh3.amd.com>
Organization: Core
X-Newsgroups: apana.lists.os.linux.cryptoapi
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hook, Gary <Gary.Hook@amd.com> wrote:
> Firstly, add a switch to allow/disallow debugfs code to be built into
> the CCP driver.
> 
> This rest of the patch series implements a set of module parameters
> that allows control over which CCPs on a system are enabled by the
> driver, and how many queues on each device are activated.^M
> 
> A switch to enable/disable DMA engine registration is implemented.
> 
> Details:
> nqueues - configure N queues per CCP (default: 0 - all queues enabled)
> max_devs - maximum number of devices to enable (default: 0 - all
>           devices activated)
> dmaengine - Register services with the DMA subsystem (default: true)
> 
> Only activated devices will have their DMA services registered,
> comprehensively controlled by the dmaengine parameter.
> 
> Changes since v1:
> - Remove debugfs patches that duplicates sysfs function
> - Remove patches for filtering by pcibus and pci device ID
> - Utilize underscores for consistency in variable names
> - Correct commit message for nqueues regarding default value
> - Alter verbage of parameter description (dmaengine)
> - Help text in Kconfig: remove reference to parameters in debugfs
> 
> ---
> 
> Gary R Hook (4):^M
>      crypto: ccp - Make CCP debugfs support optional
>      crypto: ccp - Add a module parameter to specify a queue count
>      crypto: ccp - module parameter to limit the number of enabled CCPs
>      crypto: ccp - Add a module parameter to control registration for DMA
> 
> 
> drivers/crypto/ccp/Kconfig         |    8 ++++++++
> drivers/crypto/ccp/Makefile        |    4 ++--
> drivers/crypto/ccp/ccp-dev-v3.c    |    2 +-
> drivers/crypto/ccp/ccp-dev-v5.c    |   11 ++++++-----
> drivers/crypto/ccp/ccp-dev.c       |   29 ++++++++++++++++++++++++++++-
> drivers/crypto/ccp/ccp-dev.h       |    1 +
> drivers/crypto/ccp/ccp-dmaengine.c |   12 +++++++++++-
> 7 files changed, 57 insertions(+), 10 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
