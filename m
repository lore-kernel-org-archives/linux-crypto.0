Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.141
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793938037;
	b=oTbWRmPcRaC2RfRPZZD+8bcFo5Q5/KbErCin7A6MBQa6EfewEFnJAMl7yAM3fV3JsRoy
	 1Od7KGd5Ph+qry5PyQyZBLZnXXiyyschfuBkku86FA43yjV4dFa1Ya59pyHd10iI/KxF2
	 U9SuKXZE+SMsLwGJAYQ/rlkmB0e5Fcb7NDDjWphOA2G1fsVzUDfqr+RIxoR9S8otLmaMU
	 qhps54OzFJ3IKGzmpc133VKvfJNC7EYgm5n8bo3UoKZIeufl2aHlksC6eVDdtQkZkJ2dV
	 Do8RxrFyIFrx2zfDpBG8KMYY7AawT2n7J+6iROw4VgNyWTG+Vr9DvmyAVxLqY6pDg6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793938037;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=G5nYY2ZUWgQk+ZAwY/AIoQKnH7TbOl9wmsYlDerAcvU=;
	b=gATvCqA5n+ysoSXtncoVM2qrlEsEppiDfpTVPU+Y+r6VanYuGKIbheMkzV0J1+tMnx1o
	 dS66x7oJlTiJtTy9tXhJQ4pmNSo0Tv1T4GishxVf3qEIRYOflrxGYZKoypxnZTKbCGD70
	 /8nqM87uBKILrF8FhLgp4vxt7ziBgK7Ww+sM4XRGRvxrWe9XQQEmgl0b3gRbKC72FyRQx
	 Ex83FpOTHa+8rZkEQPf6sOaeDwmkvF3S9y4+khZ3Fsy0PNfo5y1eEY6WvIyjZo3ltiysy
	 am71x9mImhuky3zKCkJvsqIZLdxh1VNUf5HU1GjNNJMhOYR2KE5w4qjlfL41Mt7qoAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=mckelvie.org;
	spf=pass smtp.mailfrom=mckelvie.org;
	dkim=pass header.d=mckelvie.org header.i=@mckelvie.org header.a=rsa-sha256 header.s=fm2 header.b=kBubSxPt;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=Yo1yfT0s;
	arc=none smtp.remote-ip=103.168.172.141
Received: from flow-a6-smtp.messagingengine.com (flow-a6-smtp.messagingengine.com [103.168.172.141])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6852606A326
	for <linux-crypto@vger.kernel.org>; Fri,  6 Nov 2026 04:07:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D6852606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mckelvie.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mckelvie.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mckelvie.org header.i=@mckelvie.org header.a=rsa-sha256 header.s=fm2 header.b=kBubSxPt;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=Yo1yfT0s
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.phl.internal (Postfix) with ESMTP id 149A81380E18
	for <linux-crypto@vger.kernel.org>; Thu,  5 Nov 2026 23:07:16 -0500 (EST)
Received: from phl-imap-04 ([10.202.2.82])
  by phl-compute-01.internal (MEProxy); Thu, 05 Nov 2026 23:07:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mckelvie.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1793938036;
	 x=1793945236; bh=G5nYY2ZUWgQk+ZAwY/AIoQKnH7TbOl9wmsYlDerAcvU=; b=
	kBubSxPtCPYauvZQaS5oXImiMfU/jmNI9JYdbRhuIKmBJi6NeA6ZCdV+c4FIAV81
	xUJShdscTp6ihdaEOetNWBD/Qq21W7fM7R5jztrJQNCXsFk4vX1FEUxW5DfGbITh
	LT+V77Tfgl4JyZ5GcTm363+FLS5sNDYblIcn5Yp6YeFWF/Bu4QmIAHuBvQ2u39Eo
	8IjtMkQYhsjjoNUonP6Oae2cTK+1qA+1CyK7N6SRnTQD8/oEgowKwfPNo3yx2sLP
	4zPu5JzBDTmMtrJ6OPJxsRodSDhS0zFiT7yqtWM1G3FAdKb9icUgz/+JJQ2DnT+K
	4TXMpng+AY69GXeJXWp6lQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1793938036; x=
	1793945236; bh=G5nYY2ZUWgQk+ZAwY/AIoQKnH7TbOl9wmsYlDerAcvU=; b=Y
	o1yfT0sQj6xt+zhYA19Mg1m1ycxWAVI8xW1+SBM0y1PKsxb1ZWwzismyCILX3nw+
	/1efe8AKm5MrJJ/khxqjVhPuoqYe8kQDbT16JLed43g5vFTaj0Kp++NxCunRJ9DU
	EJwkwdhogVYRcSWr7CKcSQrcjEQyX2g+2Y5HpBDlkJ5+3cIYVEb+3Bj/xR/w+LE7
	YGKSX6yn3wMHnggKC75KnBu6BRE/KbWws6oHNZbqOUonpvmD0kF7I6iuEWDJrv5s
	fBFoxGLp7poB9HP57WKak8gkguwdFAVho+nFinKhPmkN+0EAr9Ll9iOtz+e5R1UG
	g35B9CqClveABvSB5hVjQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=mckelvie.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793938036; d=mckelvie.org;
	mf=PHdhbHRAbWNrZWx2aWUub3JnPg==;
	rt=PGxpbnV4LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmc+;
	s=fm2:rsa-sha256:I1111DLJbsA6yjGOv5e9vKoECF8xXDICgJlEblkixpvX6eM
	egbBihBUuqYY4xjz721KSQVhQVLflLwGXuWKq2K+gsz6402HWpYZoZi0vurf7ERw
	XHIwlMMMdTynG5vKESNfGJsqCmP2dS3BvOJbF6z4iwJsAbl3fbm3dcRpcs/csuXp
	401YGwT7MbZzh/i6yiSRFmKwbfYMMBGmVahG7AfIIWM6clJTekW51RFbg3n2Bbo8
	GSKWB271Va5auJyiIdzYbtin8cvZZiYwlCBr1BHpXwGwEZu/djGVAKFhOCa1bF8m
	201gbI6JRK+LeLiTXw351wy5CyQgKsil9DcHNGQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:7Q0YJOQ41HYghfXExm1nu2Mq4vLguoRagadQaCcb1V8=:AyM6iXix/LBJ1KVUMz1sZ8R/5QyWywIk04wYBUBJUvg=;
X-ME-Sender: <xms:c1LtalOQehey5HKapZL7vU0t4aw4VaPAiYSMmDVjDnJl51_xzkXNcw>
    <xme:c1LtaizZ7P4YnSF9gPtqDhTMmwyWvfawzkPZ3ts6s1u7QFMUOtW5xEcv7LxZzi3TD
    8aW6DIHZ2DTkdmmbCUBjK_MzSVZ9IOzVS07K0A6BKbkxb6bHCDx-Cbv>
X-ME-Proxy-Cause: dmFkZTGYngjZA3QO16kR7vUd76ZuOlzfdYRv7gUrowK5koaR3eEEEFQN8LT13GmogTVJGm
    sG6tD4po2A8kUomiq3oOpUWXnOYC2r1u6giN7i2fgJbZTCzvCBUU6ZgB/0tYKeAxtZhWbU
    qLjPgm3vEpnz4e8pn2wmHYJo+aWBj6+0EpgoozBQAdcFcfiLYRiyomForHQCI1rYFgjBH/
    sr/3k0A+CP67Jo/JfiRo1u25K7FkJa8EXZMJPIzLfXy0c07UKHbLOJw1yLAgxVViTTFHxk
    Fq/mjM/+Bmhl+wynEfLU531tT0dVAwVqh2hDhbTEYtq7r6Mky6d0j6hQL0VkC/3qDVB7B/
    dCPHPOX/87ikGhbExRDhnPaByo+lgUsPlCct/8f+GfjhBbl7EU8HfMYwKUwnDBjebw0EDp
    Av5zpsDIeTKJkXO8j7bup9bnsAOzFpYdqusp0HIoF9p/8Wldhl2fBLsm+/fgvsrYRUHH3X
    7keXLqu8HSCfhIxlu5/tieN/6rEWztHVT3XHdQX7FflHgbDAIfLI1SmyWcXwOe+fCqQpYN
    bpfqQhgZ1zgTYd///VAKymjB/mWJ2FpWjfzzmQYjSxJNYEnTj9/wpxejcSXtF8gazeaGU4
    j/lFRdChYfsee0/MyihOj/yY4G0WNJVp1r5c5v354gPHqJ+O2FXkFo95vicQ
X-ME-Proxy: <xmx:c1Ltau6h7yTrr5zr8g8IaP6gaVeEqNSfwnvJneUXOeedmNntWcEA1Q>
    <xmx:c1LtahM22ZRxV8BMYGowo9roXPYDpsZLM4iysOjdy2jY10iJxFzQjQ>
    <xmx:c1LtakvnCkHvj7repaMd6HHqUm_RojX8ChdzQrnH61dtRDsIlyO_Zg>
    <xmx:c1Ltasb7xU-oNl8kubhRicYY5uNRi94ur8U88Me7yBmmdYFIeHlt6A>
    <xmx:dFLtauvUMjYi-uXIJQkOAsYsuKlgovySyWDLyvRH2-ZFnalu1e6oUopx>
Feedback-ID: i53594642:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 6A540B6006E; Thu,  5 Nov 2026 23:07:15 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-ThreadId: A9qJPwTAQC4c
Date: Thu, 05 Nov 2026 23:07:15 -0500
From: "Walter McKelvie" <walt@mckelvie.org>
To: "Eric Biggers" <ebiggers@kernel.org>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
 linux-crypto@vger.kernel.org, stable@vger.kernel.org
Message-Id: <47a49300-5b78-4723-b67c-4320aadfaf43@app.fastmail.com>
In-Reply-To: <20261106034925.GA3877@sol>
References: <20261106034150.1159818-1-walt@mckelvie.org>
 <20261106034925.GA3877@sol>
Subject: Re: [PATCH] crypto: algif_aead - Allow gcm(aes) for privileged users
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

> Is this with upstream iwd, and do you have a source code reference?

Yes. I'm using upstream iwd 3.12 with upstream ell 0.83.

The reference is in ell rather than in iwd, which is probably why your
grep missed it.

iwd's EAP-TLS, EAP-TTLS and EAP-PEAP implementations hand the TLS
tunnel to ell (src/eap-tls-common.c:641, l_tls_new()).  ell's TLS 1.2
cipher suite table uses L_AEAD_CIPHER_AES_GCM for the eight
*_WITH_AES_{128,256}_GCM_* suites:

  https://git.kernel.org/pub/scm/libs/ell/ell.git/tree/ell/tls-suites.c?h=0.83#n1220
  (tls_aes128_gcm / tls_aes256_gcm, used by the suites at lines
  1322-1425, e.g. TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384)

That maps to the AF_ALG name "gcm(aes)" and is bound through AF_ALG:

  https://git.kernel.org/pub/scm/libs/ell/ell.git/tree/ell/cipher.c?h=0.83#n224
  (aead_cipher_type_to_name(), then create_alg("aead", ...) in
  l_aead_cipher_new(), and the bind() probe in
  l_aead_cipher_is_supported())

When the probe fails, ell drops those suites from the ClientHello:

  https://git.kernel.org/pub/scm/libs/ell/ell.git/tree/ell/tls.c?h=0.83#n413
  ("Cipher suite %s's AEAD cipher algorithm not supported by the
  kernel")

With af_alg_restrict=1 that is what happens, and EAP authentication
then fails against RADIUS servers that only accept GCM suites. This
is the failure in the linked report. An affected user confirmed that
setting af_alg_restrict=0 fixed the connection.

Everything else iwd uses through ell is already on the privileged
allowlist, and ell has no ChaCha20-Poly1305 AEAD, so gcm(aes)
is the only missing algorithm.
