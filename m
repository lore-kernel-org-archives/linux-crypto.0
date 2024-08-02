Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A565321C16A
	for <linux-crypto@vger.kernel.org>; Fri,  2 Aug 2024 15:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722611437; cv=none; b=YNLHdq/4WkQ7fgYt+AXNemZ/K1bnHAUnMrBBy744ll4a6jwckopmx8Ts+bz6MfsiJDtsPUIJfnAI7oI6DbqJmbIwrEwaekkM/5I3Rc61o9tZ/x0/lGZNkUyrH9GO6K9g03j/KqcswWepDqq2qvDKmXf9NE+lgDXBa+U24jNqYRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722611437; c=relaxed/simple;
	bh=5mwEG/cYz7Ub8JMw/9ResdNemt1CBwQyArsQW7I30eM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NrUXn0tzDPZNYcfCgTfJCjh4LMmGOUm3WRFGGl0yypcDloLTlvKb2vbdMRgCzfNJFlWNvqvErwgPkipI1wMbPht0YNNXKRYG6+Fr0EcRpX0SoQOyxA0rn9GwiQT8VZP8EcFYhGFEQfEZL8jr2xrwUdNobHZRCFBBpa21JlzBqho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bn3v0NSW; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bn3v0NSW"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-70968db52d0so2508210a34.3
        for <linux-crypto@vger.kernel.org>; Fri, 02 Aug 2024 08:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1722611435; x=1723216235; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=w18rli39zrBz+z69vr4j7Cv9UgiGlYDlbgAiJhn3mtc=;
        b=bn3v0NSWyKdqZjl4lkFIi4pjG+wU8cs1c3BGfeYyPuSTtsRqQ38oumopcd8do3S+Ip
         6EBz8JQAtcJrIfFV/1ymrQp91Vn3BPlQXMZhI78t/d1yXPEIubmuYq7WRq5QBNx6gDM7
         cQGQgQLXzNWXQ3I5quuFC/ybPZBhnbZwH/pJ+d/FuwleP9e4wqzgB28JxNTfN5+yyPCz
         ZBKc4BdH38zqhrPUrJan1IwBqzHx3vf3ncO2Mpni2Mp18zrATNm1UBiPNMSGWu5+oYyw
         kzuhv9CSCY6Gh2xAiDO3835/JwIzCu0pjB3Cg3B+XTHc5hdCByqBfdFp1jJWqkWRn7dd
         /Lug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722611435; x=1723216235;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w18rli39zrBz+z69vr4j7Cv9UgiGlYDlbgAiJhn3mtc=;
        b=YlsfuWNt9lNsUx0kXLdIxftUGEgPBMzyA96pFQkOb/Q0qNlWcU/V+gK5Rr2C9VEYOP
         8cPQof6/oIAWl+w9oW16VNg3Ly4iQrD3EfodWl4wmbAoiOasvFpuK6c46vr7iknPqprf
         meQOMc/Vc8JVLqErt1riGPWZhI5mRDmDJoydSz2J+aoBxXnoaY2xG///lXTR983pqPpK
         Tm5xfWiGpLFA5dKaKXi8hk9MzRsZVQDXutICNoOaJj21mwWCySF4YAPgug2xw7eYOECw
         +yMndM/4qBJ2M7TEnZ9jA8+8sPEPxxrXUPjxz1RtmaX/AWSWAMF362Kths9xVoR4IBE7
         FzYQ==
X-Forwarded-Encrypted: i=1; AJvYcCVV5Rl7iqyo70LHKmEm0nl/acE6RXZuUYQXIeG2xmRRmi2ulmLcc3x8ALSEgAL+ieMe5M/GIxbrNMGjYTdK4ykA+bbt5DcpGyJE3Wb8
X-Gm-Message-State: AOJu0Ywt9bNGQvGveqHFhHUXtUpmeenaS94RFArRG0EkDTxAeV9pj61n
	osI69XRBeiUd9agRXLL0vya3JjFpdGkuitC4Mj95+CGvf4rCs5/P/VvKCkVompI=
X-Google-Smtp-Source: AGHT+IEXh16YlP37pNnz5n5eqHLMvKkfu8xPB7W6l/8KbQXft81x0EHBKA3Iyswcj6jlByZidCHXSA==
X-Received: by 2002:a05:6830:2656:b0:703:6845:ed89 with SMTP id 46e09a7af769-709ad85200bmr5072675a34.5.1722611434763;
        Fri, 02 Aug 2024 08:10:34 -0700 (PDT)
Received: from localhost ([2603:8080:b800:f700::17c0])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-70a31ec1f73sm536258a34.42.2024.08.02.08.10.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Aug 2024 08:10:34 -0700 (PDT)
Date: Fri, 2 Aug 2024 10:10:31 -0500
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
	Danny Tsen <dtsen@linux.ibm.com>, linux-crypto@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org, Arnd Bergmann <arnd@kernel.org>,
	Greg KH <gregkh@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] crypto: ppc/curve25519 - add missing
 MODULE_DESCRIPTION() macro
Message-ID: <ee8c4cc2-c266-4a46-a8be-7c189f14bd10@suswa.mountain>
References: <20240718-md-powerpc-arch-powerpc-crypto-v1-1-b23a1989248e@quicinc.com>
 <ZqzcApbJomFTnc30@gondor.apana.org.au>
 <75a526e3-3101-4319-b42f-4482ba188abc@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75a526e3-3101-4319-b42f-4482ba188abc@quicinc.com>

On Fri, Aug 02, 2024 at 07:27:09AM -0700, Jeff Johnson wrote:
> On 8/2/2024 6:15 AM, Herbert Xu wrote:
> > On Thu, Jul 18, 2024 at 06:14:18PM -0700, Jeff Johnson wrote:
> >> Since commit 1fffe7a34c89 ("script: modpost: emit a warning when the
> >> description is missing"), a module without a MODULE_DESCRIPTION() will
> >> result in a warning with make W=1. The following warning is being
> >> observed when building ppc64le with CRYPTO_CURVE25519_PPC64=m:
> >>
> >> WARNING: modpost: missing MODULE_DESCRIPTION() in arch/powerpc/crypto/curve25519-ppc64le.o
> >>
> >> Add the missing invocation of the MODULE_DESCRIPTION() macro.
> >>
> >> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> >> ---
> >>  arch/powerpc/crypto/curve25519-ppc64le-core.c | 1 +
> >>  1 file changed, 1 insertion(+)
> > 
> > Patch applied.  Thanks.
> 
> Great, that was the last of my MODULE_DESCRIPTION patches!!!
> 

Horray!  Congratulations.  :)

regards,
dan carpenter

