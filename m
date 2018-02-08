From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 8/9] X.509: remove dead code that set ->unsupported_sig
Date: Thu, 08 Feb 2018 15:27:09 +0000
Message-ID: <17830.1518103629@warthog.procyon.org.uk>
References: <20180207011012.5928-9-ebiggers3@gmail.com> <20180207011012.5928-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Michael Halcrow <mhalcrow@google.com>,
        Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:35214 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750882AbeBHP1M (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Feb 2018 10:27:12 -0500
In-Reply-To: <20180207011012.5928-9-ebiggers3@gmail.com>
Content-ID: <17829.1518103629.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Eric Biggers <ebiggers3@gmail.com> wrote:

> The X.509 parser is guaranteed to set cert->sig->pkey_algo and
> cert->sig->hash_algo, since x509_note_pkey_algo() is a mandatory action
> in the X.509 ASN.1 grammar, and it returns an error code if an
> unrecognized AlgorithmIdentifier is given rather than leaving the
> algorithms as NULL.

I'm leaning towards ENOPKG production here being deferred so that X.509 certs
that we can't verify can still be built into the kernel or loaded from
'trusted' sources.

Let me think about this a bit more.

David
