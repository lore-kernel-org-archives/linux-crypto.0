Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A0020B22;
	Thu, 31 Jul 2025 21:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753998844; cv=none; b=k/mKj1KYL/6BzoVZ32sZxqD6GG4Ki4pQBQMZzr0XSUQQ+2wxoNmkkT8TbpKoihNn+kxFPbHd5Q2D/tsrBP3OM5Ws4qpCn4w3VGw/yQrNfe1nffMOr1ktR8lys19ZH+RMOSaxwvD6hSZ+owfHbMPVJJd0CJCqSGiBhBKWmrohpMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753998844; c=relaxed/simple;
	bh=Sp+uNTm82GyIUnrFXO0K70bZDmbRQLYY4GLTCRkCJgY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=grlt1tSJFubV29HioYuhno5j4HHhTTKndML5xWT6Y4BsCmBSQGdHrDEUZN090W5mwiHUv5PsEeWL8SerKArQEnsk+rKG7XkcUNkTUEdPu4tHZaZfHxDN70Uo6FA3w+J+kw43ouh4sWzI6p9Shih+WSxNQCYDgkq7YE4ZO28pGuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EdS5MOfQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EdS5MOfQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5C9C4CEEF;
	Thu, 31 Jul 2025 21:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753998843;
	bh=Sp+uNTm82GyIUnrFXO0K70bZDmbRQLYY4GLTCRkCJgY=;
	h=From:To:Cc:Subject:Date:From;
	b=EdS5MOfQgaEqzyBxQ9dY+mwjHsJuUGwKHMlERI9Iystt6+5wdJwnZyy2EaTw798LX
	 e2+Bw6PMkA/C2AX7qN8myfVXJQQAPnAn3UqD7sXfouURgQluQs3rj+S5jEMXuzRWGI
	 BOVa+lZOw/UNug6Jv/MXZTimlsaZEWn/OVRhhe9Evk4fLXvgbtXShav9A3QwgizK2Z
	 w29GJ+J/tUi3Ktpaf7xzG1JtbgtzAHFNCAracItweA0XgQTGDKGtoZfEVzMMsisEuj
	 3JAr7GkOGeolMrIBZrAtvdDXLo4jVGpY847oMN1nV6hEnNWOGXkpa+Zi1PBne92k75
	 v1lfuXU7LxmTQ==
From: Eric Biggers <ebiggers@kernel.org>
To: Peter Huewe <peterhuewe@gmx.de>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	linux-integrity@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/2] tpm: HMAC fix and cleanup
Date: Thu, 31 Jul 2025 14:52:53 -0700
Message-ID: <20250731215255.113897-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Patch 1 fixes the HMAC comparison in the tpm driver to be constant-time.

Patch 2 simplifies the HMAC computation in the tpm driver by using the
library API instead of an open-coded HMAC implementation.  Note that
this depends on the HMAC library API that was merged for v6.17-rc1.

Eric Biggers (2):
  tpm: Compare HMAC values in constant time
  tpm: Use HMAC-SHA256 library instead of open-coded HMAC

 drivers/char/tpm/Kconfig         |   1 +
 drivers/char/tpm/tpm2-sessions.c | 104 +++++++++----------------------
 2 files changed, 31 insertions(+), 74 deletions(-)


base-commit: d6084bb815c453de27af8071a23163a711586a6c
-- 
2.50.1

