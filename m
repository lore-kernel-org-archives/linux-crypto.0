Return-Path: <SRS0=BBPV=OK=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from sitav-80046.hsr.ch ([152.96.80.46]:41256 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbeLBD4u (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 1 Dec 2018 22:56:50 -0500
Message-ID: <87c0faeb5f14266b10e7633f0bc2969efb7c9fd1.camel@strongswan.org>
Subject: Re: [PATCH v2 5/6] crypto: x86/chacha20 - refactor to allow varying
 number of rounds
From: Martin Willi <martin@strongswan.org>
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: Paul Crowley <paulcrowley@google.com>,
        Milan Broz <gmazyland@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        linux-kernel@vger.kernel.org
Date: Sat, 01 Dec 2018 17:43:53 +0100
In-Reply-To: <20181129230217.158038-6-ebiggers@kernel.org>
References: <20181129230217.158038-1-ebiggers@kernel.org>
         <20181129230217.158038-6-ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


> In preparation for adding XChaCha12 support, rename/refactor the
> x86_64 SIMD implementations of ChaCha20 to support different numbers
> of rounds.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Martin Willi <martin@strongswan.org>
