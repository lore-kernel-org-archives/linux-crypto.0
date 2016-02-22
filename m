From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 4/8] akcipher: Move the RSA DER encoding to the crypto layer
Date: Mon, 22 Feb 2016 22:28:10 +0000
Message-ID: <1562.1456180090@warthog.procyon.org.uk>
References: <56CB68A2.50505@intel.com> <20160219171806.17223.91381.stgit@warthog.procyon.org.uk> <20160219171836.17223.9507.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: dhowells@redhat.com, keyrings@vger.kernel.org,
	linux-security-module@vger.kernel.org, zohar@linux.vnet.ibm.com,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56CB68A2.50505@intel.com>
Content-ID: <1561.1456180090.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Tadeusz Struk <tadeusz.struk@intel.com> wrote:

> I wonder if this should be merged with the crypto/rsa-pkcs1pad.c template
> that we already have. Looks like the two do the same padding now.
> Should we merge then and pass the hash param as a separate template param,
> e.g the public_key would allocate "pkcs1pad(rsa, sha1)"?

Ummm...  Possibly.  Is that how it's used?

	warthog>git grep pkcs1pad -- Documentation
	warthog1>

Anyway, the problem I have with this is that I want to get that knowledge out
of the asymmetric key in-software public key subtype.  It knows "rsa", "dsa",
"ecdsa", ... because that's all the OIDs tell it.

I guess if I have to, I can stoop to converting "rsa" to "pkcs1pad(rsa, sha1)".

Can you do me a really quick merge?  -rc5 is already out, and I want to get it
to James pronto - plus I have things that are pending on this change being
made.

Oh - and how does the padding template find the algorithm DER encoding string
to use?  I have wondered whether it should be stored in with the hash
algorithm, but it probably makes more sense to keep it with the rsa module.

David
