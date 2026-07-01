Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C188134DCE4
	for <linux-crypto@vger.kernel.org>; Wed,  1 Jul 2026 14:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782916799; cv=none; b=DnFOac5HsQ5wbtAqa8DVc8iqf+7ehbZk1xoOF/f+HzlGWhlzZdkBLWZC5eDqJUKaJpoX/0bvVZ1Hu4GX9a1SRLtFYECmBOyhezD67ZYoVzb0KX9e2uHKj4agAo6yLbwXzf5CKrUFe/Qz8ldldgfO2nUZ8H4fPIrAN9gzock8bTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782916799; c=relaxed/simple;
	bh=mMTSl0QAOwtcpJHRkhvdgBmIGynDbf51FfvXpf6+M2k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BYyp3IO1LsRd0tEyBOXRF8KFlbcB5+wRnLKMsIMBQ21zsxN5v65VqmAIcTsQ59f1MlRUEy0D6BSUr2Ty82wMsi/Qq8p8fMzyWGnz6ZK2ooLV73woENC+RRYyK3/8dxrK8X43CcXTwSCBOzh53VFKP7j61A8PilHJxk+f8Osn8vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bRM5TpVU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bRM5TpVU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782916796;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=MXKrIVoVktsr++SWobAuflPGDO0eMMKn6HewP4qE46c=;
	b=bRM5TpVUoVvbqrtWjTnx/yvLq74glFSR8jc/gQiTlgduQQQAUvK0g2yovjFUoPQYWGsZpP
	nSuxkgOMkdd8/OWyI+JfDBQNP5TFUDkn4bpSKIOGQeFjPabq2I28vCx/cecVeJOfC6UNwO
	H80nkqDtGVBkCm67rNVRGEiV6sYw5eY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-231-6GipXXOlPRu7aKYMoJGZ0A-1; Wed,
 01 Jul 2026 10:39:53 -0400
X-MC-Unique: 6GipXXOlPRu7aKYMoJGZ0A-1
X-Mimecast-MFC-AGG-ID: 6GipXXOlPRu7aKYMoJGZ0A_1782916792
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 182661933FA0;
	Wed,  1 Jul 2026 14:39:52 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.44.34.133])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AB3423000C2E;
	Wed,  1 Jul 2026 14:39:49 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH] crypto: pcrypt - Disallow nesting of the pcrypt wrapper
Date: Wed,  1 Jul 2026 16:39:47 +0200
Message-ID: <20260701143947.944593-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

From: Thomas Huth <thuth@redhat.com>

When running syzkaller in parallel with "modprobe tcrypt", it's
possible to get a call trace with Linux v7.1:

 alg: aead: failed to allocate transform for rfc4543(gcm(aes)): -36
 alg: self-tests for rfc4543(gcm(aes)) using rfc4543(gcm(aes)) failed (rc=
=3D-36)
 ------------[ cut here ]------------
 alg: No test for cbc(cipher_null) (cbc(cipher_null-generic))
 alg: self-tests for rfc4543(gcm(aes)) using rfc4543(gcm(aes)) failed (rc=
=3D-36)
 WARNING: crypto/testmgr.c:5798 at alg_test.cold+0x85/0x98, CPU#198: modpro=
be/65089
 Modules linked in: tcrypt(+) adiantum libnh chacha20poly1305 echainiv pcry=
pt essiv crc32_cryptoapi chacha ip6_vti ip_vti ip_gre ipip sit ip_tunnel ge=
neve macvtap tap ipvlan macvlan 8021q garp mrp hsr xfrm_interface xfrm6_tun=
nel tunnel4 wireguard libcurve25519 ip6_udp_tunnel udp_tunnel veth vxcan nl=
mon dummy bonding vcan can_dev bnep bridge stp llc ip6_gre gre hci_vhci cfg=
80211 ip6_tunnel tunnel6 bluetooth tun crc16 binfmt_misc xcbc cmac blake2b =
libblake2b rmd160 xxhash_generic ccm camellia_generic camellia_aesni_avx2 c=
amellia_aesni_avx_x86_64 camellia_x86_64 fcrypt pcbc wp512 cast6_avx_x86_64=
 cast6_generic cast5_avx_x86_64 cast5_generic cast_common serpent_avx2 serp=
ent_avx_x86_64 serpent_sse2_x86_64 serpent_generic lrw twofish_generic twof=
ish_avx_x86_64 twofish_x86_64_3way twofish_x86_64 twofish_common blowfish_g=
eneric blowfish_x86_64 blowfish_common md4 des_generic libdes qrtr rfkill v=
fat amd_atl fat intel_rapl_msr intel_rapl_common amd64_edac edac_mce_amd ml=
x5_ib kvm_amd ib_uverbs macsec kvm ipmi_si
  ib_core ipmi_devintf irqbypass ipmi_msghandler wmi_bmof pcspkr rapl acpi_=
cpufreq mlx5_fwctl i2c_piix4 fwctl ptdma k10temp i2c_smbus joydev i2c_desig=
nware_platform i2c_designware_core sg loop xfs nvme_tcp nvme_fabrics nvme_c=
ore sd_mod nvme_keyring nvme_auth mlx5_core ahci libahci ast libata ccp mlx=
fw i2c_algo_bit psample sp5100_tco wmi dm_mirror dm_region_hash dm_log be2i=
scsi iscsi_boot_sysfs bnx2i cnic uio cxgb4i cxgb4 tls libcxgbi libcxgb iscs=
i_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse i2c_dev dm_multipath =
dm_mod nfnetlink
 CPU: 198 UID: 0 PID: 65089 Comm: modprobe Kdump: loaded Not tainted 7.1.0 =
#34 PREEMPT(full)
 Hardware name: AMD Corporation DAYTONA_X/DAYTONA_X, BIOS RYM100GA 01/13/20=
25
 RIP: 0010:alg_test.cold+0x8e/0x98
 Code: 62 9a fe ff e9 84 16 6a 00 48 c7 c7 20 cf d4 a4 e8 51 9a fe ff e9 17=
 18 6a 00 48 8d 3d 05 7d 05 02 44 89 e9 48 89 ea 4c 89 e6 <67> 48 0f b9 3a =
e9 0d 16 6a 00 4d 8b 4d 00 48 8b 54 24 10 41 89 c0
 RSP: 0018:ffffcba1b4ad78e8 EFLAGS: 00010297
 RAX: 000000000000004d RBX: 0000000000000000 RCX: 00000000ffffffdc
 RDX: ffffffffc166046f RSI: ffffffffc166046f RDI: ffffffffa567f3a0
 RBP: ffffffffc166046f R08: 0000000000000000 R09: 3ffffffffffeffff
 R10: ffffcba1b4ad7768 R11: 0000000000000003 R12: ffffffffc166046f
 R13: 00000000ffffffdc R14: 00000000000000bb R15: 0000000000000000
 FS:  00007f211da68b80(0000) GS:ffff8aea38d18000(0000) knlGS:00000000000000=
00
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007efc35ca8e28 CR3: 00000001e0fe3005 CR4: 0000000000f70ef0
 PKRU: 55555554
 Call Trace:
  <TASK>
  ? get_page_from_freelist+0x201/0x790
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? __alloc_frozen_pages_noprof+0x194/0x340
  do_test+0xeb4/0x5b80 [tcrypt]
  do_test+0x5b55/0x5b80 [tcrypt]
  tcrypt_mod_init+0x79/0xff0 [tcrypt]
  ? __pfx_tcrypt_mod_init+0x10/0x10 [tcrypt]
  do_one_initcall+0x5c/0x310
  do_init_module+0x60/0x240
  init_module_from_file+0xd6/0x130
  idempotent_init_module+0x114/0x310
  __x64_sys_finit_module+0x71/0xe0
  do_syscall_64+0xe3/0x540
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? ksys_read+0x6b/0xe0
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? do_syscall_64+0x11a/0x540
  ? __pfx_kfree_link+0x10/0x10
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? do_sys_openat2+0x9d/0xe0
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? do_syscall_64+0x11a/0x540
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? do_syscall_64+0x11a/0x540
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? do_user_addr_fault+0x206/0x680
  ? srso_alias_return_thunk+0x5/0xfbef5
  ? do_syscall_64+0x98/0x540
  entry_SYSCALL_64_after_hwframe+0x76/0x7e
 RIP: 0033:0x7f211d32b15d
 Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7=
 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff =
ff 73 01 c3 48 8b 0d 8b ac 0c 00 f7 d8 64 89 01 48
 RSP: 002b:00007ffe9066c218 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
 RAX: ffffffffffffffda RBX: 000055adeea20b80 RCX: 00007f211d32b15d
 RDX: 0000000000000000 RSI: 000055adcb64ae79 RDI: 0000000000000003
 RBP: 000055adcb64ae79 R08: 0000000000000070 R09: 000055adeea20b80
 R10: 000055adeea218f0 R11: 0000000000000246 R12: 0000000000040000
 R13: 000055adeea28690 R14: 0000000000000000 R15: 000055adeea20d20
  </TASK>
 ---[ end trace 0000000000000000 ]---
 tcrypt: one or more tests failed!

The problem seems to be that syzkaller instantiated the aes algorithm
with a lot of pcrypt(pcrypt(pcrypt(...))) wrappers shortly before
tcrypt tries to use it, so adding the rfc4543 prefix in gcm.c can fail
with -ENAMETOOLONG when trcypt tries to instantiate it, too.

That means a malicious user space program can block the usage of
crypto algorithms for other user space programs by instantiating
it with a lot of pcrypt() wrappers, so that the name is close to
the length limit.

There does not seem to be any compelling reason for allowing nested
pcrypt wrappers, and nesting also lead to problems in the past already,
see e.g. commit bbefa1dd6a6d5 ("crypto: pcrypt - Avoid deadlock by using
per-instance padata queues"), so let's fix the problem by disallowing
nesting here.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 Note: Marked as "RFC" since I'm not that familiar with the crypto
 subsystem ... is there a better way to prevent nested pcryptos than
 searching for the string the the cra_driver_name? "Claude" suggests
 to set "mask |=3D CRYPTO_ALG_ASYNC;" in pcrypt_create_aead() instead,
 similar to what is done in cryptd_type_and_mask(), would that be
 a better solution?

 Also note that the problem does not seem to reproduce (or at least
 reproduces less likely) in kernel 7.2-rc1 anymore, likely because
 commit 7524070f26d8 ("crypto: af_alg - Drop support for off-CPU
 cryptography") dropped the similar algorithms that could be
 instantiated in parallel? But I think it is likely still a good
 idea to disallow nesting of the pcrypt wrapper, so I'm sending out
 this patch here for discussion.

 crypto/pcrypt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 9f372442981e6..b265c90d31568 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -228,6 +228,9 @@ static void pcrypt_free(struct aead_instance *inst)
 static int pcrypt_init_instance(struct crypto_instance *inst,
 				struct crypto_alg *alg)
 {
+	if (strstr(alg->cra_driver_name, "pcrypt"))
+		return -ELOOP;		/* Nesting of pcrypt is not allowed */
+
 	if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
 		     "pcrypt(%s)", alg->cra_driver_name) >=3D CRYPTO_MAX_ALG_NAME)
 		return -ENAMETOOLONG;
--=20
2.54.0

