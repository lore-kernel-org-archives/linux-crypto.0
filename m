From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 1/2] crypto: aead AF_ALG - overhaul memory management
Date: Mon, 16 Jan 2017 14:41:06 +0100
Message-ID: <6456701.gclSaKxeL3@positron.chronox.de>
References: <1486189.x0AQ4O6r2j@positron.chronox.de> <2278925.gEXngSfgVI@positron.chronox.de> <20170113112539.GA23928@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55572 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751346AbdAPNlP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Jan 2017 08:41:15 -0500
In-Reply-To: <20170113112539.GA23928@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 13. Januar 2017, 19:25:39 CET schrieb Herbert Xu:

Hi Herbert,

> On Fri, Jan 13, 2017 at 12:16:27PM +0100, Stephan Müller wrote:
> > > If you're making a single call, what guarantees the ordering?
> > 
> > Technically, io_submit is the syscall that triggers the recvmsg. Are you
> > saying that this syscall does not maintain ordering? At least the man page
> > does not add any hints that it would not (unlike the lio_list man page).
> 
> The code certainly does.  But my point is that you can do the
> same thing using the current API.  Just make your list be pairs
> of write/read and it should work.

Over the weekend I spend more time looking into the implementation of 
io_submit and its data structures exchanged between user space and kernel 
space.

During that review I was unable to find any way how an io_submit can be linked 
to a sendmsg/sendpage operation. Therefore, I am unable to see how the 
suggested TX/RX SGL pair can come into existence during sendmsg time.

A TX/RX SGL pair can only come into existence during recvmsg that is triggered 
by io_submit when the kernel learns about the amount of data it shall process. 
That means that for sendmsg all the kernel can do is store the provided data 
in a serial fashion in the TX SGL. During recvmsg, the kernel then takes the 
required data from the TX SGL and processes it so that the output can be 
stored in the RX SGL.

Note, the kernel has to handle dissimilar sendmsg/recvmsg invocations, e.g. 
sendmsg(16 bytes), sendmsg(20 bytes), sendmsg(12bytes), recvmsg(32bytes), 
recvmsg(16 bytes). As we cannot link the sendmsg to the recvmsg calls, all the 
kernel can do is to collect the data during sendmsg and process the parts 
requested during recvmsg.

With the patch set, I exactly do that. I have one TX SGL that is simply filled 
with data as user space uses sendmsg to send data. At the time the recvmsg is 
invoked and the kernel sees how much buffer the caller provides and thus knows 
how much data it can process from the TX SGL (assuming that the kernel shall 
fill the entire recvmsg buffer as much as possible), it performs the crypto 
operation.

After the kernel processed (parts of) the TX SGL data, it could now free up 
the processed SGs in that SGL. That is already performed in the algif_skcipher 
interface, but not in the algif_aead (there, the TX SGL is only freed after 
all its components are processed). Please note that as I mentioned in the 
intro part to the patch, I only tried to fix the RX SGL handling. If my 
approach is accepted, I volunteer to port the algif_skcipher TX SGL handling 
to algif_aead so that in algif_aead the TX SG entries are freed once they are 
processed. Furthermore, I see that now there is huge code duplication 
regarding the RX/TX SGL handling between algif_skcipher and algif_aead which 
can than be handled with common service functions. But again, such work makes 
only sense if the initial approach discussed above and presented with this 
first patch set is accepted.

Ciao
Stephan
