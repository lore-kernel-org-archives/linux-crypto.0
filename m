Return-Path: <SRS0=W3IF=ZO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8C01C432C3
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 11:10:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC24E2070E
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Nov 2019 11:10:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbfKVLKg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Nov 2019 06:10:36 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:54000 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729359AbfKVLK3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Nov 2019 06:10:29 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iY6pW-0005KF-Pj; Fri, 22 Nov 2019 19:10:26 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iY6pU-0002kV-IY; Fri, 22 Nov 2019 19:10:24 +0800
Date:   Fri, 22 Nov 2019 19:10:24 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     davem@davemloft.net, narmstrong@baylibre.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: amlogic: enable working on big endian kernel
Message-ID: <20191122111023.urwkmyi7macccdd4@gondor.apana.org.au>
References: <1574006993-27022-1-git-send-email-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1574006993-27022-1-git-send-email-clabbe@baylibre.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Nov 17, 2019 at 04:09:53PM +0000, Corentin Labbe wrote:
> On big endian kernel, the GXL crypto driver does not works.
> This patch do the necessary modification to permit it to work on BE
> kernel (removing bitfield and adds some cpu_to_le32).
> 
> Fixes: 48fe583fe541 ("crypto: amlogic - Add crypto accelerator for amlogic GXL")
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>  drivers/crypto/amlogic/amlogic-gxl-cipher.c | 26 +++++------
>  drivers/crypto/amlogic/amlogic-gxl.h        | 51 +++++++++------------
>  2 files changed, 34 insertions(+), 43 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
