From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: [PATCH] crypto: s5p-sss.c: Fix kernel Oops in AES-ECB mode
Date: Mon, 05 Feb 2018 18:40:20 +0100
Message-ID: <224788c7-426b-d3a9-d0a6-412d2b8afb75@partner.samsung.com>
References: <CGME20180205174022eucas1p101e8339284c1f0ac8f40f70c24de1c1f@eucas1p1.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Anand Moon <linux.amoon@gmail.com>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
Content-language: en-US
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


In AES-ECB mode crypt is done with key only, so any use of IV
can cause kernel Oops, as reported by Anand Moon.
Fixed it by using IV only in AES-CBC and AES-CTR.

Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
Reported-by: Anand Moon <linux.amoon@gmail.com>
---
Tested on Odroid XU4/HC1, kernel 4.15 with following command:

fallocate -l 128MiB /tmp/test.bin
dd if=/dev/urandom of=/tmp/testkey.key bs=128 count=1
sync
cryptsetup luksFormat --debug -q -d /tmp/testkey.key \
  --cipher aes-cbc-essiv:sha256 -h sha256 -s 128 /tmp/test.bin

The original report by Anand Moon:
https://www.spinics.net/lists/linux-crypto/msg31180.html

Oops reproduced with cryptsetup 2.0.0, kernel 4.15,
in .config in crypto API ECB support was turned off, and s5p-sss AES driver on.

cryptsetup is using aes-ecb and has req->info in aes_ctx set to 0x10,
which caused Oops:

[ 2078.683779] Internal error: Oops: 17 [#1] PREEMPT SMP ARM
[ 2078.689148] Modules linked in: algif_skcipher af_alg sd_mod sg
evdev uas usb_storage scsi_mod gpio_keys fbtft(C) spidev spi_s3c64xx
ipv6
[ 2078.701377] CPU: 1 PID: 15 Comm: ksoftirqd/1 Tainted: G         C
    4.15.0-rc9-xu4krck #1
[ 2078.709861] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[ 2078.715932] PC is at memcpy+0x80/0x330
[ 2078.719652] LR is at s5p_tasklet_cb+0x19c/0x328

 drivers/crypto/s5p-sss.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 142c6020cec7..5c0496d1ed41 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -1926,15 +1926,21 @@ static void s5p_aes_crypt_start(struct s5p_aes_dev *dev, unsigned long mode)
 	uint32_t aes_control;
 	unsigned long flags;
 	int err;
+	u8 *iv;
 
 	aes_control = SSS_AES_KEY_CHANGE_MODE;
 	if (mode & FLAGS_AES_DECRYPT)
 		aes_control |= SSS_AES_MODE_DECRYPT;
 
-	if ((mode & FLAGS_AES_MODE_MASK) == FLAGS_AES_CBC)
+	if ((mode & FLAGS_AES_MODE_MASK) == FLAGS_AES_CBC) {
 		aes_control |= SSS_AES_CHAIN_MODE_CBC;
-	else if ((mode & FLAGS_AES_MODE_MASK) == FLAGS_AES_CTR)
+		iv = req->info;
+	} else if ((mode & FLAGS_AES_MODE_MASK) == FLAGS_AES_CTR) {
 		aes_control |= SSS_AES_CHAIN_MODE_CTR;
+		iv = req->info;
+	} else {
+		iv = NULL; /* AES_ECB */
+	}
 
 	if (dev->ctx->keylen == AES_KEYSIZE_192)
 		aes_control |= SSS_AES_KEY_SIZE_192;
@@ -1965,7 +1971,7 @@ static void s5p_aes_crypt_start(struct s5p_aes_dev *dev, unsigned long mode)
 		goto outdata_error;
 
 	SSS_AES_WRITE(dev, AES_CONTROL, aes_control);
-	s5p_set_aes(dev, dev->ctx->aes_key, req->info, dev->ctx->keylen);
+	s5p_set_aes(dev, dev->ctx->aes_key, iv, dev->ctx->keylen);
 
 	s5p_set_dma_indata(dev,  dev->sg_src);
 	s5p_set_dma_outdata(dev, dev->sg_dst);
-- 
2.16.0
