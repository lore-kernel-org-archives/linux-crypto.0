From: Alex Cope <alexcope@google.com>
Subject: Moving from blkcipher to skcipher
Date: Mon, 3 Oct 2016 10:06:23 -0700
Message-ID: <CA+cSK1134BGVm7FprZcrDxVoU7P33GkJP17itLGvTpc8ECB9zw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Michael Halcrow <mhalcrow@google.com>,
        Eric Biggers <ebiggers@google.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:34190 "EHLO
        mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751830AbcJCRGZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Oct 2016 13:06:25 -0400
Received: by mail-vk0-f42.google.com with SMTP id b186so30810854vkb.1
        for <linux-crypto@vger.kernel.org>; Mon, 03 Oct 2016 10:06:24 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I'm currently working on implementing HEH encryption, and am in the
process of switching from the blkcipher interface to the skcipher
interface.  All the examples I have found that use skcipher are
wrapping another mode of operation I.E. cts in cts(cbc(aes)) rather
than being directly above the block cipher I.E. ctr in ctr(aes). Are
there any existing examples of the latter type that I could use as a
reference? If not, is there an estimate on when that work will be
available?
Thanks,
-Alex
