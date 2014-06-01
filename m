From: Marek Vasut <marex@denx.de>
Subject: Re: Crash when using ahash_request_ctx
Date: Sun, 1 Jun 2014 18:52:24 +0200
Message-ID: <201406011852.24151.marex@denx.de>
References: <5385B3E5.3090108@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Corentin LABBE <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:34858 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbaFARLc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 1 Jun 2014 13:11:32 -0400
In-Reply-To: <5385B3E5.3090108@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wednesday, May 28, 2014 at 12:01:09 PM, Corentin LABBE wrote:
> Hello
> 
> I have a problem when using a simple md5 tfm.
> When I use the data that ahash_request_ctx() give me, it will cause random
> crash when removing the module later. I do not understand it, because
> .cra_ctxsize seems to be rightly used.
> 
> The very simplified POC code will follow, it register a fake md5
> implementation. If I remove the op->mode = 0, I can modprobe/rmmod for
> ever without problem. With it, rmmod will segfault in 2 or 3 tries, so it
> is this write that is the source of the problem.
> 
> I have try to debug, but I cannot find where __ctx (the pointer returned by
> ahash_request_ctx) is allocated.
> 
> Does I am right when saying: ahash_request_ctx() return the pointer to a
> structure of size equal to cra_ctxsize allocated for each request ?

crypto_tfm_ctx() returns per-transformation instance (tfm) private data
ahash_request_ctx() returns per-request private data

You need to configure the request context size via crypto_ahash_set_reqsize() in 
the implementations' .cra_init() callback .

[...]

static int my_cra_init(struct crypto_tfm *tfm)
{
 crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
                          sizeof(struct my_per_request_private_data));
 return 0;
}

> static struct ahash_alg sunxi_md5_alg = {
> 	.init = fake_init,
> 	.update = fake_update,
> 	.final = fake_final,
> 	.finup = fake_finup,
> 	.digest = fake_digest,
> 	.halg = {
> 		.digestsize = MD5_DIGEST_SIZE,
> 		.base = {
> 			.cra_name = "md5",
> 			.cra_driver_name = "md5-sunxi-ss",
> 			.cra_priority = 300,
> 			.cra_alignmask = 3,
> 			.cra_flags = CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
> 			.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
> 			.cra_ctxsize = sizeof(struct sunxi_req_ctx),
> 			.cra_module = THIS_MODULE,
> 			.cra_type = &crypto_ahash_type

 .cra_init = my_cra_init,

> 		}
> 	}
> };
> 
> static int sunxi_ss_md5_init(void)
> {
> 	int err = 0;
> 	err = crypto_register_ahash(&sunxi_md5_alg);
> 	if (err)
> 		pr_err("crypto_register_alg error for MD5\n");
> 	else
> 		pr_info("Registred MD5\n");
> 	return err;
> }
> 
> static void __exit sunxi_ss_md5_exit(void)
> {
> 	crypto_unregister_ahash(&sunxi_md5_alg);
> }
> 
> module_init(sunxi_ss_md5_init);
> module_exit(sunxi_ss_md5_exit);

module_platform_driver() here please, fix it up so this is a platform driver.
