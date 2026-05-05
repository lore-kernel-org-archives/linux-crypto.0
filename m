Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DECA481FAF;
	Tue,  5 May 2026 15:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777994667; cv=none; b=BuC1WlFlxIAzWUGvl+MQ+knOsq5WZPyDAS7NPPfJnUoelNiIOBSRoGJvsBw1Z0w4xXS9muixXR4wORY1f2sGWNLygD9PaHd2CuuIp9L8jo5TMiAZpND70K3dUsN8kjEU4PiFTz8mHIRl/YkWLp9txQM9Dd3yB4iwtYmzYe11TO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777994667; c=relaxed/simple;
	bh=TYLJCUs11De+IxnARIgVbv0RY+n0qr9eToShT4iy/W0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ImBFyki5iqKCt1P0HvdDW+naPLIn2DSgh3Z6jcuXEHuXmnWZMLuwWE8gqeTiy4es8ImMQ2uF17+5nsLyzEuvxwkocnTfyDvYB3L7TDPcJfWiTUabb1VdtAIQFUldUJ/bNSx1zQLLoj2Qlp4HaO97UIGTQXMOCxkzs5II2XB/7bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=WczCGkuC; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="WczCGkuC"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id A05AC4E42BB3;
	Tue,  5 May 2026 15:24:23 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 6DC746053C;
	Tue,  5 May 2026 15:24:23 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 5BA5A11AD02D2;
	Tue,  5 May 2026 17:24:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1777994662; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:content-language:in-reply-to:references;
	bh=O/ciYmWMR3lYydMKF5D/rPiOnaz1y6FpcPAyfKnu/BA=;
	b=WczCGkuCy+Lr/nF9CAOPe6GeQgO5iKst4gdF7DDgz26d97sBc/ZcM5lGIMy1yBzL5irBd8
	cQ1EvVrdKZq/scqZy7hVlFHZommT8mn84/NRDSOxjJnCqecOb6AaDX/Tz+y7OArbFJjajZ
	5x8hECe5zbchkJdUZELqPJG94ZhfOm5XLqXx7UKDfZtIaifM4FJc8WjiaqOeflD8qEMJmE
	Hr9L8IH7vT768b98A7rTKe80aE0ISsY1VSafwGzZ0ytENbUKzpvHwt7mNy6INH0U66pwAZ
	cVqTE/SYnEn5TLnlpN0x+SBu2RoHrFjV/Gi4v67whQMMjiwm3yH4jaWxyrzarw==
Message-ID: <60f67268-de8a-4e83-9038-c9fa55d1a25b@bootlin.com>
Date: Tue, 5 May 2026 17:24:24 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] crypto: talitos - fix several issues in the Freescale
 talitos crypto driver
To: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>,
 David Howells <dhowells@redhat.com>,
 Kim Phillips <kim.phillips@freescale.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
 Herve Codina <herve.codina@bootlin.com>,
 Christophe Leroy <chleroy@kernel.org>, stable@vger.kernel.org
References: <20260504-bootlin_test-7-1-rc1_sec_bugfix-v1-0-c97c641976f5@bootlin.com>
Content-Language: en-US
From: Paul Louvel <paul.louvel@bootlin.com>
In-Reply-To: <20260504-bootlin_test-7-1-rc1_sec_bugfix-v1-0-c97c641976f5@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3

Upon reviewing Sashiko’s feedback this morning, some interesting reviews has 
been made.
Please disregard the current series and wait for a v2.

Thanks,
Paul.

On 5/4/26 5:38 PM, Paul Louvel wrote:
> This series fixes several issues in the Freescale talitos crypto driver.
>
> The first patch replaces the software workqueue approach introduced by
> commit 655ef638a2bc ("crypto: talitos - fix SEC1 32k ahash request
> limitation") to handle large requests. Depending on the SEC hardware
> version, replace this approach by using facilities provided by the
> hardware itself:
>
> - On SEC1, descriptors can be chained with the Next Descriptor field.
>
> - On SEC2, the per-channel fetch FIFO is used to submit multiple
>    descriptors.
>
> This removes the workqueue-based splitting entirely and fix the (64k -
> 1) byte ahash request limit on SEC2.
>
> Patches 2-3 are cleanups that follow the first patch: a field rename for
> clarity and folding a trivial wrapper function.
>
> Patch 4 fixes an off-by-one in the submit_count initialisation that
> wastes one FIFO slot.
>
> Tested on an MPC885 SoC (SEC1 Lite), and on an MPC8321EMP SoC (SEC2).
>
> Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
> ---
> Paul Louvel (4):
>        crypto: talitos - use hardware facilities for large ahash requests
>        crypto: talitos - rename first_desc/last_desc to first_request/last_request
>        crypto: talitos - remove useless wrapper
>        crypto: talitos - fix invalid submit_count initial value
>
>   drivers/crypto/talitos.c | 583 +++++++++++++++++++++++++----------------------
>   drivers/crypto/talitos.h |  14 ++
>   2 files changed, 322 insertions(+), 275 deletions(-)
> ---
> base-commit: db8b9f227833e729faf44a512aa1e88a625b5ad8
> change-id: 20260504-bootlin_test-7-1-rc1_sec_bugfix-13169ed07ddc
>
> Best regards,
> --
> Paul Louvel <paul.louvel@bootlin.com>
>
>
-- 
Paul Louvel, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

