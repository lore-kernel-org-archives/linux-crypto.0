Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795594279;
	b=28OHb1UuXrzrpNFD+ap4pM8P8H00b3e7E1LIla012qgb10qXxBTHpCqYZNhH5Ei1gfeg
	 bojnQ7pJ3oQTRy+3VjzOcxPpR5Kunvnh2bjmlosysBcVK+C9HVLhvDNw1uqLu1bbyZnc+
	 w2Ts3dliRqBiX8JhG06w03M6TjhUiZ3Hn/psMCQb95JS34JHHf2at6bb5j0ig8/JNvQbi
	 uJPNA3sn/WEFtdtSXh3xxEWW+5IvTe88G8zGml5KD9dAZ+kDUAlsvkxm+fRp8THY+WdDU
	 LHdL9ctJyIM/7dgvNQyaNhYA+Zwa/xD0BlXw+SFbX90vSPaY9SQCAnxmHEHSrK6x7qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795594279;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=+eL61VnfOSLPieUPZNrpTckHzePhp+r5r18tMZ4cod8=;
	b=dfdjHvawMRGmRkeNFvDJiXlzPNevPtCLlKuVGXQfsoyNvarBkxCZ5zkM/Y6fbEXAjb06
	 x28lFKjJM2dg9qJPo59YuimTPmL4iVbAxexKCDjDsHzqBGXhy8h5XM1JmYCvnKGlomWNU
	 7XNjbS+Ac7p6w2G9EKvv+KsqjrNl2kCmElm9MtXClN3IvBZPhhroOnbvD/ad6R2Ip4gmW
	 jtp99RXN7d2L1r9pgqiZu5fCyT9k3SE1YIMI5EOJiDb+unfKyfdl/nKL0XhmuQ5kihoJH
	 ZIzIZCwG1cDz01Hgy3cCorB+liI0+U122hEXYRRpwswHBbuXB0EkJn3vqYwAw+C7jfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HQWbgRWB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3110606A31E
	for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 08:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HQWbgRWB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9A41F000CA;
	Wed, 25 Nov 2026 08:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795594278;
	bh=+eL61VnfOSLPieUPZNrpTckHzePhp+r5r18tMZ4cod8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HQWbgRWBL/0ulOd5LgFqQZatkYzbC4MFqFAqbznFoc4RQz8xBVJpna4mdoTJC6lq0
	 FnEYHHNyK/boLhn0HAcXKiOzJJKyxjyU2C1KOSTNainOVHLfc6M0fD0qtpO1Ro5Qi/
	 bq5wMOJ8cmgzdEyi4QrF+TNJUvqxYu0SNUc7Q0jG2uJ6uXkdHPQM4YTV10mTa03cEF
	 zMhOHaTgq22v4/JuhoK0OmOaE6TIhjgbqd4+xziMyT5rKwOF2NwZefgX4tm4rTyPeG
	 ifLLQwycE/T8ddU/eeAvWjzqhJPkq4XbLZQ4eGFpYIk8u6t5e6qEVqgbTs/FW9+HfK
	 ME7/qtBw3p+UA==
Message-ID: <sashiko-outbox-232868@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 10/11] crypto: ccp - add SM4 engine and skcipher
 algorithms
Reply-To: sashiko-reviews@lists.linux.dev
To: "Depei Yang" <yangdepei@hygon.cn>, linux-crypto@vger.kernel.org
Cc: "Tom Lendacky" <thomas.lendacky@amd.com>, "Herbert Xu" <herbert@gondor.apana.org.au>, "David
 S. Miller" <davem@davemloft.net>, "Gary R Hook" <gary.hook@amd.com>, "Shan
 Chen" <chenshan@hygon.cn>, "Yongwei Xu" <xuyongwei@hygon.cn>, "Xiaochen
 Shen" <shenxiaochen@hygon.cn>
In-Reply-To: <197a8174e8f0e39b92585c4fa24f228d5e4486d1.1795588986.git.yangdepei@hygon.cn>
References: <cover.1795588986.git.yangdepei@hygon.cn>
 <197a8174e8f0e39b92585c4fa24f228d5e4486d1.1795588986.git.yangdepei@hygon.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 08:11:17 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Medium] crypto: ccp - missing chunksize for ctr(sm4) in
  ccp_register_sm4_alg()
- [Medium] crypto: ccp - 64-bit counter size in ccp_sm4_crypt() breaks
  128-bit ctr(sm4)
- [Low] crypto: ccp - missing noinline_for_stack on SM4 ccp_run_*_cmd()
  handlers
--

commit dd1e070e32af2e2910159d7e8f6ecb0aabde8163
Author: Depei Yang <yangdepei@hygon.cn>

crypto: ccp - add SM4 engine and skcipher algorithms

This commit adds v5 descriptor builders, request handling, and skcipher
registrations for ecb(sm4), cbc(sm4), and ctr(sm4) on CCP devices.

> diff --git a/drivers/crypto/ccp/ccp-crypto-sm4.c b/drivers/crypto/ccp/ccp=
-crypto-sm4.c
> new file mode 100644
> index 0000000000000..fbdba8cd0da04
> --- /dev/null
> +++ b/drivers/crypto/ccp/ccp-crypto-sm4.c

[ ... ]

> +	if (mode =3D=3D CCP_SM4_ALG_MODE_CTR) {
> +		cmd->engine =3D CCP_ENGINE_SM4_CTR;
> +		cmd->u.sm4_ctr.action =3D action;
> +		cmd->u.sm4_ctr.size =3D 63;
> +		cmd->u.sm4_ctr.step =3D 1;

[Severity: Medium]
Does setting cmd->u.sm4_ctr.size to 63 restrict the counter increment to
the lower 64 bits of the 16-byte IV?

The crypto API ctr(sm4) algorithm treats the counter block as a 128-bit
big-endian integer (crypto_inc(ctrblk, 16)), and CCP AES-CTR sets its
7-bit size field to AES_BLOCK_SIZE * BITS_PER_BYTE - 1 (127).  With size =3D
63, requests whose counter wraps the lower 64 bits will not propagate the
carry into the upper 64 bits of the counter stream or the returned
req->iv, causing self-test failures against the generic implementation
under CONFIG_CRYPTO_MANAGER_EXTRA_TESTS.

If the SM4-CTR engine supports a 128-bit counter width via its 7-bit size
field, this should be SM4_BLOCK_SIZE * BITS_PER_BYTE - 1; if the hardware
is limited to 64 bits, requests crossing a 64-bit counter boundary need a
software fallback.

[ ... ]

> +static const struct skcipher_alg ccp_sm4_defaults =3D {
> +	.setkey			=3D ccp_sm4_setkey,
> +	.encrypt		=3D ccp_sm4_encrypt,
> +	.decrypt		=3D ccp_sm4_decrypt,
> +	.min_keysize		=3D SM4_KEY_SIZE,
> +	.max_keysize		=3D SM4_KEY_SIZE,
> +	.init			=3D ccp_sm4_init_tfm,
> +
> +	.base.cra_flags		=3D CRYPTO_ALG_ASYNC |
> +				  CRYPTO_ALG_ALLOCATES_MEMORY |
> +				  CRYPTO_ALG_KERN_DRIVER_ONLY |
> +				  CRYPTO_ALG_NEED_FALLBACK,
> +	.base.cra_blocksize	=3D SM4_BLOCK_SIZE,
> +	.base.cra_ctxsize	=3D sizeof(struct ccp_ctx) + CRYPTO_DMA_PADDING,
> +	.base.cra_priority	=3D CCP_CRA_PRIORITY,
> +	.base.cra_module	=3D THIS_MODULE,
> +};

[ ... ]

> +/* SM4-CTR is a separate engine on the CCP */
> +static const struct ccp_sm4_def sm4_ctr_alg =3D {
> +	.mode		=3D CCP_SM4_ALG_MODE_CTR,
> +	.name		=3D "ctr(sm4)",
> +	.driver_name	=3D "ctr-sm4-ccp",
> +	.blocksize	=3D 1,
> +	.ivsize		=3D SM4_BLOCK_SIZE,
> +	.alg_defaults	=3D &ccp_sm4_defaults,
> +};
> +
> +static int ccp_register_sm4_alg(struct list_head *head,
> +				const struct ccp_sm4_def *def)
> +{
> +	struct ccp_crypto_skcipher_alg *ccp_alg;
> +	struct skcipher_alg *alg;
> +	int ret;
> +
> +	ccp_alg =3D kzalloc_obj(*ccp_alg);
> +	if (!ccp_alg)
> +		return -ENOMEM;
> +
> +	INIT_LIST_HEAD(&ccp_alg->entry);
> +
> +	ccp_alg->mode =3D def->mode;
> +
> +	/* copy the defaults and override as necessary */
> +	alg =3D &ccp_alg->alg;
> +	*alg =3D *def->alg_defaults;
> +	strscpy(alg->base.cra_name, def->name);
> +	strscpy(alg->base.cra_driver_name, def->driver_name);
> +	alg->base.cra_blocksize =3D def->blocksize;
> +	alg->ivsize =3D def->ivsize;
> +
> +	ret =3D crypto_register_skcipher(alg);

[Severity: Medium]
Should ccp_sm4_defaults set .chunksize =3D SM4_BLOCK_SIZE?

For ctr(sm4), ccp_register_sm4_alg() sets alg->base.cra_blocksize to 1
while alg->chunksize remains 0, so skcipher_prepare_alg_common() defaults
chunksize to 1 instead of SM4_BLOCK_SIZE.  Streaming callers such as
AF_ALG _skcipher_recvmsg() use crypto_skcipher_chunksize() to align
non-final MSG_MORE chunks to a block boundary; with chunksize =3D=3D 1, a
partial block submitted in a non-final call advances the 16-byte hardware
counter IV to the next block and discards the remaining keystream bytes of
that block, corrupting subsequent output.

> diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
> index f35803c37ab4b..7c8464b1db6b7 100644
> --- a/drivers/crypto/ccp/ccp-ops.c
> +++ b/drivers/crypto/ccp/ccp-ops.c

[ ... ]

> +static int ccp_run_sm4_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *=
cmd)
> +{
> +	struct ccp_sm4_engine *sm4 =3D &cmd->u.sm4;
> +	struct ccp_dm_workarea iv_key;
> +	struct ccp_data src, dst;
> +	struct ccp_op op;

[ ... ]

> +static int ccp_run_sm4_ctr_cmd(struct ccp_cmd_queue *cmd_q,
> +			       struct ccp_cmd *cmd)
> +{
> +	struct ccp_sm4_ctr_engine *sm4_ctr =3D &cmd->u.sm4_ctr;
> +	struct ccp_dm_workarea iv_key;
> +	struct ccp_data src, dst;
> +	struct ccp_op op;

[Severity: Low]
Should ccp_run_sm4_cmd() and ccp_run_sm4_ctr_cmd() be marked
noinline_for_stack like the other per-engine handlers in this file?

Each function allocates roughly 400 bytes of local structures on the stack
and has a single call site in ccp_run_cmd(); 72c8117adfce ("crypto: ccp -
Reduce maximum stack usage") marked the other ccp_run_*_cmd() handlers
noinline_for_stack to prevent the compiler from combining their stack
frames in ccp_run_cmd() and tripping -Wframe-larger-than.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1795588986.gi=
t.yangdepei@hygon.cn?part=3D10
