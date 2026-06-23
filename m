Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7C73655EA
	for <linux-crypto@vger.kernel.org>; Tue, 23 Jun 2026 18:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782240990; cv=none; b=ceqmdiKMo9fSlXuMvQ1Pn7wUyP9KkRDYX5qy40nfv9Gju6h/6CpwlMcv9h1GjYlEcoP0rfK6OTiqqmXHn12CXob8/kknbDATq7EMrYyu+9Pu8di3qqAZVkvjiGP+Nb5wJlyUyewNjsCYA/1cxGLoyPqSMf0YBgbMnXhV0mbLiRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782240990; c=relaxed/simple;
	bh=24Dn8UqRZ1p8BQICezHYOo9NJl5h5GUSnVLscYJARrU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PqkN1iMxkck/PLPAr16MgnmPFH6NI5iu0Lr10jWJHwA026CFvZ2JYBdRiSuolbiw5sVLb0r0wfnDhqRKsN3qIHdJrVhnSUzCz8liwJMV7Hn6tgdzOXCuU0dbhgoFJeRIigDtIE3Mc6mV4Ir8zhHv1CszBdqbNN3iZPPNrCkXk4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P1rC2xKg; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P1rC2xKg"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c074142cf6dso194727666b.0
        for <linux-crypto@vger.kernel.org>; Tue, 23 Jun 2026 11:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1782240988; x=1782845788; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sTYMiI8T7qy3LqZCJa3jMkJNbrBL8JjUNCpZXVETjNU=;
        b=P1rC2xKgIfv1C7HAeG67IQX0uA11r56+jg95zHeion9XESiVGv9pzhlHQE8vXMGeJQ
         mEubM7UVwMu3Etn9+tV+WLABv9ZMlbo5KxxsJPEmVjg+zMmV/rtCa4UgUC0Iav8WO7vk
         ssw17MJZXFxwE/rBj46DKsZdD32Ahj1P0jVN0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782240988; x=1782845788;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sTYMiI8T7qy3LqZCJa3jMkJNbrBL8JjUNCpZXVETjNU=;
        b=WumBlyXMmJ1F+Ta14MXpFO8DIloyAM1txFnnppwEHY6FJ81tfDU/56C3C+T4YzuTgC
         l6G8W55w8BVhtfrNCSpXDmmRDfE32vsvWAjjI6D2WUh/XDbKTvWTBijTsa0dCTsdZkfZ
         BAPtsKkTecRr8+Ha6AOtheW5OZoocCShfZ1bRpj/BQIktwYDV3ydzWYTHdD0fOuuw5S2
         sokTbxKTIb4G5RaYOiy/peIPWaKlX959asXt9HrQQaclQ+GmeCyLdECFFTFkRB1m99SQ
         I1dETT6uv6lnIiYBGerPbFsGHyEnljiupocqG5vND73cfWcblcLa8IqXlow16GX597Jg
         DBLg==
X-Forwarded-Encrypted: i=1; AFNElJ/WyrYjMCxpIaY2aQtI3GYTs0RTg+tB0bVtolz6AJAXtR+D4axGJbYPVItO0TNM1DkeDjdIe+sPfXWp0qQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQRtf7O3ixUPeq553AH70YLMIfJXYoUN96Z7QnrWLPHAJN1c55
	5j7Pnibk4FGXduQTiOmChgUO/k+BceLrta29j5Tt3rTSAQqwLXNSWQ42LT/6wh+cUzXZHZtY0Zx
	XIgIbet8=
X-Gm-Gg: AfdE7clfQh16G1g98+ES+cDMrc7uOiMJqTHh8E5DHLrrV5j3MKHW0paefNRmeg8isuS
	WAD/glkh2/vzsNld2NnKqSMgqwgjh9le71WEx7hnUIewnuDVxOv0myar3eNTDm6rKze7lXtc8iC
	SAGLQ90vuKq2rjlKT/9Mr0wz+vaY5p8ayq582cXPYD/t2dkILhKwWVyUd8SRKFusNcydVEjmm3c
	tsz026xGX6JECzi8j8lZk2PVrXGuYA9/zJe50v9XSHJEimIwFtd5lbOMfu10MgFBGoHQcEjezjN
	UFCWnu57ySeUK4F61Z/ZO+bSQLmzPfTMeYd/iVpeBneo/aOnfc08Jwq+l6dUUd/JP89ykXTlq3x
	RtN6TeW36TrqyGGry7geZImprVHVmLdyXFH9Q1Iel4rQADcSw38WeE+stOB6Mv7kKm37wMjcXA/
	isjduUG25HSrG36A3LJ2xYu5tswUmBLKoQDvSyXdJfp9I7zIHAIAaYLdNYqevN/g==
X-Received: by 2002:a17:907:ec85:b0:c10:237f:35cd with SMTP id a640c23a62f3a-c102f4babb0mr256073866b.8.1782240987654;
        Tue, 23 Jun 2026 11:56:27 -0700 (PDT)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com. [209.85.208.50])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-697e4fd89e0sm892603a12.18.2026.06.23.11.56.26
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2026 11:56:27 -0700 (PDT)
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-697e96dd8d2so825374a12.1
        for <linux-crypto@vger.kernel.org>; Tue, 23 Jun 2026 11:56:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/OmOU5fS4BTCggAWHNKxc1S0oS/nb1OXJv39C7VnYKrrFeQ2sOi7koTNVHJd+IO3MO+2dA6bc1b8wXbas=@vger.kernel.org
X-Received: by 2002:a17:907:c207:b0:c11:8357:40f with SMTP id
 a640c23a62f3a-c11835704bfmr15229166b.2.1782240986490; Tue, 23 Jun 2026
 11:56:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260430011544.31823-1-ebiggers@kernel.org> <7d08a6df54279e9915f5df6bd4e5e5dde52b4fe1.camel@hadess.net>
 <20260623164932.GA1793@sol>
In-Reply-To: <20260623164932.GA1793@sol>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 23 Jun 2026 11:56:10 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgNG=F3xO9PjL0RcKy3UWvq0Np9uZu+nFUQBAA8So9xdA@mail.gmail.com>
X-Gm-Features: AVVi8CdpFGqem5dP7mBI1VIDKVc8WIWTZWMdjSeug8fejnSzLkFpq4QaapJhuLo
Message-ID: <CAHk-=wgNG=F3xO9PjL0RcKy3UWvq0Np9uZu+nFUQBAA8So9xdA@mail.gmail.com>
Subject: Re: [PATCH] crypto: af_alg - Document the deprecation of AF_ALG
To: Eric Biggers <ebiggers@kernel.org>
Cc: Bastien Nocera <hadess@hadess.net>, linux-crypto@vger.kernel.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, Marcel Holtmann <marcel@holtmann.org>, 
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	linux-bluetooth@vger.kernel.org, ell@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Tue, 23 Jun 2026 at 09:51, Eric Biggers <ebiggers@kernel.org> wrote:
>
> We're aware of that and are taking it into account in the allowlist:

Note that if we can  just unconditionally make it depend on
CAP_NET_ADMIN, that would be good - independently of any allowlist.

Because if iwd and abluetoothd are the main two users, and both of
those already require CAP_NET_ADMIN anyway...

                Linus
