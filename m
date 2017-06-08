From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: [PATCH v2 0/6] Appended signatures support for IMA appraisal
Date: Wed,  7 Jun 2017 22:49:09 -0300
Message-ID: <1496886555-10082-1-git-send-email-bauerman@linux.vnet.ibm.com>
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52699 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751437AbdFHBtr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Jun 2017 21:49:47 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v581mpxs016205
        for <linux-crypto@vger.kernel.org>; Wed, 7 Jun 2017 21:49:47 -0400
Received: from e24smtp04.br.ibm.com (e24smtp04.br.ibm.com [32.104.18.25])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2axs0s8jn3-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Wed, 07 Jun 2017 21:49:46 -0400
Received: from localhost
        by e24smtp04.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <bauerman@linux.vnet.ibm.com>;
        Wed, 7 Jun 2017 22:49:45 -0300
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On the OpenPOWER platform, secure boot and trusted boot are being
implemented using IMA for taking measurements and verifying signatures.
Since the kernel image on Power servers is an ELF binary, kernels are
signed using the scripts/sign-file tool and thus use the same signature
format as signed kernel modules.

This patch series adds support in IMA for verifying those signatures.
It adds flexibility to OpenPOWER secure boot, because it allows it to boot
kernels with the signature appended to them as well as kernels where the
signature is stored in the IMA extended attribute.

The first four patches are cleanups and improvements that can be taken
independently from the others (and from each other as well). The last two
are the ones actually focused on this feature.

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

These patches apply on top of today's linux-integrity/next.

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

Thiago Jung Bauermann (6):
  integrity: Small code improvements
  ima: Simplify policy_func_show.
  ima: Log the same audit cause whenever a file has no signature
  integrity: Introduce struct evm_hmac_xattr
  MODSIGN: Export module signature definitions.
  ima: Support module-style appended signatures for appraisal

 certs/system_keyring.c                    |  62 ++++++++---
 crypto/asymmetric_keys/pkcs7_parser.c     |  12 +++
 include/crypto/pkcs7.h                    |   3 +
 include/linux/module.h                    |   3 -
 include/linux/module_signature.h          |  48 +++++++++
 include/linux/verification.h              |  10 ++
 init/Kconfig                              |   6 +-
 kernel/Makefile                           |   2 +-
 kernel/module.c                           |   1 +
 kernel/module_signing.c                   |  74 ++++++-------
 security/integrity/Kconfig                |   2 +-
 security/integrity/digsig.c               |  28 +++--
 security/integrity/digsig_asymmetric.c    |   4 +-
 security/integrity/evm/evm.h              |   5 +
 security/integrity/evm/evm_crypto.c       |   2 +-
 security/integrity/evm/evm_main.c         |   8 +-
 security/integrity/iint.c                 |   2 +-
 security/integrity/ima/Kconfig            |  13 +++
 security/integrity/ima/Makefile           |   1 +
 security/integrity/ima/ima.h              |  78 ++++++++++++--
 security/integrity/ima/ima_api.c          |   2 +-
 security/integrity/ima/ima_appraise.c     |  52 +++++++---
 security/integrity/ima/ima_main.c         |  91 ++++++++++++----
 security/integrity/ima/ima_modsig.c       | 167 ++++++++++++++++++++++++++++++
 security/integrity/ima/ima_policy.c       |  82 ++++-----------
 security/integrity/ima/ima_template_lib.c |  14 ++-
 security/integrity/integrity.h            |  14 ++-
 27 files changed, 591 insertions(+), 195 deletions(-)
 create mode 100644 include/linux/module_signature.h
 create mode 100644 security/integrity/ima/ima_modsig.c

-- 
2.7.4
