Return-Path: <SRS0=nn+h=7V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBE1EC433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Jun 2020 06:26:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A154B20774
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Jun 2020 06:26:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728580AbgFHG0L (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Jun 2020 02:26:11 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:53888 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728538AbgFHG0K (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Jun 2020 02:26:10 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jiBER-0001by-JS; Mon, 08 Jun 2020 16:26:04 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 08 Jun 2020 16:26:03 +1000
Date:   Mon, 8 Jun 2020 16:26:03 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [v2 PATCH] crc-t10dif: Fix potential crypto notify dead-lock
Message-ID: <20200608062603.GC21732@gondor.apana.org.au>
References: <20200604063324.GA28813@gondor.apana.org.au>
 <20200605065918.GA813@gondor.apana.org.au>
 <20200605182237.GG1373@sol.localdomain>
 <20200605184527.GH1373@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605184527.GH1373@sol.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 05, 2020 at 11:45:27AM -0700, Eric Biggers wrote:
> How about the following:
> 
> (It includes some other cleanups too, like switching to the static_branch API,
>  since the static_key one is deprecated and confusing.  I can split it into
>  separate patches...)

I don't have objections to your patch but I think it's logically
separate change and I would prefer it to go on top of my patch.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
