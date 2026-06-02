Received: from mout.web.de (mout.web.de [212.227.15.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C738352026;
	Tue,  2 Jun 2026 19:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780428967; cv=none; b=KM3Hkszf6Ga3oF0gE593MYF1hbPtG5nijTk7G2hWvzYtnVtY1oqwiIWoO003zCbC5rWQNmghqJvpAi5Sw4nWdrjhZ0xF/V7TZkptAvEQGuhn3bGV8HNPL1JM5rN9w6lA+3+W0aCTIby3nJvqg+/OvyL7etYAWDZYKwHXabZVPbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780428967; c=relaxed/simple;
	bh=AEwi/fX0GckwwXDwibm4lMkFqJc3kAuC+908OxMyZno=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=ENMmslWkvkeRKaXJ7KSIRGtIwtoAgO8NFL940nA6pmPXXo4euYanBXQdt51/hCDtOVa0WewXHyNEjcO3SUrs4Pow14ygKPJgjjxfYRZvbBTZrOp/nhUYaoo/wA0jzw8wTgI1gzKPfZiDAzJ+RbyC7aW/Y333BMz+b5o4oRhuTO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=jgFsCsaq; arc=none smtp.client-ip=212.227.15.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="jgFsCsaq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1780428958; x=1781033758; i=markus.elfring@web.de;
	bh=AEwi/fX0GckwwXDwibm4lMkFqJc3kAuC+908OxMyZno=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=jgFsCsaqptyIPHiVNlQlwgiz0LWgOZmKTSLlYl1MWx1EOXEUaZtKWS5QPpONY9mt
	 KnpEN7Uzy31QAR2QFvZ5uROf5IkNqbnW4KHKHTAj5hCAvihUCLxJZiO9ODbdr46qr
	 yokf4yqkNyIpx7zMmZ1mr8j53F88QNcWU3j84ksTn/9aN5jvXQQLH8eDvY9CFE+k6
	 NPw4B+b15roUm4mles5dUVYjctJ3n0fCblpVOUARkKj15IT6WgORy022m01TNurAa
	 mUY7eaIHziZJSFEsDspwN3OYy4tF95A4SI+lasOuk2U+mskPxPIHxBQWic++AwDoC
	 M/HwDSMWM5cEa9VWDg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MpCqh-1x44VW3pOx-00phYd; Tue, 02
 Jun 2026 21:35:57 +0200
Message-ID: <bcc5ad9a-4258-4c2c-acfe-78fd6a17adf9@web.de>
Date: Tue, 2 Jun 2026 21:35:55 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Felix Gu <ustc.gu@gmail.com>, linux-crypto@vger.kernel.org,
 Bharat Bhushan <bbhushan2@marvell.com>, "David S. Miller"
 <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>,
 Lukasz Bartosik <lbartosik@marvell.com>, Srujana Challa <schalla@marvell.com>
Cc: LKML <linux-kernel@vger.kernel.org>
References: <20260602-otx-v1-1-e0c9ec50cb04@gmail.com>
Subject: Re: [PATCH] crypto: marvell/octeontx - fix DMA cleanup using wrong
 loop index
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20260602-otx-v1-1-e0c9ec50cb04@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:gniBSI66/TjJbf/F2iz+UASnFlEGNrqZ9UqPQHoR2do+a8VvwJY
 BgFiPCvZMVATFra6rXb9lUO4jR7wJ+jO9BBwbECM23gEGZQt03dDxESkbh3Iq7zS4gZguvJ
 yssLmeopeFItGKsG210+OTtU1b98qUjAmAKGqs1EPNH4jjDr2ilhSHbrSUT6NmwEjX0zsWK
 A/1ke6Z834C2YEcEVe4zQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:kqHXAZLsHpk=;23Mm+UI+b9mljOrvbE8xTjMz+YD
 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

> The sg_cleanup path used list[i] instead of list[j] when unmapping DMA
> buffers, leaking successfully mapped entries and repeatedly unmapping
> the failed one.

See also once more:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?h=v7.1-rc6#n94

Regards,
Markus
