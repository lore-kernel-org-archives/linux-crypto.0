Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7975AC43334
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Jul 2022 09:55:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbiGZJzf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Jul 2022 05:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbiGZJze (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Jul 2022 05:55:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C02A62701
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 02:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658829332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J89tbv3oKBiXNXKXQEel/6k4HsxwRXBllrBcwDVqV7M=;
        b=PweYu5RntD4OE4jt3QStp7TNnZmL9/cZghqSuKysyFWwDXPUfXmR8nU3zTdB5VWsj+SrvN
        EGXrv4VPCtSAZ1XZprHODBG/IiKGzIFms95O3ENqxVrjj04a+kGixJnK4LjU3JIYfusrjg
        yNQiHxBQbHjBbqrZFsQfi1RQ3K646xA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-O0gK7D1XNvOgFWuF2-J-Fw-1; Tue, 26 Jul 2022 05:55:27 -0400
X-MC-Unique: O0gK7D1XNvOgFWuF2-J-Fw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A11203817A63;
        Tue, 26 Jul 2022 09:55:26 +0000 (UTC)
Received: from oldenburg.str.redhat.com (unknown [10.39.193.56])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1AA172166B26;
        Tue, 26 Jul 2022 09:55:24 +0000 (UTC)
From:   Florian Weimer <fweimer@redhat.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     libc-alpha@sourceware.org,
        Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
        Cristian =?utf-8?Q?Rodr=C3=ADguez?= <crrodriguez@opensuse.org>,
        Paul Eggert <eggert@cs.ucla.edu>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] arc4random: simplify design for better safety
References: <20220725225728.824128-1-Jason@zx2c4.com>
        <20220725232810.843433-1-Jason@zx2c4.com>
Date:   Tue, 26 Jul 2022 11:55:23 +0200
In-Reply-To: <20220725232810.843433-1-Jason@zx2c4.com> (Jason A. Donenfeld's
        message of "Tue, 26 Jul 2022 01:28:10 +0200")
Message-ID: <87k080i4fo.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

* Jason A. Donenfeld:

> +      pfd.fd = TEMP_FAILURE_RETRY (
> +	  __open64_nocancel ("/dev/random", O_RDONLY | O_CLOEXEC | O_NOCTTY));
> +      if (pfd.fd < 0)
> +	arc4random_getrandom_failure ();
> +      if (__poll (&pfd, 1, -1) < 0)
> +	arc4random_getrandom_failure ();
> +      if (__close_nocancel (pfd.fd) < 0)
> +	arc4random_getrandom_failure ();

What happens if /dev/random is actually /dev/urandom?  Will the poll
call fail?

I think we need a no-cancel variant of poll here, and we also need to
handle EINTR gracefully.

Performance-wise, my 1000 element shuffle benchmark runs about 14 times
slower without userspace buffering.  (For comparison, just removing
ChaCha20 while keeping a 256-byte buffer makes it run roughly 25% slower
than current master.)  Our random() implementation is quite slow, so
arc4random() as a replacement call is competitive.  The unbuffered
version, not so much.

Running the benchmark, I see 40% of the time spent in chacha_permute in
the kernel, that is really quite odd.  Why doesn't the system call
overhead dominate?

Thanks,
Florian

