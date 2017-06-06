From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v3 05/13] security/keys: ensure RNG is seeded before use
Date: Tue, 06 Jun 2017 11:08:49 +0100
Message-ID: <26642.1496743729@warthog.procyon.org.uk>
References: <20170606005108.5646-6-Jason@zx2c4.com> <20170606005108.5646-1-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, Theodore Ts'o <tytso@mit.edu>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-hardening@lists.openwall.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Miller <davem@davemloft.net>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        David Safford <safford@us.ibm.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60824 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751274AbdFFKI6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Jun 2017 06:08:58 -0400
In-Reply-To: <20170606005108.5646-6-Jason@zx2c4.com>
Content-ID: <26641.1496743729.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Jason A. Donenfeld <Jason@zx2c4.com> wrote:

> +		key->serial = get_random_u32() >> 1;

If this may sleep, it must be interruptible.

David
