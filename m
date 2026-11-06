Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.141
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793939707;
	b=hT1j9fSKcBDPLgtpK23pd4m2xHN9BbpavsAVkFRCcfIpAa74fo6QzcBvxYIWCIG1D47o
	 SxHrfvUSZ3JEL22j2Kj7AdO/f14AVyWTnXsU0gxIlf4YgMwGi2vF6O/SlBkxHYGE8MImS
	 4hJkUfNHhvh6QSFbj2Jj+mJrBPPVzio2pzqmgtCn0HAFjOuSvLkpgoFbl0e+1+BVI4Lr7
	 7b+CAOQrfRs/0m/MVWsXfkKH8U/fcyR72favIn/ydjDBZ/m1o9yWiopnmNzsiklHyeank
	 7BdBLB+G/wrS4x6Eq9B/QuQVgUwMPl3XEL8uyOsFD377bBlamiM7dfSu9ets7NErIuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793939707;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=o4DacgDvHCDQhKBhZ41AudwyIb6U/1NjeUOXCuVps1c=;
	b=TgVjYPR0DnzXHrWepPTERPGKiVo9I9pPPdUgwTIqArQmzIJTCWRx16fw4s8QAe01kSLe
	 EtLDT0z+YrKt65fH5ZZPAQt6rcxpAqOZxWHnDOiiMenqoGUWEgzXeyEdxIZvvDp9YMleV
	 7zc4/w6pnXDomF435uo2+cZjl5iQ3mIXg93+51MQlFBwSud42UcZmaRfP1QxM3m03OyRZ
	 h7NddZKq9U+FCIbnjOnfZEMbRuviq2lisPQR1BQWBnI2Y2HcfapE+pU/p8CdRIyWKJgBD
	 sscYthkgRJmEZE5U28WmofTjdw/wGfhlqo1gfIoBW6Br2tBKptuJnXb1ArYfoLsHlYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=mckelvie.org;
	spf=pass smtp.mailfrom=mckelvie.org;
	dkim=pass header.d=mckelvie.org header.i=@mckelvie.org header.a=rsa-sha256 header.s=fm2 header.b=C87uJsch;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=T+7CCIrn;
	arc=none smtp.remote-ip=103.168.172.141
Received: from flow-a6-smtp.messagingengine.com (flow-a6-smtp.messagingengine.com [103.168.172.141])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4955606A326
	for <linux-crypto@vger.kernel.org>; Fri,  6 Nov 2026 04:35:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4955606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mckelvie.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mckelvie.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mckelvie.org header.i=@mckelvie.org header.a=rsa-sha256 header.s=fm2 header.b=C87uJsch;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=T+7CCIrn
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailflow.phl.internal (Postfix) with ESMTP id F166C1380E11
	for <linux-crypto@vger.kernel.org>; Thu,  5 Nov 2026 23:35:05 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Thu, 05 Nov 2026 23:35:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mckelvie.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1793939705; x=
	1793946905; bh=o4DacgDvHCDQhKBhZ41AudwyIb6U/1NjeUOXCuVps1c=; b=C
	87uJschfOEfORMHAdV2Yjjkhfevesef8ycWW0rBYKblJTeURV1+6KZlPBPZnFom0
	Z9cH2yEo1p5jXWVM2euqk5ocVtkUsdgT+JqwAtVh7KTrEv/NdJMyHJoFgvnZc7hm
	lmCcfyjveleFH0VMylNC9sxUyk/11EXalt4Yn/e86qm59wwlGYRMqgZiLSbDBAII
	LB3t4Rd8y9HpyThAd1sP1OSlgeN9Ny+TWEQyVN6AxIkWbajfWoQ3wvkVahKyZn2H
	vm3u0iMK00BklZRrKssBSzvnng93uDhOPxLflknIIyhlLpdjRjsamZt0nKbotYxB
	Ba4iTLIHfeA0i0wlosHYA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1793939705; x=1793946905; bh=o
	4DacgDvHCDQhKBhZ41AudwyIb6U/1NjeUOXCuVps1c=; b=T+7CCIrnhsQraK4EF
	0tCQzLJPRlhJ2H37nznnvfAcHno8PkiXanOxWOgksm4VFLo/VX3CEFIC8KkVHxO0
	ZvRctOYJSnIjj8ge/tSg0aJpOiXiAJRVQPhrLczEXeYBZoTltPZH14n2s/ti6yrq
	zZIfg58qs4jOPtLrugkeio5VGNxWKTnz7quWjkw2LKR9C0Nw0/sYhtaPZ3xO0fG7
	dMSVlAJYlTRKFXYIGBR0cXTw+R9yPEWjdWDrqPJhNjOCTqbag1g9K1MpwODYeYb1
	GTto9ybembaMeCpWF+HD9w6rTsRlLmAoca99l4Som+IYSpDwRa95SjHVJmyGXDhd
	k+EYg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=mckelvie.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793939705; d=mckelvie.org;
	mf=PHdhbHRAbWNrZWx2aWUub3JnPg==;
	rt=PGxpbnV4LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmc+;
	s=fm2:rsa-sha256:J8vWwpkP7amHaQcj/drIJwaAg8FJBHMogsHry1cV3r6Rb1W
	j6BEt50O/gsM3pOVOGk62A5V5V+MjIeHFumeNXLr3LlyFK6d/Jx2fHReAqajzDEr
	6zJwBBZmn6ZwoHncLS6iqrdr7qMBeuRT61/HWEwpllhhPa7Ok64EBw65HsIJm/ad
	7cS6SeNgGVZYa/Co57JUUmeKRLHZzGamojV2IaX9v85SkNE3ZQe+vlnosXM7/MUZ
	Mwvz5ErRe6IxMvR5P0ZMRLg1DE2VNnOw5JdPgm5xL3mJj9wJz7STVmsnR6aj8LDL
	sjym9yPlMkkQ1ZmWe9RR9CbTUnOuh8ojoj8G5vw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:PDgbLV8MQ50kb8GFquuuXNvS4wVw72yCjce+ck0xh5o=:ulCxkWKELufH2tFecSMSmT8EddX/SIfCGpvYqVMOmnI=;
X-ME-Sender: <xms:-VjtakHnKqvdb8yeC8ax39LXtfu7kVrbQjNQ_YZ3VMAp5fkE50-NwQ>
    <xme:-Vjtavngwvk4_UKim-6yBupvMrnjxVkFxO0zQb2gcPHAbRGAbP_fKtI2d0hAvLtcW
    dn6_FU1q-rBpr_JyYBedu1c77oOe6jEoDmntk9H6UHlA7dE963AVy8>
X-ME-Received: <xmr:-VjtagZc6ax1KZXMCl06_11gJiFVR-f21S0MbTWHZgXxz70wgilRwzsUGPzmskI>
X-ME-Proxy-Cause: dmFkZTEkdJ6ylFexU9TrydWpM1vAX08b4Tde+kdH8tNb/tpjn7F2fXqf3ydRg+yirYTDzc
    W6b8EEF3rKyobbD+TLO47eDGOW4U0v3jPR1Ihwig566ESG4kd1NNXnczYteSLW8dvCmhXf
    oE5mu4JneyjpcxxKk5T8b8wq/NFPOqtakY2CqAOeSGA6WaMuJ36pwd3/23PQDHrDE82tOW
    B2wJ6NhfT6+/4nAUhdS7th+ctKiFWoliwfW7pEqm3F5pRSafg5l0qbIxs6+Qc4ra0Io0PF
    dsolH4O5h/BUu1oSFmFFAFxL4OCHknGxITHjRL+d/7JuUF9cQq/qI8mW73NSPZk9H9xnas
    gMP44EDZHHeQHhH1CgVM4LobDi4cB04l/kI3oTv4VADULATh3g3G028snWHp22jurDIEx9
    lS11nHRI/EcrplkOhfWtAu3lXTX3ca+hM9QQej4f43R48dD2OXIlnaBjwJkCFXG5+zvn+Y
    yOAdzdmWs3c+aRuG8eEy04mXWL5DZBcWrIYjueSuHCvWqHByc1ip4WYRwuUHMYqgRBGl0v
    icYmvPMVoAmiEAFmgCavv8I3LjHqjpyrT44B3ERyiOiya3kgk4BQrfJgnCKkSqq4e2lnwM
    77gy/8CxVYXdobNnP1abvyvyohkwU2RiqitICYXEjOVmXCP+eSbs2kjdbXHg
X-ME-Proxy: <xmx:-VjtasEAQeCDOW063FD970PiwVehclSwFnKfnNZeKKbYJZfmcQpjyw>
    <xmx:-VjtapKM-zlAGEvnHb7AH3J3DsEpTBqtU8Pl6lHfa4wOmsxudsJK5g>
    <xmx:-VjtavNlSzW3NprAB5iwRMYCczKQ1bSxvzWaDnPl8wckFZGmQgGvkA>
    <xmx:-VjtahkWkZh4YoOVN--4TDro8Q0WiKr56nEHUkMVDB9CX91gmiwLag>
    <xmx:-VjtaieE0qVyqy-eRFMiS7dWkxipzZHhBWflPzfehwo3Xh8kcTKsZe2b>
Feedback-ID: i53594642:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 5 Nov 2026 23:35:05 -0500 (EST)
From: Walter McKelvie <walt@mckelvie.org>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	ebiggers@kernel.org,
	Walter McKelvie <walt@mckelvie.org>,
	stable@vger.kernel.org
Subject: [PATCH v2] crypto: algif_aead - Allow gcm(aes) for privileged users
Date: Thu,  5 Nov 2026 23:34:59 -0500
Message-ID: <20261106043459.1169202-1-walt@mckelvie.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <2e4c2648-72b2-4249-89d3-8dd111b84395@app.fastmail.com>
References: <2e4c2648-72b2-4249-89d3-8dd111b84395@app.fastmail.com>
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

iwd depends on the AF_ALG algorithm "gcm(aes)", although iwd's own
source never mentions "gcm(aes)" or L_AEAD_CIPHER_AES_GCM.  The
dependency is indirect, through the TLS implementation in libell (ell)
that iwd uses for EAP-TLS, EAP-TTLS and EAP-PEAP: iwd's
src/eap-tls-common.c hands the EAP tunnel to l_tls_new().  In ell, the
TLS 1.2 cipher suite table in ell/tls-suites.c uses
L_AEAD_CIPHER_AES_GCM for the eight *_WITH_AES_{128,256}_GCM_* suites,
ell/cipher.c maps that to the AF_ALG name "gcm(aes)", and
tls_change_cipher_spec() in ell/tls.c instantiates it with
l_aead_cipher_new().  Before offering a suite, ell checks that its AEAD
could be bound on an AF_ALG socket (l_aead_cipher_is_supported()) and
drops the suites whose bind() failed.

With af_alg_restrict=1 the bind of "gcm(aes)" fails even for iwd, which
holds CAP_NET_ADMIN, so the AES-GCM suites silently disappear from
iwd's ClientHello and EAP authentication fails against RADIUS servers
that only accept GCM suites (common for eduroam deployments).  This
contradicts the intent of commit 2f204fe718f5 ("crypto: af_alg - Add
af_alg_restrict sysctl, defaulting to 1"), which was to keep iwd
working under the default restriction level; the iwd algorithm list it
was based on evidently did not account for the algorithms used by
ell's TLS code.

Add "gcm(aes)" to the privileged part of the AEAD allowlist.  It is
the only AEAD that iwd actually uses: ell's TLS code has no CCM or
ChaCha20-Poly1305 suites, and no other ell or iwd code creates an AEAD
cipher.  (ell does bind "ccm(aes)" once at startup, in
init_supported() in ell/cipher.c, to probe which AEADs are available,
but nothing uses it, so its allowlist comment is left as is.)

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

