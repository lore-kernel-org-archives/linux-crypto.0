Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CBE6218305
	for <linux-crypto@vger.kernel.org>; Tue, 12 Nov 2024 19:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731440890; cv=none; b=QC3bkZHsqq0lmgaXBkL2enGtMklC29i/nAVNqOjg+LAqwgSSV8ILPl8h4IrWNc/Zh59wtFWUDJM2GKIMzf2Bcdlxo+Xycz2x3XxT/xXiCqK+ecPKtTKlQhG9dezSGv5ruJiGlN207XztqVS/1n8CmSJdwUEeNnaBHkWmncBSsPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731440890; c=relaxed/simple;
	bh=o8eOdtHtMHFg2vs8SZ/DKu2qO40wUv2AUpZc54PgLH0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eP6C/LvKVEZ6KursypLFdv9TZRNR/FDhb1zPoLkdXkgSmiw+IwLTswS2am5hxLAiQpDWIwaMsc8ijofc3410suPkMG1KiSFkJqPJKTMTgQDRcPOB5ZLGmT7nyLf6we0gc3GJvAnfkP61tPCSnrTq3BGaY4UmISSrm+DMX/76YdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sSBrVZ5t; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sSBrVZ5t"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a9ed49edd41so1044555666b.0
        for <linux-crypto@vger.kernel.org>; Tue, 12 Nov 2024 11:48:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731440887; x=1732045687; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o8eOdtHtMHFg2vs8SZ/DKu2qO40wUv2AUpZc54PgLH0=;
        b=sSBrVZ5tXJ9/IA5CI4u+zs5VRaB9pnFRMuqszy8vMXy9gS5MTyL47Ye94QGCTRSDSD
         V7/p4Vea8bWk+HnI2lUXWZSqOnLeeSG1aACB1xWQ8BKftUxYlHc4ChDETfjc+fxPSh8C
         YnkwORc/eVxRtPPQwtf+UvQwNzlOq4BI56trNeEdUisIVC4HrufbDb6h8LyCGDyDRg3B
         4zizb5rmlJgU6DhHhaBGCejiD1XOFPU7cAJykmcXVv7bSs66iUbNxLwfNtT02fLSGTa9
         iFVBKpZ/QMIgrArM2GeOklPSqEFLeilMr1smTSV+dxwiWzpN97jBeNHvCJTJ1fBpCYhQ
         vhpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731440887; x=1732045687;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o8eOdtHtMHFg2vs8SZ/DKu2qO40wUv2AUpZc54PgLH0=;
        b=lae0bZjR7H0tyAdkr/Btoh//yRXs4ooQ12FpALIV2qgVrrcno50nYV7a0gAXzAvl9/
         Gzve7Tmbcuvmi6ZWQqtDbQ8L3+ubWnBWcnOuPuNJS5w13Z6/FdcJEedQEtKKTvNzJYMX
         9JOv6JNVWrIBphenKuyXSqAND69hrX/L2wwHtIOwvq81/2OIHmBkA3R8ploO6kwQ0xSO
         8KMfnGZLXPINJvEIgjHQDBtpmU2/Ni4b6eKxhEIZm0tO05hd4xgS+3tsavtgwlIDmnBL
         szSzUznR+P/gRltNtvnbqn0SJ+Kdem8lTckK20LZLzSR8PgDQSAPWpFTD83gmlPAVSmO
         R60w==
X-Forwarded-Encrypted: i=1; AJvYcCWIZOEAPg3sBhGy+VdZ6nywjIyOtlXWYyb8Qy4HXwpuAZQHlGt/qyD4bABadyKB5YF9vMcQfe8dgUfK0fU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxEPlKX6UT/iN0tfvUBePGZhmT2f7D95NRnxMz4W5kbp6fzFJkX
	6yP5HJjU/u83RDq77B4TW85fAx43ULewS+wwujEXIyznY6X7Y6X/9UME8iqmCkNJxDvvSlP0eDj
	CZT1RsIC2e5PQX9rKKSSCa2HRhhnswX6d2/Rv
X-Google-Smtp-Source: AGHT+IEFgQusI2LRG8yS8c+lKwjb4SOnATX6OL+zJ6TrY0kBJRmVDcTAeTIKs1eTWUeRMWkbTKPLqC6ZZa3hgOujSU0=
X-Received: by 2002:a17:907:318e:b0:a9a:cf6:b629 with SMTP id
 a640c23a62f3a-a9eeff4458amr1685921066b.29.1731440886519; Tue, 12 Nov 2024
 11:48:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241107232457.4059785-1-dionnaglaze@google.com>
 <20241107232457.4059785-8-dionnaglaze@google.com> <4ec6b73f-4707-c93a-f046-213ac4d4549d@amd.com>
In-Reply-To: <4ec6b73f-4707-c93a-f046-213ac4d4549d@amd.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Tue, 12 Nov 2024 11:47:51 -0800
Message-ID: <CAAH4kHaAqh1R6CGBKXNsO+uQnscwGo0Y06MTny8CebSWK9QMaw@mail.gmail.com>
Subject: Re: [PATCH v5 07/10] crypto: ccp: Add preferred access checking method
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, 
	Ashish Kalra <ashish.kalra@amd.com>, John Allen <john.allen@amd.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	linux-coco@lists.linux.dev, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Michael Roth <michael.roth@amd.com>, Luis Chamberlain <mcgrof@kernel.org>, 
	Russ Weight <russ.weight@linux.dev>, Danilo Krummrich <dakr@redhat.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Tianfei zhang <tianfei.zhang@intel.com>, Alexey Kardashevskiy <aik@amd.com>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 11, 2024 at 2:46=E2=80=AFPM Tom Lendacky <thomas.lendacky@amd.c=
om> wrote:
>
> On 11/7/24 17:24, Dionna Glaze wrote:
> > sev_issue_cmd_external_user is the only function that checks permission=
s
> > before performing its task. With the new GCTX API, it's important to
> > establish permission once and have that determination dominate later AP=
I
> > uses. This is implicitly how ccp has been used by dominating uses of
> > sev_do_cmd by a successful sev_issue_cmd_external_user call.
> >
> > Consider sev_issue_cmd_external_user deprecated by
> > checking if a held file descriptor passes file_is_sev, similar to the
> > file_is_kvm function.
> >
> > This also fixes the header comment that the bad file error code is
> > -%EINVAL when in fact it is -%EBADF.
>
> Same comment as before. This commit merely creates a helper function, so
> this commit message is not appropriate.
>

Is this a meta-comment about how the commit presupposes being in a
series with a goal, but should have a self-contained commit message? I
don't know what "same comment as before" you're referring to.
How about this:

crypto: ccp: Add file_is_sev to identify access

Access to the ccp driver only needs to be determined once, so
sev_issue_cmd_external_user called in a loop (e.g. for
SNP_LAUNCH_UPDATE) does more than it needs to.

The file_is_sev function allows the caller to determine access before using
sev_do_cmd or other API methods multiple times without extra access
checking.

This also fixes the header comment that the bad file error code is
-%EINVAL when in fact it is -%EBADF.




--=20
-Dionna Glaze, PhD, CISSP, CCSP (she/her)
