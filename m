Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DD841B36D
	for <linux-crypto@vger.kernel.org>; Wed, 29 Apr 2026 18:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777486623; cv=none; b=QzKqf29uQ+/2UJ0f7o6xAE2bhMSCLDma8UtPPi+vLkHz3n3S2/HkmKYAW4mpNWO5vmw2yz2mZuYnbsyZL3a+UD/HPFRhF0piEvAcavxAyADF2pTCfA8yv+ALdWoATGM8DVkywjksPTKq6IoJS98TxnfJab4NySa1OAgo/xEqPcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777486623; c=relaxed/simple;
	bh=VOKbcR0YI+YuvmodCjPRijspSYgm7HYwS+yOVO9jSOU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cGtmD3SWUaZJFDQd5D1cvKUhoz03TNjKpVinBYU3QE5v8fhjGNj8BU4fTIgtQk7pUGxK11uWl4kVbDXO5RCSkcMkjXMKcC6mihiOnliTG9DrkCH3380h3jh85CULV7WH1Ulww/qy0/WDGOMI33fqw8nGPrUOOCxo9z+kLWy+A2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VMuJ7PoG; arc=none smtp.client-ip=74.125.82.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VMuJ7PoG"
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-12de530cbf1so146979c88.0
        for <linux-crypto@vger.kernel.org>; Wed, 29 Apr 2026 11:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777486620; x=1778091420; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=U3x1o891z7jO+x1WN2dbr172zqOri+EKzTP7TtRTF/o=;
        b=VMuJ7PoG5bRnwdnaqUxgnUC2VN+YCaAqwOiELQtVa7Y+YeB7hnERR/y/ju7wczibRY
         tWrfCtokWSlhX9m7IiyPbm0TVJlVoSMVOYD+82EY9YEP6gCjCOfUsKdeX6s10xjXLfpe
         oh8lnu95Nx3iTyF8caZZYBfoQBpAQuGGzRtL59dWAAiJY+dcNu174r8W9rrvCGKICxvV
         OAzfV5GFYzSkmb98v+4x7LHK2y/VCZRRbsK61BiyzEPmUYtnmM7z8iJHc1ieCCjk2Wcw
         4cphZcrRHr8PHo+06eLZ7BepnbLryjFyzbckIl/nndByhTqhRKVQb8xI5rMrdeatpms/
         pfUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777486620; x=1778091420;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U3x1o891z7jO+x1WN2dbr172zqOri+EKzTP7TtRTF/o=;
        b=H0HmQuNBwqbsMYGCag2bZqmc0RNlBg+iPQvi6GbswadjXz/5LHHkT95PPdJlTbpBKH
         H+P668XCYOB47cBsVG4QDd4/FSBv4wIv5GCrAIW2wufxFT04hu+nn2/TcDEraesGWS9Z
         lgB8SOn98xkU8WgUGwGowVuga0P6zW9BvQOve02rJAM5mtchdOobvYZVnTl0ijK2S8BK
         ILFEWgdcnTCwLnoYi40bDJImm3WwPymU7M0qi9RsCiR1iQv2OwJqQxLqODBgs9JyWtJE
         IJHOrV3IDOlI1/V/Xarm+q4H+QVyVVtB/JOEEufNcgmjMVkZ7OmY1SS3112imjpA3us/
         pL7g==
X-Forwarded-Encrypted: i=1; AFNElJ+C0K2Y+Y9CruuRGjGpVVo1lOzrx2DscIggbZH6QC5hwPCZNvanZqPTLb0uI2lacy+ylryoaAcGJDBjtVk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyr9J4nfV+6EGcorFdLdrS0B7+ENOdt/c/P8/UuLpPaB89Y7x04
	aiudXWmfVVLFmtirqnuv+DZzcdfxFD67DP21NPve+N/EW+bDHogvR80C
X-Gm-Gg: AeBDievWkMWH2wA5vUeJyukOMenoLO1Fy1gMhG8LxDFO+fiFDsg43nSHKUA95Z/PIkV
	hxxftpbr9QqUwsiGkBX4c/o7CAXiAWie3rDPcfAFsXZUp1dAs/e2VkibF9fbj+QjYrYk7a31AWk
	XdRLCVXyZc6B+0Kghl3jok8mSObHfq9mKuDThskY9Mc46XuSvCSH1LiWE03ume2Plo/qW+kjPpk
	PIWkE0k0oo4dhzt7CyN2YOlPL+3CaspBPBFP04XvRJnWcpfT5qHynGczxCOvF64TF99x2dVQ8RV
	49dHwYmNxr8hQQ965t8Q4WfiKXVFjEB3+rlMKqBmQy17vwIf1Ij9G7bfUP0fa+k+WnZcGlfDuuK
	OuyFlS1M8u3EyqjZSm7lR6IqK97IOyHt3FqcSiQukpqU2VNKKHUP/A0daJons/0XvInfIuKm0u0
	AfqaWnhI73uocAPlcFiL+rHnnmuZTYhBPPkVVl+1ZqszJDm9fV3NnHDAovmGNHxRQWQ1qnZxYBQ
	LjOcHOZa8spkBM+6hU8I7yEuwpRHHY=
X-Received: by 2002:a05:7022:6881:b0:128:dedf:f56d with SMTP id a92af1059eb24-12ddd991628mr4408396c88.24.1777486619386;
        Wed, 29 Apr 2026 11:16:59 -0700 (PDT)
Received: from efaec68ba852.tailc0aff1.ts.net ([206.206.192.132])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12de320f2a7sm4125005c88.1.2026.04.29.11.16.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 11:16:58 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: David Howells <dhowells@redhat.com>,
	Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	Andrew Zaborowski <andrew.zaborowski@intel.com>,
	keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>
Subject: [PATCH] asymmetric_keys: check asymmetric_key_ids() for NULL before dereference
Date: Wed, 29 Apr 2026 11:16:30 -0700
Message-ID: <20260429181629.110802-2-bestswngs@gmail.com>
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
 crypto/asymmetric_keys/asymmetric_type.c | 2 ++
 crypto/asymmetric_keys/restrict.c        | 9 ++++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric_keys/asymmetric_type.c
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
2.39.0
