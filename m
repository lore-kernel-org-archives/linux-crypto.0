From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: [PATCH v4 0/7] Appended signatures support for IMA appraisal
Date: Fri,  4 Aug 2017 19:03:23 -0300
Message-ID: <20170804220330.30026-1-bauerman@linux.vnet.ibm.com>
Cc: linux-ima-devel@lists.sourceforge.net, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jessica Yu <jeyu@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "AKASHI, Takahiro" <takahiro.akashi@linaro.org>,
        Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello,

This version implements an approach suggested by Mimi Zohar, which is that
if the modsig is valid, ima_appraise_measurement will now copy the hash
calculated by the verification process into the iint cache. This ensures
that the hash will appear in the measurement list and used to extend the
TPM PCR.

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

Since modsig is only supported on some specific hooks which don't get
called often (cf. ima_hook_supports_modsig), it's possible to always check
for the presence of an appended modsig before looking for the xattr sig. In
that case, the policy doesn't need to be changed to support the modsig
keyword. Is that preferable than requiring the policy to explicitly allow a
modsig like this code does?

I tested these patches with EVM and I believe they don't break it and
things work as expected, but I'm not really familiar with EVM and its use
cases so this should be taken with a grain of salt.

I also verified that the code correctly recalculates the file hash if the
modsig verification fails and the file also has an xattr signature which
uses a different hash algorithm.

These patches apply on top of today's linux-security/next.

Changes since v3:
- Patch "integrity: Introduce struct evm_hmac_xattr"
  - Renamed new struct to evm_xattr.
  - Define struct evm_xattr using struct evm_ima_xattr_data, and moved it
    from evm.h to integrity.h (suggested by Mimi Zohar).
- Patch "PKCS#7: Introduce verify_pkcs7_message_sig"
  - Also introduce pkcs7_get_message_sig.
- Patch "ima: Support appended signatures for appraisal"
  - Moved check for buffer presence and size from ima_appraise_measurement
    to ima_read_modsig (suggested by Mimi Zohar).
  - Factored out handling of ima_read_xattr return value into
    process_xattr_error in ima_appraise_measurement so that it can be used
    if the modsig verification fails.
  - Pass NULL xattr_value to evm_verifyxattr even in the case of xattr
    signature in ima_appraise_measurement (suggested by Mimi Zohar).
  - Use switch statement provided by Mimi Zohar to check result of
    evm_verifyxattr.
  - If the modsig verification succeeds, copy the hash calculated during
    the verification to the iint cache (suggested by Mimi Zohar).
  - Substitute recursion in ima_appraise_measurement by a goto statement
    back to the main switch statement (suggested by Mimi Zohar).

Changes since v2:
- Patch "MODSIGN: Export module signature definitions."
  - Put change introducing function verify_pkcs7_message_signature into
    its own patch (suggested by Mimi Zohar).
  - Shortened validate_module_signature to validate_module_sig.

- Patch "PKCS#7: Introduce verify_pkcs7_message_sig"
  - New patch in this series.
  - Shortened verify_pkcs7_message_signature to verify_pkcs7_message_sig.

- Patch "integrity: Introduce integrity_keyring_from_id"
  - New patch in this series.

- Patch "integrity: Select CONFIG_KEYS instead of depending on it"
  - New patch in this series.

- Patch "ima: Store measurement after appraisal"
  - New patch in this series.
  - Instead of creating function measure_and_appraise, simply call
    ima_appraise_measurement before ima_store_measurement in
    process_measurement (suggested by Mimi Zohar).

- Patch "ima: Support appended signatures for appraisal"
  - Put change introducing function integrity_keyring_from_id into
    its own patch (suggested by Mimi Zohar).
  - Put change to select CONFIG_KEYS in its own patch.
  - Put change in the order of measure and appraise steps into
    its own patch (suggested by Mimi Zohar).
  - Add buf and size arguments to ima_appraise_measurement. Also,
    pass xattr_value and xattr_len by reference so that the function can
    change them to point to the modsig.
  - Don't pass buf_len by reference in ima_read_modsig. It doesn't need
    to be changed anymore now that the hash calculated by the collect step
    covers the whole file instead of skipping the modsig at the end.
  - Don't add pkcs7_get_message_sig. It's not necessary anymore. Ditto for
    ima_get_modsig_hash_algo.
  - Don't change ima_collect_measurement anymore to recalculate the file
    hash if the algorithm is different, since now it doesn't have anything
    to do with the hash used by the modsig.
  - Don't change ima_get_hash_alog anymore to obtain the hash algo used by
    the modsig, since it isn't used in the collect step.
  - Change ima_appraise_measurement to check whether there is a modsig
    before verifying the xattr if the policy rule allows a modsig.
  - Use separate if clause to check result of evm_verifyxattr when
    appraising modsig (suggested by Mimi Zohar).
  - Use bool variable in ima_inode_setxattr to make code clearer (suggested
    by Mimi Zohar).
  - Don't define pr_fmt in ima_main.c.
  - Renamed struct signature_modsig_hdr to modsig_hdr.

Changes since v1:
- Patch "integrity: Small code improvements"
  - Add missing #endif comment in ima.h.

- Patch "ima: Tidy up constant strings"
  - Squashed into previous patch.

- Patch "ima: Simplify policy_func_show."
  - Generate ima_hooks enum and func_tokens array from a single macro.
    (suggested by Mimi)
  - Further simplify policy_func_show by not using the printf format string
    from the policy_tokens table.

- Patch "integrity: Introduce struct evm_hmac_xattr"
  - New patch.

- Patch "MODSIGN: Export module signature definitions."
  - Add function verify_pkcs7_message_signature which takes a
    struct pkcs7_message.
  - Move MODULE_SIG_STRING definition from <linux/module.h> to
    <linux/module_signature.h>.

- Patch "ima: Support appended signatures for appraisal"
  - Changed name from appended_sig to modsig. (suggested by Mehmet Kayaalp)
  - Don't add key_being_used_for value VERIFYING_KEXEC_CMS_SIGNATURE. Use
    existing VERIFYING_MODULE_SIGNATURE. (suggested by Mimi)
  - Moved modsig code to its own file. (suggested by Mimi)
  - Added new xattr "subtype" IMA_MODSIG. (suggested by Mimi)
  - Check whether a hook supports modsig when the policy is being parsed.
    (suggested by Mimi)
  - If the modsig verification fails, look for an xattr signature.
    (suggested by Mimi)
  - Add integrity_keyring_from_id function.
  - Put modsig to measurement list if the template requires the signature
    contents. (suggested by Mimi).

Thiago Jung Bauermann (7):
  integrity: Introduce struct evm_xattr
  MODSIGN: Export module signature definitions
  PKCS#7: Introduce pkcs7_get_message_sig and verify_pkcs7_message_sig
  integrity: Introduce integrity_keyring_from_id
  integrity: Select CONFIG_KEYS instead of depending on it
  ima: Store measurement after appraisal
  ima: Support module-style appended signatures for appraisal

 certs/system_keyring.c                    |  60 +++++++---
 crypto/asymmetric_keys/pkcs7_parser.c     |  12 ++
 include/crypto/pkcs7.h                    |   2 +
 include/linux/module.h                    |   3 -
 include/linux/module_signature.h          |  47 ++++++++
 include/linux/verification.h              |  10 ++
 init/Kconfig                              |   6 +-
 kernel/Makefile                           |   2 +-
 kernel/module.c                           |   1 +
 kernel/module_signing.c                   |  74 +++++-------
 security/integrity/Kconfig                |   2 +-
 security/integrity/digsig.c               |  28 +++--
 security/integrity/evm/evm_crypto.c       |   4 +-
 security/integrity/evm/evm_main.c         |  10 +-
 security/integrity/ima/Kconfig            |  13 +++
 security/integrity/ima/Makefile           |   1 +
 security/integrity/ima/ima.h              |  70 ++++++++++-
 security/integrity/ima/ima_appraise.c     | 185 +++++++++++++++++++++++++-----
 security/integrity/ima/ima_main.c         |   9 +-
 security/integrity/ima/ima_modsig.c       | 178 ++++++++++++++++++++++++++++
 security/integrity/ima/ima_policy.c       |  26 +++--
 security/integrity/ima/ima_template_lib.c |  14 ++-
 security/integrity/integrity.h            |  10 +-
 23 files changed, 634 insertions(+), 133 deletions(-)
 create mode 100644 include/linux/module_signature.h
 create mode 100644 security/integrity/ima/ima_modsig.c

-- 
2.13.0

