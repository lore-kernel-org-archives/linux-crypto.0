From: Alex Cope <alexcope@google.com>
Subject: Equivalent of blkciper_walk for skcipher
Date: Mon, 24 Oct 2016 13:39:57 -0700
Message-ID: <CA+cSK10WOnyC6=HgKg4q4P9OrQUtRZdCfCwE-yQxyr47jn3a5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Michael Halcrow <mhalcrow@google.com>,
        Eric Biggers <ebiggers@google.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:36564 "EHLO
        mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755128AbcJXUj7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Oct 2016 16:39:59 -0400
Received: by mail-vk0-f48.google.com with SMTP id y123so1504651vka.3
        for <linux-crypto@vger.kernel.org>; Mon, 24 Oct 2016 13:39:59 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

How should an algorithm implementing the skcipher api walk over the
scatterlist?  blkcipher_walk seems to be what I need, but the API is
not compatible with skciper at the moment. Repeatedly calling
scatterwalk_map_and_copy looks like it will work, but would be less
performant than using something akin to blkciper_walk.
