Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094C53D1CAA
	for <linux-crypto@vger.kernel.org>; Wed, 25 Mar 2026 12:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774441582; cv=none; b=oz+TpYVuSOX8hmYUht6SngGiwrabY9Iwrekh/pUKG3DUI3GUklf+reluIkCoMEgd+LtjEFKCkK469yWLUuhOwarVYYSftEZE3QN5G/oMPaCFUI+65SPqx0kQiAy4hp08JkAmbM6DABmOgi2PQ8MBNJAZRu/13ipc38bYzxZ0Nqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774441582; c=relaxed/simple;
	bh=NZmy9A71+mGjb0JyggN74KFegUmUlepYAcOg34BAaFw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:Cc:
	 In-Reply-To:Content-Type; b=YN8PcT/+fZ8fu3EtkYMjQPMVsQ08oQ4ZpIk+A7tSjiT2SwN5rK7sX6CqhuLybFSXhmbuZS/O21hLBzCcqKGSjLcDfCpiAPHzeYxd8ZW+DsHW9L8KLAAjMwEEmom+SKJH7r9ausjiW5D6Xm5IhpHAvZ1Y3xyzilxV1f1fBkuoqVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=EF5MXwAS; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="EF5MXwAS"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id C38201A2F86;
	Wed, 25 Mar 2026 12:26:19 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 9137C601E2;
	Wed, 25 Mar 2026 12:26:19 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 882C910451362;
	Wed, 25 Mar 2026 13:26:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1774441578; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:content-language:in-reply-to:references;
	bh=Nsz0GR6Zk0VoXYbxqVh2SRpOfgafRwZhwcA2/A7RPXA=;
	b=EF5MXwASWIYiahatIX3d0Mo/1pBcLlgzcwZ0RYJmtK3/S9xwyWTEu2h5YFT4hR1SafkZby
	tj04jSrlt57xTQDZ/1n4QbL/mNTyi5O9PeC/ucUnLCoLqCiIOThjaB1JkMzlN6WXdyGO+X
	07V8nxfwQS0rXkwfKC8HRbUydvzhWK3FakHHJ2KeXD9poL9hzz4T6DUJfHekHskUoEY/VF
	vHzSLjbnTVv26B+8qeTITwbjvV7Yri0ZFejHF/CBHSnJJSyAHFjbFJWiO3kXJ2BKTb4zZi
	AbetPhsgpnJQOxGQVLtAuqlpc5Q+/iYykuIeiFRdnx0Qw7pKz4PNxMW1TQPT+Q==
Message-ID: <b53feadd-8246-43cf-a768-740cb73d2553@bootlin.com>
Date: Wed, 25 Mar 2026 13:26:16 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Need some clarification about CRYPTO_AHASH_ALG_BLOCK_ONLY
From: Paul Louvel <paul.louvel@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
References: <4f93481a-a0e5-4a9f-8aae-00d3189ccc58@bootlin.com>
Content-Language: en-US
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4f93481a-a0e5-4a9f-8aae-00d3189ccc58@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Last-TLS-Session-Version: TLSv1.3

Hello,

I forgot to include the maintainers in the initial e-mail.

Additional link to the source code :
https://elixir.bootlin.com/linux/v7.0-rc1/source/crypto/ahash.c#L467

Thank you,
Paul.

On 3/20/26 10:42 AM, Paul Louvel wrote:
> Hello,
>
> I have stumbled across a flag defined in include/crypto/internal/hash.h : 
> CRYPTO_AHASH_ALG_BLOCK_ONLY.
> To get more information about what exact behavior this flag do, I read the 
> crypto_ahash_update function.
> From the looks of it, it seems that the API will call the tfm update if there 
> is enough bytes (and by enough I mean at least a block size), from the 
> internal buffer and the incoming ahash_request.
> In this case, I find the BLOCK_ONLY naming a bit of a misnomer, since it only 
> guarantee you than req->nbytes will be at least a block size.
> I initially though that the API would only give a request that are a multiple 
> of the block size.
>
> This flag, among others, are relatively recent.
> I think adding documentation about these flags would be a great idea.
>
> Regards,
> Paul.
>
-- 
Paul Louvel, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

