Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F752F7EE4;
	Fri, 17 Jul 2026 17:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784308748; cv=none; b=HKV4XaYEbegHNes03ctjgWlwj2s+60p2K8XZvXDe+3zlkXCisNTO/dAPXzN3U3axPBb0Wmgyz8dJ4TpIz4J2S3+3VLjt4kZmmoHxI/kNFqCAJg90JJ+IDliTcfZ477E+cPIOTmtFzcNoA0e8yuwWGCmEPNJ65fB8hw+6qg4Ir+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784308748; c=relaxed/simple;
	bh=/b7ya4UbIxyyDu99nHAUzO+4KZaFTCPliqXxDMRtHjc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cuKfWejMw4JAHwM3WN8HhNIOr8ylgxaKh9FUY35Mh3e+cFqT03lsFDhfVypQdC9eQfuCJBmDWGeqmWeNRKsRgRV8ZGi0wO5gtukA2HDq/Ie/mWS/auv6X7PCKM9/du+LJ81Q2RoBUcEmN7/D0571/WACkSr6CSdU/+j2ShzJYTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ghva/hAL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ghva/hAL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 302391F000E9;
	Fri, 17 Jul 2026 17:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784308747;
	bh=NVytjh4s7VBPPStb/TmGN4eD5UWlKDT/YI6SzkNgJWo=;
	h=From:To:Cc:Subject:Date;
	b=Ghva/hALm5UPJemCD8se+wVQRPULoXctdDwQ2AuoZ1xgs/EAiEPIIzUJ9NkfsBf29
	 OLQjXUe7zQb83EN4H+PwvdtrWiWzAkHX7eVH9aKRLWDAAo5RA+FsJVrtkwYI3ktDZH
	 ecrrmSOfgxFaUaRsDwa+BsXTOzQfaQa8CCDlIn/9uy+j/jnZXl6zRX0iE69wf/Onrc
	 vE5Rn7j4VHPZKw0tMcDSPiDRC/TO89xyy+6B4EdptfZMapd2St5UXcBw/qmvJMT7C6
	 eZFVVPRtMQL528YYp8bewHeQV4+2XowlVvU00mqXOhOcVxDM0NwgNzd+xEb/lHPUgn
	 sW9uAE5I/84bw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/2] More padata cleanups
Date: Fri, 17 Jul 2026 10:18:29 -0700
Message-ID: <20260717171831.27994-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Two more padata cleanups.  Applies on top of
https://lore.kernel.org/linux-crypto/20260713223234.24812-1-ebiggers@kernel.org/
which removes the no-longer-needed serialized job support.

Eric Biggers (2):
  padata: Mark remaining code as __init and data as __initdata
  padata: Free the padata_works when they're no longer needed

 kernel/padata.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)


base-commit: df373d39c6f038d176af303ae72f02c7c70b953d
prerequisite-patch-id: 57ddb64f17182e9382163da55150610d385274df
prerequisite-patch-id: 9ea2c856c57f6c92abe7f2b52e701e46398cb5bb
-- 
2.55.0

