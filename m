Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ECF52AF17
	for <linux-crypto@vger.kernel.org>; Mon, 27 May 2024 08:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716797771; cv=none; b=bwYJYTtMyDNul75B5bsKYAG47ZjC21wcPhQYaRXQqdo9g3sZ+APCjwDz7g4lLR7xOMlFITtwLiF/nr2HVaRWEYZz0uEhPcE5DZ6rUNs+NO0WSsBOYexWu7fsGaZIM3V7JrvuRcaxUZTAha0H+Vf3OiwxnTT0O89KvUzXqdrlMds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716797771; c=relaxed/simple;
	bh=im+llKHRV6/OLwUXArxx3xlTY46nqAVvEgvK+7QBrq8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AhyJSmRbedv3OU+IcRbRdjc8AzSJYVzXLTx37OttQv76kKKxZPhv0GXZCWEIRaQthBdMlDUwmKmX2ULku5ux976K1NivPIHz5oW59IOCaYY/PIFykRNtexaMQbAh/ybNsoxXdukZl7kmedg93+0M/TKg3EezENHr3LWQqfj4EAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MZcbzZ9u; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MZcbzZ9u"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-578517c7ae9so3459197a12.3
        for <linux-crypto@vger.kernel.org>; Mon, 27 May 2024 01:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1716797768; x=1717402568; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ti6BQ0nZTqoUPvV5Y4Ffa4XsuHRMzdkHsHYxPtpQMhU=;
        b=MZcbzZ9uDrTLeiiGl7sQd46M4w61vd2ICl8feR1Z+7bcM/DEihU01MZ2dMtsMf1XPo
         lGGbCW7PBcObzPMm7xvD/WvBYwDJpf7/yYYqivQV74HsFvgI+DGtH91teVWEZM2XgE3p
         Z+5wKbqVxokdRMHpBjk8KQgrmtVyGWPKkvWH5zNWMjCenyXeZ0mL8ktkZ6laPaD3pwf0
         o7DqIZYlOb30rUzRlrVfhCkMnxDrBdDsT3GNEA9jhakZ4XjyHIFbwvLC3WLmUaeLDa9x
         RG00fnRdV13MZ9YUPsS3dvAh1sZuTaQT49OZ/u5KenDufEXIOJpBi3NqhJqXBIHYuIyf
         Q2hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716797768; x=1717402568;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ti6BQ0nZTqoUPvV5Y4Ffa4XsuHRMzdkHsHYxPtpQMhU=;
        b=kM63UbIfgV+WEZEBSwdSLmusP90Y99FsBBAOp/yABLd6hNCfH0LaUCpWeaV9G2JehQ
         mMj/0YcZtUd48GUYiNidbidj1yenbblf4MBRYSP9lAp64QSHKEqN/qvYyByKolaFRRxw
         s+6MZP0sOLJPfIsUuglrQ7XZ5rB/UnoNEW90WKE+5itrZGOA4UPeW6xIHna+Z8AwbHlK
         JyrQNLF1ZgSXTdTHEFEaA9n6bDyoUqAIPqNYPXyaczdZYOxKJMZ2k/qy5H4b6U+IDZsm
         obF4keRP1kinDQ8PsUtLqJm041jd8rXfl+ahRbq40qFpJwJomOd3x63mNT2gD9jothOY
         P9WA==
X-Forwarded-Encrypted: i=1; AJvYcCX9Uq0VI7u9RgejoYm7+zq0pKEXjHIiDSUh9MEHY820OedK+d3vnab03eAiWACxbuM3b51ttgOkamTM13kK7fXxjKQ1pvLPi2R1HmAu
X-Gm-Message-State: AOJu0Yx/9FTfsixiGE055yVAFgdQsDF0ylyO1LvGvmxQ2ebY7Y+BA3qf
	vSC9tF87INblrxh9dZZZUZaakxE8+Qjc8rXQ6bjoWlCXEneOxN6uxWQ/aqMCvJU=
X-Google-Smtp-Source: AGHT+IGSR3D+cVueBrqe8m9RKJMLR/YZi8ejwDS2zj+FbDq+GuOv+ZeKHZ/hsVXQtzgukx5feH5U8Q==
X-Received: by 2002:a50:d751:0:b0:579:e283:d2a4 with SMTP id 4fb4d7f45d1cf-579e283d715mr125928a12.36.1716797767681;
        Mon, 27 May 2024 01:16:07 -0700 (PDT)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5786c0dc384sm3234417a12.75.2024.05.27.01.16.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 May 2024 01:16:07 -0700 (PDT)
Date: Mon, 27 May 2024 11:16:03 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Lothar Rubusch <l.rubusch@gmail.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel-sha204a - fix negated return value
Message-ID: <28dfdd52-e72a-4465-af7d-7b10c635b150@moroto.mountain>
References: <20240526103128.14703-1-l.rubusch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240526103128.14703-1-l.rubusch@gmail.com>

On Sun, May 26, 2024 at 10:31:28AM +0000, Lothar Rubusch wrote:
> Fix negated variable return value.
> 
> Fixes: e05ce444e9e5 ("crypto: atmel-sha204a - add reading from otp zone")
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Closes: https://lore.kernel.org/linux-crypto/34cd4179-090e-479d-b459-8d0d35dd327d@moroto.mountain/
> Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>

Thanks!

Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>

regards,
dan carpenter

