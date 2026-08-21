Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B9E2E040D
	for <linux-crypto@vger.kernel.org>; Fri, 21 Aug 2026 05:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787289519; cv=none; b=GII0TmDr/w4Ww/Mbe8jJAIcIDuMeeUvAKsmMyK0xeIklrSWo4D9XJbWnquypfgFbRsH4kIwnpjKJyE+CxCVLCpCKJa3ZlApFddR8dwCqbm1UVzJHNb1ZFbDXEx+fwmSlIz07zDUsSzGeEJH6k2i+PJXK/uHiNUze3wjQKhyKXX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787289519; c=relaxed/simple;
	bh=NU0VS62bVT9dk9mjXMVNjXu6swHBHGQ7ePRPUvfV61o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qSgbHTb0SvQARfahkoCaKUzB3eBVFrIUQFNODefictZhPOrtWzcQNjDZOoaZKSwbMZ3WwtI4xOUwPZTBBQOxDA8/VQdOEQ8LBILpvYoAjwga9CdZXXlAt4nZqLiucncZOCF6UI+JP+tYxISkYPMXzryAMCEj8DfYMCJH+1f0eEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=XEXR6mJY; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="XEXR6mJY"
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id C36624259A
	for <linux-crypto@vger.kernel.org>; Fri, 21 Aug 2026 05:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1787289514;
	bh=NU0VS62bVT9dk9mjXMVNjXu6swHBHGQ7ePRPUvfV61o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=XEXR6mJYOYrDC2DyiF7pRP+Z/0OEcYvwvQizaMNPF/IvnKb9uhGWTSyiOCyl/HARh
	 9HFBR0a9WXJmpAqF3KxsnTdZuzsMiZh/Oy9+XqLpqfpT8ZflCBKPkdMsMsX+NvKwcm
	 DElpBdeNBeDBTmfFNjXkR3YH3vJFQrITwatwe5lMoaLaXTBMTfpB+deMw7zxggfY5t
	 N51fNX7FuNQnPadXy0XqJAoLJ8bdmQgG8PJNt6xNhngYD7q++YIuQuYpb3zsY4rgr2
	 Wj2749KMZEko4CyDVp32+ImUwUgvsWXWbm0JTLw2ZC0YMkbtvt3Doy5Qp5/QRwJkL8
	 KUPdHZeqkyL++Ev99Hh0n9sjKNUlDaTfpQZROKPCh27B14PrOV0XaxLh5yOPOhj2Wq
	 285F7+XFSJIPd+rqeqCzuVOsSHzD6js1G36Ch7JLsxjsRa2GMMWlxqneVCF3Y09fV5
	 IuHlQl5ion8z7yoUzVazjL7E8SAdJ2RnJiJ+Rn74O5hsNk1xep3mI6K+NjWRCbMysZ
	 phChxqVr+L/cpAA4ti+PWEJS2axJqHYh5lSU28Y+SxAWV/YiSjYHO5X/paKzVpFQtV
	 w7h6uq5OOnvHJ3TQarSfVA7Y2rgPQqgZzl0rn4wzi5q9lgadj6puU8RA/OsMgdhJSC
	 h/7wiiRTxMQTOpSeerXlRK3A=
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-84eee2147ffso785298b3a.0
        for <linux-crypto@vger.kernel.org>; Thu, 20 Aug 2026 22:18:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787289513; x=1787894313;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NU0VS62bVT9dk9mjXMVNjXu6swHBHGQ7ePRPUvfV61o=;
        b=dzhoaAyCmzISNgQDgSCKLdtSDLA3wi6EgVLPyeIJl6KjWbX4EYCrIY+QWwa0FogThw
         LnfUZOr+x0b8NLUb0nFmvNeCrloy9Wy6VJEUyf1PUMM3+zwYChHmiqxNPay9DKfpJ0lX
         vfa8HNrih65F0EDykeMBsYxP7dM/AqtMvSGDMilb74Lg1i93UjcrwkZI9PbLLon7o2eT
         fP81ve8nVGMbHRS7yfm6J26T9/qI2jnboblvEio3zRNNG4IX7svjfFbP8470oFUrnQoK
         Fmx1NEK4Kq9Z3hyUmLZLmmrTNuTpz5pg32VKBxRPA17xMQbjNa7+DqlXuLxqAK2VD1UW
         WXjg==
X-Forwarded-Encrypted: i=1; AHgh+RrkACRMHcBw3mUhWgGOY9LJvtBExjYWBDXtf6JExt701cZB3YHkmgodIbaTu9KbHyehbYVTtrq8Sf2OhuY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxkwFilMlMVSO9bgstlneABoF4Rqo//o3QM2c7xsT96HUQfGXRz
	XqaOE5yCtfDo4DT0my+GexK1FpS9qnBJ0E7RCkY/HRV/gmCdiWhIlD0UVaGX9tPl/KUUdESYfa4
	9xJJwZG3gB0vT31RSCWTGGjkJU0YDyJaoKjMUtEe+3KBqn9oPrv6mcjxy7gNlWFPAkk7UKMch2/
	HP9P28Zw==
X-Gm-Gg: AR+sD11Xtl/Ew1II3e1lW5VhKCv1/ydKtSGQx6yyxMsl0Ebc5hEJLeUS82KTOQGBMOr
	QZbMoDVyrneF9dukLOjp/BYG3229IjHols2bg5s6k4lqhLWalZVIaIZCe+k3xg+RSORpr02DAEu
	IpvaIzWcKuMdC0ZUGPzIX89FgRqC0LKTU1E51ofYpMv3+C+w233PIiv8h3mqgaLtm6kpTPwoFc1
	d6+2baN2V2QBuBz08tEmFclUBpHn1AetB3O8GyS6gj2NTsD5GOR0TPq7ii9+WfnG29oyKEVypFo
	T3h06eSq44ANGrIoqM+ZeydbHbqVNQX6CLLvaZq3p8Qc9b0jWmiDK7ehwn1jNk7Bwg9v7FTsOIA
	k0wFjebEr0Ls=
X-Received: by 2002:a05:6a20:7348:b0:3cb:853e:850e with SMTP id adf61e73a8af0-3cd300132c2mr6293091637.13.1787289512838;
        Thu, 20 Aug 2026 22:18:32 -0700 (PDT)
X-Received: by 2002:a05:6a20:7348:b0:3cb:853e:850e with SMTP id adf61e73a8af0-3cd300132c2mr6293037637.13.1787289512466;
        Thu, 20 Aug 2026 22:18:32 -0700 (PDT)
Received: from ZBook.gateway ([123.208.39.53])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327bf15ff5dsm22655130eec.25.2026.08.20.22.18.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 22:18:32 -0700 (PDT)
From: Changwei Zou <changwei.zou@canonical.com>
To: herbert@gondor.apana.org.au
Cc: changwei.zou@canonical.com,
	davem@davemloft.net,
	gaurav.jain@nxp.com,
	horia.geanta@nxp.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lukas@wunner.de,
	pankaj.gupta@nxp.com
Subject: Re: [PATCH] crypto: caam - Use bounce buffer for unaligned RSA destination buffers
Date: Fri, 21 Aug 2026 15:18:24 +1000
Message-ID: <20260821051824.808269-1-changwei.zou@canonical.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <an-6Mew-8fQaf5sb@gondor.apana.org.au>
References: <an-6Mew-8fQaf5sb@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Herbert,

A new version with two patches and a cover letter is available at the following link.

https://lore.kernel.org/all/20260821045555.806471-1-changwei.zou@canonical.com/

Thank you very much.

Kind regards,
Changwei

