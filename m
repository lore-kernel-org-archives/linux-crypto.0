Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185131F09A8;
	Mon,  4 May 2026 04:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777870286; cv=none; b=Bnox+vbfMXs0SOYANXrTBcw8DPjhxZ8XTM/fY7O0DDiVtXsMOtrSBVY4GBpvLgeZDGzUpjITTcNe6GdEByxIJJIURfErbjydJTT079+R6izZtExIV9K9Yyk7BINea6xByXP4zBAKaIjVS8CWRZ/RikYr5jk9r2s0WNyMob7sxuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777870286; c=relaxed/simple;
	bh=k6XkXAL6L8ebKx5VD9yfExfJc70tbEmaMZGfO5R9Sjk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Y1WAx4YV9X2bQgF8DA5qMp22rcMMifKE3ytW4iZpsY01lIeiN/ZgpAdPVnR6aZiu8ZL+WhSewkCDuSLtgnyws58Ol25ugspxk0eL4DrkJFqsm79MNwIL562OTi0fXStw+i8NJyN9u1YH7OQOWB2ZKwpmNHsQLtO3pQ4DtUuMjVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OwDkWzDM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OwDkWzDM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CFA7C2BCB8;
	Mon,  4 May 2026 04:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777870285;
	bh=k6XkXAL6L8ebKx5VD9yfExfJc70tbEmaMZGfO5R9Sjk=;
	h=Date:From:To:Cc:Subject:From;
	b=OwDkWzDMlwoi58m2tO81DxeX99LHaOuXhABsbdiIAticFtTiSIDfAUQ+9+y8OI8xZ
	 vbKZ2acPexlZbA42GpibuOoGe0fjUNUuwZIa2VIABLqUpsUzwGD4Z426TjnI98AAI+
	 DADSw1wLsmwaTUt9G8fl0usj7T7ZR3V3KdTAnWqEmz1UOiinY48tgsSDAhbnpOwL+a
	 SAmvaHb5XXN7IXPZgUJfvdnvwyBc17qE9+K0CrKkTaMotEaSvFIlrzlYovefgVJ3uZ
	 fp7H1qqIfP3r3EZJqn+xlVgfMpe6kaqaZH0OjCXvMGlMdzm8LmzrtLlN0h0EaveG15
	 zaDx1kdONCC4A==
Date: Sun, 3 May 2026 21:50:07 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: iwd@lists.linux.dev, Marcel Holtmann <marcel@holtmann.org>,
	James Prestwood <prestwoj@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Demi Marie Obenour <demiobenour@gmail.com>
Subject: Complete list of AF_ALG algorithms used by iwd
Message-ID: <20260504045007.GA2289@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

With AF_ALG being on its way out due to its frequent vulnerabilities,
iwd will need to be fixed to follow the standard practice of using
userspace crypto code (for example, libcrypto) instead.  In the mean
time, AF_ALG is at least going to need to be hardened by removing
unnecessary functionality, for example unnecessary algorithms.

Based on the iwd and libell source code, it appears iwd is relying on
the following algorithm names from AF_ALG.  Please confirm that this
list is correct and that these are the ones we need to keep for iwd:

    cmac(aes)
    hmac(md5)
    hmac(sha1)
    hmac(sha224)
    hmac(sha256)
    hmac(sha384)
    hmac(sha512)
    md4
    md5
    sha1
    sha224
    sha256
    sha384
    sha512
    ecb(aes)
    cbc(aes)
    ctr(aes)
    ecb(des)
    cbc(des)
    cbc(des3_ede)

Also, does iwd always hold CAP_NET_ADMIN?  We're also considering adding
a privilege check to AF_ALG.  (It's TBD whether it would be
unconditional or controlled by a sysctl.)

- Eric
