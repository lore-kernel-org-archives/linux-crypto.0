Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525A586AC1
	for <linux-crypto@vger.kernel.org>; Wed, 27 Mar 2024 11:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711539569; cv=none; b=krBWkADh1gqqIzKE9i9mMn+9CP3rngy1ZWDGzTFFXwob2acQIAZjqXLDhZi/znDqMdaZa0Gv+cG9SxlYn5J6ouXonnDcWvnpN7qwPo6Y9kDrhxp0vM6Q/XVct1WALdFmZ8ATuzVsdbxPUHohTWHHyYUZagun51E0eag3tTFR2uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711539569; c=relaxed/simple;
	bh=pXBzSvnixq/m57ple/gS8ExDn2YvQoVopxlyyxgarts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NtPsjOzJ3vR+5sO7Zgn4Ck+iDYYY6ppHPmAbbq2MhX8w5UVkayeKq3WBodYvhqmSAvuH2RgFM85vdx62MGBP1g7+k3CB5bRozTpP7CzJeVqRRzN0BgGKoJt4eGEaxqbID2m3ubel4kSfQDNw0pMwF2hFygOC39Dldrqin5pgY8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Q8YsY57C; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Q8YsY57C"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a466a27d30aso813092166b.1
        for <linux-crypto@vger.kernel.org>; Wed, 27 Mar 2024 04:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711539565; x=1712144365; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=m93ME46lQ7B8wqoBDoWv3GJg3rLMXw/sn+I50eOHnUw=;
        b=Q8YsY57CPGxlTNbXw0mCdSQaF4kGNDeoIzgCoiXtTEEvLJ0PTbSKOUpXip9pj/BQm+
         QitzbpeZ73jRbiBe58DiGPZIY6XS7xTp4syIrwIckzqzWiqtIAdHxW9F38uahyugHMPI
         NMmBQyZXeeZaJ4WduDruYaCEVGgANCEu2oEJEMEBJsEpwF8Tn0Oakh+cKX4Lk87NWNt+
         hDWHP87T6oooIoPlcTnQt7ANhPHYN0DDCn2sksqUF9QuGhPRj1hZT7NYiFV48bMlA/O7
         WHTFPjW9WhUAGWuTfJynMyZd7YvB8ilReaKS00A65nv1rkqv/knEu9YIm0nlhFgCdTan
         9fhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711539565; x=1712144365;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m93ME46lQ7B8wqoBDoWv3GJg3rLMXw/sn+I50eOHnUw=;
        b=BDL9fscq9SwH2USiNGD/2UcASnU6CmV1+keXvb0wpOUnH62um7tFmxFDDu7rgv8LWa
         9dch9peW0Lr5OeIp2tP59BhSLeiripCkFiwXkc6fEPQb8vvQkexuAQVAwQZgsSi9L0YN
         itmqW3JP+p7XNeO7aHkkSkkR7Um2kF5WP1YSUMN5H44ISlUM4VYvKCT4oZsKaoPlZwLm
         Q0XMPoCfj5N8xQHKyxKYBghwGbo+fI5h3WlfAvEuQf5sl2IDxUFM3sjA/75KofDnJ7+i
         r65G+3DkRH+zg/IMHVqldAowXrQkd5pntp54yFwsh0+79TNADMNJQy58TcbrvOcremBN
         C/6A==
X-Forwarded-Encrypted: i=1; AJvYcCXUS0LKf2TZN9VQEPyyOhwxeoeEhNSvB7SmREF7ajc/S9LBUlnu3Qjr+maU37IhTPxjNY4jxmvpkpwkowu//W8LQ3XL8AH45KEu03rc
X-Gm-Message-State: AOJu0YyVwU6oS7k+plCYeQAbrXQX6QpWVt1Kr+Hr4hd8M3GjW7nlx0h2
	gFUXgeF+sfcgFC6P+towUjvloua8MriW3lcRg2644G79FjP33agoiM08xDH4ZUY=
X-Google-Smtp-Source: AGHT+IEh2db7nxCaUxEgb8RbXF0TQ7G70ljNTsa7xYgI7dJAup4kRdGFRMsvRHBlJJgmz+2s0cMLaQ==
X-Received: by 2002:a17:906:b1b:b0:a47:499b:d735 with SMTP id u27-20020a1709060b1b00b00a47499bd735mr745672ejg.14.1711539565301;
        Wed, 27 Mar 2024 04:39:25 -0700 (PDT)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id la5-20020a170907780500b00a45621ded4bsm5395486ejc.146.2024.03.27.04.39.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 04:39:25 -0700 (PDT)
Date: Wed, 27 Mar 2024 14:39:21 +0300
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
Message-ID: <b70ec580-dfac-48bc-87d6-b30f2e91f723@moroto.mountain>
References: <20240323164359.21642-1-kabel@kernel.org>
 <20240323164359.21642-7-kabel@kernel.org>
 <72bf31c3-337d-4747-8353-639492507a7b@moroto.mountain>
 <20240327103419.3918953a@dellmb>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240327103419.3918953a@dellmb>

On Wed, Mar 27, 2024 at 10:34:19AM +0100, Marek Behún wrote:
> On Tue, 26 Mar 2024 12:00:25 +0300
> Dan Carpenter <dan.carpenter@linaro.org> wrote:
> 
> > On Sat, Mar 23, 2024 at 05:43:54PM +0100, Marek Behún wrote:
> > > +/**
> > > + * devm_irq_create_mapping - Resource managed version of irq_create_mapping()
> > > + * @dev:	Device which lifetime the mapping is bound to
> > > + * @domain:	domain owning this hardware interrupt or NULL for default domain
> > > + * @hwirq:	hardware irq number in that domain space
> > > + *
> > > + * Create an irq mapping to linux irq space which is automatically disposed when
> > > + * the driver is detached.
> > > + * devm_irq_create_mapping() can be used to omit the explicit
> > > + * irq_dispose_mapping() call when driver is detached.
> > > + *
> > > + * Returns a linux irq number on success, 0 if mapping could not be created, or  
> >                                              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > 
> > > + * a negative error number if devm action could not be added.
> > > + */
> > > +static inline int devm_irq_create_mapping(struct device *dev,
> > > +					  struct irq_domain *domain,
> > > +					  irq_hw_number_t hwirq)
> > > +{
> > > +	unsigned int virq = irq_create_mapping(domain, hwirq);
> > > +
> > > +	if (!virq)
> > > +		return 0;  
> > 
> > What is the point of returning zero instead of an error code?  Neither
> > of the callers that are introduced later in the patchset use this.
> > 
> > I understand that it matches some of the other legacy irq function
> > behaviors, but I think we are trying to move away from that because it
> > just leads to bugs.
> > 
> > Since we don't need the zero now, let's wait until we have a user before
> > introducing this behavior.  Then we can add a new function that returns
> > zero, but we'll still encourage people to use the standard error code
> > function where possible.  And at the same time, when we do introduce the
> > zero is an error code, function you should contact
> > kernel-janitors@vger.kernel.org so someone an write a static checker
> > rule to detect the bugs that result from it.
> 
> Hi Dan,
> 
> the first user of this function is the very next patch of this series,
> and it does this:
> 
> +	irq = devm_irq_create_mapping(dev, mcu->gc.irq.domain, irq_idx);
> +	if (irq <= 0)
> +		return dev_err_probe(dev, irq ?: -ENXIO,
> +				     "Cannot map MESSAGE_SIGNED IRQ\n");
> 
> So it handles !irq as -ENXIO.

Yeah.  But imagine how much easier it would be if devm_irq_create_mapping()
returned -ENXIO directly.

	irq = devm_irq_create_mapping();
	if (irq < 0)
		return dev_err_probe(dev, irq,
				     "Cannot map MESSAGE_SIGNED IRQ\n");

> 
> I looked into several users who do
>   virq = irq_create_mapping()
> and then reutrn errno if !virq:
> 
>   git grep -A 3 'virq = irq_create_mapping'
> 
> Some return -ENOMEM, some -ENXIO, some -EINVAL.
> 
> What do you think?

-ENXIO is fine.

regards,
dan carpenter

