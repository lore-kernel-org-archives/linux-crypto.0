From: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Subject: [PATCH v7 00/14] Appended signatures support for IMA appraisal
Date: Tue, 22 May 2018 21:12:39 -0300
Message-ID: <20180523001253.15247-1-bauerman@linux.ibm.com>
Cc: linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "AKASHI, Takahiro" <takahiro.akashi@linaro.org>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>
To: linux-integrity@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello,

The main difference in this version is the addition of the last patch, which
ensures that there will always be a measurement entry containing the appended
modsig if one was used to appraise the file. The patch description and comments
in the code should explain in which circumstances the patch proved necessary.

Apart from that, there was some small cleaning up of the code, and merging and
splitting of patches. The changelog below has the details.

These patches apply on top of today's linux-integrity/next-integrity.

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

- Patch "ima: Write modsig to the measurement list"
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
 certs/system_keyring.c                    |  61 ++++++---
 crypto/asymmetric_keys/pkcs7_parser.c     |  16 +++
 crypto/asymmetric_keys/pkcs7_verify.c     |  25 ++++
 include/crypto/pkcs7.h                    |   5 +
 include/linux/module.h                    |   3 -
 include/linux/module_signature.h          |  44 +++++++
 include/linux/verification.h              |  10 ++
 init/Kconfig                              |   6 +-
 kernel/Makefile                           |   2 +-
 kernel/module.c                           |   1 +
 kernel/module_signing.c                   |  77 +++++------
 security/integrity/Kconfig                |   2 +-
 security/integrity/digsig.c               |  28 +++-
 security/integrity/digsig_asymmetric.c    |  44 +++++--
 security/integrity/evm/evm_crypto.c       |   4 +-
 security/integrity/evm/evm_main.c         |  10 +-
 security/integrity/ima/Kconfig            |  13 ++
 security/integrity/ima/Makefile           |   1 +
 security/integrity/ima/ima.h              |  67 ++++++++++
 security/integrity/ima/ima_api.c          |   8 +-
 security/integrity/ima/ima_appraise.c     |  78 +++++++++--
 security/integrity/ima/ima_main.c         |  33 ++++-
 security/integrity/ima/ima_modsig.c       | 212 ++++++++++++++++++++++++++++++
 security/integrity/ima/ima_policy.c       |  81 ++++++++++--
 security/integrity/ima/ima_template.c     |  31 ++++-
 security/integrity/ima/ima_template_lib.c |  49 ++++++-
 security/integrity/ima/ima_template_lib.h |   2 +
 security/integrity/integrity.h            |  30 ++++-
 30 files changed, 825 insertions(+), 129 deletions(-)
 create mode 100644 include/linux/module_signature.h
 create mode 100644 security/integrity/ima/ima_modsig.c
