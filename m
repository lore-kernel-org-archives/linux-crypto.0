From: Stephan Mueller <smueller@chronox.de>
Subject: Re: Decrypting data in RX path
Date: Wed, 18 May 2016 12:57:45 +0200
Message-ID: <3754929.90x4KOdgRn@positron.chronox.de>
References: <CAKJ7aR5v5LmgZ5XAv8+9mAtksdSu=LJz=oK9AmHO2t4bDiqSzw@mail.gmail.com> <CAKJ7aR5gJ=ebBgYPq6=eUQoVLi8xXz9EsRnRqWvh2_EG6s7p1g@mail.gmail.com> <DB5PR04MB13021E5E7CAF57D1188D65AEEE490@DB5PR04MB1302.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Gadre Nayan <gadrenayan@gmail.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Catalin Vasile <cata.vasile@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:39620 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795AbcERK5o (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 May 2016 06:57:44 -0400
In-Reply-To: <DB5PR04MB13021E5E7CAF57D1188D65AEEE490@DB5PR04MB1302.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 18. Mai 2016, 07:01:18 schrieb Catalin Vasile:

Hi Catalin,

> Inline Comments
> ________________________________________
> From: linux-crypto-owner@vger.kernel.org
> <linux-crypto-owner@vger.kernel.org> on behalf of Gadre Nayan
> <gadrenayan@gmail.com> Sent: Monday, May 16, 2016 5:40 PM
> To: Stephan Mueller; linux-crypto@vger.kernel.org
> Subject: Re: Decrypting data in RX path
> 
> Hi,
> 
> 1. The context of the question "best place to decrypt in
> kernel(module/driver)" is I want to encrypt network packets sent from
> my system and decrypt them back to work with crypto apis. So the
> encryption part I have done in  a Kernel thread, decryption part could
> be either in driver or a pre-routing hook. Which is appropriate.
> 
> 2. I went through the esp_input function for rx.
> 
> As I understand, It allocates a decrypt request and and calls
> crypto_aead_decrypt(req).
> 
> A. Since this request is asynchronous, it would be handled through
> condition variables, Am i right on this?

I am not sure I understand your term "condition variables". The async handling 
is implemented by invoking the callback esp_input_done once the cipher 
operation completes.

So, esp_input invokes the cipher operation. The invocation will return 
immediately. Once the operation completes, the callback is triggered where the 
callback must perform the appropriate post-operation handling.

See the kernel crypto API documentation for async handling.

> B. Also the IPSEC routines like input and output would run in softirq
> context ?

I am not sure about whether it runs in softirq, but at least it is not in 
process context.

> C. esp_input_done() is a callback for decrypt, so as soon as
> crypto_aead_decrypt(req) is called and the encryption does not happen
> immediately, it will return the error _EINPROGRESS. Now this will
> cause the esp_input function to return immediately. So then when is
> the deferred decryption checked. I see esp_input_done2 as well. How is
> the flow and call of these callbacks happening.

Please read the kernel crypto API documentation at [1]

[1] http://www.chronox.de/crypto-API/index.html
> 
> [Catalin Vasile]
> "aead_request_set_callback(req, 0, esp_output_done_esn, skb);"
> This piece of code sets into the request structure a callback.
> After the job is queued, you will receive an -EINPROGRESS and your current
> context will just return till it ends the current context (having nothing
> other to do). Later, the device will trigger an interrupt in the Kernel to
> announce it that a job has been done. The interrupt usually starts a
> kthread or a softirq which will process what jobs have ended. One of the
> processing part thingies is triggering the callback you have set. Although
> the context that sent the job no longer exist, the hardware driver uses its
> own contexts to run some custom you have sent (that code is represented by
> your callback).
> 
> Apologize for being so verbose.
> 
> Thanks.
> 
> On Mon, May 16, 2016 at 6:02 PM, Stephan Mueller <smueller@chronox.de> 
wrote:
> > Am Montag, 16. Mai 2016, 17:24:12 schrieb Gadre Nayan:
> > 
> > Hi Gadre,
> > 
> >> Hi,
> >> 
> >> I am able to encrypt data using the asynchronous kernel crypto API's.
> >> I can observe the encrypted data on the protocol analyzer.
> >> 
> >> I wanted to decry-pt the data now on the receiver side, So I have
> >> following questions.
> >> 
> >> 1. What is the best place to decrypt the data, in kernel space (module
> >> (pre-routing hook) or driver) OR user space using (maybe using raw
> >> sockets or after socket recv).
> > 
> > This is a very broad question and cannot be answered without knowning the
> > context.
> > 
> >> What precautions should be taken in terms of locking while using
> >> crypto api's in kernel space in RX path (Softirq context) --> Can
> >> someone point to existing sample in kernel where decryption is done in
> >> RX path.
> > 
> > net/ipv4/esp4.c:esp_input for rx and esp_output for tx.
> > 
> >> 2. If I encrypt data in kernel space can I decrypt it in User-space
> >> using same encryption methods and Keys.
> > 
> > Sure, if you have the keys and all information about the used crypto.
> > 
> >> Thanks.
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-crypto"
> >> in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > Ciao
> > Stephan
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Ciao
Stephan
