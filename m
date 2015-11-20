From: David Howells <dhowells@redhat.com>
Subject: [RFC] KEYS: Exposing {a,}symmetric key ops to userspace and other bits
Date: Fri, 20 Nov 2015 11:07:45 +0000
Message-ID: <23924.1448017665@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, dwmw2@infradead.org, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org
To: Marcel Holtmann <marcel@holtmann.org>, zohar@linux.vnet.ibm.com,
	Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759646AbbKTLIJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Nov 2015 06:08:09 -0500
Content-ID: <23923.1448017665.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Marcel, Mimi, Tadeus,

I want to consider adding or doing the following bits to the keyrings
facility, aiming for the next merge window:

 (*) Bring in the patches that I posted to change how the trust model on a
     keyring works.

     The model will then be that keys aren't automatically marked trusted, but
     linking a key into a keyring that is marked trusted-only will validate
     the key against the contents of the keyring before permitting its
     addition.

     Note that we can then vary the policy on a per-keyring basis.

 (*) Add Mimi's patches to allow keys/keyrings to be marked undeletable.  This
     is for the purpose of creating blacklists and to prevent people from
     removing entries in the blacklist.  Note that only the kernel can create
     a blacklist - we don't want userspace generating them as a way to take up
     kernel space.

     I think the right way to do this is to not allow marked keys to be
     unlinked from marked keyrings, but to allow marked keys to be unlinked
     from ordinary keyrings.

     The reason the 'keep' mark is required on individual keys is to prevent
     the keys from being directly revoked, expired or invalidated by keyctl
     without reference to the keyring.  Marked keys that are set expirable
     when they're created will still expire and be subsequently removed and if
     a marked key or marked keyring loses all its references it still gets
     gc'd.

 (*) Provide KEYCTL_{SIGN,VERIFY,ENCRYPT,DECRYPT} operations for use with
     asymmetric keys, allowing offload to hardware or use of the crypto
     routines for a software fallback.

     One question is as to how to set parameters.  The key will be specified
     by a key ID and this will set the crypto algorithm (eg. RSA, DSA, ECDSA,
     etc.) and the key size (eg. RSA-4096), but other parameters will need to
     be supplied such as:

     - Hash type.  I'm expecting the hash value to be passed through this
       interface not the data-to-be-hashed, but the type may need to be known
       for other purposes.

     - Password to decrypt the private key.  I'm not sure whether this should
       be presented at the point of key usage or the point of key
       instantiation.  The former means that you don't have an unsecured key
       sitting around in the kernel.

     Another question is what form the data should be presented.  In many
     ways, I would favour raw data with internal metadata attached as
     appropriate by userspace (eg. the hash algorithm OID included in a
     signature as per RFC4880 sec 5.2.2).  I would certainly rather avoid any
     ASN.1 or PGP encodings in this interface.

     One problem we have is that we only have four arguments to play with, one
     of which has to represent the key ID, but we need two buffers, two buffer
     lengths and some options per operation.  However, we could include the
     buffer lengths inside the options maybe:

	keyctl_sign(int key, const char *options, const void *data,
	            void *buffer);

     Another option is to allow a key to be queried for the buffer sizes and
     always require that amount of data - maybe something like:

	struct keyctl_asymmetric_info {
		unsigned encrypted_data_size;
		unsigned decrypted_data_size;
		unsigned signature_size;
		unsigned signed_data_size;
	} info;
	keyctl_query_asymmetric(key, &info);

     Possibly these values will all be the same, so we might only need get one
     value back.  I'm assuming here that userspace would do the dressing up of
     the data for signing with whatever metadata and padding is required.

 (*) In reference to the above, potentially provide a KEYCTL_KEY_UNLOCK that
     takes a key and password and gives you another key that has the private
     key unlocked that you can use temporarily and then discard.  I'm not sure
     how best to manage *hardware* private keys though - and I suspect that
     will be hardware dependent.

 (*) A TPM asymmetric key subtype that allows access to asymmetric keys stored
     in a TPM.

 (*) Provide KEYCTL_SEAL_KEY for sealing an asymmetric key to hardware.

 (*) Add a symmetric key type that acts as a container for a symmteric key,
     using either hardware or software, to be accessible through AF_ALG.

 (*) Provide a way to generate a new symmetric key, encrypting it with an
     asymmetric key inside the kernel.

     Again, how to parameterise is probably a tricky question.

 (*) Sort out the KEYCTL_UPDATE mess with trusted and encrypted keys.

David
