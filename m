Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6A240DFDE
	for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2026 11:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785411556; cv=none; b=d2Il7rCHyD9DmC0VGcM1+sM8E0Z0sQw9tHFixsQCTdF6U7f/RPByLzV0vAlSC5hWrI1QOkiLxAIx1EFRWmxCOPRXboc4WbiJLBwlp/ptnI6dYegBgoMOumXt/J3ItzGK48EqDXccq8kvZj9r4Ij8L/lTN+6xkCO3pMwfi6vylDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785411556; c=relaxed/simple;
	bh=KpmlrXYjTXI0e3kYamdKaJkFMC+QbYEbJOg7dnQXX7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rvf2zoEUDcpK6DZE0uAGjarsMcUi6fO34hCHfaz0+ebSXPIaXc5N+8djglyyIsbni36tAbhDkRySMCfxQ4lx2f4iradvvARscAQ+Fe89DKMHlMNE+yo04+IIc7YIeUx/ArL8okz8FtFqzW3NAlGWsMAxXLETCX+Mg1RPBnxl4tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=kLnWcTWE; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="kLnWcTWE"
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 39CF23F9A6
	for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2026 11:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1785411546;
	bh=KpmlrXYjTXI0e3kYamdKaJkFMC+QbYEbJOg7dnQXX7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=kLnWcTWEXpciN0xun+A6UNGuTk2WAr/83Oq1R1xexMcZmAuZB3d8wUx9NeU/myAYj
	 sDNHHy7qP1UiXZOCxASu+PhiW/vK4d6RBZ4pYPZGd5zBbxM1VcDJ2lN79dg7CZBmTM
	 WFLQhu71nC1NsWKG7WiHaVCf2FtgRQkFelOiFuUzFMd+v/lExuZL10yIg/smRaHxTe
	 nECbUA8yskS1plaeY3BiLbP1ff7gJbsJJ5FOHPp4lJbIdpB5qa2abEjgGcEROXPHrV
	 q89wnvJ0qXdzZFrjqSyMFyShWSS1u8OL/XO1Sn4pzPkaSMsaD2XsIKs1QEHtss/BZJ
	 RFXsmApxUm6VdSYSApfn+iQO8y3wMZjrcDtnNSKdFfskFdA/lPlDApVkkouRzLH7f9
	 VIG6sJg2jTdBgoIba9DcRgf1OH0npEygIiZG/TXdHP8OSdLL/GiLp+1/Wp6TJddGUr
	 ZWcNoKHHPF4ig1SKTBFCSoLSt2/G97YoeojqdyGUxCNe9TwcNW92smVGZ6Ytl4QxN6
	 w9vhnxz8BC4QYMOyYm74Ut3UjV+a3tYZM7C8aJYrOKEHzlk1VpZjZ1sf9lPwRFGClh
	 B+fa+ZTiSsAy9fYg+yonY7ZcnRSF11BM3Wor31YaYWQXlbOoiwCKbNzjJJGDsBHCmJ
	 0h6O4PsgD5Z63F+bjKEm9fG8=
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cb11535e6a1so1676300a12.0
        for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2026 04:39:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785411544; x=1786016344;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KpmlrXYjTXI0e3kYamdKaJkFMC+QbYEbJOg7dnQXX7s=;
        b=JMKFus6tq9BVYwEFpqK16zyiiBs+ti1wadLeSBWiyGbt/hGW8AIivFpcCrfFTRzr01
         5q0l7j2YJXbD3qBDgwZSlYDXaMRboaG4/wENG0ysWvk9xWgVC364r9GSsQm/nP4YpqDf
         98bgZOUtYbrJk8DGkxEI0f1iEfKR1tLDuomury7qukbfUgAcHu7VQ5toxAJxkkHDFTdS
         Yb67eXLwN6vyo3+8qV1OU/JwLfzDbPTCQIToFlFeConjg49NlxXPrMMS8Pgfjo4IaMKd
         4BOSAe3ZJ1nio5s0bgtRGiGo7Yj24Pwouro1TnCJKKrEm8lYWccqGgJDIh6xe+FFSmjl
         3wbA==
X-Forwarded-Encrypted: i=1; AHgh+RomFa+7Ml7b3x0zeCr0PoyBRB0sKO3j7TPfBLCY/UHrXjaR277FMysn38VnuXeKKpQGJnUEeK9PWk9mFYA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSI+9kDn5GqXpluHVC1VJTqw4OECLwJOc1HUcsBnfP+RGXWga+
	mrS7qng/oWW9NUwX9rYlJPbRczfDCoL4iCSwC7pS3txkqLPJjgHQTcT4QS6A6hHoWUlmb4FvvdV
	j24hfynZ50fJ6fQJgJ2Wu1MGS6TmYM/XcoC1nnXBwoq7aaEvIJoJAzZxUBurLzonKd5eTPQxEut
	/Vdt1KgQ==
X-Gm-Gg: AR+sD133Z8cWqfBkvfbTOCYO0m5qTuq1YeCic+AIefx2lY5/xUk9Oe/FoChBnQrDEFv
	lzu3kmkR3dRRJoGX/YGUvBFBGdtFN92KNc4jkoXDwNjjooYW0BPIaJRKlj29uNSBQXVbNjCcmgP
	vvM+ZNy++9raRSuq63qXbjQKPTMLy7u2N+VL4AQbO1pr0hdaK+1FV4tfn9vg0HgF24sYlLkyUsL
	V8GoPTVouvIM+pe5q/wzpd/rxrSeNlJUn4TcJw1meMSoWtnKJ0HCgyTp0STVn6Xq8BhWNcNbD7W
	0Bi+nUYe72DaaJn0xzZv6HpWnqlgoUYfmPxGvNnIDZjXNuYIFQ5Z8rx35asWPBNIwC79piyu6Jm
	2PJE8zLh1l4M=
X-Received: by 2002:a05:6a20:3d8b:b0:3c3:a1a4:862c with SMTP id adf61e73a8af0-3c9009ed027mr2204229637.68.1785411544510;
        Thu, 30 Jul 2026 04:39:04 -0700 (PDT)
X-Received: by 2002:a05:6a20:3d8b:b0:3c3:a1a4:862c with SMTP id adf61e73a8af0-3c9009ed027mr2204200637.68.1785411544113;
        Thu, 30 Jul 2026 04:39:04 -0700 (PDT)
Received: from ZBook.gateway ([123.208.39.53])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbdba3518e1sm2094627a12.16.2026.07.30.04.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 04:39:03 -0700 (PDT)
From: Changwei Zou <changwei.zou@canonical.com>
To: herbert@gondor.apana.org.au
Cc: Martin.Kepplinger-Novakovic@ginzinger.com,
	changwei.zou@canonical.com,
	davem@davemloft.net,
	ignat@linux.win,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lukas@wunner.de,
	martink@posteo.de
Subject: Re: [PATCH v3] crypto: rsassa-pkcs1 - Align DMA buffer to CRYPTO_DMA_ALIGN
Date: Thu, 30 Jul 2026 21:38:55 +1000
Message-ID: <20260730113855.1613653-1-changwei.zou@canonical.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <amqN-vSF0ZmWBNJ8@gondor.apana.org.au>
References: <amqN-vSF0ZmWBNJ8@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Herbert and Lukas,

Thank you very much for your help and direction.

I have submitted PATCH v4, which is available below.

https://lore.kernel.org/all/20260730112026.1612066-1-changwei.zou@canonical.com

Kind regards,
Changwei

