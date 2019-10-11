Return-Path: <SRS0=ziyG=YE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DC74C47404
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 17:57:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E88F121835
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 17:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570816664;
	bh=YiI7zF8WltNUYYD6XmKfVSSX4StmUMBNXn8Ha54j4wE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=E3NwgaxOa412gLKGFPoUO/RkiWwRNRb+xbaQWRZwypJIdEDTa+qitZt29CEAY2+Qs
	 yJOILfOh/OR5AuvBy76X9L2PnYUqlrlXDfLa/zMgETIP2EMOIxEzhMlFru5OZD/Lx3
	 gQVfywqc7foz0DLRu9AKvYk+zyHLmOr+hOPQ9dEg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbfJKR5n (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Oct 2019 13:57:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:38410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728374AbfJKR5m (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Oct 2019 13:57:42 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC971206A1;
        Fri, 11 Oct 2019 17:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570816662;
        bh=YiI7zF8WltNUYYD6XmKfVSSX4StmUMBNXn8Ha54j4wE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=arpX6MgIZZaBsDtWlD7eJ3YuDcPPaePYou4jkD0PQ9bTktRV1qK1QqvXfsu6vjFzL
         231IQm7fNJt+/TMhJyN0pkZ4y/2TdTPQlGOCUbvslNB6QTmP5f7zzDITxJKZqlBcN7
         RD5Vdwl6YNn68w3ocp7KzCXXSGWUafEy97ZsuruU=
Date:   Fri, 11 Oct 2019 10:57:40 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     David Sterba <dsterba@suse.com>
Cc:     linux-crypto@vger.kernel.org, ard.biesheuvel@linaro.org
Subject: Re: [PATCH v4 0/5] BLAKE2b generic implementation
Message-ID: <20191011175739.GA235973@gmail.com>
Mail-Followup-To: David Sterba <dsterba@suse.com>,
        linux-crypto@vger.kernel.org, ard.biesheuvel@linaro.org
References: <cover.1570812094.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1570812094.git.dsterba@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 11, 2019 at 06:52:03PM +0200, David Sterba wrote:
> The patchset adds blake2b refrerence implementation and test vectors.
> 
> V4:
> 
> Code changes:
> 
> - removed .finup
> - removed .cra_init
> - dropped redundant sanity checks (key length, output size length)
> - switch blake2b_param from a 1 element array to plain struct
> - direct assignment in blake2b_init, instead of put_unaligned*
> - removed blake2b_is_lastblock
> - removed useless error cases in the blake * helpers
> - replace digest_desc_ctx with blake2b_state
> - use __le32 in blake2b_param
> 
> Added testmgr vectors:
> 
> - all digests covered: 160, 256, 384, 512
> - 4 different keys:
>   - empty
>   - short (1 byte, 'B', 0x42)
>   - half of the default key (32 bytes, sequence 00..1f)
>   - default key (64 bytes, sequence 00..3f)
> - plaintext values:
>   - subsequences of 0..15 and 247..255
>   - the full range 0..255 add up to 4MiB of .h, for all digests and key
>     sizes, so this is not very practical for the in-kernel testsuite
> - official blake2 provided test vectors are only for empty and default key for
>   digest size 512
> - the remaining combinations were obtained from b2sum utility (enhanced to
>   accept a key)

The choice of data lengths seems a bit unusual, as they include every length in
two ranges but nothing in between.  Also, none of the lengths except 0 is a
multiple of the blake2b block size.  Instead, maybe use something like
[0, 1, 7, 15, 64, 247, 256]?

Also, since the 4 variants share nearly all their code, it seems the tests would
be just as effective in practice if we cut the test vectors down by 4x by
distributing the key lengths among each variant.  Like:

          blake2b-160  blake2b-256  blake2b-384  blake2b-512
         ---------------------------------------------------
len=0   | klen=0       klen=1       klen=16      klen=32
len=1   | klen=16      klen=32      klen=0       klen=1
len=7   | klen=32      klen=0       klen=1       klen=16
len=15  | klen=1       klen=16      klen=32      klen=0
len=64  | klen=0       klen=1       klen=16      klen=32
len=247 | klen=16      klen=32      klen=0       klen=1
len=256 | klen=32      klen=0       klen=1       klen=16

> 
> Testing performed:
> 
> - compiled with SLUB_DEBUG and KASAN, plus crypto selftests
>   CONFIG_CRYPTO_MANAGER2=y
>   CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=n
>   CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y
> - module loaded, no errors reported from the tessuite
> - (un)intentionally broken test values were detected
> 
> The test values were produced by b2sum, compiled from the reference
> implementation. The generated values were cross-checked by pyblake2
> based script (ie. not the same sources, built by distro).
> 
> The .h portion of testmgr is completely generated, so in case somebody feels
> like reducing it in size, adding more keys, changing the formatting, it's easy
> to do.

> 
> In case the patches don't make it to the mailinglist, it's in git
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git dev/blake2b-v4

Can you please rebase this onto cryptodev/master?

- Eric
