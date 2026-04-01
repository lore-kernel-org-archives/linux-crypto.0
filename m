Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB782DA765
	for <linux-crypto@vger.kernel.org>; Wed,  1 Apr 2026 14:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775052275; cv=none; b=EL7URky5tnWbJmDQhf7W1+XJHXvUT0cuhmVZe6C60609R60TlB3owlXKa8bTcQeXwq5VyASA7Me607P/uHFTLJrqT3kVj8X/HYAg1r2r4pKpxCZ4OkieZHBlJE0pov8yO/8DoRb1kStdlie7Lx3pIvx+f6yPkSSsew6QJxP4R38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775052275; c=relaxed/simple;
	bh=ENBbqPvMtgDBrtNY5Maiukm89IlJO8HyVFmraI/eHfM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G9sJ5IV9PoM4kdjX1fYNcOkVGvuaaCQ28k52HHxDRBfQm2rivX+5oX0+BPRqsGUa/M3zSto8hdq/ex+MS9dsc+pIC3QoS1yu1oMaVXCQmInZyyDsjpjZfL7s7Z8FrntPokJgXWbzrCjAfnlYIH/7y2yv0iYgF1ptkCnuqXMI0FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MQctaaUu; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=OsP54f9/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MQctaaUu";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="OsP54f9/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775052273;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tcMceLtrrOoF9OBObZDKWhIp/2bPn54+SJ2oUftQ6n8=;
	b=MQctaaUu6qEnE0fykNKj7lmbdilz+j+/wmnC+FpwPkzZFxuciX4IUR0MTdaCmL+6WxXauH
	T+txM0iRZjFqixbPWYNNVNQVNdub3ommwu1FdTTMdcXPCOm6jcgDYJKNZfWbb+eyf0Gs7n
	VBK+uGYC9RzmFgf5WS5qyF5ObDcx6WQ=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-209-kpDRYzZwOV6RPKW_mg7STQ-1; Wed, 01 Apr 2026 10:04:30 -0400
X-MC-Unique: kpDRYzZwOV6RPKW_mg7STQ-1
X-Mimecast-MFC-AGG-ID: kpDRYzZwOV6RPKW_mg7STQ_1775052270
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-67df0afe23dso24149485eaf.3
        for <linux-crypto@vger.kernel.org>; Wed, 01 Apr 2026 07:04:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1775052270; x=1775657070; darn=vger.kernel.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tcMceLtrrOoF9OBObZDKWhIp/2bPn54+SJ2oUftQ6n8=;
        b=OsP54f9/cRkV5KVwx73LS4B/Kq7ktCySUtk9oZFpaM6W0upTXpY19rwVHfRsavgDEp
         GE4vL7VsNbVNjWJgDf70xKDWQTw/zWkPiX97MtiG+m+YJoGAwmzTqpfjtAA7H+hf/Nw7
         0m2Doue+m/Ih9mYhVFugzbeluApxsdcFLLim/E7FBhjdqiUMmUz4hESiZZNywAJ59fYq
         mnGcwXv3WtDYFdN5L+5rWUn7yC/v6j3XdWWM6xY3RsjxFwl7bDI8p8E2ogWE5jOokpNX
         4dNO+7YcSMFQYjQMlYGklsOXKkXPiwGx+Wphq12pjvI0aPqM/xWnfBJ6BgUVHfEnnlJL
         T7jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775052270; x=1775657070;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tcMceLtrrOoF9OBObZDKWhIp/2bPn54+SJ2oUftQ6n8=;
        b=tYnTdNUMvndj4yOdIofFTW3ntBvi6Q7zZMS81BmAeJHBopAJYZABzPdWt2dOOnM1TT
         OyJyG4hfZIpXRgD0lE8ZJTXLZMYf6mDotUuUoIJybseI8KajGn/hjH7w4C0qH3Nrzp9e
         w87Mow61EdBEwmrCNWDO/PyhntmJzUwv9F2zbZkZeq6p17kdZwo3lDThVA7xBbME2kaL
         GfLb73t3HjtYbNtt8t8bBgTeISwP1SKuzBVkXKlbZN03/Q1KZ69ozill6Qnadj2BfiGd
         SSeA8IQbheUGrnXRNgSJnZnz05ydAJoz+3arVFJmilR/jjODId8j7KesT4qEG5LeKqaM
         YZHQ==
X-Forwarded-Encrypted: i=1; AJvYcCUofE5hHpup2qWvhhl8M9ZvP/7mJiusuqKgNZX9AGxKLZVzhIqZcyrs9Z7rOxlZz+NBXqq162Zj3j1BEnU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsBQ2B7lPVIIugTGlt/kBxagP/xBh0PrvbmQLYgwUR76WWCXra
	JdldcKH0g3gcYSl7JvtPAOR7fIgN+EdOK35DrPUev1Ujco1H+DTILfN+5bUjHMuvjYzNOiGXUKT
	+xayWn5m+AazoUe3ZUN56HzBvE7iPVRew+mgB8xkEbcDhgt4WWdoEhtdxDE953rsLSw==
X-Gm-Gg: ATEYQzzIO2GBhY+zMTgmlgDkCN35RcOtbxb0dHM1Ev50UMLS7Bn2xifh6eAN1bJUqCn
	lfRxNIeHST9XZb3ghlWRoe0GCw0zGTyv3Jbu9PRxC+r8ZJ9pZx1JWaK6TP2X1gkE/NoBSTmS33o
	vgSFLBVm3x/Gu3Xpj2NluYLyKfbwj3v+pvLqTnAzLYvT8UisTENStwH2GcUhUN6vxw6i9uyiDNM
	VYVkI3qaqAGz+VxBgdX+EcKN2uWSAGkuC/QNOPzxiNEXPDn+Y7GsnU7oxtMRAEPDtWc/xVvJn5W
	2Ra7GXFCfb1Q7TLxALEYCYdFhUDoQZ4ZfyGGJEtADS/lFYA6ECVkI2u+ZCZPSBMJkLuiCSTtzH1
	y9cZmaeXK3dT51ywV9ktx+2lKcECSVmiwRn+JrO+4dA==
X-Received: by 2002:a05:6820:4b81:b0:67d:e102:da05 with SMTP id 006d021491bc7-67fabd323a0mr1831342eaf.63.1775052269885;
        Wed, 01 Apr 2026 07:04:29 -0700 (PDT)
X-Received: by 2002:a05:6820:4b81:b0:67d:e102:da05 with SMTP id 006d021491bc7-67fabd323a0mr1831271eaf.63.1775052269221;
        Wed, 01 Apr 2026 07:04:29 -0700 (PDT)
Received: from redhat.com (c-73-183-52-120.hsd1.pa.comcast.net. [73.183.52.120])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89ecf960d2esm117933246d6.34.2026.04.01.07.04.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 07:04:25 -0700 (PDT)
Date: Wed, 1 Apr 2026 10:04:23 -0400
From: Brian Masney <bmasney@redhat.com>
To: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jayesh Choudhary <j-choudhary@ti.com>,
	"David S. Miller" <davem@davemloft.net>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Magnus Damm <magnus.damm@gmail.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	Pascal EBERHARD <pascal.eberhard@se.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	linux-clk@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org,
	Herve Codina <herve.codina@bootlin.com>
Subject: Re: [PATCH 10/16] clk: Add support for clock nexus dt bindings
Message-ID: <ac0l51ikCd_r22da@redhat.com>
References: <20260327-schneider-v7-0-rc1-crypto-v1-0-5e6ff7853994@bootlin.com>
 <20260327-schneider-v7-0-rc1-crypto-v1-10-5e6ff7853994@bootlin.com>
 <acqT3Dh03y3JiLLc@redhat.com>
 <87y0j76p8o.fsf@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y0j76p8o.fsf@bootlin.com>
User-Agent: Mutt/2.3.0 (2026-01-25)

Hi Miquel,

On Wed, Apr 01, 2026 at 10:47:51AM +0200, Miquel Raynal wrote:
> First, thanks for the whole review.
> 
> On 30/03/2026 at 11:16:44 -04, Brian Masney <bmasney@redhat.com> wrote:
> >> -		ret = of_parse_phandle_with_args(np, "clocks", "#clock-cells",
> >> -						 index, out_args);
> >> +		ret = of_parse_phandle_with_args_map(np, "clocks", "clock",
> >> +						     index, out_args);
> >
> > Before I left my Reviewed-by, I should have double checked Sashiko. It
> > has several questions about this patch. The first is:
> >
> >     Are there other places in the clock framework that need to transition to the
> >     new map API to ensure assigned clocks work?
> >     
> >     For instance, assigned-clocks and assigned-clock-parents are parsed in
> >     drivers/clk/clk-conf.c using of_parse_phandle_with_args(). If a device
> >     specifies an assigned clock that routes through a nexus node, will it fail
> >     to configure because the map is not traversed?
> 
> The goal of the nexus node is to isolate what is behind. Are
> assigned-clocks et al. supposed to traverse a nexus node? I am tempted
> to say "no", but I'm open to discussing this ofc.

I agree that it's not needed as well, however I want to defer to
Stephen's expertise here. I mainly brought this up trying to help him
with reviews.

> > https://sashiko.dev/#/patchset/20260327-schneider-v7-0-rc1-crypto-v1-0-5e6ff7853994%40bootlin.com?patch=12563
> 
> I have mixed feelings concerning Sashiko's feedback. I will go through
> that page nevertheless, there are interesting comments in there.

I have mixed feelings as well about the feedback from Sashiko. It finds
issues, however not all of the feedback has been helpful. On the whole,
I'm glad that it's available.

Brian

