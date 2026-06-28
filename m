Received: from mail.w13.tutanota.de (mail.w13.tutanota.de [185.205.69.213])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA4E348C68
	for <linux-crypto@vger.kernel.org>; Sun, 28 Jun 2026 15:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.205.69.213
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782660858; cv=none; b=KbWRapES6XAPPqyH4dZq9XOK3ZxMjhANhdxFUpOO7lq3kTKDXMNw578Ax1XFQlI+7AR+0l5qTiJhWlkQjwyuLeIWUrwGrbYnusmOHtIaReYZ83IQ76oxiSCfODha8CtIf8fnEYV80867BD/salt+k7jylppv0TE4bge/yKvuj6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782660858; c=relaxed/simple;
	bh=VRJ5uKTLsnprqjB47nX609DQeci0yYy8SoQHx4hw468=;
	h=Date:From:To:Cc:Message-ID:Subject:MIME-Version:Content-Type; b=dhExB7e/4lrjE7RbSFtw8EZApeMNwK7YYyvRvKsI8mJ1gKJGomPLfcKNde5hlsx2GeUDM7JDE8BX0Io4SdTmABg3KoZIFuSYgVEw+NbKdJ2zO0sNtVX2Ys/fXPPGKP5DE4XbZOQoDrfk0Kw0klYubvjbPBv2ciPLsaQ6KSP63gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tutanota.com; spf=pass smtp.mailfrom=tutanota.com; dkim=pass (2048-bit key) header.d=tutanota.com header.i=@tutanota.com header.b=vtm3R8IF; arc=none smtp.client-ip=185.205.69.213
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tutanota.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tutanota.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tutanota.com header.i=@tutanota.com header.b="vtm3R8IF"
Received: from tutadb.w10.tutanota.de (w10.api.tuta.com [IPv6:fd:ac::d:10])
	by mail.w13.tutanota.de (Postfix) with ESMTP id D11181555AEE8
	for <linux-crypto@vger.kernel.org>; Sun, 28 Jun 2026 17:34:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1782660855;
	s=s1; d=tutanota.com;
	h=From:From:To:To:Subject:Subject:Content-Description:Content-ID:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Cc:Cc:Date:Date:In-Reply-To:MIME-Version:MIME-Version:Message-ID:Message-ID:Reply-To:References:Sender;
	bh=VRJ5uKTLsnprqjB47nX609DQeci0yYy8SoQHx4hw468=;
	b=vtm3R8IFBYeOtFLfaqQbr+UoB15J7BNVnqq97h7LJE4Xz+glhOaCEH6o53G+HfQ8
	smOYbQhbE1SdzW7B1ns0EvsNfOZ0SZAtghUkNMbxKRaywLupAOai66DJxv4v36yn6t4
	LF2kAe8odFGXcekN0ca7M+O3kP74wkmrQOuAkZytNDDo70qtV5T8kcAA8RVPoIx1xMd
	fRhX9vWCQv3hDTziihc0o12TtDIPYaHEpQKYDJf7KV2i9SKipnNA0NxG294MoM/NgAM
	6jLxabdwBEBIFOHjGdA8uz/sXsPWvDCobhPc+/MCEy20SiKXeME9J8XsrKedNs8Mf4R
	n+lRPILgHA==
Date: Sun, 28 Jun 2026 17:34:15 +0200 (CEST)
From: cyper@tutanota.com
To: Herbert <herbert@gondor.apana.org.au>
Cc: Davem <davem@davemloft.net>, Linux Crypto <linux-crypto@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
Message-ID: <OwDrEgL--F-9@tutanota.com>
Subject: [PATCH] crypto: algif_aead - stop recvmsg looping after a completed
 request
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Feedback-ID: 01c31dc8a5d4d6751b6f6ac02a78e46dc8b122f05e0198c33d2725066fef6ebaf2fef8f8a5859fcd950990ed82c624bcd61f0c6ba63d9a3ddbf9efb21fe5671f4a:TurnOnPrivacy!:tutamail

From e0ed18c8ad9a7d2ecf939f0b97e2be0567180c1d Mon Sep 17 00:00:00 2001
From: Qiguang Wang <cyper@tutanota.com>
Date: Sat, 27 Jun 2026 21:49:55 +0000
Subject: [PATCH] crypto: algif_aead - stop recvmsg looping after a complete=
d
request
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>,
=C2=A0=C2=A0=C2=A0=C2=A0linux-crypto@vger.kernel.org,
=C2=A0=C2=A0=C2=A0=C2=A0linux-kernel@vger.kernel.org

A blocking recvmsg()/read() into an output buffer larger than the cipher
result hangs forever.

After the first pass of the "while (msg_data_left(msg))" loop in
aead_recvmsg() (and the identical loop in skcipher_recvmsg()) produces
the result, af_alg_get_rsgl() has consumed only as many bytes from the
output iterator as the cipher produced, so msg_data_left() is still
non-zero and the loop runs a second pass.=C2=A0 By then af_alg_pull_tsgl()
has executed

ctx->init =3D ctx->more;

which, for a request that was not flagged MSG_MORE, resets ctx->init to
0 and drains ctx->used.=C2=A0 The second pass therefore takes the
_aead_recvmsg()/_skcipher_recvmsg() gate

if (!ctx->init || ctx->more)
err =3D af_alg_wait_for_data(sk, flags, 0);

and af_alg_wait_for_data() blocks on

ctx->init && (!ctx->more || (min && ctx->used >=3D min))

which can never become true again (ctx->init =3D=3D 0, min =3D=3D 0), so th=
e
task sleeps in MAX_SCHEDULE_TIMEOUT forever even though the result was
already produced in pass 1.

The sleep is interruptible, so any signal -- or a poll(POLLIN) issued
before the read -- makes recvmsg return the bytes already accumulated in
ret, which is why the hang is easy to miss.=C2=A0 A plain blocking read wit=
h
an oversized buffer hangs deterministically; it reproduces with stock
gcm(aes).

Fix both loops by stopping once a non-MSG_MORE request has been fully
consumed (ctx->more =3D=3D 0 && ctx->used =3D=3D 0) instead of re-entering =
the
blocking wait.=C2=A0 Partial/AIO requests (ctx->used > 0), MSG_MORE streami=
ng
(ctx->more !=3D 0) and the -EIOCBQUEUED/-EBADMSG paths are unaffected: the
new check is only reached after "ret +=3D err", i.e. after a pass that
made forward progress.

Fixes: f3c802a1f300 ("crypto: algif_aead - Only wake up when ctx->more is z=
ero")
Cc: <stable@vger.kernel.org>
Signed-off-by: Qiguang Wang <cyper@tutanota.com>
---
crypto/algif_aead.c=C2=A0=C2=A0=C2=A0=C2=A0 | 12 ++++++++++++
crypto/algif_skcipher.c | 12 ++++++++++++
2 files changed, 24 insertions(+)

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 787aac8aeb24..d0756aef476d 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -216,6 +216,7 @@ static int aead_recvmsg(struct socket *sock, struct msg=
hdr *msg,
size_t ignored, int flags)
{
struct sock *sk =3D sock->sk;
+ struct af_alg_ctx *ctx =3D alg_sk(sk)->private;
int ret =3D 0;
=C2=A0
lock_sock(sk);
@@ -237,6 +238,17 @@ static int aead_recvmsg(struct socket *sock, struct ms=
ghdr *msg,
}
=C2=A0
ret +=3D err;
+
+ /*
+ * A request that was not flagged MSG_MORE has now been fully
+ * consumed: af_alg_pull_tsgl() reset ctx->init to ctx->more
+ * (=3D=3D 0) and drained ctx->used.=C2=A0 Stop here instead of looping
+ * back into a blocking af_alg_wait_for_data() that can never
+ * complete, which is what happens when the supplied output
+ * buffer is larger than the cipher result.
+ */
+ if (!ctx->more && !ctx->used)
+ break;
}
=C2=A0
out:
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index df20bdfe1f1f..c3a5968baef4 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -181,6 +181,7 @@ static int skcipher_recvmsg(struct socket *sock, struct=
 msghdr *msg,
=C2=A0=C2=A0=C2=A0 size_t ignored, int flags)
{
struct sock *sk =3D sock->sk;
+ struct af_alg_ctx *ctx =3D alg_sk(sk)->private;
int ret =3D 0;
=C2=A0
lock_sock(sk);
@@ -202,6 +203,17 @@ static int skcipher_recvmsg(struct socket *sock, struc=
t msghdr *msg,
}
=C2=A0
ret +=3D err;
+
+ /*
+ * A request that was not flagged MSG_MORE has now been fully
+ * consumed: af_alg_pull_tsgl() reset ctx->init to ctx->more
+ * (=3D=3D 0) and drained ctx->used.=C2=A0 Stop here instead of looping
+ * back into a blocking af_alg_wait_for_data() that can never
+ * complete, which is what happens when the supplied output
+ * buffer is larger than the cipher result.
+ */
+ if (!ctx->more && !ctx->used)
+ break;
}
=C2=A0
out:
--=C2=A0
2.53.0


