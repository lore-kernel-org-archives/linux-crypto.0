Return-Path: <SRS0=5D8e=VX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=FAKE_REPLY_C,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 699E1C7618B
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 12:35:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46C1722ADA
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jul 2019 12:35:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbfGZMfM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jul 2019 08:35:12 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:46492 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbfGZMfM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jul 2019 08:35:12 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hqzRF-0003yl-9S; Fri, 26 Jul 2019 22:35:09 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hqzRF-0002CS-20; Fri, 26 Jul 2019 22:35:09 +1000
Date:   Fri, 26 Jul 2019 22:35:08 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Vakul Garg <vakul.garg@nxp.com>
Cc:     linux-crypto@vger.kernel.org, horia.geanta@nxp.com,
        aymen.sghaier@nxp.com, vakul.garg@nxp.com
Subject: Re: [PATCH] crypto: caam/qi2 - Increase napi budget to process more
 caam responses
Message-ID: <20190726123508.GA8449@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190718112440.4052-1-vakul.garg@nxp.com>
Organization: Core
X-Newsgroups: apana.lists.os.linux.cryptoapi
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Vakul Garg <vakul.garg@nxp.com> wrote:
> While running ipsec processing for traffic through multiple network
> interfaces, it is observed that caam driver gets less time to poll
> responses from caam block compared to ethernet driver. This is because
> ethernet driver has as many napi instances per cpu as the number of
> ethernet interfaces in system. Therefore, caam driver's napi executes
> lesser than the ethernet driver's napi instances. This results in
> situation that we end up submitting more requests to caam (which it is
> able to finish off quite fast), but don't dequeue the responses at same
> rate. This makes caam response FQs bloat with large number of frames. In
> some situations, it makes kernel crash due to out-of-memory. To prevent
> it We increase the napi budget of dpseci driver to a big value so that
> caam driver is able to drain its response queues at enough rate.
> 
> Signed-off-by: Vakul Garg <vakul.garg@nxp.com>
> ---
> drivers/crypto/caam/caamalg_qi2.h | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
