Return-Path: <SRS0=ZXsK=OT=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from lhrrgout.huawei.com ([185.176.76.210]:32807 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726841AbeLJSFC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Dec 2018 13:05:02 -0500
Subject: Re: [RFC][PATCH 08/12] KEYS: PGP-based public key signature
 verification
To: David Howells <dhowells@redhat.com>
CC: <dwmw2@infradead.org>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <keyrings@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <linux-integrity@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <silviu.vlasceanu@huawei.com>
References: <e55a9f80-d2ea-f28f-06ab-3d99786096c4@huawei.com>
 <20181112102423.30415-9-roberto.sassu@huawei.com>
 <20181112102423.30415-1-roberto.sassu@huawei.com>
 <19985.1542026635@warthog.procyon.org.uk>
 <17488.1544461088@warthog.procyon.org.uk>
From: Roberto Sassu <roberto.sassu@huawei.com>
Message-ID: <12cec606-c31e-9321-b63f-7122ce068179@huawei.com>
Date: Mon, 10 Dec 2018 19:04:53 +0100
MIME-Version: 1.0
In-Reply-To: <17488.1544461088@warthog.procyon.org.uk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12/10/2018 5:58 PM, David Howells wrote:
> Roberto Sassu <roberto.sassu@huawei.com> wrote:
> 
>>> You need to consider what it is that the patch trying to achieve.
>>
>> I understood that the purpose is to check PGP signatures with built-in
>> keys or keys provided by the user. Since using the session keyring
>> caused the issue I reported, I thought it was ok to use the user
>> keyring.
>>
>> Just a note: the original patches were relying on KEY_FLAG_TRUSTED to
>> determine if a key is trusted; now the trustworthiness depends on the
>> type of keyring passed to pgp_verify_sig(). I removed the additional key
>> search in the user (session) keyring to prevent that signature
>> verification is done with a key provided by the user even when the
>> caller of pgp_verify_sig() expects that a trusted key is used. The
>> search in the session keyring is done if the caller of pgp_verify_sig()
>> sets the keyring pointer to NULL.
> 
> Thinking about these patches further, as you point out, the way that trust is
> computed has changed.  There is no no KEY_FLAG_TRUSTED; rather, a key is
> assumed to be trusted if it's on a trusted keyring.
> 
> *Getting* it onto that trusted keyring is then the trick.  There are two ways:
> 
>   (1) A key can be loaded from a trusted source during boot (say a compiled in
>       set of keys).
> 
>   (2) A key can be added to that keyring later, provided that the key is
>       verified by a key already in the ring and the ring hasn't been closed.
> 
> What do we need to check PGP signatures?  Blobs or keys as well?

For my use case, verifying blobs (RPM headers or 'Release' for Debian-
based distributions) would be sufficient. The keys can be added at
compile time.


> Why does the user keyring need to be a fallback?  (I know the session keyring
> used to be a fallback when I first did these, but things have changed since
> then).

Users can verify signatures with the pgp_test key type (patch 10/12).
During the first attempt, pgp_test tries to use built-in keys. If
verification fails, pgp_test tries again with keys in the user keyring.
But if verification succeeds during the second attempt, the kernel
prints a warning saying that an untrusted key was used.


> Should we have a separate built-in keyring for PGP keys?  Actually, I suspect
> we should probably mark keys in some way with what they're permitted to be
> used for.

I kept PGP keys in the main keyring, so that verify_pgp_signature() uses
the same convention of verify_pkcs7_signature() (keyring == NULL: use
primary keys, keyring == 1: use secondary keys).

In your patches there was a capability checking mechanism, but it was
removed with commit db6c43bd2132.

Roberto


> David
> 

-- 
HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Bo PENG, Jian LI, Yanli SHI
