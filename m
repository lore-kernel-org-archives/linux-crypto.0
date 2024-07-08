Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2AD7E0E8;
	Mon,  8 Jul 2024 11:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720438175; cv=none; b=NfDyE9eETJ403+tsQzJljXxItdE4mJKdC4+ZIqz5wUn3VQHKuQ+2VIgWxeDiOZcZNfnqKDGDNURpwoAjpc7fLbrqxSJ7brpMHc8EzEjTEB51AiecKjqoC0bU79H2QmdnywxBSPxF88VsS4CjzTq2yLBKgKPPSznbIP72G22M1Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720438175; c=relaxed/simple;
	bh=l8tNADpvGTAgcZk4owxgrOrsGJwZxT/6zV7fMI1w4KE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mtDp9s6HaRNvn32D34+5YPGhNG/RkiFm4P0iqSMbFujm4t+745EyTry7/QlSabFg0PtunzRKi34RCsF6JGTSFLF2ZYkobpO8Z7rlv78RMqbR37M7cNol7OlxBTT64+Ob+NM3oNG19fZg09LdJ7hLTwZ1nCeBfSOp9bs0jOd+gc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a77e7420697so212988266b.1;
        Mon, 08 Jul 2024 04:29:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720438172; x=1721042972;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bcz3nh3P1QPB93IkBWiwLYfGJ8ranmn0k42SqHg0GD8=;
        b=KBxJV8VtoZW9livy3cmtY4zLtcFta8OBWPhqiF3qLosCcnYqTBDzj/ZH8ydfB6emdq
         6YueJJd8+DkP2pppcwVv1PkGx96kCbMKTA6OZKdVucEuzZzx5UyIaaBjwGVwt940vK2L
         8qWFl9CU8SD9aZxE2Ic99xz9KK6HPnudUl57nGS6BPKgW/XWIC4p83aE1uklVokaI6on
         z8hUuz50Y97i9UtyIxZHsWKLtZ+FdE1AKGmSQt6EiodggIDt6Z8qPqoaskcf79B2dDfb
         Ipnj6dgNU6q1BP+znejYXwLhMwMDEqFXqLLMNccN8vBbeT6UgMm0hAW7gBhpHXlkQq6n
         o0jA==
X-Forwarded-Encrypted: i=1; AJvYcCUKPQOyRM8/35gJOqgc8ZV3gg6hLmpfJC0q2NmR8BgB5z7tnwPqCR0Yid+ouSZTt25gDLd7xhjEX9x9OpCFUtgwwgImeTGRUkQuK55VWn0CD9os9jiVCN+rfFInDTpZGNyRmpz2gReo3cpT/Ziup3ifJ23gZMU6dLMM04ZOuuoKak8o
X-Gm-Message-State: AOJu0YxfWgp5DatKvuQ6Ngh79vrrEAJ3mrt3ado7K9pmUfrQyjgoXKig
	evr5O1NkQtZ71TUigd241qeqNvIefHrg4NvI41zL0kzKDXzciQY4
X-Google-Smtp-Source: AGHT+IGwnmeCQCgRGyXdVA7s26btz7dHrIerUo2cdeyLDKvuIPKNqvP0pyiSx+yPrX1vGERkl5IksA==
X-Received: by 2002:a17:906:3403:b0:a77:da14:840f with SMTP id a640c23a62f3a-a77da1485f2mr546194766b.9.1720438172279;
        Mon, 08 Jul 2024 04:29:32 -0700 (PDT)
Received: from gmail.com (fwdproxy-lla-002.fbsv.net. [2a03:2880:30ff:2::face:b00c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a77e1417c3dsm223512566b.92.2024.07.08.04.29.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jul 2024 04:29:31 -0700 (PDT)
Date: Mon, 8 Jul 2024 04:29:29 -0700
From: Breno Leitao <leitao@debian.org>
To: Horia Geanta <horia.geanta@nxp.com>
Cc: "kuba@kernel.org" <kuba@kernel.org>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"horms@kernel.org" <horms@kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net-next v3 1/4] crypto: caam: Avoid unused
 imx8m_machine_match variable
Message-ID: <ZovNme6LSqxdYpS4@gmail.com>
References: <20240702185557.3699991-1-leitao@debian.org>
 <20240702185557.3699991-2-leitao@debian.org>
 <ffcb4e2a-22f2-4ce2-a2cd-ad05763c91f4@nxp.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ffcb4e2a-22f2-4ce2-a2cd-ad05763c91f4@nxp.com>

Hello Horia,

On Fri, Jul 05, 2024 at 10:11:40AM +0000, Horia Geanta wrote:
> On 7/2/2024 9:56 PM, Breno Leitao wrote:

> > diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
> > index bd418dea586d..d4b39184dbdb 100644
> > --- a/drivers/crypto/caam/ctrl.c
> > +++ b/drivers/crypto/caam/ctrl.c
> > @@ -80,6 +80,7 @@ static void build_deinstantiation_desc(u32 *desc, int handle)
> >  	append_jump(desc, JUMP_CLASS_CLASS1 | JUMP_TYPE_HALT);
> >  }
> >  
> > +#ifdef CONFIG_OF
> >  static const struct of_device_id imx8m_machine_match[] = {
> >  	{ .compatible = "fsl,imx8mm", },
> >  	{ .compatible = "fsl,imx8mn", },
> > @@ -88,6 +89,7 @@ static const struct of_device_id imx8m_machine_match[] = {
> >  	{ .compatible = "fsl,imx8ulp", },
> >  	{ }
> >  };
> > +#endif

> Shouldn't using __maybe_unused instead of the ifdeffery be preferred
> in this case?

That is an option as well. Not sure if it makes any difference, tho.

If you prefer __maybe_unused, I am more than happy to send a follow-up
patch to convert the #ifdef to __maybe_unused. Up to you.

Thanks!
