Received: from os-cillation.de (mx.os-c.de [213.165.83.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561C4471250;
	Tue, 21 Jul 2026 19:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.165.83.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660902; cv=none; b=DP74FQQ+w1kUTQjgfFuy2PuMxmloxkqRF1r9Z5a3wuM0N90+JqpT+c72luVBV69WsV5kxjPU1AtGh8n2eAkVT/stmUT+jSjdrkEi5XaZZnVMdDl9aZWRsd5rjyWjYBv/KSJgbxHjgJVw7AlEQnEMK7MOuwuMpnd150u0ZiD0M4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660902; c=relaxed/simple;
	bh=nggXzHJGGwPfJU60aXZiAJsN8HzsZBsOPEzvy7eLLqE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AJR86/BtTPN7hY6cg1CL2gy3GDvVBwKBS7zBKAa7aira4nidvIMGRI93tHdGlSHfdEhrqmlQY5WkrHZUMu5zrcBOiJuw5QuEu0aNjvdncH4dhkI+vCdBc/P1iXS5+PbM6nJ2RC5s000unYNMrRNFC+r1kE2Hb92/5JTzrPyzaDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=os-cillation.de; spf=pass smtp.mailfrom=os-cillation.de; dkim=pass (2048-bit key) header.d=os-cillation.de header.i=@os-cillation.de header.b=VgQfBAUh; arc=none smtp.client-ip=213.165.83.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=os-cillation.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os-cillation.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=os-cillation.de header.i=@os-cillation.de header.b="VgQfBAUh"
Received: from core2024.osc.gmbh (ip-094-079-177-042.um30.pools.vodafone-ip.de [94.79.177.42])
	by os-cillation.de (Postfix) with ESMTPSA id 7CEA7C06A3;
	Tue, 21 Jul 2026 20:59:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=os-cillation.de;
	s=202409; t=1784660362;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=n+NvtWjXqYSBNs91MMg0FWobhS1iqXzjeR5NZr7FyGQ=;
	b=VgQfBAUhVHEDqrn/VV0aVu6VTkFd+nWIzIMNOkfzBD2POnoA72RbGon4D3wJ178KlIHOqK
	UoVkTnENXkcZUt5OGd9ofbu7Ss6I0JfKh0rP6EpOdvqtnnlr8tnW/1n6A+y0WT/ru9/BVg
	1vqeRE85fWS0TfXOzRoo6KZ+Jqa8O6Cjk9wvn73o1baIhUM7iEPt09dOpPU6meZsivY2hb
	Ki3yJ/GoQ5cM9GtAqwkxEmjuWAzSntkhPeFbg0jwWh2P7VUpJwXoOrjMMV7NmN+rd439n1
	eWe1ELfqWhXY9YN+USKsecLdBeoXClWqG/9Qg3zAE0FZ3Z+h/xRUTMb97G3zEA==
Authentication-Results: os-cillation.de;
	auth=pass smtp.auth=os-c@schweissgut.net smtp.mailfrom=hd@os-cillation.de
Received: from [192.168.3.45] (hd2022.osc.gmbh [192.168.3.45])
	by core2024.osc.gmbh (Postfix) with ESMTPSA id C395F200736;
	Tue, 21 Jul 2026 20:59:21 +0200 (CEST)
Message-ID: <37ecba68-947a-45ad-9ec4-361facc06a05@os-cillation.de>
Date: Tue, 21 Jul 2026 20:59:21 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] crypto: pcrypt - Remove pcrypt
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Steffen Klassert <steffen.klassert@secunet.com>,
 Thomas Huth <thuth@redhat.com>
References: <20260713223234.24812-1-ebiggers@kernel.org>
 <20260713223234.24812-2-ebiggers@kernel.org>
Content-Language: en-US
From: Hendrik Donner <hd@os-cillation.de>
Autocrypt: addr=hd@os-cillation.de; keydata=
 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 li+2
In-Reply-To: <20260713223234.24812-2-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

On 7/14/26 00:32, Eric Biggers wrote:
> pcrypt was originally intended to improve IPsec performance.  However,
> it's no longer useful for that.  Reports from the rare cases that anyone
> has actually tried to use it over the years indicate that it actually
> reduces IPsec performance, e.g.:
> 
> * https://github.com/libreswan/libreswan/wiki/Internals:-Cryptographic-Acceleration#obsoleted-ipsec-accelerations
> * https://users.strongswan.narkive.com/liqTaTq8/strongswan-problem-with-pcrypt
> * https://unix.stackexchange.com/questions/594336/ipsec-multithreading-via-pcrypt-worse-than-single-thread
> 
> It's also undocumented and quite difficult to actually use.  Its design
> is also broken, in that any unprivileged program can enable pcrypt
> systemwide at any time (by instantiating it using AF_ALG).
> 
> Meanwhile, pcrypt has been a regular source of bugs, including at least
> four that have received CVEs.
> 
> Let's just remove it.  No one seems to care about it anymore other than
> people looking for vulnerabilities.
> 

my company is a user. We have a hardware platform based on an IMX6 SoC
using IPSec and configure pcrypt using crconf. Current performance
difference:

iperf3 -c <IP> --time 60 -R

pcrypt:
Download: 107 Mbits/sec

No pcrypt:
Download: 59.3 Mbits/sec

iperf3 -c <IP> --time 60

pcrypt:
Upload: 65.9 Mbits/sec

No pcrypt:
Upload: 52.0 Mbits/sec

The relevant crypto templates are configured in early userspace and
since i got curious, that has been the case since 2017.

Mostly using

pcrypt(gcm_base(ctr-aes-neonbs,ghash-generic))

nowadays, AES-CBC in the past/as a fallback option.

So at least on some platforms there is still a significant performance
boots, at least for downloads in this case.

Regards,
Hendrik


> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>   MAINTAINERS                                 |   7 -
>   arch/loongarch/configs/loongson32_defconfig |   1 -
>   arch/loongarch/configs/loongson64_defconfig |   1 -
>   arch/s390/configs/debug_defconfig           |   1 -
>   arch/s390/configs/defconfig                 |   1 -
>   crypto/Kconfig                              |  10 -
>   crypto/Makefile                             |   1 -
>   crypto/pcrypt.c                             | 394 --------------------
>   include/crypto/pcrypt.h                     |  39 --
>   tools/crypto/tcrypt/tcrypt_speed_compare.py |   7 +-
>   10 files changed, 2 insertions(+), 460 deletions(-)
>   delete mode 100644 crypto/pcrypt.c
>   delete mode 100644 include/crypto/pcrypt.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 806bd2d80d15..260b3bdc7614 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -21085,13 +21085,6 @@ L:	netdev@vger.kernel.org
>   S:	Maintained
>   F:	drivers/net/ethernet/amd/pcnet32.c
>   
> -PCRYPT PARALLEL CRYPTO ENGINE
> -M:	Steffen Klassert <steffen.klassert@secunet.com>
> -L:	linux-crypto@vger.kernel.org
> -S:	Maintained
> -F:	crypto/pcrypt.c
> -F:	include/crypto/pcrypt.h
> -
>   PDS DSC VIRTIO DATA PATH ACCELERATOR
>   R:	Brett Creeley <brett.creeley@amd.com>
>   F:	drivers/vdpa/pds/
> diff --git a/arch/loongarch/configs/loongson32_defconfig b/arch/loongarch/configs/loongson32_defconfig
> index 7c8f01513ed2..cf97f4493573 100644
> --- a/arch/loongarch/configs/loongson32_defconfig
> +++ b/arch/loongarch/configs/loongson32_defconfig
> @@ -1063,7 +1063,6 @@ CONFIG_SECURITY_YAMA=y
>   CONFIG_DEFAULT_SECURITY_DAC=y
>   CONFIG_CRYPTO_USER=m
>   CONFIG_CRYPTO_SELFTESTS=y
> -CONFIG_CRYPTO_PCRYPT=m
>   CONFIG_CRYPTO_CRYPTD=m
>   CONFIG_CRYPTO_ANUBIS=m
>   CONFIG_CRYPTO_BLOWFISH=m
> diff --git a/arch/loongarch/configs/loongson64_defconfig b/arch/loongarch/configs/loongson64_defconfig
> index 8e3906d3bd70..d0ece7920f21 100644
> --- a/arch/loongarch/configs/loongson64_defconfig
> +++ b/arch/loongarch/configs/loongson64_defconfig
> @@ -1096,7 +1096,6 @@ CONFIG_SECURITY_YAMA=y
>   CONFIG_DEFAULT_SECURITY_DAC=y
>   CONFIG_CRYPTO_USER=m
>   CONFIG_CRYPTO_SELFTESTS=y
> -CONFIG_CRYPTO_PCRYPT=m
>   CONFIG_CRYPTO_CRYPTD=m
>   CONFIG_CRYPTO_ANUBIS=m
>   CONFIG_CRYPTO_BLOWFISH=m
> diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debug_defconfig
> index 54637be87fb7..15f51cb924db 100644
> --- a/arch/s390/configs/debug_defconfig
> +++ b/arch/s390/configs/debug_defconfig
> @@ -765,7 +765,6 @@ CONFIG_CRYPTO_USER=m
>   CONFIG_CRYPTO_SELFTESTS=y
>   CONFIG_CRYPTO_SELFTESTS_FULL=y
>   CONFIG_CRYPTO_NULL=y
> -CONFIG_CRYPTO_PCRYPT=m
>   CONFIG_CRYPTO_CRYPTD=m
>   CONFIG_CRYPTO_BENCHMARK=m
>   CONFIG_CRYPTO_DH=m
> diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
> index 5f5114a253cf..88257ff3c2c6 100644
> --- a/arch/s390/configs/defconfig
> +++ b/arch/s390/configs/defconfig
> @@ -749,7 +749,6 @@ CONFIG_CRYPTO_FIPS=y
>   CONFIG_CRYPTO_USER=m
>   CONFIG_CRYPTO_SELFTESTS=y
>   CONFIG_CRYPTO_NULL=y
> -CONFIG_CRYPTO_PCRYPT=m
>   CONFIG_CRYPTO_CRYPTD=m
>   CONFIG_CRYPTO_BENCHMARK=m
>   CONFIG_CRYPTO_DH=m
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index f1e372195273..228a7ac9f063 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -201,16 +201,6 @@ config CRYPTO_NULL
>   	help
>   	  These are 'Null' algorithms, used by IPsec, which do nothing.
>   
> -config CRYPTO_PCRYPT
> -	tristate "Parallel crypto engine"
> -	depends on SMP
> -	select PADATA
> -	select CRYPTO_MANAGER
> -	select CRYPTO_AEAD
> -	help
> -	  This converts an arbitrary crypto algorithm into a parallel
> -	  algorithm that executes in kernel threads.
> -
>   config CRYPTO_CRYPTD
>   	tristate "Software async crypto daemon"
>   	select CRYPTO_AEAD
> diff --git a/crypto/Makefile b/crypto/Makefile
> index 8386d55a9755..2e487c946e63 100644
> --- a/crypto/Makefile
> +++ b/crypto/Makefile
> @@ -120,7 +120,6 @@ CFLAGS_aegis128-neon-inner.o += $(aegis128-cflags-y)
>   aegis128-$(CONFIG_CRYPTO_AEGIS128_SIMD) += aegis128-neon.o aegis128-neon-inner.o
>   endif
>   
> -obj-$(CONFIG_CRYPTO_PCRYPT) += pcrypt.o
>   obj-$(CONFIG_CRYPTO_CRYPTD) += cryptd.o
>   obj-$(CONFIG_CRYPTO_DES) += des_generic.o
>   obj-$(CONFIG_CRYPTO_BLOWFISH) += blowfish_generic.o
> diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
> deleted file mode 100644
> index 9f372442981e..000000000000
> --- a/crypto/pcrypt.c
> +++ /dev/null
> @@ -1,394 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0-only
> -/*
> - * pcrypt - Parallel crypto wrapper.
> - *
> - * Copyright (C) 2009 secunet Security Networks AG
> - * Copyright (C) 2009 Steffen Klassert <steffen.klassert@secunet.com>
> - */
> -
> -#include <crypto/algapi.h>
> -#include <crypto/internal/aead.h>
> -#include <linux/atomic.h>
> -#include <linux/err.h>
> -#include <linux/init.h>
> -#include <linux/module.h>
> -#include <linux/slab.h>
> -#include <linux/kobject.h>
> -#include <linux/cpu.h>
> -#include <crypto/pcrypt.h>
> -
> -static struct padata_instance *pencrypt;
> -static struct padata_instance *pdecrypt;
> -static struct kset           *pcrypt_kset;
> -
> -struct pcrypt_instance_ctx {
> -	struct crypto_aead_spawn spawn;
> -	struct padata_shell *psenc;
> -	struct padata_shell *psdec;
> -	atomic_t tfm_count;
> -};
> -
> -struct pcrypt_aead_ctx {
> -	struct crypto_aead *child;
> -	unsigned int cb_cpu;
> -};
> -
> -static inline struct pcrypt_instance_ctx *pcrypt_tfm_ictx(
> -	struct crypto_aead *tfm)
> -{
> -	return aead_instance_ctx(aead_alg_instance(tfm));
> -}
> -
> -static int pcrypt_aead_setkey(struct crypto_aead *parent,
> -			      const u8 *key, unsigned int keylen)
> -{
> -	struct pcrypt_aead_ctx *ctx = crypto_aead_ctx(parent);
> -
> -	return crypto_aead_setkey(ctx->child, key, keylen);
> -}
> -
> -static int pcrypt_aead_setauthsize(struct crypto_aead *parent,
> -				   unsigned int authsize)
> -{
> -	struct pcrypt_aead_ctx *ctx = crypto_aead_ctx(parent);
> -
> -	return crypto_aead_setauthsize(ctx->child, authsize);
> -}
> -
> -static void pcrypt_aead_serial(struct padata_priv *padata)
> -{
> -	struct pcrypt_request *preq = pcrypt_padata_request(padata);
> -	struct aead_request *req = pcrypt_request_ctx(preq);
> -
> -	aead_request_complete(req->base.data, padata->info);
> -}
> -
> -static void pcrypt_aead_done(void *data, int err)
> -{
> -	struct aead_request *req = data;
> -	struct pcrypt_request *preq = aead_request_ctx(req);
> -	struct padata_priv *padata = pcrypt_request_padata(preq);
> -
> -	if (err == -EINPROGRESS)
> -		return;
> -
> -	padata->info = err;
> -
> -	padata_do_serial(padata);
> -}
> -
> -static void pcrypt_aead_enc(struct padata_priv *padata)
> -{
> -	struct pcrypt_request *preq = pcrypt_padata_request(padata);
> -	struct aead_request *req = pcrypt_request_ctx(preq);
> -	int ret;
> -
> -	ret = crypto_aead_encrypt(req);
> -
> -	if (ret == -EINPROGRESS || ret == -EBUSY)
> -		return;
> -
> -	padata->info = ret;
> -	padata_do_serial(padata);
> -}
> -
> -static int pcrypt_aead_encrypt(struct aead_request *req)
> -{
> -	int err;
> -	struct pcrypt_request *preq = aead_request_ctx(req);
> -	struct aead_request *creq = pcrypt_request_ctx(preq);
> -	struct padata_priv *padata = pcrypt_request_padata(preq);
> -	struct crypto_aead *aead = crypto_aead_reqtfm(req);
> -	struct pcrypt_aead_ctx *ctx = crypto_aead_ctx(aead);
> -	u32 flags = aead_request_flags(req);
> -	struct pcrypt_instance_ctx *ictx;
> -
> -	ictx = pcrypt_tfm_ictx(aead);
> -
> -	memset(padata, 0, sizeof(struct padata_priv));
> -
> -	padata->parallel = pcrypt_aead_enc;
> -	padata->serial = pcrypt_aead_serial;
> -
> -	aead_request_set_tfm(creq, ctx->child);
> -	aead_request_set_callback(creq, flags & ~CRYPTO_TFM_REQ_MAY_SLEEP,
> -				  pcrypt_aead_done, req);
> -	aead_request_set_crypt(creq, req->src, req->dst,
> -			       req->cryptlen, req->iv);
> -	aead_request_set_ad(creq, req->assoclen);
> -
> -	err = padata_do_parallel(ictx->psenc, padata, &ctx->cb_cpu);
> -	if (!err)
> -		return -EINPROGRESS;
> -	if (err == -EBUSY) {
> -		/* try non-parallel mode */
> -		aead_request_set_callback(creq, flags, req->base.complete,
> -					  req->base.data);
> -		return crypto_aead_encrypt(creq);
> -	}
> -
> -	return err;
> -}
> -
> -static void pcrypt_aead_dec(struct padata_priv *padata)
> -{
> -	struct pcrypt_request *preq = pcrypt_padata_request(padata);
> -	struct aead_request *req = pcrypt_request_ctx(preq);
> -	int ret;
> -
> -	ret = crypto_aead_decrypt(req);
> -
> -	if (ret == -EINPROGRESS || ret == -EBUSY)
> -		return;
> -
> -	padata->info = ret;
> -	padata_do_serial(padata);
> -}
> -
> -static int pcrypt_aead_decrypt(struct aead_request *req)
> -{
> -	int err;
> -	struct pcrypt_request *preq = aead_request_ctx(req);
> -	struct aead_request *creq = pcrypt_request_ctx(preq);
> -	struct padata_priv *padata = pcrypt_request_padata(preq);
> -	struct crypto_aead *aead = crypto_aead_reqtfm(req);
> -	struct pcrypt_aead_ctx *ctx = crypto_aead_ctx(aead);
> -	u32 flags = aead_request_flags(req);
> -	struct pcrypt_instance_ctx *ictx;
> -
> -	ictx = pcrypt_tfm_ictx(aead);
> -
> -	memset(padata, 0, sizeof(struct padata_priv));
> -
> -	padata->parallel = pcrypt_aead_dec;
> -	padata->serial = pcrypt_aead_serial;
> -
> -	aead_request_set_tfm(creq, ctx->child);
> -	aead_request_set_callback(creq, flags & ~CRYPTO_TFM_REQ_MAY_SLEEP,
> -				  pcrypt_aead_done, req);
> -	aead_request_set_crypt(creq, req->src, req->dst,
> -			       req->cryptlen, req->iv);
> -	aead_request_set_ad(creq, req->assoclen);
> -
> -	err = padata_do_parallel(ictx->psdec, padata, &ctx->cb_cpu);
> -	if (!err)
> -		return -EINPROGRESS;
> -	if (err == -EBUSY) {
> -		/* try non-parallel mode */
> -		aead_request_set_callback(creq, flags, req->base.complete,
> -					  req->base.data);
> -		return crypto_aead_decrypt(creq);
> -	}
> -
> -	return err;
> -}
> -
> -static int pcrypt_aead_init_tfm(struct crypto_aead *tfm)
> -{
> -	int cpu_index;
> -	struct aead_instance *inst = aead_alg_instance(tfm);
> -	struct pcrypt_instance_ctx *ictx = aead_instance_ctx(inst);
> -	struct pcrypt_aead_ctx *ctx = crypto_aead_ctx(tfm);
> -	struct crypto_aead *cipher;
> -
> -	cpu_index = (unsigned int)atomic_inc_return(&ictx->tfm_count) %
> -		    cpumask_weight(cpu_online_mask);
> -
> -	ctx->cb_cpu = cpumask_nth(cpu_index, cpu_online_mask);
> -	cipher = crypto_spawn_aead(&ictx->spawn);
> -
> -	if (IS_ERR(cipher))
> -		return PTR_ERR(cipher);
> -
> -	ctx->child = cipher;
> -	crypto_aead_set_reqsize(tfm, sizeof(struct pcrypt_request) +
> -				     sizeof(struct aead_request) +
> -				     crypto_aead_reqsize(cipher));
> -
> -	return 0;
> -}
> -
> -static void pcrypt_aead_exit_tfm(struct crypto_aead *tfm)
> -{
> -	struct pcrypt_aead_ctx *ctx = crypto_aead_ctx(tfm);
> -
> -	crypto_free_aead(ctx->child);
> -}
> -
> -static void pcrypt_free(struct aead_instance *inst)
> -{
> -	struct pcrypt_instance_ctx *ctx = aead_instance_ctx(inst);
> -
> -	crypto_drop_aead(&ctx->spawn);
> -	padata_free_shell(ctx->psdec);
> -	padata_free_shell(ctx->psenc);
> -	kfree(inst);
> -}
> -
> -static int pcrypt_init_instance(struct crypto_instance *inst,
> -				struct crypto_alg *alg)
> -{
> -	if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
> -		     "pcrypt(%s)", alg->cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
> -		return -ENAMETOOLONG;
> -
> -	memcpy(inst->alg.cra_name, alg->cra_name, CRYPTO_MAX_ALG_NAME);
> -
> -	inst->alg.cra_priority = alg->cra_priority + 100;
> -	inst->alg.cra_blocksize = alg->cra_blocksize;
> -	inst->alg.cra_alignmask = alg->cra_alignmask;
> -
> -	return 0;
> -}
> -
> -static int pcrypt_create_aead(struct crypto_template *tmpl, struct rtattr **tb,
> -			      struct crypto_attr_type *algt)
> -{
> -	struct pcrypt_instance_ctx *ctx;
> -	struct aead_instance *inst;
> -	struct aead_alg *alg;
> -	u32 mask = crypto_algt_inherited_mask(algt);
> -	int err;
> -
> -	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
> -	if (!inst)
> -		return -ENOMEM;
> -
> -	err = -ENOMEM;
> -
> -	ctx = aead_instance_ctx(inst);
> -	ctx->psenc = padata_alloc_shell(pencrypt);
> -	if (!ctx->psenc)
> -		goto err_free_inst;
> -
> -	ctx->psdec = padata_alloc_shell(pdecrypt);
> -	if (!ctx->psdec)
> -		goto err_free_inst;
> -
> -	err = crypto_grab_aead(&ctx->spawn, aead_crypto_instance(inst),
> -			       crypto_attr_alg_name(tb[1]), 0, mask);
> -	if (err)
> -		goto err_free_inst;
> -
> -	alg = crypto_spawn_aead_alg(&ctx->spawn);
> -	err = pcrypt_init_instance(aead_crypto_instance(inst), &alg->base);
> -	if (err)
> -		goto err_free_inst;
> -
> -	inst->alg.base.cra_flags |= CRYPTO_ALG_ASYNC;
> -
> -	inst->alg.ivsize = crypto_aead_alg_ivsize(alg);
> -	inst->alg.maxauthsize = crypto_aead_alg_maxauthsize(alg);
> -
> -	inst->alg.base.cra_ctxsize = sizeof(struct pcrypt_aead_ctx);
> -
> -	inst->alg.init = pcrypt_aead_init_tfm;
> -	inst->alg.exit = pcrypt_aead_exit_tfm;
> -
> -	inst->alg.setkey = pcrypt_aead_setkey;
> -	inst->alg.setauthsize = pcrypt_aead_setauthsize;
> -	inst->alg.encrypt = pcrypt_aead_encrypt;
> -	inst->alg.decrypt = pcrypt_aead_decrypt;
> -
> -	inst->free = pcrypt_free;
> -
> -	err = aead_register_instance(tmpl, inst);
> -	if (err) {
> -err_free_inst:
> -		pcrypt_free(inst);
> -	}
> -	return err;
> -}
> -
> -static int pcrypt_create(struct crypto_template *tmpl, struct rtattr **tb)
> -{
> -	struct crypto_attr_type *algt;
> -
> -	algt = crypto_get_attr_type(tb);
> -	if (IS_ERR(algt))
> -		return PTR_ERR(algt);
> -
> -	switch (algt->type & algt->mask & CRYPTO_ALG_TYPE_MASK) {
> -	case CRYPTO_ALG_TYPE_AEAD:
> -		return pcrypt_create_aead(tmpl, tb, algt);
> -	}
> -
> -	return -EINVAL;
> -}
> -
> -static int pcrypt_sysfs_add(struct padata_instance *pinst, const char *name)
> -{
> -	int ret;
> -
> -	pinst->kobj.kset = pcrypt_kset;
> -	ret = kobject_add(&pinst->kobj, NULL, "%s", name);
> -	if (!ret)
> -		kobject_uevent(&pinst->kobj, KOBJ_ADD);
> -
> -	return ret;
> -}
> -
> -static int pcrypt_init_padata(struct padata_instance **pinst, const char *name)
> -{
> -	int ret = -ENOMEM;
> -
> -	*pinst = padata_alloc(name);
> -	if (!*pinst)
> -		return ret;
> -
> -	ret = pcrypt_sysfs_add(*pinst, name);
> -	if (ret)
> -		padata_free(*pinst);
> -
> -	return ret;
> -}
> -
> -static struct crypto_template pcrypt_tmpl = {
> -	.name = "pcrypt",
> -	.create = pcrypt_create,
> -	.module = THIS_MODULE,
> -};
> -
> -static int __init pcrypt_init(void)
> -{
> -	int err = -ENOMEM;
> -
> -	pcrypt_kset = kset_create_and_add("pcrypt", NULL, kernel_kobj);
> -	if (!pcrypt_kset)
> -		goto err;
> -
> -	err = pcrypt_init_padata(&pencrypt, "pencrypt");
> -	if (err)
> -		goto err_unreg_kset;
> -
> -	err = pcrypt_init_padata(&pdecrypt, "pdecrypt");
> -	if (err)
> -		goto err_deinit_pencrypt;
> -
> -	return crypto_register_template(&pcrypt_tmpl);
> -
> -err_deinit_pencrypt:
> -	padata_free(pencrypt);
> -err_unreg_kset:
> -	kset_unregister(pcrypt_kset);
> -err:
> -	return err;
> -}
> -
> -static void __exit pcrypt_exit(void)
> -{
> -	crypto_unregister_template(&pcrypt_tmpl);
> -
> -	padata_free(pencrypt);
> -	padata_free(pdecrypt);
> -
> -	kset_unregister(pcrypt_kset);
> -}
> -
> -module_init(pcrypt_init);
> -module_exit(pcrypt_exit);
> -
> -MODULE_LICENSE("GPL");
> -MODULE_AUTHOR("Steffen Klassert <steffen.klassert@secunet.com>");
> -MODULE_DESCRIPTION("Parallel crypto wrapper");
> -MODULE_ALIAS_CRYPTO("pcrypt");
> diff --git a/include/crypto/pcrypt.h b/include/crypto/pcrypt.h
> deleted file mode 100644
> index 234d7cf3cf5e..000000000000
> --- a/include/crypto/pcrypt.h
> +++ /dev/null
> @@ -1,39 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0-only */
> -/*
> - * pcrypt - Parallel crypto engine.
> - *
> - * Copyright (C) 2009 secunet Security Networks AG
> - * Copyright (C) 2009 Steffen Klassert <steffen.klassert@secunet.com>
> - */
> -
> -#ifndef _CRYPTO_PCRYPT_H
> -#define _CRYPTO_PCRYPT_H
> -
> -#include <linux/container_of.h>
> -#include <linux/crypto.h>
> -#include <linux/padata.h>
> -
> -struct pcrypt_request {
> -	struct padata_priv	padata;
> -	void			*data;
> -	void			*__ctx[] CRYPTO_MINALIGN_ATTR;
> -};
> -
> -static inline void *pcrypt_request_ctx(struct pcrypt_request *req)
> -{
> -	return req->__ctx;
> -}
> -
> -static inline
> -struct padata_priv *pcrypt_request_padata(struct pcrypt_request *req)
> -{
> -	return &req->padata;
> -}
> -
> -static inline
> -struct pcrypt_request *pcrypt_padata_request(struct padata_priv *padata)
> -{
> -	return container_of(padata, struct pcrypt_request, padata);
> -}
> -
> -#endif
> diff --git a/tools/crypto/tcrypt/tcrypt_speed_compare.py b/tools/crypto/tcrypt/tcrypt_speed_compare.py
> index f3f5783cdc06..0bf38c073dbc 100755
> --- a/tools/crypto/tcrypt/tcrypt_speed_compare.py
> +++ b/tools/crypto/tcrypt/tcrypt_speed_compare.py
> @@ -28,19 +28,16 @@ num_mb=8
>   mode=211
>   
>   # base speed test
> -lsmod | grep pcrypt && modprobe -r pcrypt
>   dmesg -C
> -modprobe tcrypt alg="pcrypt(rfc4106(gcm(aes)))" type=3
> +modprobe tcrypt alg="rfc4106(gcm(aes))" type=3
>   modprobe tcrypt mode=${mode} sec=${sec} num_mb=${num_mb}
>   dmesg > ${seq_num}_base_dmesg.log
>   
>   # new speed test
> -lsmod | grep pcrypt && modprobe -r pcrypt
>   dmesg -C
> -modprobe tcrypt alg="pcrypt(rfc4106(gcm(aes)))" type=3
> +modprobe tcrypt alg="rfc4106(gcm(aes))" type=3
>   modprobe tcrypt mode=${mode} sec=${sec} num_mb=${num_mb}
>   dmesg > ${seq_num}_new_dmesg.log
> -lsmod | grep pcrypt && modprobe -r pcrypt
>   
>   tools/crypto/tcrypt/tcrypt_speed_compare.py \
>       ${seq_num}_base_dmesg.log \

