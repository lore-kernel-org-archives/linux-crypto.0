Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337A5346A08;
	Mon, 27 Apr 2026 16:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777306539; cv=none; b=OWcpsqGEHXCmPk0PshGqCO3fNRi0SyBpP+3AIrwsRD9XbYzGqfHWQm1QmWwu2ZIeUbkHd6icTeSoapzxVVfBBNGxLkG/np+8MyqN9wIJMfnml4XHkmGx/s8FpqZsvq004V+NDyKv6W1mhGeZhMRxxhtGZlvlCfIHuPYj7HLDwk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777306539; c=relaxed/simple;
	bh=DxaBFcVV6Ivcn+LPWzkGJl+BhvbUw5dsbfhsvKaak0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nAyKnC3EnaWGTndx1lA/cNxsUEnuaso5OMs0/Iv0mtkQlh4rYxsxZimmUaxCOe4yfGkban1k49Ip47FwQuS/+cIVGQ0FrZ+pPAAA0m4aiPzZKWSZFdphsJbaipBUtDIkGSBGyS+3t9erpgV3OK69OrXIudplUClj7A3J5uaX83U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ej8TxrL7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ej8TxrL7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DDE1C2BCB4;
	Mon, 27 Apr 2026 16:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777306538;
	bh=DxaBFcVV6Ivcn+LPWzkGJl+BhvbUw5dsbfhsvKaak0Y=;
	h=From:To:Cc:Subject:Date:From;
	b=Ej8TxrL7Iy9x3PO/bfteqBftcrB1Sy7zn0lKJL5wSNJRv+Nu59hVM17tsex4sFKRj
	 EWJxHShdb4SFI3itYQ0ktnAqY48XhqZXuDIDbLywYQyobKK8BhuIFyHdtVvpLFM/6j
	 1KdVJaBaYccztV1hw+7ZAL7XBAggd+eZI15874ruQM+ZOICKi4pGwTWe6aHDH9nIvD
	 WBsfsuZYNjzCGDcRE+rmyrwIs3dlO+aU3PpQhxDrp+L+romoOIrElQvHDx+d1I9Yx2
	 N8h55y1uaDYXGjUzp0ocpo6Nz//OzpILx17Ks3J2ECOF2jgzXLyyd+XbwVy4Z8PHZ3
	 ahK3Xrh6/Fpwg==
From: Tycho Andersen <tycho@kernel.org>
To: Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Borislav Petkov <bp@alien8.de>,
	"Tycho Andersen (AMD)" <tycho@kernel.org>
Subject: [PATCH v1 0/4] SEV re-initialization fixes
Date: Mon, 27 Apr 2026 10:15:03 -0600
Message-ID: <20260427161507.32686-1-tycho@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Tycho Andersen (AMD)" <tycho@kernel.org>

Here is a series targeted at fixing the bug where HSAVE_PA is cleared
after other VMs are running that Sashiko pointed out.

The first three patches are relatively straightforward, I think :). The
last one is an ABI break from how things used to work.

Thanks,

Tycho

Tycho Andersen (AMD) (4):
  crypto/ccp: Do not initialize SNP for SEV ioctls
  crypto/ccp: Do not initialize SNP for ioctl(SNP_COMMIT)
  crypto/ccp: Do not initialize SNP for ioctl(SNP_VLEK_LOAD)
  crypto/ccp: Do not initialize SNP for ioctl(SNP_CONFIG)

 drivers/crypto/ccp/sev-dev.c | 70 ++++++------------------------------
 1 file changed, 11 insertions(+), 59 deletions(-)


base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
-- 
2.53.0

