From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH] crypto: DRBG - guard uninstantion by lock
Date: Sun, 08 Apr 2018 21:07:03 +0200
Message-ID: <6541596.TtyMCBNA0Q@positron.chronox.de>
References: <001a114467482dbc4b05692df8f9@google.com> <4564679.HlOejCIXXz@positron.chronox.de> <CACT4Y+Y7hdm6LX5-PZu9zXFSmAKMP_jCYY7Z7g6a0xd_XCEYhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Matthew Wilcox <willy@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Eric Biggers <ebiggers3@gmail.com>,
        syzbot <syzbot+75397ee3df5c70164154@syzkaller.appspotmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com, Al Viro <viro@zeniv.linux.org.uk>
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACT4Y+Y7hdm6LX5-PZu9zXFSmAKMP_jCYY7Z7g6a0xd_XCEYhA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Sonntag, 8. April 2018, 17:41:17 CEST schrieb Dmitry Vyukov:

Hi Dmitry,
> 
> Hi,
> 
> Here is config and kernel commit:
> https://groups.google.com/d/msg/syzkaller-bugs/PINYyzoaG1s/ntZPOZdcCAAJ
> You can also find compiler and image here if necessary:
> https://github.com/google/syzkaller/blob/master/docs/syzbot.md
> 
> And note that the program needs to be compiled with -m32. The bugs is
> probably not-compat specific, but the program injects fault into a
> particular malloc invocation and maybe malloc numbering is affected by
> compat path.

I am unable to reproduce the issue. But since you mention that you induce errors, I could see that the unlocking of the DRBG context is too soon.

Can you please check whether the attached patch fixes the issue?

Thanks

---8<---

In the error code path, the uninstantiation must be guarded by a lock to
ensure that the modification of the context is fully atomic.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
Reported-by: syzkaller
---
 crypto/drbg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 4faa2781c964..68c1949a253f 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1510,8 +1510,8 @@ static int drbg_instantiate(struct drbg_state *drbg, struct drbg_string *pers,
 	return ret;
 
 free_everything:
-	mutex_unlock(&drbg->drbg_mutex);
 	drbg_uninstantiate(drbg);
+	mutex_unlock(&drbg->drbg_mutex);
 	return ret;
 }
 
-- 
2.14.3
