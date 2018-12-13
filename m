Return-Path: <SRS0=KZld=OW=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:50534 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728368AbeLMKeF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Dec 2018 05:34:05 -0500
Date: Thu, 13 Dec 2018 18:34:03 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, paulcrowley@google.com
Subject: Re: [PATCH] crypto: adiantum - adjust some comments to match latest
 paper
Message-ID: <20181213103403.o3ame5d6wpr4ldgg@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181206222159.17336-1-ebiggers@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> The 2018-11-28 revision of the Adiantum paper has revised some notation:
> 
> - 'M' was replaced with 'L' (meaning "Left", for the left-hand part of
>  the message) in the definition of Adiantum hashing, to avoid confusion
>  with the full message
> - ε-almost-∆-universal is now abbreviated as ε-∆U instead of εA∆U
> - "block" is now used only to mean block cipher and Poly1305 blocks
> 
> Also, Adiantum hashing was moved from the appendix to the main paper.
> 
> To avoid confusion, update relevant comments in the code to match.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> crypto/adiantum.c   | 35 +++++++++++++++++++----------------
> crypto/nhpoly1305.c |  8 ++++----
> 2 files changed, 23 insertions(+), 20 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
