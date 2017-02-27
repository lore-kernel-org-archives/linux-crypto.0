From: Gary R Hook <ghook@amd.com>
Subject: Re: [PATCH] crypto: ccp - Reference the correct structure member
Date: Mon, 27 Feb 2017 11:40:56 -0600
Message-ID: <3692deda-892d-94b5-5101-22e371b14f34@amd.com>
References: <20170227171045.28039.10586.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
To: Gary R Hook <gary.hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam01on0049.outbound.protection.outlook.com ([104.47.32.49]:46352
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751344AbdB0STQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Feb 2017 13:19:16 -0500
In-Reply-To: <20170227171045.28039.10586.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 02/27/2017 11:10 AM, Gary R Hook wrote:
> Fix a build break by referencing the proper structure member
> name when invoking functions. Remove unneeded akcipher
> structure.

Please ignore. I was mistakenly under the impression that the referenced
patchset had been accepted.

>
> Signed-off-by: Gary R Hook <gary.hook@amd.com>
> ---
>  drivers/crypto/ccp/Makefile          |    1 -
>  drivers/crypto/ccp/ccp-crypto-main.c |    8 --------
>  drivers/crypto/ccp/ccp-ops.c         |   10 +++++-----
>  3 files changed, 5 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
> index 563594a..60919a3 100644
> --- a/drivers/crypto/ccp/Makefile
> +++ b/drivers/crypto/ccp/Makefile
> @@ -12,7 +12,6 @@ ccp-crypto-objs := ccp-crypto-main.o \
>                     ccp-crypto-aes.o \
>                     ccp-crypto-aes-cmac.o \
>                     ccp-crypto-aes-xts.o \
> -                  ccp-crypto-rsa.o \
>                     ccp-crypto-aes-galois.o \
>                     ccp-crypto-des3.o \
>                     ccp-crypto-sha.o
> diff --git a/drivers/crypto/ccp/ccp-crypto-main.c
> b/drivers/crypto/ccp/ccp-crypto-main.c
> index 228210c..8dccbdd 100644
> --- a/drivers/crypto/ccp/ccp-crypto-main.c
> +++ b/drivers/crypto/ccp/ccp-crypto-main.c
> @@ -40,7 +40,6 @@
>  /* List heads for the supported algorithms */
>  static LIST_HEAD(hash_algs);
>  static LIST_HEAD(cipher_algs);
> -static LIST_HEAD(akcipher_algs);
>  static LIST_HEAD(aead_algs);
>
>  /* For any tfm, requests for that tfm must be returned on the order
> @@ -366,7 +365,6 @@ static void ccp_unregister_algs(void)
>  {
>          struct ccp_crypto_ahash_alg *ahash_alg, *ahash_tmp;
>          struct ccp_crypto_ablkcipher_alg *ablk_alg, *ablk_tmp;
> -       struct ccp_crypto_akcipher_alg *ak_alg, *ak_tmp;
>          struct ccp_crypto_aead *aead_alg, *aead_tmp;
>
>          list_for_each_entry_safe(ahash_alg, ahash_tmp, &hash_algs, entry) {
> @@ -381,12 +379,6 @@ static void ccp_unregister_algs(void)
>                  kfree(ablk_alg);
>          }
>
> -       list_for_each_entry_safe(ak_alg, ak_tmp, &akcipher_algs, entry) {
> -               crypto_unregister_akcipher(&ak_alg->alg);
> -               list_del(&ak_alg->entry);
> -               kfree(ak_alg);
> -       }
> -
>          list_for_each_entry_safe(aead_alg, aead_tmp, &aead_algs, entry) {
>                  crypto_unregister_aead(&aead_alg->alg);
>                  list_del(&aead_alg->entry);
> diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
> index 6e2aa2c..7ae7f14 100644
> --- a/drivers/crypto/ccp/ccp-ops.c
> +++ b/drivers/crypto/ccp/ccp-ops.c
> @@ -709,7 +709,7 @@ static int ccp_run_aes_gcm_cmd(struct ccp_cmd_queue
> *cmd_q,
>                  while (aad.sg_wa.bytes_left) {
>                          ccp_prepare_data(&aad, NULL, &op,
> AES_BLOCK_SIZE, true);
>
> -                       ret = cmd_q->ccp->vdata->ccp_act->aes(&op);
> +                       ret = cmd_q->ccp->vdata->perform->aes(&op);
>                          if (ret) {
>                                  cmd->engine_error = cmd_q->cmd_error;
>                                  goto e_aad;
> @@ -758,7 +758,7 @@ static int ccp_run_aes_gcm_cmd(struct ccp_cmd_queue
> *cmd_q,
>                                  }
>                          }
>
> -                       ret = cmd_q->ccp->vdata->ccp_act->aes(&op);
> +                       ret = cmd_q->ccp->vdata->perform->aes(&op);
>                          if (ret) {
>                                  cmd->engine_error = cmd_q->cmd_error;
>                                  goto e_dst;
> @@ -807,7 +807,7 @@ static int ccp_run_aes_gcm_cmd(struct ccp_cmd_queue
> *cmd_q,
>          op.dst.u.dma.length = AES_BLOCK_SIZE;
>          op.eom = 1;
>          op.u.aes.size = 0;
> -       ret = cmd_q->ccp->vdata->ccp_act->aes(&op);
> +       ret = cmd_q->ccp->vdata->perform->aes(&op);
>          if (ret)
>                  goto e_dst;
>
> @@ -1197,7 +1197,7 @@ static int ccp_run_des3_cmd(struct ccp_cmd_queue
> *cmd_q, struct ccp_cmd *cmd)
>          int ret;
>
>          /* Error checks */
> -       if (!cmd_q->ccp->vdata->ccp_act->des3)
> +       if (!cmd_q->ccp->vdata->perform->des3)
>                  return -EINVAL;
>
>          if (des3->key_len != DES3_EDE_KEY_SIZE)
> @@ -1335,7 +1335,7 @@ static int ccp_run_des3_cmd(struct ccp_cmd_queue
> *cmd_q, struct ccp_cmd *cmd)
>                          op.soc = 0;
>                  }
>
> -               ret = cmd_q->ccp->vdata->ccp_act->des3(&op);
> +               ret = cmd_q->ccp->vdata->perform->des3(&op);
>                  if (ret) {
>                          cmd->engine_error = cmd_q->cmd_error;
>                          goto e_dst;
>

-- 
This is my day job. Follow me at:
IG/Twitter/Facebook: @grhookphoto
IG/Twitter/Facebook: @grhphotographer
