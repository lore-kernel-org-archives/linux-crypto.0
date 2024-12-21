Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873E21F2C38;
	Sat, 21 Dec 2024 09:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734772296; cv=none; b=bBsj2d/pP4khvGu0xh9YW+jVh1ostzmU+BYLzqFqfmt15yMl/B/r3y0ib747ZCweD3mU+h9j8stu26Mj4bEv4a7AULJDZdQBZdJzrSHDjTJnt6IMU9p2eWZs9EnIC4510DKo01PtAa627xO8BdX30cY8gkhEh2tBX9fBr/1XyIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734772296; c=relaxed/simple;
	bh=xG4c1QDQkeqmFr3xpqJo4Ptz4ABndWUjgc6I+1XA6i0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q13RyUNfasMh8rf4UaWXPtP8h4tVlzVTBZf1uG4HVnXSln9ItW+xjDLBXMZT0BXph2SC2KJqb5UE5f/g+ROTIlBhwJZsXEC7RM7btydTVWTOF0VNCkmk6J7qunSfn3gpJPC0N/JoLil/8F3URIYmZ/RUYBzSmJp9NIl3xj6SsFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JUY4X2ds; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JUY4X2ds"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46698C4CED7;
	Sat, 21 Dec 2024 09:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734772296;
	bh=xG4c1QDQkeqmFr3xpqJo4Ptz4ABndWUjgc6I+1XA6i0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JUY4X2dsvUZCVkG3vD1om9Bjs10e0juTq7qRZNtdgmsiyKsZyfKEycU7VPSp4phFB
	 oJw0HYdxyr00hIr82r5OraLaJolhjLjN3OiVvPXfZ/GfgQ3dqAWcdihu5moFGXmied
	 NX5Lqq3P0OvqyPQjjoFXA8hybbTwJ+J1SoftNh3G/RbMBIOifTcmdt6e4oszUOfiTu
	 CzxMEuToQZOj36wxN6rwXPBrHBnb9HRhT2/u1Nw26731jAo54twSPmgua5bDvu8CM6
	 8g0G2TPcpcJJOHqfpmi9cAyYwEuXzzWCq3sXW63dAD5rfsxedXNtU9axBb/rf1c8Kf
	 JBpxg0uaCtpIQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Boris Pismenny <borisp@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	netdev@vger.kernel.org
Subject: [PATCH 26/29] net/tls: use the new scatterwalk functions
Date: Sat, 21 Dec 2024 01:10:53 -0800
Message-ID: <20241221091056.282098-27-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241221091056.282098-1-ebiggers@kernel.org>
References: <20241221091056.282098-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Replace calls to the deprecated function scatterwalk_copychunks() with
memcpy_from_scatterwalk(), memcpy_to_scatterwalk(), or
scatterwalk_skip() as appropriate.

The new functions behave more as expected and eliminate the need to call
scatterwalk_done() or scatterwalk_pagedone().  This was not always being
done when needed, and therefore the old code appears to have also had a
bug where the dcache of the destination page(s) was not always being
flushed on architectures that need that.

Cc: Boris Pismenny <borisp@nvidia.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---

This patch is part of a long series touching many files, so I have
limited the Cc list on the full series.  If you want the full series and
did not receive it, please retrieve it from lore.kernel.org.

 net/tls/tls_device_fallback.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/net/tls/tls_device_fallback.c b/net/tls/tls_device_fallback.c
index f9e3d3d90dcf..ec7017c80b6a 100644
--- a/net/tls/tls_device_fallback.c
+++ b/net/tls/tls_device_fallback.c
@@ -67,20 +67,17 @@ static int tls_enc_record(struct aead_request *aead_req,
 	DEBUG_NET_WARN_ON_ONCE(!cipher_desc || !cipher_desc->offloadable);
 
 	buf_size = TLS_HEADER_SIZE + cipher_desc->iv;
 	len = min_t(int, *in_len, buf_size);
 
-	scatterwalk_copychunks(buf, in, len, 0);
-	scatterwalk_copychunks(buf, out, len, 1);
+	memcpy_from_scatterwalk(buf, in, len);
+	memcpy_to_scatterwalk(out, buf, len);
 
 	*in_len -= len;
 	if (!*in_len)
 		return 0;
 
-	scatterwalk_pagedone(in, 0, 1);
-	scatterwalk_pagedone(out, 1, 1);
-
 	len = buf[4] | (buf[3] << 8);
 	len -= cipher_desc->iv;
 
 	tls_make_aad(aad, len - cipher_desc->tag, (char *)&rcd_sn, buf[0], prot);
 
@@ -108,14 +105,12 @@ static int tls_enc_record(struct aead_request *aead_req,
 
 		*in_len = 0;
 	}
 
 	if (*in_len) {
-		scatterwalk_copychunks(NULL, in, len, 2);
-		scatterwalk_pagedone(in, 0, 1);
-		scatterwalk_copychunks(NULL, out, len, 2);
-		scatterwalk_pagedone(out, 1, 1);
+		scatterwalk_skip(in, len);
+		scatterwalk_skip(out, len);
 	}
 
 	len -= cipher_desc->tag;
 	aead_request_set_crypt(aead_req, sg_in, sg_out, len, iv);
 
@@ -160,13 +155,10 @@ static int tls_enc_records(struct aead_request *aead_req,
 				    cpu_to_be64(rcd_sn), &in, &out, &len, prot);
 		rcd_sn++;
 
 	} while (rc == 0 && len);
 
-	scatterwalk_done(&in, 0, 0);
-	scatterwalk_done(&out, 1, 0);
-
 	return rc;
 }
 
 /* Can't use icsk->icsk_af_ops->send_check here because the ip addresses
  * might have been changed by NAT.
-- 
2.47.1

