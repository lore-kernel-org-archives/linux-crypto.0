Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2471C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Jul 2022 11:12:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbiGZLMi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Jul 2022 07:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbiGZLMh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Jul 2022 07:12:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 747A13122A
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 04:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658833955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7qOhZ5swO7O+ySultEixYztzKt66puN09u1Oc7+Ekj8=;
        b=dUfI3HLlMDTVqD32an++YjpMqzMKNol2YrGq21KmzOT/V9e5d1YEjh+PrfUmk+6k/ZR40e
        NZRt2L5dT86aYc7zz5+dODum4bnANRYnouP6ZbF7riUKuH3M+75huoRzJBGyfkC3DAm4Ea
        10CI34zdVU01n6kO7yEx0BB+CM4CtRo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-650-fXtp_hXfMie6W6rouxSbNg-1; Tue, 26 Jul 2022 07:12:32 -0400
X-MC-Unique: fXtp_hXfMie6W6rouxSbNg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 008DD101A58D;
        Tue, 26 Jul 2022 11:12:32 +0000 (UTC)
Received: from oldenburg.str.redhat.com (unknown [10.39.193.56])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 54E9C492C3B;
        Tue, 26 Jul 2022 11:12:30 +0000 (UTC)
From:   Florian Weimer <fweimer@redhat.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     libc-alpha@sourceware.org,
        Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
        Cristian =?utf-8?Q?Rodr=C3=ADguez?= <crrodriguez@opensuse.org>,
        Paul Eggert <eggert@cs.ucla.edu>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] arc4random: simplify design for better safety
References: <20220725225728.824128-1-Jason@zx2c4.com>
        <20220725232810.843433-1-Jason@zx2c4.com>
        <87k080i4fo.fsf@oldenburg.str.redhat.com> <Yt/KOQLPSnXFPtWH@zx2c4.com>
Date:   Tue, 26 Jul 2022 13:12:28 +0200
In-Reply-To: <Yt/KOQLPSnXFPtWH@zx2c4.com> (Jason A. Donenfeld's message of
        "Tue, 26 Jul 2022 13:04:25 +0200")
Message-ID: <877d40i0v7.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

* Jason A. Donenfeld:

> Hi Florian,
>
> On Tue, Jul 26, 2022 at 11:55:23AM +0200, Florian Weimer wrote:
>> * Jason A. Donenfeld:
>> 
>> > +      pfd.fd = TEMP_FAILURE_RETRY (
>> > +	  __open64_nocancel ("/dev/random", O_RDONLY | O_CLOEXEC | O_NOCTTY));
>> > +      if (pfd.fd < 0)
>> > +	arc4random_getrandom_failure ();
>> > +      if (__poll (&pfd, 1, -1) < 0)
>> > +	arc4random_getrandom_failure ();
>> > +      if (__close_nocancel (pfd.fd) < 0)
>> > +	arc4random_getrandom_failure ();
>> 
>> What happens if /dev/random is actually /dev/urandom?  Will the poll
>> call fail?
>
> Yes. I'm unsure if you're asking this because it'd be a nice
> simplification to only have to open one fd, or because you're worried
> about confusion. I don't think the confusion problem is one we should
> take too seriously, but if you're concerned, we can always fstat and
> check the maj/min. Seems a bit much, though.

Turning /dev/random into /dev/urandom (e.g. with a symbolic link) used
to be the only way to get some applications working because they tried
to read from /dev/random at a higher rate than the system was estimating
entropy coming in.  We may have to do something differently here if the
failing poll causes too much breakage.

>> Running the benchmark, I see 40% of the time spent in chacha_permute in
>> the kernel, that is really quite odd.  Why doesn't the system call
>> overhead dominate?
>
> Huh, that is interesting. I guess if you're reading 4 bytes for an
> integer, it winds up computing a whole chacha block each time, with half
> of it doing fast key erasure and half of it being returnable to the
> caller. When we later figure out a safer way to buffer, ostensibly this
> will go away. But for now, we really should not prematurely optimize.

Yeah, I can't really argue against that, given that I said before that I
wasn't too worried about the implementation.

Thanks,
Florian

