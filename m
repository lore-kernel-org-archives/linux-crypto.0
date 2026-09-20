Received: from mail-pj2-f15.google.com (mail-pj2-f15.google.com [74.125.227.143])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0613EEAE7
	for <linux-crypto@vger.kernel.org>; Sun, 20 Sep 2026 23:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.143
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789948373; cv=none; b=Wf2PA/UPwluterRrSPo7MzRL8RS1as2sK1DfXDm3AcGRqmwXWu+slGk3Vpe4I+BifIrneW8LG25Mp/d4O93ttWunrAgkqH6nnSvNL3mqPL7loLfqFG0Gt6zE2SYpcd4HRxDPG4jTq7mIZGSbylWQ+R61rPHMMMwMJ7M32e6kPjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789948373; c=relaxed/simple;
	bh=DdpNXSidQFvpDfBnNgiQM+SzaBF2RjrrqFZBe/ypr34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JE77qykKn2g08yI+hlOpB1ttw99we3fuCYRc6mCnXuSF7j4o8h1ENjUaCUB20y4+qHStRtmOzI46Bwf+lLNqI/0e3XD2f9VcK2NQfuWwtipev4fUjLnqZdjE+dt9f1bUYbCMfCREM64uA8NR12bovHp8T1EYyzwRbLCc+0pxdPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nLv2VGgm; arc=none smtp.client-ip=74.125.227.143
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nLv2VGgm"
Received: by mail-pj2-f15.google.com with SMTP id d9443c01a7336-2d747f01363so19941215ad.2
        for <linux-crypto@vger.kernel.org>; Sun, 20 Sep 2026 16:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789948371; x=1790553171; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EhakzEdE29nOvUv7Mc+RF2KlaAe5CVApdx8H1znJCcg=;
        b=nLv2VGgmk6Q6nXxfqY7Ao+KrEk825hmRWaoLUbtWv6u5xhgHMoqMuf5HOfhqeppUQ8
         A4XN3ipB4tj1lEhSz94rw7UvnRTXtySFTqVY09FlNPVnOqJjFvVHl+qCW884RfynCZVS
         8cuaCi0q7AT5pOcLUflSA3JdlAYWv0YajB6AfPYwivD158DDG1OPRAQLCE8lhyzbdT9x
         djQUVGWfTS0sO9GqbYsYjdDuZCt1xuIqgC423QaW/T3d5TzIrRrBMdfsnKGnAPQscmX8
         HbystK3PXtI2ygYKPWd8yznqj/ZwGKFlV9gk+/8TYRmWITCRkJbsC8PTIwo8JEx1/6Xf
         UqqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789948371; x=1790553171;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EhakzEdE29nOvUv7Mc+RF2KlaAe5CVApdx8H1znJCcg=;
        b=iJfXIkQ4d2/vw+BW5RvOZcEH4rG7YdK8V5MbRTs6IY6towVOIg0sP1JWE0koBfyiVy
         zpgmMC65HgX/0KNQQFkIqXAmLNszmwieJNQYEg37ecKW6GhEC8YfGE4i/F+lfmhCHf3f
         FTHy2QkqX1ictbmJk/web3++k+ei6gW55Chj0l908WccZFuT5pw7IVmNyylLsQ5nf//p
         tYq50uNEiC5MqKcZWXDf66ZH1spm7SZMsXOnC2bpXAjCM0VMTTI1JbgoC1uBjps/wrG6
         CwrR88QQZIf3+acRISI9OEdYLRh+dtMJxKKEfd8LnmhQ50hq6Qzf1XAeqPqOrdOakCm7
         9HOw==
X-Forwarded-Encrypted: i=1; AKwUvBy7/xWHKCPL4yXnOqJQcFDo8g4jjrnmpc9HMy1YT92gzMbI6Hk0UHxBOwwhKNdk/2et9IvU3a2ww8s63ys=@vger.kernel.org
X-Gm-Message-State: AFuF++k0NcQFKunyUel7GCcDjYJL2roF7C/boOo13nU7wAqxGh39jwcP
	Yorzq1is4KhWb3sXoevyefuV4bVXOtdv6Ac9lii8D4jmMWZwbO+obEjl
X-Gm-Gg: AYBFou0/OQcdSbENDm8bYpTSZ9DiT8pA+mcSCC+VB1rrN3My/vCnLp3PuN0RGP+KCgM
	+NnDBm3tbF1xb2mLED3LPZuAXDTWRk8ZzOMqIewpYLokWiZs+pib1VzsbptM8BhSzRF2cErsLmZ
	k3WDfxsnvp34UEqsY1VnFWjpD+dUxZKUL/IkEg7FSGaaKP2Hnzb6MNkYmiQuyMoBvVtwtXFpoiJ
	M02cyr9wMSwYAXaPU7fIq5CbgRf203e13+S1wRsSMFCcf7xp0VM4Pe/6+0oVFN5fBl6IOBFsRfc
	IADgXkBW5CWzbWBKSrrtnlDMVruoAZ/T4SxTzh5QSlziTuCdNzHFnTQ2UpYl0a2UpqCB6R96KUj
	iImJu3vd1Fl16z0wmpxM1la+T7CablMrZlv/iqg6Fdyj2srf+W7W4A3IG04HAjAGd8ExK2G8bgU
	9t6Yv9sqRJ2J/hS5RNq2Ij03kV2nvXYylWS/X0DJ4EtpHTGdUQAY0/nslKnojTwnmTlsKmXZ85R
	mPixfx+v2rrvAtPR+Dqwuv3zQzx1ZtvEE4vfjRz73xo8ZEdc0s7LW4v2FeIIlOJbfe5oYus6Pdx
	gHXlPEhjBh4p5f3lubk7
X-Received: by 2002:a17:903:2c0c:b0:2dd:b3e0:850 with SMTP id d9443c01a7336-2ddb3e008d2mr126436425ad.17.1789948370862;
        Sun, 20 Sep 2026 16:52:50 -0700 (PDT)
Received: from phui-2.c.googlers.com.com (78.123.83.34.bc.googleusercontent.com. [34.83.123.78])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ddc1788173sm24228375ad.19.2026.09.20.16.52.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 16:52:50 -0700 (PDT)
From: Hui Peng <benquike@gmail.com>
To: David Howells <dhowells@redhat.com>,
	Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Paul Moore <paul@paul-moore.com>,
	keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hui Peng <benquike@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] certs: x509: duplicate cert->tbs when sig->algo_takes_data is set
Date: Sun, 20 Sep 2026 23:52:49 +0000
Message-ID: <20260920235249.260530-1-benquike@gmail.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <CAHC9VhS7sZQaPaRswKQ1ETrReEPB2f5buNAMGSXqZ1iBKTs+bg@mail.gmail.com>
References: <20260919223438.3883567-1-benquike@gmail.com> <CAHC9VhS7sZQaPaRswKQ1ETrReEPB2f5buNAMGSXqZ1iBKTs+bg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In x509_get_sig_params(), when sig->algo_takes_data is true, sig->m is
assigned (u8 *)cert->tbs with sig->m_free = false. However, cert->tbs
points into the temporary ASN.1 buffer (prep->data) passed to
x509_cert_parse(), while cert->sig is retained in
prep->payload.data[asym_auth] by x509_key_preparse() after prep->data
is freed by the caller. Subsequent signature verification on the key's
public_key_signature dereferences the freed TBS buffer.

Duplicate cert->tbs with kmemdup() and set sig->m_free = true so sig->m
remains valid for the lifetime of struct public_key_signature.

Tested in QEMU against Linux 7.3.0-rc3 with KASAN enabled by adding an
ML-DSA-44 (OID 2.16.840.1.101.3.4.3.17) X.509 certificate via
add_key("asymmetric", ...) and linking it into a signature-restricted
keyring via keyctl(KEYCTL_LINK), which triggers the following KASAN
slab-use-after-free before this patch:

  BUG: KASAN: slab-use-after-free in mldsa_verify+0x95/0xa0 [mldsa]
  Read of size 1 at addr ffff88800108c004 by task init/1

  Call Trace:
   <TASK>
   dump_stack_lvl+0x70/0xa0
   print_report+0x153/0x4c6
   kasan_report+0xf1/0x120
   mldsa_verify+0x95/0xa0 [mldsa]
   public_key_verify_signature+0x5cb/0x8e0
   verify_signature+0xe4/0x130
   key_or_keyring_common+0x428/0x850
   key_link+0x22e/0x360
   keyctl_keyring_link+0x6b/0xc0
   __do_sys_keyctl+0x146/0x4f0
   do_syscall_64+0xda/0x4b0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>

  Allocated by task 1:
   kasan_save_stack+0x30/0x50
   kasan_save_track+0x14/0x30
   __kasan_kmalloc+0x7f/0x90
   __kvmalloc_node_noprof+0x1c2/0x5b0
   __do_sys_add_key+0x1c2/0x390
   do_syscall_64+0xda/0x4b0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

  Freed by task 1:
   kasan_save_stack+0x30/0x50
   kasan_save_track+0x14/0x30
   kasan_save_free_info+0x3b/0x70
   __kasan_slab_free+0x47/0x70
   kfree+0x159/0x420
   __do_sys_add_key+0x2b3/0x390
   do_syscall_64+0xda/0x4b0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

  The buggy address belongs to the object at ffff88800108c000
   which belongs to the cache kmalloc-4k of size 4096
  The buggy address is located 4 bytes inside of
   freed 4096-byte region [ffff88800108c000, ffff88800108d000)

Fixes: f3eccecd782d ("pkcs7: Allow the signing algo to do whatever digestion it wants itself")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Hui Peng <benquike@gmail.com>
---
Changes in v2:
- Dropped the net/netlabel/netlabel_calipso.c change, keeping only the
  crypto/asymmetric_keys/x509_public_key.c fix.
- Added the KASAN slab-use-after-free report and test description to the
  commit message.

 crypto/asymmetric_keys/x509_public_key.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 25cf8ac7f257..5c9165a83f91 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -53,9 +53,11 @@ int x509_get_sig_params(struct x509_certificate *cert)
 
 	if (sig->algo_takes_data) {
 		/* The signature algorithm does whatever passes for hashing. */
-		sig->m = (u8 *)cert->tbs;
+		sig->m = kmemdup(cert->tbs, cert->tbs_size, GFP_KERNEL);
+		if (!sig->m)
+			return -ENOMEM;
 		sig->m_size = cert->tbs_size;
-		sig->m_free = false;
+		sig->m_free = true;
 		goto out;
 	}
 
-- 
2.47.3
