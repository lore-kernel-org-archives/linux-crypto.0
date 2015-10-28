From: Stephan Mueller <smueller@chronox.de>
Subject: Re: kernel tainted while exporting shash context using af_alg interface
Date: Wed, 28 Oct 2015 01:09:58 +0100
Message-ID: <2100556.thFK4ZhSZX@myon.chronox.de>
References: <CAFXBA=mVmRsAk3fuyjf3WA-P+0dHKu0upUdb5Qxr0kwn1rKiDw@mail.gmail.com> <CAFXBA==rM=XBykDC+K2tvS=Gya+ykBZp4ySnjQbPcgebOOYZGw@mail.gmail.com> <CAFXBA==5iFOGWrZ+JtM4Yr1XnBL2NFRs=EMoeS4F2mF-R89iqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Harsh Jain <harshjain.prof@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34418 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754450AbbJ1AKD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 Oct 2015 20:10:03 -0400
In-Reply-To: <CAFXBA==5iFOGWrZ+JtM4Yr1XnBL2NFRs=EMoeS4F2mF-R89iqQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 26. Oktober 2015, 14:51:01 schrieb Harsh Jain:

Hi Harsh,

> Hi Stephan,
> 
> I tried 1 more patch. This time result is correct. Find attached patch
> file. Is there any side effect of this patch.

The strace is enlightening.

The user space code does an accept on an already accepted FD

It seems your user space does something like:

socket()
fd = bind()
fd1 = accept(fd)
fd2 = accept(fd1)
fd3 = accept(fd2)
...

That is an error in the user space code. The correct way would be like the 
code in [1] with all the lines until the line 553 (the code afterwards is for 
vmsplice).

So, the code goes like that:

tfmfd = socket()
bind(tfmfd)
opfd = accept(tfmfd);

>From now on, you use opfd for all sendmsg/recvmsg operations.


However, any error in user space should not crash the kernel. So, a fix should 
be done. But I think your code is not correct as it solidifies a broken user 
space code.

I would rather think the following patch should be added to prevent the oops. 
At least for me, multiple accepts does not crash the kernel. Can you please 
test whether this patch ensures you kernel stays sane?

diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index 1396ad0..785df23 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -183,6 +183,9 @@ static int hash_accept(struct socket *sock, struct socket 
*newsock, int flags)
 	struct hash_ctx *ctx2;
 	int err;
 
+	if (!ctx->more)
+		return -EINVAL;
+
 	err = crypto_ahash_export(req, state);
 	if (err)
 		return err;


[1] https://github.com/smuellerDD/libkcapi/blob/master/lib/kcapi-kernel-if.c#L534


-- 
Ciao
Stephan
