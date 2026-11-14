Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=152.53.16.207
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794675878;
	b=jMJ+BSNa37hhCZMPwaOi2vx56QnmiL1Zc3ElIky3E+mZJbiM/pLvUyTZGQWf2tohhj9U
	 15Gv/xUVbjLClPj+q5qcg6RX4ekWKWd3QniAz8vdXyruOfR3HfOppThGBPwYrLbiRcuUV
	 qelmYEIYumT+XYHm+rKcOQMbH6qRo/+0TRL9ocOgUKsKoeeZqxJpECrIMut4bAIC/oZPG
	 su3cmoNua7mvZkAKyvqCjp0I7Ad/wsx1XiBs/4mElztu6nMPDVUsxviyAbjR1a70FJVFq
	 0ChiB9HyK1QO9Ql0QnS4Y9FtCGdwfDY2AU4NvSWwRVTB91uC4ufcA7Ut4NtW+U7fRwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794675878;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8M7aIGnqjlzx26ruFI1xuFRqljse214vxZZ04BvcePo=;
	b=Snp7LfjgI56cOk/KI2XAjp+gSWQ9LzInHgoUTbCWdHwmHs9FlECNWup5wafgjMU8Sgyj
	 KAh4FggQQmlaTY5dlw/PKRMsBB02ljTO8nYPPDlZEJet0ZDmioydPO04FCADLGAI8dm2r
	 ly2bgufGQCnf3j2iQAF08RyXIR/ALLmLnErPldFIOH0sZpvaYRjguopMmAGU4l1JCYIUo
	 5cvZuGzjbms/9b0m4BlsThvov9tzvjShbwAATNszPta3dzNQuEq+2zZ5HBlOQ+0+1qYaO
	 /ozLdBvhBV4mzW5SZbS1z2yCCZHWH9N82V3TYX54cDqokhgrB1HOYYYR8mHeXRtoA9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=kaiser.cx;
	spf=pass smtp.mailfrom=kaiser.cx;
	arc=none smtp.remote-ip=152.53.16.207
Received: from akranes.kaiser.cx (akranes.kaiser.cx [152.53.16.207])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87597606A338;
	Sat, 14 Nov 2026 17:04:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 87597606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kaiser.cx
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kaiser.cx
Received: from [185.104.138.115] (helo=nb282.user.codasip.com)
	by akranes.kaiser.cx with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <martin@kaiser.cx>)
	id 1xSHAv-00000000iNz-2Ww9;
	Sat, 14 Nov 2026 18:04:25 +0100
From: Martin Kaiser <martin@kaiser.cx>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Martin Kaiser <martin@kaiser.cx>
Subject: [PATCH 0/2] hwrng: cctrng - simplify runtime pm
Date: Sat, 14 Nov 2026 18:03:13 +0100
Message-ID: <20261114170335.1680546-1-martin@kaiser.cx>
X-Mailer: git-send-email 2.43.7
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

two patches to simplify the runtime pm code in the cctrng driver

compile-tested only
(the devres patch is similar to imx-rngc.c, which was tested on real hw)

Martin Kaiser (2):
  hwrng: cctrng - simplify runtime pm refcount code
  hwrng: cctrng - use device-managed api for runtime pm

 drivers/char/hw_random/cctrng.c | 47 +++++----------------------------
 1 file changed, 6 insertions(+), 41 deletions(-)

-- 
2.43.7

