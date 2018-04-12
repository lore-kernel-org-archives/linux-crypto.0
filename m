From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH] crypto: drbg - set freed buffers to NULL
Date: Thu, 12 Apr 2018 08:40:55 +0200
Message-ID: <2295196.9WStPcntd3@positron.chronox.de>
References: <001a114467482dbc4b05692df8f9@google.com> <2186798.qrgUIDAn9S@positron.chronox.de> <20316956.hJt0ZTxKTH@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Dmitry Vyukov <dvyukov@google.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Matthew Wilcox <willy@infradead.org>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Eric Biggers <ebiggers3@gmail.com>,
        syzbot <syzbot+75397ee3df5c70164154@syzkaller.appspotmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Al Viro <viro@zeniv.linux.org.uk>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20316956.hJt0ZTxKTH@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add the Fixes, CC stable tags.

---8<---

During freeing of the internal buffers used by the DRBG, set the pointer
to NULL. It is possible that the context with the freed buffers is
reused. In case of an error during initialization where the pointers
do not yet point to allocated memory, the NULL value prevents a double
free.

Cc: stable@vger.kernel.org
Fixes: 3cfc3b9721123 ("crypto: drbg - use aligned buffers")
Signed-off-by: Stephan Mueller <smueller@chronox.de>
Reported-by: syzbot+75397ee3df5c70164154@syzkaller.appspotmail.com
---
 crypto/drbg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 4faa2781c964..466a112a4446 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1134,8 +1134,10 @@ static inline void drbg_dealloc_state(struct drbg_state *drbg)
 	if (!drbg)
 		return;
 	kzfree(drbg->Vbuf);
+	drbg->Vbuf = NULL;
 	drbg->V = NULL;
 	kzfree(drbg->Cbuf);
+	drbg->Cbuf = NULL;
 	drbg->C = NULL;
 	kzfree(drbg->scratchpadbuf);
 	drbg->scratchpadbuf = NULL;
-- 
2.14.3
