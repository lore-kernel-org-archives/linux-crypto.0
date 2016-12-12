From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] keys/encrypted: Fix two crypto-on-the-stack bugs
Date: Mon, 12 Dec 2016 22:28:26 +0000
Message-ID: <5944.1481581706@warthog.procyon.org.uk>
References: <e958f214e8885968be8045ffde813ac339b81178.1481575835.git.luto@kernel.org> <8c273c9c41f51b34bb3115086f1d776895580637.1481575835.git.luto@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, keyrings@vger.kernel.org,
        Eric Biggers <ebiggers3@gmail.com>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>
To: Andy Lutomirski <luto@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e958f214e8885968be8045ffde813ac339b81178.1481575835.git.luto@kernel.org>
Content-ID: <5943.1481581706.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Andy Lutomirski <luto@kernel.org> wrote:

> +static const char zero_pad[16] = {0};

Isn't there a global page of zeros or something that we can share?  Also, you
shouldn't explicitly initialise it so that it stays in .bss.

> -	sg_set_buf(&sg_out[1], pad, sizeof pad);
> +	sg_set_buf(&sg_out[1], zero_pad, sizeof zero_pad);

Can you put brackets on the sizeof?

Thanks,
David
