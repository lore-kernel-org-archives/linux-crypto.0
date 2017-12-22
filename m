From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: KASAN: use-after-free Read in __list_del_entry_valid (2)
Date: Fri, 22 Dec 2017 11:25:44 -0600
Message-ID: <20171222172544.GD588@zzz.localdomain>
References: <94eb2c05a380d3908b056096eb58@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot
        <bot+29cf0a34886ca39d13fc0451b174140973b5bed3@syzkaller.appspotmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:44265 "EHLO
        mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756171AbdLVRZr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Dec 2017 12:25:47 -0500
Content-Disposition: inline
In-Reply-To: <94eb2c05a380d3908b056096eb58@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Dec 17, 2017 at 09:50:01PM -0800, syzbot wrote:
>
> syzbot will keep track of this bug report.
> Once a fix for this bug is merged into any tree, reply to this email with:
> #syz fix: exact-commit-title
> If you want to test a patch for this bug, please reply with:
> #syz test: git://repo/address.git branch
> and provide the patch inline or as an attachment.
> To mark this as a duplicate of another syzbot report, please reply with:
> #syz dup: exact-subject-of-another-report
> If it's a one-off invalid bug report, please reply with:
> #syz invalid
> Note: if the crash happens again, it will cause creation of a new bug
> report.
> Note: all commands must start from beginning of the line in the email body.

#syz fix: crypto: pcrypt - fix freeing pcrypt instances
