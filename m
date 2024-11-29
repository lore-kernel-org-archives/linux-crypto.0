Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DA01B95B;
	Fri, 29 Nov 2024 16:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732897017; cv=none; b=k/0plpfs4Lk4XfNSukRMkqOrl5sL/vkOQq7rsk7mdLxscP25wRk8EelGvfXpFRbSSuP+T+yWAhSr1H8LEBy+jEDwoDKuQNaCdV60p1+1wnpCVU5hDxFjmn2Y8zamHYioYXkXdx/otcqPe0E+eP+2OaScn7CRUyeIwKqEQOJmujM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732897017; c=relaxed/simple;
	bh=YDnw7vhkaJAuUXfPbYeU6lVbCicKP6s6NAPiGggiTN0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SNBBt6hKpQ6q3fz0YFfdTpU3oU/DJMOEnTAjbiRhCixNiVGYVwNXH0Gt1TQVKOF/5UTcehnIstP8+28a6eShKe8DgAM+uDyljYXH2q8lJqFr4uzuTLQmxaJezN517tyu7bNEVS2OMnJB1dBzn/eKZy1k1mnQmSzQKu49L68Pc5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EpnIhCuj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EpnIhCuj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1603BC4CECF;
	Fri, 29 Nov 2024 16:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732897016;
	bh=YDnw7vhkaJAuUXfPbYeU6lVbCicKP6s6NAPiGggiTN0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=EpnIhCujLTETC/sjIDlyXc2ImoUzbqLJnhGewOt8JJZCWT7l2uXBUXhxb+quO08FW
	 uN+9llytzHm3TA/GZ5dkYjxKPesLirqPExRlbsyiQ5NCnG+op+ahMU0lC9DXiWOhS1
	 qumSEl923QAwicK00scDv3kNvEQ7Ai6Ly+sv2W/EOQIx6nj2zeHNz8XJDX4niHJyRG
	 wV//L/8sRDZpiWLE/8Ne0Wv27cTKH+sFcgYUCWhNqkj5RpVaGopLCuQsFf8Bu/4cuW
	 oNRwuSMQABTpzzYq2OZJcd4WTNYbdOv2nQgQA36+zZZcJmZTxDyJJzYnHja9+5WFh/
	 ljX7io+RZ5SvA==
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-53de5ec22adso2603584e87.3;
        Fri, 29 Nov 2024 08:16:56 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXKwPCjiNbioOJTUIwZBqOFfHEVGTqeT7MrLhOKO5DDp5+b0oxe+lZXwDJA185VsdwtY7BGpeZaZI4NsEU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQWWirEN+5FE+SGe/Q1539DNVJG/yBvjgSdQ8e8F2n27HMIeVH
	G7iOqNe0vhL9PCUU0p+xY2xcWRKTlchnMYYTQ1a4OtxpPq70L966H/2lNurW5dQ/B9tdnPyKx51
	MmKIGko63DFmo6sBBid/t3d5QB88=
X-Google-Smtp-Source: AGHT+IGErHUY7cr9BfVuAMx9rKVS+ddSGGA3Z630K06yUd7VA5OKmJogaNZfNPqMKSaMYyDVMEOTxBPHY3komw7MEE4=
X-Received: by 2002:a19:2d0a:0:b0:53d:f4af:6fea with SMTP id
 2adb3069b0e04-53df4af70dcmr4799168e87.4.1732897014342; Fri, 29 Nov 2024
 08:16:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241125041129.192999-1-ebiggers@kernel.org>
In-Reply-To: <20241125041129.192999-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 29 Nov 2024 17:16:42 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHPXS3r244jABjOKTEWaqWX2TYf-KA9i+J2-C3B4XxmUQ@mail.gmail.com>
Message-ID: <CAMj1kXHPXS3r244jABjOKTEWaqWX2TYf-KA9i+J2-C3B4XxmUQ@mail.gmail.com>
Subject: Re: [PATCH 0/6] x86: new optimized CRC functions, with VPCLMULQDQ support
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 25 Nov 2024 at 05:12, Eric Biggers <ebiggers@kernel.org> wrote:
>
> This patchset is also available in git via:
>
>     git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git crc-x86-v1
>
> This patchset applies on top of my other recent CRC patchsets
> https://lore.kernel.org/r/20241103223154.136127-1-ebiggers@kernel.org/ and
> https://lore.kernel.org/r/20241117002244.105200-1-ebiggers@kernel.org/ .
> Consider it a preview for what may be coming next, as my priority is
> getting those two other patchsets merged first.
>
> This patchset adds a new assembly macro that expands into the body of a
> CRC function for x86 for the specified number of bits, bit order, vector
> length, and AVX level.  There's also a new script that generates the
> constants needed by this function, given a CRC generator polynomial.
>
> This approach allows easily wiring up an x86-optimized implementation of
> any variant of CRC-8, CRC-16, CRC-32, or CRC-64, including full support
> for VPCLMULQDQ.  On long messages the resulting functions are up to 4x
> faster than the existing PCLMULQDQ optimized functions when they exist,
> or up to 29x faster than the existing table-based functions.
>
> This patchset starts by wiring up the new macro for crc32_le,
> crc_t10dif, and crc32_be.  Later I'd also like to wire up crc64_be and
> crc64_rocksoft, once the design of the library functions for those has
> been fixed to be like what I'm doing for crc32* and crc_t10dif.
>
> A similar approach of sharing code between CRC variants, and vector
> lengths when applicable, should work for other architectures.  The CRC
> constant generation script should be mostly reusable.
>
> Eric Biggers (6):
>   x86: move zmm exclusion list into CPU feature flag
>   scripts/crc: add gen-crc-consts.py
>   x86/crc: add "template" for [V]PCLMULQDQ based CRC functions
>   x86/crc32: implement crc32_le using new template
>   x86/crc-t10dif: implement crc_t10dif using new template
>   x86/crc32: implement crc32_be using new template
>

Good stuff!

Acked-by: Ard Biesheuvel <ardb@kernel.org>

Would indeed be nice to get CRC-64 implemented this way as well, so we
can use it on both x86 and arm64.
