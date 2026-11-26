Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795685368;
	b=nYEDuXS3I2/DwWATa6rK40sBIt5b63Klc1T/UCyO+yEs40jcVwYoJ0XxToPfT7bm0P0R
	 rqvQvjZhv7dDBMGyMQ6CougUmdEC98FwO6MY6rka/BNRtWNgzVIfmJPtsS0t09Z+VdBAC
	 gUTE1ugtp0pQrpp1DPGU5NXkLASNonr330CDr7RLSFf/hIWXej9vW6TUdyJEUre2LTBHa
	 1vhn8KkEBg86jk76F+IaD/jGqHkQDBH16glgA5mMHkAvIu+YFl4ccuV1czqO6EHk5nP/2
	 guRhCnrFO5IQ5BHCP/o52EeVitMoQD81MAi4Y9YVI2Zijhoy9bkDhZaAfT5bNsFMyig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795685368;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=jTeza+k7YT6X/xvh365ftIBUgSoWvW7FELbwgf5TIzU=;
	b=P8tPtcsgS8Uz+d5mzP2NPsrtysBdZ7mtoxa22wE1E3YIAK3oEZAJ1/Irk0UGCECWTecH
	 Xzmvln0wz2ws2Cd0tNeLMoAiD8wbxYcQUJDwhByLv9Ts7at8Q6rlGLw1vpJXKuPqiOMFt
	 Pcx7qjaFeN3HQ99NXdPf9hISoGcmW9Do4c9In6k+NNHnIrzE17Ny2r3HO1DYA+rGrOHbd
	 SXH8d4smGoEPbfxofP7FqjHpdZYe9tjYZXg94T76jHYLzI1Vlq7ew0ZlyfGbdRgGK+wJA
	 evA6+Sd9yMQYzqQmMJGMEDa5HluAjmjmmG0QlJOPtJwnHePhFf2bxPSak25DdhfjTtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HtwkekYZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15CA2606A31C
	for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 09:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HtwkekYZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 187731F000C6;
	Thu, 26 Nov 2026 09:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795685367;
	bh=jTeza+k7YT6X/xvh365ftIBUgSoWvW7FELbwgf5TIzU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HtwkekYZ7TTk5ozzxJF0BMZDqUz611rxz7yOsK8FWTgs/6fdLfPyWygKegkRrVwmb
	 AYslc3VYRpkeoplTy0k8u7vfUUq1JtuUZkmax54jJ/ubpTYNPZZf1NGbbxwVFFvq4C
	 +lzYXzQJT3BU5K+wE7wlhQeWbn3QR46ghU3YhKdSdeto13vyXnM7RlQUu0oj6iy5mK
	 a/dBXlEX/s54hqXZPdG3kMksKwtwnLVIfhQWXqy3P9kR+M9Nf6FMutiEESfhBLBirb
	 5n5pvmdA3H1I7G1RBdkmTXqT/W6xaFxTcJu/6R8Mrp3zyV+EQSdl8CwcQodYS/7MkT
	 F8kqCn/aj248A==
Message-ID: <sashiko-outbox-235136@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] crypto: ccp - Do not hand a short INIT_EX file to the
 firmware
Reply-To: sashiko-reviews@lists.linux.dev
To: "Gokul K" <gokul02k@gmail.com>, "Ashish Kalra" <ashish.kalra@amd.com>, "Tom
 Lendacky" <thomas.lendacky@amd.com>, "John Allen" <john.allen@amd.com>, "Herbert
 Xu" <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org
Cc: "Sean Christopherson" <seanjc@google.com>, "David Rientjes" <rientjes@google.com>, "Peter
 Gonda" <pgonda@google.com>, "Atish Patra" <atishp@meta.com>
In-Reply-To: <20261126092001.2099312-1-gokul02k@gmail.com>
References: <20261126092001.2099312-1-gokul02k@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 09:29:26 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] crypto: ccp: inaccurate Fixes trailer for
  sev_read_init_ex_file() short read
--

commit c74101dd406e137499f025e32571e23c036489af
Author: Gokul K <gokul02k@gmail.com>

> crypto: ccp - Do not hand a short INIT_EX file to the firmware
>
> sev_read_init_ex_file() reads the INIT_EX non-volatile state from
> init_ex_path into sev_init_ex_buffer. When the read returns anything other
> than NV_LENGTH it logs the fact and then returns 0, so the caller carries
> on and __sev_init_ex_locked() passes the buffer to the PSP as the
> platform's saved state.
>
> For a truncated file that buffer holds a prefix of the old contents
> followed by the zeroes the page was allocated with, which is not a state
> the firmware ever wrote. A negative return from kernel_read() is treated
> the same way, and then the buffer holds nothing but zeroes while the code
> still reports success.
>
> This is not what the interface promises. Documentation/virt/kvm/x86/
> amd-memory-encryption.rst says of init_ex_path:
>
>   If the file specified by ``init_ex_path`` does not exist or is invalid,
>   the OS will create or override the file with PSP non-volatile storage.
>
> A file that cannot be read in full is invalid, so discard what was read
> and let INIT_EX run from a zeroed buffer, exactly as it does when the file
> does not exist yet. The firmware then repopulates the buffer and
> sev_write_init_ex_file_if_required() writes it back, which is the
> "override" half of the documented behavior.
>
> Doing this for a negative kernel_read() return means a transient read
> error costs the platform its persisted state rather than failing the
> init. That is the deliberate trade: the documented contract allows the
> file to be overridden, and feeding the firmware a buffer it did not write
> is worse than starting over.
>
> This was found while looking at the INIT_EX failure reported by Sean
> Christopherson, where an interrupted writeback leaves the platform
> unusable. It addresses only the case of a file that is short or unreadable
> on the next init. An interrupted write leaves a full-length file holding a
> mix of old and new bytes, which a length check cannot detect, so the
> reported failure is not fully fixed by this patch.
>
> Fixes: 3d725965f836 ("crypto: ccp - Add SEV_INIT_EX support")
> Reported-by: Sean Christopherson <seanjc@google.com>
> Closes: https://lore.kernel.org/all/abSWm4wyY91I4zf8@google.com/
> Signed-off-by: Gokul K <gokul02k@gmail.com>

[Severity: Low]
In commit 3d725965f836 ("crypto: ccp - Add SEV_INIT_EX support"),
sev_read_init_ex_file() returned -EIO when kernel_read() did not return
NV_LENGTH, so __sev_init_ex_locked() aborted before issuing
SEV_CMD_INIT_EX to the firmware.

Returning 0 on a short or failed read while leaving partial contents in
sev_init_ex_buffer was introduced by commit d8da2da21fdb ("crypto: ccp -
Initialize PSP when reading psp data file failed"). Should the Fixes: tag
cite that commit instead:

  Fixes: d8da2da21fdb ("crypto: ccp - Initialize PSP when reading psp data =
file failed")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126092001.2099=
312-1-gokul02k@gmail.com?part=3D1
