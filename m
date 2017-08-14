From: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH v8 0/4] crypto: add algif_akcipher user space API
Date: Mon, 14 Aug 2017 08:26:22 +0200
Message-ID: <959CA6EF-E63F-4116-A02C-153D5C436879@holtmann.org>
References: <26359147.tCiuJ5s8mz@positron.chronox.de>
 <CAOq732KZ6nNkix6P1yxYCcfRrF7Zby5qeP9WpcBR6Z_=7MFaNA@mail.gmail.com>
 <alpine.OSX.2.21.1708111158510.37345@bciftcio-mobl.amr.corp.intel.com>
 <3253864.NSkFVeIncy@tauon.chronox.de>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Andrew Zaborowski <balrogg@googlemail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <david@woodhou.se>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from coyote.holtmann.net ([212.227.132.17]:34587 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750965AbdHNG0Z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Aug 2017 02:26:25 -0400
In-Reply-To: <3253864.NSkFVeIncy@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

>> I also would like to have more of those algorithms exposed to userspace,
>> and I'd like to make sure the API is a good fit. There was extensive
>> discussion of AF_ALG akcipher last year. v8 of the patch set updates the
>> implementation but doesn't address the API concerns that kept the previous
>> versions from being merged, so we seem to be at just as much of an impasse
>> as before.
> 
> During last year's discussion, I think we have concluded (and please correct 
> me if I miss something), that the export of the asymmetric HW implementations 
> to user space should
> 
> - allow a streaming mode where the user space uses the kernel as an 
> accelerator (maybe user space has another way of storing keys)

explain to me what a streaming mode with an asymmetric cipher is? They are no good for these kind of operations. If you want streaming mode, then you want a symmetric cipher.

The keyring subsystem is actually a good storage for keys. If the keyring subsystem can use hardware storage for the keys, even better. However right now all the certificates and its associated keys are stored perfectly fine in a keyring.

> - allow the private key to be retained in kernel space (or even in hardware 
> only) -- i.e. user space only has a handle to the key for a full asym 
> operation

And that is exactly my point. Even if userspace has the key, let it load into the kernel as a key inside a keyring. We do not need two ways for loading asymmetric keys. They are by nature more complex then any symmetric key.

> The first part is clearly where AF_ALG fits and keyctl does not. This is 
> provided with the current patch set. As the keyctl API only handles, well, 
> keys, access to the raw ciphers may not be possible through this API. And let 
> us face it, a lot of user space code shall support many different OSes. Thus, 
> if you have a crypto lib in user space who has its own key management (which 
> is a core element of such libraries and thus cannot be put into an 
> architecture-dependent code part), having only the keyctl API on Linux for 
> accelerated asym support may not be helpful.

That argument is just non-sense. The crypto libraries that run on multiple OSes have already enough abstraction layers to deal with this. And frankly there it would be preferred if hardware backed keys are handled properly. Since that is what is really needed.

Also I have to repeat my comment from above. The asymmetric ciphers are really bad for any kind of streaming operation. Using them in that way is almost always going to end badly.

David Howells has patches for sign/verify/encrypt/decrypt operation. Keep in mind that all the parameters of the asymmetric keys are really bound to its cipher. So it is pretty obvious that the key itself defines what cipher is used. I do not get the wish for raw access to RSA or ECDH for example. You need the right set of keys and parameters first. Otherwise it is all garbage and not even guaranteed to be cryptographically secure.

> The second part is a keyctl domain. I see in-kernel support for this scenario, 
> but have not yet seen the kernel/user interface nor the user space support.

Actually have you looked at Mat’s kernel tree and the support for it in ELL.

> Both options are orthogonal, IMHO.

I don’t agree with that. As explained above, asymmetric ciphers are bound to their keys. For me this all feels like a hammer approach. You want to treat things as nails since that is the only thing you have. However that is not the case. We have the keyring subsystem.

> Tadeusz Struck provided a patch to link the kernel crypto API / algif_akcipher 
> with the keys subsystem to allow the second requirement to be implemented in 
> algif_akcipher. That patch is on my desk and I plan to integrate it and even 
> make it generic to allow its use for all different cipher types. I have not 
> yet integrated it to allow a small patch set to be reviewed. If it is the will 
> of the council, I can surely add that code to the initial patch set and 
> resubmit.

For symmetric ciphers this is awesome. For asymmetric ciphers I have no idea on how this would work. Once you provided the key handle, then the crypto subsystem would have to select the cipher. However that is not how it is designed. You are binding a cipher early one. In addition, depending on the key, you would need to choose the right hardware to execute on (in case of hardware bound keys). It is also not designed for this either.

So I have no idea how you want to overcome the design limitations / choices of AF_ALG when it comes to supporting assymetric ciphers correctly.

Regards

Marcel
