Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 239EEEB64D9
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Jun 2023 09:13:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241250AbjFOJNl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Jun 2023 05:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240706AbjFOJNl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Jun 2023 05:13:41 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4BD2119;
        Thu, 15 Jun 2023 02:13:39 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1q9j2n-003GDH-T8; Thu, 15 Jun 2023 17:13:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 Jun 2023 17:13:29 +0800
Date:   Thu, 15 Jun 2023 17:13:29 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     David Howells <dhowells@redhat.com>
Cc:     syzbot <syzbot+13a08c0bf4d212766c3c@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [crypto?] general protection fault in shash_async_final
Message-ID: <ZIrWOe4pG7M3TJic@gondor.apana.org.au>
References: <000000000000b928f705fdeb873a@google.com>
 <1433015.1686741914@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1433015.1686741914@warthog.procyon.org.uk>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jun 14, 2023 at 12:25:14PM +0100, David Howells wrote:
> Here's a reduced testcase for this.  The key seems to be passing MSG_MORE to
> sendmsg() and then not following up with more data before calling recvmsg().
> Apart from not oopsing, I wonder what the behaviour should be here?  Should
> recvmsg() return an error (EAGAIN or ENODATA maybe) or should it close the
> existing operation?

On send if MSG_MORE is set then we don't finalise the hash.

If the user calls recvmsg while the hash hasn't been finalised, then
we will force finalisation (thus rendering the last MSG_MORE moot).

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
