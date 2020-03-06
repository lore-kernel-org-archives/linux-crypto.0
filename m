Return-Path: <SRS0=LFd7=4X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEFC6C3F2D2
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Mar 2020 01:49:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B0AC20801
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Mar 2020 01:49:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgCFBtj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Mar 2020 20:49:39 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:46056 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726191AbgCFBti (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Mar 2020 20:49:38 -0500
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jA27J-0005mL-Gv; Fri, 06 Mar 2020 12:49:34 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Mar 2020 12:49:33 +1100
Date:   Fri, 6 Mar 2020 12:49:33 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto/chelsio: Fixed tls stats
Message-ID: <20200306014933.GF30653@gondor.apana.org.au>
References: <20200225165119.15798-1-vinay.yadav@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225165119.15798-1-vinay.yadav@chelsio.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Feb 25, 2020 at 10:21:20PM +0530, Vinay Kumar Yadav wrote:
> Added tls rx stats and reset tls rx/tx stats when chtls driver unload.
> 
> Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
> ---
>  drivers/crypto/chelsio/chtls/chtls_io.c   | 3 +++
>  drivers/crypto/chelsio/chtls/chtls_main.c | 7 +++++++
>  2 files changed, 10 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
