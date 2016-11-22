From: Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH] crypto: powerpc - Rename CRYPT_CRC32C_VPMSUM option
Date: Wed, 23 Nov 2016 09:23:39 +1100
Message-ID: <20161123092339.4a3d6735@kryten>
References: <20161122103244.38d435cd@endymion>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "David S. Miller" <davem@davemloft.net>
To: Jean Delvare <jdelvare@suse.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from hr2.samba.org ([144.76.82.148]:48645 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756131AbcKVWX4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Nov 2016 17:23:56 -0500
In-Reply-To: <20161122103244.38d435cd@endymion>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Jean,

> For consistency with the other 246 kernel configuration options,
> rename CRYPT_CRC32C_VPMSUM to CRYPTO_CRC32C_VPMSUM.

Thanks! Not sure how I missed that.

Acked-by: Anton Blanchard <anton@samba.org>

Anton
