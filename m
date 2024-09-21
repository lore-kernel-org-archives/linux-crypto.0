Received: from exchange.fintech.ru (exchange.fintech.ru [195.54.195.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89EF18C0C;
	Sat, 21 Sep 2024 16:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.54.195.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726936497; cv=none; b=Sg5Fxk4u7HvpK7/eruEIx32PPu0xRNmaaoVZwmRH497ZdnPsa6zApclyJI58RW8Z6WK92pSGp/uMoRbebcG5bqhOjVNZ4ZfLVlxCDJ1brQvgAXekk1TweoObFHuyvk8/Yeyc7W4DK5Fds8DctNATLbHjv/U/FKR/314w3hx8+bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726936497; c=relaxed/simple;
	bh=guXDKT9Uw+IFAn/x2uOFwvTY99UA9PyUzcfo7BQ91Ss=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZR3kme032VLixEH8ZZhXSkvrsSnV3KIXe/Gd79rN86WM48QG/JjK3ymGw6wAsgUytQ2mQnvGTlb/R/gUaPOZifHE2LUzRpOf7FJ9Tr4kFiE0dw8q55T1DqyzS6OF9FNBAU6kgOhvQ+u/rs8/hJIITHcEVk0MSKzD812dzy44oOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fintech.ru; spf=pass smtp.mailfrom=fintech.ru; arc=none smtp.client-ip=195.54.195.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fintech.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fintech.ru
Received: from Ex16-01.fintech.ru (10.0.10.18) by exchange.fintech.ru
 (195.54.195.169) with Microsoft SMTP Server (TLS) id 14.3.498.0; Sat, 21 Sep
 2024 19:34:42 +0300
Received: from localhost (10.0.253.138) by Ex16-01.fintech.ru (10.0.10.18)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4; Sat, 21 Sep
 2024 19:34:42 +0300
From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
To: <stable@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Nikita Zhandarovich <n.zhandarovich@fintech.ru>, Antoine Tenart
	<atenart@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, "David S.
 Miller" <davem@davemloft.net>, Peter Harliman Liem <pliem@maxlinear.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<lvc-project@linuxtesting.org>
Subject: [PATCH 5.10/5.15 0/2] crypto: inside_secure - Avoid dma map if size is zero
Date: Sat, 21 Sep 2024 09:34:36 -0700
Message-ID: <20240921163438.25253-1-n.zhandarovich@fintech.ru>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: Ex16-02.fintech.ru (10.0.10.19) To Ex16-01.fintech.ru
 (10.0.10.18)

The following patch addresses the issue of unchecked calls to
dma_map_sg() in safexcel_send_req() as these macros may return 0 in
case of unsuccessful mapping. This outcome in turn requires
unmapping of previously mapped buffers.

The fix has already been backported to the following stable branches:
v6.6: https://lore.kernel.org/all/20240122235813.608624333@linuxfoundation.org/
v6.1: https://lore.kernel.org/all/20240122235752.938797245@linuxfoundation.org/

The issue in question can be fixed in 5.10 and 5.15 stable branches by
backporting the following 2 upstream commits. Both can be cleanly
applied to kernel versions mentioned above.

[PATCH 5.10/5.15 1/2] crypto: inside_secure - Avoid dma map if size is zero
[PATCH 5.10/5.15 2/2] crypto: safexcel - Add error handling for dma_map_sg() calls

First patch is a prerequisite to main fix and removes warnings in case
of a call to dma_map_sg() with size 0 and allows for clean application
of the main fix.

Second (and main) patch adds proper handling of dma_map_sg() erroneous
behaviour.



