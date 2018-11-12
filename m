Return-Path: <SRS0=oFif=NX=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47504 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727109AbeKLWhF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Nov 2018 17:37:05 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20181112102423.30415-9-roberto.sassu@huawei.com>
References: <20181112102423.30415-9-roberto.sassu@huawei.com> <20181112102423.30415-1-roberto.sassu@huawei.com>
To: Roberto Sassu <roberto.sassu@huawei.com>
Cc: dhowells@redhat.com, dwmw2@infradead.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        silviu.vlasceanu@huawei.com
Subject: Re: [RFC][PATCH 08/12] KEYS: PGP-based public key signature verification
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <19984.1542026635.1@warthog.procyon.org.uk>
Date: Mon, 12 Nov 2018 12:43:55 +0000
Message-ID: <19985.1542026635@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Roberto Sassu <roberto.sassu@huawei.com> wrote:

> - switch from session to user keyring (Roberto Sassu)
> - search user keyring only if no keyring was provided, so that the
>   trustworthiness of the signature depends on the type of keyring
>   containing the key used for signature verification (Roberto Sassu)

Er.  No.  You should search the session keyring.  This may contain a link to
the user keyring (pam_keyinit emplaces one).

You need to consider what it is that the patch trying to achieve.

David
