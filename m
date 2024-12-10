Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329271EE7BE
	for <linux-crypto@vger.kernel.org>; Tue, 10 Dec 2024 23:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733875149; cv=none; b=hbeFDlVrxI9TD4L52hld7a4H/8LcegIBbo5VI9W9BO69L3Zx8nChvjB4wPEnq1gsYYIZN99Bu3/R6rpXdGr70G3vTDaTF8uDCb2cBbRMF1EMSMZgXhZtnd7KLPJheKwc4L6MgbulCn0uilLXeS8amwQNPAwNbiAME/8YUH96PUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733875149; c=relaxed/simple;
	bh=8YcD5F9o0aUGmQExrg5CicOnBh6b2O0CkBUj03uWrRM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IsjBu8H7kW8DkJhGQWVhoiDZ0IjgDrGDE3GXNNSjXirmxs79R1qxKkZzuJXfXYLTLa3Z3KpMtBTevFUuGQ8G3wr7UptwRPKEJ16zGMHgyRKPOme0qdmu+QnS1CKvIkz9soohCXYj7xLVIQaDvaWkNFXM1xVI2Ms33sOTEuMioU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mHZfJNkv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mHZfJNkv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF19EC4CED6;
	Tue, 10 Dec 2024 23:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733875149;
	bh=8YcD5F9o0aUGmQExrg5CicOnBh6b2O0CkBUj03uWrRM=;
	h=From:To:Cc:Subject:Date:From;
	b=mHZfJNkv5WOaFq9nxuC8lAYF9IZtMlXvAAYbQxRntjPcLSLvO3aXH39qtm6zOldrj
	 bsBx/LJeQbRBp6olbbm8WZ8URYCLmqdJ18GBuoMAWS6xfEoUMsfMBsKinOy6pPCAc3
	 lnlssOAtmh7sbHvS9cnakjo50HZ9RuxqtcIWq26g+P2Qt/HW19zSXXQZKvrvpTwdY8
	 ISZPybItYBmOoESjFgvGiCq9USDrAccR1aTZDJ+tBhDKxmyxCkZGTOg1g0GxFnt46E
	 T+GYv5kJYDD+jainAqfsGLNwxfVB3rUGVVaVyW8jlWzO8gw3qvYMyLFi8IyRsK2InL
	 oIKN8kbWyhRpw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org
Subject: [PATCH 0/7] crypto: x86 - minor optimizations and cleanup to VAES code
Date: Tue, 10 Dec 2024 15:58:27 -0800
Message-ID: <20241210235834.40862-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series contains a few minor optimizations and cleanups for the
VAES-optimized AES-XTS and AES-GCM code.

Eric Biggers (7):
  crypto: x86/aes-gcm - code size optimization
  crypto: x86/aes-gcm - tune better for AMD CPUs
  crypto: x86/aes-xts - use .irp when useful
  crypto: x86/aes-xts - make the register aliases per-function
  crypto: x86/aes-xts - improve some comments
  crypto: x86/aes-xts - change len parameter to int
  crypto: x86/aes-xts - more code size optimizations

 arch/x86/crypto/aes-gcm-avx10-x86_64.S | 119 +++++++----------
 arch/x86/crypto/aes-xts-avx-x86_64.S   | 178 +++++++++++--------------
 arch/x86/crypto/aesni-intel_glue.c     |  10 +-
 3 files changed, 134 insertions(+), 173 deletions(-)


base-commit: f04be1dddc70fcdd01497d66786e748106271eb6
-- 
2.47.1

