From: Stephan Mueller <smueller@chronox.de>
Subject: Re: Limited usefulness of RSA set key function
Date: Mon, 03 Aug 2015 08:45:37 +0200
Message-ID: <3848823.PNN01JLIZu@tauon.atsec.com>
References: <BC087D1C-7D4D-4F6D-9644-B2043C3E39D3@holtmann.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	linux-crypto@vger.kernel.org
To: Marcel Holtmann <marcel@holtmann.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:48068 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199AbbHCGpl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Aug 2015 02:45:41 -0400
In-Reply-To: <BC087D1C-7D4D-4F6D-9644-B2043C3E39D3@holtmann.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Sonntag, 2. August 2015, 21:16:47 schrieb Marcel Holtmann:

Hi Marcel,

>Hi Tadeusz,
>
>I have been working with the AF_ALG patches for akcipher lately and I find
>the RSA set key function way too limited. Especially the fact that it uses a
>format that I can not find a single reference / standard for worries me.
>
>RsaKey ::= SEQUENCE {
>        n INTEGER ({ rsa_get_n }),
>        e INTEGER ({ rsa_get_e }),
>        d INTEGER ({ rsa_get_d })
>}

Note, the kernel uses BER encoding.
>
>So where is this format coming from? I can find the RSA Public Key format
>which is a sequence of n and e. If you have a DER encoded RSA public key,
>then you can use it to encrypt and verify. So that is okay.
>
>However if you have a standard Public Key that OpenSSL would create by
>default, then things do not work since that is actually a more complicated
>DER encoded format. However in the end, I would expect that we could also
>load such a key here. The RSA set key function should auto detect it and
>extract the right information if it is marked as rsaEncryption type.

Do you propose to add a DER parser to the kernel? I feel that the BER parser 
is complex enough. If somebody has a DER key, user space should have the code 
to convert it to BER.
>
>My biggest concern however is that this does not reassemble the RSA Private
>Key at all. That key format is a sequence of 9 integers starting with a
>version. So logically I would expect that I can just set a RSA Private Key
>and then utilize the encrypt and decrypt features of the RSA cipher.

Why do you think this is not possible? testmgr.h seems to exactly do that.
>
>When it comes to exposing RSA via AF_ALG and akcipher, I really want standard
>format for the set key operation. Asking userspace to construct this Linux
>kernel only key format is not helpful. You want to be able to just load the
>RSA Private Key in DER format and be done with it.

I am all for it. BER is a standard, is it not? Yes, I have not yet seen a 
converter for DER to BER (and I have not searched for one either). But I feel 
DER should be left to user space.
>
>Any ideas on how we can fix this to allow a sensible userspace API?

I actually planned to add a BER encoder to my libkcapi. I feel that should be 
right place to provide that code, including a potential DER to BER converter.

Ciao
Stephan
