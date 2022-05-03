Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D95EC433F5
	for <linux-crypto@archiver.kernel.org>; Tue,  3 May 2022 12:33:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234547AbiECMhQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 May 2022 08:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232602AbiECMhP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 May 2022 08:37:15 -0400
Received: from gardel.0pointer.net (gardel.0pointer.net [85.214.157.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8899F1EAE4;
        Tue,  3 May 2022 05:33:42 -0700 (PDT)
Received: from gardel-login.0pointer.net (gardel-mail [IPv6:2a01:238:43ed:c300:10c3:bcf3:3266:da74])
        by gardel.0pointer.net (Postfix) with ESMTP id 5366FE804AA;
        Tue,  3 May 2022 14:33:40 +0200 (CEST)
Received: by gardel-login.0pointer.net (Postfix, from userid 1000)
        id C5E07160011; Tue,  3 May 2022 14:33:39 +0200 (CEST)
Date:   Tue, 3 May 2022 14:33:39 +0200
From:   Lennart Poettering <mzxreary@0pointer.de>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Alexander Graf <graf@amazon.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        Torben Hansen <htorben@amazon.co.uk>,
        Jann Horn <jannh@google.com>
Subject: Re: [PATCH 2/2] random: add fork_event sysctl for polling VM forks
Message-ID: <YnEhI3IX0oerUbsZ@gardel-login>
References: <20220502140602.130373-1-Jason@zx2c4.com>
 <20220502140602.130373-2-Jason@zx2c4.com>
 <Ym/7UlgQ5VjjC76P@gardel-login>
 <YnAC00VtU8MGb7vO@zx2c4.com>
 <YnAMBzhcJhGR5XOK@gardel-login>
 <7a1cfd1c-9f0e-f134-e544-83ee6d3cd9c9@amazon.com>
 <YnDn/d6iB0aUZkWJ@gardel-login>
 <YnEYN+Q3q76NVX3Q@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnEYN+Q3q76NVX3Q@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Di, 03.05.22 13:55, Jason A. Donenfeld (Jason@zx2c4.com) wrote:

> I'm still not convinced there's value in having a counter or a UUID, but
> if you had to choose, would you prefer a counter or a UUID? It sounds
> like the former, because you see a use for distinguishing between zero
> and non-zero? Or did you finally agree with me that vmgenid isn't
> granular enough for that?

I would prefer a monotonic counter, since it allows answering
questions like the following:

1. Did this image get cloned at all? (i.e. counter != 0; usecase as per the MAC address
   discussion)

2. Did the image get cloned since the last time I looked? (i.e. counter
   != my_previously_saved_counter; usecase: detect clones in an "offline"
   fashion, i.e. from a component that doesn't continously run, but
   only from time to time)

3. How many clones did I miss? (i.e. missed_clones =
   my_previously_saved_counter - counter; usecase: catch up with
   generating proxy D-Bus signal messages for clones).

There might be more.

Using a UUID would not give us #1 or #3. It would deliver #2 however.

Lennart

--
Lennart Poettering, Berlin
