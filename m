Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714191990D8;
	Mon, 21 Jul 2025 03:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753068868; cv=none; b=Hc/miEbRFT8nHYg696S7br7zppnvSpzDqguvBiWHTYgxIa89g+zV+u0OpTYJqqajHR92smZ4f3T9f7BA6DcLQYhJ4eeRVVzmGqxqvpvGzZqmspIoc2kqWKJiRJKs3mtuuUgo7ySZEGtj2PBlxnZ27nKcUy7EwCNUXyZA8KzYPBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753068868; c=relaxed/simple;
	bh=tpELBclwEmJ22iG/Z5ffCAPqTEySsrvLKNuPh21Hbi8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PRTNBsKOoo0+zQwEi6/PxvYJNx+DfMVnkXvIulETvc8Cd8lPqnAE22wcnNq+BEUDGoY+F5EpMFmvxQLVnFp9M6+gnx0PS21APRp3aSbnrMSH4BbsFVlJrORXDRgkLelpHT26imNf3iL4+X9xb4ZZR1c397R0+++QcNmTf/7EaOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M7mPxuk1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M7mPxuk1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19627C4CEF1;
	Mon, 21 Jul 2025 03:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753068868;
	bh=tpELBclwEmJ22iG/Z5ffCAPqTEySsrvLKNuPh21Hbi8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=M7mPxuk13QtF4vXag3nWt4HJvz9PCfUkRSUBW7+Vn/fwYF3cg9azdK06bj+RKC5zy
	 Hg0bNIs/X08tLK9WXYyLT0ya+Mc5GmsN/RpEtX8WTYh+MpmKpdkgftfq/k5EaDUF8d
	 JUBDsIUkf4EbhMvd7T0x8JynERvCU2S8qnjrC9tWAZWDFLYf31GygS9XFRTIp9OeMh
	 LsV5L+EErtn1/Q8RKp8P1QyErmlIgPnX3dqWoL07IC9+EdzBKcGp3L7zmEQ3KBo79s
	 VhqJnhRr+ov+lnuago+4Qf8Dx4ohYLjJLDoYksLQrOK3Ym/sycbKXtYhXfNqf47HJW
	 fKygDQBjdGT9Q==
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-558fa0b2cc8so3056464e87.1;
        Sun, 20 Jul 2025 20:34:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXe+FwJ4G2UsBk7qx02Ouq7rcnch3GmCLdlC1xe2ILuzcPpB3jjLxA3ETjWqFJJyWMfWTzfREGPW/RW6Ug=@vger.kernel.org
X-Gm-Message-State: AOJu0YxI4yoy5JxddZxjVbwcbPHnIEnGW3rWz+RqcW4aX9D+wBOipzxP
	SS57fJa7+I3OrebHBKgKSFAlxoRCIdWmhCR0badA4k1TDl94OydgQK+kP7h7eGP1XG5OPNataGg
	BK7sv3QTcEMoQNFjEQ35zn3CN6oeV0Lo=
X-Google-Smtp-Source: AGHT+IGNKwO8zZpursUf/gmpJi4HJsf4H8BmQYYQyrlZmBXCWJoLWveSmC/Z5Btk11n9vE4NoKM48n7W3IAd1hdBpo4=
X-Received: by 2002:a05:6512:3e1e:b0:553:d8ca:4fcb with SMTP id
 2adb3069b0e04-55a23ef5b6dmr4710554e87.21.1753068866460; Sun, 20 Jul 2025
 20:34:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250719224938.126512-1-ebiggers@kernel.org>
In-Reply-To: <20250719224938.126512-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 21 Jul 2025 13:34:09 +1000
X-Gmail-Original-Message-ID: <CAMj1kXFExADZiBw6t-8yoRankXXuP9sbh6v3UvMcRSH2gKWELQ@mail.gmail.com>
X-Gm-Features: Ac12FXwwhcNDST5GNCnmbeLOZ5mYfsHaG1y7b6xxjCQHOvBI9-7gYlKW3HHYo_g
Message-ID: <CAMj1kXFExADZiBw6t-8yoRankXXuP9sbh6v3UvMcRSH2gKWELQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] Improve crc32c() performance on newer x86_64 CPUs
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 20 Jul 2025 at 08:50, Eric Biggers <ebiggers@kernel.org> wrote:
>
> This series improves crc32c() performance on lengths >= 512 bytes on
> newer x86_64 CPUs by enabling the VPCLMULQDQ (vector carryless
> multiplication) optimized CRC code.
>
> This series targets crc-next.
>
> Eric Biggers (2):
>   lib/crc: x86: Reorganize crc-pclmul static_call initialization
>   lib/crc: x86/crc32c: Enable VPCLMULQDQ optimization where beneficial
>

Acked-by: Ard Biesheuvel <ardb@kernel.org>
