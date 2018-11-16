Return-Path: <SRS0=1iZj=N3=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37220 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725804AbeKQGWG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Nov 2018 01:22:06 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wAGK4CQk026125
        for <linux-crypto@vger.kernel.org>; Fri, 16 Nov 2018 15:08:16 -0500
Received: from e14.ny.us.ibm.com (e14.ny.us.ibm.com [129.33.205.204])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2nt24t62j0-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Fri, 16 Nov 2018 15:08:16 -0500
Received: from localhost
        by e14.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <bauerman@linux.ibm.com>;
        Fri, 16 Nov 2018 20:08:15 -0000
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
Subject: [PATCH v8 00/14] Appended signatures support for IMA appraisal
Date: Fri, 16 Nov 2018 18:06:58 -0200
Message-Id: <20181116200712.14154-1-bauerman@linux.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

v8 is just a rebase on top of today's linux-integrity/next-integrity.
There aren't any noteworthy changes since v7, which is why I'm keeping its
description below:

The main difference in v7 is the addition of the last patch, which ensures
that there will always be a measurement entry containing the appended
modsig if one was used to appraise the file. The patch description and
comments in the code should explain in which circumstances the patch proved
necessary.

Apart from that, there was some small cleaning up of the code, and merging
and splitting of patches. The changelog below has the details.

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

Changes since v5:
- Patch "ima: Remove some superfluous parentheses"
  - Dropped.

- Patch "evm, ima: Remove superfluous parentheses"
  - Dropped.

- Patch "evm, ima: Remove more superfluous parentheses"
  - Dropped.

- Patch "ima: Don't pass xattr value to EVM xattr verification."
  - Dropped.

- Patch "ima: Store measurement after appraisal"
  - Dropped.

- Patch "MODSIGN: Export module signature definitions"
  - Reduced changes to the code that was moved into validate_module_sig()
    to the minimum necessary (suggested by Mimi Zohar).
  - Added SPDX license identifier.

- Patch "PKCS#7: Introduce pkcs7_get_message_sig() and verify_pkcs7_message_sig()"
  - In the hypothetical case that there's more than one sinfo, changed
    pkcs7_get_message_sig() to return NULL instead of the first sinfo's sig.
  - Dropped Mimi's Reviewed-by because of the code change above.

- Patch "PKCS#7: Introduce pkcs7_get_digest()"
  - New patch.

- Patch "integrity: Introduce integrity_keyring_from_id"
  - Add stub in case CONFIG_INTEGRITY_SIGNATURE isn't set.

- Patch "integrity: Introduce asymmetric_sig_has_known_key()"
  - New patch.

- Patch "ima: Introduce is_ima_sig"
  - New patch, with code from "ima: Improvements in ima_appraise_measurement"

- Patch "ima: Add modsig appraise_type option for module-style appended signatures"
  - Changed appraise_type to accept "imasig|modsig" instead of
    "modsig|imasig" to reflect the fact that now IMA only looks for
    the modsig after failing to find a suitable imasig stored in the xattr.
  - Added SPDX license identifier.

- Patch "ima: Add functions to read and verify a modsig signature"
  - Changed ima_read_modsig() to abort loading the modsig if it uses a key
    which isn't known to IMA.
  - Changed ima_get_modsig_hash() to use pkcs7_get_digest().

- Patch "ima: Implement support for module-style appended signatures"
  - Added ima_xattr_sig_known_key() auxiliary function.
  - Call ima_read_modsig() directly from process_measurement() instead of
    from ima_appraise_measurement(), and only if there's no xattr signature
    or if the xattr signature uses a key which isn't known to IMA.
  - hash_algo in process_measurement() is always obtained from the xattr
    signature, never from the modsig.
  - Changes to ima_appraise_measurement() are a lot simpler now, and don't
    involve going back to the main switch statement a second time.
  - Pass xattr_value to evm_verifyxattr() unless xattr_value is a modsig.

- Patch "ima: Write modsig to the measurement list"
  - Since now we determine whether we'll use an xattr sig or a modsig
    at the time they are read, there's no need to store a measurement
    again in the modsig case. Thus, this patch doesn't need to change
    ima_store_measurement() nor process_measurement() anymore.
  - Define new "d-sig" template field which holds the digest that is
    expected to match the one contained in the modsig.
  - Moved addition of ima_modsig_serialize_data() to patch "ima: Add
    functions to read and verify a modsig signature".
  - Increase MAX_TEMPLATE_NAME_LEN to 24.

Changes since v4:
- Patch "ima: Remove redundant conditional operator"
  - New patch.

- Patch "ima: Remove some superfluous parentheses"
  - New patch.

- Patch "evm, ima: Remove superfluous parentheses"
  - New patch.

- Patch "evm, ima: Remove more superfluous parentheses"
  - New patch.

- Patch "ima: Simplify ima_eventsig_init"
  - New patch.

- Patch "ima: Improvements in ima_appraise_measurement"
  - New patch.

- Patch "ima: Don't pass xattr value to EVM xattr verification."
  - New patch.

- Patch "ima: Export func_tokens"
  - Split from patch "ima: Support module-style appended signatures for
    appraisal".

- Patch "ima: Add modsig appraise_type option for module-style appended
         signatures"
  - Split from patch "ima: Support module-style appended signatures for
    appraisal".
  - Mention modsig option in Documentation/ABI/testing/ima_policy
    (suggested by Mimi Zohar).

- Patch "ima: Add functions to read and verify a modsig signature"
  - Split from patch "ima: Support module-style appended signatures for
    appraisal".

- Patch "ima: Implement support for module-style appended signatures"
  - Split from patch "ima: Support module-style appended signatures for
    appraisal".
  - In ima_appraise_measurement, change the logic of dealing with xattr
    errors in case the modsig verification fails. With this,
    process_xattr_error isn't needed anymore.

- Patch "ima: Write modsig to the measurement list"
  - Split from patch "ima: Support module-style appended signatures for
    appraisal".
  - Added ima_current_template_has_sig function.
  - Removed hdr parameter from ima_modsig_serialize_data.
  - In ima_store_measurement, continue processing even if the given PCR
    is already measured if it's for a modsig.
  - In process_measurement, add exception to store measurement even if
    IMA_MEASURE is not set when appraising a modsig (suggested by
    Mimi Zohar).
  - Call is_ima_sig in ima_eventsig_init.

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
 certs/system_keyring.c                    |  61 +++++--
 crypto/asymmetric_keys/pkcs7_parser.c     |  16 ++
 crypto/asymmetric_keys/pkcs7_verify.c     |  25 +++
 include/crypto/pkcs7.h                    |   5 +
 include/linux/module.h                    |   3 -
 include/linux/module_signature.h          |  47 +++++
 include/linux/verification.h              |  10 +
 init/Kconfig                              |   6 +-
 kernel/Makefile                           |   2 +-
 kernel/module.c                           |   1 +
 kernel/module_signing.c                   |  82 ++++-----
 security/integrity/Kconfig                |   2 +-
 security/integrity/digsig.c               |  28 ++-
 security/integrity/digsig_asymmetric.c    |  44 +++--
 security/integrity/evm/evm_main.c         |   8 +-
 security/integrity/ima/Kconfig            |  13 ++
 security/integrity/ima/Makefile           |   1 +
 security/integrity/ima/ima.h              |  67 +++++++
 security/integrity/ima/ima_api.c          |   8 +-
 security/integrity/ima/ima_appraise.c     |  79 ++++++--
 security/integrity/ima/ima_main.c         |  33 +++-
 security/integrity/ima/ima_modsig.c       | 212 ++++++++++++++++++++++
 security/integrity/ima/ima_policy.c       |  81 +++++++--
 security/integrity/ima/ima_template.c     |  31 +++-
 security/integrity/ima/ima_template_lib.c |  49 ++++-
 security/integrity/ima/ima_template_lib.h |   2 +
 security/integrity/integrity.h            |  30 ++-
 29 files changed, 829 insertions(+), 128 deletions(-)
 create mode 100644 include/linux/module_signature.h
 create mode 100644 security/integrity/ima/ima_modsig.c
