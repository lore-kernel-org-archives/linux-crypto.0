Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFE636C0D8;
	Fri,  6 Mar 2026 03:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772768296; cv=none; b=JsmvxIJyd/FS2e6QswAkYl+jj29IAAws/ZFUmx8t2xM3JCH/nhbjSXxRMpziC5PqFzTNXu1FJHvx1me+i/30Xw892+Dx2cJbEMNoINNPuj9hAdmM0PsCmuGq2EoR+w55TMumzDMnVF2bl/ItVa9R6JQKriY0coZpUj4TAjUlwsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772768296; c=relaxed/simple;
	bh=lWPe6HzHlWF7Ajkoe7X0eQUQeWdZYLj0utrBAnEF+Ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SxWFqRqXNESUBLIdTUPz/VzkcQps5PA7ASav3/q+IKHN8TzusmRqAeZ5xuflX29TmbDvC76i5mcDkdz3ApoSCkBn/8E2n7Vtr+4kFHZv2goTmW2nZRQ3RnoDB+AIklmbG9I4r97WaNkKkDDzbzIjMjXtp/QtQobgW37EkxkoZ0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oriXQEJP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oriXQEJP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02EBEC2BC9E;
	Fri,  6 Mar 2026 03:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772768296;
	bh=lWPe6HzHlWF7Ajkoe7X0eQUQeWdZYLj0utrBAnEF+Ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oriXQEJPL9UhlIql8Q6MQYF5AUij6jK5QaSqC/8SA31+mrAvdPv4Uy5ZAoAs6/exa
	 +FX3n55p2+RpgT4tcVtSk2rp7shIalloT7rkMVdcgnNN8M0NLBfC+6hhJZxVad0NRG
	 HgmnkfWL6pRI1HjNnA37HOinaXyYR7V6PBoNwlg0UkLGwGYdW6WcVHwb/rmt9eXNs/
	 ce5072RvPXAyb9ZGbmPQDb12gjfAysU6sdR0rkNYuVCt9uR2dXjXZUPZo2v1pISwNM
	 GXDCcyRmkvVfwyIypd+LTsyAR5p/EEb7g6PuPeBmAyrvGUZTr9D6HwABmElAt6Fs4S
	 NFcc/7Nvgb82Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	kunit-dev@googlegroups.com,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 2/3] lib/crc: tests: Add CRC_ENABLE_ALL_FOR_KUNIT
Date: Thu,  5 Mar 2026 19:35:56 -0800
Message-ID: <20260306033557.250499-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260306033557.250499-1-ebiggers@kernel.org>
References: <20260306033557.250499-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that crc_kunit uses the standard "depends on" pattern, enabling the
full set of CRC tests is a bit difficult, mainly due to CRC7 being
rarely used.  Add a kconfig option to make it easier.  It is visible
only when KUNIT, so hopefully the extra prompt won't be too annoying.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crc/Kconfig | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/lib/crc/Kconfig b/lib/crc/Kconfig
index 9ddfd1a29757..cca228879bb5 100644
--- a/lib/crc/Kconfig
+++ b/lib/crc/Kconfig
@@ -105,10 +105,24 @@ config CRC_KUNIT_TEST
 	  Unit tests for the CRC library functions.
 
 	  This is intended to help people writing architecture-specific
 	  optimized versions.  If unsure, say N.
 
+config CRC_ENABLE_ALL_FOR_KUNIT
+	tristate "Enable all CRC functions for KUnit test"
+	depends on KUNIT
+	select CRC7
+	select CRC16
+	select CRC_T10DIF
+	select CRC32
+	select CRC64
+	help
+	  Enable all CRC functions that have test code in CRC_KUNIT_TEST.
+
+	  Enable this only if you'd like the CRC KUnit test suite to test all
+	  the CRC variants, even ones that wouldn't otherwise need to be built.
+
 config CRC_BENCHMARK
 	bool "Benchmark for the CRC functions"
 	depends on CRC_KUNIT_TEST
 	help
 	  Include benchmarks in the KUnit test suite for the CRC functions.
-- 
2.53.0

