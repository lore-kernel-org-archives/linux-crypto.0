Return-Path: <SRS0=EtZ3=SR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 116FDC282CE
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Apr 2019 00:39:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D049220850
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Apr 2019 00:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555288752;
	bh=CTjdnkuHwBPHudfyCPndpC+yQI7y2/2p/1kEAN2rDAc=;
	h=From:To:Subject:Date:List-ID:From;
	b=0LQZ3NhD0Hfla0o8XUFl8II+t+X4NeBCUXCHmqqm1PiEnX7CRWqxMFMyIc2oS8JX4
	 UENL8Fi1PmDT9itM10mgSREObNaHmJAUp5hsiLO/ceoVyBXnrU276vRq+A0/Fiay+M
	 MWW5tVRJgxYVdMQlpqUFb0AuPxNBCDv0bgcISEBQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbfDOAjM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 14 Apr 2019 20:39:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbfDOAjM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 14 Apr 2019 20:39:12 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79A532084E
        for <linux-crypto@vger.kernel.org>; Mon, 15 Apr 2019 00:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555288750;
        bh=CTjdnkuHwBPHudfyCPndpC+yQI7y2/2p/1kEAN2rDAc=;
        h=From:To:Subject:Date:From;
        b=Tm/R5Cv8R07VPVJVIA6OERFhdSxoPT+AIfFZxAIprQxdWhBXS7f1K/Byv0PIvDbE/
         fPpdb0dgUx7ckx5ms6kdJIipKkkGss5R0ZRI6U4ruu7jo0tUyILYcre4AKyx4/yCYh
         STSh14bG7c6j8ApHGFj7AR856DhHIiUNpXhUsIIc=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [RFC PATCH 0/3] crypto: remove shash_desc::flags
Date:   Sun, 14 Apr 2019 17:37:06 -0700
Message-Id: <20190415003709.1531-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This series removes the flags field from 'struct shash_desc', i.e. the
ability to specify CRYPTO_TFM_REQ_MAY_SLEEP for shashes, because:

(1) It never actually does anything except in two cases, one of which is
    broken, and the other of which is useless and also redundant with
    the ahash_request flags.

(2) Users are incorrectly passing MAY_SLEEP when they can't sleep, so if
    we actually made any shash algorithm sleep, things would break.

(3) If any users actually need preemption points, we can just add a
    function that calls crypto_shash_update() multiple times with
    preemption points.  No need to pass a flag down to every algorithm.

Eric Biggers (3):
  crypto: shash - remove useless crypto_yield() in shash_ahash_digest()
  crypto: nx - don't abuse shash MAY_SLEEP flag
  crypto: shash - remove shash_desc::flags

 Documentation/crypto/api-samples.rst                 |  1 -
 arch/arm/crypto/ghash-ce-glue.c                      |  3 ---
 arch/x86/crypto/ghash-clmulni-intel_glue.c           |  2 --
 arch/x86/power/hibernate.c                           |  1 -
 crypto/adiantum.c                                    |  1 -
 crypto/asymmetric_keys/pkcs7_verify.c                |  1 -
 crypto/asymmetric_keys/verify_pefile.c               |  1 -
 crypto/asymmetric_keys/x509_public_key.c             |  1 -
 crypto/cryptd.c                                      |  3 ---
 crypto/drbg.c                                        |  1 -
 crypto/hmac.c                                        | 11 -----------
 crypto/shash.c                                       |  5 -----
 crypto/testmgr.c                                     |  2 --
 drivers/block/drbd/drbd_receiver.c                   |  1 -
 drivers/block/drbd/drbd_worker.c                     |  2 --
 drivers/crypto/axis/artpec6_crypto.c                 |  2 --
 drivers/crypto/bcm/cipher.c                          |  1 -
 drivers/crypto/bcm/util.c                            |  1 -
 drivers/crypto/ccp/ccp-crypto-sha.c                  |  2 --
 drivers/crypto/chelsio/chcr_algo.c                   |  2 --
 drivers/crypto/mediatek/mtk-sha.c                    |  3 ---
 drivers/crypto/n2_core.c                             |  2 --
 drivers/crypto/nx/nx-aes-xcbc.c                      | 12 ++++--------
 drivers/crypto/nx/nx-sha256.c                        |  6 ++----
 drivers/crypto/nx/nx-sha512.c                        |  6 ++----
 drivers/crypto/omap-sham.c                           |  2 --
 drivers/crypto/padlock-sha.c                         |  5 -----
 drivers/crypto/qat/qat_common/qat_algs.c             |  1 -
 drivers/crypto/s5p-sss.c                             |  1 -
 drivers/crypto/vmx/ghash.c                           |  1 -
 drivers/infiniband/sw/rxe/rxe.h                      |  1 -
 drivers/md/dm-crypt.c                                |  3 ---
 drivers/md/dm-integrity.c                            |  2 --
 drivers/net/ppp/ppp_mppe.c                           |  1 -
 drivers/net/wireless/intersil/orinoco/mic.c          |  1 -
 drivers/nfc/s3fwrn5/firmware.c                       |  1 -
 drivers/staging/ks7010/ks_hostif.c                   |  1 -
 drivers/staging/rtl8192e/rtllib_crypt_tkip.c         |  1 -
 .../rtl8192u/ieee80211/ieee80211_crypt_tkip.c        |  1 -
 drivers/target/iscsi/iscsi_target_auth.c             |  1 -
 drivers/thunderbolt/domain.c                         |  1 -
 fs/cifs/misc.c                                       |  1 -
 fs/crypto/keyinfo.c                                  |  1 -
 fs/ecryptfs/crypto.c                                 |  1 -
 fs/ecryptfs/keystore.c                               |  1 -
 fs/ext4/ext4.h                                       |  1 -
 fs/f2fs/f2fs.h                                       |  1 -
 fs/nfsd/nfs4recover.c                                |  1 -
 fs/ubifs/auth.c                                      |  6 ------
 fs/ubifs/replay.c                                    |  2 --
 include/crypto/hash.h                                | 10 ++++++++--
 include/linux/jbd2.h                                 |  1 -
 kernel/kexec_file.c                                  |  1 -
 lib/crc-t10dif.c                                     |  1 -
 lib/digsig.c                                         |  1 -
 lib/libcrc32c.c                                      |  1 -
 net/bluetooth/amp.c                                  |  1 -
 net/bluetooth/smp.c                                  |  1 -
 net/sctp/auth.c                                      |  1 -
 net/sctp/sm_make_chunk.c                             |  2 --
 net/sunrpc/auth_gss/gss_krb5_crypto.c                |  2 --
 net/sunrpc/auth_gss/gss_krb5_mech.c                  |  1 -
 net/wireless/lib80211_crypt_tkip.c                   |  1 -
 security/apparmor/crypto.c                           |  2 --
 security/integrity/evm/evm_crypto.c                  |  1 -
 security/integrity/ima/ima_crypto.c                  |  4 ----
 security/keys/dh.c                                   |  1 -
 security/keys/encrypted-keys/encrypted.c             |  1 -
 security/keys/trusted.c                              |  1 -
 69 files changed, 16 insertions(+), 130 deletions(-)

-- 
2.21.0

