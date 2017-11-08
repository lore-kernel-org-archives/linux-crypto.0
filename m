From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: general protection fault in asn1_ber_decoder
Date: Wed, 8 Nov 2017 12:40:22 -0800
Message-ID: <20171108204022.GB14292@gmail.com>
References: <94eb2c1886e4e1e95e055d54b9ab@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, dhowells@redhat.com,
        herbert@gondor.apana.org.au, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot
        <bot+04b92812698232d15d78c1e4d3bbf6fcc21eeeb1@syzkaller.appspotmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:47833 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751728AbdKHUk0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Nov 2017 15:40:26 -0500
Content-Disposition: inline
In-Reply-To: <94eb2c1886e4e1e95e055d54b9ab@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 06, 2017 at 10:36:00AM -0800, syzbot wrote:
> 
> syzbot will keep track of this bug report.
> Once a fix for this bug is committed, please reply to this email with:
> #syz fix: exact-commit-title
> To mark this as a duplicate of another syzbot report, please reply with:
> #syz dup: exact-subject-of-another-report
> If it's a one-off invalid bug report, please reply with:
> #syz invalid
> Note: if the crash happens again, it will cause creation of a new
> bug report.
> Note: all commands must start from beginning of the line.

#syz fix: KEYS: fix NULL pointer dereference during ASN.1 parsing [ver #2]
