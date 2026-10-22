Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792659704;
	b=0OOWwQdm4+9lTKxW50TFm5FfTg9+n78x+K3ikR3zwmNjOaUMpmV36APXWFJ61w/8XN+3
	 P4AkrecQqlTUSuSMqNkutvRDajsaGxiZ6N5rv/NGdLQ3OrFW8I4DnyRwush2GUpTf1+Vs
	 WNytMYwDUd3EkPPMbN6mTqH/Fd2O8IqNQZUVKcjhXBaKEooy28HR6gCsXkYCrEdTEMkP8
	 BEgFD7QWyE+ce5ZxO/aW7f+7Drfn/1D3ozQ2674sdaG8dhtXy4CN5BmVrjb4QAOPykOes
	 wLt/2b6YmJuG9wsDTuVXdIoZjHFCgfDTUCqAOr3Kvo03J8Fs79DGD6ewBMXcV7/69DA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792659704;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=bGj6EN/omX0uE5qyyJLIAN+qlCLiq46+bLn+6BlAVTE=;
	b=4MTkzzX5p6qBSksEfg9mzI7s9PoyfrkMH/6jAH91cHgO3nb9zC36hbn6aDXCQLbR8QnO
	 5eX8U3RGW/pK7xucVa4tVipHPYMeKVw4BJa9+CWhZ4dzfk+aGCGBbwOnnZ8W1I4gqHKwl
	 rhyJd0doOAYSm7sMR+UzH/BSZ/jEwzZ/n8MsxX8iWutrvuDrMoLvHfLQBBjmtX/QEhqmo
	 cGjw1MzD0UwYccIX+JrUgVydS1tPTq2KzgYTnoelr+xisfAFDoWDNl7txu599htMbMHZr
	 thbJyupdNxAv0kYp68RCTWEvVdj1O4Afc/IsvJUxFE0mPnXxAeuLtek6tSZjVk9DZ9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Bq4nQQve;
	arc=none smtp.remote-ip=209.85.221.41
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55584606A31B
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 09:01:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 55584606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Bq4nQQve
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48c4d870d54so1154219f8f.2
        for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 02:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792659703; x=1793264503; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bGj6EN/omX0uE5qyyJLIAN+qlCLiq46+bLn+6BlAVTE=;
        b=Bq4nQQve9WpfkmCavE54oRtIDUMfl70YbCx4Tp0aRw1ivQw+1HHHSM4oCO2asnOJKg
         K3aKwrDen8sGxk1IRsoG0We6kOQ5Nuxca20pRXutpZl6/wInZS2ARWW/3XQNVFjbKxmE
         5ljDDZQadXLS8kptWZJohh0gOEANdV2zWeYdLxuHLn6FnerKO4Mai+39MiivnSVOUlB5
         3PergsB2Tna5qn7Bfpp83ImepspiuyYOdRXXq9nAKKU6JvEaQ47ELsNqUYrmunWfA5+t
         9WxooZ469J6MGLSJjVXIFe/79RGYV685VF5mNxa50jO/39R5HycsWGe5XPJgbu7OuNF7
         eQ4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792659703; x=1793264503;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bGj6EN/omX0uE5qyyJLIAN+qlCLiq46+bLn+6BlAVTE=;
        b=Rf3MwGjGqt1T9Wnc7rNXRUzBfqNy/Meo+O/1yrYkFoEOHiH+T2jSWjFoFMLTxi0m51
         qyhYY0BR2gUuhHR1qahENZcwkqKks5XMKyTmzbWAfuIABzMOKjVbJGR6U0nBAM5GAV41
         uK116v95xwAVFKqCjTp/hPnnTBG2zq2YiCGVNCN7xSS316xTYATAMwcoUowZ+62GxMeG
         e4iVExMjGljlUkz4a2ZH/r34EZG3q4H34BOuv0Jqiq3XMuwGXqTlB6CWo6aVjy/shsY4
         8WI3fYn9IZHUMhrfLOjplNug81TtQRT5ScIeIS6+37LeH4odGAsirOSP31nglk6SzDqu
         avTQ==
X-Forwarded-Encrypted: i=1; AKwUvBw1pnj5qPC9nCzJYUz3DiMxo9ZyNw1B+HikDYgoaABhJwSwX8S9MmFLL0PqniGi1N21ZcG+fuZ7+mcJ0nk=@vger.kernel.org
X-Gm-Message-State: AFq9FYLSfADf9QHBZEvsgwayCRTvHt8WL3Klf2pyEF3RVCwbuHzCPS31
	sVHFuaDTdPkjywycjaqKx0O05MMYc1EjjAVHt/N6XxMtls/pc43y/kxS
X-Gm-Gg: AYBFou3uIeUyeAtJopICP76QOd/Pu0o3JQYFNu8qhcJz8Fl2XXVPoqJ/jVOwFvPPnya
	qIyNcBYswujmUxyTcpgET11zrjs5pfGhq/xL8/6EqmV/1x6oTA5rZxXiP7/T1r4IVPBerh/eoR7
	tQQKe2Oa4VpN2qyXW1ETEfcNXzHUXZcBWXmu6da5aET3BSU6buDJljVHAFc54PfnVNHSQligrz1
	U1qrvN0Sd7zu3b4vsF1wolRxq8XHGIg1U8ag58uOJlURKYf8l6uz+K6Ca10fK5f3JeMoqLzW7Su
	ijzem2xQ3z7b3AO0tzTKrvAA5WWLxYz4utNGYvkFp8nKrTSVSIp/RXIA9I2nQwEmFsdvxIco4n/
	84D6Erf/V6U6j2xkVepWje1qbWezmvcuDJr52L4whMan2jIjYn4OMFak7LqhdbMaRS/0zhyBT2f
	Xqg1+BOzZMVZDUxN4b9OadL6/gpoqPrWOCkuUA+5l5l/GVl/HwgFKoIktu+my06OpNzRkblW45o
	eI4VGdbBBkw4qHg7lTizdBTa4rTZftXzTua+OAJdlV/7PCq0rziUsDcpgZe3lCj7UuxUERYSvWm
	g+ggZ0rEoQjUFhSI
X-Received: by 2002:a05:6000:2c06:b0:48c:4f94:222f with SMTP id ffacd0b85a97d-48e26493580mr9869801f8f.17.1792659702564;
        Thu, 22 Oct 2026 02:01:42 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e2581eed3sm12230195f8f.12.2026.10.22.02.01.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 02:01:41 -0700 (PDT)
Date: Thu, 22 Oct 2026 10:01:40 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Alexander Lobakin <aleksander.lobakin@intel.com>
Cc: Tzu-Ching Yang <shingekinocore@gmail.com>, Eric Biggers
 <ebiggers@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Ard
 Biesheuvel <ardb@kernel.org>, "Jose E. Marchesi"
 <jose.marchesi@oracle.com>, Jakub Kicinski <kuba@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, Simon Horman <horms@kernel.org>, Maciej
 Fijalkowski <maciej.fijalkowski@intel.com>, <linux-crypto@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] unroll: Make unrolled, unrolled_full and unrolled_none
 function-like
Message-ID: <20261022100140.101ddf52@pumpkin>
In-Reply-To: <0a38e0b0-2508-41c1-bd99-d15c27579307@intel.com>
References: <20261016025613.2690485-1-shingekinocore@gmail.com>
	<0a38e0b0-2508-41c1-bd99-d15c27579307@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 21 Oct 2026 17:02:30 +0200
Alexander Lobakin <aleksander.lobakin@intel.com> wrote:

> From: Tzu-Ching Yang <shingekinocore@gmail.com>
> Date: Fri, 16 Oct 2026 10:56:13 +0800
> 
> > unrolled, unrolled_full and unrolled_none are object-like macros with  
> 
> Because those are attributes. With function-like names such patterns:
> 
> unrolled()
> for (int i = 0; i < n; i++)
> 
> are counter-intuitive and confusing.

Is it possible to make the syntax:
	unrolled_for(....)

Or is that made 'all hard and difficult' because he setting is sticky?

David

> 
> We have either plain-named attributes like `notrace` (BTW what if you
> name your variable as `notrace`?) or underscored like `__always_inline`.
> If you really need to name your variables `unrolled`, then I'd expect
> changing these macros to `__unrolled` etc, not to `unrolled()`.
> Although I'm not sure we really need it, there's tons of such macros in
> the kernel -- try naming your variable `current`.
> 
> > lower-case names, so in a file that includes <linux/unroll.h> every
> > later identifier with one of these names is replaced with a _Pragma()
> > operator. A local variable or struct member with one of these names  
> Thanks,
> Olek
> 

