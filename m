Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.141
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793936545;
	b=0kN036vrq8ZQu9WfqwNFlBSzG58y0Cf3WFJNlpyV8x/cWBE36/Upu30UAToMheHlkAFY
	 KwNessVbjHoBSwZ6e43pzq/2rK1/6n/MWZ6aWO6/aoYtYfbixwPb71hlfJ2VycikwR7U3
	 JMdCs9lxDS8QFTggLtNf+MOD6hnJCzlV9l8BFcJkJZqlME8O/uHnm4QNGkaX216OaWNg3
	 LqR0frwN0Tv8RKT5oUsnJDh0f2Oj0D3JhIF/LJAaGQnc56YOQ1JoOa9MisX1aTyErvpUr
	 w1KmoVgnbVK+r/jCw/cSYEveL8272fLXvoiKO9Y/ZRSCLoDA6cERvO7gcqdewNAPrWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793936545;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=/QCjxhmVN1aQ0DukloSVJmF3e+8x0FNeoK4gOuxONVc=;
	b=epwAXSc4D5VIJA6Il8zQu9cd51uh/bxENvX5x8wCKkyxqemB+SSOj0Yczk7XMbGlRj0p
	 p1ZXEdg6T4V+pE+VO5QcB1P6IW7plOgGvS2ljfZrjgkXVSV7V2jD1JT1rlhufv0fxra5Y
	 dfx+GVSPnaddKkih4euQIJdUqLBsK1MBix1pVBbTcELzl8ftreFFFSXKlO+L9d+L8jFu0
	 5jlkak+YjCwA0N8jj238DlM0kBgUIt+v0lRCgF+hfGonML5EnAblwYSahh642oylofpHQ
	 HQIN7oaPLoe1psu52+4XO1U4WUcgLNh4wsV4CLrk9LBM9pw9s3WG3ILn3ry/aW6t0nQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=mckelvie.org;
	spf=pass smtp.mailfrom=mckelvie.org;
	dkim=pass header.d=mckelvie.org header.i=@mckelvie.org header.a=rsa-sha256 header.s=fm2 header.b=JabHDKpK;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=AJ1BQqrh;
	arc=none smtp.remote-ip=103.168.172.141
Received: from flow-a6-smtp.messagingengine.com (flow-a6-smtp.messagingengine.com [103.168.172.141])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA009606A332
	for <linux-crypto@vger.kernel.org>; Fri,  6 Nov 2026 03:42:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EA009606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mckelvie.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mckelvie.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mckelvie.org header.i=@mckelvie.org header.a=rsa-sha256 header.s=fm2 header.b=JabHDKpK;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=AJ1BQqrh
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.phl.internal (Postfix) with ESMTP id 2872D1380E2E
	for <linux-crypto@vger.kernel.org>; Thu,  5 Nov 2026 22:42:24 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Thu, 05 Nov 2026 22:42:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mckelvie.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm2; t=1793936544; x=1793943744; bh=/QCjxhmVN1aQ0DukloSVJ
	mF3e+8x0FNeoK4gOuxONVc=; b=JabHDKpKIqfe1CsiuR3FwcxS9HTBNot5UAxqf
	XxaWTWLOlcCN+bhD24kQU65UFdA2NmULeB3RrXlxieIoAHOfB3AP/P7WAGoBsfBr
	tfWN/uOaucvs2VTHgEhwrI5E+w41ovYygQLqOz7gBHF1MIgCTniHtYZA5n8rSpVQ
	z5tuldI9Mz1MSxpXivo6XFfeI7d630CEteT/hJyCpnXIaXxBZjTZesaEbi70e7WT
	qikyrkc5awXtZwRXixUDGj+Z7oKK2gV/kEKsx9g5dFUOo/M2J4EgUg4vHduIuNI/
	6e5Sg6U9ls8Llm2mtgWpuUjjaa84x57FlOlSfLB4LQnHcpupw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1793936544; x=1793943744; bh=/QCjxhmVN1aQ0DukloSVJmF3e+8x0FNeoK4
	gOuxONVc=; b=AJ1BQqrh3sTc2XTXOqCaTk7BBrGOlvgY96sSC6F1NAh17r0OACq
	/5W3v9AmuXRQ6pYjJ4Fq1t+kc5AcmenXGenRnMa/xvJQN0szw3XI4kdZVYe3HYPx
	bTPfHLOYmIW24UuxAQ8PzEgdMuIYUmk7wO+XPSVPkKy5F3AygB+H8YySxV37xQJs
	NJdLUAmKAxInNiExEZmIKRnKOw7pBF/Bh9O+hovPZYs9UWUW3Lkd+kMqPU9QY2Uo
	eOuDKxxd2QDkHBZaM8DT9HvJFDkz/A9QR2vzHvhr//pCYrDw136PJNhy7olh9ql5
	j0j6MPl8u2nD5ARX8ats1LD5GM7V1hFkWgA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=mckelvie.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793936544; d=mckelvie.org;
	mf=PHdhbHRAbWNrZWx2aWUub3JnPg==;
	rt=PGxpbnV4LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmc+;
	s=fm2:rsa-sha256:svHIu4InOijHvuYVw7fddngEGHqZjv6Bm/El+QS5kGKH3wO
	tfgWns9ro0AIpYuRDVHRNFGxhBgFW6yeu8GoEZwvdM9oRzy3kCtMi/E25JX/zmTT
	njGI4nZBhCuFBM/JEa3Ajwf5Ly37CjwvVvJHcXoCo0QwGZO6+SRnan9MK51VqjWW
	I3iSr2EW9X/9tg1Vak0QPipgzhPndIDvQtQ+kpvrwv6K23N2GQyugHBMJNWtsJTU
	G7H0Zo+T/fw3XJrFrgZ6NM8MDoSkI3XJhVlVpDPaxVI2xnPjTpGUOUazpakg+o/v
	CwhEQXSFBKAnID7jcammvrTi80ngXF2rUW1Us+Q==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:WXiRCt65aIuuP/KLOyvYJ+boXDkfpnYKYOXX1OFBdJg=:XOuzhh99rJxjM1OJOjUBCkD6jR38xrBVdi38tIRFCE8=;
X-ME-Sender: <xms:nkztanXY40l2etqachp2PeccqDxdFOOYKJ_jkSL_oHss1TMvL33kKQ>
    <xme:nkztah1MJitVM1XQAE98O4KTfGFy6KA7uWsXuMy5z6auNkdMa9w8bOUh-s6Y9iddU
    Geu7TphToUZqbgy-JAO50etWQVymqUXyiPvpGSVEj2_Ug-_Y5CpeyPy>
X-ME-Received: <xmr:nkztalpSsAPeXwNFW3yY5rbpc-ewFRbvZymaeUq8lOXQxJmv2i1TDOl9uqcESmw>
X-ME-Proxy-Cause: dmFkZTE3kdnyejC7I/OD5vfIecI86Y7WDW1ls9R/GjrFdnuFmrV2e7laF/dDaPvsdEFkCw
    MHzQllhLwxjMkQ0RA9Znt4DrbA8uUdQoJIenuLeCHgWUBpesRwCeBxqFo++FgkmwSNGmpB
    qiTg2+TsoYxbnZVjBS7V0Q6vy889aUmIlINYr50ZbA1e+u/aG/ZNfBdhlB1/ayxTSEzcMR
    EzBfBhpUz2kODykjJ7CZBlbnI8m8fJavYxNPP1F7o3Pgz3ussNolkpP+v6B7AAy+qSjfTk
    6w3HGtdpWegPiqMEys8wT64VyiJsmPV4UoLYboAriK5VH0e+UA1tlaHdJUpGYIroCRJquI
    tmS79PtX1tDJtyl1Hk+h+Em7I9cvaFYPh96ceSuirduH7LADVqD4vYEgLlaBsbb4wMVu+e
    EfQvFuTRbGbqKv4glWaZYM8n8uGPlCi6CiSnfq3GTWwrKAID34WCr5U2xIFNRS7+ix04y3
    UdJn+UT/syOmQgw51BiI9kJGaGyQZu2WYsPa5MT8BBi4l4zyJ9OZSrcCcSjSH9j2UxKujF
    wykEmMVhIV0DiheyIuCpUWUIiNdRRey6YFgUGg+ZqmniCLfsM5UAvkC0mfhbZ4+5lx1+VS
    q9PnSwUeb2lPCg9BWIxarNpDuv6YuWODD3vQ78Ijqy+wG3PM0fD2bjcxMQpQ
X-ME-Proxy: <xmx:nkztaoVat4HJ9u2xpPC0kxr0bnObQnHfkHXUtB8eUrSSoyEV_q8DOQ>
    <xmx:nkztagbdtQacFAskJ_fBfz_xcBCBKx3XPDnFVagNnUDMcaGwLfEZqw>
    <xmx:nkztalff14erzw8DQNKWDTMQlq-8fQBeL8r9xhG9oB9q_86psJb2vA>
    <xmx:nkztaq2doJNLaT9OYFHBA9vPxXUbo-_B-irehAGzwd3vThkOe_n5Kw>
    <xmx:oEztamu2ushQjXVmiDs7aP69f5LTPw2fI3APMPUhU5x_ka1gBwml2cnr>
Feedback-ID: i53594642:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 5 Nov 2026 22:42:22 -0500 (EST)
From: Walter McKelvie <walt@mckelvie.org>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	ebiggers@kernel.org,
	Walter McKelvie <walt@mckelvie.org>,
	stable@vger.kernel.org
Subject: [PATCH] crypto: algif_aead - Allow gcm(aes) for privileged users
Date: Thu,  5 Nov 2026 22:41:50 -0500
Message-ID: <20261106034150.1159818-1-walt@mckelvie.org>
X-Mailer: git-send-email 2.55.0
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

iwd (via ell) implements TLS for the EAP-TLS/TTLS/PEAP authentication
methods and uses AF_ALG for the AES-GCM AEAD of the
TLS_*_WITH_AES_{128,256}_GCM_SHA{256,384} cipher suites.  With
af_alg_restrict=1 these suites are silently dropped from the
ClientHello, and authentication fails against RADIUS servers that only
accept GCM suites (common for eduroam deployments).  This contradicts
the stated intent of commit 2f204fe718f5 ("crypto: af_alg - Add
af_alg_restrict sysctl, defaulting to 1"), which was to keep iwd
working under the default restriction level.

iwd runs with CAP_NET_ADMIN, so add gcm(aes) to the privileged part of
the AEAD allowlist, next to ccm(aes) which iwd also uses.

Fixes: 2f204fe718f5 ("crypto: af_alg - Add af_alg_restrict sysctl, defaulting to 1")
Link: https://github.com/NixOS/nixpkgs/issues/583203
Cc: stable@vger.kernel.org
Signed-off-by: Walter McKelvie <walt@mckelvie.org>
---
 crypto/algif_aead.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 5574e2d70539..a5c9e29b64be 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -36,6 +36,7 @@
 
 static const struct af_alg_allowlist_entry aead_allowlist[] = {
 	{ "ccm(aes)" }, /* bluez */
+	{ "gcm(aes)" }, /* iwd */
 	{},
 };
 
-- 
2.55.0

