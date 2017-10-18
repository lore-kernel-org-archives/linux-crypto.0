From: Romain Izard <romain.izard.pro@gmail.com>
Subject: Kernel panic when using ccm(aes) with the Atmel AES HW accelerator
Date: Wed, 18 Oct 2017 15:32:57 +0200
Message-ID: <CAGkQfmP6Kq4DEBbGU7AW71PjbUJ2acdJF5PVDm6VqZkUaaoEzA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Cyrille Pitchen <cyrille.pitchen@atmel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:43445 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753404AbdJRNdS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Oct 2017 09:33:18 -0400
Received: by mail-qk0-f196.google.com with SMTP id w134so6216735qkb.0
        for <linux-crypto@vger.kernel.org>; Wed, 18 Oct 2017 06:33:18 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

For some time I have been trying to fix an issue with the Atmel AES hardware
accelerator available on SAMA5D2 chips. The ciphertext stealing mode did not
work, and this led to problems when using the cts(cbc(aes)) crypto engine
for fscrypt with Linux 4.13.

(see also
I have updated the driver in atmel-aes.c to fix this issue, taking care of
the corner case where the source and destination are the same in decryption
mode by saving the last 16 bytes of ciphertext in memory, and restoring them
into the 'info' member of the encryption request. This made it possible to
pass the cts(cbc(aes)) test in tcrypt.ko, which was failing before.

Here are my modifications:

8<----------------------------------------------------------------------
diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 29e20c37f3a6..f3eabe1f1490 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -80,6 +80,7 @@
 #define AES_FLAGS_BUSY         BIT(3)
 #define AES_FLAGS_DUMP_REG     BIT(4)
 #define AES_FLAGS_OWN_SHA      BIT(5)
+#define AES_FLAGS_CIPHERTAIL   BIT(6)

 #define AES_FLAGS_PERSISTENT   (AES_FLAGS_INIT | AES_FLAGS_BUSY)

@@ -156,6 +157,7 @@ struct atmel_aes_authenc_ctx {

 struct atmel_aes_reqctx {
        unsigned long           mode;
+       u32                     ciphertail[AES_BLOCK_SIZE / sizeof(u32)];
 };

 #ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
@@ -496,6 +498,11 @@ static void atmel_aes_authenc_complete(struct
atmel_aes_dev *dd, int err);

 static inline int atmel_aes_complete(struct atmel_aes_dev *dd, int err)
 {
+       struct ablkcipher_request *req = ablkcipher_request_cast(dd->areq);
+       struct crypto_ablkcipher *ablkcipher = crypto_ablkcipher_reqtfm(req);
+       struct atmel_aes_reqctx *rctx = ablkcipher_request_ctx(req);
+       int ivsize = crypto_ablkcipher_ivsize(ablkcipher);
+
 #ifdef CONFIG_CRYPTO_DEV_ATMEL_AUTHENC
        atmel_aes_authenc_complete(dd, err);
 #endif
@@ -503,6 +510,17 @@ static inline int atmel_aes_complete(struct
atmel_aes_dev *dd, int err)
        clk_disable(dd->iclk);
        dd->flags &= ~AES_FLAGS_BUSY;

+       if (rctx->mode & AES_FLAGS_CIPHERTAIL) {
+               if (rctx->mode & AES_FLAGS_ENCRYPT) {
+                       scatterwalk_map_and_copy(req->info, req->dst,
+                                                req->nbytes - ivsize,
+                                                ivsize, 0);
+               } else {
+                       memcpy(req->info, rctx->ciphertail, ivsize);
+                       memset(rctx->ciphertail, 0, ivsize);
+               }
+       }
+
        if (dd->is_async)
                dd->areq->complete(dd->areq, err);

@@ -1071,11 +1089,13 @@ static int atmel_aes_ctr_start(struct atmel_aes_dev *dd)

 static int atmel_aes_crypt(struct ablkcipher_request *req, unsigned long mode)
 {
+       struct crypto_ablkcipher *ablkcipher;
        struct atmel_aes_base_ctx *ctx;
        struct atmel_aes_reqctx *rctx;
        struct atmel_aes_dev *dd;

-       ctx = crypto_ablkcipher_ctx(crypto_ablkcipher_reqtfm(req));
+       ablkcipher = crypto_ablkcipher_reqtfm(req);
+       ctx = crypto_ablkcipher_ctx(ablkcipher);
        switch (mode & AES_FLAGS_OPMODE_MASK) {
        case AES_FLAGS_CFB8:
                ctx->block_size = CFB8_BLOCK_SIZE;
@@ -1103,7 +1123,15 @@ static int atmel_aes_crypt(struct
ablkcipher_request *req, unsigned long mode)
                return -ENODEV;

        rctx = ablkcipher_request_ctx(req);
-       rctx->mode = mode;
+
+       if (!(mode & AES_FLAGS_ENCRYPT)) {
+               int ivsize = crypto_ablkcipher_ivsize(ablkcipher);
+
+               scatterwalk_map_and_copy(rctx->ciphertail, req->src,
+                               (req->nbytes - ivsize), ivsize, 0);
+       }
+       rctx->mode = mode | AES_FLAGS_CIPHERTAIL;
+

        return atmel_aes_handle_queue(dd, &req->base);
 }

8<----------------------------------------------------------------------


But as I wanted to test my code more thoroughly, I also ran the kcapi test
suite on my test platform. Some tests cases were now passing, some others
did not pass both before and after my fix, but my fix also led to a
systematic oops when running the ccm(aes) test case. Here is an example of
the kernel logs observed:

# kcapi -x 2 -c 'ccm(aes)' -i 0100000003020100a0a1a2a3a4a50000 -k c0c1c2c3c4c5c6
c7c8c9cacbcccdcecf -q 588c979a61c663d2f066d0c2c0f989806d5f6b61dac38417e8d12cfdf9
26e0 -t 0001020304050607
[   92.340000] atmel_aes f002c000.aes: saving ciphertext tail (16b)
[   92.350000] atmel_aes f002c000.aes: copy ciphertext tail to IV
EBADMSG[   92.360000] Unable to handle kernel NULL pointer dereference
at virtual address 00000020
[   92.370000] pgd = deebc000
[   92.370000] [00000020] *pgd=3ec40831, *pte=00000000, *ppte=00000000
[   92.370000] Internal error: Oops: 17 [#1] ARM
[   92.370000] Modules linked in:
[   92.370000] CPU: 0 PID: 839 Comm: kcapi Not tainted 4.13.4+ #38
[   92.370000] Hardware name: Atmel SAMA5
[   92.370000] task: dec0f580 task.stack: df730000
[   92.370000] PC is at aead_sock_destruct+0x28/0x7c
[   92.370000] LR is at __sk_destruct+0x30/0x168
[   92.370000] pc : [<c0388e6c>]    lr : [<c063df5c>]    psr: 600b0013
[   92.370000] sp : df731e78  ip : df731e98  fp : df731e94
[   92.370000] r10: 00000008  r9 : df241220  r8 : 00000000
[   92.370000] r7 : df427710  r6 : df221908  r5 : df6a9800  r4 : dee6e400
[   92.370000] r3 : 00000000  r2 : 00000000  r1 : 00000026  r0 : dee6e400
[   92.370000] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[   92.370000] Control: 10c53c7d  Table: 3eebc059  DAC: 00000051
[   92.370000] Process kcapi (pid: 839, stack limit = 0xdf730208)
[   92.370000] Stack: (0xdf731e78 to 0xdf732000)
[   92.370000] 1e60:
    dee6e5c0 dee6e400
[   92.370000] 1e80: df221908 df427710 df731eac df731e98 c063df5c
c0388e50 dee6e400 00000000
[   92.370000] 1ea0: df731ebc df731eb0 c063fd5c c063df38 df731ed4
df731ec0 c063fdcc c063fd40
[   92.370000] 1ec0: df241200 00000000 df731ee4 df731ed8 c063fe78
c063fd7c df731ef4 df731ee8
[   92.370000] 1ee0: c0385a5c c063fe48 df731f0c df731ef8 c063a1fc
c0385a18 dee7fb40 df241220
[   92.370000] 1f00: df731f1c df731f10 c063a294 c063a1d8 df731f5c
df731f20 c01f10d8 c063a284
[   92.370000] 1f20: 00000000 00000000 dee7fb40 dee7fb48 df731f54
dec0f8bc dec0f580 c0d8a22c
[   92.370000] 1f40: 00000000 c0108ea4 df730000 00000000 df731f6c
df731f60 c01f1284 c01f1050
[   92.370000] 1f60: df731f8c df731f70 c0134cec c01f1278 df730000
c0108ea4 df731fb0 00000006
[   92.370000] 1f80: df731fac df731f90 c010c378 c0134c78 0004a070
0004a130 00000000 00000006
[   92.370000] 1fa0: 00000000 df731fb0 c0108d34 c010c2f0 00000000
00000000 00000001 00000000
[   92.370000] 1fc0: 0004a070 0004a130 00000000 00000006 00000027
ffffffb6 00000002 0004a130
[   92.370000] 1fe0: 00000000 bef01844 b6f43a1c b6ec5040 400b0010
00000006 00000000 00000000
[   92.370000] [<c0388e6c>] (aead_sock_destruct) from [<c063df5c>]
(__sk_destruct+0x30/0x168)
[   92.370000] [<c063df5c>] (__sk_destruct) from [<c063fd5c>]
(sk_destruct+0x28/0x3c)
[   92.370000] [<c063fd5c>] (sk_destruct) from [<c063fdcc>]
(__sk_free+0x5c/0xcc)
[   92.370000] [<c063fdcc>] (__sk_free) from [<c063fe78>] (sk_free+0x3c/0x40)
[   92.370000] [<c063fe78>] (sk_free) from [<c0385a5c>]
(af_alg_release+0x50/0x58)
[   92.370000] [<c0385a5c>] (af_alg_release) from [<c063a1fc>]
(sock_release+0x30/0xac)
[   92.370000] [<c063a1fc>] (sock_release) from [<c063a294>]
(sock_close+0x1c/0x24)
[   92.370000] [<c063a294>] (sock_close) from [<c01f10d8>] (__fput+0x94/0x1d8)
[   92.370000] [<c01f10d8>] (__fput) from [<c01f1284>] (____fput+0x18/0x1c)
[   92.370000] [<c01f1284>] (____fput) from [<c0134cec>]
(task_work_run+0x80/0xa4)
[   92.370000] [<c0134cec>] (task_work_run) from [<c010c378>]
(do_work_pending+0x94/0xbc)
[   92.370000] [<c010c378>] (do_work_pending) from [<c0108d34>]
(slow_work_pending+0xc/0x20)
[   92.370000] Code: e5902064 e1a04000 e59532d0 e3520000 (e5933020)
[   92.660000] ---[ end trace cce00d600b8ad985 ]---

Segmentation fault


As the changes in the hardware driver were related to the IV buffer, the
symptoms were coherent with an out-of-bounds memory access when updating the
IV. I applied the following patch, and this was enough to avoid the panic:

8<----------------------------------------------------------------------

diff --git a/crypto/ccm.c b/crypto/ccm.c
index 1ce37ae0ce56..e7c2121a3ab2 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -47,6 +47,7 @@ struct crypto_ccm_req_priv_ctx {
        u8 odata[16];
        u8 idata[16];
        u8 auth_tag[16];
+       u8 iv[16];
        u32 flags;
        struct scatterlist src[3];
        struct scatterlist dst[3];
@@ -248,32 +249,22 @@ static void crypto_ccm_encrypt_done(struct
crypto_async_request *areq, int err)
        aead_request_complete(req, err);
 }

-static inline int crypto_ccm_check_iv(const u8 *iv)
-{
-       /* 2 <= L <= 8, so 1 <= L' <= 7. */
-       if (1 > iv[0] || iv[0] > 7)
-               return -EINVAL;
-
-       return 0;
-}
-
-static int crypto_ccm_init_crypt(struct aead_request *req, u8 *tag)
+static int crypto_ccm_init_crypt(struct aead_request *req, u8 *tag, u8* iv)
 {
        struct crypto_ccm_req_priv_ctx *pctx = crypto_ccm_reqctx(req);
        struct scatterlist *sg;
-       u8 *iv = req->iv;
-       int err;
+       u8 L = req->iv[0] + 1;

-       err = crypto_ccm_check_iv(iv);
-       if (err)
-               return err;
-
-       pctx->flags = aead_request_flags(req);
+       if (2 > L || L > 8)
+               return -EINVAL;

         /* Note: rfc 3610 and NIST 800-38C require counter of
         * zero to encrypt auth tag.
         */
-       memset(iv + 15 - iv[0], 0, iv[0] + 1);
+       memcpy(iv, req->iv, 16 - L);
+       memset(iv + 16 - L, 0, L);
+
+       pctx->flags = aead_request_flags(req);

        sg_init_table(pctx->src, 3);
        sg_set_buf(pctx->src, tag, 16);
@@ -301,10 +292,10 @@ static int crypto_ccm_encrypt(struct aead_request *req)
        struct scatterlist *dst;
        unsigned int cryptlen = req->cryptlen;
        u8 *odata = pctx->odata;
-       u8 *iv = req->iv;
+       u8 *iv = pctx->iv;
        int err;

-       err = crypto_ccm_init_crypt(req, odata);
+       err = crypto_ccm_init_crypt(req, odata, iv);
        if (err)
                return err;

@@ -363,12 +354,12 @@ static int crypto_ccm_decrypt(struct aead_request *req)
        unsigned int cryptlen = req->cryptlen;
        u8 *authtag = pctx->auth_tag;
        u8 *odata = pctx->odata;
-       u8 *iv = req->iv;
+       u8 *iv = pctx->iv;
        int err;

        cryptlen -= authsize;

-       err = crypto_ccm_init_crypt(req, authtag);
+       err = crypto_ccm_init_crypt(req, authtag, iv);
        if (err)
                return err;

8<----------------------------------------------------------------------

My problem is that I do not understand why it works. It ensures that in both
encryption and decryption cases, the IV buffer is available and 16 bytes
wide. But normally the IV buffer provided by the crypto request is already
16 bytes wide, as the algorithm is registered with ivsize=16.

As I am not very familiar with the crypto subsystem, I fear that I missed
something. I would gladly appreciate the feedback of more experienced
developers regarding this issue.

Best regards,
-- 
Romain Izard
