From: Alex Cope <alexcope@google.com>
Subject: Re: [RFC][PATCH 0/6] crypto: Adding Hash-Encrypt-Hash(HEH)
Date: Tue, 15 Nov 2016 12:40:07 -0800
Message-ID: <CA+cSK119vii5u=LF4uN0=LW2Pj8kj1x9+7c1+d860Yvcs3Po-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Michael Halcrow <mhalcrow@google.com>,
        Ed Knapp <edknapp@google.com>, Alex Cope <alexcope@google.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ua0-f172.google.com ([209.85.217.172]:33422 "EHLO
        mail-ua0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752679AbcKOUkJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Nov 2016 15:40:09 -0500
Received: by mail-ua0-f172.google.com with SMTP id 20so97647662uak.0
        for <linux-crypto@vger.kernel.org>; Tue, 15 Nov 2016 12:40:09 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I accidentally had an off-by-one in this patch set. There is no patch
7/7. I've edited this subject but don't plan to resend the rest of the
patches to fix the subject lines.

To clarify, this patchset is on top of "crypto: skcipher - skcipher
algorithm conversion part 3" that Herbert currently has out for
review.

Cheers,
-Alex

On Mon, Nov 14, 2016 at 1:01 PM, Alex Cope <alexcope@google.com> wrote:
> This patchset implements HEH, which is currently specified by the
> following Internet Draft:
>
>         https://tools.ietf.org/html/draft-cope-heh-00
>
> This patchset is a request for comments, and should not be merged at
> this time. We would like to wait for further comments on the Internet
> Draft before merging this patchset.
>
> Thanks
