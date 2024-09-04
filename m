Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9976742A92
	for <linux-crypto@vger.kernel.org>; Wed,  4 Sep 2024 03:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725419825; cv=none; b=F9UFcRCKPoPiEkWlpuN3zLw+jmPJxOF6UB91LYhVhKSZKE38aq/A7l2kekDRbha7dR21HmC4UaNV8Tyjgq0ENN35cYwVQULeOoc/XNqFOoCW5NJFpOEFZ92wCUvgyZTDvASv+MlQShnvRdcCI13dJKH29iYSmw6iNOo4Mrh0s0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725419825; c=relaxed/simple;
	bh=axdPi6gHlUQ1P/3ccJLxc/fXwwP7dqVbm7fA2Rn5BEI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r53hZPedPFSYEcLI2ON+orFWyOVIA8uF5+feeCi0oYeNzXEfIAUAyv17hV3X4UKzZ4c86Mu7NJp20Wh1iyTGcWMgrDSKCIKoK5S+uXdSSIvZJjU0XSpsc9POm7OtOJtjLIbO1rm0ama8X9F1F5kMp+L7qWd8HbQbhoc1DLvBUMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=F1ohc3bT; arc=none smtp.client-ip=209.85.219.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="F1ohc3bT"
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-e1d0e74f484so388044276.2
        for <linux-crypto@vger.kernel.org>; Tue, 03 Sep 2024 20:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1725419822; x=1726024622; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aIgWpf10MgiyR/h9hwrNrtk6IK0asvonhO5fQ7psyeA=;
        b=F1ohc3bT0TkDY8WFPEyhXFbzx5SSETY6XjSEKNlnxAQ3kjM0wpuF/rwsU1Am9t6DdT
         BvRcXRrTRS6tH3f57W504encJThrER9omty9o3gBb+M4lkCLsOP7phaaZw0qUgGqgW7e
         KDcV1s9vbHRwPijIhRUoJSAvBvhAqUeDmzGh8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725419822; x=1726024622;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aIgWpf10MgiyR/h9hwrNrtk6IK0asvonhO5fQ7psyeA=;
        b=gAJNNRbdzec+Tvo/xlN4gWmDgIdTrZwffdEEzGxGEmS9jXP3H6AgrqVDauLAIUcb5A
         /o3tFEabPlbCnvX9pa7IJRHfLIOO4xlMah1q5FJqTzagDMA6SM5MhwzH68RNk6MxuwFJ
         6MyFKHECBzS0uJIMRMU5ETkHNaWOyTpS17+gTnDF0nWnOETHiijEEST1+OVdNVmPH7rY
         FlxJSonB9NKbEZrlNH96ze9iQdCxQTNWmcN3YC3RiO+Wg+pb/xuVsJClDWGsdH0/wH0V
         6J0/8WhEIsq7bIUGgU09yt5mhiKu1xXzF4jlDzGE1p+dLcKSS08F8fUNB/7L7xr5lNbE
         VlzA==
X-Forwarded-Encrypted: i=1; AJvYcCVuzmxt6GyehOnrMhCLO9fhgAiAJfuV9s4De55N5xLsvDGk8wYdmg2gdgoiaZ7exgHykiEHgVp9ssG6CY0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGAHaSErojNp6k4p5NLE0gp0AbY8lKQ7jXHbp766BNTx7vgcRu
	dncqDmS8c10HXEpNa3eSQTodA+0AtFKqf2LTjMPcLtymTrweyKmVt1VDVGEYmWEUFGxfwVD3QsF
	xae531AmZAYDRRik9/odpJH5bJBCI+J37RG57xa/d8cH+f+dZ
X-Google-Smtp-Source: AGHT+IGKsUC6Kxc+OLxbn3qG2wqlObrwo4AQ8dp1iSHt5FmMVKwFK+WKvUT3kE/L/RAMEcMFXjEebdh58SI1u2YXzxg=
X-Received: by 2002:a05:690c:6ac2:b0:6b1:a965:4ddf with SMTP id
 00721157ae682-6d40e877a34mr176529637b3.27.1725419822626; Tue, 03 Sep 2024
 20:17:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240729041350.380633-1-pavitrakumarm@vayavyalabs.com>
 <ZrcHGxcYnsejQ7H_@gondor.apana.org.au> <20240903172509.GA1754429-robh@kernel.org>
 <ZteU3EvBxSCTeiBY@gondor.apana.org.au> <CALxtO0n9gjX80tGEFtA_6FH+3EtxuVje4Ot58WvQXXNtDwSSkw@mail.gmail.com>
 <ZtfPKi-qDD_uJDx7@gondor.apana.org.au>
In-Reply-To: <ZtfPKi-qDD_uJDx7@gondor.apana.org.au>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Wed, 4 Sep 2024 08:46:51 +0530
Message-ID: <CALxtO0mD2QSUcHitx-CDpY+LHjk7L3xfXEw27dSFewUwqepp1g@mail.gmail.com>
Subject: Re: [PATCH v7 0/6] Add SPAcc Crypto Driver Support
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Rob Herring <robh@kernel.org>, linux-crypto@vger.kernel.org, Ruud.Derwig@synopsys.com, 
	manjunath.hadli@vayavyalabs.com, bhoomikak@vayavyalabs.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sure Herbert,
  I have the driver with all the fixes merged and DT fixes asked by Rob.
  I will add the DT bindings to the same patchset and push it immediately.

Warm Regards,
PK

On Wed, Sep 4, 2024 at 8:38=E2=80=AFAM Herbert Xu <herbert@gondor.apana.org=
.au> wrote:
>
> On Wed, Sep 04, 2024 at 08:22:31AM +0530, Pavitrakumar Managutte wrote:
> > Herbert,
> >   I am pushing the DT bindings.
> >   We had a crash with the changes, we were root causing those.
> >   Should I push the whole driver once again or should I push just the
> > incremental patches?
>
> You will need to start again from scratch.  Please make sure
> that you include all the fixes that have been posted.
>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
