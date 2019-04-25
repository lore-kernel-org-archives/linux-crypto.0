Return-Path: <SRS0=5M5o=S3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B79AC10F03
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Apr 2019 07:49:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22411217FA
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Apr 2019 07:49:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727927AbfDYHtu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Apr 2019 03:49:50 -0400
Received: from [5.180.42.13] ([5.180.42.13]:52342 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1726184AbfDYHtu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Apr 2019 03:49:50 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hJZ8f-0002Ef-9V; Thu, 25 Apr 2019 15:49:49 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hJZ8e-00024n-RX; Thu, 25 Apr 2019 15:49:48 +0800
Date:   Thu, 25 Apr 2019 15:49:48 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] crypto: remove shash_desc::flags
Message-ID: <20190425074948.emecih4hecalugl5@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190415003709.1531-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi
Organization: Core
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> wrote:
> This series removes the flags field from 'struct shash_desc', i.e. the
> ability to specify CRYPTO_TFM_REQ_MAY_SLEEP for shashes, because:
> 
> (1) It never actually does anything except in two cases, one of which is
>    broken, and the other of which is useless and also redundant with
>    the ahash_request flags.
> 
> (2) Users are incorrectly passing MAY_SLEEP when they can't sleep, so if
>    we actually made any shash algorithm sleep, things would break.
> 
> (3) If any users actually need preemption points, we can just add a
>    function that calls crypto_shash_update() multiple times with
>    preemption points.  No need to pass a flag down to every algorithm.
> 
> Eric Biggers (3):
>  crypto: shash - remove useless crypto_yield() in shash_ahash_digest()
>  crypto: nx - don't abuse shash MAY_SLEEP flag
>  crypto: shash - remove shash_desc::flags
> 
> Documentation/crypto/api-samples.rst                 |  1 -
> arch/arm/crypto/ghash-ce-glue.c                      |  3 ---
> arch/x86/crypto/ghash-clmulni-intel_glue.c           |  2 --
> arch/x86/power/hibernate.c                           |  1 -
> crypto/adiantum.c                                    |  1 -
> crypto/asymmetric_keys/pkcs7_verify.c                |  1 -
> crypto/asymmetric_keys/verify_pefile.c               |  1 -
> crypto/asymmetric_keys/x509_public_key.c             |  1 -
> crypto/cryptd.c                                      |  3 ---
> crypto/drbg.c                                        |  1 -
> crypto/hmac.c                                        | 11 -----------
> crypto/shash.c                                       |  5 -----
> crypto/testmgr.c                                     |  2 --
> drivers/block/drbd/drbd_receiver.c                   |  1 -
> drivers/block/drbd/drbd_worker.c                     |  2 --
> drivers/crypto/axis/artpec6_crypto.c                 |  2 --
> drivers/crypto/bcm/cipher.c                          |  1 -
> drivers/crypto/bcm/util.c                            |  1 -
> drivers/crypto/ccp/ccp-crypto-sha.c                  |  2 --
> drivers/crypto/chelsio/chcr_algo.c                   |  2 --
> drivers/crypto/mediatek/mtk-sha.c                    |  3 ---
> drivers/crypto/n2_core.c                             |  2 --
> drivers/crypto/nx/nx-aes-xcbc.c                      | 12 ++++--------
> drivers/crypto/nx/nx-sha256.c                        |  6 ++----
> drivers/crypto/nx/nx-sha512.c                        |  6 ++----
> drivers/crypto/omap-sham.c                           |  2 --
> drivers/crypto/padlock-sha.c                         |  5 -----
> drivers/crypto/qat/qat_common/qat_algs.c             |  1 -
> drivers/crypto/s5p-sss.c                             |  1 -
> drivers/crypto/vmx/ghash.c                           |  1 -
> drivers/infiniband/sw/rxe/rxe.h                      |  1 -
> drivers/md/dm-crypt.c                                |  3 ---
> drivers/md/dm-integrity.c                            |  2 --
> drivers/net/ppp/ppp_mppe.c                           |  1 -
> drivers/net/wireless/intersil/orinoco/mic.c          |  1 -
> drivers/nfc/s3fwrn5/firmware.c                       |  1 -
> drivers/staging/ks7010/ks_hostif.c                   |  1 -
> drivers/staging/rtl8192e/rtllib_crypt_tkip.c         |  1 -
> .../rtl8192u/ieee80211/ieee80211_crypt_tkip.c        |  1 -
> drivers/target/iscsi/iscsi_target_auth.c             |  1 -
> drivers/thunderbolt/domain.c                         |  1 -
> fs/cifs/misc.c                                       |  1 -
> fs/crypto/keyinfo.c                                  |  1 -
> fs/ecryptfs/crypto.c                                 |  1 -
> fs/ecryptfs/keystore.c                               |  1 -
> fs/ext4/ext4.h                                       |  1 -
> fs/f2fs/f2fs.h                                       |  1 -
> fs/nfsd/nfs4recover.c                                |  1 -
> fs/ubifs/auth.c                                      |  6 ------
> fs/ubifs/replay.c                                    |  2 --
> include/crypto/hash.h                                | 10 ++++++++--
> include/linux/jbd2.h                                 |  1 -
> kernel/kexec_file.c                                  |  1 -
> lib/crc-t10dif.c                                     |  1 -
> lib/digsig.c                                         |  1 -
> lib/libcrc32c.c                                      |  1 -
> net/bluetooth/amp.c                                  |  1 -
> net/bluetooth/smp.c                                  |  1 -
> net/sctp/auth.c                                      |  1 -
> net/sctp/sm_make_chunk.c                             |  2 --
> net/sunrpc/auth_gss/gss_krb5_crypto.c                |  2 --
> net/sunrpc/auth_gss/gss_krb5_mech.c                  |  1 -
> net/wireless/lib80211_crypt_tkip.c                   |  1 -
> security/apparmor/crypto.c                           |  2 --
> security/integrity/evm/evm_crypto.c                  |  1 -
> security/integrity/ima/ima_crypto.c                  |  4 ----
> security/keys/dh.c                                   |  1 -
> security/keys/encrypted-keys/encrypted.c             |  1 -
> security/keys/trusted.c                              |  1 -
> 69 files changed, 16 insertions(+), 130 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
