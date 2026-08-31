Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352433DE43E
	for <linux-crypto@vger.kernel.org>; Mon, 31 Aug 2026 12:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788178099; cv=none; b=JsbGahvKw1G2uFCeWf1omeaE9fcscQd/Ucz08DoRLGmi09mdNM3cL1UOeUgVKHyFVb7y1mWEQUgAzuyqkoyJAfBAHFVh6lHFIRb9/JdcJ9wBYa5gXrCNLFnEIvfAGrrAoZG2mpg1qknmluhHa4QCATOP/2XqCSHWxYSwIWj4IZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788178099; c=relaxed/simple;
	bh=uaVHbHk7M9IGTybf9q0hDQElbdiNj1LNaTPfuiAnnWc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=pZoa71kG688o3ID6DxDgQDDzse5b2SmveWNqXs+IgDwEGxoN2aCxvK8Ekz86QNdSlNzqHr598g/4nzV2QDPg4d9IZgIlkmBhvZob0VySKLTNrRkPPaCYuwHZH+oMj1TJExmkUsim7fHf4kYK1Ay90MJcLCp3CdmNMmQs9oVkLC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=dPPHuMpp; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="dPPHuMpp"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 25E674E41488;
	Mon, 31 Aug 2026 12:08:14 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id D9E2C6054B;
	Mon, 31 Aug 2026 12:08:13 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 63BFB11C78AE0;
	Mon, 31 Aug 2026 14:08:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1788178087; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:content-language:in-reply-to:references;
	bh=aZ5+lPFAk7HjRgWCwnN8U+IoVeVmfO1YLxxwKDuIJLE=;
	b=dPPHuMppCmZRG/jS1t/O8otBqshafZygC6XeAsEkZqIY0Qiq/o/gOkWx7SCrqAcoO6uqMc
	8G2h3KJPKot71TND7dZofYawf7MxikONGbIoUWiq8TS3ps1cC0SCgZc3RCByDLDsgx3Gu0
	xIleC78D2j8yCpnTf3hiaMa0mSKF0QfF6z18WjHNKs+gDTmmK8RKkjRehjjKJf2I8OF1Wy
	wC1PO8Sw0nvNyqINrrNMQ9vRG6KknX2zIVqzXnbBIu2hbzlj3H0nSXpsEa8ctnBG0riz0w
	fzBJqJzZ5sPG16FhWhMcbYL69akPHJfT1VL08FfcfLFdKKsth3g9NXI98bzizw==
Message-ID: <41bb0b65-3a30-4922-9aef-10f73c654852@bootlin.com>
Date: Mon, 31 Aug 2026 14:08:02 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ECDSA key parsing in crypto drivers
From: Paul Louvel <paul.louvel@bootlin.com>
To: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>, Jian Pan <jian.pan@se.com>
References: <34094aaa-da49-4203-b176-ed3faa4b8692@bootlin.com>
Content-Language: en-US
In-Reply-To: <34094aaa-da49-4203-b176-ed3faa4b8692@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Last-TLS-Session-Version: TLSv1.3

Adding Herbert Xu and David S. Miller as recipient.

On 8/31/26 11:09 AM, Paul Louvel wrote:
> Hi,
>
> I am currently working on upstreaming the ECDSA part of a Public Key
> Accelerator.
> I have a question regarding which ASN.1 schema should I use when decoding the
> buffer passed by the .set_pub_key() and .set_priv_key() callbacks in struct
> sig_alg.
> The documentation only mentions that the callbacks should "know how to decode
> and interpret the BER encoded public key and parameters."
>
> The kernel software implementation of ECDSA only supports verifying signatures,
> and thus only implements the .set_pub_key() callback. In this callback, the
> buffer should contain an ECC key as defined by RFC5480 section 2.2 [1].
>
> In the downstream driver I am currently upstreaming, it expects a BER encoded
> ASN.1 schema of SubjectPublicKeyInfo as defined in RFC5480 section 2 [2]. The
> driver defines its own .asn1 file containing the ASN.1 schema of this sequence,
> and uses the kernel's ASN.1 compiler/decoder to decode the buffer.
>
> Because the PKA can be used to sign messages, there is a .set_priv_key()
> callback that expects a BER encoded ASN.1 schema as defined in RFC5915 section
> 3 [3]. The same remark applies to the public key: a .asn1 file is present and
> defines the ASN.1 schema described by the RFC.
>
> My question is: which ASN.1 schema should be used? Should a client of the
> crypto API know in advance which format the driver expects? Also, for RSA,
> there are helpers for parsing private and public keys: rsa_parse_priv_key() and
> rsa_parse_pub_key(). These helpers use the kernel's ASN.1 decoder. Would it
> make sense to have such helpers for ECDSA?
>
> Thank you,
>
> [1] RFC5480 Section 2.2 - ECC Key Format
> https://tools.ietf.org/html/rfc5480#section-2.2
>
> [2] RFC5480 Section 2 - SubjectPublicKeyInfo
> https://tools.ietf.org/html/rfc5480#section-2
>
> [3] RFC5915 Section 3 - Private Key Format
> https://tools.ietf.org/html/rfc5915#section-3
>
-- 
Paul Louvel, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

