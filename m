Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B4E268690
	for <linux-crypto@vger.kernel.org>; Mon,  1 Jun 2026 08:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780301189; cv=none; b=fB5p+tLYy2BvEHML91kR9m1Ve8rZUUNpkjpbxKwJk08qYe5YhyCPsJaIpwG9BbQu5uf5entEc39zv3moVw/WfbcdjQ6zKZRGIzyKxN3HDMxTLH8t1nXKT3hk3wkGNes4Rm3Vm4vGPlu3mA3v9CI2WY05D0KYdTRdyNq8uxSEUZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780301189; c=relaxed/simple;
	bh=dM6cx4Hz3ukX4C3/N5u+oLvLJus5S+gqleuClEZRS54=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=c0Rt/uwu7BMMv5Q+5Nxe3iL0753Me1p4XYWlNP/5v2JgshKXHVIlIXjdVvPnZEmFlPKx8R0baYo0HV7ZGsXUGqjUYgPMUQiH+UwUKJ6JfL/10I0QOEMUGoQkVwEOIhlXkZ7l6n0uwWWPecf3Iowd73GpTL0wofJp09PSjESZuv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=fO5csgor; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="fO5csgor"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id A0D374E42DD2;
	Mon,  1 Jun 2026 08:06:25 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 78A09602AB;
	Mon,  1 Jun 2026 08:06:25 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 23F6910888080;
	Mon,  1 Jun 2026 10:06:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1780301185; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=jOEH6LRldGuuxFCs4i2rSboeta0VcGI5PWsVx+/Sj88=;
	b=fO5csgortCndD17Q6OKyM0xqyDW4gZc+nX/9P3qY+HOWzpDsfsjpqLFk39baFdKPqR5nkX
	1uRZJLdouxlQ3FzYgEXrfHHXf7wdH8WSsE/TXcCQkrLOxMComVeWoogv5N2G0JaWC0X0Dz
	m+9lE5FmhutyOiYeFuGhLgQrN4opCT/1lfzTycDcCEPQxARw8auoXtQjBWJ2hYa7HQgfpb
	ByTGBKXlZRFcpHNVmyYRgPGE185Oevw7/Z3NKFe5/YkcltGJEgjRnb1TsXWFhAP1ZNTVZx
	MJGokb7ztwzGJvRa1stV4eNKjgpNY68A3HB2GJHfmKBjIu2PfRwjGYJochzlHQ==
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 01 Jun 2026 10:06:20 +0200
Message-Id: <DIXK3JN49LF0.4TB3XST1UHTX@bootlin.com>
Cc: "Thomas Petazzoni" <thomas.petazzoni@bootlin.com>, "Herve Codina"
 <herve.codina@bootlin.com>, <linux-crypto@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/29] crypto: talitos/hash - Use
 CRYPTO_AHASH_BLOCK_ONLY API
From: "Paul Louvel" <paul.louvel@bootlin.com>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Paul Louvel"
 <paul.louvel@bootlin.com>, "Herbert Xu" <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260528-7-1-rc1_talitos_cleanup-v1-0-cb1ad6cdea49@bootlin.com>
 <20260528-7-1-rc1_talitos_cleanup-v1-1-cb1ad6cdea49@bootlin.com>
 <f70f5279-e136-467a-8306-a1af1ea27015@kernel.org>
In-Reply-To: <f70f5279-e136-467a-8306-a1af1ea27015@kernel.org>
X-Last-TLS-Session-Version: TLSv1.3

Christophe,

>
> I have a build failure with this patch:
>
>    UPD     include/config/kernel.release
>    UPD     include/generated/utsrelease.h
>    DESCEND objtool
>    INSTALL libsubcmd_headers
>    CC      drivers/crypto/talitos.o
> drivers/crypto/talitos.c: In function 'talitos_cra_init_ahash':
> drivers/crypto/talitos.c:3150:34: warning: statement with no effect=20
> [-Wunused-value]
>   3150 |                                  sizeof(struct=20
> talitos_ahash_req_ctx));
>        |                                  ^~~~~~
> drivers/crypto/talitos.c:3150:70: error: expected ';' before ')' token
>   3150 |                                  sizeof(struct=20
> talitos_ahash_req_ctx));
>        |=20
>       ^
>        |=20
>       ;
> drivers/crypto/talitos.c:3150:70: error: expected statement before ')' to=
ken
> make[4]: *** [scripts/Makefile.build:289: drivers/crypto/talitos.o] Error=
 1
> make[3]: *** [scripts/Makefile.build:548: drivers/crypto] Error 2
> make[2]: *** [scripts/Makefile.build:548: drivers] Error 2
> make[1]: *** [/home/chleroy/linux-powerpc/Makefile:2141: .] Error 2
> make: *** [Makefile:248: __sub-make] Error 2
>
>

Thanks for reporting,
Paul.

--=20
Paul Louvel, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

