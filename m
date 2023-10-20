Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78ED4CDB47E
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 05:27:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233471AbjJTF1D (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 01:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232838AbjJTF1C (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 01:27:02 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9831F119
        for <linux-crypto@vger.kernel.org>; Thu, 19 Oct 2023 22:26:59 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qti2A-0097BI-Qw; Fri, 20 Oct 2023 13:26:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Oct 2023 13:27:00 +0800
Date:   Fri, 20 Oct 2023 13:27:00 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Damian Muszynski <damian.muszynski@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH 00/11] crypto: qat - add rate limiting feature to qat_4xxx
Message-ID: <ZTIPpMdWOWBuHAmM@gondor.apana.org.au>
References: <20231011121934.45255-1-damian.muszynski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231011121934.45255-1-damian.muszynski@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 11, 2023 at 02:14:58PM +0200, Damian Muszynski wrote:
> This set introduces the rate limiting feature to the Intel QAT accelerator.
> The Rate Limiting allows control of the rate of the requests that can be
> submitted on a ring pair (RP). This allows sharing a QAT device among
> multiple users while ensuring a guaranteed throughput.

This does not sound like something that should sit in a driver.

Could we implement this in crypto_engine instead?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
