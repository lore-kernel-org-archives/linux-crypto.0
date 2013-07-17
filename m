From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [RFC][PATCH 00/20] ima: larger digests and template support
Date: Wed, 17 Jul 2013 19:51:20 -0400
Message-ID: <1374105100-25880-1-git-send-email-zohar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
	linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>
To: linux-security-module@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:48995 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757632Ab3GRALc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Jul 2013 20:11:32 -0400
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
	Wed, 17 Jul 2013 18:11:31 -0600
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Support for additional hash algorithms with larger digests, as well as
support for additional file metadata, in the IMA measurement list, have
been proposed for a long time.  Unfortunately, the IMA measurement list
entries, which are exposed to userspace via the securityfs
ascii/binary_runtime_measurement lists, are fixed length.  Any changes
to the measurement list would impact existing userspace tools.

This patch set defines an extensible template architecture and support
for larger hash algorithms.  A description of the new template
architecture is described in the "ima: new templates management
mechanism" patch description and, with more detail, in
Documentation/security/IMA-templates.txt.  The two initial templates
defined are: the original 'ima', for backwards compatibility, and
'ima-ng', which eliminates the digest and pathname size limitations.
Future templates will include file metadata, such as uid/gid and LSM
object/subject labels.

Larger hash algorithms, used for file data signature verification, is
also required to conform to various standards.

The first 9 patches add support for additional, larger hash
algorithms used in both the IMA measurement list and for file signature
verification, but isn't enabled until support for the new template
architecture is enabled.

Patches from 10 to 12 are preparatory for the subsequent changes.

Patches from 13 to 16 introduce the new template architecture
and the last group effectively enables it by allowing users to
choose their desired template either from the kernel configuration
and from the kernel command line.

Mimi Zohar

Dmitry Kasatkin (8):
  crypto: provide single place for hash algo information
  keys: change asymmetric keys to use common hash definitions
  ima: provide support for arbitrary hash algorithms
  ima: read and use signature hash algorithm
  ima: use dynamically allocated hash storage
  ima: provide dedicated hash algo allocation function
  ima: support arbitrary hash algorithms in ima_calc_buffer_hash
  ima: ima_calc_boot_agregate must use SHA1

Mimi Zohar (3):
  ima: differentiate between template hash and file data hash sizes
  ima: add Kconfig default measurement list template
  ima: enable support for larger default filedata hash algorithms

Roberto Sassu (9):
  ima: pass the file descriptor to ima_add_violation()
  ima: pass the filename argument up to ima_add_template_entry()
  ima: define new function ima_alloc_init_template() to API
  ima: new templates management mechanism
  ima: define template fields library and new helpers
  ima: define new template ima-ng and template fields d-ng and n-ng
  ima: switch to new template management mechanism
  ima: defer determining the appraisal hash algorithm for 'ima' template
  ima: define kernel parameter 'ima_template=' to change configured
    default

 Documentation/kernel-parameters.txt       |  11 +-
 Documentation/security/00-INDEX           |   2 +
 Documentation/security/IMA-templates.txt  |  87 +++++++++
 crypto/Kconfig                            |   3 +
 crypto/Makefile                           |   1 +
 crypto/asymmetric_keys/Kconfig            |   1 +
 crypto/asymmetric_keys/public_key.c       |  12 --
 crypto/asymmetric_keys/rsa.c              |  14 +-
 crypto/asymmetric_keys/x509_cert_parser.c |  12 +-
 crypto/asymmetric_keys/x509_parser.h      |   2 +-
 crypto/asymmetric_keys/x509_public_key.c  |   4 +-
 crypto/hash_info.c                        |  56 ++++++
 include/crypto/hash_info.h                |  40 ++++
 include/crypto/public_key.h               |  18 +-
 include/uapi/linux/hash_info.h            |  37 ++++
 kernel/module_signing.c                   |   8 +-
 security/integrity/digsig_asymmetric.c    |  11 --
 security/integrity/iint.c                 |   2 +
 security/integrity/ima/Kconfig            |  61 ++++++
 security/integrity/ima/Makefile           |   2 +-
 security/integrity/ima/ima.h              |  95 +++++++--
 security/integrity/ima/ima_api.c          | 119 ++++++++----
 security/integrity/ima/ima_appraise.c     |  60 ++++--
 security/integrity/ima/ima_crypto.c       | 131 +++++++++++--
 security/integrity/ima/ima_fs.c           |  64 +++---
 security/integrity/ima/ima_init.c         |  37 ++--
 security/integrity/ima/ima_main.c         |  50 ++++-
 security/integrity/ima/ima_queue.c        |  10 +-
 security/integrity/ima/ima_template.c     | 175 +++++++++++++++++
 security/integrity/ima/ima_template_lib.c | 313 ++++++++++++++++++++++++++++++
 security/integrity/ima/ima_template_lib.h |  39 ++++
 security/integrity/integrity.h            |  26 ++-
 32 files changed, 1300 insertions(+), 203 deletions(-)
 create mode 100644 Documentation/security/IMA-templates.txt
 create mode 100644 crypto/hash_info.c
 create mode 100644 include/crypto/hash_info.h
 create mode 100644 include/uapi/linux/hash_info.h
 create mode 100644 security/integrity/ima/ima_template.c
 create mode 100644 security/integrity/ima/ima_template_lib.c
 create mode 100644 security/integrity/ima/ima_template_lib.h

-- 
1.8.1.4
