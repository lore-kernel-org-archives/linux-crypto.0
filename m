Return-Path: <SRS0=8KRZ=NP=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33162 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728868AbeKDUdO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 4 Nov 2018 15:33:14 -0500
Received: by mail-wm1-f65.google.com with SMTP id f19-v6so4289706wmb.0
        for <linux-crypto@vger.kernel.org>; Sun, 04 Nov 2018 03:18:37 -0800 (PST)
Date: Sun, 4 Nov 2018 12:18:33 +0100
From: LABBE Corentin <clabbe@baylibre.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+6939a606a5305e9e9799@syzkaller.appspotmail.com>
Subject: Re: KASAN: use-after-free Read in skcipher_recvmsg
Message-ID: <20181104111833.GC6963@Red>
References: <000000000000d8053d05799b4b86@google.com>
 <20181103223504.GC808@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181103223504.GC808@sol.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Nov 03, 2018 at 03:35:04PM -0700, Eric Biggers wrote:
> [+clabbe@baylibre.com]
> 
> Hi Corentin, I think this is a bug in the new crypto statistics feature.  In the
> skcipher_decrypt case the code is (but this applies elsewhere too!):
> 
> static inline void crypto_stat_skcipher_decrypt(struct skcipher_request *req,
> 						int ret, struct crypto_alg *alg)
> {
> #ifdef CONFIG_CRYPTO_STATS
> 	if (ret && ret != -EINPROGRESS && ret != -EBUSY) {
> 		atomic_inc(&alg->cipher_err_cnt);
> 	} else {
> 		atomic_inc(&alg->decrypt_cnt);
> 		atomic64_add(req->cryptlen, &alg->decrypt_tlen);
> 	}
> #endif
> }
> 
> static inline int crypto_skcipher_decrypt(struct skcipher_request *req)
> {
> 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> 	int ret;
> 
> 	if (crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
> 		ret = -ENOKEY;
> 	else
> 		ret = tfm->decrypt(req);
> 	crypto_stat_skcipher_decrypt(req, ret, tfm->base.__crt_alg);
> 	return ret;
> }
> 
> The bug is the request may be issued asynchronously (as indicated by EINPROGRESS
> or EBUSY) being returned, and the stats are updated afterwards.  But by that
> time, the request's completion function may have already run, and the request
> structure may have already been freed.
> 
> In theory, I think the algorithm could have even been unregistered as well.
> Therefore, it's only safe to update the stats either *before* calling
> tfm->decrypt(), or afterwards if the error code was not EINPROGRESS or EBUSY.

Hello

I can store "len" and alg for later use, this will fix a part of the problem.

For the fact that algorithm could be unregistred, I think it cannot happen since at least the tfm running this crypto_skcipher_decrypt/othersamefunction still exists and that it is(should be) impossible to unregister an alg with still existing tfm which uses it.
But that needs to be verified.

Regards
