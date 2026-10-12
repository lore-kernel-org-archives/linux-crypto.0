Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF1F3EB7FE
	for <linux-crypto@vger.kernel.org>; Mon, 12 Oct 2026 10:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791799371; cv=none; b=i+6Mzz3UzeytJxTmqJSLLmvEHnAS+xKh1G97wV6osNXW2PGLKE/O448rH7JHxf9IGHwhjO/P/teim8r1E2HwgH9h8lEB5X7kMmPjtvbhOg5p+6p7YXswN9meA81z4F2YnYjdpatJUholrWqrZCJk+H4mxTmfTRhXn0Y9sjdhiac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791799371; c=relaxed/simple;
	bh=ES57OMWDXrsoZJBL22fsLX3F+7rH3zkgExYA0woUnIw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TeR7zxp1o1etpyHrYKnix8zHz/n/pvs31Y3uWyPq5mzOwzRh5qsLGdr7i5oeWA2tSHNAv1EuGidN+bWxJZxVeVArwVtozZXy6zLyJkMn2YzabCCIFp/TjeABMNtKzxlbKHFzkiFH1sL46zHm5RBT2+unMzDA3XXIC9tfTeghYg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a/VNs1Ne; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a/VNs1Ne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E7D71F0089C
	for <linux-crypto@vger.kernel.org>; Mon, 12 Oct 2026 10:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791799369;
	bh=PKhmKSXxyWUzry2viDjAp4Mx8bpRIvQ5Zqqe6zrzPF0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=a/VNs1NeYjyKMwn9kbLuZjI1IKQs4uIlGh4FqC/Xkl4uoiP6OQPpDUaW0UEZwALyC
	 jGaRHzMslizX+jsPXLZK/ujQCWztMkDtcnO77+NztFc+uPF2U9TJlv0g1EEVqAkYDp
	 4sCnvKSUwHX4SzdAAlsIvhLeUlEKTLii/dl42BozTBzBJAMShNFQS15OvimlV98IE2
	 wrsuPDY1M+XHlEhCfbgyzUx4QD8f0A7hjRH7SGd26yYDkFbsob8yEg0hTp09jETJiH
	 2uafX+vrrARh8f5TAumUiSSXtVqDIhAvTW4xQ/il3m5MjCOvpCjcMjU6KbvCcMJs53
	 iK0jHu6WNY5XA==
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6ac76a02368so1502138a12.2
        for <linux-crypto@vger.kernel.org>; Mon, 12 Oct 2026 03:02:49 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByD4roaU+LKRDKd1HrEGgS4tmF3rxMIcSC1QvHFkVENoCYpGFKqXV+T6Kd+n7xaEkbuyVVQQ+6zQfdflqU=@vger.kernel.org
X-Gm-Message-State: AFq9FYLd1wWlEpsGCkXfvoj5B5Vxwj0yqnCdAeEUGKN3+/HZS7P/ucha
	1nQ3yUhEMbBH+OaYswqdiBQbnnw3a9XTLlsqQCTyTULy+IegMTPiZliDNCFjLh1xBw9IXlRMjGl
	4oo2capeAkAiY5w+FZClOIugbyrXvYQk=
X-Received: by 2002:a05:6402:21c3:b0:6a7:e514:1d85 with SMTP id
 4fb4d7f45d1cf-6b17c240894mr6498477a12.13.1791799367604; Mon, 12 Oct 2026
 03:02:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261011142930.492999-1-chenhuacai@loongson.cn>
 <20261011142930.492999-2-chenhuacai@loongson.cn> <20261011151243.GB168780@quark>
 <CAAhV-H4YwMFMQP1razrWDG=XKvBVyN64Hv0rKsA+TNN-4bt20g@mail.gmail.com> <20261012072417.GB828441@google.com>
In-Reply-To: <20261012072417.GB828441@google.com>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 12 Oct 2026 18:02:36 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5cy_k5VUKng72aQakoqZZEOSgx19kWRX0NqvB0TbBkiA@mail.gmail.com>
X-Gm-Features: AclHuK-osVE5SrXavzkNmgI4bhi9V5ZKPZItprDT3MVNovDl4jXtyb3JihNV8LM
Message-ID: <CAAhV-H5cy_k5VUKng72aQakoqZZEOSgx19kWRX0NqvB0TbBkiA@mail.gmail.com>
Subject: Re: [PATCH 2/2] lib/crc: loongarch: Add 3-way parallel CRC32(C) for
 large buffers
To: Eric Biggers <ebiggers@kernel.org>
Cc: Huacai Chen <chenhuacai@loongson.cn>, Ard Biesheuvel <ardb@kernel.org>, 
	linux-crypto@vger.kernel.org, WANG Xuerui <kernel@xen0n.name>, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Tianyang Zhang <zhangtianyang@loongson.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 12, 2026 at 3:24=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Mon, Oct 12, 2026 at 02:45:24PM +0800, Huacai Chen wrote:
> > Yes, crc_kunit is passed.
>
> Are you sure?  This patch reads 4096 bytes from a 4-byte buffer, which
> seems a bit problematic.
Yes, I'm sure --- but that doesn't mean I'm correct, probably because
there is a large block with 0.

Our old version used crc32_le_shift() and __crc32c_le_shift(), but
they are removed now. So we did the same change as commit
b6ccde39b1c1292ad44 ("gfs2: avoid inefficient use of
crc32_le_shift()"), but forgot to increase the zero buffer from 4 to
4096.

Huacai

>
> - Eric
