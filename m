Return-Path: <SRS0=WWUc=4V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C27A3C3F2C6
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Mar 2020 00:06:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85DD620866
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Mar 2020 00:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583280370;
	bh=1ozUNORDROHYuoKp1GjAwkWJ8+4RKmoM944CcRwOrLg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=coHQgTquFVzrN03HGMJwkhDz23M4Rm9kt795A62KKkxlVfXVRt0BeCNwyUJKrgxmS
	 pv46Rf3qxOC5OIUxg5uPLrd+roYhLVXQ0zCzDZNQnuMkpc25m9AdRkBNXQ1uOOPIvJ
	 nUo1WKm/KHpNh+WPBENOt7zbyVxMBYDHGvbuCQMM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727762AbgCDAGJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Mar 2020 19:06:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:40232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727604AbgCDAGJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Mar 2020 19:06:09 -0500
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0699E206D5;
        Wed,  4 Mar 2020 00:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583280368;
        bh=1ozUNORDROHYuoKp1GjAwkWJ8+4RKmoM944CcRwOrLg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ECm0hWpQ4Ub7HVWP3jgWDVXNW+8niHjagCLoG0psDBAT+mUUebfDiIfx5vMSpFp1H
         UubGxPnJ/Qt74RZc19J0LIaGgWjNtnXt3ep5SJXuthS2JJCisxZ/YYK3Sp823Lrj/c
         YZwav/8Y1pGn9xEqes/UPHNyQMtuZ44BQPw3HZE0=
Date:   Tue, 3 Mar 2020 16:06:06 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: testmgr - sync both RFC4106 IV copies
Message-ID: <20200304000606.GB89804@sol.localdomain>
References: <20200303120925.12067-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303120925.12067-1-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 03, 2020 at 02:09:25PM +0200, Gilad Ben-Yossef wrote:
> RFC4106 AEAD ciphers the AAD is the concatenation of associated
> authentication data || IV || plaintext or ciphertext but the
> random AEAD message generation in testmgr extended tests did
> not obey this requirements producing messages with undefined
> behaviours. Fix it by syncing the copies if needed.
> 
> Since this only relevant for developer only extended tests any
> additional cycles/run time costs are negligible.
> 
> This fixes extended AEAD test failures with the ccree driver
> caused by illegal input.
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Cc: Eric Biggers <ebiggers@kernel.org>
> ---
> 
>  crypto/testmgr.c | 35 ++++++++++++++++++++++++++---------
>  1 file changed, 26 insertions(+), 9 deletions(-)
> 
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index 88f33c0efb23..379bd1c7dd5b 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -91,10 +91,16 @@ struct aead_test_suite {
>  	unsigned int einval_allowed : 1;
>  
>  	/*
> -	 * Set if the algorithm intentionally ignores the last 8 bytes of the
> -	 * AAD buffer during decryption.
> +	 * Set if the algorithm includes a copy of the IV (last 8 bytes)
> +	 * in the AAD buffer but does not include it in calculating the ICV
>  	 */
> -	unsigned int esp_aad : 1;
> +	unsigned int skip_aad_iv : 1;

"Authentication tag" would be easier to understand than "ICV" and would match
the rest of the code.  "ICV" is an idiosyncrasy used in certain RFCs only.

> +
> +	/*
> +	 * Set if the algorithm includes a copy of the IV (last 8 bytes)
> +	 * in the AAD buffer and does include it when calculating the ICV
> +	 */
> +	unsigned int auth_aad_iv : 1;
>  };
>  
>  struct cipher_test_suite {
> @@ -2167,14 +2173,20 @@ struct aead_extra_tests_ctx {
>   * here means the full ciphertext including the authentication tag.  The
>   * authentication tag (and hence also the ciphertext) is assumed to be nonempty.
>   */
> -static void mutate_aead_message(struct aead_testvec *vec, bool esp_aad)
> +static void mutate_aead_message(struct aead_testvec *vec,
> +				const struct aead_test_suite *suite)
>  {
> -	const unsigned int aad_tail_size = esp_aad ? 8 : 0;
> +	const unsigned int aad_ivsize = 8;

We should use the algorithm's actual IV size instead of hard-coding 8 bytes.

> +	const unsigned int aad_tail_size = suite->skip_aad_iv ? aad_ivsize : 0;
>  	const unsigned int authsize = vec->clen - vec->plen;
>  
>  	if (prandom_u32() % 2 == 0 && vec->alen > aad_tail_size) {
>  		 /* Mutate the AAD */
>  		flip_random_bit((u8 *)vec->assoc, vec->alen - aad_tail_size);
> +		if (suite->auth_aad_iv)
> +			memcpy((u8 *)vec->iv,
> +			       (vec->assoc + vec->alen - aad_ivsize),
> +			       aad_ivsize);

Why sync the IV copies here?  When 'auth_aad_iv', we assume the copy of the IV
in the AAD (which was just corrupted) is authenticated.  So we already know that
decryption should fail, regardless of the other IV copy.

Also, the code doesn't currently mutate vec->iv for any AEAD.  So mutating it
for one specific algorithm is a bit odd.  IMO, it would make more sense to do a
separate patch later that mutates vec->iv for all AEADs.

>  		if (prandom_u32() % 2 == 0)
>  			return;
>  	}
> @@ -2208,6 +2220,10 @@ static void generate_aead_message(struct aead_request *req,
>  	/* Generate the AAD. */
>  	generate_random_bytes((u8 *)vec->assoc, vec->alen);
>  
> +	if (suite->auth_aad_iv && (vec->alen > ivsize))
> +		memcpy(((u8 *)vec->assoc + vec->alen - ivsize), vec->iv,
> +		       ivsize);

Shouldn't this be >= ivsize, not > ivsize?  And doesn't the IV need to be synced
in both the skip_aad_iv and auth_aad_iv cases?

There are also unnecessary parentheses here; the memcpy() could be one line.


How about the following patch instead?

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index ccb3d60729fc..eea56fe8d1e8 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -91,10 +91,16 @@ struct aead_test_suite {
 	unsigned int einval_allowed : 1;
 
 	/*
-	 * Set if the algorithm intentionally ignores the last 8 bytes of the
-	 * AAD buffer during decryption.
+	 * 'aad_iv' is set if this algorithm requires that the IV be located at
+	 * the end of the AAD buffer, in addition to being given in the normal
+	 * way.  It's implementation-defined which IV copy the algorithm uses.
+	 *
+	 * 'aad_iv_auth' is set if the copy of the IV in the AAD buffer is
+	 * authenticated just like the rest of the AAD, i.e. if decryption with
+	 * the AAD IV bytes corrupted should fail.
 	 */
-	unsigned int esp_aad : 1;
+	unsigned int aad_iv : 1;
+	unsigned int aad_iv_auth : 1;
 };
 
 struct cipher_test_suite {
@@ -2167,9 +2173,12 @@ struct aead_extra_tests_ctx {
  * here means the full ciphertext including the authentication tag.  The
  * authentication tag (and hence also the ciphertext) is assumed to be nonempty.
  */
-static void mutate_aead_message(struct aead_testvec *vec, bool esp_aad)
+static void mutate_aead_message(struct aead_testvec *vec,
+				const struct aead_test_suite *suite,
+				unsigned int ivsize)
 {
-	const unsigned int aad_tail_size = esp_aad ? 8 : 0;
+	const unsigned int aad_tail_size =
+		(suite->aad_iv && !suite->aad_iv_auth) ? ivsize : 0;
 	const unsigned int authsize = vec->clen - vec->plen;
 
 	if (prandom_u32() % 2 == 0 && vec->alen > aad_tail_size) {
@@ -2207,6 +2216,8 @@ static void generate_aead_message(struct aead_request *req,
 
 	/* Generate the AAD. */
 	generate_random_bytes((u8 *)vec->assoc, vec->alen);
+	if (suite->aad_iv && vec->alen >= ivsize)
+		memcpy((u8 *)vec->assoc + vec->alen - ivsize, vec->iv, ivsize);
 
 	if (inauthentic && prandom_u32() % 2 == 0) {
 		/* Generate a random ciphertext. */
@@ -2242,7 +2253,7 @@ static void generate_aead_message(struct aead_request *req,
 		 * Mutate the authentic (ciphertext, AAD) pair to get an
 		 * inauthentic one.
 		 */
-		mutate_aead_message(vec, suite->esp_aad);
+		mutate_aead_message(vec, suite, ivsize);
 	}
 	vec->novrfy = 1;
 	if (suite->einval_allowed)
@@ -5229,7 +5240,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			.aead = {
 				____VECS(aes_gcm_rfc4106_tv_template),
 				.einval_allowed = 1,
-				.esp_aad = 1,
+				.aad_iv = 1,
 			}
 		}
 	}, {
@@ -5241,7 +5252,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			.aead = {
 				____VECS(aes_ccm_rfc4309_tv_template),
 				.einval_allowed = 1,
-				.esp_aad = 1,
+				.aad_iv = 1,
 			}
 		}
 	}, {
@@ -5252,6 +5263,8 @@ static const struct alg_test_desc alg_test_descs[] = {
 			.aead = {
 				____VECS(aes_gcm_rfc4543_tv_template),
 				.einval_allowed = 1,
+				.aad_iv = 1,
+				.aad_iv_auth = 1,
 			}
 		}
 	}, {
@@ -5267,7 +5280,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			.aead = {
 				____VECS(rfc7539esp_tv_template),
 				.einval_allowed = 1,
-				.esp_aad = 1,
+				.aad_iv = 1,
 			}
 		}
 	}, {
