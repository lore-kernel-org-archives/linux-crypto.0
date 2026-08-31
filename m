Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05EF22D9EDB
	for <linux-crypto@vger.kernel.org>; Mon, 31 Aug 2026 09:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788167376; cv=none; b=eFyCz3bJlGuhfeBu99OJ2WmbaPDND/Vn4yLTUYvTXJtv2sMGNvuLeiV5KYy21DpLuS6SRHl81Nv0c2UkuIa5mo8blOLHhwJY+D3bJ48yPdue7Gp49fGKMMvSwwZsKWEm6nmW4RGhsHiXaSiX8dtVAshRSAJVXG68zhTX0J+m7Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788167376; c=relaxed/simple;
	bh=CM27XdfXzlAt2YX/Yyv+oZnaq8tkUaLo/uohsSh4wtg=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=FKXDGKuMJdZnePTULBrROcg6F/unuC0dOPh5vVGd1EAjgMeR8UnlBDyyqDnp+0pzGRQ/XLbsN6Ga92juN9hGsOehCQKYLZgir8NI2x2L9qsJbgIn0B657ziut4x3s0ZcBuMCzXNg98lHNWh2RU59t8qUZrvw6T86U7a6DotPjBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=fFnAx8lQ; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="fFnAx8lQ"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 56E2C1A18ED;
	Mon, 31 Aug 2026 09:09:31 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 2B79760231;
	Mon, 31 Aug 2026 09:09:31 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 03B1C11C78AE3;
	Mon, 31 Aug 2026 11:09:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1788167366; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:content-language;
	bh=c0BR+dsQEncxRDdVU1dh1qyWGTdbrAOzg3TVqsPblzc=;
	b=fFnAx8lQ2xI3ekDBqUzSJx1lz321FU9tE/5Ehj5FtD7Fx1svKJKnPSECedR1fzmgcvxrcI
	JItVUnXdRsjNyG/g0Vry4DkvSY+3lOuiY2aOQTASZMCpz2dATn9iXY2HgJ7qBxdo6OE9Va
	jb6OORDgAunfLY3oPtOTcYLSfLVonQqC2LNP3KMXoyS5P2TFGRLqNM529XqgdWZKRt2Af5
	YrYzYaeYeeKib/Sdt28ZXxnOI22hueCsMtuvjDb2CuKALvslcHUWjcPVjA5Z/ickmOYtvy
	XM55Tmj4QSKzIc7z6jupmL/GjqfCQRL3VPvPOEQGrRkHTP6j9SUyv5FoUYmkDg==
Message-ID: <34094aaa-da49-4203-b176-ed3faa4b8692@bootlin.com>
Date: Mon, 31 Aug 2026 11:09:25 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-crypto@vger.kernel.org
Cc: Miquel Raynal <miquel.raynal@bootlin.com>, Jian Pan <jian.pan@se.com>
From: Paul Louvel <paul.louvel@bootlin.com>
Subject: ECDSA key parsing in crypto drivers
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Last-TLS-Session-Version: TLSv1.3

Hi,

I am currently working on upstreaming the ECDSA part of a Public Key
Accelerator.
I have a question regarding which ASN.1 schema should I use when decoding the
buffer passed by the .set_pub_key() and .set_priv_key() callbacks in struct
sig_alg.
The documentation only mentions that the callbacks should "know how to decode
and interpret the BER encoded public key and parameters."

The kernel software implementation of ECDSA only supports verifying signatures,
and thus only implements the .set_pub_key() callback. In this callback, the
buffer should contain an ECC key as defined by RFC5480 section 2.2 [1].

In the downstream driver I am currently upstreaming, it expects a BER encoded
ASN.1 schema of SubjectPublicKeyInfo as defined in RFC5480 section 2 [2]. The
driver defines its own .asn1 file containing the ASN.1 schema of this sequence,
and uses the kernel's ASN.1 compiler/decoder to decode the buffer.

Because the PKA can be used to sign messages, there is a .set_priv_key()
callback that expects a BER encoded ASN.1 schema as defined in RFC5915 section
3 [3]. The same remark applies to the public key: a .asn1 file is present and
defines the ASN.1 schema described by the RFC.

My question is: which ASN.1 schema should be used? Should a client of the
crypto API know in advance which format the driver expects? Also, for RSA,
there are helpers for parsing private and public keys: rsa_parse_priv_key() and
rsa_parse_pub_key(). These helpers use the kernel's ASN.1 decoder. Would it
make sense to have such helpers for ECDSA?

Thank you,

[1] RFC5480 Section 2.2 - ECC Key Format
https://tools.ietf.org/html/rfc5480#section-2.2

[2] RFC5480 Section 2 - SubjectPublicKeyInfo
https://tools.ietf.org/html/rfc5480#section-2

[3] RFC5915 Section 3 - Private Key Format
https://tools.ietf.org/html/rfc5915#section-3

-- 
Paul Louvel, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

