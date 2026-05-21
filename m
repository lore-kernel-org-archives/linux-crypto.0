Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762253955C4;
	Thu, 21 May 2026 10:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779358577; cv=none; b=XeaiaID6RK7fpDaPSjYM1sKw7MvMKcFr+vGZEcM1egn3vE8kNuSCSe3cSYactbRMiLIRBStJJGO3MHrJlSFPV2kBwfur57dT0zxTxADsYhmqjmHDOP2Axmr97LteGirnLGESa9Q6zSGNSBq88wWUdgFE0372JEE+xpLvycOiu38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779358577; c=relaxed/simple;
	bh=BY2jaUG/1JKEplVUmLFxO8h42XjoJK/qQhsRHEmIaFA=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=oHAxYH/SfBGJ5oBBIo0wxpIgdxfIOVYdnzG3WgGGG+b04nk3TR5cfTbxSwFLhnl4bJmyHBivHshbDdHAgWQ0fRkrNrHQMTY0/9qjsuQQM4FzF+aG/aEsHOOu1DQwXutYkmWrY8QW4IoZ0g9G4a6SV3jcYvu8CCPw4Lp1LI8Dli0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=QjX2AKlU; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="QjX2AKlU"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id 59920C2C64E;
	Thu, 21 May 2026 10:17:00 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 3872360495;
	Thu, 21 May 2026 10:16:06 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 85341107EA6DB;
	Thu, 21 May 2026 12:16:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1779358565; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=P3Je6nUumeNH8/k2DYTNZ5Gs/YQlh7dTA4pIcgJCjnY=;
	b=QjX2AKlUsMeOMgoTmyD8xDdTc4IhdiYnO51O4x8SN5mhpcnhmdrQKXMDPrcYXs2lBL6cG2
	eHUNxlCqsof4ZBNbdPv2nzkYNTzFUNt4RBcHbX3xniDd10ON6fU7VPCgzsNZqPjZ6TpyMW
	rBjysfw0mdzbVZWdGgQkZcTxEmcpir/iYGOwlLXoU3vp25qrfG3A1rpHpiN0EvSp8qk9mD
	nOB1VkP+HhNnn7Wqhl6oSDhF21WIRDKDSM52fan3/ioeZ1Qfer18CYNvCyw6APX1i8SY8k
	IsD7975JS3NQtFn6h7dLFpGfGiKN3T65WO0G4CGkHuGqcSttpi86QJV9tQ7DAw==
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 21 May 2026 12:16:01 +0200
Message-Id: <DIO9YUHO5VGT.3BLGH04NVJNHP@bootlin.com>
To: "Goetz Goerisch" <ggoerisch@gmail.com>, <paul.louvel@bootlin.com>
Cc: <herve.codina@bootlin.com>, <miquel.raynal@bootlin.com>,
 <stable@vger.kernel.org>, <thomas.petazzoni@bootlin.com>, "Herbert Xu"
 <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Sasha Levin"
 <sashal@kernel.org>
Subject: Re: [PATCH] crypto: talitos - fix rename first/last to
 first_desc/last_desc
From: "Paul Louvel" <paul.louvel@bootlin.com>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <142603430.61540.1779296295550@app.mailbox.org>
In-Reply-To: <142603430.61540.1779296295550@app.mailbox.org>
X-Last-TLS-Session-Version: TLSv1.3

On Wed May 20, 2026 at 6:58 PM CEST, Goetz Goerisch wrote:
> Hi,
>
> Commit a1b80018b8cec27fc06a8b04a7f8b5f6cfe86eae
> was backported to 6.6.y with a866e2b1c65edaee2e1bb1024ee2c761ced335f8
> It renames last to last_desc but misses one occurrence which leads to com=
pile errors on mpc85xx

Hi Goetz,

Thank you for the patch. I did not catch that since I worked on a mainline =
tree,
and that specific line was removed in 9826d1d6ed5f ("crypto: talitos - stop
using crypto_ahash::init"), which was not backported into the stable tree.

> drivers/crypto/talitos.c: In function 'ahash_digest':
> drivers/crypto/talitos.c:2204:16: error: 'struct talitos_ahash_req_ctx' h=
as no member named 'last'
>  2204 | req_ctx->last =3D 1;
>       |        ^~4
>
> Fixes: a866e2b1c65e ("crypto: talitos - rename first/last to first_desc/l=
ast_desc")
> Signed-off-by: Goetz Goerisch <ggoerisch@gmail.com>
> ---
>  drivers/crypto/talitos.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
> index 347483f6fc5d..ed160c591346 100644
> --- a/drivers/crypto/talitos.c
> +++ b/drivers/crypto/talitos.c
> @@ -2201,7 +2201,7 @@ static int ahash_digest(struct ahash_request *areq)
>  	struct crypto_ahash *ahash =3D crypto_ahash_reqtfm(areq);
> =20
>  	ahash->init(areq);
> -	req_ctx->last =3D 1;
> +	req_ctx->last_desc =3D 1;

Instead of renaming req_ctx->last, commit 9826d1d6ed5f8 ("crypto: talitos -=
 stop
using crypto_ahash::init") should be applied. Ideally before commit
655ef638a2bc ("crypto: talitos - fix SEC1 32k ahash request limitation") to
avoid any compilation breakage and ensure correctness of the code.

> =20
>  	return ahash_process_req(areq, areq->nbytes);
>  }

Paul.

--=20
Paul Louvel, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

