From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 0/8] X.509: Software public key subtype changes
Date: Mon, 22 Feb 2016 11:59:16 -0800
Message-ID: <56CB6894.3050004@intel.com>
References: <20160219171806.17223.91381.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-security-module@vger.kernel.org, zohar@linux.vnet.ibm.com,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:18293 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020AbcBVUDc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 22 Feb 2016 15:03:32 -0500
In-Reply-To: <20160219171806.17223.91381.stgit@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 02/19/2016 09:18 AM, David Howells wrote:
> 
> Here's a set of patches that cleans up the public key handling in the
> asymmetric key functions:
> 
>  (1) - (3) These are Tadeusz's RSA akcipher conversion.

Thanks for taking this David.

> 
>  (4) This removes all knowledge of RSA from the software public key
>      asymmetric key subtype.  Instead, the public key type and the hash
>      type are indicated to the crypto layer and the RSA module there does
>      all the appropriate encoding.
> 
>  (5) This changes the various algorithm IDs to text labels instead of enums
>      as the strings are what we actually deal with (printing, passing to
>      the crypto layer).
> 
>  (6) This separates the private parts of the software public key subtype
>      into a private header in the implementation directory.
> 
>  (7) This renames public_key.c to software_pkey.c and changes the Kconfig
>      symbol to match.
> 
>  (8) This renames symbols beginning "public_key" to "software_pkey" except
>      struct for public_key_signature which is a wider API component.
> 
> The patches can be found here also:
> 
> 	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-rsa
> 
> David
> ---
> David Howells (5):
>       akcipher: Move the RSA DER encoding to the crypto layer
>       X.509: Make algo identifiers text instead of enum
>       X.509: Make the public_key asymmetric key type internal data private
>       X.509: Rename public_key.c to software_pkey.c
>       X.509: Rename public_key* to software_pkey*
> 
> Tadeusz Struk (3):
>       crypto: KEYS: convert public key and digsig asym to the akcipher api
>       integrity: convert digsig to akcipher api
>       crypto: public_key: remove MPIs from public_key_signature struct
> 
> 
>  arch/s390/configs/default_defconfig       |    2 
>  arch/s390/configs/gcov_defconfig          |    2 
>  arch/s390/configs/performance_defconfig   |    2 
>  crypto/asymmetric_keys/Kconfig            |   17 +-
>  crypto/asymmetric_keys/Makefile           |   10 -
>  crypto/asymmetric_keys/mscode_parser.c    |   14 +
>  crypto/asymmetric_keys/pkcs7_parser.c     |   30 +--
>  crypto/asymmetric_keys/pkcs7_trust.c      |    2 
>  crypto/asymmetric_keys/pkcs7_verify.c     |   12 +
>  crypto/asymmetric_keys/public_key.c       |  130 --------------
>  crypto/asymmetric_keys/public_key.h       |   36 ----
>  crypto/asymmetric_keys/rsa.c              |  278 -----------------------------
>  crypto/asymmetric_keys/software_pkey.c    |  142 +++++++++++++++
>  crypto/asymmetric_keys/software_pkey.h    |   33 +++
>  crypto/asymmetric_keys/verify_pefile.c    |    4 
>  crypto/asymmetric_keys/verify_pefile.h    |    2 
>  crypto/asymmetric_keys/x509_cert_parser.c |   67 ++-----
>  crypto/asymmetric_keys/x509_parser.h      |    4 
>  crypto/asymmetric_keys/x509_public_key.c  |   43 ++--
>  crypto/asymmetric_keys/x509_rsakey.asn1   |    4 
>  crypto/rsa.c                              |  210 +++++++++++++++++++---
>  crypto/testmgr.c                          |    5 -
>  include/crypto/akcipher.h                 |    7 +
>  include/crypto/public_key.h               |   79 +-------
>  init/Kconfig                              |    4 
>  kernel/module_signing.c                   |    6 +
>  security/integrity/Kconfig                |    3 
>  security/integrity/digsig_asymmetric.c    |   16 +-
>  28 files changed, 467 insertions(+), 697 deletions(-)
>  delete mode 100644 crypto/asymmetric_keys/public_key.c
>  delete mode 100644 crypto/asymmetric_keys/public_key.h
>  delete mode 100644 crypto/asymmetric_keys/rsa.c
>  create mode 100644 crypto/asymmetric_keys/software_pkey.c
>  create mode 100644 crypto/asymmetric_keys/software_pkey.h
>  delete mode 100644 crypto/asymmetric_keys/x509_rsakey.asn1
> 

-- 
TS
