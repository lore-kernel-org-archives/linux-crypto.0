Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDE02AC17;
	Sun, 24 Aug 2025 01:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756000101; cv=none; b=IVOlxLrHvH1MRQH6qPUQ0XivYNYXwOuDP9dhGIAi1CDVzHdh5DKrj1Tk2S/ymi1x2qKK23t9GnqtaWsly27K8rgqSS+cp1FNdjZCfEYbeYMWJjDUoUu48gayldcmO8qx6a13BOJIqjlWHr3AGzCVxsPu1GmzGvwPwljishQ4WyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756000101; c=relaxed/simple;
	bh=D+ocbRPEs0ajigDumGXUtQ5Yb6ngRIeK+zntHOyq2fQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ggG/MNLVSyXWF5TLGauTv5PwUI7Oq1HazVkdf0wM/E5Fh69Yas6PWi72wgMEuhlEib4fgXlN13zH5ciHRQfbQs7lcEJQ1ARk8QmWVW4BVLN8fq3Eb6xvyf9xLyY20ZVOmkFHBeZgdQcDqLT+4DXPqN3In4i4/Elrk3839iVUHbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RUcZ/RED; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RUcZ/RED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431A6C4CEE7;
	Sun, 24 Aug 2025 01:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756000100;
	bh=D+ocbRPEs0ajigDumGXUtQ5Yb6ngRIeK+zntHOyq2fQ=;
	h=From:To:Cc:Subject:Date:From;
	b=RUcZ/RED6yyZX7DA4uKVuXmtC4eQ7RsbM8CzORM0mOkQBbcoHxjGDAYO11BDfw5+6
	 fRd/8XA/Gk07eCh1f3JNA1NDtYaUX01qpwm8t5xmYj8tvuuJAMpKMaMrvHX7qv8IBe
	 P/+BEGrOTyCZxTOQym6EcRfN3PHBjhhqnpNiA7rVHIszK9z6LQAZW0p5UajdrE8wIR
	 7SWNOnmOtDnJXEQK2CIKM4HxylNz77dDnukaVhvAKdRBfBDvVbqCZ991ONpansYhKO
	 MRd+zVrWUsAI9MSbWu8DL1OuMBbv7ZYKUN4rtRlxj7HQPbj/1G13GjeqZDX+maDwD8
	 JXDrRcxaeDZ2w==
From: Eric Biggers <ebiggers@kernel.org>
To: netdev@vger.kernel.org,
	David Ahern <dsahern@gmail.com>,
	Stephen Hemminger <stephen@networkplumber.org>
Cc: Andrea Mayer <andrea.mayer@uniroma2.it>,
	David Lebrun <dlebrun@google.com>,
	linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH iproute2-next v3] man8: ip-sr: Document that passphrase must be high-entropy
Date: Sat, 23 Aug 2025 21:47:21 -0400
Message-ID: <20250824014721.72689-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

'ip sr hmac set' takes a newline-terminated "passphrase", but it fails
to stretch it.  The "passphrase" actually gets used directly as the key.
This makes it difficult to use securely.

I recommend deprecating this command and replacing it with a command
that either stretches the passphrase or explicitly takes a key instead
of a passphrase.  But for now, let's at least document this pitfall.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

Changed in v3:
- Dropped the update of the man page date
- Use /dev/random instead of /dev/urandom in the example
Changed in v2:
- Use better example commmand for key generation

 man/man8/ip-sr.8 | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/man/man8/ip-sr.8 b/man/man8/ip-sr.8
index 6be1cc54..962fb0d1 100644
--- a/man/man8/ip-sr.8
+++ b/man/man8/ip-sr.8
@@ -32,13 +32,21 @@ internal parameters.
 .PP
 Those parameters include the mapping between an HMAC key ID and its associated
 hashing algorithm and secret, and the IPv6 address to use as source for encapsulated
 packets.
 .PP
-The \fBip sr hmac set\fR command prompts for a passphrase that will be used as the
-HMAC secret for the corresponding key ID. A blank passphrase removes the mapping.
-The currently supported algorithms for \fIALGO\fR are \fBsha1\fR and \fBsha256\fR.
+The \fBip sr hmac set\fR command prompts for a newline-terminated "passphrase"
+that will be used as the HMAC secret for the corresponding key ID. This
+"passphrase" is \fInot\fR stretched, and it is used directly as the HMAC key.
+Therefore it \fImust\fR have enough entropy to be used as a key. For example, a
+correct use would be to use a passphrase that was generated using
+\fBhead\~-c\~32\~/dev/random\~|\~base64\~-w\~0\fR.
+.PP
+A blank "passphrase" removes the mapping.
+.PP
+The currently supported algorithms for \fIALGO\fR are \fBsha1\fR and
+\fBsha256\fR.
 .PP
 If the tunnel source is set to the address :: (which is the default), then an address
 of the egress interface will be selected. As this operation may hinder performances,
 it is recommended to set a non-default address.
 
@@ -52,7 +60,11 @@ it is recommended to set a non-default address.
 .nf
 # ip sr tunsrc set 2001:db8::1
 .SH SEE ALSO
 .br
 .BR ip-route (8)
+
+.SH BUGS
+\fBip sr hmac set\fR does not stretch the passphrase.
+
 .SH AUTHOR
 David Lebrun <david.lebrun@uclouvain.be>

base-commit: 0ad8fef322365b7bafd052f416fc972bea49d362
-- 
2.50.1

