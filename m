From: George Wilson <ltcgcw@us.ibm.com>
Subject: Re: [PATCH 0/8] KEYS: keyctl operations for asymmetric keys [ver #2]
Date: Thu, 5 Oct 2017 17:59:57 -0500
Message-ID: <20171005225957.GA13267@us.ibm.com>
References: <146668965425.2977.13357101274301968911.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mathew.j.martineau@linux.intel.com, dwmw2@infradead.org,
        tadeusz.struk@intel.com, linux-security-module@vger.kernel.org,
        keyrings@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, subras@us.ibm.com
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38070 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751083AbdJEXAH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Oct 2017 19:00:07 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v95MwYfD063576
        for <linux-crypto@vger.kernel.org>; Thu, 5 Oct 2017 19:00:06 -0400
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ddtx7gfe1-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Thu, 05 Oct 2017 19:00:06 -0400
Received: from localhost
        by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <ltcgcw@us.ibm.com>;
        Thu, 5 Oct 2017 19:00:05 -0400
Content-Disposition: inline
In-Reply-To: <146668965425.2977.13357101274301968911.stgit@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 23, 2016 at 02:47:34PM +0100, David Howells wrote:
> 
> Here's a set of patches that provides keyctl access for asymmetric keys,
> including a query function, and functions to do encryption, decryption,
> signature creation and signature verification.
> 
> I've added a PKCS#8 asymmetric key parser so that you can load an RSA private
> key into the kernel.  Currently only DER-encoded and unencrypted PKCS#8 is
> supported.  Encryption and verification can use a public key from an X.509
> cert, but signing and decryption require a private key, though encryption and
> verification can use that too.
> 
> Example usage:
> 
> 	j=`openssl pkcs8 -in private_key.pem -topk8 -nocrypt -outform DER | \
> 	    keyctl padd asymmetric foo @s`
> 	echo -n abcdefghijklmnopqrst >/tmp/data
> 	keyctl pkey_encrypt $j /tmp/data enc=pkcs1 >/tmp/enc
> 	keyctl pkey_decrypt $j /tmp/enc enc=pkcs1 >/tmp/dec
> 	cmp /tmp/data /tmp/dec
> 	keyctl pkey_sign $j /tmp/data enc=pkcs1 hash=sha1 >/tmp/sig
> 	keyctl pkey_verify $j /tmp/data /tmp/sig enc=pkcs1 hash=sha1
> 
> Changes:
> 
>  (*) I've taken out the password parameters for the moment as there isn't
>      yet a subtype that uses them.  I have, however, left space in the
>      keyctl UAPI to add them back later.
> 
> The kernel patches can be found here also:
> 
> 	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-asym-keyctl
> 
> The keyutils changes needed can be found here:
> 
> 	http://git.kernel.org/cgit/linux/kernel/git/dhowells/keyutils.git/log/?h=pkey
> 
> David
> ---
> David Howells (8):
>       KEYS: Provide key type operations for asymmetric key ops
>       KEYS: Provide keyctls to drive the new key type ops for asymmetric keys
>       KEYS: Provide missing asymmetric key subops for new key type ops
>       KEYS: Make the X.509 and PKCS7 parsers supply the sig encoding type
>       KEYS: Provide software public key query function
>       KEYS: Allow the public_key struct to hold a private key
>       KEYS: Implement encrypt, decrypt and sign for software asymmetric key
>       KEYS: Implement PKCS#8 RSA Private Key parser
> 
> 
>  Documentation/crypto/asymmetric-keys.txt  |   26 ++
>  Documentation/security/keys.txt           |  217 +++++++++++++++++++
>  crypto/asymmetric_keys/Kconfig            |   10 +
>  crypto/asymmetric_keys/Makefile           |   13 +
>  crypto/asymmetric_keys/asymmetric_keys.h  |    3 
>  crypto/asymmetric_keys/asymmetric_type.c  |   59 +++++
>  crypto/asymmetric_keys/pkcs7_parser.c     |    1 
>  crypto/asymmetric_keys/pkcs8.asn1         |   24 ++
>  crypto/asymmetric_keys/pkcs8_parser.c     |  184 +++++++++++++++++
>  crypto/asymmetric_keys/public_key.c       |  195 ++++++++++++++++--
>  crypto/asymmetric_keys/signature.c        |   95 +++++++++
>  crypto/asymmetric_keys/x509_cert_parser.c |   21 +-
>  include/crypto/public_key.h               |   14 +
>  include/keys/asymmetric-subtype.h         |    9 +
>  include/linux/key-type.h                  |   11 +
>  include/linux/keyctl.h                    |   46 ++++
>  include/uapi/linux/keyctl.h               |   30 +++
>  security/keys/Makefile                    |    1 
>  security/keys/compat.c                    |   18 ++
>  security/keys/internal.h                  |   39 ++++
>  security/keys/keyctl.c                    |   24 ++
>  security/keys/keyctl_pkey.c               |  323 +++++++++++++++++++++++++++++
>  22 files changed, 1319 insertions(+), 44 deletions(-)
>  create mode 100644 crypto/asymmetric_keys/pkcs8.asn1
>  create mode 100644 crypto/asymmetric_keys/pkcs8_parser.c
>  create mode 100644 include/linux/keyctl.h
>  create mode 100644 security/keys/keyctl_pkey.c
> 

Hi David,

To lend support for this patch series, we have a compelling use case in OpenPOWER
firmware.  We need to verify that our key management command queue elements are
properly signed.  However, we have limited flash storage space and want to avoid
dragging in a userspace library.  Sub Swaminathan (on copy) has prototyped a
solution using these patches.  We'd very much like to see them applied.

-- 
George Wilson
IBM Linux Technology Center
Security Development
