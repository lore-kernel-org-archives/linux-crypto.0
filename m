Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9BB231A21
	for <linux-crypto@vger.kernel.org>; Sat,  2 May 2026 16:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777739638; cv=none; b=l8Be3IPoW7YFYtcltnFxO71O6CVoHxSyZGukFl8ItAbhY5FqyoxCeDw1+HzvnhfkCGgwcMg7LKdc+khjnx1KjdkziWHXujr6JgqnNldyzimqBFruVwLvMAC1qtyML9cTh22PBIxRRh9iG8PMvAyIfl48vVQkOk8F6SrzwmrlKKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777739638; c=relaxed/simple;
	bh=u+xQMtGqXsh+gMATDVhNpZ2LVrpcAWd4ZqvM//zvUto=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uVQWOn5DSc3X3lIXGRMHZTwvpGYXkgTOQ92gvmvdlpAOpWC7Vul20Il5BWbbwv3L++ATCz0TzwWr7WnXCcgXtSFH6++CdXqWs+ToHthZds2IfrsU9Hz4gxtNsD0IjaO/nDY17NmdD+gckapMJVQS2oUT3YfOzhiy2QLdTET1/3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gTRf6LOt; arc=none smtp.client-ip=74.125.82.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gTRf6LOt"
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-2ef84d016d9so2453712eec.0
        for <linux-crypto@vger.kernel.org>; Sat, 02 May 2026 09:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777739636; x=1778344436; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=U8qblfI6Sw5tc14k/l+jvxt6BzLYWjeb+CuRiMdqxKY=;
        b=gTRf6LOtqDrY1/FVZ2ultTJVr4smb2ry2oD9B0vXfGlhz+raX2VMZ+7nazAjbW3XQW
         EayWEFHW8KMNlJIHvlO0Q58c9iz0/jM7ABkSdAbDX10yCMlZHI3BXPGlVYSeBhx4R9wU
         U2u/mvt9gienSmNSX0ClnRedcNi8EDPGcWrwRv26BPRoynmwhVTYJTkAAxZpt4NC1n1I
         2jrBOi4tuTgPcmr3Qa/3ENnwWhUpx/8JPsrkYVA5aK/gzXRfi/kipj9ItCQNijbKRDan
         XapvJrADNBAIKAes/rYyz03mEKp8TMNAfV8CnQoeTAZUey9ZVpgcx5IwhMXslNGC/QYP
         5VOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777739636; x=1778344436;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U8qblfI6Sw5tc14k/l+jvxt6BzLYWjeb+CuRiMdqxKY=;
        b=swRIv+9axRpkiWAE4ps/fsc01RlSSz156jEhBQLSfx7Reod9YJ6fYdpByCk2NfMOC5
         rQVb0gtprQgZfjJCFr7L0TqIuy68d1nbARnZ/dKHRdv97rFzV8Vlqsm+38OpoE8yk8ko
         bcA+q3+Of2V4ShS0IRnNItdomPqe+RH0utIYLrjlpqWHGk5MThGWxzC94fKkxoJmcE0j
         HhT7Z4ILhtSv+opi5G+TkegIAwRp7x0h/YigHkSUuHm9mHhqbJHwoG+jeB0GY2Ty1xMR
         vdETQ4odUlvKDPaJjAYUSzR9Zn/wuy9XOGB/xBjQgqpCjz0AppQgb809305XJqrXoP+A
         i5/A==
X-Forwarded-Encrypted: i=1; AFNElJ8HWilaeYajdnDJlp3xnkCVr03WtjL4teyoA9zjNIeelb8FHxKQGB2/2c2YlbyKKgk1z/21zCizsfzVErQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9NJ6yFH4PgFt7eeyNPvMx5FyWj/4VbmXpsxTcSecQbtr/zkar
	Ki/JFoM4+cW+i8IS9xTtoUM8JuXxXoq9gvqoG8n8c0WwVTJrIEBclAFT
X-Gm-Gg: AeBDiet8eatxP4LEYI0xJqTbB/5wSjkt4pcOek7VgBaOt4IqqPgQaEm2TwiN5WetAnR
	iB4jsNpEco9AgnIbHlmBScjQE5/eFmhT6t4QEzwZEWy0t+1aIeK3NtcMaiFrokUi5GAwmCOpHeU
	3ZqgHsoqAUkuCxt4w3SKe0NwTL+1ATEuyX4cN39513L4Q4q/G5k3RdmG/usbaA9COo9e+VmFFn0
	b6qlJP3Xp66MuUlRZ9gNMvt3eLdCyJXjCHVuUxLorBjLAeUxIPrU5fbZ5Vs2NuBe/PBs1zOruti
	OZET8KGu65T6TlzYG061+xHYI4ckWnf19Krv6YbAsm/CA2T0Q5Wo9hjbmHgRkbNigSp9vRQV48j
	LAEQ8er4v0ipRfbh0LWlm8nkVhc/1PdrkRSyaogGkePvgXMa3AEmW3KC2DWW4GsnxnQkdvSfT4P
	sLEsIm/hwEd/hz+tIYe/6oVcE1wiZ5wi1SkRUp6bkOS90/7oSp1/v0UkEAEjGzQRL/911TVhpMy
	YQj14SQGzDu4HbKLfApZBI0YbdcJDw=
X-Received: by 2002:a05:7300:f194:b0:2cc:600d:2ffa with SMTP id 5a478bee46e88-2efb999d860mr1735093eec.16.1777739636548;
        Sat, 02 May 2026 09:33:56 -0700 (PDT)
Received: from efaec68ba852.tailc0aff1.ts.net ([206.206.192.132])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ee3b29b1a4sm9008804eec.18.2026.05.02.09.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 May 2026 09:33:55 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: David Howells <dhowells@redhat.com>,
	Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>
Subject: [PATCH v2] asymmetric_keys: check asymmetric_key_ids() for NULL before dereference
Date: Sat,  2 May 2026 09:33:29 -0700
Message-ID: <20260502163328.696098-2-bestswngs@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

asymmetric_key_ids() returns key->payload.data[asym_key_ids], which can
be NULL for keys parsed by the PKCS#8 parser (pkcs8_parser.c explicitly
stores NULL in prep->payload.data[asym_key_ids]).

key_or_keyring_common() in restrict.c and find_asymmetric_key() in
asymmetric_type.c both dereference this return value without checking
for NULL. An unprivileged user can trigger a NULL pointer dereference
in key_or_keyring_common() by creating a PKCS#8 key, restricting a
keyring with key_or_keyring:<pkcs8_serial>, and adding an X.509 cert
to the restricted keyring. CONFIG_PKCS8_PRIVATE_KEY_PARSER=y is
required.

The following bash script can reproduce the issue:

  #!/bin/bash
  modprobe pkcs8_key_parser 2>/dev/null
  openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:1024 \
      -out /tmp/poc.pem 2>/dev/null
  openssl pkcs8 -topk8 -nocrypt -in /tmp/poc.pem \
      -outform DER -out /tmp/poc.p8
  openssl req -new -x509 -key /tmp/poc.pem -outform DER \
      -out /tmp/poc.der -days 365 -subj "/CN=Test" \
      -addext "subjectKeyIdentifier=hash" \
      -addext "authorityKeyIdentifier=keyid:always" 2>/dev/null
  PKCS8_ID=$(keyctl padd asymmetric pkcs8key @s < /tmp/poc.p8)
  KR=$(keyctl newring test_kr @s)
  keyctl restrict_keyring $KR asymmetric "key_or_keyring:$PKCS8_ID"
  keyctl padd asymmetric trigger $KR < /tmp/poc.der
  rm -f /tmp/poc.pem /tmp/poc.p8 /tmp/poc.der

 Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000
 KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
 RIP: 0010:key_or_keyring_common (crypto/asymmetric_keys/restrict.c:205 crypto/asymmetric_keys/restrict.c:279)
 Call Trace:
  <TASK>
  __key_create_or_update (security/keys/key.c:884)
  key_create_or_update (security/keys/key.c:1021)
  __do_sys_add_key (security/keys/keyctl.c:134)
  do_syscall_64 (arch/x86/entry/common.c:52 arch/x86/entry/common.c:83)
  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
  </TASK>
 Kernel panic - not syncing: Fatal exception

Add a NULL check in find_asymmetric_key(), mirroring the existing
pattern in asymmetric_match_key_ids() and asymmetric_key_describe().
In key_or_keyring_common(), skip the trusted key matching when it
has no key IDs and fall through to the check_dest path.

Fixes: 7d30198ee24f ("keys: X.509 public key issuer lookup without AKID")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---
v2: add bash reproducer to commit message (Ignat)

 crypto/asymmetric_keys/asymmetric_type.c | 2 ++
 crypto/asymmetric_keys/restrict.c        | 9 +++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric_keys/asymmetric_type.c
index 16a7ae16593c..22f04656d529 100644
--- a/crypto/asymmetric_keys/asymmetric_type.c
+++ b/crypto/asymmetric_keys/asymmetric_type.c
@@ -109,6 +109,8 @@ struct key *find_asymmetric_key(struct key *keyring,
 	if (id_0 && id_1) {
 		const struct asymmetric_key_ids *kids = asymmetric_key_ids(key);
 
+		if (!kids)
+			goto reject;
 		if (!kids->id[1]) {
 			pr_debug("First ID matches, but second is missing\n");
 			goto reject;
diff --git a/crypto/asymmetric_keys/restrict.c b/crypto/asymmetric_keys/restrict.c
index 86292965f493..ccf1084f720e 100644
--- a/crypto/asymmetric_keys/restrict.c
+++ b/crypto/asymmetric_keys/restrict.c
@@ -243,10 +243,14 @@ static int key_or_keyring_common(struct key *dest_keyring,
 			if (IS_ERR(key))
 				key = NULL;
 		} else if (trusted->type == &key_type_asymmetric) {
+			const struct asymmetric_key_ids *kids;
 			const struct asymmetric_key_id **signer_ids;
 
-			signer_ids = (const struct asymmetric_key_id **)
-				asymmetric_key_ids(trusted)->id;
+			kids = asymmetric_key_ids(trusted);
+			if (!kids)
+				goto skip_trusted;
+
+			signer_ids = (const struct asymmetric_key_id **)kids->id;
 
 			/*
 			 * The auth_ids come from the candidate key (the
@@ -290,6 +294,7 @@ static int key_or_keyring_common(struct key *dest_keyring,
 		}
 	}
 
+skip_trusted:
 	if (check_dest && !key) {
 		/* See if the destination has a key that signed this one. */
 		key = find_asymmetric_key(dest_keyring, sig->auth_ids[0],
-- 
2.43.0

