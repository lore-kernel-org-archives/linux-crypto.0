From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] crypto: af_alg - add async support to algif_aead
Date: Wed, 27 Jan 2016 14:41:36 -0800
Message-ID: <56A947A0.7080705@intel.com>
References: <201601280638.gQ8Esy5g%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: kbuild-all@01.org, herbert@gondor.apana.org.au,
	smueller@chronox.de, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:31533 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934365AbcA0Wpa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Jan 2016 17:45:30 -0500
In-Reply-To: <201601280638.gQ8Esy5g%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/27/2016 02:29 PM, kbuild test robot wrote:
> Hi Tadeusz,
> 
> [auto build test ERROR on cryptodev/master]
> [also build test ERROR on v4.5-rc1 next-20160127]
> [if your patch is applied to the wrong git tree, please drop us a note to help improving the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Tadeusz-Struk/crypto-af_alg-add-async-support-to-algif_aead/20160128-061818
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> config: x86_64-randconfig-x011-01270835 (attached as .config)
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
> 
> All error/warnings (new ones prefixed by >>):
> 
>    crypto/algif_aead.c: In function 'aead_async_cb':
>>> crypto/algif_aead.c:386:29: error: implicit declaration of function 'aead_request_cast' [-Werror=implicit-function-declaration]
>      struct aead_request *req = aead_request_cast(_req);
>                                 ^
>>> crypto/algif_aead.c:386:29: warning: initialization makes pointer from integer without a cast [-Wint-conversion]
>    cc1: some warnings being treated as errors
> 
> vim +/aead_request_cast +386 crypto/algif_aead.c
> 
>    380	static void aead_async_cb(struct crypto_async_request *_req, int err)
>    381	{
>    382		struct sock *sk = _req->data;
>    383		struct alg_sock *ask = alg_sk(sk);
>    384		struct aead_ctx *ctx = ask->private;
>    385		struct crypto_aead *tfm = crypto_aead_reqtfm(&ctx->aead_req);
>  > 386		struct aead_request *req = aead_request_cast(_req);
>    387		struct aead_async_req *areq = GET_ASYM_REQ(req, tfm);
>    388		struct scatterlist *sg = areq->tsgl;
>    389		struct aead_async_rsgl *rsgl;
> 

Thanks for the report.
It has dependency on this one https://patchwork.kernel.org/patch/8144731/
which has been sent one minute earlier.
I do not want to squash them into one patch, because they are not really related.
Herbert, how should this be handled?
Thanks,
 
-- 
TS
