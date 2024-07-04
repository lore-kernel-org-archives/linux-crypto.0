Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE7314B966;
	Thu,  4 Jul 2024 16:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720109737; cv=none; b=IrC4YDI8WKQKS/TfCQZ1pySESgFJOnhwXRx7XqTP99GEjRCpAjQLHuF3mLxd87MrqTU9tpFqmGqu2RYz02CDmm0gGl++QtYV2L/E3cIrikmmtZlWpSRmgzWsnRRfJRBEaZx7bEOu2QYyMwXsvY8PYhRjFLaec/ICrd1ToeNC8CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720109737; c=relaxed/simple;
	bh=c4q5Jgv8TLP8NcmfeDKwvvOhlsN3MP6PRX2BR1kN7zs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=almrmO68uqmfhJ7HCRCCECB4cIJdc7DyG5fJc1lKF+bZ44bonxDaKDqhiIT9vvQ4IyTpaZV/TJgAUfcDg+wGVvj+ln8l3OapO2vwQRPVcUQCfakdd8M35kr7D5ox9lNja+GQWsBH5mTQcypc22hucniKWnekfLQiqIiDtCofxJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a729d9d7086so339034566b.0;
        Thu, 04 Jul 2024 09:15:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720109734; x=1720714534;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ifhtzXGs+i5f3VXWSwrfmv9kw+0cgBz6vNCd3/K8wJo=;
        b=tBGLiDg0Vc7GjjEuDfBNalLiZ4KqDEfa2ac34pRec+hfcDl2bPjVPgW6BtM1U35sq3
         3zcQChrW0GGKiTSDBD8TtKyXSU2aQGl0Ez7SO3XTLs1/aKXAo52AKKRAZ37MPcpHcFd3
         bnQnUK9dJ+AXjeNiBbiW02U7mMhs1PnNGkCir2c8qbrLdg7cdVGr82UVyaozNrZpV2lp
         bOoXjdzBQsqvX1zMJYnHcCjCy6M7rRv7XjRkeWAK7nK/yRNJz4U13S7Em4//OXCsmClq
         nQpDobAlQPVB9gqR4XBohmeP51fTqZL4vz+RSlDA4jisBG2wggXXBWUOXAcZmECG4aSn
         3dew==
X-Forwarded-Encrypted: i=1; AJvYcCXmr3QGRH9DgZXdYDNfkgf5vRF9aKZjbvTXOZEGTkbzJaN/5++Zjdftodf8O3Gy4YyqNm/xlQIev0vpTnNyI20ukfew77nagyPysLSORG0LRSTZ7o1k5J2HvU53jCzEq2a52LS8/ZY9nJixvMjum+hO1IZq2mBtmqgVx4KzHEqVIJ3C
X-Gm-Message-State: AOJu0YwRj1LAsKzamxqHx8I3/GC/ZMeN1E4X8rfkzVG5vLl2uGhiBOiu
	Qla8N8CXEmREMRJYFqp1keZEc+2msz/caScbsKuCqlGEat1neGwq
X-Google-Smtp-Source: AGHT+IHyIp9PHYjXo9rsa26hJ5TZ1+lz779fiuQgo4pA6qV9Q55a9y4V+mdgajPl/5voXT1eb1gdAw==
X-Received: by 2002:a17:906:f882:b0:a62:e450:b147 with SMTP id a640c23a62f3a-a77bdc1f137mr150099566b.29.1720109732671;
        Thu, 04 Jul 2024 09:15:32 -0700 (PDT)
Received: from gmail.com (fwdproxy-lla-004.fbsv.net. [2a03:2880:30ff:4::face:b00c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a72ab0652d8sm612815566b.98.2024.07.04.09.15.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 09:15:32 -0700 (PDT)
Date: Thu, 4 Jul 2024 09:15:29 -0700
From: Breno Leitao <leitao@debian.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: horia.geanta@nxp.com, pankaj.gupta@nxp.com, gaurav.jain@nxp.com,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>, horms@kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 3/4] crypto: caam: Unembed net_dev structure
 from qi
Message-ID: <ZobKod5Fhf1kvLp1@gmail.com>
References: <20240702185557.3699991-1-leitao@debian.org>
 <20240702185557.3699991-4-leitao@debian.org>
 <20240703194533.5a00ea5d@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703194533.5a00ea5d@kernel.org>

Hello Jakub,

On Wed, Jul 03, 2024 at 07:45:33PM -0700, Jakub Kicinski wrote:
> On Tue,  2 Jul 2024 11:55:53 -0700 Breno Leitao wrote:

> > @@ -751,10 +766,16 @@ int caam_qi_init(struct platform_device *caam_pdev)
> >  		struct caam_qi_pcpu_priv *priv = per_cpu_ptr(&pcpu_qipriv, i);
> >  		struct caam_napi *caam_napi = &priv->caam_napi;
> >  		struct napi_struct *irqtask = &caam_napi->irqtask;
> > -		struct net_device *net_dev = &priv->net_dev;
> > +		struct net_device *net_dev;
> >  
> > +		net_dev = alloc_netdev_dummy(0);
> > +		if (!net_dev) {
> > +			err = -ENOMEM;
> > +			goto fail;
> 
> free_netdev() doesn't take NULL, free_caam_qi_pcpu_netdev()
> will feed it one if we fail here

Sorry, I am not sure I followed you. Let me ask a clarifying questions:

Do you think that free_netdev() will take NULL ?

If that is the case, that *shouldn't* happen, since I have a cpumask
that tracks the percpu netdev that got allocated, and only free those
percpu-net_device that was properly allocated.

Let me simplify the code to make it easy to understand what I had in
mind:

	int caam_qi_init(struct platform_device *caam_pdev) {
		cpumask_clear(&clean_mask);

		net_dev = alloc_netdev_dummy(0);
		if (!net_dev)
			goto fail;

		cpumask_set_cpu(i, &clean_mask);

	fail:
		free_caam_qi_pcpu_netdev(&clean_mask);
	}

	static void free_caam_qi_pcpu_netdev(const cpumask_t *cpus) {
		for_each_cpu(i, cpus) {
			priv = per_cpu_ptr(&pcpu_qipriv, i);
			free_netdev(priv->net_dev);
		}
	}

So, if alloc_netdev_dummy() fails, then the cpu current cpu will not be
set in `clean_mask`, thus, free_caam_qi_pcpu_netdev() will not free it
later.

Anyway, let me know if I am missing something.
