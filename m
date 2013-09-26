From: Hamid Nassiby <h.nassiby@gmail.com>
Subject: Re: IV generation in geode-aes
Date: Thu, 26 Sep 2013 20:12:46 +0330
Message-ID: <CAFuf8QP1MmFmE-nubFVm7rnte-AbYfGpHFRRzhriSa+BcrsBmQ@mail.gmail.com>
References: <loom.20130919T140312-617@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org
To: Sohail <sohailtariq25@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:61957 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404Ab3IZQnS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 Sep 2013 12:43:18 -0400
Received: by mail-wg0-f46.google.com with SMTP id k14so1436520wgh.1
        for <linux-crypto@vger.kernel.org>; Thu, 26 Sep 2013 09:43:16 -0700 (PDT)
In-Reply-To: <loom.20130919T140312-617@post.gmane.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

In geode-aes, there is not any IV generation mechanism. In fact IV is
delivered to geode-aes's
registered algorithms, from upper layers.For example in case of
"cbc-aes-geode" algorithm,
from cbc wrapper ("cbc.c") via walk->iv:

blkcipher_walk_init(&walk, dst, src, nbytes);
err = blkcipher_walk_virt(desc, &walk);
op->iv = walk.iv;
...

Regards.

On Thu, Sep 19, 2013 at 4:34 PM, Sohail <sohailtariq25@gmail.com> wrote:
> Hi all,
> I could'nt understand the mechanism of IV generation in geode-aes. Can
> someone explain it in easy to understand manner?
>
> Thanks a lot.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
