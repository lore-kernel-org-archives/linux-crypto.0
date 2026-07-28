Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898CF3A3816
	for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2026 09:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785230396; cv=none; b=Tm7stPy+U/g53aMtpQXAcNGy/bRX0d+8n+8iWlPSHf3C4DYHojSRWzojXHYco0CFDQRP9Gg99ImkQorhXyyEtGwV44LYE2zqrUIVWHWJMVdyoUe4drjMvylp/NkvgONU6JjVUJzD57xze5CnCHP4fI8AUksvQ/Ad8fL//RWHk8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785230396; c=relaxed/simple;
	bh=7JiH+XSwdA+8bA2dT5izwIM5GRMs98IjTHcmzzU79GQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cN7az4mx3gqhP+304QclFB/pSQffcOHDGJc7t8OZr9MMwdYHP4354QtXVwcFCdoroylGvPYL56KwnkE/mOeq1PNd9hKR67s9hcuVVAsQ4X/S1Q4fBBqbz1tx/PHOoWlXyQ38Mdb9ErxeBrDxJagGcFKy8nzNses861qiMB5Q7TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=ZLTmntKw; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="ZLTmntKw"
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 02C493F9DE
	for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2026 09:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1785230392;
	bh=7JiH+XSwdA+8bA2dT5izwIM5GRMs98IjTHcmzzU79GQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=ZLTmntKwvBtUYeOKdyv3JAWywdiSIP9WLxzSt+XPNUOXkn38qF3wgW1tepNflpiFK
	 U7YpTtlf4USiltnNGOsEEDV3cygTnqZ7hBOwneKorv1wgDsluexxF0flAMbqGmh8VB
	 zAPVV0GbhpHw5VMQu/nxlPMFqJZy0bGSI44u70d1n/0O6mNZg9X34XdKgBqhfGLfzh
	 XZQeN61YD2VVKrZAxzZVk2j+l+hQIJtmNEC+s2lQ1is2z1KKXY9mWjDUxb65JuUliF
	 s2iEQnhGX7de1xqvOErhGwxyxVGuAu3oSekyI+TW4+jvd43JnNLFVTAiejjTMyxB9z
	 etSIapJP/WbJr95bF1ECPfUl8MLRI9922rfSfWJ5icWbIfmLH845i/8DI2fLnLkd7B
	 j8pgXXbTZk90O6B3t0Rs2pvPzWd+8IkQRh6pVCa+qOWbExAMOnnofPM3BBz1PrGfW2
	 ISrjjDfhgAy/8Mc45hWBOu5Dm09r1moet+832/UXQqzmBGBKmIpa7osl6ArCPgdQUY
	 QcxssVHiIVi9Sgh9SEYV4sZhhXc0lCLPu3g1oN9ckAvFtgtKjOcu68+PLQJ0ULdInC
	 UtilFm3gJDiUDhXwPK1JHyC0NAEl35fFXOqNf2OgYXc49MGWpI9ClI4h95CWhp2kWr
	 7XpUxE5+C89hHz8QWpFGn8d4=
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38ea32e57e2so1982629a91.1
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2026 02:19:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785230390; x=1785835190;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7JiH+XSwdA+8bA2dT5izwIM5GRMs98IjTHcmzzU79GQ=;
        b=rkKaT6frFP8hjYTnCWWZDH4nemkV024ZDXkqPx2624cbAvbLB25ni7c2/7lPGLqy4e
         hGfqF8s5Nbe3P1CpNj5VmQG+8NZ2FP+rGXvG67H3GXMVgSMeKM0O8K2F2F3F4w9abq9A
         6QbFuO2rPkG1W2vVOozsdXmw/kbIcH4wgm0YcGRm7BpV0QEoOQOp5AlIlWYuC5gK9CrW
         ami0OkMqoirSepNniQDXOAPwseaf6gJLjqgYTqiQzUvq3YafbSG5BL8HvPoZy+pSozw4
         JfvJ/xcpo9E7+m1aTAcpL70iwdYF7Q+/CRsLt7F/XfBldrKthF9B3JS6Bc5skUwQH6eA
         txYA==
X-Forwarded-Encrypted: i=1; AHgh+RpF9CkZX0KsGlvtlENv7LThtc1f5n7RjBPGdCkparMRTRyX/dI6NYaydIMk7YXkEvNKZLIQ0yiZuerxKPI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBcf16/Zw/IXc9W27dSdnV0MWYAZwvttuqFtXurMmzrjlHXM1g
	RAb7UeNX2sWo1EhKJkDVcGjlBh2CY3CIhcYLwqhsZEJgua3sKq1wPLIQKKDwv7tzfKAil0oqv2q
	HTo1z3amV2o6DTPwRTHumC6i71/K3I9aga4YNa6qjhQrXZJuoHg6sXkWjkZbVq0KqZd1BdjtEIJ
	XYmmg8f0OqB4g0lw==
X-Gm-Gg: AR+sD11dJtiSJ1O4L5au5rlx7oMxBfBM9fm883ks0DjVnCrEhQgD2nSs93IObDEvzWs
	beNg9fLUiQEfz10jy4AqsUcm2aQPdBmKMpdr0TgoOpEQYABqemdfwhdIZhSiPn7BBYuCi1sZ0H3
	rO2U1ZLFqFwX+NjtWt/Mjj62cq4xDVKfKHoBj5hBOvHSj48DeT/FMG2Rv+VWGUzuYCln0E9WiWU
	k+AsStAER7kpOBzHAqDCVIyzNPuIirSyvQE7RA+DYdnYznEM3aCPtpEaUgRK0cb4Wv0hNIhHCeM
	xpDsrm0i0MIfPjArqb9f0nQW5A6vHTjQtnOnO4/MeUQxzQ5rf641tbQlIl2baP6EkuXQD6ay9uZ
	pSM0ieXDlnzw=
X-Received: by 2002:a05:6a21:9984:b0:3c3:b57b:6455 with SMTP id adf61e73a8af0-3c8ba5acf3dmr2187607637.49.1785230390064;
        Tue, 28 Jul 2026 02:19:50 -0700 (PDT)
X-Received: by 2002:a05:6a21:9984:b0:3c3:b57b:6455 with SMTP id adf61e73a8af0-3c8ba5acf3dmr2187595637.49.1785230389753;
        Tue, 28 Jul 2026 02:19:49 -0700 (PDT)
Received: from ZBook.gateway ([123.208.39.53])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc548f5dsm48931806eec.17.2026.07.28.02.19.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 02:19:49 -0700 (PDT)
From: Changwei Zou <changwei.zou@canonical.com>
To: lukas@wunner.de
Cc: Martin.Kepplinger-Novakovic@ginzinger.com,
	changwei.zou@canonical.com,
	davem@davemloft.net,
	herbert@gondor.apana.org.au,
	ignat@linux.win,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	martink@posteo.de
Subject: Re: [PATCH v2] crypto: rsassa-pkcs1: align DMA buffer to ARCH_DMA_MINALIGN
Date: Tue, 28 Jul 2026 19:19:41 +1000
Message-ID: <20260728091941.13838-1-changwei.zou@canonical.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <amhJWs2AdPgFzw8t@wunner.de>
References: <amhJWs2AdPgFzw8t@wunner.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Lukas,

Thank you for your feedback and guidance.

Yes, "PATCH V2" supersedes the previous patch.
https://lore.kernel.org/r/20260723150107.33546-1-changwei.zou@canonical.com

Although the first patch passed 10,000 iterations of stress testing,
it implicitly relied on in_buf (i.e., ctx->key_size) being larger than a cache line.

In PATCH V2, aligning out_buf to ARCH_DMA_MINALIGN makes the root cause clearer.

I will fix the typo and switch to the CRYPTO_* alignment macros in V3.

Thanks again.

Kind regards,
Changwei

