From: syzbot <syzbot+9c251bdd09f83b92ba95@syzkaller.appspotmail.com>
Subject: Re: KMSAN: uninit-value in af_alg_free_areq_sgls
Date: Sat, 07 Jul 2018 12:01:02 -0700
Message-ID: <000000000000d7542605706d66a3@google.com>
References: <1612449.5GibSviISC@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
To: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        smueller@chronox.de, syzkaller-bugs@googlegroups.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1612449.5GibSviISC@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger  
crash:

Reported-and-tested-by:  
syzbot+9c251bdd09f83b92ba95@syzkaller.appspotmail.com

Tested on:

commit:         a00de5aa4da3 kmsan: delete some dead code
git tree:       https://github.com/google/kmsan.git/master
kernel config:  https://syzkaller.appspot.com/x/.config?x=b11f4cfb262ee607
compiler:       clang version 7.0.0 (trunk 334104)
patch:          https://syzkaller.appspot.com/x/patch.diff?x=17a9badc400000

Note: testing is done by a robot and is best-effort only.
