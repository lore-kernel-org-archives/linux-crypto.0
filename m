Return-Path: <SRS0=BBPV=OK=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from sitav-80046.hsr.ch ([152.96.80.46]:41277 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbeLBEAA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 1 Dec 2018 23:00:00 -0500
Message-ID: <972ec5f157fc4e0b96311eafba50759b61cd4436.camel@strongswan.org>
Subject: Re: [PATCH v2 6/6] crypto: x86/chacha - add XChaCha12 support
From: Martin Willi <martin@strongswan.org>
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: Paul Crowley <paulcrowley@google.com>,
        Milan Broz <gmazyland@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        linux-kernel@vger.kernel.org
Date: Sat, 01 Dec 2018 17:47:02 +0100
In-Reply-To: <20181129230217.158038-7-ebiggers@kernel.org>
References: <20181129230217.158038-1-ebiggers@kernel.org>
         <20181129230217.158038-7-ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


> Now that the x86_64 SIMD implementations of ChaCha20 and XChaCha20
> have been refactored to support varying the number of rounds, add
> support for XChaCha12.  This is identical to XChaCha20 except for the
> number of rounds, which is 12 instead of 20.  This can be used by
> Adiantum.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Martin Willi <martin@strongswan.org>
