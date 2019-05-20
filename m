Return-Path: <SRS0=w/0I=TU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02CB9C04AAF
	for <linux-crypto@archiver.kernel.org>; Mon, 20 May 2019 16:39:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAE5721721
	for <linux-crypto@archiver.kernel.org>; Mon, 20 May 2019 16:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558370353;
	bh=ISo06FCJrG9k2nLXbAzv522hQDENE46NAA1tXip5Ako=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=coO5AIHA/t9R58phuierVzwAUoeXycNW3+Pt5qbgrDoL3toZCMzYdyLqCFRlD8YiG
	 Ha9v8bVM8UnGEPM8KQVwXVFykQ/4HPFdzvrKsWM/Aklqk4cS/B8UkW9GcoLXRVNpEh
	 ol1EorKAcvxAejA+8G1mXmRM583888+u3J2SV9t0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392628AbfETQjM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 May 2019 12:39:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392622AbfETQjL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 May 2019 12:39:11 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F230214DA;
        Mon, 20 May 2019 16:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558370350;
        bh=ISo06FCJrG9k2nLXbAzv522hQDENE46NAA1tXip5Ako=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I0kYMPWMpCmIFiFdE9bDFcr62ej78ewiWNnyHJT5Gm3GZEvbU+6w19XfssuSMsewm
         QfPxL21SH//mf2pBpU6UgGtqE+W3P9hWs+I83pSwIYO5dD4+NTuhgTVXmEfB6yvR78
         FSkBHcBwvd9IMlkfd2Xvd2GpWXadm+SMCYeMdy/w=
Date:   Mon, 20 May 2019 09:39:08 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Daniel Axtens <dja@axtens.net>
Cc:     mpe@ellerman.id.au, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        marcelo.cerri@canonical.com, Stephan Mueller <smueller@chronox.de>,
        leo.barbosa@canonical.com, linuxppc-dev@lists.ozlabs.org,
        nayna@linux.ibm.com, pfsmorigo@gmail.com, leitao@debian.org,
        gcwilson@linux.ibm.com, omosnacek@gmail.com
Subject: Re: [PATCH] crypto: vmx - CTR: always increment IV as quadword
Message-ID: <20190520163907.GA119750@gmail.com>
References: <20190515102450.30557-1-dja@axtens.net>
 <87r28tzy1i.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r28tzy1i.fsf@dja-thinkpad.axtens.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, May 20, 2019 at 11:59:05AM +1000, Daniel Axtens wrote:
> Daniel Axtens <dja@axtens.net> writes:
> 
> > The kernel self-tests picked up an issue with CTR mode:
> > alg: skcipher: p8_aes_ctr encryption test failed (wrong result) on test vector 3, cfg="uneven misaligned splits, may sleep"
> >
> > Test vector 3 has an IV of FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD, so
> > after 3 increments it should wrap around to 0.
> >
> > In the aesp8-ppc code from OpenSSL, there are two paths that
> > increment IVs: the bulk (8 at a time) path, and the individual
> > path which is used when there are fewer than 8 AES blocks to
> > process.
> >
> > In the bulk path, the IV is incremented with vadduqm: "Vector
> > Add Unsigned Quadword Modulo", which does 128-bit addition.
> >
> > In the individual path, however, the IV is incremented with
> > vadduwm: "Vector Add Unsigned Word Modulo", which instead
> > does 4 32-bit additions. Thus the IV would instead become
> > FFFFFFFFFFFFFFFFFFFFFFFF00000000, throwing off the result.
> >
> > Use vadduqm.
> >
> > This was probably a typo originally, what with q and w being
> > adjacent. It is a pretty narrow edge case: I am really
> > impressed by the quality of the kernel self-tests!
> >
> > Fixes: 5c380d623ed3 ("crypto: vmx - Add support for VMS instructions by ASM")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Daniel Axtens <dja@axtens.net>
> >
> > ---
> >
> > I'll pass this along internally to get it into OpenSSL as well.
> 
> I passed this along to OpenSSL and got pretty comprehensively schooled:
> https://github.com/openssl/openssl/pull/8942
> 
> It seems we tweak the openssl code to use a 128-bit counter, whereas
> the original code was in fact designed for a 32-bit counter. We must
> have changed the vaddu instruction in the bulk path but not in the
> individual path, as they're both vadduwm (4x32-bit) upstream.
> 
> I think this change is still correct with regards to the kernel,
> but I guess it's probably something where I should have done a more
> thorough read of the documentation before diving in to the code, and
> perhaps we should note it in the code somewhere too. Ah well.
> 
> Regards,
> Daniel
> 

Ah, I didn't realize there are multiple conventions for CTR.  Yes, all CTR
implementations in the kernel follow the 128-bit convention, and evidently the
test vectors test for that.  Apparently the VMX OpenSSL code got incompletely
changed from the 32-bit convention by this commit, so that's what you're fixing:

	commit 1d4aa0b4c1816e8ca92a6aadb0d8f6b43c56c0d0
	Author: Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>
	Date:   Fri Aug 14 10:12:22 2015 -0300

	    crypto: vmx - Fixing AES-CTR counter bug
	    
	    AES-CTR is using a counter 8bytes-8bytes what miss match with
	    kernel specs.
	    
	    In the previous code a vadduwm was done to increment counter.
	    Replacing this for a vadduqm now considering both cases counter
	    8-8 bytes and full 16bytes.

A comment in the code would indeed be helpful.

Note that the kernel doesn't currently need a 32-bit CTR implementation for GCM
like OpenSSL does, because the kernel currently only supports 12-byte IVs with
GCM.  So the low 32 bits of the counter start at 1 and don't overflow,
regardless of whether the counter is incremented mod 2^32 or mod 2^128.

- Eric
