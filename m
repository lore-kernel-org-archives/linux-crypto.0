Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B43943AAE
	for <linux-crypto@vger.kernel.org>; Tue, 11 Jun 2024 16:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718123294; cv=none; b=VSRPKNLdsfwa77QmOaq/xeh1Jd9Ln8UGYtSVTPa+2p+z9K/f17gVD/BfSApaG5lXzAdRWdtbkNWK79ipdox3D82rz6HtV+s6wQL8FjE967Y4wErz3Xu+uWyKqbelbP8XK21yhtOojZ1Vs65H0Bfc5GABJAS0PfNl+MqAH8At59Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718123294; c=relaxed/simple;
	bh=N4evEqm5Lsj9muDRZ0FKGlEsgvOKjl0qugGTleH/ab8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bXYkniy54JewNoTMk8fZIJd5EKBV1NPWsWYWwecr6YqL8RupipFJlVzZGTOmP/z9d85Py0CXksYuwboZsPJILYQ+sLIXCkZLtpNvPt8e231if1jhwNKBq7ydl7a8LeGGPYD8nUFmWx81MgASAHgBC4RqioIXrRqXsGWo4+DQPqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OizTeFwj; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OizTeFwj"
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-3d22368713aso1801750b6e.1
        for <linux-crypto@vger.kernel.org>; Tue, 11 Jun 2024 09:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718123292; x=1718728092; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BG7XPsDBrgukiLlYYahx3Tk9saQ0mEeAf77iSA+2xAk=;
        b=OizTeFwjBU81njD45yxQT2wWY3Eodu/9OIU5Hg4n1NA1r58jVM9QenP8mB+dRc7lEv
         Dwb0Z45eMdGk/GNGRR/kaOSM+cO7BcnPeQw5KEVNAeKK+5y+24od82A+dYRk0TQfaaG5
         Ko5TK1i/d1qE+0PrUgn6yXwsMA+2SYtMo+FxPEsTvK02NznyZVP/IAXRVcDumy9si3Vm
         E/Qt3Nq6kdPu0fvDs4fhfMOet99oYPOxUR4bB64H2AsbyB9vwp+RmSHDy4KyurNG83Zx
         ShD2fVSXur3+4qOL4l/XNg/HqLHyyUIgVmEcUkDOq0sRrCgIeBElI/2KGXPZyJVF/NYn
         Ga3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718123292; x=1718728092;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BG7XPsDBrgukiLlYYahx3Tk9saQ0mEeAf77iSA+2xAk=;
        b=RYBuSpnRX39c/Jan4S0vk0iR8r6YnGOgp8i0vFOiijeYMzcmG3NVDLQHJf8CKYDb0v
         6hD3j13L2VzSEDFMDp4ATsnK3K43wwyF4wcI0CAnnBhNsdH1AGOQNmItHnHylpeXuaXu
         IRhkzTNVX0ha/s202nrTAZ5QmW50wqJjOnHohOFs+tFkCc4JirJlxIARafynBlRvbRdW
         aB3eePV9hWt93UzdY3xPsNz69sjRCQNObxT0JY+LqI4k8JoV8j7b319BuepH8Ijuke7Y
         +FELHneFiO6Pma6K1DeNgAUIxfJX+ri61NoBaKxke5J0+hy6ZifK+UzRXowaa3kM6fFn
         NPww==
X-Gm-Message-State: AOJu0Yx5yc8Vj24zX6aDNRyKb36FvAc5U3X5lAi1ghYvkfGNilUPLbqo
	KP0ZV9uIkLoxt9D1vjhedQ8YGpfsPvb/TwkAL/S7btXDQbv9wcABlhbNSZFuOJJQCaUS7abEYmw
	rTh2HxsPZi5HkqGIXPJhfWOHezBrRTX4vc7FN
X-Google-Smtp-Source: AGHT+IGsoxkLL97yYbUdTS+m9HxBL/aA7VS6tK+dAweHiy1stwZYh0uBGwlgxKNC988k8KBFPrrE/j5bFzDX0CXaftQ=
X-Received: by 2002:a05:6808:2183:b0:3d2:1f88:3e86 with SMTP id
 5614622812f47-3d21f88455amr12786369b6e.37.1718123292024; Tue, 11 Jun 2024
 09:28:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240611034822.36603-1-ebiggers@kernel.org>
In-Reply-To: <20240611034822.36603-1-ebiggers@kernel.org>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Tue, 11 Jun 2024 09:27:32 -0700
Message-ID: <CABCJKuf-yUQVh_gpO80qbifGyonQYDC-=QxL+PPwUzprXqQBUw@mail.gmail.com>
Subject: Re: [PATCH v5 00/15] Optimize dm-verity and fsverity using
 multibuffer hashing
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, fsverity@lists.linux.dev, 
	dm-devel@lists.linux.dev, x86@kernel.org, 
	linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ardb@kernel.org>, 
	Bart Van Assche <bvanassche@acm.org>, Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Eric,

On Mon, Jun 10, 2024 at 8:49=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On many modern CPUs, it is possible to compute the SHA-256 hash of two
> equal-length messages in about the same time as a single message, if all
> the instructions are interleaved.  This is because each SHA-256 (and
> also most other cryptographic hash functions) is inherently serialized
> and therefore can't always take advantage of the CPU's full throughput.
>
> An earlier attempt to support multibuffer hashing in Linux was based
> around the ahash API.  That approach had some major issues, as does the
> alternative ahash-based approach proposed by Herbert (see my response at
> https://lore.kernel.org/linux-crypto/20240610164258.GA3269@sol.localdomai=
n/).
> This patchset instead takes a much simpler approach of just adding a
> synchronous API for hashing equal-length messages.
>
> This works well for dm-verity and fsverity, which use Merkle trees and
> therefore hash large numbers of equal-length messages.

Thank you for continuing to work on this! Improving dm-verity
performance is a high priority for Android, and this patch series
shows very promising results. FWIW, I would like to see this merged
upstream, and any ahash improvements handled in follow-up patches. For
the series:

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>

Sami
