Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3896115E5D4;
	Thu, 31 Jul 2025 19:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753990044; cv=none; b=Dl+1mQnFERrek8qS43MJsxL2SF2vnp3H4VEJWKZknlhIvsIZAYy6W7A/dKVxB2VOw9EwmtwDrsdcxKACK4ICs0ebmKgV9MtnDYAB2iH+L7hbv6Tr/rOij2ANt1f1QCBO0q8vyr2zIOga+C/8zmqM0VXvGIyPz8ZGyPqyR1tjyXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753990044; c=relaxed/simple;
	bh=Edb0Yx43f8y8puSiprUt8OUSHZGwnjbuJAP3ut+p2ko=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lyG78rXGTkJayEBirAIvkOtvyMSIs9rgG5ev2WTllwUSkOGw+8ZyzPhCBSg408xA3eiJQxpEibGRxjpxvaDM5PrvltG7HcdHpYfN+dSy1XBrqoSQmJaT5exiQT2elmbxFdYqN82H3orz5+ZDkXBI60tGZw1AaVCIscw7lS8cGeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PCWbNMcP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PCWbNMcP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4176BC4CEEF;
	Thu, 31 Jul 2025 19:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753990043;
	bh=Edb0Yx43f8y8puSiprUt8OUSHZGwnjbuJAP3ut+p2ko=;
	h=From:To:Cc:Subject:Date:From;
	b=PCWbNMcPXGe1GNcL3rznBg1jUtZRuMpiaU8AoOG3tnuYUtPlc9JeAXplX40fVm8fa
	 otv01LHmgW5p7rYRezV/RmkC+wfoavA1gDl4BBnVMW4mNcTRNX5Ajmpds9OB+PGUzk
	 ExYh9ZzPpusXqry7YONO65O6XO6k6bioIvFCi/pZqmhe26KABxREIEWl3Ob/UfPX6X
	 WKrdrCBUBTT7xks1eE0cSU0xKoQlCTIv+GFZJEVN+6OTQzeaECrNKywsfXs2HYMz62
	 /6HlnmUpkMSaMn0jr0jTT6KDIAcQog1kwY3LS5T2h7tJfF/zSaOg1udEXehVsZSVse
	 7/kzLlr2+1Wzw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-usb@vger.kernel.org,
	Andreas Noever <andreas.noever@gmail.com>,
	Michael Jamet <michael.jamet@intel.com>,
	Mika Westerberg <westeri@kernel.org>,
	Yehezkel Bernat <YehezkelShB@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/2] thunderbolt: HMAC fix and cleanup
Date: Thu, 31 Jul 2025 12:25:43 -0700
Message-ID: <20250731192545.29869-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Patch 1 fixes the HMAC comparison in the thunderbolt driver to be
constant-time.

Patch 2 simplifies the HMAC computation in the thunderbolt driver by
using the library API instead of crypto_shash.  Note that this depends
on the HMAC-SHA256 library API that was merged for v6.17-rc1.

Eric Biggers (2):
  thunderbolt: Compare HMAC values in constant time
  thunderbolt: Use HMAC-SHA256 library instead of crypto_shash

 drivers/thunderbolt/Kconfig  |  4 ++--
 drivers/thunderbolt/domain.c | 45 ++++++------------------------------
 2 files changed, 9 insertions(+), 40 deletions(-)


base-commit: d6084bb815c453de27af8071a23163a711586a6c
-- 
2.50.1

