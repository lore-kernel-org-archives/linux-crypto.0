From: Ondrej Mosnacek <omosnace@redhat.com>
Subject: dm-crypt IV generation (summary)
Date: Fri, 10 Mar 2017 14:44:26 +0100
Message-ID: <CAFqZXNs0=6+PvpGq3weRwCJkUOfSn06i_fD6ZuvXo_0rms9zeA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org, dm-devel@redhat.com,
        Mike Snitzer <snitzer@redhat.com>,
        Alasdair Kergon <agk@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Binoy Jayan <binoy.jayan@linaro.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>
To: Milan Broz <gmazyland@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ot0-f173.google.com ([74.125.82.173]:35029 "EHLO
        mail-ot0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934384AbdCJNo4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Mar 2017 08:44:56 -0500
Received: by mail-ot0-f173.google.com with SMTP id x37so76806540ota.2
        for <linux-crypto@vger.kernel.org>; Fri, 10 Mar 2017 05:44:28 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi all,

I was tasked to post a summary the whole dm-crypt IV generation
problem and all the suggested solutions along with their drawbacks, so
here it goes...

PROBLEM STATEMENT:
Currently, dm-crypt uses a fixed 512-byte sector size and handles
en-/decrypting of a bio by submitting a separate request to the crypto
API for each sector. This causes a performance problem with some
crypto drivers that have a high processing overhead for small
requests, i.e. most crypto accelerators [1][2] and also e.g. the
AES-NI driver [3].

POSSIBLE SOLUTIONS:
1. Move IV generator algorithms to crypto API and allow them to
process the whole bio at once. ([5] or something equivalent)
    ISSUES:
        a) The 'keycount' parameter.
            In order to support multi-key modes from Loop-AES,
dm-crypt accepts a keycount parameter which, if it != 1, causes
consecutive sectors to be encrypted with a different key. This
parameter can be specified with any of the cipher modes, which makes
porting the whole scale of modes supported by dm-crypt to crypto API
rather messy, since a lot of dm-crypt specific stuff needs to be moved
into the crypto drivers.
        b) New AEAD functionality; random IV generator.
            The soon-to-be-added AEAD functionality in dm-crypt
introduces a new IV generator that generates IVs randomly and stores
them as sector metadata. This means IV generation cannot be handled
solely in the driver. Also, additional AEAD implementation of IV
generators would be eventually needed.

2. Restrict the keycount parameter to allow only reasonable
combinations and then move IV generators to crypto API.
    In Loop-AES, the multi-key mode always uses exactly 64 keys and
there is no reasonable scenario where someone would like to use
keycount != 1 with other IV mode than LMK. Thus it might be acceptable
to only work with multiple keys in LMK (and only allow keycount == 64
for it) and work with just one key in all other modes (and only allow
keycount == 1 for them). I.e., the cipher format would remain the
same, just with more restricted values.

    Note that this would be basically a breaking change (the keycount
parameter is documented [4], so there may be users somewhere that use
it in some unusual combination...). Still, such combinations would
have to be used explicitly, as they are never used with common
LUKS/Loop-AES/TrueCrypt partitions (something like cryptsetup --type
plain ... or dmsetup would have to be used directly).

    Applying this change would allow implementing the IV generators as
simple crypto algorithms that honor the usual interface (without
setkey hacks and passing of special structures via IV).

    ISSUES:
        a) Backward incompatibility (see above).
        b) Again need to somehow handle the new 'random' IV generator.

3. Extend crypto API to allow passing multiple requests at once (each
with a separate IV) to crypto drivers.
    (see [3])
    ISSUES:
        a) HW accelerators would have to specifically support this
scheme (unless they are somehow programmable).
            I.e. accelerators that already have the plain64 IV
generator hard-coded could not fully benefit from this (I don't know
how many are already out there). However, future ones could implement
this 'universal' IV mode and enjoy basically the same benefit.

4. Implement support of 4KB sectors (or other sizes, too) in dm-crypt.
    This would partially help, since on devices with 4K sectors the
size of each crypto request would then be 8x bigger and overhead would
be reduced without the need to mess with the dm-crypt IV generators.

    ISSUES:
        a) Only 4KB would be processed at once, not the whole bio (but
it may suffice).
        b) Partitions encrypted as 4KB sectors could not be safely
moved to a 512B-sector device (writes would not be atomic).

QUESTIONS:
@Mike/dm-devel: Do you think it would be feasible to apply solution 2
(thus introducing the small incompatibility)?

REFERENCES:
[1] https://nelenkov.blogspot.com/2015/05/hardware-accelerated-disk-encryption-in.html
[2] https://lkml.org/lkml/2017/3/2/274
[3] https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg23007.html
[4] https://gitlab.com/cryptsetup/cryptsetup/wikis/DMCrypt
[5] https://lkml.org/lkml/2017/2/7/182

Cheers,
Ondrej
