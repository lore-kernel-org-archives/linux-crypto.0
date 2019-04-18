Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88B5DC10F14
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 03:51:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61FCE21850
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 03:51:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387442AbfDRDvr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Apr 2019 23:51:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60438 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387829AbfDRDvr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Apr 2019 23:51:47 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3I3o8VK115905
        for <linux-crypto@vger.kernel.org>; Wed, 17 Apr 2019 23:51:45 -0400
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2rxee6p2nj-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Wed, 17 Apr 2019 23:51:45 -0400
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <bauerman@linux.ibm.com>;
        Thu, 18 Apr 2019 04:51:44 +0100
Received: from b03cxnp08025.gho.boulder.ibm.com (9.17.130.17)
        by e36.co.us.ibm.com (192.168.1.136) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 18 Apr 2019 04:51:39 +0100
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x3I3pciK12517432
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Apr 2019 03:51:38 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41AB27805F;
        Thu, 18 Apr 2019 03:51:38 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C474C7805E;
        Thu, 18 Apr 2019 03:51:33 +0000 (GMT)
Received: from morokweng.localdomain.com (unknown [9.85.230.182])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 18 Apr 2019 03:51:33 +0000 (GMT)
From:   Thiago Jung Bauermann <bauerman@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
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
Subject: [PATCH v10 00/12] Appended signatures support for IMA appraisal
Date:   Thu, 18 Apr 2019 00:51:08 -0300
X-Mailer: git-send-email 2.17.2
X-TM-AS-GCONF: 00
x-cbid: 19041803-0020-0000-0000-00000ED91E02
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00010947; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000284; SDB=6.01190665; UDB=6.00623948; IPR=6.00971462;
 MB=3.00026493; MTD=3.00000008; XFM=3.00000015; UTC=2019-04-18 03:51:44
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19041803-0021-0000-0000-0000657949F0
Message-Id: <20190418035120.2354-1-bauerman@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-18_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904180023
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

There are two big changes in this version:

1. The modsig contents aren't stored anymore in the struct xattr_value which
is passed around in IMA for the xattr sig or digest. Instead, a new struct
modsig argument is passed alongside xattr_value in relevant IMA functions.
This change was suggested by Mimi Zohar, and allowed cleaner handling of the
modsig in the code (especially in process_measurement()).

2. There are separate template fields for the modsig and its digest. This
was also suggested by Mimi Zhoar. Because of this change, we don't need to
know anymore at measurement time whether the modsig or the xattr sig will be
used for appraisal (in the case where a file has both types of signature
available). This avoids needing to peek at the xattr sig and at the modsig
to see if their signatures use known keys, which we had to do before in
order to know at measurement time which sig would be used for appraisal, so
that we would store the correct signature in the measurement list.

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

Changes since v9:

- Patch "MODSIGN: Export module signature definitions"
  - Moved mod_check_sig() to a new file so that CONFIG_IMA_APPRAISE_MODSIG
    doesn't have to depend on CONFIG_MODULES.
  - Changed scripts/Makefile to build sign-file if CONFIG_MODULE_SIG_FORMAT
    is set.
  - Removed Mimi's Reviewed-by because of the changes in this version.

- Patch "PKCS#7: Refactor verify_pkcs7_signature()"
  - Don't add function pkcs7_get_message_sig() anymore, since it's not
    needed in the current version.

- Patch "PKCS#7: Introduce pkcs7_get_digest()"
  - Changed 'len' argument from 'u8 *' to 'u32 *'.
  - Added 'hash_algo' argument to obtain the algo used for the digest.
  - Don't check whether 'buf', 'len' and 'hash_algo' output arguments are NULL,
    since the function's only caller always sets them.
  - Removed Mimi's Reviewed-by because of the changes in this version.

- Patch "integrity: Introduce asymmetric_sig_has_known_key()"
  - Dropped.

- Patch "integrity: Introduce integrity_keyring_from_id"
  - Squashed into "ima: Implement support for module-style appended signatures"
  - Changed integrity_keyring_from_id() to a static function (suggested by Mimi
    Zohar).

- Patch "ima: Introduce is_signed()"
  - Dropped.

- Patch "ima: Export func_tokens"
  - Squashed into "ima: Implement support for module-style appended signatures"

- Patch "ima: Use designated initializers for struct ima_event_data"
  - New patch.

- Patch "ima: Factor xattr_verify() out of ima_appraise_measurement()"
  - New patch.

- Patch "ima: Implement support for module-style appended signatures"
  - Renamed 'struct modsig_hdr' to 'struct modsig'.
  - Added integrity_modsig_verify() to integrity/digsig.c so that it's not
    necessary to export integrity_keyring_from_id() (Suggested by Mimi Zohar).
  - Don't add functions ima_xattr_sig_known_key() and
    modsig_has_known_key() since they're not necessary anymore.
  - Added modsig argument to ima_appraise_measurement().
  - Verify modsig in a separate function called by ima_appraise_measurement().
  - Renamed ima_read_collect_modsig() to ima_read_modsig(), with a separate
    collect function added in patch "ima: Collect modsig" (suggested by Mimi
    Zohar).
  - In ima_read_modsig(), moved code saving of raw PKCS7 data to 'struct
    modsig' to patch "ima: Collect modsig".
  - In ima_read_modsig(), moved all parts related to the modsig hash to
    patch "ima: Collect modsig".
  - In ima_read_modsig(), don't check if the buf pointer is NULL since it's
    never supposed to happen.
  - Renamed ima_free_xattr_data() to ima_free_modsig().
  - No need to check for modsig in ima_read_xattr() and
    ima_inode_set_xattr() anymore.
  - In ima_modsig_verify(), don't check if the modsig pointer is NULL since
    it's not supposed to happen.
  - Don't define IMA_MODSIG element in enum evm_ima_xattr_type.

- Patch "ima: Collect modsig"
  - New patch.

- Patch "ima: Define ima-modsig template"
  - Patch renamed from "ima: Add new "d-sig" template field"
  - Renamed 'd-sig' template field to 'd-modsig'.
  - Added 'modsig' template field.
  - Added 'ima-modsig' defined template descriptor.
  - Renamed ima_modsig_serialize_data() to ima_modsig_serialize().
  - Renamed ima_get_modsig_hash() to ima_get_modsig_digest(). Also the
    function is a lot simpler now since what it used to do is now done in
    ima_collect_modsig() and pkcs7_get_digest().
  - Added check for failed modsig collection in ima_eventdigest_modsig_init().
  - Added modsig argument to ima_store_measurement().
  - Added 'modsig' field to struct ima_event_data.
  - Removed check for modsig == NULL in ima_get_modsig_digest() and in
    ima_modsig_serialize_data() since their callers already performs that
    check.
  - Moved check_current_template_modsig() to this patch, previously was in
    "ima: Store the measurement again when appraising a modsig".

- Patch "ima: Store the measurement again when appraising a modsig"
  - Renamed ima_template_has_sig() to ima_template_has_modsig().
  - Added a change to ima_collect_measurement(), making it to call
    ima_collect_modsig() even if IMA_COLLECT is set in iint->flags.
  - Removed IMA_READ_MEASURE flag.
  - Renamed template_has_sig global variable to template_has_modsig.
  - Renamed find_sig_in_template() to find_modsig_in_template().

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

Thiago Jung Bauermann (12):
  MODSIGN: Export module signature definitions
  PKCS#7: Refactor verify_pkcs7_signature()
  PKCS#7: Introduce pkcs7_get_digest()
  integrity: Introduce struct evm_xattr
  integrity: Select CONFIG_KEYS instead of depending on it
  ima: Use designated initializers for struct ima_event_data
  ima: Add modsig appraise_type option for module-style appended
    signatures
  ima: Factor xattr_verify() out of ima_appraise_measurement()
  ima: Implement support for module-style appended signatures
  ima: Collect modsig
  ima: Define ima-modsig template
  ima: Store the measurement again when appraising a modsig

 Documentation/ABI/testing/ima_policy      |   6 +-
 Documentation/security/IMA-templates.rst  |   7 +-
 certs/system_keyring.c                    |  61 +++++--
 crypto/asymmetric_keys/pkcs7_verify.c     |  33 ++++
 include/crypto/pkcs7.h                    |   4 +
 include/linux/module.h                    |   3 -
 include/linux/module_signature.h          |  44 +++++
 include/linux/verification.h              |  10 ++
 init/Kconfig                              |   6 +-
 kernel/Makefile                           |   1 +
 kernel/module.c                           |   1 +
 kernel/module_signature.c                 |  45 +++++
 kernel/module_signing.c                   |  56 +-----
 scripts/Makefile                          |   2 +-
 security/integrity/Kconfig                |   2 +-
 security/integrity/digsig.c               |  39 ++++-
 security/integrity/evm/evm_main.c         |   8 +-
 security/integrity/ima/Kconfig            |  13 ++
 security/integrity/ima/Makefile           |   1 +
 security/integrity/ima/ima.h              |  61 ++++++-
 security/integrity/ima/ima_api.c          |  33 +++-
 security/integrity/ima/ima_appraise.c     | 198 ++++++++++++++--------
 security/integrity/ima/ima_init.c         |   4 +-
 security/integrity/ima/ima_main.c         |  23 ++-
 security/integrity/ima/ima_modsig.c       | 169 ++++++++++++++++++
 security/integrity/ima/ima_policy.c       |  64 ++++++-
 security/integrity/ima/ima_template.c     |  31 +++-
 security/integrity/ima/ima_template_lib.c |  60 ++++++-
 security/integrity/ima/ima_template_lib.h |   4 +
 security/integrity/integrity.h            |  26 +++
 30 files changed, 836 insertions(+), 179 deletions(-)
 create mode 100644 include/linux/module_signature.h
 create mode 100644 kernel/module_signature.c
 create mode 100644 security/integrity/ima/ima_modsig.c

