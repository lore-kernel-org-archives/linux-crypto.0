Return-Path: <SRS0=fnEV=PW=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.51]:20868 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbfANTSU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Jan 2019 14:18:20 -0500
From: Stephan Mueller <smueller@chronox.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, keyrings@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Chen Yu <yu.c.chen@intel.com>,
        Oliver Neukum <oneukum@suse.com>,
        Ryan Chen <yu.chen.surf@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Giovanni Gherdovich <ggherdovich@suse.cz>,
        Randy Dunlap <rdunlap@infradead.org>,
        Jann Horn <jannh@google.com>,
        Andy Lutomirski <luto@kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 4/6] crypto: hkdf - RFC5869 Key Derivation Function
Date: Mon, 14 Jan 2019 19:44:22 +0100
Message-ID: <1693060.JDmgY16SMQ@tauon.chronox.de>
In-Reply-To: <20190114175315.GB7644@gmail.com>
References: <20190103143227.9138-1-jlee@suse.com> <4734428.Gj5BGI4uxL@positron.chronox.de> <20190114175315.GB7644@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 14. Januar 2019, 18:53:16 CET schrieb Eric Biggers:

Hi Eric,

> > I would not suggest this, because that rounds contrary to the concept of
> > the kernel crypto API IMHO. The caller has to provide the wrapping
> > cipher. It is perfectly viable to allow a caller to invoke a specific
> > keyed message digest.
> Sure, but it would not conform to the HKDF specification.  Are you sure it
> is okay to specify an arbitrary keyed hash?

Technically, I see no issue why this should not be possible. You see that with 
the SP800-108 KDF implementations where using CMAC is perfectly legal (and 
which I also test).

Though, using another keyed hash implementation like CMAC is not covered by 
the HKDF spec. If a caller would use hkdf(cmac(aes)), it would produce 
cryptographically strong values. Though this implementation does not conform 
to any standard. I do not think we should prevent a caller to select such 
combination in the kernel crypto API.

IMHO there would even be valid reasons why one would use cmac(aes) for a kdf. 
For example, when you would want to use a hardware AES which somehow also 
employs a hardware key that is inaccessible to software in order to tie the 
KDF result to the local hardware. This could even be a valid use case for Ext4 
FBE encryption where you derive a key. The KDF could be used to link the 
derived key to the local hardware to prevent the encrypted data could be 
copied to another system and decrypted successfully there.

Ciao
Stephan
