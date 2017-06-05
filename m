From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH RFC v2 5/8] security/keys: ensure RNG is seeded before use
Date: Tue, 6 Jun 2017 01:18:01 +0200
Message-ID: <CAHmME9qWkYdrVCAUoDaQiJ4_56A9J5E=VK6iiTQVxvjNNEmQAQ@mail.gmail.com>
References: <20170605034757.4803-1-Jason@zx2c4.com> <20170605034757.4803-6-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        David Safford <safford@us.ibm.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-hardening@lists.openwall.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:45271 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751246AbdFEXSF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Jun 2017 19:18:05 -0400
In-Reply-To: <20170605034757.4803-6-Jason@zx2c4.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 5, 2017 at 5:47 AM, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> -               get_random_bytes(&key->serial, sizeof(key->serial));
> +               ret = get_random_bytes_wait(&key->serial, sizeof(key->serial));

This actually isn't okay at bootup, but I've got a different change
for this section that will be in the v3.
