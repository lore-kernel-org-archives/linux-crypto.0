Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723BD1AC252;
	Thu, 20 Jun 2024 12:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718887727; cv=none; b=EdQ5bwe0b93VYqvaoselPRA3qU0yGVrRfgwHvnH1T4c+exrLprtxfGIjKtymcacemIlMuabVJLQY3Jx0Lh2saD5D2PmaesznvMwXnyfkN9cuaKHbjSg/4ZP5RS/KV1P2t9oV6DCR0GKLBDiqyO2808nuEP+i4ur59Nh84DjdzcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718887727; c=relaxed/simple;
	bh=v4jlGjeuGFae3UIWanV95pEru7/tYXgxjCsl+c+4hec=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=lcWsRKRfe+At4LAbC0/QuDmd9yBT99XUHMhPZI2+GS5WveAbWy33lcU2W2+QXMnKoukMuKPFkiEjqyQP4a32OZJkgIG4ZgtnBNSNyZOJxLtkw1d9y+t4NxyLztFcUxKK5oJnvEpE7R+fR0caBeJKgnm52ULGdKgAeuMZpEm0fN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4W4gJy4TM4z4wcg;
	Thu, 20 Jun 2024 22:48:34 +1000 (AEST)
From: Michael Ellerman <patch-notifications@ellerman.id.au>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>, Danny Tsen <dtsen@linux.ibm.com>, Nathan Lynch <nathanl@linux.ibm.com>
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20240603-powerpc-crypto-ignore-p8-asm-v1-1-05843fec2bb7@linux.ibm.com>
References: <20240603-powerpc-crypto-ignore-p8-asm-v1-1-05843fec2bb7@linux.ibm.com>
Subject: Re: [PATCH] powerpc/crypto: Add generated P8 asm to .gitignore
Message-Id: <171888750936.804969.14409568109203763184.b4-ty@ellerman.id.au>
Date: Thu, 20 Jun 2024 22:45:09 +1000
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

On Mon, 03 Jun 2024 08:01:03 -0500, Nathan Lynch wrote:
> Looks like drivers/crypto/vmx/.gitignore should have been merged into
> arch/powerpc/crypto/.gitignore as part of commit
> 109303336a0c ("crypto: vmx - Move to arch/powerpc/crypto") so that all
> generated asm files are ignored.
> 
> 

Applied to powerpc/fixes.

[1/1] powerpc/crypto: Add generated P8 asm to .gitignore
      https://git.kernel.org/powerpc/c/2b85b7fb1376481f7d4c2cf92e5da942f06b2547

cheers
