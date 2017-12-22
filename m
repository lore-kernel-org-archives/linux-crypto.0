From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: KASAN: wild-memory-access Write in scatterwalk_copychunks
Date: Fri, 22 Dec 2017 11:24:58 -0600
Message-ID: <20171222172458.GC588@zzz.localdomain>
References: <94eb2c05a380bd8f2a055ffc6de5@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot
        <bot+afbe81311aa0da046f1e62a665eccddac254f803@syzkaller.appspotmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <94eb2c05a380bd8f2a055ffc6de5@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Dec 10, 2017 at 05:31:01AM -0800, syzbot wrote:
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

#syz fix: crypto: chacha20poly1305 - validate the digest size
