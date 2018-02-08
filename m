From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 6/9] PKCS#7: remove unnecessary check for NULL sinfo->sig->hash_algo
Date: Thu, 08 Feb 2018 15:13:03 +0000
Message-ID: <17221.1518102783@warthog.procyon.org.uk>
References: <20180207011012.5928-7-ebiggers3@gmail.com> <20180207011012.5928-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Michael Halcrow <mhalcrow@google.com>,
        Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:56396 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750929AbeBHPNF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Feb 2018 10:13:05 -0500
In-Reply-To: <20180207011012.5928-7-ebiggers3@gmail.com>
Content-ID: <17220.1518102783.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Eric Biggers <ebiggers3@gmail.com> wrote:

> The PKCS#7 parser is guaranteed to set ->sig->hash_algo for every
> SignerInfo, since pkcs7_sig_note_digest_algo() is a mandatory action in
> the PKCS#7 ASN.1 grammar, and it returns an error code if an
> unrecognized DigestAlgorithmIdentifier is given rather than leaving the
> algorithm as NULL.  Therefore, remove the unnecessary NULL check.

Actually, we might be better off deferring ENOPKG generation as we might have
multiple signatures, at least one of which does have a digest algorithm that
we can handle.

David
