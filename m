Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E704C3B1B4
	for <linux-crypto@vger.kernel.org>; Sat, 18 Jul 2026 18:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784397692; cv=none; b=RHHhwmSEi2G/T0x+YmN5MvT8dTBeldFw5BoTpWO73x4nRQQnwQK4mNGcvse1xijz5VZcCn/k12TcIAHHyunnFX3INaM9sfKFPb4XIfsjG1xLk+R6fidnY4awAGdADhjFm9lvHT5r258QA6rvx2kVv1ScyVXJDDgiyatqpABfEbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784397692; c=relaxed/simple;
	bh=prkQ1DTy3si3wGcQ+MBkaECtthq55+8rqXe08cc0j3I=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=C5BewF5Lf5VdASz1KaDfeWNXk/zTDE8+mx1rPwEjJXnUZtqwt8w2BCp5bT+o+/00qFmIlvV5BX1fPlewbOGQM6iZqVB1eOER7KYOphwth/SrZQoxq5w0RfESR6lpZOCITTCgGRgJwTd9WRQD2/b7cM0BsHC5Y5GXMSLn/tW2PcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kPACf1NM; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kPACf1NM"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-84a2dcede83so7631375b3a.3
        for <linux-crypto@vger.kernel.org>; Sat, 18 Jul 2026 11:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784397690; x=1785002490; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Cx4evW55kOIFpMHCa3lO8FPO0o8+50jLU8+L3sFmdTo=;
        b=kPACf1NMHXCWeu2GW7B8evEMm2a9ePmegF/wb8SDIvoyvpsxU6ki2tu9GebyfhFDFx
         0kaoSw34UwGaMsWULzsgRowLntyFJ8vFi1a8uFFEk0u6BApkjomaihjve3Ft88lIW21r
         dW0+CnJW+NVWJEC/bHKqNKBq64XMbn+Qni19lsxf8S4Lp7Pa15ZChJh+RnZF5wmC0rnF
         TLSysSftvDN/LIN3A/vZVUxXtnOWDRZX2N3Ay7z2CXEn/YxH0O3cDAdVwIxWEqGDoRl+
         0674wxBRyL1gUNHpbhLxa3xGRjTsyfUUwloU/8TgCMgctcfTHUpOAlAG8j6gW5z2DIll
         tJCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784397690; x=1785002490;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Cx4evW55kOIFpMHCa3lO8FPO0o8+50jLU8+L3sFmdTo=;
        b=oaandLVWOfsQfaSwfcMNGaD9HhpMcLsxkJlPTUaqpM5ivmxYtbPScwAj7yPkLzqoHH
         Dx5DAwn+LNo236AzwYBIQb32PeVXcaK+QmaXxpZ0kHVyx7e5eDF8unhKVJKLGJR0afXk
         zQLX7ZOlZQcLXZbt30K3rXZKrrDY61pl1I/Eq2LSXXoo9sgi4cYHqduAU/qobQa2aXsz
         NIPp5RQlCCxbDQFs6RhJOC3pVWwBjVWwWvWUR23B53QRSqwpdXUo1k7jKzbFe7isz3HI
         yaSno4y50+m5G3EdS7n1R8bZ2LAecMUWQW/R57EHiH0had/CsqPPEWZvx67Qbxv73fEr
         Hmdw==
X-Forwarded-Encrypted: i=1; AHgh+RoUolV/tJmxGh2+xe8QhELnxUSLmfEGDppZn69TlwTpQBCyGJC+cEfvls1AOvZmxwpvdTgRya1Pn6evHUU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1VdxBxdjQo5kgmO2Oo+rtApk8byY3xN8kZ0kIRShHCwv8tV2b
	Wgxaod2ufIFb9iMAl7uiamOGzq4+k0+l5eum69gvr5hRlUbxgSyRGVAz
X-Gm-Gg: AfdE7ckboPq604CLMVbYEyP7nOmBeN1j8ro+g4koMAhMqHjurxI9tlIvVbNmSI1EV/I
	ApT91+gJ1iLUjuMw//agi4FsZFxzgs171RYnhHw8VyJ2K7ed8lQqFHeKeqTSdcVJfcAq/igccpe
	hdWOoYiXySWYvQzfskXmcdcpuLg64j8N8ePtz60AqVlqRZPUUtEjF9YF0VXhN4ffVNlgKQd/eMU
	WgD2Ankl4SSQbE/R5vHfHYmyqSeK0cVUYTfUxY27/NIyzZHi1bu098ohQbiQTgWaH/iGKBDgKY8
	9iaGQVAQMztnBF9VdFnznfP/zKLn6upi3ks4q3DIZ0KiD1WDvdFWC/aNYZ/j8JUSA3/KlXReKbc
	zUP8UKx2XEI4WtxAmBDwexxEqwqILWC0LWQyJQjCSjTitHpBSYm3R2MUBYH7NVxfpruGQKR5zjz
	8AoUWNCJ3ohVxKkLFv6lORBw==
X-Received: by 2002:a05:6a00:6c81:b0:847:8b11:5966 with SMTP id d2e1a72fcca58-84c292730eamr8915242b3a.1.1784397690011;
        Sat, 18 Jul 2026 11:01:30 -0700 (PDT)
Received: from DESKTOP-SF55S0Q.localdomain ([116.38.218.197])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84c2e68e7b8sm2808749b3a.35.2026.07.18.11.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2026 11:01:29 -0700 (PDT)
Date: Sun, 19 Jul 2026 03:01:25 +0900
From: Seohyeon Maeng <bioloidgp@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [BUG] crypto: rfc4309 default authsize mismatch causes unprivileged
 AF_ALG panic
Message-ID: <alu_daaywAIZXKZm@DESKTOP-SF55S0Q.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

I found an output-length contract mismatch in the RFC4309 AEAD template.
An unprivileged user can reach it through AF_ALG and panic the kernel.

Summary
-------

crypto_rfc4309_init_tfm() spawns its child AEAD but does not synchronize the
child's initial authsize with the RFC4309 parent's initial authsize.

The generic AEAD initialization code initializes each transform's authsize to
that algorithm's own maxauthsize.  RFC4309 hardcodes maxauthsize to 16, while
the template accepts any child AEAD with IV size 16 and block size 1.  The
parent and child can therefore start with different authsizes until an
explicit crypto_aead_setauthsize() call is made.

AF_ALG does not require ALG_SET_AEAD_AUTHSIZE, so the inconsistent default
state is reachable without capabilities or user namespaces.

I confirmed two directions of the mismatch:

1. Child authsize larger than the parent

   rfc4309(authenc(hmac(sha256),ctr(aes)))

   - RFC4309 parent authsize: 16
   - AUTHENC child authsize: 32

   During encryption, AF_ALG creates the receive scatterlist using the
   parent's 16-byte expansion, but AUTHENC appends a 32-byte tag.  The first
   16 tag bytes fit and the scatterlist walker then dereferences the NULL
   entry after the marked end of the receive scatterlist.

2. Child authsize smaller than the parent

   rfc4309(authenc(michael_mic,ctr(aes)))

   - RFC4309 parent authsize: 16
   - AUTHENC child authsize: 8

   During decryption, the parent computes the plaintext length by subtracting
   16, while the child subtracts only 8.  With a valid child authentication
   tag, the child attempts to decrypt eight bytes more than the destination
   scatterlist represents.  The CTR slow path copies the represented bytes
   and then dereferences the NULL entry after the destination SG end.

Affected code
-------------

crypto/ccm.c:

  static int crypto_rfc4309_init_tfm(struct crypto_aead *tfm)
  {
          ...
          aead = crypto_spawn_aead(spawn);
          if (IS_ERR(aead))
                  return PTR_ERR(aead);

          ctx->child = aead;
          ...
  }

crypto_rfc4309_setauthsize() would synchronize the child, but it is only
called when a consumer explicitly sets an authsize.

The RFC4309 instance creation code verifies the child IV size and block size,
but does not verify that its inherited/default authsize is compatible:

  if (crypto_aead_alg_ivsize(alg) != 16)
          goto err_free_inst;
  if (alg->base.cra_blocksize != 1)
          goto err_free_inst;
  ...
  inst->alg.maxauthsize = 16;

Reachability
------------

The reproducers drop to UID/GID 65534 before opening AF_ALG sockets.

No capability, user namespace, io_uring, network configuration, or device node
is required.  The relevant configuration options are enabled in the tested
kernel:

  CONFIG_CRYPTO_AUTHENC=y
  CONFIG_CRYPTO_AES=y
  CONFIG_CRYPTO_CTR=y
  CONFIG_CRYPTO_CCM=y
  CONFIG_CRYPTO_HMAC=y
  CONFIG_CRYPTO_SHA256=y
  CONFIG_CRYPTO_MICHAEL_MIC=y
  CONFIG_CRYPTO_USER_API_AEAD=y

Runtime results
---------------

The small-child decryption case was reproduced on the official Linux 6.12.95
kernel image.

Control, with ALG_SET_AEAD_AUTHSIZE set to 8:

  uid=65534 gid=65534 mode=control
  sendmsg op=1 returned 32; recv capacity=40
  recv op=1 returned 40
  sendmsg op=0 returned 40; recv capacity=32
  recv op=0 returned 32

Trigger, leaving the RFC4309 parent and child at their defaults:

  uid=65534 gid=65534 mode=trigger
  sendmsg op=1 returned 32; recv capacity=40
  recv op=1 returned 40
  sendmsg op=0 returned 40; recv capacity=32
  BUG: kernel NULL pointer dereference, address: 0000000000000008
  CPU: 1 UID: 65534 PID: 129 Comm: repro_rfc4309_s
  RIP: scatterwalk_copychunks+0xd6/0x150
  Call Trace:
    skcipher_walk_done+0x231/0x240
    crypto_ctr_crypt+0x100/0x280
    aead_recvmsg+0x3d4/0x510
    sock_recvmsg+0x8e/0x90
    __sys_recvfrom+0xc3/0x140
  Kernel panic - not syncing: Fatal exception

The large-child encryption case was also reproduced as UID/GID 65534.  It
faults while AUTHENC copies the oversized tag beyond the parent-sized receive
scatterlist.

Version status
--------------

The vulnerable initialization shape was present when checked in:

  - Torvalds master: 1229e2e57a5c2980ccd457b9b53ea0eed5a22ab3
  - crypto maintainer master: 8173f7e2ce67e6ca1d4763f3da14e5b01ce77456
  - Linux 6.12.96: 6d15a1029d425b15c59463910ebdccc4afe760d6
  - tested Linux 6.12.95: 296aabce459470a4c1b68ffd0c0c0920e563aaad

The standard RFC4309 test coverage does not expose this state: testmgr covers
rfc4309(ccm(aes)), and the AEAD test path calls crypto_aead_setauthsize()
before executing each vector.

Impact
------

Confirmed impact is an unprivileged local kernel panic/denial of service on a
PANIC_ON_OOPS kernel.

I have not demonstrated an adjacent-object write or privilege-escalation
primitive.  The AF_ALG receive path marks the exact parent-sized destination
SG as ended, so the tested software walkers fault at the NULL next entry
instead of continuing into adjacent memory.

Suggested fix direction
-----------------------

RFC4309 initialization should apply the parent's inherited authsize to the
newly spawned child and fail transform initialization if the child rejects
that size.  Conceptually:

  aead = crypto_spawn_aead(spawn);
  if (IS_ERR(aead))
          return PTR_ERR(aead);

  err = crypto_aead_setauthsize(aead, crypto_aead_authsize(tfm));
  if (err) {
          crypto_free_aead(aead);
          return err;
  }

  ctx->child = aead;

This preserves compatible children and rejects child algorithms whose output
contract cannot represent RFC4309's inherited default.

This issue was found with AI-assisted source review.  Both paths and the
runtime results above were manually validated.  Minimal source reproducers are
available privately on request, but are not attached to this public report.

Regards,
Seohyeon Maeng
