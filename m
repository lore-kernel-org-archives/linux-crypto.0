Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECE820DD71
	for <linux-crypto@vger.kernel.org>; Tue,  4 Feb 2025 13:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738674866; cv=none; b=lJwHntBzcKBHI0anweRz14Y2e8W0rUTFyoCcl6Z9NG+5O+lqkVd+AoZNIB0WgPDZIZNUQerSMBzucjYoCY1hZ9X6saz/59QpOKLNww4otbtXNawnZtbzrbaiYLVspA8ohD6Ib560fECyOwsvf4gXElRtURYz9IqHic+6AaFuzfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738674866; c=relaxed/simple;
	bh=sbChlCM5bLRd+p7rE7ABNpyo6f8eQeBuxvwx8M7mZYM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bS4cS26GJbHNI9qc57wFoXkUg8ofdiSf4/x0qgjXpq3SHh6nNiSAWj4T7+UIsLbtJKvN7jYjIZ7A2ZgZ4MPZnPjEhazDaLIQ6iS91hLZcLERBJg/MFLX8qxfWTPUGBI7z9WuYrPvryGv2aR7Qcorq7LxRvpFDp9vcVQ3MSxh3kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MV1HiJSv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MV1HiJSv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AB62C4CEDF;
	Tue,  4 Feb 2025 13:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738674866;
	bh=sbChlCM5bLRd+p7rE7ABNpyo6f8eQeBuxvwx8M7mZYM=;
	h=From:To:Cc:Subject:Date:From;
	b=MV1HiJSvwqd/OzZfUB2wbELoBiQkFXilHtChOkoJciTjyTrOK201Mpc/0RogDgTK+
	 G+NqJIEDKrqJjBcQXcUlV9mdo/XOGIrAwHcWcGCZA51uzJ6VKkIAww2cvHb6n146PD
	 xuYvamrogK3Hd7NH9CsKeuCut+eUD8oLivaJFrTblMGRrnexj0lTLVeBPQ4qvJC0yB
	 m3+pdxCOf52BYdru+bP5l+EgwSVKiEFhnzo3OhFwDlq3+mOlGx7eMWIOwpt89O7aPl
	 uzwn41MHDcHHuS0lj9CHJajpISHFCCSvEAE5PT3+JzjwKjeGcRKiqIh5L5Ra9q4v2j
	 zgH7pNMtBhhoA==
From: =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>,
	soc@kernel.org
Cc: arm@kernel.org,
	Andy Shevchenko <andy@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 0/5] Turris ECDSA signatures via keyctl()
Date: Tue,  4 Feb 2025 14:14:10 +0100
Message-ID: <20250204131415.27014-1-kabel@kernel.org>
X-Mailer: git-send-email 2.45.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Arnd et al.,

this series adds support for generating ECDSA signatures with hardware
stored private key on Turris Omnia and Turris MOX.

This ability is exposed via the keyctl() syscall.

Patch 1 does a small refactor in the turris-omnia-mcu driver - a piece
of code is moved to a separate function so that it can be reused in
patch 3.

Patch 2 adds a new helper module turris-signing-key, which helps
exposing the signing ability via the keyctl() syscall.

Patch 3 adds the functionality into the turris-omnia-mcu driver.

Patch 4 removes the old debugfs implementation of this functionality
from turris-mox-rwtm driver. The debugfs implementation was intended
to be temporary until a better userspace interface was introduced.

Patch 5 adds the functionality into the turris-mox-rwtm driver.

Marek

Marek Behún (5):
  platform: cznic: turris-omnia-mcu: Refactor requesting MCU interrupt
  platform: cznic: Add keyctl helpers for Turris platform
  platform: cznic: turris-omnia-mcu: Add support for digital message
    signing with HW private key
  firmware: turris-mox-rwtm: Drop ECDSA signatures via debugfs
  firmware: turris-mox-rwtm: Add support for ECDSA signatures with HW
    private key

 .../ABI/testing/debugfs-turris-mox-rwtm       |  14 -
 .../testing/sysfs-firmware-turris-mox-rwtm    |   9 -
 MAINTAINERS                                   |   1 +
 drivers/firmware/Kconfig                      |  17 ++
 drivers/firmware/turris-mox-rwtm.c            | 260 +++++++++---------
 drivers/platform/cznic/Kconfig                |  17 ++
 drivers/platform/cznic/Makefile               |   3 +
 .../platform/cznic/turris-omnia-mcu-base.c    |   4 +
 .../platform/cznic/turris-omnia-mcu-gpio.c    |  21 +-
 .../platform/cznic/turris-omnia-mcu-keyctl.c  | 162 +++++++++++
 .../platform/cznic/turris-omnia-mcu-trng.c    |  17 +-
 drivers/platform/cznic/turris-omnia-mcu.h     |  33 ++-
 drivers/platform/cznic/turris-signing-key.c   | 192 +++++++++++++
 include/linux/turris-signing-key.h            |  33 +++
 14 files changed, 608 insertions(+), 175 deletions(-)
 delete mode 100644 Documentation/ABI/testing/debugfs-turris-mox-rwtm
 create mode 100644 drivers/platform/cznic/turris-omnia-mcu-keyctl.c
 create mode 100644 drivers/platform/cznic/turris-signing-key.c
 create mode 100644 include/linux/turris-signing-key.h

-- 
2.45.3

