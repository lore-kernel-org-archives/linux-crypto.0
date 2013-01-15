From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Subject: [RFC 0/1] ima/evm: signature verification support using asymmetric keys
Date: Tue, 15 Jan 2013 12:34:37 +0200
Message-ID: <cover.1358246017.git.dmitry.kasatkin@intel.com>
To: zohar@linux.vnet.ibm.com, dhowells@redhat.com, jmorris@namei.org,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga12.intel.com ([143.182.124.36]:19250 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756289Ab3AOKeq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Jan 2013 05:34:46 -0500
Received: by mail-bk0-f71.google.com with SMTP id jm19so4876820bkc.10
        for <linux-crypto@vger.kernel.org>; Tue, 15 Jan 2013 02:34:42 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Asymmetric keys were introduced in linux-3.7 to verify the signature on signed
kernel modules.  The asymmetric keys infrastructure abstracts the signature
verification from the crypto details.  This patch adds IMA/EVM signature
verification using asymmetric keys.  Support for additional signature
verification methods can now be delegated to the asymmetric key infrastructure.

Although the module signature header and the IMA/EVM signature header could
use the same header format, to minimize the signature length and save space
in the extended attribute, the IMA/EVM header format is different than the
module signature header.  The main difference is that the key identifier is
a sha1[12 - 19] hash of the key modulus and exponent and similar to the current
implementation. The only purpose is to identify corresponding key in the kernel
keyring. ima-evm-utils was updated to support the new signature format.

BR,
Dmitry

Dmitry Kasatkin (1):
  ima: digital signature verification using asymmetric keys

 security/integrity/Kconfig  |   12 +++++
 security/integrity/digsig.c |  103 ++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 114 insertions(+), 1 deletion(-)

-- 
1.7.10.4
