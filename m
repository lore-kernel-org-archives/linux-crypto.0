From: Fengguang Wu <lkp@intel.com>
Subject: Re: [kbuild-all] [PATCH] crypto: af_alg - add async support to
 algif_aead
Date: Thu, 28 Jan 2016 16:48:57 +0800
Message-ID: <20160128084857.GA20993@wfg-t540p.sh.intel.com>
References: <201601280638.gQ8Esy5g%fengguang.wu@intel.com>
 <56A947A0.7080705@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: smueller@chronox.de, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, kbuild-all@01.org,
	herbert@gondor.apana.org.au
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:3845 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965185AbcA1ItE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Jan 2016 03:49:04 -0500
Content-Disposition: inline
In-Reply-To: <56A947A0.7080705@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 27, 2016 at 02:41:36PM -0800, Tadeusz Struk wrote:
> On 01/27/2016 02:29 PM, kbuild test robot wrote:
> > Hi Tadeusz,
> > 
> > [auto build test ERROR on cryptodev/master]
> > [also build test ERROR on v4.5-rc1 next-20160127]
> > [if your patch is applied to the wrong git tree, please drop us a note to help improving the system]
> > 
> > url:    https://github.com/0day-ci/linux/commits/Tadeusz-Struk/crypto-af_alg-add-async-support-to-algif_aead/20160128-061818
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> > config: x86_64-randconfig-x011-01270835 (attached as .config)
> > reproduce:
> >         # save the attached .config to linux build tree
> >         make ARCH=x86_64 
> > 
> > All error/warnings (new ones prefixed by >>):
> > 
> >    crypto/algif_aead.c: In function 'aead_async_cb':
> >>> crypto/algif_aead.c:386:29: error: implicit declaration of function 'aead_request_cast' [-Werror=implicit-function-declaration]
> >      struct aead_request *req = aead_request_cast(_req);
> >                                 ^
> >>> crypto/algif_aead.c:386:29: warning: initialization makes pointer from integer without a cast [-Wint-conversion]
> >    cc1: some warnings being treated as errors
> > 
> > vim +/aead_request_cast +386 crypto/algif_aead.c
> > 
> >    380	static void aead_async_cb(struct crypto_async_request *_req, int err)
> >    381	{
> >    382		struct sock *sk = _req->data;
> >    383		struct alg_sock *ask = alg_sk(sk);
> >    384		struct aead_ctx *ctx = ask->private;
> >    385		struct crypto_aead *tfm = crypto_aead_reqtfm(&ctx->aead_req);
> >  > 386		struct aead_request *req = aead_request_cast(_req);
> >    387		struct aead_async_req *areq = GET_ASYM_REQ(req, tfm);
> >    388		struct scatterlist *sg = areq->tsgl;
> >    389		struct aead_async_rsgl *rsgl;
> > 
> 
> Thanks for the report.
> It has dependency on this one https://patchwork.kernel.org/patch/8144731/
> which has been sent one minute earlier.
> I do not want to squash them into one patch, because they are not really related.
> Herbert, how should this be handled?

Sorry for the noise -- you may either ignore the warning or send
dependent patches in one same patch series in future.

Thanks,
Fengguang
