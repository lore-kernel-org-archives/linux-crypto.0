Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F293C43334
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jul 2022 16:45:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236232AbiGYQpi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jul 2022 12:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233196AbiGYQph (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jul 2022 12:45:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4CABBE19
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 09:45:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6207C6131F
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 16:45:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F85C341C8
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 16:45:35 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=fail reason="key not found in DNS" (0-bit key) header.d=redhat.com header.i=@redhat.com header.b="iJZqep+j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com; s=20210105;
        t=1658767533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wjN4RhMaNLyUnTuvipsdvB7P0NOG965onZEKEl/Hg5g=;
        b=iJZqep+jD8VASIuB3Ith728NtMGbbbK3NQPPbs7SIpgAZyRbk7wKBW9GbJbHZDVtlU35n9
        poTPKnmMWz4W/vFJqsyVhrXOOmiQ0ECB0sgWUdSePanJtk705rROChjmzd//p7WSDJf23B
        tIVcmi//JVbep1G5rYAZvN/akGlggjA=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 46a90509 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Mon, 25 Jul 2022 16:45:33 +0000 (UTC)
From:   Florian Weimer <fweimer@redhat.com>
To:     Rich Felker <dalias@libc.org>
Cc:     Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, libc-alpha@sourceware.org,
        Yann Droneaud <ydroneaud@opteya.com>, jann@thejh.net,
        Michael@phoronix.com, Paul Eggert <eggert@cs.ucla.edu>,
        linux-crypto@vger.kernel.org
Subject: Re: arc4random - are you sure we want these?
References: <YtwgTySJyky0OcgG@zx2c4.com> <Ytwg8YEJn+76h5g9@zx2c4.com>
        <6bf352e9-1312-40de-4733-3219721b343c@linaro.org>
        <20220725153303.GF7074@brightrain.aerifal.cx>
Date:   Mon, 25 Jul 2022 18:40:54 +0200
In-Reply-To: <20220725153303.GF7074@brightrain.aerifal.cx> (Rich Felker's
        message of "Mon, 25 Jul 2022 11:33:04 -0400")
Message-ID: <878rohp2ll.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

* Rich Felker:

> On Sat, Jul 23, 2022 at 02:39:29PM -0300, Adhemerval Zanella Netto via Libc-alpha wrote:
>> On 23/07/22 13:25, Jason A. Donenfeld wrote:
>> > Firstly, for what use cases does this actually help? As of recent
>> > changes to the Linux kernels -- now backported all the way to 4.9! --
>> > getrandom() and /dev/urandom are extremely fast and operate over per-cpu
>> > states locklessly. Sure you avoid a syscall by doing that in userspace,
>> > but does it really matter? Who exactly benefits from this?
>> 
>> Mainly performance, since glibc both export getrandom and getentropy. 
>> There were some discussion on maillist and we also decided to explicit
>> state this is not a CSRNG on our documentation.
>
> This is an extreme documentation/specification bug that *hurts*
> portability and security. The core contract of the historical
> arc4random function is that it *is* a CSPRNG. Having a function by
> that name that's allowed not to be one means now all software using it
> has to add detection for the broken glibc variant.
>
> If the glibc implementation has flaws that actually make it not a
> CSPRNG, this absolutely needs to be fixed. Not doing so is
> irresponsible and will set everyone back a long ways.

The core issue is that on some kernels/architectures, reading from
/dev/urandom can degrade to GRND_INSECURE (approximately), and while the
result is likely still unpredictable, not everyone would label that as a
CSPRNG.

If we document arc4random as a CSPRNG, this means that we would have to
ditch the fallback code and abort the process if the getrandom system
call is not available: when reading from /dev/urandom as a fallback, we
have no way of knowing if we are in any of the impacted execution
environments.  Based on your other comments, it seems that you are
interested in such fallbacks, too, but I don't think you can actually
have both (CSPRNG + fallback).

And then there is the certification issue.  We really want applications
that already use OpenSSL for other cryptography to use RAND_bytes
instead of arc4random.  Likewise for GNUTLS and gnutls_rnd.  What should
authors of those cryptographic libraries?  That's less clear, and really
depends on the constraints they operate in (e.g., they may target only a
subset of architectures and kernel versions).

Thanks,
Florian

