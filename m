Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890E119DF62
	for <linux-crypto@vger.kernel.org>; Mon, 25 Aug 2025 14:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756133732; cv=none; b=SPMipxVOhS67p6ufWqvzexMPJ0CL7rpvg3vpmNc2u4u5mjxPsI4cP9bpUeTA3JctslOkfRXma+O4D+Jrmmocxt5wIf5NWnLMdyGD/JO8M57X9OYmtGNoAonzlUBM00oW6TYs9aAAep2JGqaNhyVw72QJQzLUGsS69V7t6KrAfEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756133732; c=relaxed/simple;
	bh=MUZh0fqX7er+3EBVq0tH9uE4JqSOrjhojj0dV8e6N9Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a8K/1Y58rXqiksVscRaYt6FW97oDWHhmBWwCB/r926CZGVnQh1pJs7FxcMh+tij+Ej055l1dAp+CUkptlU5KtwdQYgBTLIKloY0zCx8j5/a8x3m6B1VTabKM3EtFHQrstE3mxJzUNa6cZDPDvDoqE/tVHH06Am1cmx78GLpfAbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=cVDaPCmU; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="cVDaPCmU"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-55f4bc9bc93so121593e87.3
        for <linux-crypto@vger.kernel.org>; Mon, 25 Aug 2025 07:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1756133729; x=1756738529; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HZltQqa1JiPaVTEAokUCgaMM7517JDy9kaVACznP6Mg=;
        b=cVDaPCmUdvq8a8CAJenu7h76LxR4W6gj7SMAo2UMdTj3rNwJ4tOUEqmrp7QmsPOLz9
         FWyTGaCFIDeKFW7lbmFHLl82K9b9F9ZcaeQ1qy2XBiyupnUy5NpPe10tiWN+K7dZmZer
         BHU1ZpeD1BJtj0XC5m9a6zJr0iOklhTHWdukc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756133729; x=1756738529;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HZltQqa1JiPaVTEAokUCgaMM7517JDy9kaVACznP6Mg=;
        b=On0ifCy+uqs4ySbMKSnKFs0aiSOkgAFhYQpPQiI4nXlB9beQD/+Z7ckCI6ix5H1hZe
         xVk+5oCTPFoesOy6O4vdGMpBxCGJDmeAOfPcxbwlCsK0uDeOM/OlXcrgcv0UAw96PZfJ
         HBmrNk1ADCIcUkqPsLHC9agHca2J0FZgVeO7eLE+CWFD//6k9rDZvqMzZXouwyrBesT1
         D12MioxCIyoZir3U+p3qDZ6PBYTLIFeYVz+7V3pH7tdCmIrWsJ7yNjwb/Y9JML+7ZHsf
         qfQggHN4hU2Ij4QU0fItaPAwhTpr1NMUulHseJ4H0BYBDvwmBaRUDFCgWNKe4mZrNU8h
         0L1w==
X-Forwarded-Encrypted: i=1; AJvYcCW2ZttXhNZEJbyohLmOxPTBJXzKDSf/Mzrs+onLj752r+mQonMaqLG4gsc3nVUyPuTU2X3zbcEBu4UbGtQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXhOjJoyS8w0WpLDsxiTDxKLKglpbXm7udCEgYzN5JpZzkivHc
	gSwVuhzf84GvxTijN37LEcYJT4sJyWfY5++Pxltt/pefxhQv5h2w6ZebwWjJP/ImHQCcSb+Y7Yl
	b+MyucgXE8cmllyCM/PgunTduEh5gN2onMCx06Rvd
X-Gm-Gg: ASbGncssSTW/kEBWAxjm9W7+V2TH1oMYhK+Lc77+5IhmAUfGPH66zJAAJeHQBUamiy2
	dsh03BmjLuVC1l2YkOXrF8Dimnce7yP+he5WAHhdd0coRGqyRyMlnTwL8+nNZI3rM3Z4tBL1J/l
	ppd7gONdCbCa0nGLHhWYMpBoA2T5PA3LCI+9PekruxOT3Ed7SUC9fSE4TR9C6XOwrj/lWHvKHs7
	Xfv26ZaUg==
X-Google-Smtp-Source: AGHT+IEZpeoTDTSsArwCzl1l1l/wwXdnUcf5tNDKdV7KZZc7u29Ae3NIxjZuKBLSH1BoqzL03/Y6m1XaPeFnfadFQPw=
X-Received: by 2002:a05:6512:12c4:b0:55f:43ab:b214 with SMTP id
 2adb3069b0e04-55f43abb552mr1458116e87.15.1756133728719; Mon, 25 Aug 2025
 07:55:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250821175613.14717-1-ebiggers@kernel.org>
In-Reply-To: <20250821175613.14717-1-ebiggers@kernel.org>
From: Chen-Yu Tsai <wenst@chromium.org>
Date: Mon, 25 Aug 2025 16:55:17 +0200
X-Gm-Features: Ac12FXxjKOcBiTNpPdKXqoqBJ4orKCURYaKZfX9c6jF45-S8ShurjJD2-s3Vx6s
Message-ID: <CAGXv+5FxXcJxfCUcX2SY-agbi-sr+btXq2-sDx6quwGF2vu8ew@mail.gmail.com>
Subject: Re: [PATCH drm-next v2] drm/bridge: it6505: Use SHA-1 library instead
 of crypto_shash
To: Eric Biggers <ebiggers@kernel.org>
Cc: dri-devel@lists.freedesktop.org, Andrzej Hajda <andrzej.hajda@intel.com>, 
	Neil Armstrong <neil.armstrong@linaro.org>, Robert Foss <rfoss@kernel.org>, 
	Laurent Pinchart <Laurent.pinchart@ideasonboard.com>, Jonas Karlman <jonas@kwiboo.se>, 
	Jernej Skrabec <jernej.skrabec@gmail.com>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 21, 2025 at 7:56=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> Instead of using the "sha1" crypto_shash, simply call the sha1() library
> function.  This is simpler and faster.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
