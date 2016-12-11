From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: Remaining crypto API regressions with CONFIG_VMAP_STACK
Date: Sun, 11 Dec 2016 11:13:55 -0800
Message-ID: <CALCETrVBGPijiacbY-trdbgRPYC8grNrGA7TVu0xvxUaqud08w@mail.gmail.com>
References: <20161209230851.GB64048@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, Andrew Lutomirski <luto@kernel.org>,
	Stephan Mueller <smueller@chronox.de>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20161209230851.GB64048@google.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Dec 9, 2016 at 3:08 PM, Eric Biggers <ebiggers3@gmail.com> wrote:
> In the 4.9 kernel, virtually-mapped stacks will be supported and enabled by
> default on x86_64.  This has been exposing a number of problems in which
> on-stack buffers are being passed into the crypto API, which to support crypto
> accelerators operates on 'struct page' rather than on virtual memory.
>

>         fs/cifs/smbencrypt.c:96

This should use crypto_cipher_encrypt_one(), I think.

--Andy

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
