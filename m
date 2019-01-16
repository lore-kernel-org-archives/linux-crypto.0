Return-Path: <SRS0=g5s/=PY=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41574 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730514AbfAPQTO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Jan 2019 11:19:14 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20190106133608.820-3-vt@altlinux.org>
References: <20190106133608.820-3-vt@altlinux.org> <20190106133608.820-1-vt@altlinux.org>
To: Vitaly Chikunov <vt@altlinux.org>
Cc: dhowells@redhat.com, Herbert Xu <herbert@gondor.apana.org.au>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/4] akcipher: Introduce verify2 for public key algorithms
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <21753.1547655551.1@warthog.procyon.org.uk>
Date: Wed, 16 Jan 2019 16:19:11 +0000
Message-ID: <21754.1547655551@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Vitaly Chikunov <vt@altlinux.org> wrote:

> Current akcipher .verify() just decrypts signature to uncover message
> hash, which is then verified in upper level public_key_verify_signature
> by memcmp with the expected signature value, which is never passed into
> verify().

I think it would be better to make ->verify() take the data hash we've been
given rather than returning the expected hash for the caller to compare.  That
way the callers don't have to do two different things, depending on how the
crypto algo works.

David
