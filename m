From: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Subject: [PATCH 0/6] Appended signatures support for IMA appraisal
Date: Tue, 18 Apr 2017 17:17:40 -0300
Message-ID: <1492546666-16615-1-git-send-email-bauerman@linux.vnet.ibm.com>
Cc: linux-ima-devel@lists.sourceforge.net, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Claudio Carvalho <cclaudio@linux.vnet.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37432 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1757575AbdDRUSE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Apr 2017 16:18:04 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3IK3YRE011896
        for <linux-crypto@vger.kernel.org>; Tue, 18 Apr 2017 16:18:03 -0400
Received: from e24smtp03.br.ibm.com (e24smtp03.br.ibm.com [32.104.18.24])
        by mx0a-001b2d01.pphosted.com with ESMTP id 29wqpt56nr-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Tue, 18 Apr 2017 16:18:02 -0400
Received: from localhost
        by e24smtp03.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <bauerman@linux.vnet.ibm.com>;
        Tue, 18 Apr 2017 17:18:01 -0300
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On the OpenPOWER platform, secure boot and trusted boot are being
implemented using IMA for taking measurements and verifying signatures.
Since the kernel image on Power servers is an ELF binary, kernels are
signed using the scripts/sign-file tool and thus use the same signature
format as signed kernel modules.

This patch series adds support in IMA for verifying those signatures.
It adds flexibility to OpenPOWER secure boot, because it can boot kernels
with the signature appended to them as well as kernels where the signature
is stored in the IMA extended attribute.

The first four patches are cleanups and improvements that can be taken
independently from the others (and from each other as well). The last two
are the ones actually focused on this feature.

These patches apply on top of today's linux-security/next.

Thiago Jung Bauermann (6):
  integrity: Small code improvements
  ima: Tidy up constant strings
  ima: Simplify policy_func_show.
  ima: Log the same audit cause whenever a file has no signature
  MODSIGN: Export module signature definitions.
  ima: Support appended signatures for appraisal

 crypto/asymmetric_keys/asymmetric_type.c |  1 +
 crypto/asymmetric_keys/pkcs7_parser.c    | 12 +++++
 crypto/asymmetric_keys/pkcs7_verify.c    | 13 +++++
 include/crypto/pkcs7.h                   |  3 ++
 include/linux/module_signature.h         | 45 ++++++++++++++++
 include/linux/verification.h             |  1 +
 init/Kconfig                             |  6 ++-
 kernel/Makefile                          |  2 +-
 kernel/module_signing.c                  | 74 +++++++++++----------------
 security/integrity/Kconfig               |  2 +-
 security/integrity/digsig_asymmetric.c   |  4 +-
 security/integrity/iint.c                |  2 +-
 security/integrity/ima/Kconfig           | 13 +++++
 security/integrity/ima/ima.h             |  8 +++
 security/integrity/ima/ima_appraise.c    | 86 ++++++++++++++++++++++++++++++-
 security/integrity/ima/ima_init.c        |  2 +-
 security/integrity/ima/ima_main.c        | 30 +++++++++--
 security/integrity/ima/ima_policy.c      | 88 ++++++++++++--------------------
 security/integrity/integrity.h           | 27 ++++++----
 19 files changed, 302 insertions(+), 117 deletions(-)
 create mode 100644 include/linux/module_signature.h

-- 
2.7.4
