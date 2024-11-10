Received: from mout.web.de (mout.web.de [212.227.17.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB734F9DA;
	Sun, 10 Nov 2024 09:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731231120; cv=none; b=IKqhxEFUgEvgW8kyYyMm3jNsk/DMjp+47nToKiFx2Ri9MU0zihlWYdKdOoVZA1WUHSZw7WjHrUf/1sbU83Jwah4alYvghBIb5cToOlYA45Yo+3CIK1gM98XV7mB59Sbl//hZ5GbfGbshePa8pxXY1HSE5pm31uTqg0athqy3AJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731231120; c=relaxed/simple;
	bh=rjrpZKboCeJvPg4Wde4QaFMKzZ2Rtol8hxYHZ62ymZk=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=nVmRT+O6Se51h3Fw2FENum6OSaYxjPdq5c15ktEbo1jofaoaurPOOTQ05izn1euciRepY6tVuGkR8hBkdueWLCKZzj5B7qb+BGrbAAaMCcfTD1hbPPYuOg9kKxwp4eMixIz4bTNycQhQg1vLP34L32/xbKg1rR9jxclnOOfarPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=GTv2pa0m; arc=none smtp.client-ip=212.227.17.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="GTv2pa0m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1731231115; x=1731835915; i=markus.elfring@web.de;
	bh=rjrpZKboCeJvPg4Wde4QaFMKzZ2Rtol8hxYHZ62ymZk=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=GTv2pa0m2emi6P+jT6hBQXUavBs8izuHEqZk+QMqPbqdREE0IsTu8MjUON2ak6qV
	 GrCo4H8ttl0TM1o4ZVmUEGbWrpvbXKCOpgw5dlRkByJwrt+n+vfp4LBmr/DFFpT3X
	 3ImI6JXuFzz2unldCGVh9JZP2PNAA3AV6KKBbbo0EQYEFUIS//UMhCecHhfrlQrZh
	 3lXgm0RvTXtQdOt+24PDUb+5xLzcREhfHEIoueIXwomvOA6FG0cYqIC0jGG0B/LCZ
	 Gpq2xhBqyechitBAFJqzzcw89aWGGS4NjQ0+9MP4arNVZxbIObycimLLm3aKM51CR
	 OviINEhC4hVfoqhzgA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.85.95]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MSIEs-1tKxFJ2Gc4-00IX1q; Sun, 10
 Nov 2024 10:26:17 +0100
Message-ID: <2d828178-c972-461e-973a-6983f3bf095e@web.de>
Date: Sun, 10 Nov 2024 10:25:53 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Mario Limonciello <mario.limonciello@amd.com>,
 linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 John Allen <john.allen@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>
Cc: Mario Limonciello <superm1@kernel.org>,
 LKML <linux-kernel@vger.kernel.org>
References: <20241109020054.3877377-1-superm1@kernel.org>
Subject: Re: [PATCH] crypto: ccp: Use scoped guard for mutex
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20241109020054.3877377-1-superm1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:BIEVjxNh9skkM6JNPD1UFgRwJGm8RgBhG5GT2E5cVsWlYGgnumb
 jMsnKQQ5ZDWvYdoC6agkOEt8pCOl/HZU6VlvVBgY4K9D+5pU8OXAzqFaGGKPx0L1Mm0Zov+
 iqC2177uKd0wZvsmtw/Z9spe7iV8sYxUXvX2G/2r1FJ4o3Z2sXyjWp/IgAc/d1iHfQdYxWn
 fdqn2uAMEysJqsIv8pmrg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:x957D6me1mA=;rEB3KkzsNIKk6E6jFAmiLDxCyN6
 HoeoQoz6Hgoat8LUH7phoApEI97vYhE2PRQGC2ns7n0PfIrMzdfnKJfTh3ITmPswYesDdrb1k
 n1OE/mJ3rqvAJurjgMMclO6IuVX9TcCII0oTCPgBzowBgzpVUq8Zgb/EYZOoKLR/mhqOSPkKS
 DIbaLCZNIRSeDzc5NqK94Ims8rV3JYMQGpx2b9PGRmJWTo8iCzjC931exjt7004ELYc7PzTix
 TWaZK4ab36q4fQbZRbIex1AjlDUmJPnrgDkC95o8tBGYotv0fZGk0xtli8cCWI4BWpz7xZ6d3
 ACQWefVRHBm0f9QtWt5DfFM8KzHjMpmU0WS6VKfwyM9gOhAucsQMKEHhY3QO2znRKHfVr3HBd
 XRiucYcg9kHC0MPCxRb4C2qkIHeLxTR7RpD7wgqpVhMfun3cCaVLIfujHl8l3oE6WSUZ7FfID
 cgm/+6pQoMpPqSlxAZU9M7QnTux5er+WEv5iiEe19sH1pt+a+2zOakx55QW2LAGfuDkr3xq9x
 sXVnFE6DpMknb2X8uEtI/tIH05FpyhJXpXKewAipTI7XRf8lu5nT6vfwoVNykCgCvPb1zUXGB
 xK/J2xOwjHuJ7TqElIJjCBqbOEdgY4qvRSWYkj1J07l1IVorPM3J5iPqbiNzTwXZmag5PPPX3
 iS4/BUzZiGwCxhUfic5g8X+GCtVdWKiI/J/MCMIgC5igGjMZw1NR0MiEGrhPtUg6t+AGgPIqs
 T6Tc5YDZaUIafwSTysTR2LW9Fbu+JlvakXJ0savmOOt3/QHH8SwlZt+vT0+mXSyPt89tt5sXv
 1Zm8af8EKumeuLVGkagdeRaUVDptQ6LkJIrJzazpTeDcO24BzaKVg5httclwVGyeUOwFuPzLf
 1+c1ct9zV+q7LOCTfega6p25fM5pSCcL4IneQCOB8+UTF6A4T0UBNcTAz

> Using a scoped guard simplifies the cleanup handling.

Will another imperative wording become helpful for an improved change description?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?h=v6.12-rc6#n94

Regards,
Markus
