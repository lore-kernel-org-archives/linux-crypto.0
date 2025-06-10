Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFED721D3D1
	for <linux-crypto@vger.kernel.org>; Tue, 10 Jun 2025 08:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749542465; cv=none; b=OX29DBTfX4mYHTqeP/8n8Vyx2nlL03a2Sgz9N4SgMquchBNI06VFZsNlxyTHVIHX2HUHS/n8ZB8TO2vWaxkkh0i/t8LLmdHnlH4DDr1eD+lxWRLxqfJJf8YiN9dCrQ+esTn/m30oiSiyypOa06MsRgLLrr3tKHTbx0iWl5Xr7IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749542465; c=relaxed/simple;
	bh=GquF+jZovk8RCJjze7Xb5g+H3uRIu4j+p0ose5q2frg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z0mBExMgsjPWLO1aXi7PMjB2Ub1oH1eJriqLoXET3/Cc9RMA7PR2qj6z7ic8YnCoPEEDXwGTbrebV2sXS/ezP/s3NE1RHMXn9u3XWpgvL/xazNkgeelbTr2kPS9rQu/i8BvlicsbRZoEZePMmo/1aFAwduPLqV2E44VGlfZQOBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=A5L/+G0K; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="A5L/+G0K"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-441d437cfaaso31940995e9.1
        for <linux-crypto@vger.kernel.org>; Tue, 10 Jun 2025 01:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1749542462; x=1750147262; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mKWAmISk89aOM0wVfQYa31c/BeY5WyWlYt42tEpUpVU=;
        b=A5L/+G0KAf/tC5UTxw8H+KcTlDULc+AJRrXCCetXnavVixY0X98AOWcnQJkrdYTRum
         5S2C2829EQEvGy2KX425qu9m9NB4JDfpr1aAW2fGswD07hXlwonoxCjfnw4lCF2BAr0S
         PM+lvg1FeJW7TfxdQUX9sqiGM/mOLPHmPmrzeU5t61aY+MuoyhsXXorRtu5j/52cgFTt
         ObBLB2cw0/FPlHnWMtxTf8R/dbOJys2V27zBh+MBbM/JLRtWD2P6OBQnwsdK6nnu1Iw7
         LTCqr1pIJIRSVGYyADlGOcYAyOef1t9wgnjICb09CNL2MnHI1C4NeZReb70RV3gf/OXg
         ynMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749542462; x=1750147262;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mKWAmISk89aOM0wVfQYa31c/BeY5WyWlYt42tEpUpVU=;
        b=viHkK5Wbb84NqCmlUb5EaC0/tSw3QCYWmGJ7y8g9nvsYegK7lngw2uihhyPsfIHYrl
         FIcoZmlozGF5cCu3pcyuiIlIxSAc4Vx+vJ8D00ORW2oZBs/BH52HXlLMrM0VTYZzUbVI
         UiwYLieGe4hady0Xuw6wmU5odTU20bpBy6NhlcHa8f5OmlJj90Cje8iafCqyxMGu2RHk
         YN7NPZGYEMFeVXJ7KI0Zmim+19vPmILvMF0dwZKu3fO7KWVh4GPGtHcr698J7x2RNXmO
         Jp6peebp3F7cCiGIf1JxlhxAGpgdvWy13to9i38fW6iWn06fQg9fnnJMTEycEvlcl9Dj
         nwlg==
X-Forwarded-Encrypted: i=1; AJvYcCVoJIxPIF1j28iB96oo4T6vbOcCpdqoPCCkRs1Co4YpJDm2RKxx2olNIxCV6Q+p9kuN5ZDNp+Xlhbjxz4c=@vger.kernel.org
X-Gm-Message-State: AOJu0YydXVU4hTeUA8Xu9WaW3sEpfYIh5uqjLZZzotjK2nEVeEWubvJ7
	q6fel/PxpDMwcNCE+fHaJR48BULuKagv/20sY4pp80+8RDZ/W3+gW9G7XlxMrda94K0=
X-Gm-Gg: ASbGncvM+HSfYVgEvTZ/5LSQNKNvroueleb96udv3asW2CYHhySR0w6TUCfl6CD26jZ
	MXCEZpFkNbv7zVwvFuRttZ7JWYgFmbKBNkS8WyS9uz9ADZNR0oC3gcAXRVkGII9uSIbC9N8kiWl
	2ytXmVEudJtY/71eI3hPZKtEUrcURjmoteOzUzDEsKBCh4ZgD0gwBEt0jM1+v9QVxQpaO/0miit
	tYSW+SGg9pYUzPtbXz1v5/7SLOwh99F3ie9jUx6y9ibeOU3Gkc9aLwQ0HYK3Ju+7xkyYppHdSos
	GWS+t86D/qIJtHqSEBlzVITZM58FG33XG1nE9SwWk5EXwtA0LDBGyphqz6IbgYgjT2A=
X-Google-Smtp-Source: AGHT+IERMqPGjTquJvfsUCkSxdiNBdK+K6B6sBYGUKvuIYyCZj05skSoySHcYQ9VjAMuk44kIdnhIg==
X-Received: by 2002:a05:600c:6989:b0:442:e9eb:1b48 with SMTP id 5b1f17b1804b1-452014977f7mr135407865e9.24.1749542461982;
        Tue, 10 Jun 2025 01:01:01 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45307b9d827sm84741535e9.22.2025.06.10.01.01.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jun 2025 01:01:01 -0700 (PDT)
Date: Tue, 10 Jun 2025 11:00:57 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: "Jain, Harsh (AECG-SSW)" <h.jain@amd.com>
Cc: Krzysztof Kozlowski <krzk@kernel.org>,
	kernel test robot <lkp@intel.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"Botcha, Mounika" <Mounika.Botcha@amd.com>,
	"Savitala, Sarat Chand" <sarat.chand.savitala@amd.com>,
	"Dhanawade, Mohan" <mohan.dhanawade@amd.com>,
	"Simek, Michal" <michal.simek@amd.com>
Subject: Re: [PATCH v2 5/6] crypto: xilinx: Fix missing goto in probe
Message-ID: <aEfmOQm0FtqtP22v@stanley.mountain>
References: <20250609045110.1786634-1-h.jain@amd.com>
 <20250609045110.1786634-6-h.jain@amd.com>
 <25b144f6-ccf6-4426-a021-11f3f00074bd@kernel.org>
 <DS0PR12MB93454C9316C3C54E45BFD65B976AA@DS0PR12MB9345.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR12MB93454C9316C3C54E45BFD65B976AA@DS0PR12MB9345.namprd12.prod.outlook.com>

On Tue, Jun 10, 2025 at 06:28:22AM +0000, Jain, Harsh (AECG-SSW) wrote:
> [AMD Official Use Only - AMD Internal Distribution Only]
> 
> > -----Original Message-----
> > From: Krzysztof Kozlowski <krzk@kernel.org>
> > Sent: Tuesday, June 10, 2025 11:48 AM
> > To: Jain, Harsh (AECG-SSW) <h.jain@amd.com>; herbert@gondor.apana.org.au;
> > davem@davemloft.net; linux-crypto@vger.kernel.org; devicetree@vger.kernel.org;
> > Botcha, Mounika <Mounika.Botcha@amd.com>; Savitala, Sarat Chand
> > <sarat.chand.savitala@amd.com>; Dhanawade, Mohan
> > <mohan.dhanawade@amd.com>; Simek, Michal <michal.simek@amd.com>
> > Cc: kernel test robot <lkp@intel.com>; Dan Carpenter <dan.carpenter@linaro.org>
> > Subject: Re: [PATCH v2 5/6] crypto: xilinx: Fix missing goto in probe
> >
> > Caution: This message originated from an External Source. Use proper caution
> > when opening attachments, clicking links, or responding.
> >
> >
> > On 09/06/2025 06:51, Harsh Jain wrote:
> > > Add goto to clean up allocated cipher on reseed failure.
> > >
> > > Reported-by: kernel test robot <lkp@intel.com>
> > > Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> > > Closes: https://lore.kernel.org/r/202505311325.22fIOcCt-lkp@intel.com/
> >
> > Please stop adding bugs and fixing them afterwards. Fix your patch first.
> 
> Hi Kozlowski,
> 
> After squashing this fix, Do I need to add "Reported-by, Closes" tag in original patch?
> 

Nope.

regards,
dan carpenter

