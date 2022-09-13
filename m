Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4E7BC54EE9
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Sep 2022 09:18:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231528AbiIMJSg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Sep 2022 05:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbiIMJSe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Sep 2022 05:18:34 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC87BB3;
        Tue, 13 Sep 2022 02:18:31 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oY23n-004AlE-BR; Tue, 13 Sep 2022 19:18:28 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 Sep 2022 17:18:27 +0800
Date:   Tue, 13 Sep 2022 17:18:27 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Elliott, Robert (Servers)" <elliott@hpe.com>
Cc:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Accidental config renaming in commit 3f342a23257d ("crypto:
 Kconfig - simplify hash entries")
Message-ID: <YyBK46H1HTR7rFEx@gondor.apana.org.au>
References: <CAKXUXMyMUNgra_B47Qk3kjqgmR-FcCbDpEZMH5rv=whrQDRQww@mail.gmail.com>
 <MW5PR84MB18424AB8C095BFC041AE33FDAB479@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW5PR84MB18424AB8C095BFC041AE33FDAB479@MW5PR84MB1842.NAMPRD84.PROD.OUTLOOK.COM>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Sep 13, 2022 at 08:30:45AM +0000, Elliott, Robert (Servers) wrote:
>
> Herbert, can you fix that in a way that won't
> cause bisection anomalies?

Sorry, it's a bit late for that.  Please send an incremental patch.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
