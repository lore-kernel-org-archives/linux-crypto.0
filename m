Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A3D225A3B
	for <linux-crypto@vger.kernel.org>; Thu,  4 Sep 2025 03:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756958317; cv=none; b=ZD4QO/Y9/JLix9sWWtUwd3LLCYXsgqvgS5O5wtkNhjLBS8B0V07l9ZdrlnlGnJSjAeTc0y7XaU26y3VoLMgZu5xc5gis1VBD+e5T1MVrQLHqWpbmyATgR3263tJWhobNBC2eRqOQbG071hQdKCNURpa5tRRf4i4v6/2fNq5MQUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756958317; c=relaxed/simple;
	bh=6/Qaj+NgmUC/lhSw+pl11U983W+hD+qO4SvaZZK4NJo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=hKEtJi4s+LIrTy5+96J5+t/IoRT50dtuEsY8IhCqatp7opvnNnBIn58OOuJ6cBKCht6ctv6XwF9kLvtizSK6/Im4OqxSojiTQYtCohbxxYSl0cl1u75F4MY7Ole3PgL/53Ds0GTOXC+vlaab41QDyZgq6a0h8OvpZdHvnztlCXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=jlS0kHZG; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="jlS0kHZG"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-248cb0b37dfso5903515ad.3
        for <linux-crypto@vger.kernel.org>; Wed, 03 Sep 2025 20:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1756958316; x=1757563116; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vdcVC7EGsc3p5AhbAck6hSHkD/WxcPvPTOs/rsi4Pyk=;
        b=jlS0kHZGxaaKZ+BzehSYhZ5BH+G0/kF/FkzvCFjK1RrU9bCEeFjHGw+Uwjc+ODVV0S
         0MjqW9s6YtNYItvmvJ0XaKGykfPJdNl5DCH7vcbhKjvqv1xw6pvfC/PXoEDyfll4tckn
         IYQS5EYUiRYplkldr/+UvdZ43Beki9H4GK/pk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756958316; x=1757563116;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vdcVC7EGsc3p5AhbAck6hSHkD/WxcPvPTOs/rsi4Pyk=;
        b=eqSnBL+9R4RqHX2YqppK730iwnVRzkfZ0gQmgF7+ubUXa2dVxdmAO9SamGyLccS5IR
         jyTyEXCdCKPXA/6wmFu7knyBP8ntVGuSmYBwMo4TtJQzj6AQwc/5DcKQXrRWAp9D2lo5
         3Tm1LtUcHVjpNkBgN5kwfRnHBDjb1TDkpRTqvge1AiARvyEj6GdAzVvz4EoAy7ePKFci
         iTgtAxTmtn2KTXIVzPHzeBq83vQQr2cdNpoF85bEv/MTMX58wFHRXJXpdI83HygW9u+f
         UzFm/QUp+GZlRJJFb9eKP4tVssBl75VcRXOv9gPWW0EzO6f+vd+hMVfb5xY9f+ghCv7S
         wYqg==
X-Forwarded-Encrypted: i=1; AJvYcCUgPO3i9G4x8uZONTozSErjcrIjT+1pLVSTVvx4EnoNUZucfxDkHu86NhGZIKP3CuxII5LWAP46GMRhFOs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzc4jEzRy9itdH72NAGa+HT8yOL3Rcao+jFa5ydlQBey54YAE6s
	p8oeHZ9NmDprokPTCC0fAcv46k6AL7v4jRPuXxPEWj+cgYsig1FNRqF8Iddc0o3Gug==
X-Gm-Gg: ASbGncv8EDe1yb2pxZ+G7dsWTHD70EmBz89LTglm+dc6Mf61360KLwv2lcYOjg10fT7
	/tXa5D8vgOzeVPLBpy7BCpePhKg99ygKca+Q1cObZRNv5WuefX5afIZxjYMvalvH25dTXrNcElP
	xYE4IOufPcuv2xTJDIoJnxn4vDSxalmB7PKy5weC3LtJnNxQ6FuOdc+fizrpuJfzdwRs8qJCnv5
	yj189JudinizooiEzlEk68yJBsv17hEHvk74y5JzyUGf3TMe9+blbpBOGrkidlRBWlfdFZ/+kSI
	tt8nrm4G523OSVUD+qu4IzBMvyjveiY8e5dWqxLTzc7+wzUqttNNhKxYRCCaKB9Z22ZLfJRA2GW
	ok4WXKqUbwfvy5xZfbHRDFferQE+ZblB9crKQhNgW3GpCez4ldvjKNMYlLxXrRDmF5py37wv5Z1
	IjG8Td2pp3j1BnEA==
X-Google-Smtp-Source: AGHT+IFqjpDEL+NZxw/zBYdqqN1met/cuuCeIu/YOCgUar+yk4gMXjjK8G9vvtXW5yAKilSqQDIh9Q==
X-Received: by 2002:a17:903:37c4:b0:246:cb10:6e2f with SMTP id d9443c01a7336-24944907804mr238303175ad.26.1756958315783;
        Wed, 03 Sep 2025 20:58:35 -0700 (PDT)
Received: from wenstp920.tpe.corp.google.com ([2a00:79e0:201d:8:3c2b:f8f3:78fe:d80f])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24cb28c3126sm16707405ad.65.2025.09.03.20.58.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 20:58:35 -0700 (PDT)
From: Chen-Yu Tsai <wenst@chromium.org>
To: dri-devel@lists.freedesktop.org, 
 Andrzej Hajda <andrzej.hajda@intel.com>, 
 Neil Armstrong <neil.armstrong@linaro.org>, Robert Foss <rfoss@kernel.org>, 
 Eric Biggers <ebiggers@kernel.org>
Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>, 
 Jonas Karlman <jonas@kwiboo.se>, Jernej Skrabec <jernej.skrabec@gmail.com>, 
 linux-crypto@vger.kernel.org
In-Reply-To: <20250821175613.14717-1-ebiggers@kernel.org>
References: <20250821175613.14717-1-ebiggers@kernel.org>
Subject: Re: [PATCH drm-next v2] drm/bridge: it6505: Use SHA-1 library
 instead of crypto_shash
Message-Id: <175695831382.1322876.17900015503262535191.b4-ty@chromium.org>
Date: Thu, 04 Sep 2025 11:58:33 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2


On Thu, 21 Aug 2025 13:56:13 -0400, Eric Biggers wrote:
> Instead of using the "sha1" crypto_shash, simply call the sha1() library
> function.  This is simpler and faster.
> 
> 

Applied, thanks!

[1/1] drm/bridge: it6505: Use SHA-1 library instead of crypto_shash
      commit: e339a73737d365dc88e1994d561112ef2c21ad88

Best regards,
-- 
Chen-Yu Tsai <wenst@chromium.org>

