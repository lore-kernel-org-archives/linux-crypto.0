From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: [PATCH v5 00/18] Appended signatures support for IMA appraisal
Date: Tue, 17 Oct 2017 22:53:13 -0200
Message-ID: <20171018005331.2688-1-bauerman@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
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
To: linux-integrity@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57798 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756528AbdJRAyA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Oct 2017 20:54:00 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v9I0rUBp102642
        for <linux-crypto@vger.kernel.org>; Tue, 17 Oct 2017 20:54:00 -0400
Received: from e12.ny.us.ibm.com (e12.ny.us.ibm.com [129.33.205.202])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2dnswk6f49-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Tue, 17 Oct 2017 20:53:59 -0400
Received: from localhost
        by e12.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <bauerman@linux.vnet.ibm.com>;
        Tue, 17 Oct 2017 20:53:58 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

The main highlight in this version is that it fixes a bug where the modsig
wasn't being included in the measurement list if the appraised file was
already measured by another rule. The fix is in the last patch.

Another change is that the last patch in the v4 series ("ima: Support
module-style appended signatures for appraisal") has been broken up into
smaller patches. I may have overdone it...

Finally, I have added some patches removing superfluous parentheses from
expressions. IMO these patches make it easier (and more pleasant) to read
the code, and thus easier to understand it. Since I'm not sure how welcome
the changes are, I split them in 3 "levels" in increasing potential for
conflict with patches from other people (they can be squashed together when
applied):

1. patch 2 contains the bare minimum, changing only lines that are also
   touched by other patches in the series;

2. patch 3 cleans up all the files that are touched by this patch series;

3. patch 4 cleans up all other EVM and IMA files that weren't already fixed
   by the previous patches.

If unwanted, patches 3 and 4 can be simply skipped without affecting the
rest of the patches. I have already rebased them from v4.13-rc2 to
v4.14-rc3 and now to linux-integrity/next with very few easy to resolve
conflicts, so I think they are worth keeping.

These patches apply on top of today's linux-integrity/next.

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

Thiago Jung Bauermann (18):
  ima: Remove redundant conditional operator
  ima: Remove some superfluous parentheses
  evm, ima: Remove superfluous parentheses
  evm, ima: Remove more superfluous parentheses
  ima: Simplify ima_eventsig_init
  ima: Improvements in ima_appraise_measurement
  integrity: Introduce struct evm_xattr
  integrity: Select CONFIG_KEYS instead of depending on it
  ima: Don't pass xattr value to EVM xattr verification.
  ima: Store measurement after appraisal
  ima: Export func_tokens
  MODSIGN: Export module signature definitions
  PKCS#7: Introduce pkcs7_get_message_sig and verify_pkcs7_message_sig
  integrity: Introduce integrity_keyring_from_id
  ima: Add modsig appraise_type option for module-style appended
    signatures
  ima: Add functions to read and verify a modsig signature
  ima: Implement support for module-style appended signatures
  ima: Write modsig to the measurement list

 Documentation/ABI/testing/ima_policy      |   6 +-
 certs/system_keyring.c                    |  60 +++++++---
 crypto/asymmetric_keys/pkcs7_parser.c     |  12 ++
 include/crypto/pkcs7.h                    |   2 +
 include/linux/module.h                    |   3 -
 include/linux/module_signature.h          |  47 ++++++++
 include/linux/verification.h              |  10 ++
 init/Kconfig                              |   6 +-
 kernel/Makefile                           |   2 +-
 kernel/module.c                           |   1 +
 kernel/module_signing.c                   |  74 ++++++-------
 security/integrity/Kconfig                |   2 +-
 security/integrity/digsig.c               |  28 +++--
 security/integrity/evm/evm_crypto.c       |   6 +-
 security/integrity/evm/evm_main.c         |  23 ++--
 security/integrity/evm/evm_posix_acl.c    |   8 +-
 security/integrity/ima/Kconfig            |  13 +++
 security/integrity/ima/Makefile           |   1 +
 security/integrity/ima/ima.h              |  75 ++++++++++++-
 security/integrity/ima/ima_api.c          |  10 +-
 security/integrity/ima/ima_appraise.c     | 166 +++++++++++++++++++++++-----
 security/integrity/ima/ima_fs.c           |   6 +-
 security/integrity/ima/ima_main.c         |  50 +++++++--
 security/integrity/ima/ima_modsig.c       | 176 ++++++++++++++++++++++++++++++
 security/integrity/ima/ima_policy.c       |  65 ++++++-----
 security/integrity/ima/ima_queue.c        |   6 +-
 security/integrity/ima/ima_template.c     |  37 ++++---
 security/integrity/ima/ima_template_lib.c |  30 +++--
 security/integrity/integrity.h            |  10 +-
 29 files changed, 739 insertions(+), 196 deletions(-)
 create mode 100644 include/linux/module_signature.h
 create mode 100644 security/integrity/ima/ima_modsig.c
