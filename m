Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D167C770E2;
	Thu, 17 Oct 2024 12:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729169736; cv=none; b=j/MKzyEKEQOde6bMtYNfq7A61FIoGUn5yZmzFMkSWqnWNHdP7ug8N+QlEvoud6ObcmcW8/SnEoEV6+3AGx4TDGXCcRYqDfTeSxIWZrYCdHIK3eQ8gw9fPPfipb4iZD+hjyjnpqSLUiu2QB8bkz9tEv5NJaOHjHggS5zFbYb+a10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729169736; c=relaxed/simple;
	bh=ZTXid6J0lRxBXRmOOJZdFDXBQHQ3HqwPcVDkf60LL+w=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lirf1FPAvDXzhNzpbseZBgBesm0gQVzPgvhyeXpgSxK+R5ZyLW9ZNmtdUIH9U+D7DTOP3oaoCt5Dy2FOlvmV16bs8rnMkhy9qFrMGvMqZd0DmvKLT5rkPTWM4okHO2VssAYfauzJaC7hq1rriQfDEGe2tq8E14GnN5YWli6P19M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ONAC/XVq; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ONAC/XVq"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4315839a7c9so10125495e9.3;
        Thu, 17 Oct 2024 05:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729169733; x=1729774533; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=710SIBW9J/sukd5yvZdpOqpR89j7PM7tq6MYOr7SPZI=;
        b=ONAC/XVqv+8LSwenYKefQ86+XVFZB0C/vF+Sys/bhGCqPc7rhPpYApC0LdEB8JGT+B
         z3hnccFmPaQHWK6dfavnJWKbEfYqqqQpw/jflcvL8RGiRBi6wbwkwUIlhYYRFzZDA/mt
         ClSe9lhRDVbujJcuLwsD5fiY0um0VQwNiuOQK3ZkUD5IYlpUqcoYpXtKkDiT1uxnC2Zz
         t0GhJSjTyMaFvNRt2e92AGL2kk33q7L57MBohlnmxG90ShEOfATrxyMgbQCHFUCrucG1
         3j2ZvmxFGkVD/w3Pg/Sulgct3LE72LlwwPWkG4H4GjZix08OafALGjlj93q+Sc443diq
         G4+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729169733; x=1729774533;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=710SIBW9J/sukd5yvZdpOqpR89j7PM7tq6MYOr7SPZI=;
        b=mgyzokHcIecUzDcdstMHQlxL+bFmqG8f7gh21o6CeHjsJQVsjPg1FLAnXUw4cxw4Gz
         fgkYJJekS2IrRwVOUEHdp4qc8Y3z8loza+kej7b2S7v5P9Et8nlytf5+TZPucMg+sh1s
         SDr3L4c19B0mjRGFjgv7tGix/SfSStSDK+Fzwu9OEujEVpSv04IG72XOh1IgZiB12rSd
         jNbwB9EP90bP4/r9PtTNn2tnLlQnf0LAyikXy0lTr6e5P4K2RJrEtcyLDHEXlMWRDJ7c
         M+DFnPHfJXKeefubUMEOTW9ezrPCXxiMiZeVsNXNctsgvVcIHRz+1HWB1xWR6yjUCWx5
         sVbQ==
X-Forwarded-Encrypted: i=1; AJvYcCUjgp4AgE+cJWqi4VnWTvoXwreNjLhZoGY9ht+pxabnfUREZlgbyOLad75kK4fGrF1QyYII0EambL1n@vger.kernel.org, AJvYcCVsvceAp8rkYLOURtNCWm2DcAEkobiUoCdlNgaMvurbIVijYQcedssAVxPTYP8BKZgwDCSZwRYlJ3uHRaNR@vger.kernel.org, AJvYcCW5reJLwDVh26ER1VTKYEmzdxvGeF7NTK2CZ2GiMyJQQKQymXmbouPIjlIoWPp2cMOsLHBDwJZBMp15WzhL@vger.kernel.org
X-Gm-Message-State: AOJu0YzgbW08/zBNMuiuRdIcidTNjHLTgPj2mEpMoFIFWA7vIh8m0QnL
	g+jjR3v9kgA1xVyMk5mkOD+ncUWoFfKIqAHDsAIEbJ3EzOFdqJq/
X-Google-Smtp-Source: AGHT+IHn9ln8/GKixX1FVbCjsOOsgO68yrDzX/FK4hxyxOA0CgKcYmjDNHeNjyhWpJK87axTX9LERQ==
X-Received: by 2002:a05:600c:b8d:b0:431:12a8:7f1a with SMTP id 5b1f17b1804b1-4314a303409mr68075935e9.16.1729169732955;
        Thu, 17 Oct 2024 05:55:32 -0700 (PDT)
Received: from Ansuel-XPS. (93-34-90-105.ip49.fastwebnet.it. [93.34.90.105])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43158c3a256sm25325925e9.17.2024.10.17.05.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2024 05:55:32 -0700 (PDT)
Message-ID: <67110944.7b0a0220.1923e4.814f@mx.google.com>
X-Google-Original-Message-ID: <ZxEJQV8b1AU3OPXf@Ansuel-XPS.>
Date: Thu, 17 Oct 2024 14:55:29 +0200
From: Christian Marangi <ansuelsmth@gmail.com>
To: Rob Herring <robh@kernel.org>
Cc: Krzysztof Kozlowski <krzk@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
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
 <20241017124805.GB3032377-robh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241017124805.GB3032377-robh@kernel.org>

On Thu, Oct 17, 2024 at 07:48:05AM -0500, Rob Herring wrote:
> On Thu, Oct 17, 2024 at 10:23:54AM +0200, Krzysztof Kozlowski wrote:
> > On Thu, Oct 17, 2024 at 02:43:18AM +0200, Christian Marangi wrote:
> >  +
> > > +description: |
> > > +  The Inside Secure SafeXcel EIP-93 is a cryptographic engine IP block
> > > +  integrated in varios devices with very different and generic name from
> > > +  PKTE to simply vendor+EIP93. The real IP under the hood is actually
> > > +  developed by Inside Secure and given to license to vendors.
> > > +
> > > +  The IP block is sold with different model based on what feature are
> > > +  needed and are identified with the final letter. Each letter correspond
> > > +  to a specific set of feature and multiple letter reflect the sum of the
> > > +  feature set.
> > 
> > You write it is licensed to vendors, so are you sure these could be
> > used alone, without vendor customizations/hookups etc? I think you
> > should have a dedicated, SoC-specific compatible in the front. I am not
> > sure if this was discussed already, though.
> 
> Probably should, but some reason we haven't on other Inside Secure IP. 
> Perhaps they are just simple enough from a DT perspective to get away 
> without. Also, there may not be any SoC associated with some of these. 
> If there is an SoC, then better to add a compatible to help avoid any 
> future DT changes.
>

Would it be ok to have inside-secure,safexcel-eip93i-mediatek IF some
device will require special handling?

Again I expect no vendor to modify how the IP works internally with the
descriptor and the common register.

Vendor tag is probably not needed as Vendor are not that crazy to modify
a crypto engine IP and cause disaster on the way.

-- 
	Ansuel
