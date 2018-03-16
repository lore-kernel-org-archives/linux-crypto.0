From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: [PATCH v6 00/12] Appended signatures support for IMA appraisal
Date: Fri, 16 Mar 2018 17:38:25 -0300
Message-ID: <20180316203837.10174-1-bauerman@linux.vnet.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, linuxppc-dev@lists.ozlabs.org,
 Jessica Yu <jeyu@kernel.org>, linux-kernel@vger.kernel.org,
 James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>, "AKASHI,
 Takahiro" <takahiro.akashi@linaro.org>, linux-security-module@vger.kernel.org,
 keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
 Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
 Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>,
 Mimi Zohar <zohar@linux.vnet.ibm.com>, David Woodhouse <dwmw2@infradead.org>,
 "Serge E. Hallyn" <serge@hallyn.com>
To: linux-integrity@vger.kernel.org
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Id: linux-crypto.vger.kernel.org

Hello,

The main highlight in this version is that it's not necessary to appraise
the file before storing its measurement anymore. This is possible due to a
new approach that Mimi suggested: we decide whether the modsig should be
used or not at the time it is read from the file, while before we would
only make that decision when trying to verify its signature (i.e., at
appraisal time).

Now the modsig is only ignored if it references a signature that is not
present in IMA's keyring (or if there's a parsing error, obviously). If the
signature verification fails, then appraisal fails and the xattr signature
(if there is one) is not used as a fallback. With this change, we already
know which signature will be used for appraisal at the time the measurement
is stored in the measurement list.

Also, now IMA first tries to use the xattr signature and only if it doesn't
exist or uses a key which isn't in IMA's keyring it will look for a modsig.
This is because an xattr sig was most likely placed there by the system
admin, while the modsig most likely came from the OS vendor and thus the
former should be given preference. Also, since modsig is only allowed in
hooks which aren't in any hotpath, there's no practical gain in speed by
avoiding to read the xattr.

There's also a new template field called 'd-sig' which will store the
digest used for verification of the modsig in the measurement list.

Finally, I dropped the patches removing superfluous parentheses from
expressions, since they add a lot of churn and whether they're an actual
improvement or not is subjective.

These patches apply on top of today's linux-integrity/next-integrity.

They also require patch 4/4 from my cleanups series I posted a few days
ago, which isn't in next-integrity yet:

https://lkml.org/lkml/2018/3/14/1029

For convenience, I pushed these patches to the following branch:

https://github.com/bauermann/linux.git ima-modsig

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

Thiago Jung Bauermann (12):
  MODSIGN: Export module signature definitions
  PKCS#7: Introduce pkcs7_get_message_sig() and
    verify_pkcs7_message_sig()
  PKCS#7: Introduce pkcs7_get_digest()
  ima: Introduce is_ima_sig()
  integrity: Introduce integrity_keyring_from_id()
  integrity: Introduce asymmetric_sig_has_known_key()
  integrity: Select CONFIG_KEYS instead of depending on it
  ima: Export func_tokens
  ima: Add modsig appraise_type option for module-style appended
    signatures
  ima: Add functions to read and verify a modsig signature
  ima: Implement support for module-style appended signatures
  ima: Write modsig to the measurement list

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
 security/integrity/ima/Kconfig            |  13 ++
 security/integrity/ima/Makefile           |   1 +
 security/integrity/ima/ima.h              |  66 ++++++++++
 security/integrity/ima/ima_appraise.c     |  60 +++++++--
 security/integrity/ima/ima_main.c         |  21 ++-
 security/integrity/ima/ima_modsig.c       | 212 ++++++++++++++++++++++++++++++
 security/integrity/ima/ima_policy.c       |  24 ++--
 security/integrity/ima/ima_template.c     |   4 +-
 security/integrity/ima/ima_template_lib.c |  49 ++++++-
 security/integrity/ima/ima_template_lib.h |   2 +
 security/integrity/integrity.h            |  16 +++
 27 files changed, 693 insertions(+), 110 deletions(-)
 create mode 100644 include/linux/module_signature.h
 create mode 100644 security/integrity/ima/ima_modsig.c
