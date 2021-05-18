Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E440EC433ED
	for <linux-crypto@archiver.kernel.org>; Tue, 18 May 2021 16:57:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7F26610CD
	for <linux-crypto@archiver.kernel.org>; Tue, 18 May 2021 16:57:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350917AbhERQ6X (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 May 2021 12:58:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:54604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244114AbhERQ6X (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 May 2021 12:58:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07FDA61184;
        Tue, 18 May 2021 16:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621357025;
        bh=CUB74zhwK+0DPuipOMjuUrdevGC0aj9GsPNaTdXpsms=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=aP4I/vnAbdNBAhjpfXk/I3rmOZ5XVgn2uufx2tihVUlvlzZn74fhykXU09WecuhWp
         +WFFD+xyYUol5rVehLhY8gO3Yc47dPgIRo74GEfUyWRGddVHLy5xw6lvQXGUoBAroW
         0hbMAmSoNlHTYlFbjJyYLTzV9WiziVArl2l0AsrHKCrKAykVFNc5H1PQvhsNE3kQpT
         eHe/WAM72KZdytwxGoBkb+15LbRVIzR3LgcuO65y8a1p+P4d2GUKr+3aQFni3lG4YJ
         W/e6lANyaNRJOEgOl3lMSCHUP3yhB9MQdF28MCwrJIqDLCr97ebFj6wuBW0n1nscGY
         MF7D8otLUdZuQ==
Subject: Re: [RFC PATCH v2 10/11] crypto: x86/aes-kl - Support AES algorithm
 using Key Locker instructions
To:     "Chang S. Bae" <chang.seok.bae@intel.com>, tglx@linutronix.de,
        mingo@kernel.org, bp@suse.de, x86@kernel.org,
        herbert@gondor.apana.org.au
Cc:     dan.j.williams@intel.com, dave.hansen@intel.com,
        ravi.v.shankar@intel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210514201508.27967-1-chang.seok.bae@intel.com>
 <20210514201508.27967-11-chang.seok.bae@intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Message-ID: <9e7ba5da-2395-ab5f-2051-4d04dc55f565@kernel.org>
Date:   Tue, 18 May 2021 09:57:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210514201508.27967-11-chang.seok.bae@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 5/14/21 1:15 PM, Chang S. Bae wrote:
> Key Locker (KL) is Intel's new security feature that protects the AES key
> at the time of data transformation. New AES SIMD instructions -- as a
> successor of Intel's AES-NI -- are provided to encode an AES key and
> reference it for the AES algorithm.
> 
> New instructions support 128/256-bit keys. While it is not desirable to
> receive any 192-bit key, AES-NI instructions are taken to serve this size.
> 
> New instructions are operational in both 32-/64-bit modes.
> 
> Included are methods for ECB, CBC, CTR, and XTS modes. They are not
> compatible with other implementations as referencing an encrypted form
> only.

This entire concept is severely problematic.  The nineties are over --
in 2021, a responsible author of a crypto library will understand,
document, and preferably prove what security properties it is supposed
to have.

Even assuming that Key Locker is used properly and that the wrapping key
is never compromised, the security properties of Key Locker-ified
AES-CTR are weak at best.  In particular, all the usual caveats of CTR
apply, and KL does nothing to mitigate it.  Any attacker who recovers,
directly or by capture of a plaintext-ciphertext pair, enc_k(0),
enc_k(1), etc can encrypt and forge any message involving those counter
values.

In-kernel support for an AES Key Locker mode needs to document precisely
what that mode accomplishes and when it should and should not be used.

At least AES-XTS *probably* has the property that at attacker who gets
the contents of main memory once can't decrypt future disk images
encrypted against the same key.  AES-CTR can't even achieve that.

So far, the only compelling use case for KL that I've seen is full disk
encryption.  I think it would be nice for the entire process of doing
that to be worked out.

--Andy
