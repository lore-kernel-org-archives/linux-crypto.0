From: Dan Streetman <ddstreet@ieee.org>
Subject: Re: crypto/nx842: Ignore queue overflow informative error
Date: Mon, 7 Dec 2015 14:39:22 -0500
Message-ID: <CALZtONDkyZ--PZ4VBH3yTiGPhmneo=vUuYLwbTHQ2q-2XRnyNg@mail.gmail.com>
References: <1449388004.2096.12.camel@hbabu-laptop> <87bna36v91.fsf@gamma.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Haren Myneni <haren@linux.vnet.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Michael Ellerman <mpe@ellerman.id.au>, pair@us.ibm.com,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
To: Daniel Axtens <dja@axtens.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87bna36v91.fsf@gamma.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Dec 6, 2015 at 5:57 PM, Daniel Axtens <dja@axtens.net> wrote:
> Haren Myneni <haren@linux.vnet.ibm.com> writes:
>
>> NX842 coprocessor sets bit 3 if queue is overflow. It is just for
>> information to the user. So the driver prints this informative message
>> and ignores it.
>
> What queue, and what happens when the queue overflows? It seems like
> *something* would need to be done, somewhere, by someone?
>
> I realise that as a piece of IBM hardware this is probably an incredibly
> optimistic question, but is this behaviour documented publically anywhere?
> (As a distant second best, is it documented internally anywhere that I
> can read?)

When I worked there, it unfortunately wasn't public and there was no
future plan to make it public, but things might have changed since I
left.  Maybe it will be included in future openpower documentation...?

>
>> --- a/drivers/crypto/nx/nx-842-powernv.c
>> +++ b/drivers/crypto/nx/nx-842-powernv.c
>> @@ -442,6 +442,15 @@ static int nx842_powernv_function(const unsigned char *in, unsigned int inlen,
>>                            (unsigned int)ccw,
>>                            (unsigned int)be32_to_cpu(crb->ccw));
>>
>> +     /*
>> +      * NX842 coprocessor uses 3rd bit to report queue overflow which is
>> +      * not an error, just for information to user. So, ignore this bit.
>> +      */
>> +     if (ret & ICSWX_BIT3) {
>> +             pr_info_ratelimited("842 coprocessor queue overflow\n");
> It doesn't look like this is done anywhere else in the file, but should
> this be prefixed with something? Something like "nx-842: Coprocessor
> queue overflow"?

it defines pr_fmt at the top of the file so it will be prefixed with
the module name.

>
> Regards,
> Daniel
>
>> +             ret &= ~ICSWX_BIT3;
>> +     }
>> +
>>       switch (ret) {
>>       case ICSWX_INITIATED:
>>               ret = wait_for_csb(wmem, csb);
>>
>>
>> _______________________________________________
>> Linuxppc-dev mailing list
>> Linuxppc-dev@lists.ozlabs.org
>> https://lists.ozlabs.org/listinfo/linuxppc-dev
