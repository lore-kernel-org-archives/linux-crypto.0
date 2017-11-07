From: David Howells <dhowells@redhat.com>
Subject: Re: general protection fault in asn1_ber_decoder
Date: Tue, 07 Nov 2017 13:08:06 +0000
Message-ID: <12841.1510060086@warthog.procyon.org.uk>
References: <20171106222153.GA37298@gmail.com> <94eb2c1886e4e1e95e055d54b9ab@google.com> <15884.1510005945@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com,
        syzbot
        <bot+04b92812698232d15d78c1e4d3bbf6fcc21eeeb1@syzkaller.appspotmail.com>,
        davem@davemloft.net, herbert@gondor.apana.org.au,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34364 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934026AbdKGNIJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Nov 2017 08:08:09 -0500
In-Reply-To: <20171106222153.GA37298@gmail.com>
Content-ID: <12840.1510060086.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Eric Biggers <ebiggers3@gmail.com> wrote:

> Hi David, you just beat me to it, but I don't think this is the best way to
> fix the problem.  The length check just needs to be rewritten to not
> overflow.  Also it seems there is another broken length check later in the
> function.  How about this:

Okay, fair enough.  Do you mind if I trim your register dump a bit?

David
