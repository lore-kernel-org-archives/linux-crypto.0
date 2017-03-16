From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 2/4] crypto: powerpc - Re-enable non-REFLECTed CRCs
Date: Thu, 16 Mar 2017 21:44:03 +1100
Message-ID: <871stxlcwc.fsf@concordia.ellerman.id.au>
References: <20170315123737.20234-1-dja@axtens.net> <20170315123737.20234-2-dja@axtens.net>
Mime-Version: 1.0
Content-Type: text/plain
Cc: anton@samba.org, Daniel Axtens <dja@axtens.net>
To: Daniel Axtens <dja@axtens.net>, linuxppc-dev@lists.ozlabs.org,
        linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:51097 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751137AbdCPKod (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Mar 2017 06:44:33 -0400
In-Reply-To: <20170315123737.20234-2-dja@axtens.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Daniel Axtens <dja@axtens.net> writes:

> When CRC32c was included in the kernel, Anton ripped out
> the #ifdefs around reflected polynomials, because CRC32c
> is always reflected. However, not all CRCs use reflection
> so we'd like to make it optional.
>
> Restore the REFLECT parts from Anton's original CRC32
> implementation (https://github.com/antonblanchard/crc32-vpmsum)
>
> That implementation is available under GPLv2+, so we're OK
> from a licensing point of view:
> https://github.com/antonblanchard/crc32-vpmsum/blob/master/LICENSE.TXT

It's also written by Anton and copyright IBM, so you (we (IBM)) could
always just relicense it anyway.

So doubly OK IMO.

cheers
