Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D871DD87D;
	Thu, 17 Oct 2024 12:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729168206; cv=none; b=OpomHb0o4jSEanHV054AkA26aQusKWjyuhpMeqyEmnY7At+RvN/o9wrdz1H+oDuG3NFRGn1ALIkVrowIuxybzwcTUalpWZd90dywK0E7PqS5aORxiG5wGhpDIPGJg55Erpq7rtiKsbhcV24qS3LG6XwOojfsr1vvUO+j897jNbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729168206; c=relaxed/simple;
	bh=XgziAbReF3ro/I+pQGQQcCy5YVAQurh04oOvgfEMjEY=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n4ViY9hAVzM30A4phdCIgtbK8kupt6oMliOo1bq+Xf8cESQ6N9HcFH8XjUoV//BuU6oWrcUhC4IZ2ETEKPg/3gU9zDSIOaG99Mx1oXv1eYBRBgfwAHWHrUb3D9lBNKtG/1J9mykA7xtOcqF90YbrMi2h4cP+HlbP8qTr1V76XjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mobCr2PK; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mobCr2PK"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4315eeb2601so2022225e9.2;
        Thu, 17 Oct 2024 05:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729168203; x=1729773003; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=eau2jkUCayYgBs/JR1nIB5Drz991JgJug5wK7vgjtZ4=;
        b=mobCr2PK+92mbA9olp88fyjROIyUlyVSy/WIpJbP43cS9SoQNUmy6eSv7XAhxH9TKo
         N0KlBL4sSXs3jCZchZV6EejZ1Wy+knMndbVnSItQU2VnCANH6+mMzC5gj8CbRXEdjiBG
         BYHeP98S5s3bx0nuOKrMW+3miofG7w9EB2JTvaLu5eg0a2AwyQ8UfLUQU+G7CUWpca7t
         YqgZYyhSdaux7gtMoeJbfJYG6D0+bcxYLdvwdr7S6G4KpLdw1o5mKnybWXdeDug1kFyF
         9swy5+jdxKxgwpzQvDgURKxKhmhPj7SKh/VFw+JIbryFhAqjlQ2R1H6AM+KgQCuYWX4O
         +nzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729168203; x=1729773003;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eau2jkUCayYgBs/JR1nIB5Drz991JgJug5wK7vgjtZ4=;
        b=mzqcKIT/iX+6EWLKwAbnaO4yH7c464VFUNnB0OHmRcLTD7JcG3cqdiGJcSkpL+Y2+w
         azmKqRIoJ6ZvnTTz0fQshsZFXWdwV+1Yzgl9ECgtHKnjsQOPN0rXGFJEN5kk/u7ITD5G
         zxzqLOZ2rqQ+X7D/3xFJvewgVE4PWKj7l37hLEdA7hTm1u7/ERUftY3X5PDMfbyeNgSQ
         ozpmzeMz0tQx9X2wsKWFPJhoqPFu/yND1b5523cXLuzvEisG9CYsPTJ7iSNayQBjT/NN
         l79yIy6rIMgG8iogr7eZIBKW1TzRfVYlDNa4RK+RbuvJlwYmXOuefOdj+ImP8Mw/lRoF
         CKjg==
X-Forwarded-Encrypted: i=1; AJvYcCUtAiCGS8pP7AqM7B/+3JjhF2nUYGop25iQc5ChxnsYdXC3KnI+cjzCx3HGXls1Kof8N8SP/KW8s9ZSaJk0@vger.kernel.org, AJvYcCV4tTZ15UMSqN5TkHONm+OllEN+eSc9RbRPFQhunUlztNMsE0l21B7UXP/nX36ES2AJmVVw3vYXfAHIUKSB@vger.kernel.org, AJvYcCXLnVS9GtafCvIh7VrOqYo6973fT7DIBjTBqUezlVxc4T03A2GDdN9M6aDiwSDsgw7kfa+tIJGAT25G@vger.kernel.org
X-Gm-Message-State: AOJu0YwT76sqx1vChgjXsg/1wrBUehQJ5TrAopK8daN5apjRoTjqlr2x
	vV1S14Nb/ugJmpVfnvTa56CMK8pMVJmv+C/6ULTSW9hOFiweCXGO
X-Google-Smtp-Source: AGHT+IHgAtgVvKla+/LznHYLjG8I8NUeFfcD+iJ8xsZ/gYBEACZ3iYiEiUhczaMF9H/uPCRN3/YQ1Q==
X-Received: by 2002:a05:600c:5108:b0:430:9fde:3b92 with SMTP id 5b1f17b1804b1-431255e033bmr210426525e9.14.1729168202861;
        Thu, 17 Oct 2024 05:30:02 -0700 (PDT)
Received: from Ansuel-XPS. (93-34-90-105.ip49.fastwebnet.it. [93.34.90.105])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43158c39a33sm24904645e9.13.2024.10.17.05.30.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2024 05:30:02 -0700 (PDT)
Message-ID: <6711034a.050a0220.1ed172.7fa9@mx.google.com>
X-Google-Original-Message-ID: <ZxEDRgOe1FjmdhZD@Ansuel-XPS.>
Date: Thu, 17 Oct 2024 14:29:58 +0200
From: Christian Marangi <ansuelsmth@gmail.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Richard van Schagen <vschagen@icloud.com>,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/3] dt-bindings: crypto: Add Inside Secure
 SafeXcel EIP-93 crypto engine
References: <20241017004335.27471-1-ansuelsmth@gmail.com>
 <20241017004335.27471-2-ansuelsmth@gmail.com>
 <dg346xguo5cjx6yotnrdpjyp7n7wwpwnrjvybrrbocekhltpmg@s2j734wd2rnf>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dg346xguo5cjx6yotnrdpjyp7n7wwpwnrjvybrrbocekhltpmg@s2j734wd2rnf>

On Thu, Oct 17, 2024 at 10:23:54AM +0200, Krzysztof Kozlowski wrote:
> On Thu, Oct 17, 2024 at 02:43:18AM +0200, Christian Marangi wrote:
>  +
> > +description: |
> > +  The Inside Secure SafeXcel EIP-93 is a cryptographic engine IP block
> > +  integrated in varios devices with very different and generic name from
> > +  PKTE to simply vendor+EIP93. The real IP under the hood is actually
> > +  developed by Inside Secure and given to license to vendors.
> > +
> > +  The IP block is sold with different model based on what feature are
> > +  needed and are identified with the final letter. Each letter correspond
> > +  to a specific set of feature and multiple letter reflect the sum of the
> > +  feature set.
> 
> You write it is licensed to vendors, so are you sure these could be
> used alone, without vendor customizations/hookups etc? I think you
> should have a dedicated, SoC-specific compatible in the front. I am not
> sure if this was discussed already, though.

Yes in v1, Rob asked some info about the compatible that was
mediatek,mtk-eip93 or airoha,mtk-eip93.

The thing is that from what I checked from different documentation
around, the register map and how the thing works doesn't change across
vendors, what I have seen is at max specific register added that are
outside of the crypto module usage (example debug register for BUS
bandwidth)

Any suggestion on what could be a good compatible? Honestly I'm more
tempted of using this similar to how is done by the new model EIP197.

> > +
> > +  EIP-93 models:
> > +    - EIP-93i: (basic) DES/Triple DES, AES, PRNG, IPsec ESP, SRTP, SHA1
> > +    - EIP-93ie: i + SHA224/256, AES-192/256
> > +    - EIP-93is: i + SSL/DTLS/DTLS, MD5, ARC4
> > +    - EIP-93ies: i + e + s
> > +    - EIP-93iw: i + AES-XCB-MAC, AES-CCM
> > +
> > +properties:
> > +  compatible:
> > +    enum:
> > +      - inside-secure,safexcel-eip93i
> > +      - inside-secure,safexcel-eip93ie
> > +      - inside-secure,safexcel-eip93is
> > +      - inside-secure,safexcel-eip93ies
> > +      - inside-secure,safexcel-eip93iw
> > +
> > +  reg:
> > +    maxItems: 1
> > +
> > +  interrupts:
> > +    maxItems: 1
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - interrupts
> > +
> > +additionalProperties: false
> > +
> > +examples:
> > +  - |
> > +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> > +
> > +    crypto@1e004000 {
> > +      compatible = "inside-secure,safexcel-eip93ies";
> > +      reg = <0x1fb70000 0x1000>;
> 
> Looks like not matching unit address.
>

Yes sorry a typo, will fix in v3.

-- 
	Ansuel
