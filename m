Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2DC3FD955;
	Wed, 14 Oct 2026 20:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792010355; cv=none; b=dCMcD+6CjMYpTJMVZEly6dMGPtaoH2j4wKB5ZC5Nr491qMjmnh5xUTMInj5LsMfRaYdnGBkYm9c42kVuwEY/tO+KVFxp0a9JzFp2tkx9vJHlGt9Gtx6FygClRnlnznzxHmxvbG4gF+VB3ktGLijnHM5Q33RlEamteLK1asO4Z/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792010355; c=relaxed/simple;
	bh=COt3GvWqWgF0CxI9plDeQb5zlZ9CoK/iukULf+JUTd8=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=n1cC8gF7qjoM+IWgJ6BPM3j9fyxhRAQjqj3YFTTOlK0ALzkpkNqR6mYHCLJmeddaalhkga8HenPf54aypPO1rl+4Gi6DrRjgYoslOrsFfOe21MFO/NvpdPlwRVuTMkMQPZlAu06kBsBkG9cHfFdwQjDP0i8INnLuBlT+IRSox6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OnRqdUej; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OnRqdUej"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 590B4C2BCF5;
	Wed, 14 Oct 2026 20:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1792010355;
	bh=COt3GvWqWgF0CxI9plDeQb5zlZ9CoK/iukULf+JUTd8=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=OnRqdUeje8h7xcsJrIWm4dgO6n/hNW17viy2Nzy87dNFsiI1cfChmAmD6QpUXHsoa
	 dVkc6gsS4TwWl769C+MA+/BEiwfpBDHyi0UEOVpJonnKhiba2IReecOiP99qGOx143
	 VXUWaWoQL/HbYK5qmAra/jCe+o8bAWyC9rGJM2ijxxVG85Sw6JD/b/xnhDhIi6GbBE
	 lrjtUHy6150ZRU/fUJDrPPVMiXvCF5c3s+HHXYWKGfcH2Hea9rmtgWuvQhIWQ/RBlb
	 IolWh+E6AQgPx78DL3G7K8kEifqND/K5ev4X4X0ApDR+AfidJszsB5hPMHx/wjpUG+
	 f/sOXhS7hoMyQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34B74CC6B2D;
	Wed, 14 Oct 2026 20:39:15 +0000 (UTC)
From: Vladimir Kukharenko via B4 Relay <devnull+vladimir.genproof.com@kernel.org>
Subject: [PATCH 0/2] lib/crypto: chacha: Handle lengths of 2 GiB or more on
 32-bit arm and MIPS
Date: Wed, 14 Oct 2026 20:34:20 +0000
Message-Id: <20261014-libcrypto-chacha-32bit-2gib-v1-0-e0719ca0be89@genproof.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAE3nz2oC/zWN227CMBAFfyXyc428tpOQqKr4D8SDL2t3C0nAN
 qgV4t8xl0r7MtqjmSvLmAgzG5srS3ihTMtcAT4a5r7NHJGTr8ykkB0I0PxA1qW/Y1l4/dfjSlo
 qXEayvDUKW1SdER2wajgmDPT7tG93L85n+4OuPJTvRcLTuWbLa8YmzNk8s2Pz+V+FVnZCr5RUC
 gQHjpZixJQ3e0wzHlZLil8PnTUZuVumicrYaBF0HwwIAx4G1+ug1waUH3or0cLg22AHtfZsd7v
 dAVdR8MAIAQAA
X-Change-ID: 20261014-libcrypto-chacha-32bit-2gib-5a3e5e36a061
To: Eric Biggers <ebiggers@kernel.org>, 
 "Jason A. Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
 Vladimir Kukharenko <vladimir@genproof.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792010354; l=1694;
 i=vladimir@genproof.com; s=20261012; h=from:subject:message-id;
 bh=COt3GvWqWgF0CxI9plDeQb5zlZ9CoK/iukULf+JUTd8=;
 b=rnntLP2QYnFZTNLD0UoAJH+5N82xB9Y7wkvlKAyjJogo7+gLjT1eGgZHZSfqMxSU84345q47Q
 +cvgDd+YaR9DXMeWRNqIYZDj/OTr3obKCf6qGcBhKWqNd2UzOwlcVWW
X-Developer-Key: i=vladimir@genproof.com; a=ed25519;
 pk=EqOzBSKBgFn7ExzKj5f9T8u+1yTrGVlLBwf3fj/sdHM=
X-Endpoint-Received: by B4 Relay for vladimir@genproof.com/20261012 with
 auth_id=1169
X-Original-From: Vladimir Kukharenko <vladimir@genproof.com>
Reply-To: vladimir@genproof.com

On 32-bit arm (the scalar code) and 32-bit MIPS, the ChaCha assembly
treats the length as signed, so lengths of 2 GiB or more are still
mishandled after "lib/crypto: chacha: Use size_t length", since size_t
is 32 bits there.

Patch 1 makes the arm assembly use unsigned conditions.  The MIPS
assembly relies on the sign of the remaining length, so patch 2 instead
limits each call to 1 GiB from C.

This applies on top of
https://lore.kernel.org/r/20261014152604.323310-1-ebiggers@kernel.org
Feel free to fold these into your series instead.

Tested with the lib/crypto KUnit tests in QEMU on arm (Cortex-A7 and
Cortex-A15) and 32-bit MIPS, plus a temporary 2 GiB test on the
Cortex-A7 and QEMU user mode runs of the MIPS assembly.

An LLM review found these bugs; I used an LLM-based assistant to write
the patches and reviewed its work.

---
Vladimir Kukharenko (2):
      lib/crypto: arm/chacha: Handle lengths of 2 GiB or more in scalar code
      lib/crypto: mips/chacha: Handle lengths of 2 GiB or more

 lib/crypto/arm/chacha-scalar-core.S |  8 ++++----
 lib/crypto/arm/chacha.h             |  2 +-
 lib/crypto/mips/chacha-core.S       |  8 ++++----
 lib/crypto/mips/chacha.h            | 20 +++++++++++++++++++-
 4 files changed, 28 insertions(+), 10 deletions(-)
---
base-commit: 40f47fa10a1d19c74f48a13d97b2eb19d5fb938d
change-id: 20261014-libcrypto-chacha-32bit-2gib-5a3e5e36a061
prerequisite-message-id: <20261014152604.323310-1-ebiggers@kernel.org>
prerequisite-patch-id: f66d78884d3d0cf68e1efc9635c084c6b700352f
prerequisite-patch-id: 64c39ea52fe4e25501701ffa262fb3525af29f0b

Best regards,
--  
Vladimir Kukharenko <vladimir@genproof.com>


