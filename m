Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BDF30E82C
	for <linux-crypto@vger.kernel.org>; Tue,  5 May 2026 09:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777971771; cv=none; b=EQK/hKdPFuTByz7WYV/3k7P+3ilZ3DmOGNjdvrVx10pnBQTuo2qer9u7umnls4crVVcgK70l/S1R8jb0x0QuD9hrWdS38E53Yz4o8qXSw1V18gFObwU6OzGpsjBtlEzLD6r/WhoBXyNkR8YiRHH3Zy6UfV5gcqpvDc3kJn8djtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777971771; c=relaxed/simple;
	bh=vOGHNz0kx2vVuaAvhEuzgqV+gbONmpmDWfvjslN1kf8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ItTpNyLmM7YfhrRjnkGAioZ6G0m2J6D/Egsmzgf+0VxmqvX2JhLMUSxjfDdif12EOe9KE+Pwf4wn195rRdD9rwwTDvRN8OvK+d7QmhFp2opcXsmwersTkif7IV+7uep0udOiGDnz3IOaRP4oKmO2aiM83qwZaDudwIRDJYqxom4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=P+ZbIzoC; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="P+ZbIzoC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=Content-Type:MIME-Version:Message-ID:Subject:
	Cc:To:From:Date:cc:to:subject:message-id:date:from:content-type:in-reply-to:
	references:reply-to; bh=4AvXyOgZKLC/sbcF+HgH4Ok2VrliWz7q9lmWNO2/r2A=; b=P+ZbI
	zoCyw1B6gyI6+22lKbRBAyPPwmNQvPotDjC9Y9PjPLwxBhDlt+B77SMPmWBsSaCe5xwzN5RmLqRZw
	booer4M0JdJeHY5t9vmLQq6mTnpX/87DTTn8wN/57e8+oq4W1ERLhViVpp+6DiRPW4Uhr8lk6dcCs
	kf7j/gIxJXee25jXPdeVqXtWNDcWMxunfy28ngIOx5GkwI+Vj6vCnGXxgMZKbCMP9IQv5muDZ0QWt
	TyMT1TJrEUVODbYwl120MgRmVAND+vKnUSGQrLxLHaNEBX+bftV8FrjBZvb4acUTheD0E3dbatIxO
	Z+TmtjkV5YAZknsF/YLHjYLjoFyhA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wKBfx-00BNLS-0o;
	Tue, 05 May 2026 17:02:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 05 May 2026 17:02:45 +0800
Date: Tue, 5 May 2026 17:02:45 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Greg KH <gregkh@linuxfoundation.org>,
	=?utf-8?B?6ZKx5LiA6ZOt?= <yimingqian591@gmail.com>
Cc: Stephan Mueller <smueller@chronox.de>,
	Stephan Mueller <stephan.mueller@atsec.com>
Subject: [PATCH] crypto: af_alg - Cap AEAD AD length to 0x80000000
Message-ID: <afmyNZxW3QB33LXi@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

In order to prevent arithmetic overflows when checking the TX
buffer size, cap the associated data length to 0x80000000.

Reported-by: Yiming Qian <yimingqian591@gmail.com>
Fixes: 400c40cf78da ("crypto: algif - add AEAD support")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 5a00c18eb145..2358900a5533 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -584,6 +584,8 @@ static int af_alg_cmsg_send(struct msghdr *msg, struct af_alg_control *con)
 			if (cmsg->cmsg_len < CMSG_LEN(sizeof(u32)))
 				return -EINVAL;
 			con->aead_assoclen = *(u32 *)CMSG_DATA(cmsg);
+			if (con->aead_assoclen >= 0x80000000u)
+				return -EINVAL;
 			break;
 
 		default:
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
