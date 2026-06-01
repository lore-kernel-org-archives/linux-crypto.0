Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93A633F590
	for <linux-crypto@vger.kernel.org>; Mon,  1 Jun 2026 08:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780303788; cv=none; b=ATIDgPKxaoe0z0OMdmmQFfpdDBCw92fELJQARqTeT2bia3zQ6Us7Oxg6I5KbeWTWTmCYRYD2Mq/iYGtqzovnoFKdKv7eN0eUHAmcAfN71IBwygRjDUJ9IhDFbZ6QpW2Bl68cYkrmfQommzEN5XCaEi1XiwXY/R4GhEBA3WaIsu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780303788; c=relaxed/simple;
	bh=jWIevYRR8qoruIyIUtQAXdGenVw6PmWlTptff/3IAig=;
	h=Content-Type:Date:Message-Id:Cc:Subject:From:To:Mime-Version:
	 References:In-Reply-To; b=fKkefLll/r9OZK0aYcjBIng5Ka7XaNtVi/WlDqGDsOFCVvVHUZgVUqunDFrzQrb4HyhBem5E4LvNdGxzps4xCLxMcQwcnGe+j0DMfdHTsA2giQoE3MUvssRa/r3BbCpBAKVGnlS4IKknKsZKfE/Vl0t6djl3BJU8ZiFVzvnG3Nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=CjrvcpnL; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="CjrvcpnL"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 0E3261A3794;
	Mon,  1 Jun 2026 08:49:41 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id D1D5B602AB;
	Mon,  1 Jun 2026 08:49:40 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 61D55108881D6;
	Mon,  1 Jun 2026 10:49:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1780303780; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=jWIevYRR8qoruIyIUtQAXdGenVw6PmWlTptff/3IAig=;
	b=CjrvcpnLbB1+TPVtILwihqfPYng6+dWDzbGdGsSDMNJJolXeKpNGjkC3V1e+X2qZYPzbOi
	kXTJHLWB7xddFoZ21oVN5eM274IWcpQxm+DOzDBsG9scjXsnybnyZ9rMVt9qVdTQxjk6rS
	b0hZbaTvz0Ax8AEAiHfBsPjKbE+hW6EPUnHnV8Jk+qzSTjDIRMzS90WREWJ6BWhGt2RnCJ
	zhEECphBF8aRS3WgZukEtl4ESYqpY5MTRifOKIBPu5v6RICi/W6DfESYih0NObcRAa3dzW
	aLuSmsLVzlIvwEEzMb9obITnlm1/1PkUVxpIW89IX8kNr2IrUFQFupRIVvZ6BA==
Content-Type: text/plain; charset=UTF-8
Date: Mon, 01 Jun 2026 10:49:36 +0200
Message-Id: <DIXL0OBC6IP9.3UNVLNBMZ7EZ9@bootlin.com>
Cc: "Thomas Petazzoni" <thomas.petazzoni@bootlin.com>, "Herve Codina"
 <herve.codina@bootlin.com>, <linux-crypto@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/29] crypto: talitos - Prepare crypto implementation
 file splitting
From: "Paul Louvel" <paul.louvel@bootlin.com>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Paul Louvel"
 <paul.louvel@bootlin.com>, "Herbert Xu" <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
 <20260528-7-1-rc1_talitos_cleanup-v1-5-cb1ad6cdea49@bootlin.com>
 <22245899-e046-41f1-8707-94f172b310e9@kernel.org>
In-Reply-To: <22245899-e046-41f1-8707-94f172b310e9@kernel.org>
X-Last-TLS-Session-Version: TLSv1.3

Hi Christophe,

> Le 28/05/2026 =C3=A0 11:08, Paul Louvel a =C3=A9crit=C2=A0:
>> Remove the static qualifier on multiple function that will be called
>> inside each crypto implementation file.
>> Add them to the main driver header file.
>
> I didn't have time to look at the generated text yet but I'm a bit=20
> sceptic with this change, or more than the change itself, about its=20
> purpose. And even more when I see patches 24 and 25.

About patch 24 and 25: one of the main purpose of this series is to get rid=
 of
the is_sec1 scattered around the core code of the driver.

> Most functions here are small helpers. To be shared between several C=20
> files they deserve becoming static inlines in talitos.h, not global=20
> functions.

I did not look at the generated text either for this change but I bet the
compiler is inlining these calls. Adding them as static inline is more expl=
icit.

I understand that there is a performance penalty, since there will be no
inlining, and a memory dereferencing for a call through function pointer.

> Indeed, most of the time is_sec1 is known at build time because in most=
=20
> cases has_ftr_sec1() will constant fold into true or false during build.=
=20
> This is because it is very unlikely that someone build a kernel to run=20
> on both MPC 82xx and MPC 83xx at the same time. Therefore it is really=20
> unlikely that this in built with both CRYPTO_DEV_TALITOS1 and=20
> CRYPTO_DEV_TALITOS2 at the same time.

As for patch 24, 25 and onwards, the same space optimization apply here. If=
 the
kernel is built with CRYPTO_DEV_TALITOS1, there will be no SEC2-related fun=
ction
in the generated text, and vice versa.

>
> I can understand for a function like talitos_submit() but not for=20
> functions like to_talitos_ptr() or to_talitos_ptr_ext_set() whose=20
> purpose is really to get inlined into the caller.
>
> Christophe
>

These changes are needed to split the driver into multiple files.

Best regards,
Paul.

--=20
Paul Louvel, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

