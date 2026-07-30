Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C69400991
	for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2026 10:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785405657; cv=none; b=D/WSaaurmjGVvw79pEMkR2pUshXwrtXXbCRcFmZxd27DeCCV6rvWhgtxKsCYpIhZjXR8qtpHYmZAeoQbKqitSCSk94z1gD9UvoiNT5FaOVk1pDberWiiT9Ahjr/nuGp0mGlESASm6pKULXe+4eBv8akfbtfPAsx87Ml/wIItYmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785405657; c=relaxed/simple;
	bh=2aE4/gtJEqYKaBgbtT+vxFpTATlUhDBcRco2daW2WsA=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=jdsbmSStBioDiJON1wzMqFoetEvrr8CpdPCIT4r/bXh1gRqJlkm20IMDv9XEREnFCOtZBaOX701of935Xtz8FFiJKdh84DnI4XtmeNXXtW6YgJYFcvSHJnYsG5oIduob/miCy6sqM3IXGwkJZLEG9DybKoEEsV//SGPIGfgAHds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=gi1JUl/s; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="gi1JUl/s"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 444984E41001;
	Thu, 30 Jul 2026 10:00:48 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 1822E602B8;
	Thu, 30 Jul 2026 10:00:48 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 1BE6911C1597E;
	Thu, 30 Jul 2026 12:00:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1785405643; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=AyNjJKOPhsbLACNRJAnmbwDNBITLgF9GlmNSRZLg7f4=;
	b=gi1JUl/sDV7SYUOVFaA/clBCPgj6qkfADZdRfMIy3jYGQCRMHyyKGgFuQmvNNQl76y4HeH
	PUM1UkmUKvckie/+Wl2witpFTMZ+MBnG+ALMkJHZWmto003h+a55wWi31ILxRXlwWmGOET
	krJ0zso5qEfH2USACY4CJttmG2i8a/0I/SwH+Te7z3ipd/5SHRxU6AFrolwQq7DBBriSLF
	zzy2mtx+j04p7jMSMB905yj2rjdUkGAWS/sS0H1TV5aXUIOMaTou1s+Qi8EEfSnwePJgnb
	8XA1GXC2a8qlrEbl+x5XNAJ2k7Fwu7/6q0OgSu+NlYCN8wYc+qmX25e3wz23xw==
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 30 Jul 2026 12:00:38 +0200
Message-Id: <DKBTH7CXUX2R.S62IGDGU9MJZ@bootlin.com>
From: "Paul Louvel" <paul.louvel@bootlin.com>
To: "Herbert Xu" <herbert@gondor.apana.org.au>, "Paul Louvel"
 <paul.louvel@bootlin.com>
Cc: "David S. Miller" <davem@davemloft.net>, "Thomas Petazzoni"
 <thomas.petazzoni@bootlin.com>, "Herve Codina" <herve.codina@bootlin.com>,
 "Christophe Leroy" <chleroy@kernel.org>, <linux-crypto@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 00/19] crypto: talitos - Driver cleanup
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260722-7-1-rc1_talitos_cleanup-v4-0-81d1ed2ad911@bootlin.com>
 <amr62AUAifNXVIns@gondor.apana.org.au>
In-Reply-To: <amr62AUAifNXVIns@gondor.apana.org.au>
X-Last-TLS-Session-Version: TLSv1.3

Hi Herbert,

On Thu Jul 30, 2026 at 9:18 AM CEST, Herbert Xu wrote:
> On Wed, Jul 22, 2026 at 10:53:44AM +0200, Paul Louvel wrote:
>>
>> Changes in v4:
>> - The modification I did in v3 in PATCH 1 was incomplete. message_size
>>   was not initialized in ahash_init(), and not incremented in
>>   ahash_process_req().
>> - Link to v3: https://patch.msgid.link/20260721-7-1-rc1_talitos_cleanup-=
v3-0-7c71a2b77c83@bootlin.com
>
> Please check the Sashiko comments:
>
> https://sashiko.dev/#/patchset/20260722-7-1-rc1_talitos_cleanup-v4-0-81d1=
ed2ad911%40bootlin.com
>
> Thanks,

Thanks for notifying, I tend to forget to check it if they are not automati=
cally
send in my mailbox.

On the following remarks:

> Also regarding -EAGAIN, if talitos_submit() returns -EAGAIN to the generi=
c=20
> core, does the core handle it safely?
> Since we are now relying on CRYPTO_AHASH_ALG_BLOCK_ONLY, the generic core
> handles negative errors in ahash_update_finish(). If it sees an error lik=
e
> -EAGAIN, it clears the internal buffer length.
> Will this erase previously buffered partial blocks and silently corrupt t=
he
> hash stream under high load?

This is a non-issue, because such error make the core abandon the current
request, right ?

> MD5 mandates little-endian padding length, and HMAC also requires the inn=
er
> iPad length to be handled. Will this cause incorrect hash digests for=20
> messages whose length is an exact multiple of the block size?

Agreeing on MD5, and indeed with MD5 hash digests for message whose length =
is an
exact multiple of the block size, the hash is wrong.

The comment on HMAC seems wrong to me. The hardware performs IPAD and OPAD
operations automatically on the key data when required.
After some testing, I also don't found any obvious issue.

--=20
Paul Louvel, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

