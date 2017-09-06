From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH] crypto: authenc - cryptlen must be at least AAD len
Date: Wed, 06 Sep 2017 22:10:08 +0200
Message-ID: <2430903.zcKRVmhyml@positron.chronox.de>
References: <4634467.01PS30tDXi@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: stable@vger.kernel.org, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <4634467.01PS30tDXi@positron.chronox.de>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Mittwoch, 6. September 2017, 21:22:44 CEST schrieb Stephan Müller:

Hi Herbert,

> With AF_ALG, AAD len and cryptlen can be set freely by unprivileged
> user space. The cipher implementation must therefore validate the input
> data for sanity. For AEAD ciphers, this implies that cryptlen must be
> at least as large as AAD size.
> 
> This fixes a kernel crash that can be triggered via AF_ALG detected by
> the fuzzing test implemented with libkcapi.

What is your opinion: should this check be rather added to crypto_aead_encrypt 
(similar to a sanity check found in crypto_aead_decrypt)?

Ciao
Stephan
