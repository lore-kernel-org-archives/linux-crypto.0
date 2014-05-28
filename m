From: Corentin LABBE <clabbe.montjoie@gmail.com>
Subject: Crash when using ahash_request_ctx
Date: Wed, 28 May 2014 12:01:09 +0200
Message-ID: <5385B3E5.3090108@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:34684 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbaE1KBP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 28 May 2014 06:01:15 -0400
Received: by mail-la0-f45.google.com with SMTP id gl10so7281721lab.18
        for <linux-crypto@vger.kernel.org>; Wed, 28 May 2014 03:01:13 -0700 (PDT)
Received: from ?IPv6:2a01:c9c0:a1:15:216:17ff:fe3b:ec41? ([2a01:c9c0:a1:15:216:17ff:fe3b:ec41])
        by mx.google.com with ESMTPSA id aa1sm17884633lbd.12.2014.05.28.03.01.11
        for <linux-crypto@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Wed, 28 May 2014 03:01:12 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello

I have a problem when using a simple md5 tfm.
When I use the data that ahash_request_ctx() give me, it will cause random crash when removing the module later.
I do not understand it, because .cra_ctxsize seems to be rightly used.

The very simplified POC code will follow, it register a fake md5 implementation.
If I remove the op->mode = 0, I can modprobe/rmmod for ever without problem.
With it, rmmod will segfault in 2 or 3 tries, so it is this write that is the source of the problem.

I have try to debug, but I cannot find where __ctx (the pointer returned by ahash_request_ctx) is allocated.

Does I am right when saying: ahash_request_ctx() return the pointer to a structure of size equal to cra_ctxsize allocated for each request ?

Thanks in advance

Best regards


#include <linux/clk.h>
#include <linux/crypto.h>
#include <linux/io.h>
#include <linux/module.h>
#include <linux/of.h>
#include <linux/platform_device.h>
#include <crypto/scatterwalk.h>
#include <linux/scatterlist.h>
#include <linux/interrupt.h>
#include <linux/delay.h>
#include <crypto/md5.h>
#include <crypto/sha.h>
#include <crypto/hash.h>
#include <crypto/internal/hash.h>

struct sunxi_req_ctx {
	u8 key[32 * 8];
	u32 keylen;
	u32 mode;
	u64 byte_count;
	u32 waitbuf;
	unsigned int nbwait;
};

int fake_init(struct ahash_request *areq) {
	struct sunxi_req_ctx *op = ahash_request_ctx(areq);
	/* this is the location of action that cause the crash */
	op->mode = 0;
	op->nbwait = 0;
	return 0;
}
int fake_update(struct ahash_request *areq) {
	return 0;
}
int fake_final(struct ahash_request *areq) {
	return 0;
}
int fake_finup(struct ahash_request *areq) {
	fake_init(areq);
	return 0;
}
int fake_digest(struct ahash_request *areq) {
	fake_init(areq);
	return 0;
}

static struct ahash_alg sunxi_md5_alg = {
	.init = fake_init,
	.update = fake_update,
	.final = fake_final,
	.finup = fake_finup,
	.digest = fake_digest,
	.halg = {
		.digestsize = MD5_DIGEST_SIZE,
		.base = {
			.cra_name = "md5",
			.cra_driver_name = "md5-sunxi-ss",
			.cra_priority = 300,
			.cra_alignmask = 3,
			.cra_flags = CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
			.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
			.cra_ctxsize = sizeof(struct sunxi_req_ctx),
			.cra_module = THIS_MODULE,
			.cra_type = &crypto_ahash_type
		}
	}
};

static int sunxi_ss_md5_init(void)
{
	int err = 0;
	err = crypto_register_ahash(&sunxi_md5_alg);
	if (err)
		pr_err("crypto_register_alg error for MD5\n");
	else
		pr_info("Registred MD5\n");
	return err;
}

static void __exit sunxi_ss_md5_exit(void)
{
	crypto_unregister_ahash(&sunxi_md5_alg);
}

module_init(sunxi_ss_md5_init);
module_exit(sunxi_ss_md5_exit);

MODULE_DESCRIPTION("test MD5 module");
MODULE_LICENSE("GPL");
MODULE_AUTHOR("Corentin LABBE <clabbe.montjoie@gmail.com>");
