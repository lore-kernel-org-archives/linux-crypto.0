Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792887126;
	b=2Ie+TcNKlOFPBjHCfWwk5BJK5QHGfvhzUKB25fzuGqilIzUKCu0Ug4KboE01/LOEDKSG
	 SuEwmHh9n/GXqq6zIA8s3RlKZQB35ZEQlphQo8YDKAP0/yVD43rGk+TBWICG9Jg97XTam
	 Th0jWNNzAy94I6ABb0N1666AJGVaUvSVroJFpQZXT9trKnAz6Prn5xN+H7Myq2sxEVGPF
	 vApzF6LRWV3wuhUD9REhxUNFM6yNyt9tHJ9SmJwCmqvSjX4ajQ53ZgcJsAm5GIU2M+KSs
	 VcAKHk9YRzZ7mdTNglfr6FW2ScJBpEU7dQh4M/b1WCFffilQqk4fTTOjIavUhatSMqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792887126;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=ZyI2ZxRsCFGR8Z+gBT3qLKeB8C/aqFH9i5cqte353Mc=;
	b=WUTm/oeq2JKAFrZTk19I+yCeomclL1iOe4EnT52P/pyrGH1bo9ocKelyJiVw2nFouZPj
	 18wFPoqf0H+MH6gbjkkY80vRddQ66g9ru2LPQEsQATMP0Mp5y6bpq3uOe+OI1jltFFF6n
	 u5ykgcAZDeABMAa8vq6s5dC+lHk+TDWpDRXvGpNWjJ6cSZ4EBWu/b/dHWJKdEP1PCbO5C
	 uSTpKNOEcmBLOX/MYFkElOqLkvBe3Krpgh4cTCAb5ZlM/ErWbTdyc96e/0HST5/0IYtH2
	 8Wgr9BMWx+tK5KqWj5ycQCAFbKLAj5OZl8To5/HMi1cBew9EJ2Lb/AxgBQcn8sJdVXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SRXl4IHM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 51D4E606A31A;
	Sun, 25 Oct 2026 00:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SRXl4IHM
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 957461F01828;
	Sun, 25 Oct 2026 00:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792887126;
	bh=ZyI2ZxRsCFGR8Z+gBT3qLKeB8C/aqFH9i5cqte353Mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SRXl4IHMSUVx7kNXB8XeF3GLv4W/hn2SSp2MSA5poZ4A4/edwOyBu7RQ128K/p+5A
	 WaTiYbufxYBjEGEbMlFfVzJje8OWSO3k6wWAv4bO+AdcR5vwxmG4O/zvjLtSpoF/QN
	 5ZTFcl6XCcgS4L2A0EnRDtu7it44XkaE2pPWAHUncdOmYw0sjE+vv7FK/hWb9B8VaZ
	 iqeklSSexwn0uIqHacAk6uMDDN15BFnycJijCPp42imOwofqNHDBKcLlbPLVcAhoWp
	 X5ft1xMUOHl2tWfeMxhgbaoMxIxTayBZo12/AieJ02S3Sn52dnWy4hgy2uy7sSKRZA
	 EV2qULo/D5ZPg==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Graf <tgraf@suug.ch>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	linux-kernel@vger.kernel.org (open list:LIBRARY CODE),
	linux-crypto@vger.kernel.org (open list:RHASHTABLE),
	linux-security-module@vger.kernel.org (open list:SECURITY SUBSYSTEM)
Subject: [PATCH v3 3/6] KEYS: Verify the key identity in __key_unlink_begin
Date: Sun, 25 Oct 2026 03:10:11 +0300
Message-ID: <20261025001105.1824178-4-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261025001105.1824178-1-jarkko@kernel.org>
References: <20261025001105.1824178-1-jarkko@kernel.org>
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

When two keys have identical type and description, linking the second key
replaces the first in a keyring. However, attempting to unlink the first
key (no longer in the keyring) unlinks the second key.

This happens because __key_unlink_begin() calls assoc_array_delete() with
&key->index_key, matching only on type and description rather than the
key's identity.

Example:

  keyctl new_session >/dev/null
  keyctl newring ring_a @s
  keyctl newring ring_b @s
  A=$(keyctl add user A ss %:ring_a)
  B=$(keyctl add user A qq %:ring_b)
  keyctl newring R @s
  keyctl link $A %:R
  keyctl link $B %:R
  keyctl unlink $A %:R
  keyctl show

Verify the key identity before unlinking, and return -ENOENT on mismatch,
instead of unlinking the key with the wrong identity.

Cc: stable@vger.kernel.org
Fixes: b2a4df200d57 ("KEYS: Expand the capacity of a keyring")
Reviewed-by: David Howells <dhowells@redhat.com>
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Link: https://lore.kernel.org/r/20261020174325.2229448-4-jarkko@kernel.org
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 security/keys/keyring.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index 2c54f7f84c55..5281da9d5bf7 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -1506,9 +1506,15 @@ static int __key_unlink_begin(struct key *keyring, struct key *key,
 			      struct assoc_array_edit **_edit)
 {
 	struct assoc_array_edit *edit;
+	const void *object;
 
 	BUG_ON(*_edit != NULL);
 
+	object = assoc_array_find(&keyring->keys, &keyring_assoc_array_ops,
+				  &key->index_key);
+	if (!object || keyring_ptr_to_key(object) != key)
+		return -ENOENT;
+
 	edit = assoc_array_delete(&keyring->keys, &keyring_assoc_array_ops,
 				  &key->index_key);
 	if (IS_ERR(edit))
-- 
2.47.3

