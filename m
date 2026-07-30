Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78226411A18
	for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2026 12:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785413189; cv=none; b=H3Q0y8IFT83ghnC1vbm3fm8NyOVEgMC4Y1uzjgCAI9YmhTXzZVBdxPOLGcK8e1YokH77feCSxH7uLYmbUpfeV5fD0pB52tIC0igF7Azq/7SQOVz1oYY/EaMZKYyNe1a3Q5zwln78K10LZN5fXzB9epzirKOLIVT8hbMGLjDIJd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785413189; c=relaxed/simple;
	bh=IjHYRt3b6XbO3uSNBzE3Dn9FEQqz39BkAW/8SpRq9Z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dTeOiZEGBP09WxtaUhIq4GUp5TX1jXu/UgF6lZKo14lShSP4ZDfCykGnyOFdcMSBSF7/+rZoR1dkS2T/fg0UiyBZqhNpvqSW9XFOs0ZrQUcOTqjyH56OTXOfKMTyrppff2ieGPk7us+h/8N2qEfXicZnitTqI69s97p4p9geqCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=U9Rge4+Q; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="U9Rge4+Q"
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id C05923F9A6
	for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2026 12:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1785413184;
	bh=JZ0Ni4k/nro/sujtQqSou/DbTDAlKfldBstQVC17mJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=U9Rge4+Qv03f9Hz2rN7VM7LekyIB8pjXMQ/DnNj28uHFBbKDkf5RtlTL3+dgV3tVA
	 hPus5CHqGYIhQ7yR33ybwLrPRBARmwgjq/GZOtgKnyyk/LgurjZCX9CPLdFg2cQTQG
	 ofOWvcXb9lT3EKX/RsChzeEUEgbQJFioEFqquMIRZPYHBWAbQA7QhvbR7qF6jSbt7l
	 BSi0wJ2XJwS9ilG/Xsz+FGap5qHbILbAsKusJaYPK2s7u1Yg6pnEdyK7L3VqDcG+3P
	 K6+ic6ffpEKTrt+wGq6PZAC6WaHHCVxNz8GSZAXKQknZaH2aK2+CpKHm2lC4D0eJPM
	 7aovCJmYz6jjInieZLFg4xvbOQXau2K/OIW3LJOYVYjLRGTlyUMUFxdfv+dqGcHRFW
	 s4bLJqYQ+wuj+XA/ROGUPybKMLS8orAsh8gZUFF/ndmwoGbNow1NbG8vBbLT9sv0kJ
	 yGvHASl3wCoWsCRKglwoKYNV0+owS17IvaeXgDKE6Xx4ni3kIn/r/G2lmjlzh2aPQU
	 rQ3rWx1wmyjRqasV1Mkyae+EgJnjYC/7MlLAwAmG1LK+Wc9xfNUIjxXkzUyJjPwLT2
	 6UTHZTVOto2OZeQCzRERe33kTl0nlka3OKKZHIcj5rbpOFIbZ9iMppfTqkgGapZO9+
	 7FJiDKWk62QO52AcC5g3Ge6s=
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-388cfc4848dso2648891a91.3
        for <linux-crypto@vger.kernel.org>; Thu, 30 Jul 2026 05:06:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785413183; x=1786017983;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JZ0Ni4k/nro/sujtQqSou/DbTDAlKfldBstQVC17mJI=;
        b=aIqc6sbsXudMtaPz+oOu6bPTg9F+WJNM8PmZLrdbtZpJHUWSRgxkM9hBydNjBzDB1p
         ruvvppvInajknpIDToPR1vGgcuZ3L4jNVwGYbW1k61HqsTwUFOrjZeAqlYnF+iIs7i1S
         DosKpEZOZECi2D8pAM9Cbfi9EX8Vcl3Gq5XDBSqycODk9HmL/wfk19NUTV4ieu8V/8VI
         AWlg/qKcfRhDJ5tDxigWCHqbGHnCzKStNe5HSjm4YJAN4O3e+8DuEb7S0wqBYWKWoMQh
         S3C9LyzfmOxes7l961FLpssS4BRLoPkslg1hK4pEwe5Ko3VE8Rt59SHP66tsWOHH/kZ3
         pLgA==
X-Forwarded-Encrypted: i=1; AHgh+Ro17ixiZ/EPJQb+hVEn/FIZnplmDj7rrTK2xz3GFbaV6aqtPByioe/ZRF5x2sXp/LF8lBRpQjp5QctQgAE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQnHNULMIJTNRpbCqeOB36VOGrI7egSAZPlsQlNxX5LH2RWcQr
	DwrVuyJYYA1YwAjXhqnBM3SZFTupZgqW7NN6SRHiP287o5tMvohM96LSbw2nWmOl4EJtb96pwm+
	l4viK3q8xehnp9HOIOeAF2awj9y0OmW6X8VUh8p73cY7oCJqeNCOtuqUGTIjWsG0NeylxvDhh/S
	SaHkxAJw==
X-Gm-Gg: AR+sD118dty2I7CyhLcrf5hyo6KzqbJOabtK1DpywjIfUrHqmE+W5+OSoUoFA/0qUTs
	Ey6/CtQW+0VEn011MMMMnTLLNjSwlA5FJ3Q2bBJ8u3hcALRt9CZjrohbgZP7HHNu9EuEBZi2REV
	/qbBoRX+oIuBdjM0DD4xi7+rsu1KIM+1qCOUH1j1Ik+GJU6rPC5vRSky885lhWzbOfa1t0SznvZ
	esfnqA53IsYDGp47DoMSrAtJrGnRDGLHXduBCEHZx1Pf2OtgNok03BVBcQOd4wntZBWOjJy4SKP
	KO1zSb2HrJCT8utVrdUy0Wf5g5rxR3RIqBz1uEtXdAOtNvqFY+0BS1IKwzE+aa7aCb+35d2fq+b
	COTjoBu9O01k=
X-Received: by 2002:a17:90b:4cc6:b0:37f:bfd6:8b40 with SMTP id 98e67ed59e1d1-38f9bd6d19emr2115102a91.5.1785413183074;
        Thu, 30 Jul 2026 05:06:23 -0700 (PDT)
X-Received: by 2002:a17:90b:4cc6:b0:37f:bfd6:8b40 with SMTP id 98e67ed59e1d1-38f9bd6d19emr2115070a91.5.1785413182566;
        Thu, 30 Jul 2026 05:06:22 -0700 (PDT)
Received: from ZBook.gateway ([123.208.39.53])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f9b99639csm972428a91.11.2026.07.30.05.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 05:06:22 -0700 (PDT)
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
Subject: Re: [PATCH v4] crypto: rsassa-pkcs1 - Avoid cacheline sharing with underlying driver
Date: Thu, 30 Jul 2026 22:06:14 +1000
Message-ID: <20260730120614.1615780-1-changwei.zou@canonical.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <ams3ED05SiobrDap@wunner.de>
References: <ams3ED05SiobrDap@wunner.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Lukas,

I will move the new declaration up below the one for child_req.

Since out_buf is incremented later in the function rsassa_pkcs1_verify(),
key_buf was introduced to preserve the original address returned by kmalloc().

I tried the following approach, but it would require replacing all existing
occurrences of out_buf with ptr.

	u8 *out_buf __free(kfree_sensitive) = NULL;
	
	u8 *ptr;

	ptr = out_buf;

Could you please give me some advice on this?
Thanks a lot.

Kind regards,
Changwei

