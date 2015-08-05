From: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: Proposal for adding setpubkey callback to akcipher_alg
Date: Tue, 4 Aug 2015 21:02:36 -0700
Message-ID: <DDF4B0CD-92AE-4EB4-97BE-9218CF7FA784@holtmann.org>
References: <905E1812-AD9B-4188-A668-3CD8985EA1BF@holtmann.org> <1704807.Rn4DsddD6R@tauon.atsec.com> <70C201C0-233D-4912-9856-C8C0E7A6A0FA@holtmann.org> <14682477.78a1L9JDin@myon.chronox.de> <3743CED6-E3E0-416E-9B82-F1677628E35E@holtmann.org> <20150805024600.GA3878@gondor.apana.org.au>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Stephan Mueller <smueller@chronox.de>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	David Howells <dhowells@redhat.com>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:52890 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbbHEECp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Aug 2015 00:02:45 -0400
In-Reply-To: <20150805024600.GA3878@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

>> RSA Private Key is n + e + d (including 6 other fields). RSA Public Key is n + e (no other fields).
>> 
>> So for RSA you would make setkey to take RSA Private Key and setpubkey to take RSA Public Key. Meaning you only have to use one of them since if you have the private key, you always have the public key.
>> 
>> This real difference here is that you can provide the key in two different key formats. As explained RSA uses two different format.
> 
> I don't have a problem with a setpubkey/setprivkey split interface.
> 
> However, I'm totally against importing MPI keys which is just silly.
> The BER-encoded keys are just raw integers.  Most of the hardware
> out there take raw integers.  So it makes no sense to have our
> interface take MPIs instead of raw integers, as this would mean
> converting into MPIs and then straight back into raw integers
> for hardware devices.


after looking further into this, the whole akcipher setkey should not operate on BER-encoded key blobs nor MPIs. Instead it should take a struct key as input and reference it.

For skcipher the key as binary blob thing works nicely, but for akcipher this is not a good interface. I prefer to have one interface for loading public/private keys and not have 2 or more different ways of loading and parsing these keys. That will get messy really quick. They are just magnitude more complicated than skcipher keys since they come in more complicated packaging.

We already have an interface that can handle asymmetric keys and it is easy to extend with new key formats and key types. So lets use that. I can clearly see that after RSA, we get DSA, ECDH etc. So having a simple way to handle these key formats is a good idea. That infrastructure is already in place and easy to extend if needed. Especially with the background that some keys might be actually in hardware or compiled into the kernel, the current asymmetric key interface has the right abstraction. It is also the right abstraction to deal with crypto hardware like TPM or even UEFI.

The nice advantage is that keys do not have to be copied around. The struct key supports referencing keys and it also ties nicely into process and user permissions. So essentially you reference your key for akcipher by struct key or from userspace indirectly via key_serial_t. No need to duplicate the key for each instance of the akcipher. There is only a single key. Especially when handling private keys, I prefer to keep them nicely in one place and not spread copies around kernel memory. Duplicating sensitive key material is a bad security practice.

It also avoids having to duplicate the ASN.1 parsing over and over again (I found 3 places that parse RSA keys at the moment). Have the asymmetric key interface parse the key once and stop duplicating this on every single attempt. This is especially helpful if your key comes in form of a certificate. We can validate the certificate and provide a key reference. More important we can also validate it against the kernel system keyring or a hardware provided keyring or certificate.

I really want to avoid that we are getting into the business of converting from format a to format b to format c because everybody invents their own ones. That is a bad API for me. And lets face it, when it comes to public key cryptography, there are standards we should follow. If the Linux kernel starts making up yet another format and interface, then we are doing a pretty bad job.

With the support for different sub-keytypes, we can really easily optimize the handling of struct key for the actual hardware in question. So instead of using an interim BER format or MPI or whatever, the keys can be parsed right into the correct format of the hardware that will eventually run the offload. This will be done once and we can avoid all the extra work.

Further more the important part for me is that when keys are actually bound to hardware, meaning we will never see the actual private key in kernel memory, we can still reference them. The selection of a hardware provided private key with a RSA cipher then can automatically select the right implementation for usage of that key. No point in trying a software RSA cipher if the key is only in hardware.

If the hardware supports RSA offload and has a private key storage of its own, why should that be treated any different than AES hardware engine. It is just that its usage is limited to its keys. However the interface of akcipher should handle this. If it does not, then we boxed ourselves into a corner and end up inventing new interfaces for these kinds of hardware. TPM and UEFI are such devices / services already out there. For me they are no different than skcipher offload. It is just that they are bound to a key and not just an instruction or hardware block.

The keys subsystem with the asymmetric key type should be responsible for loading and managing the keys. The crypto subsystem with akcipher should use these keys to run that cipher operation. That seems a clean logical split to me. It will us also give a nice interface that is extensible.

I have patches for most of this already written. There are some cleanups and fixes to be made. Once that is done I will send them for review.

The little more "boring" stuff is to use struct key with skcipher and extend AF_ALG with ALG_SET_KEY_ID. But I have implemented that as well. As I said, for symmetric keys it is not as important. It is however nice for AES operation if your key is already loaded as user key anyway.

Regards

Marcel
