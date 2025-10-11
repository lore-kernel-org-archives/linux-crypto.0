Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0162B163
	for <linux-crypto@vger.kernel.org>; Sat, 11 Oct 2025 00:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760141861; cv=none; b=ET2TGC3i7B2P0kaRiqzy36ovpd575z6VNgA1cTWP76Ca6oCMWPow6gjSp5D5oFm5VkovsK+VjY9ZN3D5UUsIN2bbsYHRn+9PQNmB50AMWj18Ren0K4Jfq/8BhRPYpTJYXYeTeI2LofUFFTJN4CxAJPmFXyQeO7BovdrlyCVT+Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760141861; c=relaxed/simple;
	bh=aurbYv/vTkfn9HIChUPF+R+B5adUjKdvTNF0+vMzUMk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QwunDDYuFsT1EIxmqdNpqV2k2za40xiTNa2vh0/ufzQqs5ToLzEfzWWAImRf8YKgpUtz0puff/n1Z3EKx0QO1z5b2oZNiGpBGpiisJ6OPMK5LDjhUAzGOhzMKXzrgOGbpwIV0mH9aao+4OkCZDMLPFQvZvw31TsdYgGrmfQ3KF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dSqpPW+n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dSqpPW+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFECDC4CEFE
	for <linux-crypto@vger.kernel.org>; Sat, 11 Oct 2025 00:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760141860;
	bh=aurbYv/vTkfn9HIChUPF+R+B5adUjKdvTNF0+vMzUMk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dSqpPW+nHOMzDlK4YBIAjoI+HWIfEPZOFSsVyRGg1Cv9hT5Yzgc4+3sl9yyPp371Y
	 8/5pfYgUH5MpAztQI92PHBlZTTPhXN0woqvSZD0ofbx0YA/LqzQKjSAI/fjHqcvOaQ
	 GhZMKh7swwUejL0SZZV+jVGYlHuEMFPbAKALMja/hVuUkTTid+YVyDPYtIufkOFJ7Z
	 +1/Ig8VliyZh7sigtaJvfXBqzXV3ix8wIx2JSh9j4SPLp71PZ7CgowF+n4GsSoWlcp
	 RxwDcFcrlvBuyiLehrTm9GWCwqrbxDRagQTqqYNn59QyxI3EY2GH8hrFikt9RslPQT
	 F9bPvtqEi6wVQ==
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-579d7104c37so3251827e87.3
        for <linux-crypto@vger.kernel.org>; Fri, 10 Oct 2025 17:17:40 -0700 (PDT)
X-Gm-Message-State: AOJu0YxO2uhSJo65sjjshnY+7OP4goJhr1nkcn9DYxVM25D6O3iRDhkj
	sGVT/7/rnxnxyipfcRD5UpB6emZGICTt+7jv0jcE447b4dn7m/pqRhnpj/GI/Ua2R8g7ybMi9PM
	S8T1iUmUBqvxXQLKNV7zWctWhsVeAXHE=
X-Google-Smtp-Source: AGHT+IFYoBXl8MLluMTfeFwJa+NEuCYmEcZBESbt41XDIJLh5zc+uZZNMpU3+8nz0NSO+UX0bF6jbyWWcJ32afRcmkw=
X-Received: by 2002:a05:6512:2247:b0:587:94d4:9f7 with SMTP id
 2adb3069b0e04-5906dafcef9mr4486420e87.57.1760141859021; Fri, 10 Oct 2025
 17:17:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251011001047.51886-1-ebiggers@kernel.org>
In-Reply-To: <20251011001047.51886-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 10 Oct 2025 17:17:26 -0700
X-Gmail-Original-Message-ID: <CAMj1kXEcVSbib2G9hByCcMqvGVvqCcvgLJR09kGpHfVUJo7Jcg@mail.gmail.com>
X-Gm-Features: AS18NWBgw-3ehwGSdcD9jpkVDhSrROiFc_n2ExAQIc6Y2SSjkNyUqzxOoNatpdo
Message-ID: <CAMj1kXEcVSbib2G9hByCcMqvGVvqCcvgLJR09kGpHfVUJo7Jcg@mail.gmail.com>
Subject: Re: [PATCH v2] lib/crypto: Add FIPS self-tests for SHA-1 and SHA-2
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>, Vegard Nossum <vegard.nossum@oracle.com>, 
	Joachim Vandersmissen <git@jvdsn.com>, David Howells <dhowells@redhat.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 10 Oct 2025 at 17:12, Eric Biggers <ebiggers@kernel.org> wrote:
>
> Add FIPS cryptographic algorithm self-tests for all SHA-1 and SHA-2
> algorithms.  Following the "Implementation Guidance for FIPS 140-3"
> document, to achieve this it's sufficient to just test a single test
> vector for each of HMAC-SHA1, HMAC-SHA256, and HMAC-SHA512.
>
> Just run these tests in the initcalls, following the example of e.g.
> crypto/kdf_sp800108.c.  Note that this should meet the FIPS self-test
> requirement even in the built-in case, given that the initcalls run
> before userspace, storage, network, etc. are accessible.
>
> This does not fix a regression, seeing as lib/ has had SHA-1 support
> since 2005 and SHA-256 support since 2018.  Neither ever had FIPS
> self-tests.  Moreover, fips=1 support has always been an unfinished
> feature upstream.  However, with lib/ now being used more widely, it's
> now seeing more scrutiny and people seem to want these now.
>
> Link: https://lore.kernel.org/linux-crypto/20250917184856.GA2560@quark/
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
