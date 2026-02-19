Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B41A72621
	for <linux-crypto@vger.kernel.org>; Thu, 19 Feb 2026 03:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771470490; cv=pass; b=i5NscETKmJwQ+UE+v7jRnDK/0gTpQi1us/KUKzKGGLEwdzb0gfu3dfMMieCe7UeGsqkiK+zulYEmb/0YHEHAI3Wg29oC4ytGplMny8tLC4xxzwVIJBwkGwCjLRF82/UyP+crFbfuGKTlh5cHAwpxE+bJoi/ePdUabvTvcxChUZw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771470490; c=relaxed/simple;
	bh=rbzPvagpoG6UPn0nuadO4/Qt1Kc9tDA3KfvTKUQfHeA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jnqc2WWBsfbF2TH/5F58qazeqDLM3d1I1Ugzg5z771FSGFuX1JFxlmHfarsW1jAMOp5EpRhAb0iK/+4ENiiIofumxRj4Gg+LNvbS0AyFXlFtQp8RHBn4GptouUdpc8qdgY9ppbLBx2JUjnStxJlejKWEVKRZX6NAfs/bPNdTLX4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Pfdn68fM; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=qehOJ2as; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Pfdn68fM";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="qehOJ2as"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771470488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IN2sA1JRTNH6UQklfgt+KOn6zP7+NRpBqtUBwsCoDdY=;
	b=Pfdn68fMQ5Fnp4Y28UQgdDeVK5tQVBZLutKuBaFTBIECajFW+Ihy3fkSPrcCBmR3vDedGL
	X6EdRzCFVy1a/nQx0/AlrCmA/MDG9GNeGB/VU3jFwwuNUBbppOindsaAZRqj08dJDBNabR
	37jtF2H4acy1rbk7/ZHwcJdseQrckx8=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-130-6FQ99I1bOeWAmYSTrr3UqQ-1; Wed, 18 Feb 2026 22:07:55 -0500
X-MC-Unique: 6FQ99I1bOeWAmYSTrr3UqQ-1
X-Mimecast-MFC-AGG-ID: 6FQ99I1bOeWAmYSTrr3UqQ_1771470471
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-b8fa51ade75so43644266b.3
        for <linux-crypto@vger.kernel.org>; Wed, 18 Feb 2026 19:07:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771470471; cv=none;
        d=google.com; s=arc-20240605;
        b=Ewz4vzlDsWLHSGqBxBapoVsWN/wV5eL8UvqxZt9GasXgheBCSBLyejDyfJhAFz30xc
         n4ZuyBOz/NVJx08EYKIZ5LhAdWzz9h0sr/WvzHc4mdxfv9DXLeCto+/bMYcCQEmK8fFs
         lci+iutBpp4zzGX9smRHOcinXFHxok8k72/Ttnl7f8NWiAbOhWBLsDfkiL7nFt28Ir6q
         uC+W2R01a6s+XLPj00901zwDeGHUJz//kEDtW3BiqHOWlR+bqjaTbJ4VS0Igw/qChvQx
         xFYbygVF8DgMhD8xjSUuvLhD6lAztITsm1IyDA5ohAKXj15af9qYJ9qVU4kulvA/ukGx
         tBfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IN2sA1JRTNH6UQklfgt+KOn6zP7+NRpBqtUBwsCoDdY=;
        fh=3SO0D5Lm4YPb13YyA8oaSZZVo2EMdIfyqgH010Twbw8=;
        b=R3BFTlpGI+YbddH9Isxer/lrnmluqUBS+aupbxn0svR/rgZWBrTG0uiQUbjBHFhX6R
         vKfQ+N/eOCilgL/Lt2eMt4b8IvZJtQJyiNWiGawGInkI9SrgV3Muloyn6zgyo30uZw29
         103gq47+2snnm05bdVbym9qgCXWAjX40iN9/4Ad1izAphn77nvRJ1gIGMzQo2/W6T0GO
         wrVULoZumywhrcSBJTippRc3gmlcDLRE6AgIRO6SEdOKH2Fn/gyx8b2spGpwAMvUkdex
         8mPo+U3du6nz6lyQpbH3Tz+4cOpje7uk4JsSqnJnOr7lkGoKAGm0xJ3auDhIWeyQWy76
         /p8Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771470471; x=1772075271; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IN2sA1JRTNH6UQklfgt+KOn6zP7+NRpBqtUBwsCoDdY=;
        b=qehOJ2assbSAWjdO2QTT1dJvj/pvjEbZL7iZSs/C5c95Dd5Y35EWCfUm6iL7G4wO6d
         PyeCEHbhbhQ0RNCGL72uUcOKPXWAZS+s4z3c0s+h0j2g5pCdyuWDk4TQp2zdlFWyLIVH
         IgfVD9a3c4WOrIbaxcS3cHncs82SISqz4dqgTBF8QEbGLe0aZkddlv6bZEbMSosgVXvF
         UF0mS1wpHHAnaKfyjDlo56bkfhD5NAEZF7Bow2evHVLoT5TlnwD1UEnRlGzLqvROiyne
         Ny27A9z6Q74+4NIETyPRPHSaqs1JhSh35CUY3mAAOY1MDYsU/7raPwFNkbtz/2qQ6ohm
         tRyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771470471; x=1772075271;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IN2sA1JRTNH6UQklfgt+KOn6zP7+NRpBqtUBwsCoDdY=;
        b=dNnf9sesQKNdGDMtX2Gcsl1rwfpJbepQMMRQCdGEwTe1kTwacCO0V57yvruJ/wQp2w
         5jlHvK8N6evXoAAMnVqw1qBp4Ti+vMu+pbfAFD9waX+Aa+HCUFLWmBQOuXA8oF4uAlQG
         Nlc4WUXBMKYC8BLeOGYsey5MZq2nwjL9WjC16wUwtyYAf7kuX8Egx6AIQQo+0hSZJMT4
         HIggGB0TeSIELa2b+vYUnELllCb+Nt6LYGaGwKXnf8xKj4d7anZn4Nc5/KHKWUAJpdmI
         e8S39iJKYXHeQHVQNoSbrUgKuVQXks5oJaavKzBWh9Ott+YPpTv1s706l3LVjAP7SwoK
         LJzA==
X-Forwarded-Encrypted: i=1; AJvYcCV8YqBqkqb5xjgF33kLdDkTus9NjVWL7h00E9VkKNewzJ7FpoxbKEE5KOiibY2vD291BZr1TjE/r74dv70=@vger.kernel.org
X-Gm-Message-State: AOJu0YyT0TKNpIFUq4ukwIhdOXFgeqDy66tYyHHjh7wu8nX8iBcdQIWp
	WcyTURN4l56wYGUBfj114ZdiHUXOB7qAAmZlzErsStXpdqn6xoIEtigJ6m5eY50uovNFEax6tj1
	wklZURaOzf+n50knnhJW62PIks9MClBKacRHSHaYmZcSyQvoMkPpqCMdSNeEPDlksSJLOYArG1h
	Ius3sJYe95R0ikoCu2VrSua3BGXKdgD3YG8J7X19iX
X-Gm-Gg: AZuq6aICi8+zBqOiyDBSHI+Ahzaw4bUAx5T4rtaWgm2MDcK9DJCXOXhTstyW1i4mRCD
	Atz+apMNKyzl3q/E0Rnm2EKRZS3pfS2KXDBVt2uJKRUm/l9dgwEGSA1t9QheB0XduZA28yNdC7C
	oZcOzlF9cp9g5SteS+f/+w4h5bGat7h+CwsXqoC33KKqoByRQuFvCwjqbnJVljCsmAXvTD8COUA
	iLbdrPP6tGSCJcyIGYWFyUGRf487cjhu5VPufBe
X-Received: by 2002:a17:906:f5a5:b0:b87:2abc:4a32 with SMTP id a640c23a62f3a-b903da926b7mr260716466b.18.1771470470666;
        Wed, 18 Feb 2026 19:07:50 -0800 (PST)
X-Received: by 2002:a17:906:f5a5:b0:b87:2abc:4a32 with SMTP id
 a640c23a62f3a-b903da926b7mr260715566b.18.1771470470229; Wed, 18 Feb 2026
 19:07:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260219000939.276256-1-tim.bird@sony.com>
In-Reply-To: <20260219000939.276256-1-tim.bird@sony.com>
From: Richard Fontana <rfontana@redhat.com>
Date: Wed, 18 Feb 2026 22:07:38 -0500
X-Gm-Features: AaiRm51m-AQGr4ke1e-Tsrl9rio623bAL6h5u-neUt-g2ocBiaaCaIReZ2ZwG3M
Message-ID: <CAC1cPGy07RtOQifhova1+6ezTiKHzK8ZjBKQrWY9UW1t4hAG1Q@mail.gmail.com>
Subject: Re: [PATCH] crypto: Add SPDX ids to some files
To: Tim Bird <tim.bird@sony.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, lukas@wunner.de, 
	ignat@cloudflare.com, stefanb@linux.ibm.com, smueller@chronox.de, 
	ajgrothe@yahoo.com, salvatore.benedetto@intel.com, dhowells@redhat.com, 
	linux-crypto@vger.kernel.org, linux-spdx@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 18, 2026 at 7:10=E2=80=AFPM Tim Bird <tim.bird@sony.com> wrote:
>


> +// SPDX-License-Identifier: GPL-2.0-or-later OR BSD-3-Clause
>  /* FCrypt encryption algorithm
>   *
>   * Copyright (C) 2006 Red Hat, Inc. All Rights Reserved.
>   * Written by David Howells (dhowells@redhat.com)
>   *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version
> - * 2 of the License, or (at your option) any later version.
> - *
>   * Based on code:
>   *
>   * Copyright (c) 1995 - 2000 Kungliga Tekniska H=C3=B6gskolan
>   * (Royal Institute of Technology, Stockholm, Sweden).
>   * All rights reserved.
> - *
> - * Redistribution and use in source and binary forms, with or without
> - * modification, are permitted provided that the following conditions
> - * are met:
> - *
> - * 1. Redistributions of source code must retain the above copyright
> - *    notice, this list of conditions and the following disclaimer.
> - *
> - * 2. Redistributions in binary form must reproduce the above copyright
> - *    notice, this list of conditions and the following disclaimer in th=
e
> - *    documentation and/or other materials provided with the distributio=
n.
> - *
> - * 3. Neither the name of the Institute nor the names of its contributor=
s
> - *    may be used to endorse or promote products derived from this softw=
are
> - *    without specific prior written permission.
> - *
> - * THIS SOFTWARE IS PROVIDED BY THE INSTITUTE AND CONTRIBUTORS ``AS IS''=
 AND
> - * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
> - * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PU=
RPOSE
> - * ARE DISCLAIMED.  IN NO EVENT SHALL THE INSTITUTE OR CONTRIBUTORS BE L=
IABLE
> - * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUE=
NTIAL
> - * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOO=
DS
> - * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
> - * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, S=
TRICT
> - * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY=
 WAY
> - * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY O=
F
> - * SUCH DAMAGE.

This is not `GPL-2.0-or-later OR BSD-3-Clause`. It appears to be
something like "GPLv2-or-later code based partly on some BSD-3-Clause
code" which would be `GPL-2.0-or-later AND BSD-3-Clause` (with some
significant loss of information in the conversion to SPDX notation,
but I've complained about that before in other forums).

Richard

