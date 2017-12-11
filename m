From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: KASAN: use-after-free Write in aead_recvmsg
Date: Mon, 11 Dec 2017 11:03:13 -0800
Message-ID: <20171211190313.GB62691@gmail.com>
References: <001a1141f050d78763055f85c42e@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: syzbot
        <bot+3cbaad7926415bb8cfce88469e5f66a2bbd0d0cd@syzkaller.appspotmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <001a1141f050d78763055f85c42e@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Dec 04, 2017 at 07:57:01AM -0800, syzbot wrote:
> syzbot will keep track of this bug report.
> Once a fix for this bug is committed, please reply to this email with:
> #syz fix: exact-commit-title
> If you want to test a patch for this bug, please reply with:
> #syz test: git://repo/address.git branch
> and provide the patch inline or as an attachment.
> To mark this as a duplicate of another syzbot report, please reply with:
> #syz dup: exact-subject-of-another-report
> If it's a one-off invalid bug report, please reply with:
> #syz invalid
> Note: if the crash happens again, it will cause creation of a new
> bug report.
> Note: all commands must start from beginning of the line in the email body.
> 

#syz fix: crypto: af_alg - fix race accessing cipher request
