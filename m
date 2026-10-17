Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B32D394797
	for <linux-crypto@vger.kernel.org>; Sat, 17 Oct 2026 10:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792232469; cv=none; b=H0bRPDjRYj8VHQ9a1tWYqz0Y+Mnfh01P8N9DF3zeTeXndlpIhIYzLf3rK7z3ruINRri5Dm74B/rKKvpJIEgpJVkyY4u9Xxb1g8TADajIxZ709LBrRf64MRV8rVrxRsF0ldNyAevAO7Il887N3Z7ZwuHztYqXqJ3pLhd0m+WRU6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792232469; c=relaxed/simple;
	bh=o/txFfZ6qREH6HvPvJA5uqvrdC2R4O4pSi9AdfzM0pE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DkxXhrwy4WkxtdZdXQ1CXjCaxF6BlaY/dIE91BgWTdH9ppHWpVoEq0lpbPUgigAlKswPHvqvSAQjlrbpqMUNPk4i4NASa80mOwfwI45Y+3URTKJWR5R9UJMmL+GNDJvs410xSCFO5etz7yl9zikwouTlCp/MELkOF2+5316aehU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=KKHeqZ/x; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="KKHeqZ/x"
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 4EEF23F19A
	for <linux-crypto@vger.kernel.org>; Sat, 17 Oct 2026 10:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1792232459;
	bh=+C0qtXyCjBUJJ5Qb8uii3DzDlBDyGd3v4gWGK+ZJm9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=KKHeqZ/xqRenlNHiJutBRLKBjCx0EtEYTqTG/CGyThEqu5sOrP/fxJD6OKFPt8pwr
	 GPhXtgEU0GhUxAvjj1fN5WWIQEEP3iPEsegic+my/g0zZRvOvZP71WqeRCtf7/PNj1
	 EEdQfSr+GWiKl5oqXQp/E2sf6l/Ufnt32Kp2eOSudDDPyQIpvatrf5J8xwQ1r85tST
	 VtjrtNY/1PMVBYUGB+bNOUiz4Q0VFn/pSkL7d4r8TNxe05410MuWsPNeGtrZu+izoE
	 wgFLSa7Bx9riHUCEqG5kPfGQKF9soI+I9K3/AnITXn5Nhx0xtpiiY+BckaAEf/Xcxy
	 6GG5HwAZlEGT6+wV41LIdQ6VSFlKg6MChpoyzCTZXhdSf/tO9BakRIBV5V3+tJHgrG
	 Wki+ibvw28uyQEJMRlhrbCZ0/LHj1NLnYxAeEBKDGisvrsU1Iy7bYzH6Co+zkERQAv
	 Rqr8AoqHjAPE6CEKXA2/PrdIjSVGabMBvvZA1CBWQFthVxvoQtbIHosrsqSORIKWT6
	 QxmhMTefwbxl9R/KX8mKYoiBm+eTuVpKtg/h6EROPsVJ35YK9daTc8128PUSLyo2UW
	 rc9m8k8ToqeeiyH7JFRTeQV13uTHa1PA38yej1UjIwM1Gub01F0lh0289fiphMtl/t
	 SUoqz8HEZm49R5gjf8xV0cAk=
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2df8d1e91c9so9554185ad.0
        for <linux-crypto@vger.kernel.org>; Sat, 17 Oct 2026 03:20:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792232458; x=1792837258;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+C0qtXyCjBUJJ5Qb8uii3DzDlBDyGd3v4gWGK+ZJm9M=;
        b=p5nogwwA+EoWO7KlzfFFqPPbdkfBQ8fxf/f+pkU8/9pTTUtUudynlNASVhhycnPAE7
         812sebR9bw6UlKYb4hnSNTT68/zPfdW1H2tL2HUzbJxKeB3bgntSgb+MNi92iDdAPSar
         MW6hoDUoAXeNB1Y5Zqr5QRWtVQzN7brx80mBZX5HRRYMBETKlFR4Hv7cnjpdmtEQvp7U
         nhsq6WeZ89gq6ek8uI3otcfLAN5+R4cqm00m+8leRoiCZ05By5gOkHQF80n8eZszeQCW
         BJa4odHY5gU5+t9FAay9pILgpjXHF9vhq8JM9y7fQCV2pyZpR37dsBT4VYvr6yPb59Zb
         GE4w==
X-Forwarded-Encrypted: i=1; AKwUvByjB2oh/RhK2F2o2kisnqj5iHJL347BDcqrSR6oAOMkLMbB1Es4RzK36Et+euJC2WhuzlBCLMr5KIjXMLk=@vger.kernel.org
X-Gm-Message-State: AFq9FYJSzNnq+uNfVsPbrST5H44zQxv8+lgMOCwjZZyjRMESlpSub6is
	WZkJy+Q57rrImQmH+AeISmLDPYuJSFaGAbs7xuxNxTklgIgy5uo8AQvcA/Keo8713SqZJRZNICO
	cZIlbQZo0jOGoxtlxAC05AXWx7j6i1usWt1SK8l56or8n8eJHAJDI2M9NXEFQryqawRyHO2qYG8
	2TkreK1Q==
X-Gm-Gg: AYBFou38YdnRSIz6echwdMXmU33iUEu6CxngOcEYg8VvcZP7YwrJfb7KEbi++G9WFAv
	Vk5G3l8zgr0mpwRHYWTm7fIvuuOhXoGbXQAPLvjNIFKoC+IdjGnKm8J7pBfe5V9XdkU1IJNU1YC
	57RSbFUxjueFbz/cuseIctwzVd4RpzL67345n9kJIJJpngx1LHbeC4THZsnooYfxbJEkyBbAE5I
	YmWOa7s6SDsQCNmlYDCWkzbLjhZrVGHoBh/JvqcrkKTwVrDhWg2ExZNvzIJeAS1YZeiMbd7DdzN
	Oh6BCbJtcBUXqiGpsm7etlaskxKeEU0iRsNYo2iMkU1npETl+QstNEo6tA/Z/RA0/ePYEU2QW0i
	qyWL/2e2qeQ==
X-Received: by 2002:a05:6a20:a121:b0:3e1:5481:5457 with SMTP id adf61e73a8af0-3e2260271afmr1650462637.31.1792232457783;
        Sat, 17 Oct 2026 03:20:57 -0700 (PDT)
X-Received: by 2002:a05:6a20:a121:b0:3e1:5481:5457 with SMTP id adf61e73a8af0-3e2260271afmr1650414637.31.1792232456626;
        Sat, 17 Oct 2026 03:20:56 -0700 (PDT)
Received: from ZBook.gateway ([123.208.39.53])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd65497df08sm2115250a12.6.2026.10.17.03.20.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 03:20:55 -0700 (PDT)
From: Changwei Zou <changwei.zou@canonical.com>
To: stephane.debusne@cynove.com
Cc: changwei.zou@canonical.com,
	davem@davemloft.net,
	herbert@gondor.apana.org.au,
	jeffbarnes@linux.microsoft.com,
	horia.geanta@nxp.com,
	iuliana.prodan@nxp.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lukas@wunner.de,
	martin.kepplinger-novakovic@ginzinger.com,
	pankaj.gupta@nxp.com,
	sahil.malhotra@nxp.com,
	sahil.malhotra@oss.nxp.com
Subject: Re: [PATCH v2 2/2] crypto: caam - Use bounce buffer for unaligned RSA destination buffers
Date: Sat, 17 Oct 2026 21:20:47 +1100
Message-ID: <20261017102047.333792-1-changwei.zou@canonical.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261017081417.2775186-1-stephane.debusne@cynove.com>
References: <20261017081417.2775186-1-stephane.debusne@cynove.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Stephane,

Thank you very much for your help with testing the patch.

In fact, I had previously submitted another patch to fix the bug on the caller side:

https://lore.kernel.org/all/20260731024446.786329-1-changwei.zou@canonical.com/

However, Herbert pointed out:

"In the Crypto API we don't ask the user to provide aligned data. 
In general it's the driver's responsibility to ensure proper alignment."

https://lore.kernel.org/all/am2UMhd5CAhDiKBF@gondor.apana.org.au/

Therefore, I later switched to a driver-side solution.

I'll include your Tested-by tag when I submit the next version. 

Thanks.
