Return-Path: <SRS0=PsuD=V6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BDB7C32750
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Aug 2019 04:56:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 175D82073D
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Aug 2019 04:56:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732144AbfHBE4E (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Aug 2019 00:56:04 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:48706 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726723AbfHBE4E (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Aug 2019 00:56:04 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1htPbi-0006KJ-QV; Fri, 02 Aug 2019 14:55:58 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1htPbi-0004kk-CJ; Fri, 02 Aug 2019 14:55:58 +1000
Date:   Fri, 2 Aug 2019 14:55:58 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     Matt Mackall <mpm@selenic.com>, linux-crypto@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: timeriomem - add include guard to timeriomem-rng.h
Message-ID: <20190802045558.GI18077@gondor.apana.org.au>
References: <20190728153236.9937-1-yamada.masahiro@socionext.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190728153236.9937-1-yamada.masahiro@socionext.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 29, 2019 at 12:32:36AM +0900, Masahiro Yamada wrote:
> Add a header include guard just in case.
> 
> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> ---
> 
>  include/linux/timeriomem-rng.h | 5 +++++
>  1 file changed, 5 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
