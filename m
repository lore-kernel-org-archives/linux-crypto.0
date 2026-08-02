Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A153D34041C;
	Sun,  2 Aug 2026 23:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785711725; cv=none; b=NMtF42lkoBtyyBYL9a+fHL2eXpmPsPfw5f+KS9eB1Wn5zj5aBpNdw12hTfW4FOv2GckL1qUnGMB7wtRPQJ0Tg+uzFkZtbmXfG6Sko1xR3AzBtKZvUv1HoXMLnVDQe0cTgeZ50y/yvGR+Z/nE08a7wKitJWoLNrZre8YB2CrQgN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785711725; c=relaxed/simple;
	bh=lLal+leuJtehj+DFCsY8ciP1Hzfu6ttl8xq811k6TLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k1UT5NHKE8F/TQ0rVxThL3ukZ+oUyiNzYorcnPpg/xOy9edp8Myan2LIXoF1SAtVGpEhcI51ZOGEYRcecCxWcW6CFf3EuakKmA9XR84gd8LkQeZvWE6xc1sFG7sAm2AhssQX8xfV+qP7oLsc1J0GxSVR5zNdZQDH04I0OHYV9v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KYek+Zlr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KYek+Zlr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D7C1F00AC4;
	Sun,  2 Aug 2026 23:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785711723;
	bh=kIzg9GOQSA3QUe+ILmEeajJXxnc5iqX0Du1fki1bNxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KYek+ZlrywcFl67vo/OkdLnmgJGLFCEuQ8oAi2ahI+CPsyqSd1zLhlYRU6+R5sqo2
	 JE9U3pABIFGOta6HSl2OFPkBb7/teb+bouDOGOROrKEtAp9FM9/Y4nXjxe4OPyJi7Z
	 zkrrvLFIT+k8LdnCokUmjguN+f6Rq7PgRsRIAKm7LQM2Vb5qi8DxHsuK9CSj/yy+r1
	 U8tNsKxt49K5tF5FOmVTinNrGNxIQReTbzVRTm9Kk65FLudPmF240smg1zYbLItVJO
	 oHddGxNPw8K70wX+H7oeW7D4GTI5LJCNsTlW/rBkX8ScYbvuq3Dr4AC0Nvv467dUtA
	 TkNdCTWoiM8Gg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Richard Weinberger <richard@nod.at>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 3/3] crypto: af_alg - Stop after finding name in allowlist
Date: Sun,  2 Aug 2026 16:00:55 -0700
Message-ID: <20260802230055.100746-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260802230055.100746-1-ebiggers@kernel.org>
References: <20260802230055.100746-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the algorithm name is found in the allowlist and the privilege check
doesn't pass, there's no need to consider remaining entries since the
list contains (and is intended to contain) at most one entry per name.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/af_alg.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 1e5da61b315c..ab84c4488a15 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -145,10 +145,13 @@ int af_alg_check_restriction(const char *name,
 	if (level == 1) {
 		for (const struct af_alg_allowlist_entry *ent = allowlist;
 		     ent->name; ent++) {
-			if (strcmp(name, ent->name) == 0 &&
-			    ((ent->flags & AF_ALG_UNPRIVILEGED) ||
-			     af_alg_capable()))
-				return 0;
+			if (strcmp(name, ent->name) == 0) {
+				if ((ent->flags & AF_ALG_UNPRIVILEGED) ||
+				    af_alg_capable())
+					return 0;
+				/* List contains at most one entry per name. */
+				break;
+			}
 		}
 	}
 	/*
-- 
2.55.0

