Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 083D8CDB46E
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Oct 2023 03:28:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234059AbjJLD2d (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Oct 2023 23:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234050AbjJLD2c (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Oct 2023 23:28:32 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 335C0A4
        for <linux-crypto@vger.kernel.org>; Wed, 11 Oct 2023 20:28:30 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qqmN5-006E5B-8T; Thu, 12 Oct 2023 11:28:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 12 Oct 2023 11:28:27 +0800
Date:   Thu, 12 Oct 2023 11:28:27 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Denis Kenzior <denkenz@gmail.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        James Prestwood <prestwoj@gmail.com>
Subject: Re: Linux 6.5 broke iwd
Message-ID: <ZSdn29PDrs6hzjV9@gondor.apana.org.au>
References: <ab4d8025-a4cc-48c6-a6f0-1139e942e1db@gmail.com>
 <ZSc/9nUuF/d24iO6@gondor.apana.org.au>
 <ZSda3l7asdCr06kA@gondor.apana.org.au>
 <be96d2e7-592e-467e-9ad2-3f69a69cf844@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be96d2e7-592e-467e-9ad2-3f69a69cf844@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 11, 2023 at 10:09:02PM -0500, Denis Kenzior wrote:
.
> [denkenz@archdev linux]$ git checkout 63ba4d67594ad05b2c899b5a3a8cc7581052dd13
> HEAD is now at 63ba4d67594a KEYS: asymmetric: Use new crypto interface
> without scatterlists

No wonder I can't reproduce this.  This is already fixed by

commit 3867caee497edf6ce6b6117aac1c0b87c0a2cb5f
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Sat Jun 24 13:19:56 2023 +0800

    crypto: sm2 - Provide sm2_compute_z_digest when sm2 is disabled

It's just a bisection artifact, you need to skip the broken commit
when bisecting.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
