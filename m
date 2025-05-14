Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A642920AD;
	Wed, 14 May 2025 19:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747251657; cv=none; b=J5+jr+ZhSWHqgPHRr9XUKeI/a3MfRExv12Qb9h070Ld6is1+hVNxtqWlx53f9UGFl7w3HFHakf0/cbZmzZRaRJTOOem7hAJZyEciOQa1UKyGizB46RWtj7uB/uTT5XO95xk4LjYv+Wd8hrjTMFsFXMS3i/Kei+7qvz/S4yinvpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747251657; c=relaxed/simple;
	bh=3dlzPlsKinE64MIivs/eYgaMWH/MDC38gxxjBt8A3Lc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Lw1CWpUGrQ39n0d3jTjVFAlFskdvzH1QSPxf8GO/iHC6RV0D3SXG96rQ6Cvz64gFfIfiVrq6LbYR3FJXq/Q1LviD8Itdv+239ts+71x1D0TL4mwH6u+fBdCwNNDj/JU1QAUmZthSYUY/I5hi7EuxCbcCRRshHKdzqq5kXrl7jQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HxR/W4ka; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HxR/W4ka"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB802C4CEF1;
	Wed, 14 May 2025 19:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747251656;
	bh=3dlzPlsKinE64MIivs/eYgaMWH/MDC38gxxjBt8A3Lc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=HxR/W4ka+N5RROLE4HVcUoDexz96lUTer7bf5kWko4Ar45+vUxHucDixeFN/G8U2u
	 vtmTM8mZsd7G4ObPUIZTl9DsfI3LAP1jFNzy2wUYkvyFqeUywLbd5MG/vOptkVmwrR
	 4Xsu3HxueSmiOe7LK/ne0m+BZxjfEO4/41pF+iVni6TsjGeQuWKFadtOI2lAC77FEb
	 QuOx2YVhqQRiNA9kPkTEkoUrvMnNo4t1gPWniE+481PvhG7OlDd4U5gndLyp/N4wiB
	 LUNXMDCKlvc0nNuD8CWPqMl8BE7Othj3A6jWlPYU0DDJsLwzUYKCgZeAXPjqsswLQ4
	 xX58Rng8JPpXQ==
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-70a2b85aeb7so1559597b3.1;
        Wed, 14 May 2025 12:40:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVNELRNPvCqsBMrCcdLZLNRfGgs5UobS/A0dLVjMO/M6MNCi4XaKSDvsUJFkF5SqSTeQB42D0EjaFDBCyk=@vger.kernel.org, AJvYcCXE7VvjeuucIJTlRpvBKeHyAHSa6S8tHbLQ91ybFerAeD0RJasyif6UVLm4vyuYYyYSw3fqapxwbA0PsiPpt5civ6UgXdTi@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4ECE0JfS+jSdS8tDqt49mVUVNgEL0IUX3Mo1QLgAEugJKoC1S
	QWig+terrTGCOFVwI1xthWxx2nVVnEGE+IBZ23QKtZbxsdEV6bLlAdWB/ZMtD74B0mlaYXRe9KD
	UZbO10KmXki1U+PTgHyJ2J5muOWs=
X-Google-Smtp-Source: AGHT+IEP2dzhREGYTCFSb4cVSt7gFADGTaNf6IvRfOS9U27FGV6+xhsxm8HguKdO8AJS6BI9tdut+ZVDHu7N1j1ilak=
X-Received: by 2002:a05:690c:650a:b0:708:a686:7f04 with SMTP id
 00721157ae682-70c7f1457edmr70334417b3.2.1747251656240; Wed, 14 May 2025
 12:40:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250514050546.155041-1-ebiggers@kernel.org>
In-Reply-To: <20250514050546.155041-1-ebiggers@kernel.org>
From: Fan Wu <wufan@kernel.org>
Date: Wed, 14 May 2025 12:40:45 -0700
X-Gmail-Original-Message-ID: <CAKtyLkEnJGFCAuurSihU_bUTCzEqTXEx_0dG0OHQ8353do0okA@mail.gmail.com>
X-Gm-Features: AX0GCFsm8dqNuJMkFb4meuyUWRQJhsF9FsS2cF_qn7tt2hQVcr0HcXaYGSypFZM
Message-ID: <CAKtyLkEnJGFCAuurSihU_bUTCzEqTXEx_0dG0OHQ8353do0okA@mail.gmail.com>
Subject: Re: [PATCH] ipe: use SHA-256 library API instead of crypto_shash API
To: Eric Biggers <ebiggers@kernel.org>
Cc: Fan Wu <wufan@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E . Hallyn" <serge@hallyn.com>, 
	linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 13, 2025 at 10:06=E2=80=AFPM Eric Biggers <ebiggers@kernel.org>=
 wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> audit_policy() does not support any other algorithm, so the crypto_shash
> abstraction provides no value.  Just use the SHA-256 library API
> instead, which is much simpler and easier to use.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks. Will pull this into ipe/next.

-Fan
