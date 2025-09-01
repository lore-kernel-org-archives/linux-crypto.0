Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6792E03F2;
	Mon,  1 Sep 2025 16:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756745559; cv=none; b=R9J4isrvWcfC8pi3Toxy6ox4Qmv9GTvzwT7muBPaSuHMILdItUlwDMDBAqpxM6yesjuUCTAenIt8DyRk9q30+exTkMjM3shJE/aQXrP5DVjeGt8Q+jhnHyaW+ZzlkG1Tg/VO7fp/0EQchN/lVo2tjeZglgb10K+1165V4hkd3Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756745559; c=relaxed/simple;
	bh=VCeHmhHHJh56nj5M2NBoAxPVELuH9Nb9QLOAx3qRti8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oJUEGW1K7TSBGrXcHeWNaeo7E3JwKYjn4bZYY3TOqG8wnwZiGGUGehAr8xG7Mn0ubohV7y2Oi01RcwlYtKptLGwBpX7l7/BhiKhySbjp0dFtyuEAjfqg1hWAHE6ufDrdobxZ9e4L6Ix07ovRdq/M8AYkXhdJIhGPCeszvKXjSIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nz2A91Pb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nz2A91Pb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07DB7C4CEF0;
	Mon,  1 Sep 2025 16:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756745559;
	bh=VCeHmhHHJh56nj5M2NBoAxPVELuH9Nb9QLOAx3qRti8=;
	h=From:To:Cc:Subject:Date:From;
	b=nz2A91Pb+xxOFb9V7KYQXa8iUsauATywlpBt/NIxxZvUTdKri3eyLXDnP4xQq6+Y+
	 gBBUHu0uunonsw0TlwLfM9tmKPgHiRiJ2PyaD9C6UHLrxWiWsSYhSApWkK2ZGVa2f/
	 nx+QMko9JuHL7w4J3FeW5s6rufZX/4T2ZWPHcLBko0xHinZjONaoBe0f7BLQnoC++e
	 fv8iJQU6yMB67ydy8s5rDT9YrK0N9RlgysRZgQMx/MInDVnsi9Az7rLOxtzD1Xa+7z
	 1ujOkyKereIMOFvAV1slWnvvUaO4P8KH3oZ2HraH1aC2eR2yPetcj2ruyC2Bp2k/iu
	 v3uf7HBzVD4sw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/3] crypto: sha - Implement export_core() and import_core()
Date: Mon,  1 Sep 2025 09:50:10 -0700
Message-ID: <20250901165013.48649-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series implements export_core() and import_core() in sha1.c,
sha256.c, and sha512.c to fix some legacy drivers.  Unfortunately, the
Crypto API partial block handling changes that went into v6.16 made some
legacy drivers start depending on the presence of these methods.

This series is targeting libcrypto-fixes.

Eric Biggers (3):
  crypto: sha1 - Implement export_core() and import_core()
  crypto: sha256 - Implement export_core() and import_core()
  crypto: sha512 - Implement export_core() and import_core()

 crypto/sha1.c   | 39 +++++++++++++++++++++++++++
 crypto/sha256.c | 71 +++++++++++++++++++++++++++++++++++++++++++++++++
 crypto/sha512.c | 71 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 181 insertions(+)

base-commit: b320789d6883cc00ac78ce83bccbfe7ed58afcf0
-- 
2.50.1

