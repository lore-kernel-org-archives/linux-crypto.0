Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6233213E6D;
	Thu, 19 Jun 2025 18:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750358128; cv=none; b=Io6m2io/6gamqanSIjlVPXKuLxynPLAjhXr6o69OrarLBaucD69Js2b3QNZ47Zou0GDlTbWUWD6yAwKX/JhQs7gVDSnR70IyB2UAuQIA9q9wgiWQCmFdqs5qxV7MBbWcq8os3nUJPlgdw3jatmKSAQeint3Fc/4/Emh+eqAuv/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750358128; c=relaxed/simple;
	bh=qH5/JEmkvzKPI6/HH8DjDLCOwejQwXCTuISnD7/tw+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a/sx+09HaNsZzLIkbGA7yechbc+3bQTVbpOTSSiZCu9hy1NRJugBVgtcJumpo1exCxunq4CluSQIqGmYcKJaSzB+f8+42i+Pbj/2QCbmJtPEmvFsZDgjAo2jix8ll+b2flNKU46C2lRZnOinbl34/BetpAYVEEQNOtfedD66BTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nMEQcIZc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nMEQcIZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A33A2C4CEEA;
	Thu, 19 Jun 2025 18:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750358128;
	bh=qH5/JEmkvzKPI6/HH8DjDLCOwejQwXCTuISnD7/tw+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nMEQcIZcSEhyX9Kp2JPu8J6YgLcs2ThnNud8Juzg+VQihg3rPpas+qXiH+CKLR33o
	 Kq0G+FKIQyV2u40098yDv/gi6mzH/FnffQ2xucfDGnlD88c5zMneW4yZ8LTX2eTIY9
	 V0i8mornn0FufW1jUAiQkl1oYrAqZcqwriM0xCl4/MPFyMvqasv9o8AvWPRj1Gm29D
	 D8pnqrYA7D3r7+zFoytwYbZ28GJ4yxjEqH9fxBgBLkSRDjhIOMq5A5NBS5yJTw4Wgm
	 bAd9NIQhsNPhk5SDMWV9SIOU5ABiBSuI1WmXkHf9rul8IIyAcMCQj3pJey16FOJDG1
	 VKJrUeFxs9yXg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	linux-crypto@vger.kernel.org
Subject: [PATCH 3/3] lib/crc/crc64: add include/linux/crc64.h to kernel-api.rst
Date: Thu, 19 Jun 2025 11:34:14 -0700
Message-ID: <20250619183414.100082-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250619183414.100082-1-ebiggers@kernel.org>
References: <20250619183414.100082-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

The other CRC functions with kerneldoc are here, so add crc64.h too.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/core-api/kernel-api.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/core-api/kernel-api.rst b/Documentation/core-api/kernel-api.rst
index 0096463c7d7f7..111f6a595e48d 100644
--- a/Documentation/core-api/kernel-api.rst
+++ b/Documentation/core-api/kernel-api.rst
@@ -154,10 +154,12 @@ CRC Functions
 .. kernel-doc:: lib/crc/crc-itu-t.c
    :export:
 
 .. kernel-doc:: include/linux/crc32.h
 
+.. kernel-doc:: include/linux/crc64.h
+
 Base 2 log and power Functions
 ------------------------------
 
 .. kernel-doc:: include/linux/log2.h
    :internal:
-- 
2.50.0

