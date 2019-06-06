Return-Path: <SRS0=NolZ=UF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C9E8C04AB5
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 06:50:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3932A20673
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 06:50:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725766AbfFFGu5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Jun 2019 02:50:57 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:38686 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725267AbfFFGu5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Jun 2019 02:50:57 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hYmEh-0006rY-LI; Thu, 06 Jun 2019 14:50:55 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hYmEd-0006gi-I4; Thu, 06 Jun 2019 14:50:51 +0800
Date:   Thu, 6 Jun 2019 14:50:51 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        maxime.chevallier@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, nadavh@marvell.com, igall@marvell.com
Subject: Re: [PATCH 00/14] crypto: inside-secure - self-test fixes
Message-ID: <20190606065051.kc7nfpwx2tt5gw2d@gondor.apana.org.au>
References: <20190527145106.8693-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190527145106.8693-1-antoine.tenart@bootlin.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, May 27, 2019 at 04:50:52PM +0200, Antoine Tenart wrote:
> Hello,
> 
> The crypto runtime self-tests were improved and thanks to this we
> spotted new issues within the Inside Secure SafeXcel cryptographic
> engine driver:
> - Intermediate IV were not retrieved from the hardware nor copied to the
>   quest IV buffer for cbc(aes/des).
> - HMAC updates wasn't supported.
> - We spotted issues with the use of the SG lists.
> - There was an issue with the use of result buffers.
> 
> The series fixes all those issues, and includes other small changes
> found while doing this work.
> 
> Thanks!
> Antoine
> 
> Antoine Tenart (14):
>   crypto: inside-secure - remove empty line
>   crypto: inside-secure - move comment
>   crypto: inside-secure - fix coding style for a condition
>   crypto: inside-secure - remove useless check
>   crypto: inside-secure - improve the result error format when displayed
>   crypto: inside-secure - change returned error when a descriptor
>     reports an error
>   crypto: inside-secure - enable context reuse
>   crypto: inside-secure - unify cache reset
>   crypto: inside-secure - fix zeroing of the request in ahash_exit_inv
>   crypto: inside-secure - fix queued len computation
>   crypto: inside-secure - implement IV retrieval
>   crypto: inside-secure - add support for HMAC updates
>   crypto: inside-secure - fix use of the SG list
>   crypto: inside-secure - do not rely on the hardware last bit for
>     result descriptors
> 
>  drivers/crypto/inside-secure/safexcel.c       |  13 +-
>  drivers/crypto/inside-secure/safexcel.h       |  17 ++-
>  .../crypto/inside-secure/safexcel_cipher.c    | 116 +++++++++++-------
>  drivers/crypto/inside-secure/safexcel_hash.c  |  92 ++++++++------
>  drivers/crypto/inside-secure/safexcel_ring.c  |   3 +
>  5 files changed, 157 insertions(+), 84 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
