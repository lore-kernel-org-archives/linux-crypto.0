From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/2] crypto: KEYS: convert public key to akcipher api
Date: Thu, 10 Dec 2015 13:25:57 -0500
Message-ID: <1449771957.2694.2.camel@linux.vnet.ibm.com>
References: <20151209235226.11783.57073.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, dhowells@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151209235226.11783.57073.stgit@tstruk-mobl1>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 2015-12-09 at 15:52 -0800, Tadeusz Struk wrote:
> This patch set converts the module verification and digital signature
> code to the new akcipher API.
> RSA implementation has been removed from crypto/asymmetric_keys and the
> new API is used for cryptographic primitives.
> There is no need for MPI above the akcipher API anymore.
> Modules can be verified with software as well as HW RSA implementations.

With these two patches my system doesn't even boot.  Digging deeper...

Mimi

> Patches generated against cryptodev-2.6
> ---
> 
> Tadeusz Struk (2):
>       crypto: KEYS: convert public key to the akcipher api
>       integrity: convert digsig to akcipher api
> 
> 
>  crypto/asymmetric_keys/Kconfig            |    2 
>  crypto/asymmetric_keys/Makefile           |    7 -
>  crypto/asymmetric_keys/pkcs7_parser.c     |   12 +-
>  crypto/asymmetric_keys/pkcs7_trust.c      |    2 
>  crypto/asymmetric_keys/pkcs7_verify.c     |    2 
>  crypto/asymmetric_keys/public_key.c       |   64 +++------
>  crypto/asymmetric_keys/public_key.h       |   36 -----
>  crypto/asymmetric_keys/rsa.c              |  211 +++++++++++------------------
>  crypto/asymmetric_keys/x509_cert_parser.c |   37 +----
>  crypto/asymmetric_keys/x509_public_key.c  |   17 +-
>  crypto/asymmetric_keys/x509_rsakey.asn1   |    4 -
>  include/crypto/public_key.h               |   49 ++-----
>  security/integrity/digsig_asymmetric.c    |   10 -
>  13 files changed, 138 insertions(+), 315 deletions(-)
>  delete mode 100644 crypto/asymmetric_keys/public_key.h
>  delete mode 100644 crypto/asymmetric_keys/x509_rsakey.asn1
> 
> --
> TS
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
