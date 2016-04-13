From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH] crypto: sha1-mb - use corrcet pointer while completing
 jobs
Date: Wed, 13 Apr 2016 11:26:02 -0700
Message-ID: <1460571962.14714.46.camel@linux.intel.com>
References: <1460454351-43534-1-git-send-email-xiaodong.liu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, megha.dey@linux.intel.com,
	Megha Dey <megha.dey@linux.intel.com>
To: Xiaodong Liu <xiaodong.liu@intel.com>, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:50290 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554AbcDMS0F (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 Apr 2016 14:26:05 -0400
In-Reply-To: <1460454351-43534-1-git-send-email-xiaodong.liu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2016-04-12 at 09:45 +0000, Xiaodong Liu wrote:
> In sha_complete_job, incorrect mcryptd_hash_request_ctx pointer is
> used
> when check and complete other jobs. If the memory of first completed
> req
> is freed, while still completing other jobs in the func, kernel will
> crash since NULL pointer is assigned to RIP.


> Signed-off-by: Xiaodong Liu <xiaodong.liu@intel.com>
> ---
> =C2=A0arch/x86/crypto/sha-mb/sha1_mb.c | 4 ++--
> =C2=A01 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/x86/crypto/sha-mb/sha1_mb.c b/arch/x86/crypto/sha-
> mb/sha1_mb.c
> index a8a0224..081255c 100644
> --- a/arch/x86/crypto/sha-mb/sha1_mb.c
> +++ b/arch/x86/crypto/sha-mb/sha1_mb.c
> @@ -453,10 +453,10 @@ static int sha_complete_job(struct
> mcryptd_hash_request_ctx *rctx,
> =C2=A0
> =C2=A0			req =3D cast_mcryptd_ctx_to_req(req_ctx);
> =C2=A0			if (irqs_disabled())
> -				rctx->complete(&req->base, ret);
> +				req_ctx->complete(&req->base, ret);
> =C2=A0			else {
> =C2=A0				local_bh_disable();
> -				rctx->complete(&req->base, ret);
> +				req_ctx->complete(&req->base, ret);
> =C2=A0				local_bh_enable();
> =C2=A0			}


Agreed. =C2=A0Should use req_ctx which is the ctx for the
next job that have been completed in the lanes
instead of the first completed job rctx, whose=C2=A0
completion could have been called and released.

Should be propagated back to stable release.

Acked-by: Tim Chen <tim.c.chen@linux.intel.com>

Tim

>=C2=A0

> =C2=A0		}
