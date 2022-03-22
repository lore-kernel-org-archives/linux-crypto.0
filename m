Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37920C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Mar 2022 18:21:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239866AbiCVSWs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Mar 2022 14:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236651AbiCVSWr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Mar 2022 14:22:47 -0400
X-Greylist: delayed 1470 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 22 Mar 2022 11:21:20 PDT
Received: from gateway23.websitewelcome.com (gateway23.websitewelcome.com [192.185.47.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6384B8A6C2
        for <linux-crypto@vger.kernel.org>; Tue, 22 Mar 2022 11:21:20 -0700 (PDT)
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id 12DF584F6
        for <linux-crypto@vger.kernel.org>; Tue, 22 Mar 2022 12:56:49 -0500 (CDT)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id WikSn7tYRXvvJWikSnUC54; Tue, 22 Mar 2022 12:56:49 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=+7brRiRvYR2VidHiE43DL07dgBdAsSYPqfIk9b4TX/g=; b=StQ7WEwTCb/rt89VCe+LQ+ERB3
        QXWawfzAKDTeBk43IYokD+KpmviLLj48HZ6Hdz6Gtv7W0x9SfXi41CA7r8C9zZ23Pvsjnaxrq96PA
        Xh5IdeTdXhHHWO3QJNulu9uqk+8kZeiomOeJiD0ZWg6KT4wgh0R12OuxUioWkkDwKTiTnJM7JGJqi
        +ZM34ZtPX8NXMvyTGRbVqdYCe+rcqabUesJcdWq64y6z4YsvRI4XcveyYK5C6Uds0zKkh0UxczVYc
        t23ai+O230YiBstGhXLG2gwrDSTpEMCyE7845DZOyf22ZUtOxKleVeCYKKXbK5ah+HB8WeZaLyZTd
        j2uEbZpQ==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:54402)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nWikR-002XCh-MU; Tue, 22 Mar 2022 17:56:47 +0000
Message-ID: <d5c23f68-30ba-a5eb-6bea-501736e79c88@roeck-us.net>
Date:   Tue, 22 Mar 2022 10:56:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v1] random: block in /dev/urandom
Content-Language: en-US
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-arch@vger.kernel.org, Dinh Nguyen <dinguyen@kernel.org>,
        Nick Hu <nickhu@andestech.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        "David S . Miller" <davem@davemloft.net>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Michal Simek <monstr@monstr.eu>,
        Borislav Petkov <bp@alien8.de>, Guo Ren <guoren@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Joshua Kinard <kumba@gentoo.org>,
        David Laight <David.Laight@aculab.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Theodore Ts'o <tytso@mit.edu>
References: <20220217162848.303601-1-Jason@zx2c4.com>
 <20220322155820.GA1745955@roeck-us.net> <YjoC5kQMqyC/3L5Y@zx2c4.com>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <YjoC5kQMqyC/3L5Y@zx2c4.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1nWikR-002XCh-MU
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net [108.223.40.66]:54402
X-Source-Auth: linux@roeck-us.net
X-Email-Count: 32
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/22/22 10:09, Jason A. Donenfeld wrote:
> Hey Guenter,
> 
> On Tue, Mar 22, 2022 at 08:58:20AM -0700, Guenter Roeck wrote:
>> On Thu, Feb 17, 2022 at 05:28:48PM +0100, Jason A. Donenfeld wrote:
>>> This topic has come up countless times, and usually doesn't go anywhere.
>>> This time I thought I'd bring it up with a slightly narrower focus,
>>> updated for some developments over the last three years: we finally can
>>> make /dev/urandom always secure, in light of the fact that our RNG is
>>> now always seeded.
>>>
>>
>> [ ... ]
>>
>> This patch (or a later version of it) made it into mainline and causes a
>> large number of qemu boot test failures for various architectures (arm,
>> m68k, microblaze, sparc32, xtensa are the ones I observed). Common
>> denominator is that boot hangs at "Saving random seed:". A sample bisect
>> log is attached. Reverting this patch fixes the problem.
> 
> As Linus said, it was worth a try, but I guess it just didn't work. For
> my own curiosity, though, do you have a link to those QEMU VMs you could
> share? I'd sort of like to poke around, and if we do ever reattempt this
> sometime down the road, it seems like understanding everything about why
> the previous time failed might be a good idea.
> 

Everything - including the various root file systems - is at
git@github.com:groeck/linux-build-test.git. Look into rootfs/ for the
various boot tests. I'll be happy to provide some qemu command lines
if needed.

Guenter
