Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C214927BF99;
	Tue,  4 Mar 2025 23:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741129683; cv=none; b=UReQFcpA7ZKGFnouM6ANksj3cm5dprv26ayh/jBSYhe64138Zd4pvHZZXEBMATaqi+BSVrjKUwnPbwScpK0YwmRCdUuNmOUe2ryPIS3hFdS50q3ZLOHGGvU2S/9ql95hfm3y8ofFTU+4Yy572d2GB0RyQU4sqUmF0BzLsrjPaZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741129683; c=relaxed/simple;
	bh=6OawBiHHp4m5x2MxZ3PlFGzG0WH9Ah1ajeEk2doc+RU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rns9t7teQCb10W6vLeP6c0izp4zPPB8+fU4RnkeUhKlaDUfFIPbQy6g7N8OGAbeUBfFDTeOkwGNeAAQTNww+F1M9MmV8Q39zAbs7a9XyUkyn8ujB4kiDs4TkQp1KdV3pzZG2hFbv1lauPYbho9zzWPmt+iNyZfS3Do64YGdsy8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SGegSeD2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SGegSeD2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48493C4CEEC;
	Tue,  4 Mar 2025 23:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741129683;
	bh=6OawBiHHp4m5x2MxZ3PlFGzG0WH9Ah1ajeEk2doc+RU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SGegSeD2r06+jxlBPe5wL7d6OdXJKBJOloxIZDAKlcR8YWKWL6k1OAhBAm7QK1voX
	 2FXurfeKf/nrnPCV6PkXx0RVx+SQdsdGgQjmvoPGFqe/kj6Q1BtLS1jvskrVnZX4XL
	 T4RfWl0dLDDGZfO0eb1aN6qYPmw/m5q9I7LncJG42uYXUS/xbHuATOLgXP3I/tIwhz
	 IaQknc7mkWn9IqvysRrUbNRsi1VVOp1bTqQWa/rsuo3yIVNq79L7TmVet4HQa5+8tD
	 jzvOSZ3E55K8NpjAFZAmx4PHZup9dsankH82zdUcG+cheLAFYuvOZ0mJY8v8QdRVr4
	 SbY30juDGlWew==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5/5] lib/crc: remove unnecessary prompt for CONFIG_CRC64
Date: Tue,  4 Mar 2025 15:07:12 -0800
Message-ID: <20250304230712.167600-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250304230712.167600-1-ebiggers@kernel.org>
References: <20250304230712.167600-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

All modules that need CONFIG_CRC64 already select it, so there is no
need to bother users about the option.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 lib/Kconfig | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/lib/Kconfig b/lib/Kconfig
index 4bf2dd9f49a80..61cce0686b53e 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -192,16 +192,11 @@ config ARCH_HAS_CRC32
 config CRC32_ARCH
 	tristate
 	default CRC32 if ARCH_HAS_CRC32 && CRC_OPTIMIZATIONS
 
 config CRC64
-	tristate "CRC64 functions"
-	help
-	  This option is provided for the case where no in-kernel-tree
-	  modules require CRC64 functions, but a module built outside
-	  the kernel tree does. Such modules that use library CRC64
-	  functions require M here.
+	tristate
 
 config ARCH_HAS_CRC64
 	bool
 
 config CRC64_ARCH
-- 
2.48.1

