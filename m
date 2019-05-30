Return-Path: <SRS0=uqbH=T6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55F47C28CC0
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 16:55:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B91625DE4
	for <linux-crypto@archiver.kernel.org>; Thu, 30 May 2019 16:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559235315;
	bh=+amcZveniinSrBT+Vlc49ya+ayzBMXpVqMJ/np0of18=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=cvn4UUvleDC9JFmqglW3BZoCM+6kAGmLW9FHnUz78ksMrse1yfpjTVbtThsvWUxau
	 IYDH7rIV8ZXJwnqFAPefKGa79bZamvJmXJXoxdNuqULpfl5JHou6Wav3sV1B0wP/mu
	 Xu2k+oOC8QOF7Dct8sYnNfTXlfV8h1tVU/XXJbss=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbfE3QzO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 May 2019 12:55:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727141AbfE3QzO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 May 2019 12:55:14 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 054F225DDF;
        Thu, 30 May 2019 16:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559235313;
        bh=+amcZveniinSrBT+Vlc49ya+ayzBMXpVqMJ/np0of18=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lr1PNDByOges69amdPcfZYxaUBv4Yg1UGTBVdtfzZDArw6XXAZ6eSjKDGaSF2w0Py
         muN0ZOiVAxv67UAtvPx3M/Qq4lmmmj/eCZm0fWd0qpPh4YHX/8xMD6LM49sbkDpvg7
         S5KI8OWtP1cguq7Fpuq3ehg1z1JODYv469KiNaL8=
Date:   Thu, 30 May 2019 09:55:11 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, terrelln@fb.com, jthumshirn@suse.de
Subject: Re: [PATCH v4] crypto: xxhash - Implement xxhash support
Message-ID: <20190530165510.GA70051@gmail.com>
References: <20190530065257.13174-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190530065257.13174-1-nborisov@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, May 30, 2019 at 09:52:57AM +0300, Nikolay Borisov wrote:
> xxhash is currently implemented as a self-contained module in /lib.
> This patch enables that module to be used as part of the generic kernel
> crypto framework. It adds a simple wrapper to the 64bit version.
> 
> I've also added test vectors (with help from Nick Terrell). The upstream
> xxhash code is tested by running hashing operation on random 222 byte
> data with seed values of 0 and a prime number. The upstream test
> suite can be found at https://github.com/Cyan4973/xxHash/blob/cf46e0c/xxhsum.c#L664
> 
> Essentially hashing is run on data of length 0,1,14,222 with the
> aforementioned seed values 0 and prime 2654435761. The particular random
> 222 byte string was provided to me by Nick Terrell by reading
> /dev/random and the checksums were calculated by the upstream xxsum
> utility with the following bash script:
> 
> dd if=/dev/random of=TEST_VECTOR bs=1 count=222
> 
> for a in 0 1; do
> 	for l in 0 1 14 222; do
> 		for s in 0 2654435761; do
> 			echo algo $a length $l seed $s;
> 			head -c $l TEST_VECTOR | ~/projects/kernel/xxHash/xxhsum -H$a -s$s
> 		done
> 	done
> done
> 
> This produces output as follows:
> 
> algo 0 length 0 seed 0
> 02cc5d05  stdin
> algo 0 length 0 seed 2654435761
> 02cc5d05  stdin
> algo 0 length 1 seed 0
> 25201171  stdin
> algo 0 length 1 seed 2654435761
> 25201171  stdin
> algo 0 length 14 seed 0
> c1d95975  stdin
> algo 0 length 14 seed 2654435761
> c1d95975  stdin
> algo 0 length 222 seed 0
> b38662a6  stdin
> algo 0 length 222 seed 2654435761
> b38662a6  stdin
> algo 1 length 0 seed 0
> ef46db3751d8e999  stdin
> algo 1 length 0 seed 2654435761
> ac75fda2929b17ef  stdin
> algo 1 length 1 seed 0
> 27c3f04c2881203a  stdin
> algo 1 length 1 seed 2654435761
> 4a15ed26415dfe4d  stdin
> algo 1 length 14 seed 0
> 3d33dc700231dfad  stdin
> algo 1 length 14 seed 2654435761
> ea5f7ddef9a64f80  stdin
> algo 1 length 222 seed 0
> 5f3d3c08ec2bef34  stdin
> algo 1 length 222 seed 2654435761
> 6a9df59664c7ed62  stdin
> 
> algo 1 is xx64 variant, algo 0 is the 32 bit variant which is currently
> not hooked up.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---

Looks fine now.

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

- Eric
