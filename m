Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDEA1C3F1F;
	Mon, 21 Oct 2024 16:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729529926; cv=none; b=tol9wwk5V4IpZR0GksME+mAltRaMSrXbNP5F0vuDDk+fKJjGokOZRW0+MwLLJJx3a8pylOJaDy4SeIiZWiJNREaxvf3VMVxM62XdSfMR1T0MBBtsD4sACNaiAyTLLoS/r2T2aTi5nqwQr1t8duoqp5+52SuxWGzTN2vEM0gfepM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729529926; c=relaxed/simple;
	bh=rWNFdfqAINsqgIPmQ58XV9XMhtcFfEUW3JM86HlYGr8=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mAZXP3tHGqznqI2/7k8d96L1kw0/EbTrNSGp0M8g8Di1XVVD/GauHWbaxGk9eJu2tIK3Wk+OeghqWk26Ku+Twn3W+IyJKR6wfT1omCIWPMgb7YWCmf3i3Tq0tTozOfX0HDbG5W5Rp4sxD/sIIc0x1ZJ5mnfqsI7pLj9HYNQ7FVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f9exvweh; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f9exvweh"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-43168d9c6c9so26346685e9.3;
        Mon, 21 Oct 2024 09:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729529920; x=1730134720; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=3O3ZqCsjCEbziUzYAzv6B3rVVFyqYjTTrhAS14y6FHs=;
        b=f9exvwehD6FO6GjLBuc0U7gX58o+KFbVWq3aa4AuKl41eQi9K5nD4Ns0w9QOQ3+Uen
         crHWUEa+zZ87hUz0yx0R/6ev2SE2zWsfRnZTNAClIDk0u4lmNB5tdRU1DcQtuNisELBI
         QlfkbgC+uHTFftt3nX+oFEKqXlxZIxHVGHY9TFbGDj892y7wE3iHLazjp9rZJuMAwX76
         pgUwCwEWD26ECZE4TP7bgCpeuLjUaSH+cGhl6fgHB97wNPxcgLSzYSLp19y3xkqS2B1d
         xdHo5XEDd7cLKqRU26DJALLK+b9K94F5yHBl7OcQj6ClZgTFAPt6r95lDseIzLb49DHq
         fGVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729529920; x=1730134720;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3O3ZqCsjCEbziUzYAzv6B3rVVFyqYjTTrhAS14y6FHs=;
        b=KMWVUL58+0dbVrT1EYmONuninm6l043UduB1YwZgoggNy2k18fSIVez9635t24Aqci
         x2d8kSIs3EPXwQ96yKZBpXwdpNbKyEOtX4hf/cURjSQjuGFnpxWw7YkGsmIXEveBqUUR
         rbjwIo+ZX6lxzStcN8PoJNy8KE+V3pvJnm5qG2xnG+s/qx6zYOJx4Qe48vooUDQFxGAe
         akpddrOx4MW3bcEwmfjA0qZY6E88onpFpgNVqPjtcG/ykIZvg3Nv4mvS3sb+Qcfx5Kdu
         NxNpXdMoPb+7o8bMr7/1X2cEps1BsvUkK5EE2Y1+FJcFwDZM52zWSg0U8e00uZZaSqgu
         wdmw==
X-Forwarded-Encrypted: i=1; AJvYcCUTc9O/oV9GvO/aFYTa+v6m0zUimXUBeoa7WGvKSdJLax67Fy2mfTSXoDHFjzY42dYGdHBQ+zbxlt7Qe8ne@vger.kernel.org, AJvYcCX1WHZIxlMQk5k+eKMAJ+Z3C2G2K24Yu82HgGkUJu7arav3XyYP5EaG/vrXglqSyx/Y7TdrBjYQpZDu0ksf@vger.kernel.org, AJvYcCX6clPQOJ4wJJVsxksRogvU2+F0DoORgepBqrk3nyy7yAucYGqiNXQIFga3GIS4LaB+OXobzMcaScYZ@vger.kernel.org
X-Gm-Message-State: AOJu0YwV01CBsmirN3Jyo/MYi2WzbWPFhx7CcFq4ouLYUPKsH1XslDhm
	/GFOIsLcvlRFDMvcxBQ4rMiP3BP1UeJyKILO4rNWOGtH+c7JLIHN
X-Google-Smtp-Source: AGHT+IH1rjzoflHlQy1RKRZo1OcQNF67Ti3665AgAQE6ZaNOhsVxI9Vt11YMbl4rTj+b9b6YG51a2Q==
X-Received: by 2002:a05:600c:3b9c:b0:42c:bc22:e074 with SMTP id 5b1f17b1804b1-43161691787mr101963005e9.29.1729529919498;
        Mon, 21 Oct 2024 09:58:39 -0700 (PDT)
Received: from Ansuel-XPS. (93-34-91-161.ip49.fastwebnet.it. [93.34.91.161])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4316f5c2fa7sm64477955e9.34.2024.10.21.09.58.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2024 09:58:38 -0700 (PDT)
Message-ID: <6716883e.050a0220.3afab9.2304@mx.google.com>
X-Google-Original-Message-ID: <ZxaIO9f6AC_DIsyY@Ansuel-XPS.>
Date: Mon, 21 Oct 2024 18:58:35 +0200
From: Christian Marangi <ansuelsmth@gmail.com>
To: Conor Dooley <conor@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Richard van Schagen <vschagen@icloud.com>,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [RFC PATCH v3 2/3] dt-bindings: crypto: Add Inside Secure
 SafeXcel EIP-93 crypto engine
References: <20241021145642.16368-1-ansuelsmth@gmail.com>
 <20241021145642.16368-2-ansuelsmth@gmail.com>
 <20241021-extenuate-glue-fa98a4c7f695@spud>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241021-extenuate-glue-fa98a4c7f695@spud>

On Mon, Oct 21, 2024 at 05:50:25PM +0100, Conor Dooley wrote:
> On Mon, Oct 21, 2024 at 04:56:38PM +0200, Christian Marangi wrote:
> > Add bindings for the Inside Secure SafeXcel EIP-93 crypto engine.
> > 
> > The IP is present on Airoha SoC and on various Mediatek devices and
> > other SoC under different names like mtk-eip93 or PKTE.
> > 
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > ---
> > Changes v3:
> > - Add SoC compatible with generic one
> > Changes v2:
> > - Change to better compatible
> > - Add description for EIP93 models
> 
> RFC v3, but I don't see any comments explaining what you're seeking
> comments on.

I feel comments for the DT part are finished, if Rob is ok with the
following compatibles.

The RFC is more for the driver part and this is patch part of the series.

-- 
	Ansuel
