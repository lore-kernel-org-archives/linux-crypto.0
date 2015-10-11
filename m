From: Corentin LABBE <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: crypto: sun4i-ss: bug with cryptodev
Date: Sun, 11 Oct 2015 13:34:22 +0200
Message-ID: <561A493E.6030902@gmail.com>
Reply-To: clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org" <linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-sunxi+bncBD7YLCN32UNBBQMS5GYAKGQE2RMCLKA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Post: <http://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/linux-sunxi
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/linux-sunxi/subscribe>
List-Id: linux-crypto.vger.kernel.org

Hello

I am working on some tools for checking the good working of crypto device (and benching them).
One of the tool use cryptodev (http://cryptodev-linux.org/) for using the kernel crypto API
(and so any hardware accelerated crypto).
The tool compare the results of an AES cipher via cryptodev and the result of the same cipher via openssl.
Exactly it test the results of one encryption, and then the decryption.

For an unknown reason, the tool detect a problem with my sun4i-ss driver.
The last n bytes of data are garbage.
This happens randomly for any length of data starting from 4096 bytes(I never got any fail with size < 4096).
But always on the deciphering test.
Example: I have the src buffer of 32768 bytes, I cipher it via cryptodev in the dst buffer
and then cipher it in odst via openssl. Then I compare dst and odst, that part is always working.
Then I use cryptodev to decipher dst in ddst, and compare src and ddst.
The test fail with ddst being garbage at offset 28784. (the offset is always different in each fail).

I have tried to find which change cause that problem and it seems to be introduced in v10.
But it is very strange because I am sure to have tested all versions with this tool.

I have found a fix for this problem, but I do not like it and I do not understand why it solve the problem.
The fix is to remove the flag SG_MITER_ATOMIC from the destination buffer miter.
(and so change the spinlock to irq_save but changing only the spinlock does not solve the problem).

For giving more information I use cryptodev 1.7, and my tool is available at https://github.com/montjoie/cryptotest.

So I seek any advice for understanding why removing SG_MITER_ATOMIC fix the problem.

For giving more informations, without my driver, the same test works, so I thinked that the problem was with my driver.
But I have made two other tools, one what do the same thing with AF_ALG,
and one who is a module who use the crypto API for checking against the cbc(aes-generic) (instead of openssl).
Both tools do not find any error.

Best regards

diff --git a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
index e070c31..07ee88e 100644
--- a/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/sunxi-ss/sun4i-ss-cipher.c
@@ -35,6 +35,7 @@ static int sun4i_ss_opti_poll(struct ablkcipher_request *areq)
        unsigned int todo;
        struct sg_mapping_iter mi, mo;
        unsigned int oi, oo; /* offset for in and out */
+       unsigned long flags;

        if (areq->nbytes == 0)
                return 0;
@@ -49,7 +50,7 @@ static int sun4i_ss_opti_poll(struct ablkcipher_request *areq)
                return -EINVAL;
        }

-       spin_lock_bh(&ss->slock);
+       spin_lock_irqsave(&ss->slock, flags);

        for (i = 0; i < op->keylen; i += 4)
                writel(*(op->key + i / 4), ss->base + SS_KEY0 + i);
@@ -65,7 +66,7 @@ static int sun4i_ss_opti_poll(struct ablkcipher_request *areq)
        sg_miter_start(&mi, areq->src, sg_nents(areq->src),
                       SG_MITER_FROM_SG | SG_MITER_ATOMIC);
        sg_miter_start(&mo, areq->dst, sg_nents(areq->dst),
-                      SG_MITER_TO_SG | SG_MITER_ATOMIC);
+                      SG_MITER_TO_SG);
        sg_miter_next(&mi);
        sg_miter_next(&mo);
        if (!mi.addr || !mo.addr) {
@@ -117,7 +118,7 @@ release_ss:
        sg_miter_stop(&mi);
        sg_miter_stop(&mo);
        writel(0, ss->base + SS_CTL);
-       spin_unlock_bh(&ss->slock);
+       spin_unlock_irqrestore(&ss->slock, flags);
        return err;
 }
