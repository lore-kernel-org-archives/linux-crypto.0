Received: from bumble.maple.relay.mailchannels.net (bumble.maple.relay.mailchannels.net [23.83.214.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A55B2E0926;
	Sun, 14 Dec 2025 11:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.214.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765710907; cv=pass; b=cgzbZLv1t+Ybf32ZMCWesf8mG8JQrgX4UxoEBXYUjcYNyT6+fBnkF8dJ3adbhGKTrAgRTJoF+LeNVhJH70LlKnvSv0PkvtzIr8IiRzR0QFNr2Hr8/eHBKKEict2S3Yn+qiotRdoupU2gNwG1sicX02wx/ZegP/4MLPeRXhpGn5o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765710907; c=relaxed/simple;
	bh=3H1kYfFsOa0FYQSoYB3N8LvG7HnX3eNhtNfmlaHEQaw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=lhUFu6IAif4YBA7ELRlYsEeZhZL37CqYUOyqjBi8QXVW6D1zKrMu4K0y+2id44AocvpNH9aeS2jJjSR6d2CyV4VoA7vJynMTctTupFQlVb5OA/7dXX5jcJLTNvZAy8tLMsMix8zXmEjAcUn4xh4PlqjU/gNh3kFEoAmr69ZMLhg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kriptograf.id; spf=pass smtp.mailfrom=kriptograf.id; dkim=pass (2048-bit key) header.d=kriptograf.id header.i=@kriptograf.id header.b=yp3wmgQk; arc=pass smtp.client-ip=23.83.214.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kriptograf.id
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kriptograf.id
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kriptograf.id header.i=@kriptograf.id header.b="yp3wmgQk"
X-Sender-Id: nlkw2k8yjw|x-authuser|rusydi.makarim@kriptograf.id
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 518A28C1334;
	Sun, 14 Dec 2025 11:14:57 +0000 (UTC)
Received: from vittoria.id.domainesia.com (trex-green-2.trex.outbound.svc.cluster.local [100.102.46.124])
	(Authenticated sender: nlkw2k8yjw)
	by relay.mailchannels.net (Postfix) with ESMTPA id 468B38C135E;
	Sun, 14 Dec 2025 11:14:55 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=mailchannels.net; s=arc-2022; cv=none;
	t=1765710897;
	b=wQh+zK4buVmB7Ozj9AyY73LubUmYBtrsKSlHPjVf0ITGtXUgBEeQnEw65x9LDLPq/sMHxp
	V3iGL9gbPZxjPzGBZHZ7LVzgw0Fd+NWgsYCDAH3V0A8SyKLtFlNQyPQF0DBkt3awwsS5+h
	3pmnjjtrqa4DxRHQDS/BD6zY2oWL0dDWMk2YgtzKOh1fIlVlc1LdeOn02vgWzjbs6sSoua
	VGOComf9L5U1tgPf370Y/lClOpZ2nNkvWXdcYsM2XlEI7/sTRFy7Cr/XR8MYj6YCMSz35Q
	HFVxYJ4exHjTHnqmxZoZRV0U0fOwsO5LAg+jZFIel4V+WU4doqUwcU8cUnQYzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1765710897;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:dkim-signature;
	bh=FXAMxOpIdpERdlKCwzJRfNFYzaAYdhNPvJTzobn9t3w=;
	b=uAb9GWKmaeYGT2HdYbcHKoYwI6tEyOX6OR7rpSKgcqMve7Px31pFNp3HZsGtrMDLhMF4Il
	CeSy/7S4Gi89ubWJ8Rk8I1S5j2PBnY2U7UrJ6f8qRV8EJQcif5hJJp22Disf5Fte4opxae
	R/kPzmYR7lffdeHu2O0q9+D8Q58FKOqaWAL+WU3+X4+ZEzBbD1FMlyVG/wGFmG5foRiM/I
	sWqYL/cWy0tlXiXeAQ7tPDw4vrQwJIQxpo7xkQ8w7vgz62DaWzbSX3rb40NjV5+LypCjVC
	8K3k2WJXvAdqVmxFtXyEFdXhouWFQ/EJgzvdv+RsZgLJA5x2Nx9K8yxF/eKeeA==
ARC-Authentication-Results: i=1;
	rspamd-659888d77d-bd8ft;
	auth=pass smtp.auth=nlkw2k8yjw smtp.mailfrom=rusydi.makarim@kriptograf.id
X-Sender-Id: nlkw2k8yjw|x-authuser|rusydi.makarim@kriptograf.id
X-MC-Relay: Neutral
X-MailChannels-SenderId: nlkw2k8yjw|x-authuser|rusydi.makarim@kriptograf.id
X-MailChannels-Auth-Id: nlkw2k8yjw
X-Glossy-Tangy: 10fc6df17382da9c_1765710897170_2128734225
X-MC-Loop-Signature: 1765710897170:1756380708
X-MC-Ingress-Time: 1765710897170
Received: from vittoria.id.domainesia.com (vittoria.id.domainesia.com
 [36.50.77.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.102.46.124 (trex/7.1.3);
	Sun, 14 Dec 2025 11:14:57 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=kriptograf.id; s=default; h=Cc:To:Message-Id:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Subject:Date:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=FXAMxOpIdpERdlKCwzJRfNFYzaAYdhNPvJTzobn9t3w=; b=yp3wmgQkgKnmpM5m60B65zSCmz
	WePOuIdr34l7sxzX6Qu8/2w48QIcGP0zPCpBvyzCreyneZ98g70tL8LYJw096HpNbLqNwBglqDfZh
	gABQIKgD2DRNWRQ6i3chdxnLg9qxhJFiSrpwV/qvMrsZIPnP1jW3q4geeWJZ/p06yohRBtDbuI6GL
	sogaXRtfOoe3ioSBW/49xslPLE0Vf5ntDGfQqEZydExba+YnSW5OQIpjLpesnGNb2I8XAqs/y92iV
	C53wlQBSbgzZ84wZR6u6R4M/84UM1TdX16TBQLlCuC9RhUGb5D+rh+aKX1r67XEGYI/Ucmw29pqKU
	uIRvYVYg==;
Received: from [2001:448a:40aa:1055:c7f:b318:d179:5346] (port=51106 helo=192.168.1.8)
	by vittoria.id.domainesia.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99)
	(envelope-from <rusydi.makarim@kriptograf.id>)
	id 1vUk3w-00000000OkX-3ENC;
	Sun, 14 Dec 2025 18:14:52 +0700
From: "Rusydi H. Makarim" <rusydi.makarim@kriptograf.id>
Date: Sun, 14 Dec 2025 18:15:12 +0700
Subject: [PATCH] lib/crypto: use rol32 in md5.c
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251214-rol32_in_md5-v1-1-20f5f11a92b2@kriptograf.id>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI1NDI0MT3aL8HGOj+My8+NwUU91EYyNLSwMDg5QkQwMloJaCotS0zAqwcdG
 xtbUA7Fsmkl4AAAA=
X-Change-ID: 20251214-rol32_in_md5-a3299000db10
To: Eric Biggers <ebiggers@kernel.org>, 
 "Jason A. Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kernel-janitor@vger.kernel.org, 
 "Rusydi H. Makarim" <rusydi.makarim@kriptograf.id>
X-Mailer: b4 0.14.3
X-AuthUser: rusydi.makarim@kriptograf.id

use rol32 in MD5STEP

---
this patch replaces the bitwise left rotation in lib/crypto/md5.c
with rol32

Signed-off-by: Rusydi H. Makarim <rusydi.makarim@kriptograf.id>
---
 lib/crypto/md5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/crypto/md5.c b/lib/crypto/md5.c
index c0610ea1370e..c4af57db0ea8 100644
--- a/lib/crypto/md5.c
+++ b/lib/crypto/md5.c
@@ -29,7 +29,7 @@ static const struct md5_block_state md5_iv = {
 #define F4(x, y, z) (y ^ (x | ~z))
 
 #define MD5STEP(f, w, x, y, z, in, s) \
-	(w += f(x, y, z) + in, w = (w << s | w >> (32 - s)) + x)
+	(w += f(x, y, z) + in, w = rol32(w, s) + x)
 
 static void md5_block_generic(struct md5_block_state *state,
 			      const u8 data[MD5_BLOCK_SIZE])

---
base-commit: 3f9f0252130e7dd60d41be0802bf58f6471c691d
change-id: 20251214-rol32_in_md5-a3299000db10

Best regards,
-- 
Rusydi H. Makarim <rusydi.makarim@kriptograf.id>

