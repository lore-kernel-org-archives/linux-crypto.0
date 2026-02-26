Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527563D5225;
	Thu, 26 Feb 2026 14:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772117174; cv=none; b=cDhr48nQReRQb0zmZYS4gS6NNrk/i8DuWhc4XouvwwnTsPmEWjiJEpFUEyFSvaciMFHfzyJkYAJME/GuI3jIRifEFey6F1QMsy0HCGMVhTPz3dVjHHm+/ogPwyD57Qng4bg7G4jEZqG3LeD46GZena1UIfAlC8s1QF7tIRtfD+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772117174; c=relaxed/simple;
	bh=dOx7L9FMXSNyyO9RDoQZeW4I5roMbAYAp6pktIjCurw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AeepFRFEuN/uQrTjXmw7l5z+OLsxDtni6WsuH0jJyyvtvALhPonWp/Rp7Mv00hna50Q6xNiMpeJAryEkgOzJmsdpH/lJvQw6IalgQ3KBx0OBD+0Su2ZdY8mRT+iUeIZo5zEL2KwAxPxLvjrIUeIs4bWvc6BIFBORmtrtnBLzmfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1573C116C6;
	Thu, 26 Feb 2026 14:46:12 +0000 (UTC)
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 0/5] crypto: Drop stale usages in various help texts
Date: Thu, 26 Feb 2026 15:46:04 +0100
Message-ID: <cover.1772116160.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

	Hi all,

This patch series drops stale references to subsystems that are using
various crypto algoritms.  It was triggered by "make oldconfig" in
v7.0-rc1 showing new prompts about BLAKE2b, SHA-256, xxHash, and CRC32c
algorithms.  When querying these symbols, the corresponding help texts
incorrectly claim they are used by btrfs.

Notw that even if correct, there is no need for such references, as all
users should select the needed symbols anyway.

Geert Uytterhoeven (5):
  crypto: Drop stale CRYPTO_BLAKE2B usage
  crypto: Drop stale CRYPTO_SHA256 usage
  crypto: Drop stale CRYPTO_XXHASH usage
  crypto: Drop stale CRYPTO_CRC32C usage
  crypto: Drop stale CRYPTO_CRC32 usage

 crypto/Kconfig | 9 ---------
 1 file changed, 9 deletions(-)

-- 
2.43.0

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
