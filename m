From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH] keys/encrypted: Fix two crypto-on-the-stack bugs
Date: Mon, 12 Dec 2016 16:32:03 -0800
Message-ID: <CALCETrVPnrXVcapWezAw+AwEpcyTybKUpAO4YqVDk+e1yBUoUw@mail.gmail.com>
References: <8c273c9c41f51b34bb3115086f1d776895580637.1481575835.git.luto@kernel.org>
 <e958f214e8885968be8045ffde813ac339b81178.1481575835.git.luto@kernel.org> <5944.1481581706@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Andy Lutomirski <luto@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>, keyrings@vger.kernel.org,
        Eric Biggers <ebiggers3@gmail.com>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:47338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752833AbcLMAc2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Dec 2016 19:32:28 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 0792B20454
        for <linux-crypto@vger.kernel.org>; Tue, 13 Dec 2016 00:32:27 +0000 (UTC)
Received: from mail-ua0-f176.google.com (mail-ua0-f176.google.com [209.85.217.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17A3420444
        for <linux-crypto@vger.kernel.org>; Tue, 13 Dec 2016 00:32:25 +0000 (UTC)
Received: by mail-ua0-f176.google.com with SMTP id 51so97958735uai.1
        for <linux-crypto@vger.kernel.org>; Mon, 12 Dec 2016 16:32:25 -0800 (PST)
In-Reply-To: <5944.1481581706@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 12, 2016 at 2:28 PM, David Howells <dhowells@redhat.com> wrote:
> Andy Lutomirski <luto@kernel.org> wrote:
>
>> +static const char zero_pad[16] = {0};
>
> Isn't there a global page of zeros or something that we can share?  Also, you
> shouldn't explicitly initialise it so that it stays in .bss.

This is a double-edged sword.  It seems that omitting the
initialization causes it to go in .bss, which isn't read only.  I have
no idea why initializing make a difference at all -- the IMO sensible
behavior would be to put it in .rodata as NOBITS either way.

But I'll use empty_zero_page.

>
>> -     sg_set_buf(&sg_out[1], pad, sizeof pad);
>> +     sg_set_buf(&sg_out[1], zero_pad, sizeof zero_pad);
>
> Can you put brackets on the sizeof?

Will do for v2.
