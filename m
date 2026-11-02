Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793635257;
	b=3WUjoPjN3bD6bs/P5K7OL3BbM3HhBc9SCmXrZHuIPZjGez/R71P67h+CteWzYhf0lVPq
	 aNUBSR4YQJcjUw7ff4XK+ev4s2Tf7Jpf4eza5feh+sPDEwOLxXLQGgNI8t+9MSEgsk2dt
	 3WCKjU41M1WQ/Hb7sDfQ+Q0plDB++mlUxOHXfDMSOnJ3tFg2dj1w6YIMM/udW1+f2CRgH
	 /To/t1nGZ250nNzMD2Bem0TweZ1wt05qQbpY2Fo4+ECuELqQqz4jnnigv8svfZa6y8g7U
	 3VLlp++NyhmbEZjf0MBEDxbsod/iEsZjiisSFPgdzs+qqxKeYpU3UeMrgVBjP20YuhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793635257;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Pt8TVBLj+aue5/olEE3IwKpFODSJf5c35bOqyoXE5JM=;
	b=V9UI/QbLUwPvY5+midbVrCn6lW9dFnVVVgp7YXnKkIrmXnl4Tz90fRdN/0qKcRuqsT68
	 K4C8A3FX5Jovo5QxOHs++RU0KloCP1X1TZukjPqpWyZiJBc1rd/aQxb5OCgaKZnnrmnpj
	 T1vsYeyYh+6MJCuJXni7gRLr6v/s97TcbxSXXcrHp6XyoTHJXWv3d1cdSim1+UOidRu2U
	 FSKSdTJgJ3Wmtu+8CMxhntTA12lW8bOcrhN0gpMTs5nUUDEI2aLi7bIJitWtuz0XHJtoB
	 rZcAvc4aOL+MTKyirZw5D8WPfKfTM8V6cXjEnB3ms7OIpUh9CdpKim6e2ZiJJ4/QnSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SYAg2MlT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B12606A5A8
	for <linux-crypto@vger.kernel.org>; Mon,  2 Nov 2026 16:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SYAg2MlT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 086561F00A17;
	Mon,  2 Nov 2026 16:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793635256;
	bh=Pt8TVBLj+aue5/olEE3IwKpFODSJf5c35bOqyoXE5JM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SYAg2MlTtc1FLKdUflrImz5Exq9+eaYFYu1B31JTcElUSlv0gZeSTrP2pSCZbyotZ
	 cdL8Thj0u5jeRKEjcNC7i28s9MZ03Z7Ld0h0Kad49fh3efQab2HAeQSYID4oa9yvrq
	 uwCnrZNN04VkuZqs47wtuLr2Xxa0dljUErX2/caDnTt2cpdBiMRAsPeaR2AnVnYrEI
	 3UzUIjEqJUOz2pjcsPF33KpG/cBsxN7lNceCHhdrM/v82UxA2hMNY/yeRse895argR
	 AdVhhebHARNF/IjI50Q8HceDIdp2gqkvuuhn+iTw2nZ46CpzGwaHl1oTdfRpAaX0rR
	 AYShCOCEZP6qA==
Message-ID: <sashiko-outbox-193718@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] padata: fix lockdep warning in padata_find_next()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tristan Madani" <tristmd@gmail.com>, steffen.klassert@secunet.com, daniel.m.jordan@oracle.com
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org, "Tristan
 Madani" <tristan@talencesecurity.com>
In-Reply-To: <20261102155353.1268322-1-tristan@talencesecurity.com>
References: <20261102155353.1268322-1-tristan@talencesecurity.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 16:00:55 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] padata: redundant spin_lock_nested() in padata_find_next() split=
s lock class
--

commit d8de136037d32da1b6bd4096b78d163c014e8d23
Author: Tristan Madani <tristmd@gmail.com>

padata: fix lockdep warning in padata_find_next()

This commit replaces spin_lock() with spin_lock_nested() in
padata_find_next() to annotate acquiring reorder->lock while
padata_reorder() holds squeue->serial.lock.

> diff --git a/kernel/padata.c b/kernel/padata.c
> index 5a113c667d4cb..94d7880a001c4 100644
> --- a/kernel/padata.c
> +++ b/kernel/padata.c
> @@ -253,7 +253,7 @@ static struct padata_priv *padata_find_next(struct pa=
rallel_data *pd, int cpu,
> =20
>  	reorder =3D per_cpu_ptr(pd->reorder_list, cpu);
> =20
> -	spin_lock(&reorder->lock);
> +	spin_lock_nested(&reorder->lock, SINGLE_DEPTH_NESTING);

[Severity: Medium]
Is this spin_lock_nested() annotation still needed here, and does it split
reorder->lock across two lockdep subclasses?

In Linux, spin_lock_init() assigns a lock_class_key per macro expansion site
rather than per C struct type. Historically, squeue->serial.lock and
reorder->lock shared a lockdep class because both were initialized via a
common helper __padata_list_init() (and padata_find_next() was moved inside
squeue->serial.lock in commit 71203f68c774 ("padata: Fix list-related race
in padata_find_next"), rather than commit 16295bec6398).

However, commit af3852cda347 ("padata: remove __padata_list_init()") removed
that helper and initialized the two locks at separate spin_lock_init() call
sites in kernel/padata.c:

padata_init_squeues()
	INIT_LIST_HEAD(&squeue->serial.list);
	spin_lock_init(&squeue->serial.lock);

padata_init_reorder_list()
	INIT_LIST_HEAD(&list->list);
	spin_lock_init(&list->lock);

Because squeue->serial.lock and reorder->lock already have distinct lockdep
classes, acquiring reorder->lock inside squeue->serial.lock does not trigger
a recursive locking warning on current kernels.

Meanwhile, padata_do_serial() acquires the same reorder->lock at the default
subclass 0 before calling padata_reorder():

padata_do_serial()
	spin_lock(&reorder->lock);
	...
	spin_unlock(&reorder->lock);

	if (gotit)
		padata_reorder(padata);
			spin_lock(&squeue->serial.lock);
			padata_find_next()
				spin_lock_nested(&reorder->lock, SINGLE_DEPTH_NESTING);

Won't annotating reorder->lock with SINGLE_DEPTH_NESTING in
padata_find_next() while padata_do_serial() acquires it at subclass 0 cause
lockdep to track the same physical lock as two separate subclasses, hiding
lock ordering dependencies between padata_do_serial() and
padata_find_next()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102155353.1268=
322-1-tristan@talencesecurity.com?part=3D1
