Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7F10CDB46E
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Oct 2023 14:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343958AbjJLO21 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Oct 2023 10:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347103AbjJLO20 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Oct 2023 10:28:26 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D8DBD6
        for <linux-crypto@vger.kernel.org>; Thu, 12 Oct 2023 07:28:23 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qqwff-006Pn5-Ni; Thu, 12 Oct 2023 22:28:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 12 Oct 2023 22:28:20 +0800
Date:   Thu, 12 Oct 2023 22:28:20 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Denis Kenzior <denkenz@gmail.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        James Prestwood <prestwoj@gmail.com>
Subject: Re: Linux 6.5 broke iwd
Message-ID: <ZSgChGwi1r9CILPI@gondor.apana.org.au>
References: <ab4d8025-a4cc-48c6-a6f0-1139e942e1db@gmail.com>
 <ZSc/9nUuF/d24iO6@gondor.apana.org.au>
 <ZSda3l7asdCr06kA@gondor.apana.org.au>
 <be96d2e7-592e-467e-9ad2-3f69a69cf844@gmail.com>
 <ZSdn29PDrs6hzjV9@gondor.apana.org.au>
 <1d22cd18-bc2a-4273-8087-e74030fbf373@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d22cd18-bc2a-4273-8087-e74030fbf373@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Oct 12, 2023 at 09:19:42AM -0500, Denis Kenzior wrote:
>
> Unfortunately that commit causes the unit test to crash the kernel.
> bash-5.1# uname -a
> Linux (none) 6.4.0-rc1-00082-g3867caee497e #37 Thu Oct 12 09:11:21 CDT 2023
> x86_64 GNU/Linux
> bash-5.1# unit/test-key
> TEST: unsupported
> TEST: user key
> TEST: Diffie-Hellman 1
> TEST: Diffie-Hellman 2
> TEST: Diffie-Hellman 3
> TEST: simple keyring
> TEST: trusted keyring
> Kernel panic - not syncing: Kernel mode fault at addr 0x18, ip 0x601fac3a
> CPU: 0 PID: 28 Comm: test-key Not tainted 6.4.0-rc1-00082-g3867caee497e #37
> Stack:
>  6232a840 6232d400 00000000 2000000100
>  62345e00 00000000 718b7aa0 718b7aa0
>  00000000 712851d8 10000000400 00000000

OK, we need to take a step back.  The commits that you're testing
are all known to be buggy.

So please tell me what exactly is the problem with the latest kernel
and then we can work it back from there.

If you have a reproducer that works on the latest kernel that would
be great.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
