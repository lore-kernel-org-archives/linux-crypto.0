Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C8D267B07;
	Fri, 10 Jul 2026 21:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783717406; cv=none; b=dtv64kaiGTQNUe2aBZUCNQl3BsRVmirCxlM8sVmwijb3ozRFfF0NiwD/FXW1FrWtDgK+ll9DSPlipIgdJRarqCF4eu1NLInundmJa/McYhbPAY2XzHJIgxCtD3KQB0Mbv7tlfvkJ+VFww9cgfr6WS6GjXZXU185mYmCRxhA0dvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783717406; c=relaxed/simple;
	bh=QALKcAmTuI5LzRrJSGbbgmFsW4bUFQk/YvqIHsa6s5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oSmRZ2wQROnBY8CYyGjohggFQvMbQT+7ZBcAcEBuxCplc9TwnKurmo4+UUs4FzFkBV57E7kgemyurmIGRfBCQT/Mr8MG8iC2AN9ywBi1wE9dyGeGU8vBycQUDOdYZkN4PVeQrLy3ENoXXydu+ToiBjWDdH+N6GIhYl5cFaZvOAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bgj8ri39; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bgj8ri39"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466231F000E9;
	Fri, 10 Jul 2026 21:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783717405;
	bh=wd7eVM3AWuUiBj7+RHIm9jhBIwbfSUTiNOHzYqHIuKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bgj8ri39hSxA46Fn58r3wMHhyaiGB8/cYReE92W4moAPASl9zGvS6WY/PTiTAGbIx
	 9KWOmE4INy6vniWemw+B6GRhoa5g2cGuVHXkRzmMhBOFbkN5mo0SS5eLHfpFxE+3Fo
	 c5YquZAFyHPRL4PY5gRl7ML+Jd9bIFna8dUHy8VdbIrYy4i206D0mmhbOlq1Bzwali
	 r5KONtvwTDvd0kKr8MwVEBYPC6tn0burL9WrMhLeJCX7Y/1l6GFhSZHSGeaKDebOBW
	 00ZJ6ecl7dqyF5nzQvVn4bPcPIrL/9+x83KTTpkBBjgtfPJ5XuoDjMrWYE8DEjP8jE
	 cJlK/8Lt7D+yA==
From: Sasha Levin <sashal@kernel.org>
To: gregkh@linuxfoundation.org
Cc: Sasha Levin <sashal@kernel.org>,
	ggoerisch@gmail.com,
	herbert@gondor.apana.org.au,
	herve.codina@bootlin.com,
	linux-crypto@vger.kernel.org,
	miquel.raynal@bootlin.com,
	paul.louvel@bootlin.com,
	stable@vger.kernel.org,
	thomas.petazzoni@bootlin.com
Subject: Re: [PATCH 6.6.y v3 0/5] crypto: talitos - fix rename first/last to first_desc/last_desc
Date: Fri, 10 Jul 2026 17:02:59 -0400
Message-ID: <20260710163023.agent5-0003@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260709193956.15619-1-ggoerisch@gmail.com>
References: <2026070912-pluck-bagful-2a71@gregkh> <20260709193956.15619-1-ggoerisch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, Jul 09, 2026 at 09:39:51PM +0200, Goetz Goerisch wrote:
> Commit a1b80018b8cec27fc06a8b04a7f8b5f6cfe86eae
> was backported to 6.6.y with a866e2b1c65edaee2e1bb1024ee2c761ced335f8
> It renames last to last_desc but misses one occurrence which leads to compile errors on mpc85xx
>
> drivers/crypto/talitos.c: In function 'ahash_digest':
> drivers/crypto/talitos.c:2204:16: error: 'struct talitos_ahash_req_ctx' has no member named 'last'
>  2204 | req_ctx->last = 1;
>       |        ^~~~

Queued the series for 6.6, thanks.

-- 
Thanks,
Sasha
