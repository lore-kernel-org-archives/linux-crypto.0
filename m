Return-Path: <SRS0=KZld=OW=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59348 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726442AbeLMCK4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Dec 2018 21:10:56 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wBD23isE112145
        for <linux-crypto@vger.kernel.org>; Wed, 12 Dec 2018 21:10:55 -0500
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2pbbdj7g8t-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Wed, 12 Dec 2018 21:10:54 -0500
Received: from localhost
        by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <bauerman@linux.ibm.com>;
        Thu, 13 Dec 2018 02:10:54 -0000
From: Thiago Jung Bauermann <bauerman@linux.ibm.com>
To: linux-integrity@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        "AKASHI, Takahiro" <takahiro.akashi@linaro.org>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>
Subject: [PATCH v9 00/14] Appended signatures support for IMA appraisal
Date: Thu, 13 Dec 2018 00:08:53 -0200
Message-Id: <20181213020907.13601-1-bauerman@linux.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

This version is basically about tidying up the code to make it clearer. Most
of the changes are in patches 11 and 14.

There are two functional changes: one is modifying the list of hooks allowed
to use modsig to allow verifying signed modules and disallow verifying
firmware, and the other is to use the platform keyring as fallback for kexec
kernel verification.

The changelog below has the details. The patches apply on today's
linux-integrity/next-integrity.

Original cover letter:

On the OpenPOWER platform, secure boot and trusted boot are being
implemented using IMA for taking measurements and verifying signatures.
Since the kernel image on Power servers is an ELF binary, kernels are
signed using the scripts/sign-file tool and thus use the same signature
format as signed kernel modules.

This patch series adds support in IMA for verifying those signatures.
It adds flexibility to OpenPOWER secure boot, because it allows it to boot
kernels with the signature appended to them as well as kernels where the
signature is stored in the IMA extended attribute.

Changes since v8:
- Patch "MODSIGN: Export module signature definitions"
  - Renamed validate_module_sig() to mod_check_sig(). (Suggested by
    Mimi Zohar).

- Patch "integrity: Introduce struct evm_xattr"
  - Added comment mentioning that the evm_xattr usage is limited to HMAC
    before the structure definition. (Suggested by Mimi Zohar)

- Patch "ima: Add modsig appraise_type option for module-style appended
         signatures"
  - Added MODULE_CHECK to whitelist of hooks allowed to use modsig, and
    removed FIRMWARE_CHECK. (Suggested by Mimi Zohar and James Morris)

- Patch "ima: Implement support for module-style appended signatures"
  - Moved call to ima_modsig_verify() from ima_appraise_measurement() to
    integrity_digsig_verify(). (Suggested by Mimi Zohar)
  - Renamed ima_read_modsig() to ima_read_collect_modsig() and made it force
    PKCS7 code to calculate the file hash. (Suggested by Mimi Zohar)
  - Build sign-file tool if IMA_APPRAISE_MODSIG is enabled.
  - Check whether the signing key is in the platform keyring as a fallback
    for the KEXEC_KERNEL hook. (Suggested by Mimi Zohar)

- Patch "ima: Store the measurement again when appraising a modsig"
  - In process_measurement(), when a new measurement needs to be stored
    re-add IMA_MEASURE flag when the modsig is read rather than changing the
    if condition when calling ima_store_measurement(). (Suggested by Mimi
    Zohar)
  - Check whether ima_template has "sig" and "d-sig" fields at
    initialization rather than at the first time the check is needed.
    (suggested by Mimi Zohar)

Changes since v7:
- Patch "MODSIGN: Export module signature definitions"
  - Added module name parameter to validate_module_sig() so that it can be
    shown in error messages.

- Patch "integrity: Introduce struct evm_xattr"
  - Dropped use of struct evm_xattr in evm_update_evmxattr() and
    evm_verify_hmac(). It's not needed there anymore because of changes
    to support portable EVM signatures.

Changes since v6:

- Patch "PKCS#7: Introduce pkcs7_get_message_sig() and verify_pkcs7_message_sig()"
  - Retitled to "PKCS#7: Refactor verify_pkcs7_signature() and
    add pkcs7_get_message_sig()"
  - Reworded description to clarify why the refactoring is needed.
    The code is unchanged. (Suggested by Mimi Zohar)
  - Added Mimi Zohar's Reviewed-by.

- Patch "PKCS#7: Introduce pkcs7_get_digest()"
  - Added Mimi Zohar's Reviewed-by.

- Patch "integrity: Introduce integrity_keyring_from_id"
  - Added Mimi Zohar's Signed-off-by.

- Patch "integrity: Introduce asymmetric_sig_has_known_key()"
  - Added Mimi Zohar's Signed-off-by.

- Patch "integrity: Select CONFIG_KEYS instead of depending on it"
  - Added Mimi Zohar's Signed-off-by.

- Patch "ima: Introduce is_ima_sig()"
  - Renamed function to is_signed() (suggested by Mimi Zohar).

- Patch "ima: Add functions to read and verify a modsig signature"
  - Changed stubs for the !CONFIG_IMA_APPRAISE_MODSIG to return -EOPNOTSUPP
    instead of -ENOTSUPP, since the latter isn't defined in uapi headers.
  - Moved functions to the patches which use them and dropped this patch
    (suggested by Mimi Zohar).

- Patch "ima: Implement support for module-style appended signatures"
  - Prevent reading and writing of IMA_MODSIG xattr in ima_read_xattr()
    and ima_inode_setxattr().
  - Simplify code in process_measurement() which decides whether to try
    reading a modsig (suggested by Mimi Zohar).
  - Moved some functions from patch "ima: Add functions to read and verify
    a modsig signature" into this patch.

- Patch "ima: Add new "d-sig" template field"
  - New patch containing code from patch "ima: Write modsig to the measurement list"
    (Suggested by Mimi Zohar).

- Patch "ima: Write modsig to the measurement list"
  - Moved some functions from patch "ima: Add functions to read and verify
    a modsig signature" into this patch.
  - Moved code related to d-sig support to new patch.

- Patch "ima: Store the measurement again when appraising a modsig"
  - New patch.

Thiago Jung Bauermann (14):
  MODSIGN: Export module signature definitions
  PKCS#7: Refactor verify_pkcs7_signature() and add
    pkcs7_get_message_sig()
  PKCS#7: Introduce pkcs7_get_digest()
  integrity: Introduce struct evm_xattr
  integrity: Introduce integrity_keyring_from_id()
  integrity: Introduce asymmetric_sig_has_known_key()
  integrity: Select CONFIG_KEYS instead of depending on it
  ima: Introduce is_signed()
  ima: Export func_tokens
  ima: Add modsig appraise_type option for module-style appended
    signatures
  ima: Implement support for module-style appended signatures
  ima: Add new "d-sig" template field
  ima: Write modsig to the measurement list
  ima: Store the measurement again when appraising a modsig

 Documentation/ABI/testing/ima_policy      |   6 +-
 Documentation/security/IMA-templates.rst  |   5 +
 certs/system_keyring.c                    |  61 ++++--
 crypto/asymmetric_keys/pkcs7_parser.c     |  16 ++
 crypto/asymmetric_keys/pkcs7_verify.c     |  27 +++
 include/crypto/pkcs7.h                    |   5 +
 include/linux/module.h                    |   3 -
 include/linux/module_signature.h          |  47 +++++
 include/linux/verification.h              |  10 +
 init/Kconfig                              |   6 +-
 kernel/Makefile                           |   2 +-
 kernel/module.c                           |   1 +
 kernel/module_signing.c                   |  82 ++++----
 scripts/Makefile                          |   4 +-
 security/integrity/Kconfig                |   2 +-
 security/integrity/digsig.c               |  31 ++-
 security/integrity/digsig_asymmetric.c    |  44 +++--
 security/integrity/evm/evm_main.c         |   8 +-
 security/integrity/ima/Kconfig            |  13 ++
 security/integrity/ima/Makefile           |   1 +
 security/integrity/ima/ima.h              |  62 ++++++
 security/integrity/ima/ima_api.c          |   9 +-
 security/integrity/ima/ima_appraise.c     |  82 +++++++-
 security/integrity/ima/ima_main.c         |  29 ++-
 security/integrity/ima/ima_modsig.c       | 229 ++++++++++++++++++++++
 security/integrity/ima/ima_policy.c       |  81 ++++++--
 security/integrity/ima/ima_template.c     |  28 ++-
 security/integrity/ima/ima_template_lib.c |  49 ++++-
 security/integrity/ima/ima_template_lib.h |   2 +
 security/integrity/integrity.h            |  40 +++-
 30 files changed, 861 insertions(+), 124 deletions(-)
 create mode 100644 include/linux/module_signature.h
 create mode 100644 security/integrity/ima/ima_modsig.c
