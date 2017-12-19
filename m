From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] crypto: n2 - cure use after free
Date: Tue, 19 Dec 2017 11:38:20 -0500 (EST)
Message-ID: <20171219.113820.1629794046915223777.davem@davemloft.net>
References: <20171216010117.13275-1-jengelh@inai.de>
        <20171219.103116.1726291053594167469.davem@davemloft.net>
        <nycvar.YFH.7.76.1712191637300.11660@n3.vanv.qr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: sparclinux@vger.kernel.org, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, rmk+kernel@arm.linux.org.uk
To: jengelh@inai.de
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <nycvar.YFH.7.76.1712191637300.11660@n3.vanv.qr>
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Jan Engelhardt <jengelh@inai.de>
Date: Tue, 19 Dec 2017 16:42:39 +0100 (CET)

> Nevertheless, I think that the error pathing in n2_core.c should be made 
> robust as well.

I completely agree.

> Should I resubmit with a new commit message?

Yes.
