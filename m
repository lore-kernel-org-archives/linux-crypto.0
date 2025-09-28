Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C8B2D8383
	for <linux-crypto@vger.kernel.org>; Sun, 28 Sep 2025 11:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759059506; cv=none; b=PUZG54uhIFz4ykzyIfiJjZqi4Wpbtf7cwtUR5K1rqcNxr6zNkogQUIvo7SN4+CYmMTAfVGOzwUJY2s6rbEo2JrI9Qc3cZZESK6Pee1Ef+H3Cy5PPGWA+lJqKTWrijcwA2WvsIGToeSSkERRZijftecLkmcLvmX01uOE8y3C9saE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759059506; c=relaxed/simple;
	bh=UWXHyb5fW71etsDBlaN+K6xYk233c3qY+BvulNc09+4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AC22fO5I/gFz2bcHOH/75ZTVwWS67HSPRA80lTSXChxmeBJTIaMmAPs2O0CzMeXPSy5HETcG1tdxkXW94clfOLxdknOX7K3uUseRtE4IR917+97S0V+Yo9ZXX++A0frQ7+Im0sNIPQ3wqcNYvzjtKOSEgVIrVVx73t5e6ALHuHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cfhu+Yut; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cfhu+Yut"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3ef166e625aso2965554f8f.2
        for <linux-crypto@vger.kernel.org>; Sun, 28 Sep 2025 04:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759059503; x=1759664303; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tJbyj7CTQs5Hq3X4BmLYSl2wXTOQJPC2yJvcoDb8Pu4=;
        b=Cfhu+Yutuv1ICa97DiNeOzS2vaPrMPW/auYyWlEbTAzElnCJt4G2BAZIklUFWFYbVT
         pDDpZ2rvNjjpxoKa/y0wzj8ns6EF1d6PQR1PInZZyOl8uEIjRUEKzhcB60jYGnqL1QNW
         aD/nca4TgnCkYcs7PyjlMjljygHsIP6o/zprPPWSnaOMxulG5wokAx6ek44MPJRClYEb
         augi6R34xWP/XxpKfLOS9aQL5AWYgfCipc7gHPSZEOtZVi23wn6ZKds9a8qHU+WRVJZc
         7HCCDXU7gRL7dF+PzoDbycOgXdePrt0ywMiiJzrCJaXE+nla6ZuNv4fDeT6vspf6JNLu
         s5/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759059503; x=1759664303;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tJbyj7CTQs5Hq3X4BmLYSl2wXTOQJPC2yJvcoDb8Pu4=;
        b=KuU1Wxx00egLZpmsnaStUJCIykvxOU+fozJv4yBawt9Pq4UZX4nUeDjfv8hPY5GYoD
         Q3yo72lsYlHKuzsYV9E4XBudcCXM95lOG9vH6XwB/lOd3jZdJImkXgZl4gtyEG7p2cKA
         /Tj7v7mMs6CSOBzJGhdYjPkQdl7BJiTXcjoCLlKxCNlfyDVUsKd3zth7wjjOGqjlVsPr
         GNFeFibODvW74FkQfVcgL0eLTp3wnvVeYX0YqMpFqJjeEr2p5QVsSjOdM6noIHxYxLI7
         eR5K4NDnKaDHUFctsaQKuMs7eyfgfEmUELcf0OQvF93lhVIpqIzrQWHnYiHFhdbiBGWT
         7efw==
X-Forwarded-Encrypted: i=1; AJvYcCUvJ4Ob8eQ2DRYHPsQMnIzx7KmAtux1ygA9vy0U4MuOtQpq8MpDUCwaGH6y1yhdGxLKarTjMkdV65Izls8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzW+Yryfy5EEOfsYOL7pTfpgimRKG+BoGZrx0f17JcQZbdkpF3O
	WzCBtq/U5aaKU2AwbCfoZ20qUHB0c2r4TWea0FTbNYuAK+Prp6RjJ/PJNXIIPZD/JlSDUwQFGAn
	CEPj44zIrQQp3h4WY+wv98rh5apmfLVA=
X-Gm-Gg: ASbGncsY4+se4PXwxolXuqlPGytP726bqw57KBhlGu31w1IDoVYinjRQwA/pTUE2Lp2
	YFW2qfnpBD9hWNvyty0bNJ6k7hSy4CnfyDSXGdPRb3yP/hubFsou6CszUWMA8FXxlMgw/7aKAVV
	Rkr7tdBuY+RUGSA809/AJ5hrQOmnm3Nvn9OQYoEIfHKkJhKSejZD96cyDZ8G/aGA3NMRBZ2R2g/
	IJI5LphrEjBmVK8
X-Google-Smtp-Source: AGHT+IG5gTtwFXeUzvsJ2VqaPa0CMNS4HK3Y/UagjYN3qOQg/bakMLvXYWHNxz7sZTKthRY+L6R5rDP6tc8yoc8r0do=
X-Received: by 2002:a05:6000:2005:b0:3ee:d165:2edd with SMTP id
 ffacd0b85a97d-40e4b666ffcmr12929230f8f.28.1759059503066; Sun, 28 Sep 2025
 04:38:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250928003833.138407-1-ebiggers@kernel.org>
In-Reply-To: <20250928003833.138407-1-ebiggers@kernel.org>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Sun, 28 Sep 2025 12:38:11 +0100
X-Gm-Features: AS18NWDF4pVhW0K0jrrRfv67o0OX71OOEMAIVbexLs8vE527XzYFys8Sg4We4Xg
Message-ID: <CAADnVQ+ukRuU74ZY=c0RNhJ1ETDj6F4gcBPCS9jDFRnAivgTKA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: Don't use AF_ALG for SHA-256
To: Eric Biggers <ebiggers@kernel.org>
Cc: bpf <bpf@vger.kernel.org>, Andrii Nakryiko <andrii@kernel.org>, 
	Eduard Zingerman <eddyz87@gmail.com>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, John Fastabend <john.fastabend@gmail.com>, 
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, Hao Luo <haoluo@google.com>, 
	Jiri Olsa <jolsa@kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 28, 2025 at 1:39=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> Reimplement libbpf_sha256() using some basic SHA-256 C code.  This
> eliminates the newly-added dependency on AF_ALG, which is a problematic
> UAPI that is not supported by all kernels.
>
> Make libbpf_sha256() return void, since it can no longer fail.  This
> simplifies some callers.  Also drop the unnecessary 'sha_out_sz'
> parameter.  Finally, also fix the typo in "compute_sha_udpate_offsets".
>
> Tested by uncommenting the included test code and running
> 'make -C tools/bpf/bpftool', which causes the test to be executed.
>
> Fixes: c297fe3e9f99 ("libbpf: Implement SHA256 internal helper")
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>
> Let me know if there's some way I should wire up the test.  But libbpf
> doesn't seem to have an internal test suite.

It does.

> +
> +#if 0 /* To test libbpf_sha256(), uncomment this.  Requires -lcrypto. */
> +#include <openssl/sha.h>
> +
> +/* Test libbpf_sha256() for all lengths from 0 to 4096 bytes inclusively=
. */
> +static void __attribute__((constructor)) test_libbpf_sha256(void)

Dropped this bit and applied.
Please follow up with a test similar to
tools/testing/selftests/bpf/prog_tests/btf_field_iter.c
There are quite a few tests there that exercise libbpf_internal.h
