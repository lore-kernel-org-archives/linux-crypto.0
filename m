Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F5B49B1E1
	for <linux-crypto@vger.kernel.org>; Wed,  2 Sep 2026 11:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788350340; cv=none; b=ZOupTN9uLAM05uHRadZpTf4k7LVPSeK/o37hi/8TXYLCr399IZ/wHZ8eqkfD4g29TUqZCslO3XeQezUuUNOfSOXiCCoc6d1bLT8ZrsG5rSa0UuTHiE2l6CoQDdOPaknDDRr/fQ7BVNzYE/nD4sTYL8ZCs9duweOVQBVMhzP/bOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788350340; c=relaxed/simple;
	bh=D231sYpNvPXi3QG2syP6L8V0BuwGKvnwBXeth/8D62M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a6c7ql6Sp+yA7yaQBvs0bGq5bnPYqS/HEYmdvaPLAIqVCfHcPipfejDuRDRwn1NVbqIJqhma4Gc+oC0YNwE5UyMBEzxs+j+/DlSCyYBw5STSlB9dataKouhVHLJ/UZi2Kg/1KFe5r009ebPjL+M/tQMmUOSM8lYOW/fEjnKkicc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=2bmN0L/U; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="2bmN0L/U"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 834DC4E414CA;
	Wed,  2 Sep 2026 11:58:42 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 508F56053C;
	Wed,  2 Sep 2026 11:58:42 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id B205011C79305;
	Wed,  2 Sep 2026 13:58:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1788350317; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:content-language:in-reply-to:references;
	bh=Argkh8fOXqu3RtX8B0Djo/lbWhOGIiKDY4XvkMuUyEA=;
	b=2bmN0L/U/l1wkab6qS0vlVWsFLQHTytjpDHHd9KVDU17A/duoDcrYhRAjOfmitfZQBpXM7
	K5ebNKDACTbEFkmNkk12AHbixpCyOwOyF8QAfsbpcUNymeWnosXxQ1N6X3ymUy/o+Dj6hG
	HjObCpcGtSc4W+0KEt7ApJjbEJW48+riOKCdjG9NFKEs9E/o2+kwV+ksS1zjWIgABMIJOi
	9H6c9WtaS5WL8oI2p+TMjKnCigoEgrYtsGiVY4ClCkRkj32tDfyPaQHk5wMajfIQaAY9ip
	x7tG1Ztycr+IEMJ8iScFM+N8eZWgVdQZereVEbkzcAyOcNHVpxj5aqVgAbbF2A==
Message-ID: <c413ff04-61bd-4352-98fe-c2c01f075042@bootlin.com>
Date: Wed, 2 Sep 2026 13:58:33 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ECDSA key parsing in crypto drivers
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 Miquel Raynal <miquel.raynal@bootlin.com>, Jian Pan <jian.pan@se.com>,
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>
References: <34094aaa-da49-4203-b176-ed3faa4b8692@bootlin.com>
 <41bb0b65-3a30-4922-9aef-10f73c654852@bootlin.com>
 <apff2HnJS3IjlT4p@gondor.apana.org.au>
Content-Language: en-US
From: Paul Louvel <paul.louvel@bootlin.com>
In-Reply-To: <apff2HnJS3IjlT4p@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Last-TLS-Session-Version: TLSv1.3

Hi Herbert,

On 9/2/26 10:35 AM, Herbert Xu wrote:
> On Mon, Aug 31, 2026 at 02:08:02PM +0200, Paul Louvel wrote:
>>> My question is: which ASN.1 schema should be used? Should a client of the
>>> crypto API know in advance which format the driver expects? Also, for RSA,
>>> there are helpers for parsing private and public keys: rsa_parse_priv_key() and
>>> rsa_parse_pub_key(). These helpers use the kernel's ASN.1 decoder. Would it
>>> make sense to have such helpers for ECDSA?
> The driver needs to match the generic C implementation of the
> same algorithm.
>
> Cheers,

By "generic C implementation", do you mean the implementation in ecdsa.c ? For
verify operation, this is clear. But signing is not implemented, so there is no
callback for setting the private key.

Best regards,

-- 
Paul Louvel, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

