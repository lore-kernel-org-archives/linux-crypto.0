Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC7F2C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Nov 2021 05:22:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244864AbhKZFZf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Nov 2021 00:25:35 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:57142 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244991AbhKZFXe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Nov 2021 00:23:34 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mqTee-0008Nj-A6; Fri, 26 Nov 2021 13:20:12 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mqTeC-0004WP-EL; Fri, 26 Nov 2021 13:19:44 +0800
Date:   Fri, 26 Nov 2021 13:19:44 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Peter Gonda <pgonda@google.com>
Cc:     thomas.lendacky@amd.com, Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4 0/5] Add SEV_INIT_EX support
Message-ID: <20211126051944.GA17358@gondor.apana.org.au>
References: <20211115174102.2211126-1-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211115174102.2211126-1-pgonda@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Nov 15, 2021 at 09:40:57AM -0800, Peter Gonda wrote:
> SEV_INIT requires users to unlock their SPI bus for the PSP's non
> volatile (NV) storage. Users may wish to lock their SPI bus for numerous
> reasons, to support this the PSP firmware supports SEV_INIT_EX. INIT_EX
> allows the firmware to use a region of memory for its NV storage leaving
> the kernel responsible for actually storing the data in a persistent
> way. This series adds a new module parameter to ccp allowing users to
> specify a path to a file for use as the PSP's NV storage. The ccp driver
> then reads the file into memory for the PSP to use and is responsible
> for writing the file whenever the PSP modifies the memory region.
> 
> V3
> * Add another module parameter 'psp_init_on_probe' to allow for skipping
>   PSP init on module init.
> * Fixes review comments from Sean.
> * Fixes missing error checking with file reading.
> * Removed setting 'error' to a set value in patch 1.

This doesn't compile cleanly for me with C=1 W=1:

  CC [M]  drivers/crypto/ccp/sev-dev.o
In file included from ../arch/x86/include/asm/bug.h:84,
                 from ../include/linux/bug.h:5,
                 from ../include/linux/cpumask.h:14,
                 from ../arch/x86/include/asm/cpumask.h:5,
                 from ../arch/x86/include/asm/msr.h:11,
                 from ../arch/x86/include/asm/processor.h:22,
                 from ../arch/x86/include/asm/timex.h:5,
                 from ../include/linux/timex.h:65,
                 from ../include/linux/time32.h:13,
                 from ../include/linux/time.h:60,
                 from ../include/linux/stat.h:19,
                 from ../include/linux/module.h:13,
                 from ../drivers/crypto/ccp/sev-dev.c:10:
../drivers/crypto/ccp/sev-dev.c: In function ‘sev_read_init_ex_file’:
../include/linux/lockdep.h:286:52: error: invalid type argument of ‘->’ (have ‘struct mutex’)
 #define lockdep_is_held(lock)  lock_is_held(&(lock)->dep_map)
                                                    ^~
Please fix and resubmit.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
