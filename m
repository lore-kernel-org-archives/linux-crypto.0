Return-Path: <SRS0=zNYl=VI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F847C74A36
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Jul 2019 00:46:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE3AE214AF
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Jul 2019 00:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1562805981;
	bh=9PtXVEFgbz5xR5gteaqKYk77B7+n5FHztKZstybeI4s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=OKNxvAcTgZ43X5BeMiI4BTtiQfPEIjOkk/No3ktH2v+Sm4LRvLu9qouRf+mSXzPpV
	 1MhulP4R811OZ5Fx3+D9Q7gxFKf68rhX+39R1/3rMQz3AyGCfyaJtRJ6OiXtCFzmYJ
	 oOKkTSC2Xj0GxXcPslXXAotUNSyQEZW1jg8fUHOw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727594AbfGKAqU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Jul 2019 20:46:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:33886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726627AbfGKAqU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Jul 2019 20:46:20 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D74C220872;
        Thu, 11 Jul 2019 00:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562805979;
        bh=9PtXVEFgbz5xR5gteaqKYk77B7+n5FHztKZstybeI4s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tJpS94AGuN+4L3uTDEOV3v6YUZ4FGPEa6uDHBQmLu5JZc2RY5tlE8gjnNiNCzAe0P
         p0AXY+18wYECcmPjjrcZ0XG91KHsO3TGoLtTkqsm1rHkynm/os2O4QCxeEDs0VNKYg
         dg93rTLsiDYaW2yKY32gwZuEacIwt5uPYKAzNq4o=
Date:   Wed, 10 Jul 2019 17:46:17 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Gary R Hook <ghook@amd.com>
Cc:     "Hook, Gary" <Gary.Hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
Subject: Re: [PATCH v2] crypto: ccp - memset structure fields to zero before
 reuse
Message-ID: <20190711004617.GA628@sol.localdomain>
Mail-Followup-To: Gary R Hook <ghook@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
References: <20190710000849.3131-1-gary.hook@amd.com>
 <20190710015725.GA746@sol.localdomain>
 <2875285f-d438-667e-52d9-801124ffba88@amd.com>
 <20190710203428.GC83443@gmail.com>
 <d4b8006c-0243-b4a4-c695-a67041acc82f@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4b8006c-0243-b4a4-c695-a67041acc82f@amd.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 10, 2019 at 10:50:31PM +0000, Gary R Hook wrote:
> On 7/10/19 3:34 PM, Eric Biggers wrote:
> > On Wed, Jul 10, 2019 at 03:59:05PM +0000, Gary R Hook wrote:
> >> On 7/9/19 8:57 PM, Eric Biggers wrote:
> >>> On Wed, Jul 10, 2019 at 12:09:22AM +0000, Hook, Gary wrote:
> >>>> The AES GCM function reuses an 'op' data structure, which members
> >>>> contain values that must be cleared for each (re)use.
> >>>>
> >>>> This fix resolves a crypto self-test failure:
> >>>> alg: aead: gcm-aes-ccp encryption test failed (wrong result) on test vector 2, cfg="two even aligned splits"
> >>>>
> >>>> Fixes: 36cf515b9bbe ("crypto: ccp - Enable support for AES GCM on v5 CCPs")
> >>>>
> >>>> Signed-off-by: Gary R Hook <gary.hook@amd.com>
> >>>
> >>> FYI, with this patch applied I'm still seeing another test failure:
> >>>
> >>> [    2.140227] alg: aead: gcm-aes-ccp setauthsize unexpectedly succeeded on test vector "random: alen=264 plen=161 authsize=6 klen=32"; expected_error=-22
> >>>
> >>> Are you aware of that one too, and are you planning to fix it?
> >>>
> >>> - Eric
> >>>
> >>
> >> I just pulled the latest on the master branch of cryptodev-2.6, built,
> >> booted, and loaded our module. And I don't see that error. It must be new?
> > 
> > Did you have CONFIG_CRYPTO_MANAGER_EXTRA_TESTS enabled?  This failure was with a
> > test vector that was generated randomly by the fuzz tests, so
> > CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y is needed to reproduce it.
> > 
> > You probably just need to update ccp_aes_gcm_setauthsize() to validate the
> > authentication tag size.
> 
> Now I'm confused. I did need to fix that function, and AFAIK the tag for 
> GCM is always going to be 16 bytes (our AES_BLOCK_SIZE).
> 
> So, after making the small change, the above test passes, but now I 
> progress and get this error:
> 
> [ 1640.820781] alg: aead: gcm-aes-ccp setauthsize failed on test vector 
> "random: alen=29 plen=29 authsize=12 klen=32"; expected_error=0, 
> actual_error=1
> 
> Which is wholly unclear. Why would an authsize of 12 be okay for this 
> transformation? The GCM tag is a fixed size.
> 
> Nothing in the AEAD documentation jumps out at me. As I don't profess to 
> be a crypto expert, I'd appreciate any guidance on this subtle issue 
> that is eluding me...
> 

The generic implementation allows authentication tags of 4, 8, 12, 13, 14, 15,
or 16 bytes.  See crypto_gcm_setauthsize() in crypto/gcm.c, and see
https://nvlpubs.nist.gov/nistpubs/Legacy/SP/nistspecialpublication800-38d.pdf
section 5.2.1.2 "Output Data".  If you disagree that this is the correct
behavior, then we need to fix the generic implementation too.

Also, I just got a kernel panic in the CCP driver on boot with
CONFIG_CRYPTO_MANAGER_EXTRA_TESTS enabled.  The kernel included this patch.  So
apparently there's yet another bug that needs to be fixed.  This one must occur
infrequently enough to not be hit every time with the default
fuzz_iterations=100, but still frequently enough for me to have seen it.

- Eric
