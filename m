From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 4/9] X.509: fix BUG_ON() when hash algorithm is unsupported
Date: Thu, 08 Feb 2018 15:07:30 +0000
Message-ID: <16536.1518102450@warthog.procyon.org.uk>
References: <20180207011012.5928-5-ebiggers3@gmail.com> <20180207011012.5928-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Michael Halcrow <mhalcrow@google.com>,
        Eric Biggers <ebiggers@google.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        stable@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180207011012.5928-5-ebiggers3@gmail.com>
Content-ID: <16535.1518102450.1@warthog.procyon.org.uk>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Eric Biggers <ebiggers3@gmail.com> wrote:

> The X.509 parser mishandles the case where the certificate's signature's
> hash algorithm is not available in the crypto API.  In this case,
> x509_get_sig_params() doesn't allocate the cert->sig->digest buffer; this
> part seems to be intentional.

Well, yes, that would be intentional: we can't digest the digestibles without
access to a hash algorithm to do so and we can't allocate a digest buffer
without knowing how big it should be.

> Fix this by making public_key_verify_signature() return -ENOPKG if the
> hash buffer has not been allocated.

Hmmm...  I'm not sure that this is the right place to do this, since it
obscures a potential invalid argument within the kernel.

I'm more inclined that the users of X.509 certs should check
x509->unsupported_sig (pkcs7_verify_sig_chain() does this already partially).

David
