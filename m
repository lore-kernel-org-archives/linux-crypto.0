Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A950A30BF70
	for <linux-crypto@vger.kernel.org>; Fri, 11 Sep 2026 01:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789089354; cv=none; b=Q8QXwXWKHeYD0TY/MozdxpqDT7bp0oeBv73KMRGwJSWfRq1c1nXMuYLZWtz8SFa6j1LvHEzOJJGgRgUv9YNMjwWhvtPu1J1RblCQkeoJmKT/s4VZ47wkGTwkJS0aw/6c8vahbkwWa7kbxMkDfu+/Wj9Yi1p06Y86kOHfJbfl/RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789089354; c=relaxed/simple;
	bh=R3yS3RxdL5mSC4vxGS/erIRVpvD1oCJlWwlQFObGjfM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n2L6JzuvgxYZqeSlrdfPq2/RzArtXrST4Lp3ouiZ3fJwz7THBA/bnbzMMYsB2DWR3NDaqkps2P2Bt4AhbNbX+9+1F2X602kJPYvAUnOWP+Ev069wPHCVvmBGIlASd6oga2HQvYv/D+8ojYqiqFBXpXh7ERNfUhSShgCCtUwlWpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TZZBsz38; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TZZBsz38"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DAC91F008A0
	for <linux-crypto@vger.kernel.org>; Fri, 11 Sep 2026 01:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789089353;
	bh=R3yS3RxdL5mSC4vxGS/erIRVpvD1oCJlWwlQFObGjfM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=TZZBsz38GQfyZU2IntpDYKjIcXbtbAe+uA+9efc5ARz5qcMWPV7kMCMQ+8RLPD4jo
	 BBXEWvFszJWPSRRx1t7+dPX17PIJmJOCp3q/ZDf8L/g/T7sSgqYEIbxU3DSdpq40Ff
	 LOF+CjuGlB7VE0zcPhZnNxpARF3Gtz45HN54bkj0oIc90khVhQ7VZIqBav//NZj44d
	 7fK91AEO989wiSYSetABcGH+MwBAEvXqu+35bp//QDJDgBoLrsFDDQzDW7Rvglf2Yz
	 7/2S7tt8KRMlmHi/hzeLhZ4w9x2lIGYa+wPOwsO5LvBptLNAD8nqUTn/IaVkWugdxj
	 sr1RzSELb6lOw==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c2637dd37c1so58030866b.0
        for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 18:15:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBz4Et336X3AoumDpAaSPekbzSr3YcrxW9UvMPYysrYzwhpOFYeGu3dHArCKiohRNE5Grm5vXwi9GmTv4TY=@vger.kernel.org
X-Gm-Message-State: AFuF++n1JULjhncHKdd3x6gu/1g9UNzFHte9ccJjFnk5F8Il9HkShjEE
	n5qW5Je3N+yoBEkIHJzjO5G3s6+Lgy98gm3AeN8mYEChIYl3k5Xs38VNQ+fdGzW2SDVgzh1L1n+
	jNPkdOL3Za0rW76fCDE/FmirKZkMlkzc=
X-Received: by 2002:a17:906:478e:b0:c1f:29ce:76a1 with SMTP id
 a640c23a62f3a-c29665dc7e6mr60892766b.19.1789089351792; Thu, 10 Sep 2026
 18:15:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260910124138.417439-1-thuth@redhat.com> <20260910124138.417439-12-thuth@redhat.com>
In-Reply-To: <20260910124138.417439-12-thuth@redhat.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 11 Sep 2026 10:15:39 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-pugCqCMM98x1nv96G9Sp4pgix3jY0xoopeEEvcsN_mg@mail.gmail.com>
X-Gm-Features: AcwNN1W4pIBwXw4VALOF9HKB1o33_iwx5FdTl3CrHv3Ox9mSMYtz4o9TYHCXtyU
Message-ID: <CAKYAXd-pugCqCMM98x1nv96G9Sp4pgix3jY0xoopeEEvcsN_mg@mail.gmail.com>
Subject: Re: [PATCH v3 11/13] lib/crypto: sha2: Provide functions for
 zeroizing SHA2 hmac_sha* structures
To: Thomas Huth <thuth@redhat.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 10, 2026 at 9:52=E2=80=AFPM Thomas Huth <thuth@redhat.com> wrot=
e:
>
> In certain cases crypto code functions need to zeroize their local SHA2
> hmac_sha*_key or hmac_sha*_ctx structures after use to avoid leaking
> sensitive material on the stack.
> Provide hmac_sha*_zeroize_key() and hmac_sha*_zeroize_ctx() helper
> functions that can be used with __cleanup() to automatically zeroize
> the structure when it goes out of scope.
>
> Signed-off-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks.
