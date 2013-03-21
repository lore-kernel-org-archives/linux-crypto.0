From: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] crypto: replace kmalloc and then memcpy with kmemdup
Date: Thu, 21 Mar 2013 19:18:45 +0100
Message-ID: <CACRpkdbqhjm9=o5GG5Anqa5bRFL5cTdrXD=ZBd=7gntvoSSaCg@mail.gmail.com>
References: <1362998890-7532-1-git-send-email-mihneadb@gmail.com>
	<20130321095415.GB26931@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Mihnea Dobrescu-Balaur <mihneadb@gmail.com>,
	linux-crypto@vger.kernel.org, davem@davemloft.net,
	andreas.westin@stericsson.com, arnd@arndb.de, rubini@unipv.it,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130321095415.GB26931@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Mar 21, 2013 at 10:54 AM, Herbert Xu
<herbert@gondor.apana.org.au> wrote:
> On Mon, Mar 11, 2013 at 12:48:10PM +0200, Mihnea Dobrescu-Balaur wrote:
>> Signed-off-by: Mihnea Dobrescu-Balaur <mihneadb@gmail.com>
>
> Patch applied.  Thanks.

Acked-by: Linus Walleij <linus.walleij@linaro.org> FWIW, I tried to get the
people involved with the code to ACK but somehow they must've missed it.

Thanks,
Linus Walleij
