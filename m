From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] crypto: n2 - cure use after free
Date: Tue, 19 Dec 2017 16:42:39 +0100 (CET)
Message-ID: <nycvar.YFH.7.76.1712191637300.11660@n3.vanv.qr>
References: <nycvar.YFH.7.76.1712151444211.6644@n3.vanv.qr> <20171216010117.13275-1-jengelh@inai.de> <20171219.103116.1726291053594167469.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: sparclinux@vger.kernel.org, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, rmk+kernel@arm.linux.org.uk
To: David Miller <davem@davemloft.net>
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <20171219.103116.1726291053594167469.davem@davemloft.net>
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


On Tuesday 2017-12-19 16:31, David Miller wrote:
>
>Instead, what fails is the algorithm registry which you should look
>more deeply into the cause of.

You are right. The registration failure is because the crypto layer 
expects halg->statesize to be non-zero, and drivers/crypto/n2_core.c 
does not set it, causing breakage since possibly 
v4.2-rc1-182-g8996eafdcbad (commit by rmk):

(1471)  halg = &ahash->halg;
        halg->digestsize = tmpl->digest_size;

Nevertheless, I think that the error pathing in n2_core.c should be made 
robust as well. Should I resubmit with a new commit message?
