Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742DB1F7569;
	Fri, 17 Jul 2026 16:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784304469; cv=none; b=TefMgLZwu8i7GLftlL742xS1we8kWtx7c+2h/Z8hv9O/zSseGzdspfKkx25fBv8VETh4cOTRaYQcTDYU/YM4M6SZlBPr2TXSR5mQzHss9zM3Wp4FMqPRLQJNHFGDru+6xW+/brUyRMlSRJEnge871sY9u3Y5Ya50QrbRr1oSpgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784304469; c=relaxed/simple;
	bh=iapX3TYHAcXTPyVwpjbW3luuNHOao+GhIeBaaQMeMqU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=DALlGeNlP3PyT4x0TbHaG7OR5/oBpGdDO+j7xk0UOJw7u3+xfi7VqpYkeddgESCt8wPvQPfFbRNmCm6pWsG2BpnDVPautSppDB2bK5wC3uV27SMBaigDjg3UCCOchQ42YDqS6pyw9cfhr1q8a8x6bqWtq5A/ysM1xw2qLUW3tWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RIWFdWyb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RIWFdWyb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC2A1F000E9;
	Fri, 17 Jul 2026 16:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784304468;
	bh=oMiXg7RWpmnf948I5HoPwnvmRH96GLZgCaT/jcbnglA=;
	h=Date:From:To:Cc:Subject;
	b=RIWFdWybjj/TB/N2aXx7ijSRHlwh5vNpOODNG8rzNj3yCXHn8jDaR6OISmATBRI9L
	 CjQ39GNUshpOn+6o56J6NeMQ9k1wzY497jtFxlF7tF9hYJu9KYKKPv/E8sJ3hUbSLH
	 kvzfqewT/23SQFQ4APpCHH/EcU+zgSdW/9cdQaGgAWnlozLhxx7v1Y8X1oMEJLYxUH
	 C19GYJ5A2PL9wKWeZAoDfBKAjJ5alHCulrXKcofzNzVEj3vz3t15Pa8TzsTmeuT1XX
	 FcSwCtTdKW762C9vJLqJhmXk689hRn4W08IOpLwf9J/qRR5j86e4k9fyVFS4prqR9t
	 GxE4Gtm6k285A==
Date: Fri, 17 Jul 2026 09:07:46 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Huth <thuth@redhat.com>
Subject: [GIT PULL] Crypto library fixes for v7.2-rc4
Message-ID: <20260717160746.GA2046@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit dc59e4fea9d83f03bad6bddf3fa2e52491777482:

  Linux 7.2-rc1 (2026-06-28 12:01:31 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus

for you to fetch changes up to e073f1238ecaea366f53e98724c40b31856da56a:

  crypto: aes - Fix conditions for selecting MAC dependencies (2026-07-09 11:06:22 -0400)

----------------------------------------------------------------

- Fix a build error in certain configurations

- Clarify some parts of the documentation

- Remove unused code that I forgot to remove in commit cf52058dcdd9

----------------------------------------------------------------
Eric Biggers (4):
      lib/crypto: md5: Remove support for md5_mod_init_arch()
      lib/crypto: docs: Fix some sentence fragments
      lib/crypto: docs: Improve introduction sentence
      crypto: aes - Fix conditions for selecting MAC dependencies

 Documentation/crypto/libcrypto-blockcipher.rst |  6 ++--
 Documentation/crypto/libcrypto-hash.rst        | 38 ++++++++++++++------------
 Documentation/crypto/libcrypto-signature.rst   |  2 +-
 Documentation/crypto/libcrypto.rst             |  5 ++--
 crypto/Kconfig                                 |  4 +--
 lib/crypto/Kconfig                             |  3 +-
 lib/crypto/md5.c                               | 14 ----------
 7 files changed, 30 insertions(+), 42 deletions(-)
