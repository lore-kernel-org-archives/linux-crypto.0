Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D36BEB64DA
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Jul 2023 22:00:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbjGEWAy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Jul 2023 18:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjGEWAx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Jul 2023 18:00:53 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FFBD9F;
        Wed,  5 Jul 2023 15:00:52 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qHAYF-000bA3-8I; Thu, 06 Jul 2023 08:00:44 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 06 Jul 2023 06:00:36 +0800
Date:   Thu, 6 Jul 2023 06:00:36 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     syzbot <syzbot+f2c120b449b209d89efa@syzkaller.appspotmail.com>,
        David Howells <dhowells@redhat.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [crypto?] WARNING in extract_iter_to_sg
Message-ID: <ZKXoBM7EQfbKKVjG@gondor.apana.org.au>
References: <0000000000003f2db705ffc133d2@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000003f2db705ffc133d2@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 05, 2023 at 11:02:16AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    3674fbf0451d Merge git://git.kernel.org/pub/scm/linux/kern..
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=10e4a802a80000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c9bf1936936ca698
> dashboard link: https://syzkaller.appspot.com/bug?extid=f2c120b449b209d89efa
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> 
> Unfortunately, I don't have any reproducer for this issue yet.

Hi David:

This looks like another regression.  It's not clear whether this
one will be fixed by your latest patch.  Could you please take a
look?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
