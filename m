From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: Re: [RFC PATCH 6/6] dm-crypt: Add bulk crypto processing support
Date: Mon, 16 Jan 2017 14:07:37 +0530
Message-ID: <CAHv-k_92j=C8AOzfFzyuiJO=NXWh=zP3=N8MqdyqSUUZf9Hzzw@mail.gmail.com>
References: <cover.1484215956.git.omosnacek@gmail.com> <75887e6759ac308a017c83b7fa377516dcd5e2a3.1484215956.git.omosnacek@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, dm-devel@redhat.com,
        Mike Snitzer <snitzer@redhat.com>,
        Milan Broz <gmazyland@gmail.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>
To: Ondrej Mosnacek <omosnacek@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vk0-f51.google.com ([209.85.213.51]:34416 "EHLO
        mail-vk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751075AbdAPIho (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Jan 2017 03:37:44 -0500
Received: by mail-vk0-f51.google.com with SMTP id r136so69045672vke.1
        for <linux-crypto@vger.kernel.org>; Mon, 16 Jan 2017 00:37:43 -0800 (PST)
In-Reply-To: <75887e6759ac308a017c83b7fa377516dcd5e2a3.1484215956.git.omosnacek@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Ondrej,

On 12 January 2017 at 18:29, Ondrej Mosnacek <omosnacek@gmail.com> wrote:
> This patch converts dm-crypt to use bulk requests when invoking skcipher
> operations, allowing the crypto drivers to process multiple sectors at once,
> while reducing the overhead caused by the small sector size.
>
> The new code detects if multiple sectors from a bio are contigously stored
> within a single page (which should almost always be the case), and in such case
> processes all these sectors via a single bulk request.
>
> Note that the bio can also consist of several (likely consecutive) pages, which
> could be all bundled in a single request. However, since we need to specify an
> upper bound on how many sectors we are going to send at once (and this bound
> may affect the amount of memory allocated per single request), it is best to
> just limit the request bundling to a single page.

The initial goal of our proposal was to process the encryption requests with the
maximum possible block sizes with a hardware which has automated iv generation
capabilities. But when it is done in software, and if the bulk
requests are processed
sequentially, one block at a time, the memory foot print could be
reduced even if
the bulk request exceeds a page. While your patch looks good, there
are couple of
drawbacks one of which is the maximum size of a bulk request is a page. This
could limit the capability of the crypto hardware. If the whole bio is
processed at
once, which is what qualcomm's version of dm-req-crypt does, it achieves an even
better performance.

> Note that if the 'keycount' parameter of the cipher specification is set to a
> value other than 1, dm-crypt still sends only one sector in each request, since
> in such case the neighboring sectors are encrypted with different keys.

This could be avoided if the key management is done at the crypto layer.

Thanks,
Binoy
