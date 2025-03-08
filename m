Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8187B5028C
	for <linux-crypto@vger.kernel.org>; Sat,  8 Mar 2025 05:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741412469; cv=none; b=NVTODrTEqmwKnVletLBFjReHgTVvO/gMsT+ROzICyIRf+WSDiBGynAaA5pbCR1hXpNV416wz91m4p9vnbdY8sASf61s2eRyij3gmbVPu5FswZMblWRpj5LweEgAhQn6EM06T6QYUh+ZBzwTbi1Ivl3N/MZ2ubYXOrbcIkkomRUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741412469; c=relaxed/simple;
	bh=zdInW9/Q0g3TtRuFFjxtdjGT1ntLsubGIabA7azNnF8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pC1vUcLk8TEdv7Xg0URRxE9wnzoejNVlBTRzI3uvG2nOINQfSxUEtdHdeXlOrKro3G3wbRa5IMrOqYUNIkzYVKaoqS2kLeRCIxrCNqmAMJ6LHsOYZIrzi8KUfwLGhI5ILWrcVb3l71vH5I6cUs/yl/82r56gMZjbGTm5G6WOenM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nwY+Kmhh; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nwY+Kmhh"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5e04cb346eeso4344192a12.2
        for <linux-crypto@vger.kernel.org>; Fri, 07 Mar 2025 21:41:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741412465; x=1742017265; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zdInW9/Q0g3TtRuFFjxtdjGT1ntLsubGIabA7azNnF8=;
        b=nwY+KmhhQf+38vFFQEm9kV9LFhWK8Jy3sEka9D99j9X7OvCMtu3G5LFTvQ7+1KjQzH
         /Nbdemw+dU4XMWcclDVOPmrXf9W3wC0af920HfvKjeCFOF7R8ber/KysZfDKdoXN2CkI
         ShH7yGxKrerRBXZxUXmUdBLpxgGhYA6zZcHB7G1oTK9eba6XtPkrujf48o/Kejw0h07G
         xCWoo6IRpMw4KQ7LU6N0XHSekiK5dCcHN6PF6vuSH0C6+KrroEFt9OLekj03mXEHU6EK
         cyGO8KXT5mRp4zx+g3yXu0ln5lBwhr9peFDZq0JmeV516c5UTuoG6WuEMDzL7YqJuGMt
         Xueg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741412465; x=1742017265;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zdInW9/Q0g3TtRuFFjxtdjGT1ntLsubGIabA7azNnF8=;
        b=qRHS1MjBMm37i8Gr3iE2ODvYc+jku0fIeg5o+FQ03e0MSAaySyFFMAyTd61eYoe/sa
         9ftwCY7FvSa0fQ2dNi8nMTxGmQ9JnEm9XCPs2i2qQgKwIPm7GIyddsc/TxLvGwJgiGsb
         J5o0PQVjlKVsuAFpSTPRQw1GXT5cfpFpLxL9Yc39zrF3dN6tGRAQ+PW4puPG9Hed4Frg
         hJIpMAsgAR8BB8/UoKPCXHyWdqod7RI1+Gm4eqZ3uEl1u4sIcMbFqpcEmGimZHiNwEHs
         khO9tmHfdSE6DcVTKOu6MPnXCV8s5APRghglMoAXBX8dYMi9UgEwT9BvIf883vqKp2Td
         kLAg==
X-Gm-Message-State: AOJu0Yy1A7KRdmKV4ECw2h5d7guEXpUSElIVbkj3u0c3MOyf1okkCnUe
	o8z98fOvCTClmGQYc2xIkF0ht48eDwzxhXnRjLzpccK7biQNeLsJUHhkdVuuCCPy3rnVgB5SoxH
	qv9Cq5uun4SEPi0fw5JHBLQ4vIIvRW7ui8/TB
X-Gm-Gg: ASbGncvIe/9fV9dwlTyoZs+/J+IH7mFn7cqOQcwTds3kswiZe33bfoldgGFJJoO3+KV
	i3q3cnfZXoXI8KIVvwyIwRoMaVIRZXXxu8T4MQp535xWvdYY1Z8aDjEklxysRsmaMOGUZPhyFQp
	F6mmSVi4tDJ9+jsuuWphmdnRaFv9WM8lWg9B99
X-Google-Smtp-Source: AGHT+IHo2PDDI9I6qlRDO6UBHqyRzd05L8tQZ+VxcalVUvx7hfwObQ0npt6/o1jp9kL48JbYgSiDJElWv/K6VQ8EdhA=
X-Received: by 2002:a05:6402:2791:b0:5e4:d11e:7c4c with SMTP id
 4fb4d7f45d1cf-5e5e24bb58cmr7202371a12.28.1741412464668; Fri, 07 Mar 2025
 21:41:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250308011028.719002-1-aik@amd.com>
In-Reply-To: <20250308011028.719002-1-aik@amd.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Fri, 7 Mar 2025 21:40:52 -0800
X-Gm-Features: AQ5f1JqHUPD1cUQbwC0XGvEQjFvxgeTUlhoO_RT4hTgIRg1b6omcoJrhiqinDuY
Message-ID: <CAAH4kHaK3Z-_aYizZM0Kvmsjvs_RT88tKG5aefm2_9GTUsU4bg@mail.gmail.com>
Subject: Re: [PATCH] crypto: ccp: Fix uAPI definitions of PSP errors
To: Alexey Kardashevskiy <aik@amd.com>
Cc: linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ashish Kalra <ashish.kalra@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, "Borislav Petkov (AMD)" <bp@alien8.de>, 
	Herbert Xu <herbert@gondor.apana.org.au>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 7, 2025 at 5:10=E2=80=AFPM Alexey Kardashevskiy <aik@amd.com> w=
rote:
>
> Additions to the error enum after explicit 0x27 setting for
> SEV_RET_INVALID_KEY leads to incorrect value assignments.
>
> Use explicit values to match the manufacturer specifications more
> clearly.
>
> Fixes: 3a45dc2b419e ("crypto: ccp: Define the SEV-SNP commands")
> CC: stable@vger.kernel.org
> Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> ---
>
> Reposting as requested in
> https://lore.kernel.org/r/Z7f2S3MigLEY80P2@gondor.apana.org.au
>
> I wrote it in the first place but since then it travelled a lot,
> feel free to correct the chain of SOBs and RB :)

It's all good. Thanks for seeing this through to the end.


--=20
-Dionna Glaze, PhD, CISSP, CCSP (she/her)
