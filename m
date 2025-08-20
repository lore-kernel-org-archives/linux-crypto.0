Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7538B2D6E72
	for <linux-crypto@vger.kernel.org>; Wed, 20 Aug 2025 09:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755681141; cv=none; b=fX00p5TRwmCnA1qI8MiMMH9k8/FD73+3Y3D9AasY3/D/EIT3YEyMufcU79usyCCMGoxkqf6CtEXB65vEctI/veCLOpwPaqyz1aYOn0Q4N1+sbgznzdX63NVnEDwW1XH2Baw7tHsgLal6U6HrhTX0y2yPE/4Y8XsybPzQJdnmIA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755681141; c=relaxed/simple;
	bh=YKPdEoNUAkUaX4oZOPkIhdN8Mk15rJBAZJUdHjNcAWs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rdGuIag/wm+t3BJ3FlCmLaZ02okSUrJbvQDklGMhUlzVNz1fu3R/oSkURCq+GcJoED98QAEAbiCaioZTb7tdkyzHKG18bAPigBGI2NMQp80AE3d9zxiDZkAHvZdcgSMO4iEw24FCLkOtRt4v/X7kWE0IJ+Wx6pNp5UG2YqfdAkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tii0W23y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tii0W23y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17BC2C4CEEB;
	Wed, 20 Aug 2025 09:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755681141;
	bh=YKPdEoNUAkUaX4oZOPkIhdN8Mk15rJBAZJUdHjNcAWs=;
	h=From:To:Cc:Subject:Date:From;
	b=Tii0W23ypvWKu0EXkd3rRRtIhpUMBc3K9TciAboWFiLABZov7ETeLSsyYv7w4xQPJ
	 S+7Z/PdDZfUTxid9GYTA9ljhlszQeWL5jQHR33PMxKTFddyHlY10T1XXpefpWT9Rx3
	 lo+7YtYwVMLktCLq+afuaVPYxSdktzA5moDyT/BBr490k4v1XQz+20gpoBRPIO/rb3
	 pC4xxfqUDlJlxBF6EBVJjqfiX8Dfbib7OE8spntxo5ykIOdAdVx0ANLIwZen8USMNf
	 vTm+8pju+yRZztZ5nQka0o7leB+56LwXD103bf4XJHYloFitU5hWnkLpRqOjL49V+x
	 Q9+XZlwb5Dibg==
From: hare@kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chris Leech <cleech@redhat.com>,
	linux-nvme@lists.infradead.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH 0/2] crypto,nvme: fixup HKDF-Expand-Label implementation
Date: Wed, 20 Aug 2025 11:12:09 +0200
Message-ID: <20250820091211.25368-1-hare@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hannes Reinecke <hare@kernel.org>

As per RFC 8446 (TLS 1.3) the HKDF-Expand-Label function is using vectors
for the 'label' and 'context' field, but defines these vectors as a string
prefixed with the string length (in binary). The implementation in nvme
is missing the length prefix which was causing interoperability issues
with spec-conformant implementations.

This patchset adds a function 'hkdf_expand_label()' to correctly implement
the HKDF-Expand-Label functionality and modifies the nvme driver to utilize
this function instead of the open-coded implementation.

As usual, comments and reviews are welcome.

Chris Leech (1):
  crypto: hkdf: add hkdf_expand_label()

Hannes Reinecke (1):
  nvme-auth: use hkdf_expand_label()

 crypto/hkdf.c              | 55 ++++++++++++++++++++++++++++++++++++++
 drivers/nvme/common/auth.c | 33 +++++++++--------------
 include/crypto/hkdf.h      |  4 +++
 3 files changed, 72 insertions(+), 20 deletions(-)

-- 
2.43.0

