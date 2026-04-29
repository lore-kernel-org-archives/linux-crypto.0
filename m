Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E995438C2A7;
	Wed, 29 Apr 2026 21:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777496958; cv=none; b=Z8F93TH4gK6RyQGQzFU9MAT9D+0BeXcrmaxiZJ7r0/JCHLMbObhckiT/Kzsv5ztOR5pvRCsv4VOyYm2807dovX7bzMDjTyw0bJy1z5WUdHq6lfbzgtRKq8sbazcgOo84O3RL1OJx7t4zjsXoB1LdLeY9pVZssZgfVbm3JRB3GLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777496958; c=relaxed/simple;
	bh=M0tdnOuzmXCioq1vwVig5JzFxH+713uACYEZlJFVWF0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XKSneFz2685tkp3PtVffFEBw5VnFOTRU4SRXNRWu6QXoshwHXvW3luc+oh9LwPsYNwOzTV8tcsjnbUpxLeHifk6tSvX7qEpgTWA9Js7gZ1oi0FzsrblkVapPfCRNuRR61zhVh0tniwWTIboFdeZr+tBbDWGmagNNsKFkE63dQTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bat/mB6E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bat/mB6E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050E7C19425;
	Wed, 29 Apr 2026 21:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777496957;
	bh=M0tdnOuzmXCioq1vwVig5JzFxH+713uACYEZlJFVWF0=;
	h=From:To:Cc:Subject:Date:From;
	b=Bat/mB6EBRPlJ0/KTDjzhHnrM7sS4bWxntiwKyhUmeP/aUWfvDhffz/ONTecVUdka
	 3ARQrOwB5HbAuEMe3fnyTMD1Y+Qrhnrckx86yj/PqRhfD2oRZUNAP6a/hOXICkGFao
	 HSllbKrNweKuaDMb0WNhI8O7mrsK8qg6DG72HsZUn8LfroRLI9hoI+PzEMV5Zc5UyS
	 czA54KqM2wWLh4kVHmt0y29vfMbjgYFLzZYLGX/vroegIzwtd1Ul668w+QIbFpU8jb
	 QgDRFs/lKeRpdexUeNvKsBpNJaDLl0JhjHX0H+zdJX6SNLeXL4afibZzJSgyLULWvb
	 X0NntKwn82idw==
From: Eric Biggers <ebiggers@kernel.org>
To: netdev@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	"David S . Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH net-next] Documentation/tcp_ao: Document the supported MAC algorithms and lengths
Date: Wed, 29 Apr 2026 21:08:56 +0000
Message-ID: <20260429210856.725667-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update the TCP-AO documentation to fix some incorrect terminology and
claims regarding the MAC algorithms, and document which MAC algorithms
and lengths the Linux implementation supports.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 Documentation/networking/tcp_ao.rst | 38 ++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 11 deletions(-)

diff --git a/Documentation/networking/tcp_ao.rst b/Documentation/networking/tcp_ao.rst
index d5b6d0df63c3..55304037aa81 100644
--- a/Documentation/networking/tcp_ao.rst
+++ b/Documentation/networking/tcp_ao.rst
@@ -5,32 +5,34 @@ TCP Authentication Option Linux implementation (RFC5925)
 ========================================================
 
 TCP Authentication Option (TCP-AO) provides a TCP extension aimed at verifying
 segments between trusted peers. It adds a new TCP header option with
 a Message Authentication Code (MAC). MACs are produced from the content
-of a TCP segment using a hashing function with a password known to both peers.
+of a TCP segment using a key known to both peers.
 The intent of TCP-AO is to deprecate TCP-MD5 providing better security,
-key rotation and support for a variety of hashing algorithms.
+key rotation and support for a variety of MAC algorithms.
 
 1. Introduction
 ===============
 
 .. table:: Short and Limited Comparison of TCP-AO and TCP-MD5
 
  +----------------------+------------------------+-----------------------+
  |                      |       TCP-MD5          |         TCP-AO        |
  +======================+========================+=======================+
- |Supported hashing     |MD5                     |Must support HMAC-SHA1 |
- |algorithms            |(cryptographically weak)|(chosen-prefix attacks)|
- |                      |                        |and CMAC-AES-128 (only |
- |                      |                        |side-channel attacks). |
- |                      |                        |May support any hashing|
- |                      |                        |algorithm.             |
+ |Supported MAC         |MD5 of data and key     |HMAC-SHA-1-96 and      |
+ |algorithms            |(cryptographically weak)|AES-128-CMAC-96.       |
+ |                      |                        |Implementations are    |
+ |                      |                        |permitted to support   |
+ |                      |                        |additional algorithms. |
  +----------------------+------------------------+-----------------------+
- |Length of MACs (bytes)|16                      |Typically 12-16.       |
- |                      |                        |Other variants that fit|
- |                      |                        |TCP header permitted.  |
+ |Length of MACs (bytes)|16                      |12 for HMAC-SHA-1-96   |
+ |                      |                        |and AES-128-CMAC-96.   |
+ |                      |                        |Implementations are    |
+ |                      |                        |permitted to support   |
+ |                      |                        |any MAC length that    |
+ |                      |                        |fits in the TCP header.|
  +----------------------+------------------------+-----------------------+
  |Number of keys per    |1                       |Many                   |
  |TCP connection        |                        |                       |
  +----------------------+------------------------+-----------------------+
  |Possibility to change |Non-practical (both     |Supported by protocol  |
@@ -294,10 +296,24 @@ Linux provides a set of ``setsockopt()s`` and ``getsockopt()s`` that let
 userspace manage TCP-AO on a per-socket basis. In order to add/delete MKTs
 ``TCP_AO_ADD_KEY`` and ``TCP_AO_DEL_KEY`` TCP socket options must be used.
 It is not allowed to add a key on an established non-TCP-AO connection
 as well as to remove the last key from TCP-AO connection.
 
+``TCP_AO_ADD_KEY`` allows the MAC algorithm and MAC length to be selected.
+Linux supports the mandatory-to-implement algorithms HMAC-SHA-1-96 and
+AES-128-CMAC-96. In addition, as Linux extensions, it supports:
+
+- HMAC-SHA256. Linux uses HMAC-SHA256 in the same way as HMAC-SHA1; this
+  includes omitting an explicit entropy extraction step. To work around the
+  missing entropy extraction, users should provide keys with full entropy. The
+  implementation is interoperable with other implementations of HMAC-SHA256 for
+  TCP-AO only when they have implemented the key derivation the same way (and
+  also the same MAC length is selected on each side).
+
+- Any MAC length for any of the supported MAC algorithms, provided it fits in
+  the TCP header and is at least 4 bytes.
+
 ``setsockopt(TCP_AO_DEL_KEY)`` command may specify ``tcp_ao_del::current_key``
 + ``tcp_ao_del::set_current`` and/or ``tcp_ao_del::rnext``
 + ``tcp_ao_del::set_rnext`` which makes such delete "forced": it
 provides userspace a way to delete a key that's being used and atomically set
 another one instead. This is not intended for normal use and should be used

base-commit: 09942ddedcb960f9e78fd817ec33f501d1040c5b
-- 
2.54.0.545.g6539524ca2-goog

