From: Marcel Holtmann <marcel@holtmann.org>
Subject: Limited usefulness of RSA set key function
Date: Sun, 2 Aug 2015 21:16:47 -0700
Message-ID: <BC087D1C-7D4D-4F6D-9644-B2043C3E39D3@holtmann.org>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:34397 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbbHCEQy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Aug 2015 00:16:54 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Tadeusz,

I have been working with the AF_ALG patches for akcipher lately and I find the RSA set key function way too limited. Especially the fact that it uses a format that I can not find a single reference / standard for worries me.

RsaKey ::= SEQUENCE {
        n INTEGER ({ rsa_get_n }),
        e INTEGER ({ rsa_get_e }),
        d INTEGER ({ rsa_get_d })
}

So where is this format coming from? I can find the RSA Public Key format which is a sequence of n and e. If you have a DER encoded RSA public key, then you can use it to encrypt and verify. So that is okay.

However if you have a standard Public Key that OpenSSL would create by default, then things do not work since that is actually a more complicated DER encoded format. However in the end, I would expect that we could also load such a key here. The RSA set key function should auto detect it and extract the right information if it is marked as rsaEncryption type.

My biggest concern however is that this does not reassemble the RSA Private Key at all. That key format is a sequence of 9 integers starting with a version. So logically I would expect that I can just set a RSA Private Key and then utilize the encrypt and decrypt features of the RSA cipher.

When it comes to exposing RSA via AF_ALG and akcipher, I really want standard format for the set key operation. Asking userspace to construct this Linux kernel only key format is not helpful. You want to be able to just load the RSA Private Key in DER format and be done with it.

Any ideas on how we can fix this to allow a sensible userspace API?

Regards

Marcel
