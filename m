Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB1329D1C
	for <linux-crypto@vger.kernel.org>; Tue, 26 Mar 2024 09:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711443632; cv=none; b=TCfjF4pGFKE6x5fMHrlLY+3/mnV1fVTlJNrF60ENwr/geeaAt5j13PkE7osHgVBBUInlG597uFfXPuGFGJUK/bbMbDYUkLYfReufj2Hizg1jNmMl0pC2XeuvzB88KC5pbdei78mitmsjh0GFsAbbX1Fm86jyaMwgL5vn3UVYenY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711443632; c=relaxed/simple;
	bh=NtRuqXWxjKnN7viwmR28Pf5balV8up66LErQMgZQF80=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CZ3As7qVJ5zeI9JlQYY1X3XhFleWmAjzmzEe401OLX9YnEyZzQ+B16vg+O/Dwb1iVwbP9DIe/51f/rx1Twiuto9vAruUg75lqCSN7pUJdFs8Rsuk5jVjFOaDXYgP15ZIpe5mTDs98k96MC+YqGZ1iJyXeLnzwEtJS0t1e2aTFWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=OUAhBaT3; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OUAhBaT3"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a468226e135so620411766b.0
        for <linux-crypto@vger.kernel.org>; Tue, 26 Mar 2024 02:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711443629; x=1712048429; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=m63gCWGRhL/wRJdhnP7MEeXdlJyGmEWUu13/Biz4Pfc=;
        b=OUAhBaT39ks85JTqUUStjq5VrUDvqNxmNfihJPzw3MYUw9QKD9TnKdfe0RM6M9uqoL
         AC1yvUi0hGacyUc3FDX6NlV9MMh0Rs7VowTZlsPjox453M9ou1EO3fDji19rpTTXwSoI
         MTsfNREppPAnUXgv1I0W98ILkTInt/AGPb+StcjUcWbi4EehN+o3USgGNjx40ZcF2Y7c
         88/i1fYiRauvkV7RywZxEf+gj/3XrS6Ww9cwXaXGGQAiy7eRZkR+8JbakZRb/YHKABPD
         jFbCURnOhAvJ0b7mr+V5LG6vGObR9vdo+zuNT+tZTV0UDZ1eY75ambJhw9cq6lGkJgsx
         tf8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711443629; x=1712048429;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m63gCWGRhL/wRJdhnP7MEeXdlJyGmEWUu13/Biz4Pfc=;
        b=PhLE/9bme6HZn5nwAviWsAgdSe1+yNmZwGyd2d7HqBf9tzhfg6R3hPicayiMjOCL8q
         dBrk+YOx3oeIJLdDiwC+Kawz6JPlOEmoKhNqyxatxfHP3SSFEVQP9RZcWDIWo/J2yWm+
         DaWF4LJ8g18+FbeTrHs7DSIaHwUAruIJOj7uc+5oJRhqBbdFHVWaaocW/vrsgZreMSI4
         p+t4gJbsuZu++BzuzzQV2pOpRrs81xGGTuz4Pb2zd/WSq9yibB/Oxfwz00/mQ6924dKG
         qWcAVz0UoeAxYhs2CBrLDAmV/Fe3eLEWiHtUW4eoPPL7RHNLIPOLNKeJKw+0zl7S8dFp
         iQvg==
X-Forwarded-Encrypted: i=1; AJvYcCXXwVkjWqppcasMRpijeobq45jgnSCYtJ4dKQLuqd91GBLM2v3yFCotZD2VmvnfdthUdXJk21gX6IZtFdBxy5WvCHf6YYud3EnJ+KWh
X-Gm-Message-State: AOJu0Yx+/EbIuNDad9r80N9I+yGLgNNav7yZZOeBQWinAogEVXpb1jw2
	vHMd7JMqNjO/Wdb06wV3nsG0f5wxFnqy6VcmI21Hbb/zvvs2rRHFvmVhMqOtfuQ=
X-Google-Smtp-Source: AGHT+IFjgo1w4nZ2O4eNk881Ww1anaBEX/i76CaqNoRSwZEdcRCn3dyIq8WxNXo9+RFpWyaRh5TiwA==
X-Received: by 2002:a17:906:1194:b0:a46:ac10:1cde with SMTP id n20-20020a170906119400b00a46ac101cdemr1328114eja.45.1711443629180;
        Tue, 26 Mar 2024 02:00:29 -0700 (PDT)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id jy10-20020a170907762a00b00a461e10094asm4021494ejc.95.2024.03.26.02.00.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Mar 2024 02:00:28 -0700 (PDT)
Date: Tue, 26 Mar 2024 12:00:25 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Gregory CLEMENT <gregory.clement@bootlin.com>, soc@kernel.org,
	arm@kernel.org, Hans de Goede <hdegoede@redhat.com>,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5 06/11] devm-helpers: Add resource managed version of
 irq_create_mapping()
Message-ID: <72bf31c3-337d-4747-8353-639492507a7b@moroto.mountain>
References: <20240323164359.21642-1-kabel@kernel.org>
 <20240323164359.21642-7-kabel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240323164359.21642-7-kabel@kernel.org>

On Sat, Mar 23, 2024 at 05:43:54PM +0100, Marek Behún wrote:
> +/**
> + * devm_irq_create_mapping - Resource managed version of irq_create_mapping()
> + * @dev:	Device which lifetime the mapping is bound to
> + * @domain:	domain owning this hardware interrupt or NULL for default domain
> + * @hwirq:	hardware irq number in that domain space
> + *
> + * Create an irq mapping to linux irq space which is automatically disposed when
> + * the driver is detached.
> + * devm_irq_create_mapping() can be used to omit the explicit
> + * irq_dispose_mapping() call when driver is detached.
> + *
> + * Returns a linux irq number on success, 0 if mapping could not be created, or
                                             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

> + * a negative error number if devm action could not be added.
> + */
> +static inline int devm_irq_create_mapping(struct device *dev,
> +					  struct irq_domain *domain,
> +					  irq_hw_number_t hwirq)
> +{
> +	unsigned int virq = irq_create_mapping(domain, hwirq);
> +
> +	if (!virq)
> +		return 0;

What is the point of returning zero instead of an error code?  Neither
of the callers that are introduced later in the patchset use this.

I understand that it matches some of the other legacy irq function
behaviors, but I think we are trying to move away from that because it
just leads to bugs.

Since we don't need the zero now, let's wait until we have a user before
introducing this behavior.  Then we can add a new function that returns
zero, but we'll still encourage people to use the standard error code
function where possible.  And at the same time, when we do introduce the
zero is an error code, function you should contact
kernel-janitors@vger.kernel.org so someone an write a static checker
rule to detect the bugs that result from it.

regards,
dan carpenter

> +
> +	/*
> +	 * irq_dispose_mapping() is an empty function if CONFIG_IRQ_DOMAIN is
> +	 * disabled. No need to register an action in that case.
> +	 */
> +	if (IS_ENABLED(CONFIG_IRQ_DOMAIN)) {
> +		int err;
> +
> +		err = devm_add_action_or_reset(dev, devm_irq_mapping_drop,
> +					       (void *)(unsigned long)virq);
> +		if (err)
> +			return err;
> +	}
> +
> +	return virq;
> +}
> +
>  #endif
> -- 
> 2.43.2
> 
