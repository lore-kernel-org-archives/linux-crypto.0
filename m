Return-Path: <SRS0=+KeW=2R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3361C2D0C6
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Dec 2019 10:37:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACE3C21582
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Dec 2019 10:37:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbfL0KhS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Dec 2019 05:37:18 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:60178 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726354AbfL0KhR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Dec 2019 05:37:17 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1ikmzc-0007L7-OQ; Fri, 27 Dec 2019 18:37:16 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1ikmzb-0005lm-VW; Fri, 27 Dec 2019 18:37:16 +0800
Date:   Fri, 27 Dec 2019 18:37:15 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: curve25519 - re-add selftests
Message-ID: <20191227103715.ypvwmxmb3eh73cbm@gondor.apana.org.au>
References: <20191216185326.688195-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191216185326.688195-1-Jason@zx2c4.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Dec 16, 2019 at 06:53:26PM +0000, Jason A. Donenfeld wrote:
> Somehow these were dropped when Zinc was being integrated, which is
> problematic, because testing the library interface for Curve25519 is
> important.. This commit simply adds them back and wires them in in the
> same way that the blake2s selftests are wired in.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  lib/crypto/Makefile              |    1 +
>  lib/crypto/curve25519-selftest.c | 1321 ++++++++++++++++++++++++++++++
>  lib/crypto/curve25519.c          |   17 +
>  3 files changed, 1339 insertions(+)
>  create mode 100644 lib/crypto/curve25519-selftest.c

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
