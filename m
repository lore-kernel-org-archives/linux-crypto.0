From: leroy christophe <christophe.leroy@c-s.fr>
Subject: Re: Question about Talitos Linux driver for MPC885
Date: Mon, 14 Apr 2014 14:01:34 +0200
Message-ID: <534BCE1E.20706@c-s.fr>
References: <50616F1D.108@c-s.fr>	<20120925194730.85456a91d813a7fa35b637f4@freescale.com>	<50AF7F4C.9080704@c-s.fr> <20121127171140.8fcc7a0b49c26248b7bddd5e@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:14271 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864AbaDNMcE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 14 Apr 2014 08:32:04 -0400
In-Reply-To: <20121127171140.8fcc7a0b49c26248b7bddd5e@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Le 28/11/2012 00:11, Kim Phillips a =E9crit :
> On Fri, 23 Nov 2012 14:51:08 +0100
> leroy christophe <christophe.leroy@c-s.fr> wrote:
>
>> Le 26/09/2012 02:47, Kim Phillips a =E9crit :
>>> On Tue, 25 Sep 2012 10:45:17 +0200
>>> leroy christophe <christophe.leroy@c-s.fr> wrote:
>>>
>>>> I'm trying to use the Talitos crypto driver with the MPC885
>>>> microcontroller. For the time being, it doesn't work.
>>> yes, they're not exactly compatible...
>>>
>>>> The kernel startup blocks at the test of the DES function.
>>>>
>>>> I have added the following definition in the DTS file:
>>>>
>>>>            crypto@20000 {
>>>>                compatible =3D "fsl,sec2.0";
>>> interesting, its called "SEC Lite" and its version register does
>>> indeed say 2.  I see it has a single channel FIFO instead of a ring=
,
>>> that the SEC v1.x (MPC185) used, so you probably don't have to
>>> rewrite talitos_submit.
>> Good news, it was also my understanding.
>>>>                reg =3D <0x20000 0x8000>;
>>>>                interrupts =3D <1 1>;
>>> I couldn't find the IRQ line in the MPC855RM - if there's no IRQ
>>> line, then that's a problem.
>> Neither do I on the drawing, however in Table 52-1, there are 3 bits=
 in
>> the CPTR register for defining the interrupt level of the SEC lite, =
just
>> like you do for the CPM and for the FEC.
> not sure how interrupt _level_ is relevant, but I'm going to assume
> you're saying the SEC's IRQ line is integrated into that of the CPM
> and/or FEC.
>
>> So I believe this should be ok ?
> Assuming the above, the 'interrupts' property above should
> equal that of the CPM and/or FEC, and the IRQ_SHARED flag set in
> request_irq (in both talitos and the CPM and/or FEC drivers).  The
> talitos IRQ handler will return IRQ_NONE if none of the channel
> done/error bits are set in the SEC.
Indeed no. It shares the same registrer (CPTR) as the FEC, but has its=20
own bits and its own IRQ line. So it works without having to share the =
IRQ.
>>>>                interrupt-parent =3D <&PIC>;
>>>>                fsl,num-channels =3D <1>;
>>>>                fsl,channel-fifo-len =3D <24>;
>>>>                fsl,exec-units-mask =3D <0x4c>;
>>>>                fsl,descriptor-types-mask =3D <0x301f>;
>>> the descriptor type enumeration isn't uniform across into the mpc8x=
x
>>> SEC version, e.g., the SEC Lite doesn't support the ipsec_esp
>>> descriptor type, represented in mpc8xxx SEC versions as the second
>>> bit, so this descriptor-types-mask setting should be fixed to at
>>> least omit that since the driver checks for, and uses it if
>>> available.
In fact it looks like the enumeration is uniform as far as what I was=20
seen, the different is that on SEC1 it is encoded on 4 bits, while in=20
SEC2 it is encoded on 5 bits, and unfortunately it is the least=20
significant bit that is missing on SEC1.
So by shifting one bit to the left in matches.
>>>
>>>> Is there anything wrong in what I did ? Or is there something else=
 I
>>>> should do ?
>>> might want to go through the defines in talitos.h, e.g,
>>> TALITOS_MCR_SWR is 0x1 on mpc8xxx vs. 0x10000000 on
>>> mpc8xx (I suppose CONFIG_PPC_8xx can be used as the ifdef, btw).
>> I'm surprised about this, I didn't check the talitos.h file, but had
>> checked the Reference Manual of the MPC 8272.
>> I rechecked yesterday and the SWR bit is at the same place as on the
>> MPC885 which is different from what is defined in talitos.h
> right, for some odd reason the h/w designers decided to scramble
> the bitfield definitions.
Right. In the begining in fact I was wrongly thinking the MPC8282 had=20
SEC2 while MPC885 had SEC1, whereas indeed both have SEC1.
Therefore as you suggested I started altering the needed defines inside=
=20
CONFIG_PPC_8xx

I'm now having a driver which starts bubbling, I'm having two issues:
1) One with the interrupt routing of the existing talitos driver. The=20
drivers considers that when ISR_LO is non zero, it is an error, whereas=
=20
according to the reference manuels, on both SEC1 (MPC885) and SEC2=20
(MPC8323), ISR_LO includes ERR and DONE for the EUs. So when the=20
interrupt fires after completion, at least on MPC885, both the Channel=20
and the EUs have their DONE bit set.
It there any reason why a non zero ISR_LO is considered as a fault ?
2) I'm having an issue with the MD5 runtime test at startup. The first=20
test on MD5 seems to the the hashing of a zero length data. It looks=20
like the SEC1 doesn't like this, the kernel remains stuck and nothing=20
happens. Looking at the status registers of the crypto channel, status=20
is 0x10 meaning Processing Data Pairs, and status2 is 0x00280005.
=46irst, is that correct to try and hash an empty data packet ?
Second, is there a way to workaround this issue ?

Herebelow is the content of /dev/crypto (I have faked the MD5 by settin=
g=20
data length to 1 instead of 0, hence the failure)

name         : sha256
driver       : sha256-talitos
module       : kernel
priority     : 3000
refcnt       : 1
selftest     : passed
type         : ahash
async        : yes
blocksize    : 64
digestsize   : 32

name         : sha224
driver       : sha224-talitos
module       : kernel
priority     : 3000
refcnt       : 1
selftest     : passed
type         : ahash
async        : yes
blocksize    : 64
digestsize   : 28

name         : sha1
driver       : sha1-talitos
module       : kernel
priority     : 3000
refcnt       : 1
selftest     : passed
type         : ahash
async        : yes
blocksize    : 64
digestsize   : 20

name         : md5
driver       : md5-talitos
module       : kernel
priority     : 3000
refcnt       : 1
selftest     : unknown
type         : ahash
async        : yes
blocksize    : 64
digestsize   : 16

name         : cbc(des3_ede)
driver       : cbc-3des-talitos
module       : kernel
priority     : 3000
refcnt       : 1
selftest     : passed
type         : ablkcipher
async        : yes
blocksize    : 8
min keysize  : 24
max keysize  : 24
ivsize       : 8
geniv        : eseqiv

name         : cbc(aes)
driver       : cbc-aes-talitos
module       : kernel
priority     : 3000
refcnt       : 1
selftest     : passed
type         : ablkcipher
async        : yes
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : eseqiv

name         : stdrng
driver       : krng
module       : kernel
priority     : 200
refcnt       : 1
selftest     : passed
type         : rng
seedsize     : 0

name         : lzo
driver       : lzo-generic
module       : kernel
priority     : 0
refcnt       : 2
selftest     : passed
type         : compression

name         : aes
driver       : aes-generic
module       : kernel
priority     : 100
refcnt       : 2
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32


Christophe

>
>>> Descriptor header and pointer formats, along with field locations,
>>> sizes, and enumerations may also be different.
>>>
>>> It also appears the SEC Lite doesn't support scatter-gather tables,
>>> which will make performance hurt for fragmented (large) packet size=
s.
>> Does it mean something has to be modified if the SW ?
> yes, s/w will have to allocate a new contiguous memory buffer and
> sg_copy_to_buffer() prior to crypto request submission to the h/w,
> and sg_copy_from_buffer() after h/w completion.
>
> Kim
>
